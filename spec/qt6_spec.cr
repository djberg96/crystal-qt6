require "./spec_helper"

private class EditorVerticalSliceSpecState
  property active_layer : String
  property zoom : Float64
  property pan_x : Float64
  property pan_y : Float64
  property dragging : Bool
  property last_pointer : Qt6::PointF
  property accent : Qt6::Color

  def initialize
    @active_layer = "Terrain"
    @zoom = 1.0
    @pan_x = 24.0
    @pan_y = 28.0
    @dragging = false
    @last_pointer = Qt6::PointF.new(0.0, 0.0)
    @accent = Qt6::Color.new(62, 130, 109)
  end
end

private class EditableLayerListModel < Qt6::AbstractListModel
  getter layers

  def initialize(layers : Array(String), parent : Qt6::QObject? = nil)
    @layers = layers
    super(parent)
  end

  def append_layer(name : String) : String
    position = @layers.size
    begin_insert_rows(position, position)
    @layers << name
    end_insert_rows
    name
  end

  def remove_layer(row : Int) : String
    begin_remove_rows(row, row)
    removed = @layers.delete_at(row)
    end_remove_rows
    removed
  end

  def replace_layers(layers : Array(String)) : Array(String)
    begin_reset_model
    @layers = layers
    end_reset_model
    layers
  end

  protected def model_row_count : Int32
    @layers.size.to_i32
  end

  protected def model_data(index : Qt6::ModelIndex, role : Int32) : Qt6::ModelData
    return nil unless index.valid?

    case role
    when Qt6::ItemDataRole::Display.value, Qt6::ItemDataRole::Edit.value
      @layers[index.row]?
    when Qt6::ItemDataRole::User.value
      index.row
    else
      nil
    end
  end

  protected def model_set_data(index : Qt6::ModelIndex, value : Qt6::ModelData, role : Int32) : Bool
    return false unless index.valid? && role == Qt6::ItemDataRole::Edit.value

    @layers[index.row] = value.to_s
    data_changed(index)
    true
  end

  protected def model_header_data(section : Int32, orientation : Qt6::Orientation, role : Int32) : Qt6::ModelData
    return nil unless section == 0 && orientation == Qt6::Orientation::Horizontal && role == Qt6::ItemDataRole::Display.value

    "Layer"
  end

  protected def model_flags(index : Qt6::ModelIndex) : Qt6::ItemFlag
    return Qt6::ItemFlag::None unless index.valid?

    Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable
  end
end

private class DraggableLayerListModel < Qt6::AbstractListModel
  MIME_TYPE = "application/x-crystal-qt6-layer"

  getter layers

  def initialize(layers : Array(String), parent : Qt6::QObject? = nil)
    @layers = layers
    super(parent)
  end

  protected def model_row_count : Int32
    @layers.size.to_i32
  end

  protected def model_data(index : Qt6::ModelIndex, role : Int32) : Qt6::ModelData
    return nil unless index.valid?

    case role
    when Qt6::ItemDataRole::Display.value, Qt6::ItemDataRole::Edit.value
      @layers[index.row]?
    else
      nil
    end
  end

  protected def model_flags(index : Qt6::ModelIndex) : Qt6::ItemFlag
    return Qt6::ItemFlag::None unless index.valid?

    Qt6::ItemFlag::Enabled |
      Qt6::ItemFlag::Selectable |
      Qt6::ItemFlag::Editable |
      Qt6::ItemFlag::DragEnabled |
      Qt6::ItemFlag::DropEnabled
  end

  protected def model_mime_types : Array(String)
    [MIME_TYPE, "text/plain"]
  end

  protected def model_mime_data(indexes : Array(Qt6::ModelIndex)) : Qt6::MimeData?
    names = indexes.compact_map { |index| @layers[index.row]? }.uniq
    return nil if names.empty?

    mime_data = Qt6::MimeData.new
    payload = names.join("\n")
    mime_data.text = payload
    mime_data.set_data(MIME_TYPE, payload)
    mime_data
  end

  protected def model_drop_mime_data(mime_data : Qt6::MimeData, action : Qt6::DropAction, row : Int32, column : Int32, parent : Qt6::ModelIndex) : Bool
    return false unless action.includes?(Qt6::DropAction::MoveAction) || action.includes?(Qt6::DropAction::CopyAction)
    return false unless mime_data.has_format?(MIME_TYPE)

    names = String.new(mime_data.data(MIME_TYPE)).split('\n').reject(&.empty?)
    return false if names.empty?

    destination = if row >= 0
                    row
                  elsif parent.valid?
                    parent.row
                  else
                    @layers.size
                  end

    if action.includes?(Qt6::DropAction::MoveAction) && names.size == 1
      source_index = @layers.index(names.first)
      return move_layer(source_index.to_i32, destination) if source_index
    end

    if action.includes?(Qt6::DropAction::MoveAction)
      moved_names = names.select { |name| @layers.includes?(name) }
      return false if moved_names.empty?

      moved_names.each do |name|
        source_index = @layers.index(name)
        next unless source_index

        begin_remove_rows(source_index, source_index)
        @layers.delete_at(source_index)
        end_remove_rows
        destination -= 1 if source_index < destination
      end
    end

    names.each_with_index do |name, offset|
      insert_at = Math.min(destination + offset, @layers.size)
      begin_insert_rows(insert_at, insert_at)
      @layers.insert(insert_at, name)
      end_insert_rows
    end

    true
  end

  protected def model_supported_drag_actions : Qt6::DropAction
    Qt6::DropAction::CopyAction | Qt6::DropAction::MoveAction
  end

  protected def model_supported_drop_actions : Qt6::DropAction
    Qt6::DropAction::CopyAction | Qt6::DropAction::MoveAction
  end

  private def move_layer(source_index : Int32, destination_child : Int32) : Bool
    bounded_destination = destination_child.clamp(0, @layers.size)
    return true if bounded_destination == source_index || bounded_destination == source_index + 1
    return false unless source_index >= 0 && source_index < @layers.size
    return false unless begin_move_rows(source_index, source_index, bounded_destination)

    layer = @layers.delete_at(source_index)
    insert_at = bounded_destination
    insert_at -= 1 if source_index < bounded_destination
    @layers.insert(insert_at, layer)
    end_move_rows
    true
  end
end

private class LayerTreeModel < Qt6::AbstractTreeModel
  private record Node, id : UInt64, label : String, parent_id : UInt64?, children : Array(UInt64)

  def initialize(parent : Qt6::QObject? = nil)
    @nodes = {} of UInt64 => Node
    @roots = [] of UInt64

    @nodes[1_u64] = Node.new(1_u64, "Terrain", nil, [2_u64, 3_u64])
    @nodes[2_u64] = Node.new(2_u64, "Contours", 1_u64, [] of UInt64)
    @nodes[3_u64] = Node.new(3_u64, "Labels", 1_u64, [] of UInt64)
    @nodes[4_u64] = Node.new(4_u64, "Units", nil, [5_u64])
    @nodes[5_u64] = Node.new(5_u64, "Infantry", 4_u64, [] of UInt64)
    @roots = [1_u64, 4_u64]
    super(parent)
  end

  protected def model_row_count(parent : Qt6::ModelIndex) : Int32
    child_ids_for(parent).size.to_i32
  end

  protected def model_column_count(parent : Qt6::ModelIndex) : Int32
    1
  end

  protected def model_index_internal_id(row : Int32, column : Int32, parent : Qt6::ModelIndex) : UInt64?
    return nil unless column == 0

    child_ids_for(parent)[row]?
  end

  protected def model_parent(index : Qt6::ModelIndex) : Qt6::ModelIndexSpec?
    return nil unless index.valid?

    node = @nodes[index.internal_id]?
    parent_id = node.try(&.parent_id)
    return nil unless node && parent_id

    parent_node = @nodes[parent_id]?
    return nil unless parent_node

    siblings = parent_node.parent_id ? @nodes[parent_node.parent_id].not_nil!.children : @roots
    row = siblings.index(parent_id)
    return nil unless row

    Qt6::ModelIndexSpec.new(row.to_i32, 0, parent_id)
  end

  protected def model_data(index : Qt6::ModelIndex, role : Int32) : Qt6::ModelData
    return nil unless index.valid?
    return nil unless role == Qt6::ItemDataRole::Display.value || role == Qt6::ItemDataRole::Edit.value

    @nodes[index.internal_id]?.try(&.label)
  end

  protected def model_set_data(index : Qt6::ModelIndex, value : Qt6::ModelData, role : Int32) : Bool
    return false unless index.valid? && role == Qt6::ItemDataRole::Edit.value

    node = @nodes[index.internal_id]?
    return false unless node

    @nodes[index.internal_id] = Node.new(node.id, value.to_s, node.parent_id, node.children)
    data_changed(index)
    true
  end

  protected def model_header_data(section : Int32, orientation : Qt6::Orientation, role : Int32) : Qt6::ModelData
    return nil unless section == 0 && orientation == Qt6::Orientation::Horizontal && role == Qt6::ItemDataRole::Display.value

    "Layer"
  end

  protected def model_flags(index : Qt6::ModelIndex) : Qt6::ItemFlag
    return Qt6::ItemFlag::None unless index.valid?

    Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable
  end

  private def child_ids_for(parent : Qt6::ModelIndex) : Array(UInt64)
    return @roots unless parent.valid?

    @nodes[parent.internal_id]?.try(&.children) || ([] of UInt64)
  end
end

private class MutableTreeNode
  property label : String
  property parent_id : UInt64?
  getter children : Array(UInt64)

  def initialize(@label : String, @parent_id : UInt64?, @children : Array(UInt64) = [] of UInt64)
  end
end

private class MutableLayerTreeModel < Qt6::AbstractTreeModel
  def initialize(parent : Qt6::QObject? = nil)
    @nodes = {} of UInt64 => MutableTreeNode
    @roots = [] of UInt64
    @next_id = 1_u64

    terrain_id = create_node("Terrain")
    contours_id = create_node("Contours", terrain_id)
    labels_id = create_node("Labels", terrain_id)
    units_id = create_node("Units")

    @roots << terrain_id << units_id
    @nodes[terrain_id].children.concat([contours_id, labels_id])

    super(parent)
  end

  def append_child(label : String, parent : Qt6::ModelIndex? = nil) : UInt64
    target_parent = valid_parent(parent)
    siblings = child_ids_for(target_parent)
    row = siblings.size

    begin_insert_rows(row, row, target_parent)
    id = create_node(label, target_parent.try(&.internal_id))
    siblings << id
    end_insert_rows
    id
  end

  def remove_child(row : Int, parent : Qt6::ModelIndex? = nil) : String?
    target_parent = valid_parent(parent)
    siblings = child_ids_for(target_parent)
    node_id = siblings[row]?
    return nil unless node_id

    removed_label = @nodes[node_id].label
    begin_remove_rows(row, row, target_parent)
    siblings.delete_at(row)
    delete_subtree(node_id)
    end_remove_rows
    removed_label
  end

  def move_child(row : Int, destination_child : Int, parent : Qt6::ModelIndex? = nil) : Bool
    target_parent = valid_parent(parent)
    siblings = child_ids_for(target_parent)
    return false unless row >= 0 && row < siblings.size

    bounded_destination = destination_child.clamp(0, siblings.size)
    return true if bounded_destination == row || bounded_destination == row + 1
    return false unless begin_move_rows(row, row, bounded_destination, target_parent, target_parent)

    moved_id = siblings.delete_at(row)
    insert_at = bounded_destination
    insert_at -= 1 if row < bounded_destination
    siblings.insert(insert_at, moved_id)
    end_move_rows
    true
  end

  protected def model_row_count(parent : Qt6::ModelIndex) : Int32
    child_ids_for(parent).size.to_i32
  end

  protected def model_column_count(parent : Qt6::ModelIndex) : Int32
    1
  end

  protected def model_index_internal_id(row : Int32, column : Int32, parent : Qt6::ModelIndex) : UInt64?
    return nil unless column == 0

    child_ids_for(parent)[row]?
  end

  protected def model_parent(index : Qt6::ModelIndex) : Qt6::ModelIndexSpec?
    return nil unless index.valid?

    node = @nodes[index.internal_id]?
    parent_id = node.try(&.parent_id)
    return nil unless node && parent_id

    parent_node = @nodes[parent_id]?
    return nil unless parent_node

    siblings = parent_node.parent_id ? @nodes[parent_node.parent_id].not_nil!.children : @roots
    row = siblings.index(parent_id)
    return nil unless row

    Qt6::ModelIndexSpec.new(row.to_i32, 0, parent_id)
  end

  protected def model_data(index : Qt6::ModelIndex, role : Int32) : Qt6::ModelData
    return nil unless index.valid?
    return nil unless role == Qt6::ItemDataRole::Display.value || role == Qt6::ItemDataRole::Edit.value

    @nodes[index.internal_id]?.try(&.label)
  end

  protected def model_set_data(index : Qt6::ModelIndex, value : Qt6::ModelData, role : Int32) : Bool
    return false unless index.valid? && role == Qt6::ItemDataRole::Edit.value

    node = @nodes[index.internal_id]?
    return false unless node

    node.label = value.to_s
    data_changed(index)
    true
  end

  protected def model_header_data(section : Int32, orientation : Qt6::Orientation, role : Int32) : Qt6::ModelData
    return nil unless section == 0 && orientation == Qt6::Orientation::Horizontal && role == Qt6::ItemDataRole::Display.value

    "Layer"
  end

  protected def model_flags(index : Qt6::ModelIndex) : Qt6::ItemFlag
    return Qt6::ItemFlag::None unless index.valid?

    Qt6::ItemFlag::Enabled |
      Qt6::ItemFlag::Selectable |
      Qt6::ItemFlag::Editable |
      Qt6::ItemFlag::DragEnabled |
      Qt6::ItemFlag::DropEnabled
  end

  private def create_node(label : String, parent_id : UInt64? = nil) : UInt64
    id = @next_id
    @next_id += 1
    @nodes[id] = MutableTreeNode.new(label, parent_id)
    id
  end

  private def delete_subtree(id : UInt64) : Nil
    node = @nodes[id]?
    return unless node

    node.children.each { |child_id| delete_subtree(child_id) }
    @nodes.delete(id)
  end

  private def valid_parent(parent : Qt6::ModelIndex?) : Qt6::ModelIndex?
    return nil unless parent
    parent.valid? ? parent : nil
  end

  private def child_ids_for(parent : Qt6::ModelIndex?) : Array(UInt64)
    return @roots unless parent
    return @roots unless parent.valid?

    @nodes[parent.internal_id]?.try(&.children) || ([] of UInt64)
  end
end

describe Qt6 do
  it "renders into images and pixmaps with paths and transforms" do
    app
    image = Qt6::QImage.new(32, 32)
    image.fill(Qt6::Color.new(255, 255, 255))
    image.set_pixel_color(0, 0, Qt6::Color.new(1, 2, 3, 255))

    pen = Qt6::QPen.new(Qt6::Color.new(255, 0, 0), 3)
    brush = Qt6::QBrush.new(Qt6::Color.new(255, 0, 0))
    font = Qt6::QFont.new(point_size: 14, bold: true, italic: true)
    metrics = font.metrics
    metrics_f = font.metrics_f

    transform = Qt6::QTransform.new
    transform.translate(4, 5)

    path = Qt6::QPainterPath.new
    path.add_rect(Qt6::RectF.new(0.0, 0.0, 8.0, 8.0))
    moved_path = path.transformed(transform)
    translated_path = path.translated(10, 12)
    simplified_path = path.simplified

    curve_path = Qt6::QPainterPath.new
    curve_path.empty?.should be_true
    curve_path.move_to(Qt6::PointF.new(1.0, 2.0))
    curve_path.line_to(Qt6::PointF.new(5.0, 2.0))
    curve_path.quad_to(Qt6::PointF.new(8.0, 8.0), Qt6::PointF.new(10.0, 2.0))

    curve_path.empty?.should be_false
    curve_path.current_position.should eq(Qt6::PointF.new(10.0, 2.0))
    curve_path.element_count.should eq(5)
    curve_path[0].type.should eq(Qt6::PainterPathElementType::MoveTo)
    curve_path[0].point.should eq(Qt6::PointF.new(1.0, 2.0))
    curve_path[1].type.should eq(Qt6::PainterPathElementType::LineTo)
    curve_path[2].type.should eq(Qt6::PainterPathElementType::CurveTo)
    curve_path[3].type.should eq(Qt6::PainterPathElementType::CurveToData)
    curve_path[4].type.should eq(Qt6::PainterPathElementType::CurveToData)
    curve_path.control_point_rect.height.should be > curve_path.bounding_rect.height

    path.contains(Qt6::PointF.new(2.0, 2.0)).should be_true
    path.contains(Qt6::RectF.new(1.0, 1.0, 2.0, 2.0)).should be_true
    path.intersects?(Qt6::RectF.new(7.0, 7.0, 4.0, 4.0)).should be_true
    path.intersects?(Qt6::RectF.new(20.0, 20.0, 4.0, 4.0)).should be_false
    moved_path.bounding_rect.x.should eq(4.0)
    moved_path.bounding_rect.y.should eq(5.0)
    translated_path.bounding_rect.x.should eq(10.0)
    translated_path.bounding_rect.y.should eq(12.0)
    simplified_path.empty?.should be_false

    overlay_path = Qt6::QPainterPath.new
    overlay_path.add_rect(Qt6::RectF.new(10.0, 0.0, 4.0, 4.0))
    path.add_path(overlay_path)
    path.contains(Qt6::PointF.new(12.0, 2.0)).should be_true
    path.connect_path(curve_path)
    path.current_position.should eq(curve_path.current_position)

    disposable_path = Qt6::QPainterPath.new
    disposable_path.add_ellipse(Qt6::RectF.new(0.0, 0.0, 6.0, 6.0))
    disposable_path.empty?.should be_false
    disposable_path.clear
    disposable_path.empty?.should be_true

    Qt6::QPainter.paint(image) do |painter|
      painter.active?.should be_true
      painter.antialiasing = false
      painter.pen = pen
      painter.brush = brush
      painter.font = font
      painter.draw_path(moved_path)
      painter.fill_rect(Qt6::RectF.new(20.0, 20.0, 4.0, 4.0), Qt6::Color.new(0, 0, 255))
      painter.draw_line(Qt6::PointF.new(0.0, 31.0), Qt6::PointF.new(31.0, 31.0))
      painter.draw_text(Qt6::PointF.new(1.0, 16.0), "qt6")
    end

    pixmap = Qt6::QPixmap.from_image(image)
    pixmap_canvas = Qt6::QPixmap.new(40, 40)
    pixmap_canvas.fill(Qt6::Color.new(0, 0, 0, 0))
    svg_path = File.join(Dir.tempdir, "crystal-qt6-render-scene-#{Process.pid}.svg")
    svg = Qt6::QSvgGenerator.new(svg_path, 40, 40, title: "Render Scene", description: "Generated by crystal-qt6 specs")
    svg.resolution = 96
    pdf_path = File.join(Dir.tempdir, "crystal-qt6-render-scene-#{Process.pid}.pdf")
    pdf = Qt6::QPdfWriter.new(pdf_path, title: "Render Scene PDF", creator: "crystal-qt6 specs")
    pdf.page_size_points = Qt6::Size.new(120, 120)
    pdf.resolution = 144

    Qt6::QPainter.paint(pixmap_canvas) do |painter|
      painter.draw_image(Qt6::PointF.new(2.0, 2.0), image)
      painter.draw_pixmap(Qt6::PointF.new(0.0, 0.0), pixmap)
    end

    Qt6::QPainter.paint(svg) do |painter|
      painter.antialiasing = false
      painter.pen = pen
      painter.brush = brush
      painter.font = font
      painter.draw_path(moved_path)
      painter.fill_rect(Qt6::RectF.new(20.0, 20.0, 4.0, 4.0), Qt6::Color.new(0, 0, 255))
      painter.draw_text(Qt6::PointF.new(1.0, 16.0), "qt6-svg")
    end

    Qt6::QPainter.paint(pdf) do |painter|
      painter.antialiasing = false
      painter.pen = pen
      painter.brush = brush
      painter.font = font
      painter.draw_path(moved_path)
      painter.fill_rect(Qt6::RectF.new(20.0, 20.0, 4.0, 4.0), Qt6::Color.new(0, 0, 255))
      painter.draw_text(Qt6::PointF.new(1.0, 16.0), "qt6-pdf")
      pdf.new_page.should be_true
      painter.reset_transform
      painter.draw_line(Qt6::PointF.new(0.0, 0.0), Qt6::PointF.new(30.0, 30.0))
    end

    svg_file_name = svg.file_name
    svg_size = svg.size
    svg_view_box = svg.view_box
    svg_title = svg.title
    svg_description = svg.description
    svg_resolution = svg.resolution
    pdf_file_name = pdf.file_name
    pdf_title = pdf.title
    pdf_creator = pdf.creator
    pdf_resolution = pdf.resolution

    svg_markup = begin
      svg.release
      File.read(svg_path)
    end

    svg_renderer = Qt6::QSvgRenderer.new(svg_path)
    svg_renderer.valid?.should be_true

    svg_canvas = Qt6::QImage.new(40, 40)
    svg_canvas.fill(Qt6::Color.new(255, 255, 255))
    Qt6::QPainter.paint(svg_canvas) do |painter|
      svg_renderer.render(painter, Qt6::RectF.new(0.0, 0.0, 40.0, 40.0))
    end

    svg_default_size = svg_renderer.default_size
    svg_render_view_box = svg_renderer.view_box

    pdf_header = begin
      pdf.release
      File.open(pdf_path) do |file|
        bytes = Bytes.new(5)
        file.read_fully(bytes)
        String.new(bytes)
      end
    end

    pixmap_image = pixmap_canvas.to_image
    image_path = File.join(Dir.tempdir, "crystal-qt6-render-image-#{Process.pid}.png")
    pixmap_path = File.join(Dir.tempdir, "crystal-qt6-render-pixmap-#{Process.pid}.png")
    text_bounds = metrics.bounding_rect("qt6")
    text_bounds_f = metrics_f.bounding_rect("qt6")

    pen.width.should eq(3.0)
    pen.color.should eq(Qt6::Color.new(255, 0, 0, 255))
    brush.color.should eq(Qt6::Color.new(255, 0, 0, 255))
    font.point_size.should eq(14)
    font.bold?.should be_true
    font.italic?.should be_true
    metrics.height.should be > 0
    metrics.ascent.should be > 0
    metrics.descent.should be >= 0
    metrics.horizontal_advance("qt6").should be > 0
    text_bounds.width.should be > 0.0
    text_bounds.height.should be > 0.0
    metrics_f.height.should be > 0.0
    metrics_f.ascent.should be > 0.0
    metrics_f.descent.should be >= 0.0
    metrics_f.horizontal_advance("qt6").should be > 0.0
    text_bounds_f.width.should be > 0.0
    text_bounds_f.height.should be > 0.0
    transform.map(Qt6::PointF.new(1.0, 1.0)).should eq(Qt6::PointF.new(5.0, 6.0))
    transform.map(Qt6::RectF.new(0.0, 0.0, 8.0, 8.0)).should eq(Qt6::RectF.new(4.0, 5.0, 8.0, 8.0))
    moved_path.bounding_rect.should eq(Qt6::RectF.new(4.0, 5.0, 8.0, 8.0))
    image.pixel_color(0, 0).should eq(Qt6::Color.new(1, 2, 3, 255))
    image.pixel_color(6, 7).should eq(Qt6::Color.new(255, 0, 0, 255))
    image.pixel_color(21, 21).should eq(Qt6::Color.new(0, 0, 255, 255))
    pixmap.width.should eq(32)
    pixmap.height.should eq(32)
    pixmap.null?.should be_false
    svg_file_name.should eq(svg_path)
    svg_size.should eq(Qt6::Size.new(40, 40))
    svg_view_box.should eq(Qt6::RectF.new(0.0, 0.0, 40.0, 40.0))
    svg_default_size.width.should be > 0
    svg_default_size.height.should be > 0
    svg_render_view_box.should eq(Qt6::RectF.new(0.0, 0.0, 40.0, 40.0))
    svg_title.should eq("Render Scene")
    svg_description.should eq("Generated by crystal-qt6 specs")
    svg_resolution.should eq(96)
    pdf_file_name.should eq(pdf_path)
    pdf_title.should eq("Render Scene PDF")
    pdf_creator.should eq("crystal-qt6 specs")
    pdf_resolution.should eq(144)
    pixmap_image.pixel_color(1, 1).should eq(Qt6::Color.new(255, 255, 255, 255))
    pixmap_image.pixel_color(6, 7).should eq(Qt6::Color.new(255, 0, 0, 255))
    image.save(image_path).should be_true
    pixmap.save(pixmap_path).should be_true
    File.exists?(image_path).should be_true
    File.exists?(pixmap_path).should be_true
    File.exists?(svg_path).should be_true
    File.exists?(pdf_path).should be_true
    svg_markup.includes?("<svg").should be_true
    svg_markup.includes?("<title>Render Scene</title>").should be_true
    svg_markup.includes?("Generated by crystal-qt6 specs").should be_true
    pdf_header.should eq("%PDF-")
    svg_canvas.pixel_color(6, 7).should eq(Qt6::Color.new(255, 0, 0, 255))
    svg_canvas.pixel_color(21, 21).should eq(Qt6::Color.new(0, 0, 255, 255))
  end

  it "supports richer painter state, polygons, strokers, and textured brushes" do
    app

    polygon = Qt6::QPolygonF.new([
      Qt6::PointF.new(0.0, 0.0),
      Qt6::PointF.new(4.0, 0.0),
      Qt6::PointF.new(4.0, 4.0),
      Qt6::PointF.new(0.0, 4.0),
    ])
    polygon << Qt6::PointF.new(0.0, 0.0)

    path = Qt6::QPainterPath.new
    path.add_polygon(polygon)

    map_transform = Qt6::QTransform.new
    map_transform.translate(6, 0)
    moved_path = map_transform.map(path)

    stroker = Qt6::QPainterPathStroker.new
    stroker.width = 2.0
    stroked_path = stroker.create_stroke(path)

    pen = Qt6::QPen.new(Qt6::Color.new(0, 0, 0), 1)
    pen.style = Qt6::PenStyle::NoPen
    pen.cap_style = Qt6::PenCapStyle::RoundCap

    texture = Qt6::QPixmap.new(1, 1)
    texture.fill(Qt6::Color.new(220, 40, 40))
    textured_brush = Qt6::QBrush.new(texture)
    brush_transform = Qt6::QTransform.new
    brush_transform.translate(1, 0)
    textured_brush.transform = brush_transform

    source = Qt6::QImage.new(2, 2)
    source.fill(Qt6::Color.new(30, 60, 220))
    source_pixmap = Qt6::QPixmap.from_image(source)

    canvas = Qt6::QImage.new(12, 12)
    canvas.fill(Qt6::Color.new(0, 0, 0, 0))

    Qt6::QPainter.paint(canvas) do |painter|
      painter.smooth_pixmap_transform = true
      painter.pen = pen
      painter.brush = textured_brush
      painter.draw_polygon(polygon)

      painter.save
      painter.clip_path = moved_path
      painter.fill_rect(Qt6::RectF.new(0.0, 0.0, 12.0, 12.0), Qt6::Color.new(40, 220, 80))
      painter.restore

      painter.save
      painter.translate(8, 8)
      painter.opacity = 0.5
      painter.draw_image(0, 0, source)
      painter.restore

      painter.draw_pixmap(0, 8, source_pixmap)
      painter.composition_mode = Qt6::PainterCompositionMode::Clear
      painter.fill_rect(Qt6::RectF.new(8.0, 8.0, 1.0, 1.0), Qt6::Color.new(255, 255, 255))
      painter.composition_mode.should eq(Qt6::PainterCompositionMode::Clear)
      painter.composition_mode = Qt6::PainterCompositionMode::SourceOver
      painter.brush = Qt6::Color.new(70, 170, 240)
      painter.draw_ellipse(Qt6::PointF.new(10.0, 2.0), 1.0, 1.0)
    end

    polygon.size.should eq(5)
    polygon[2].should eq(Qt6::PointF.new(4.0, 4.0))
    polygon.bounding_rect.should eq(Qt6::RectF.new(0.0, 0.0, 4.0, 4.0))
    path.empty?.should be_false
    path.contains(Qt6::PointF.new(2.0, 2.0)).should be_true
    path.contains(Qt6::PointF.new(5.5, 2.0)).should be_false
    moved_path.bounding_rect.should eq(Qt6::RectF.new(6.0, 0.0, 4.0, 4.0))
    stroked_path.contains(Qt6::PointF.new(0.2, 2.0)).should be_true
    pen.style.should eq(Qt6::PenStyle::NoPen)
    pen.cap_style.should eq(Qt6::PenCapStyle::RoundCap)
    textured_brush.transform.map(Qt6::PointF.new(1.0, 1.0)).should eq(Qt6::PointF.new(2.0, 1.0))

    canvas.pixel_color(2, 2).should eq(Qt6::Color.new(220, 40, 40, 255))
    canvas.pixel_color(7, 2).should eq(Qt6::Color.new(40, 220, 80, 255))
    canvas.pixel_color(5, 2).should eq(Qt6::Color.new(0, 0, 0, 0))
    canvas.pixel_color(8, 8).should eq(Qt6::Color.new(0, 0, 0, 0))
    faded = canvas.pixel_color(9, 9)
    faded.red.should eq(30)
    faded.green.should eq(60)
    faded.blue.should eq(220)
    faded.alpha.should eq(127)
    canvas.pixel_color(0, 8).should eq(Qt6::Color.new(30, 60, 220, 255))
    canvas.pixel_color(10, 2).should eq(Qt6::Color.new(70, 170, 240, 255))

    deep_source = Qt6::QImage.new(4, 4)
    deep_source.fill(Qt6::Color.new(0, 0, 0, 0))
    deep_source.set_pixel_color(2, 2, Qt6::Color.new(240, 30, 30))
    deep_pixmap = Qt6::QPixmap.from_image(deep_source)
    deep_canvas = Qt6::QImage.new(12, 12)
    deep_canvas.fill(Qt6::Color.new(0, 0, 0, 0))

    painter = Qt6::QPainter.new(deep_canvas)
    painter.active?.should be_true
    painter.antialiasing = false
    painter.draw_image(
      Qt6::RectF.new(0.0, 0.0, 4.0, 4.0),
      deep_source,
      Qt6::RectF.new(2.0, 2.0, 1.0, 1.0)
    )
    painter.draw_pixmap(
      Qt6::RectF.new(4.0, 0.0, 4.0, 4.0),
      deep_pixmap,
      Qt6::RectF.new(2.0, 2.0, 1.0, 1.0)
    )
    painter.clip_rect = Qt6::RectF.new(0.0, 4.0, 2.0, 2.0)
    painter.fill_rect(Qt6::RectF.new(0.0, 4.0, 4.0, 4.0), Qt6::QBrush.new(Qt6::Color.new(30, 220, 90)))
    painter.clipping = false
    painter.save
    painter.translate(12, 12)
    painter.rotate(180)
    painter.fill_rect(Qt6::RectF.new(0.0, 0.0, 2.0, 2.0), Qt6::Color.new(80, 40, 220))
    painter.restore
    painter.draw_point(Qt6::PointF.new(8.0, 8.0))
    painter.end.should be_true
    painter.active?.should be_false
    painter.release

    deep_canvas.pixel_color(0, 0).should eq(Qt6::Color.new(240, 30, 30, 255))
    deep_canvas.pixel_color(4, 0).should eq(Qt6::Color.new(240, 30, 30, 255))
    deep_canvas.pixel_color(1, 5).should eq(Qt6::Color.new(30, 220, 90, 255))
    deep_canvas.pixel_color(3, 5).should eq(Qt6::Color.new(0, 0, 0, 0))
    deep_canvas.pixel_color(10, 10).should eq(Qt6::Color.new(80, 40, 220, 255))
    deep_canvas.pixel_color(8, 8).should eq(Qt6::Color.new(0, 0, 0, 255))
  end

  it "supports gradients and advanced pen styling" do
    app

    gradient_canvas = Qt6::QImage.new(12, 12)
    gradient_canvas.fill(Qt6::Color.new(0, 0, 0, 0))

    linear = Qt6::QLinearGradient.new(0.0, 0.0, 10.0, 0.0)
    linear.set_color_at(0.0, Qt6::Color.new(255, 0, 0))
    linear.set_color_at(1.0, Qt6::Color.new(0, 0, 255))
    linear.start.should eq(Qt6::PointF.new(0.0, 0.0))
    linear.final_stop.should eq(Qt6::PointF.new(10.0, 0.0))

    radial = Qt6::QRadialGradient.new(Qt6::PointF.new(6.0, 8.0), 4.0)
    radial.set_color_at(0.0, Qt6::Color.new(255, 255, 255))
    radial.set_color_at(1.0, Qt6::Color.new(0, 0, 0))
    radial.center.should eq(Qt6::PointF.new(6.0, 8.0))
    radial.radius.should eq(4.0)

    Qt6::QPainter.paint(gradient_canvas) do |painter|
      painter.antialiasing = false
      painter.pen = Qt6::QPen.new(Qt6::Color.new(0, 0, 0), 1).tap { |pen| pen.style = Qt6::PenStyle::NoPen }
      painter.brush = Qt6::QBrush.new(linear)
      painter.draw_rect(Qt6::RectF.new(0.0, 0.0, 10.0, 4.0))
      painter.brush = Qt6::QBrush.new(radial)
      painter.draw_rect(Qt6::RectF.new(2.0, 4.0, 8.0, 8.0))
    end

    left = gradient_canvas.pixel_color(1, 1)
    middle = gradient_canvas.pixel_color(5, 1)
    right = gradient_canvas.pixel_color(8, 1)
    radial_center = gradient_canvas.pixel_color(6, 8)
    radial_edge = gradient_canvas.pixel_color(2, 8)

    left.red.should be > left.blue
    middle.red.should be > 0
    middle.blue.should be > 0
    right.blue.should be > right.red
    radial_center.red.should be > radial_edge.red
    radial_center.green.should be > radial_edge.green
    radial_center.blue.should be > radial_edge.blue

    dash_canvas = Qt6::QImage.new(12, 12)
    dash_canvas.fill(Qt6::Color.new(0, 0, 0, 0))

    dashed_pen = Qt6::QPen.new(Qt6::Color.new(0, 0, 0), 1)
    dashed_pen.cap_style = Qt6::PenCapStyle::FlatCap
    dashed_pen.join_style = Qt6::PenJoinStyle::RoundJoin
    dashed_pen.dash_pattern = [2.0, 2.0]
    dashed_pen.dash_offset = 0.0

    Qt6::QPainter.paint(dash_canvas) do |painter|
      painter.antialiasing = false
      painter.pen = dashed_pen
      painter.draw_line(Qt6::PointF.new(0.0, 6.0), Qt6::PointF.new(11.0, 6.0))
    end

    dashed_pen.style.should eq(Qt6::PenStyle::CustomDashLine)
    dashed_pen.join_style.should eq(Qt6::PenJoinStyle::RoundJoin)
    dashed_pen.dash_offset.should eq(0.0)
    dash_canvas.pixel_color(0, 6).should eq(Qt6::Color.new(0, 0, 0, 255))
    dash_canvas.pixel_color(1, 6).should eq(Qt6::Color.new(0, 0, 0, 255))
    dash_canvas.pixel_color(3, 6).should eq(Qt6::Color.new(0, 0, 0, 0))
    dash_canvas.pixel_color(4, 6).should eq(Qt6::Color.new(0, 0, 0, 255))
    dash_canvas.pixel_color(5, 6).should eq(Qt6::Color.new(0, 0, 0, 255))
    dash_canvas.pixel_color(7, 6).should eq(Qt6::Color.new(0, 0, 0, 0))
  end

  it "supports byte arrays, buffers, data-backed images, and mm-based pdf sizing" do
    app

    raw = Qt6::QByteArray.new(Bytes[1_u8, 2_u8, 3_u8, 4_u8])
    raw.size.should eq(4)
    raw.bytes.should eq(Bytes[1_u8, 2_u8, 3_u8, 4_u8])
    raw.clear
    raw.empty?.should be_true

    raw_pixels = Bytes[
      30_u8, 20_u8, 10_u8, 255_u8,
      60_u8, 50_u8, 40_u8, 255_u8,
      90_u8, 80_u8, 70_u8, 255_u8,
      120_u8, 110_u8, 100_u8, 255_u8,
    ]
    raw_image = Qt6::QImage.from_raw_data(raw_pixels, 2, 2, 8, Qt6::ImageFormat::ARGB32)
    raw_image.null?.should be_false
    raw_image.format.should eq(Qt6::ImageFormat::ARGB32)
    raw_image.bytes_per_line.should eq(8)
    raw_image.size_in_bytes.should eq(16)
    raw_image.bytes.should eq(raw_pixels)
    raw_image.pixel_color(0, 0).should eq(Qt6::Color.new(10, 20, 30, 255))
    raw_image.pixel_color(1, 1).should eq(Qt6::Color.new(100, 110, 120, 255))

    raw_copy = raw_image.copy
    raw_copy.set_pixel_color(0, 0, Qt6::Color.new(200, 10, 20, 255))
    raw_image.pixel_color(0, 0).should eq(Qt6::Color.new(10, 20, 30, 255))
    raw_copy.pixel_color(0, 0).should eq(Qt6::Color.new(200, 10, 20, 255))

    raw_region = raw_image.copy(Qt6::Rect.new(1, 0, 1, 2))
    raw_region.size.should eq(Qt6::Size.new(1, 2))
    raw_region.pixel_color(0, 0).should eq(Qt6::Color.new(40, 50, 60, 255))
    raw_region.pixel_color(0, 1).should eq(Qt6::Color.new(100, 110, 120, 255))

    premultiplied = raw_image.convert_to_format(Qt6::ImageFormat::ARGB32Premultiplied)
    premultiplied.format.should eq(Qt6::ImageFormat::ARGB32Premultiplied)
    premultiplied.bytes.size.should eq(premultiplied.size_in_bytes)

    image = Qt6::QImage.new(4, 4)
    image.fill(Qt6::Color.new(0, 0, 0, 0))
    image.set_pixel_color(1, 1, Qt6::Color.new(10, 20, 30))
    image.set_pixel_color(2, 2, Qt6::Color.new(200, 150, 100))

    byte_array = Qt6::QByteArray.new
    buffer = Qt6::QBuffer.new(byte_array)
    buffer.open(Qt6::IODeviceOpenMode::WriteOnly).should be_true
    image.save(buffer, "PNG").should be_true
    buffer.close
    buffer.open?.should be_false

    encoded = byte_array.bytes
    encoded.size.should be > 0

    image_from_data = Qt6::QImage.from_data(encoded, "PNG")
    image_from_data.null?.should be_false
    image_from_data.pixel_color(1, 1).should eq(Qt6::Color.new(10, 20, 30, 255))
    image_from_data.pixel_color(2, 2).should eq(Qt6::Color.new(200, 150, 100, 255))
    image.save_to_data("PNG").size.should be > 0

    pixmap_from_data = Qt6::QPixmap.from_data(encoded, "PNG")
    pixmap_from_data.null?.should be_false
    pixmap_from_data.to_image.pixel_color(2, 2).should eq(Qt6::Color.new(200, 150, 100, 255))
    pixmap_from_data.save_to_data("PNG").size.should be > 0

    implicit_buffer = Qt6::QBuffer.new
    implicit_buffer.open(Qt6::IODeviceOpenMode::WriteOnly).should be_true
    image.save(implicit_buffer, "PNG").should be_true
    implicit_buffer.close
    implicit_buffer.data.bytes.size.should be > 0

    pdf_path = File.join(Dir.tempdir, "crystal-qt6-mm-layout-#{Process.pid}.pdf")
    pdf = Qt6::QPdfWriter.new(pdf_path, title: "MM Layout", creator: "crystal-qt6 specs")
    pdf.set_page_size_millimeters(50.0, 40.0, Qt6::PageOrientation::Portrait)
    pdf.resolution = 96
    layout = Qt6::PageLayout.new(
      Qt6::PageSize.new(50.0, 40.0, Qt6::PageSizeUnit::Millimeter),
      Qt6::PageOrientation::Portrait,
      Qt6::MarginsF.new(5.0, 2.5, 5.0, 2.5)
    )
    pdf.page_layout = layout

    full_rect = pdf.page_layout_full_rect_points
    paint_rect = pdf.page_layout_paint_rect_points

    full_rect.width.should be > paint_rect.width
    full_rect.height.should be > paint_rect.height
    paint_rect.x.should be > 0.0
    paint_rect.y.should be > 0.0

    Qt6::QPainter.paint(pdf) do |painter|
      painter.draw_line(Qt6::PointF.new(0.0, 0.0), Qt6::PointF.new(20.0, 20.0))
    end

    pdf_header = begin
      pdf.release
      File.open(pdf_path) do |file|
        bytes = Bytes.new(5)
        file.read_fully(bytes)
        String.new(bytes)
      end
    end

    File.exists?(pdf_path).should be_true
    pdf_header.should eq("%PDF-")
  end

  it "supports url and filesystem utility wrappers" do
    app

    root_path = File.join(Dir.tempdir, "crystal-qt6-utils-#{Process.pid}")
    nested_relative = "maps/exports"
    nested_path = File.join(root_path, "maps", "exports")
    maps_path = File.join(root_path, "maps")
    file_path = File.join(root_path, "terrain.map")

    Dir.mkdir_p(root_path)
    File.write(file_path, "terrain")

    url = Qt6::QUrl.from_local_file(file_path)
    web_url = Qt6::QUrl.new("https://example.com/maps/view?id=7")
    dir = Qt6::QDir.new(root_path)
    file_info = Qt6::QFileInfo.new(file_path)

    url.valid?.should be_true
    url.local_file?.should be_true
    url.scheme.should eq("file")
    url.to_local_file.should eq(file_path)
    url.to_string.should contain(file_path)

    web_url.valid?.should be_true
    web_url.local_file?.should be_false
    web_url.scheme.should eq("https")
    web_url.path.should eq("/maps/view")

    dir.exists?.should be_true
    dir.path.should eq(root_path)
    dir.file_path("terrain.map").should eq(file_path)
    dir.absolute_file_path("terrain.map").should eq(file_path)
    dir.mkpath(nested_relative).should be_true

    Qt6::QDir.clean_path("#{root_path}/maps/../maps/exports").should eq(nested_path)
    Qt6::QDir.current_path.should eq(Dir.current)
    Qt6::QDir.home_path.should_not be_empty

    file_info.exists?.should be_true
    file_info.file?.should be_true
    file_info.dir?.should be_false
    file_info.file_name.should eq("terrain.map")
    file_info.base_name.should eq("terrain")
    file_info.suffix.should eq("map")
    file_info.absolute_file_path.should eq(file_path)
    file_info.absolute_path.should eq(root_path)
    file_info.directory.absolute_path.should eq(root_path)
    file_info.size.should eq(7_i64)
  ensure
    File.delete?(file_path) if file_path
    Dir.delete?(nested_path) if nested_path
    Dir.delete?(maps_path) if maps_path
    Dir.delete?(root_path) if root_path
  end

  it "supports file-backed qt io helpers" do
    app

    file_path = File.join(Dir.tempdir, "crystal-qt6-qfile-#{Process.pid}.txt")
    file = Qt6::QFile.new(file_path)

    Qt6::QFile.exists?(file_path).should be_false
    file.exists?.should be_false
    file.file_name.should eq(file_path)

    file.open(Qt6::IODeviceOpenMode::WriteOnly).should be_true
    file.open?.should be_true
    file.write("terrain\n").should eq(8_i64)
    file.flush.should be_true
    file.size.should eq(8_i64)
    file.close

    Qt6::QFile.exists?(file_path).should be_true
    file.exists?.should be_true

    file.open(Qt6::IODeviceOpenMode::ReadOnly).should be_true
    file.read_all.bytes.should eq("terrain\n".to_slice)
    file.close
    file.open?.should be_false

    renamed_path = File.join(Dir.tempdir, "crystal-qt6-qfile-renamed-#{Process.pid}.txt")
    file.file_name = renamed_path
    file.file_name.should eq(renamed_path)
    file.exists?.should be_false

    renamed = Qt6::QFile.new(renamed_path)
    renamed.open(Qt6::IODeviceOpenMode::WriteOnly).should be_true
    renamed.write(Bytes[1_u8, 2_u8, 3_u8, 4_u8]).should eq(4_i64)
    renamed.close
    renamed.size.should eq(4_i64)
    renamed.remove.should be_true
    renamed.exists?.should be_false
  ensure
    File.delete?(file_path) if file_path
    File.delete?(renamed_path) if renamed_path
  end

  it "supports shared qiodevice-style helpers for buffers and files" do
    app

    backing = Qt6::QByteArray.new
    buffer = Qt6::QBuffer.new(backing)

    buffer.open(Qt6::IODeviceOpenMode::ReadWrite).should be_true
    buffer.open?.should be_true
    buffer.position.should eq(0_i64)
    buffer.at_end?.should be_true
    buffer.write("roads").should eq(5_i64)
    buffer.size.should eq(5_i64)
    buffer.position.should eq(5_i64)
    buffer.at_end?.should be_true
    buffer.seek(0).should be_true
    buffer.position.should eq(0_i64)
    buffer.bytes_available.should eq(5_i64)
    buffer.at_end?.should be_false
    buffer.read_all.bytes.should eq("roads".to_slice)
    buffer.at_end?.should be_true
    buffer.seek(2).should be_true
    buffer.write("X").should eq(1_i64)
    buffer.close
    buffer.data.bytes.should eq("roXds".to_slice)

    file_path = File.join(Dir.tempdir, "crystal-qt6-iodevice-#{Process.pid}.txt")
    file = Qt6::QFile.new(file_path)
    file.open(Qt6::IODeviceOpenMode::WriteOnly).should be_true
    file.write("terrain\nroads").should eq(13_i64)
    file.position.should eq(13_i64)
    file.size.should eq(13_i64)
    file.close

    file.open(Qt6::IODeviceOpenMode::ReadOnly).should be_true
    file.position.should eq(0_i64)
    file.bytes_available.should eq(13_i64)
    file.at_end?.should be_false
    file.seek(8).should be_true
    file.position.should eq(8_i64)
    file.read_all.bytes.should eq("roads".to_slice)
    file.at_end?.should be_true
    file.close
  ensure
    File.delete?(file_path) if file_path
  end

  it "supports persisted settings stores" do
    app

    settings_path = File.join(Dir.tempdir, "crystal-qt6-settings-#{Process.pid}.ini")
    File.delete?(settings_path)

    settings = Qt6::QSettings.new(settings_path)
    settings.file_name.should eq(settings_path)
    settings.contains?("window/title").should be_false
    settings.value("window/title").should be_nil
    settings.value("window/missing", "fallback").should eq("fallback")

    settings.set_value("window/title", "Map Tool").should eq("Map Tool")
    settings.set_value("window/width", 1280).should eq(1280)
    settings.set_value("window/opacity", 0.85).should eq(0.85)
    settings.set_value("window/pinned", true).should eq(true)
    settings.sync

    File.exists?(settings_path).should be_true

    reopened = Qt6::QSettings.new(settings_path)
    reopened.contains?("window/title").should be_true
    reopened.value("window/title").should eq("Map Tool")
    reopened.value("window/width").should eq(1280)
    reopened.value("window/opacity").should eq(0.85)
    reopened.value("window/pinned").should eq(true)
    reopened.all_keys.sort.should eq(["window/opacity", "window/pinned", "window/title", "window/width"])

    reopened.remove("window/title").sync
    reopened.contains?("window/title").should be_false

    reopened.clear.sync
    reopened.all_keys.should be_empty
  ensure
    File.delete?(settings_path) if settings_path
  end

  it "supports desktop integration helpers" do
    app

    temp_path = Qt6::StandardPaths.writable_location(Qt6::StandardLocation::TempLocation)
    home_path = Qt6::StandardPaths.writable_location(Qt6::StandardLocation::HomeLocation)
    home_locations = Qt6::StandardPaths.standard_locations(Qt6::StandardLocation::HomeLocation)
    app_config_locations = Qt6::StandardPaths.standard_locations(Qt6::StandardLocation::AppConfigLocation)

    temp_path.should_not be_empty
    home_path.should_not be_empty
    home_locations.should contain(home_path)
    app_config_locations.should_not be_empty
    Qt6::StandardPaths.display_name(Qt6::StandardLocation::DocumentsLocation).should_not be_empty

    Qt6::DesktopServices.open_url(Qt6::QUrl.new).should be_false
  end

  it "loads standalone SVG files and exposes element bounds" do
    app
    svg_path = File.join(Dir.tempdir, "crystal-qt6-standalone-#{Process.pid}.svg")
    File.write(svg_path, <<-SVG)
      <svg xmlns="http://www.w3.org/2000/svg" width="20" height="12" viewBox="0 0 20 12">
        <rect id="box" x="2" y="1" width="6" height="4" fill="#ff0000"/>
        <rect id="accent" x="12" y="2" width="4" height="6" fill="#0000ff"/>
      </svg>
    SVG

    renderer = Qt6::QSvgRenderer.new(svg_path)
    renderer.load(svg_path).should be_true
    canvas = Qt6::QImage.new(20, 12)
    canvas.fill(Qt6::Color.new(255, 255, 255))
    element_canvas = Qt6::QImage.new(20, 12)
    element_canvas.fill(Qt6::Color.new(255, 255, 255))
    bounded_element_canvas = Qt6::QImage.new(10, 10)
    bounded_element_canvas.fill(Qt6::Color.new(255, 255, 255))

    Qt6::QPainter.paint(canvas) do |painter|
      renderer.render(painter)
    end

    Qt6::QPainter.paint(element_canvas) do |painter|
      renderer.render(painter, "box")
    end

    Qt6::QPainter.paint(bounded_element_canvas) do |painter|
      renderer.render(painter, "accent", Qt6::RectF.new(0.0, 0.0, 10.0, 10.0))
    end

    renderer.valid?.should be_true
    renderer.default_size.should eq(Qt6::Size.new(20, 12))
    renderer.view_box.should eq(Qt6::RectF.new(0.0, 0.0, 20.0, 12.0))
    renderer.element_exists?("box").should be_true
    renderer.element_exists?("accent").should be_true
    renderer.element_exists?("missing").should be_false
    renderer.bounds_on_element("box").should eq(Qt6::RectF.new(2.0, 1.0, 6.0, 4.0))
    renderer.bounds_on_element("accent").should eq(Qt6::RectF.new(12.0, 2.0, 4.0, 6.0))
    canvas.pixel_color(3, 2).should eq(Qt6::Color.new(255, 0, 0, 255))
    canvas.pixel_color(13, 3).should eq(Qt6::Color.new(0, 0, 255, 255))
    element_canvas.pixel_color(3, 2).should eq(Qt6::Color.new(255, 0, 0, 255))
    bounded_element_canvas.pixel_color(1, 1).should eq(Qt6::Color.new(0, 0, 255, 255))
  end

  it "supports clipboard access and file-backed image loading helpers" do
    application = app
    source_path = File.join(Dir.tempdir, "crystal-qt6-image-source-#{Process.pid}.png")
    source = Qt6::QImage.new(12, 10)
    source.fill(Qt6::Color.new(255, 255, 255))
    source.set_pixel_color(4, 3, Qt6::Color.new(12, 34, 56, 255))
    source.save(source_path).should be_true

    loaded_image = Qt6::QImage.from_file(source_path)
    loaded_image.null?.should be_false
    loaded_image.size.should eq(Qt6::Size.new(12, 10))
    loaded_image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    reusable_image = Qt6::QImage.new(1, 1)
    reusable_image.load(source_path).should be_true
    reusable_image.size.should eq(Qt6::Size.new(12, 10))
    reusable_image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    loaded_pixmap = Qt6::QPixmap.from_file(source_path)
    loaded_pixmap.null?.should be_false
    loaded_pixmap.size.should eq(Qt6::Size.new(12, 10))
    loaded_pixmap.to_image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    reusable_pixmap = Qt6::QPixmap.new(1, 1)
    reusable_pixmap.load(source_path).should be_true
    reusable_pixmap.size.should eq(Qt6::Size.new(12, 10))
    reusable_pixmap.to_image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    reader = Qt6::QImageReader.new(source_path)
    reader.file_name.should eq(source_path)
    reader.can_read?.should be_true
    reader.size.should eq(Qt6::Size.new(12, 10))
    reader.format.should eq("png")
    reader.auto_transform?.should be_false
    reader.auto_transform = true
    reader.auto_transform?.should be_true
    reader.format = "png"
    reader.format.should eq("png")

    reader_image = reader.read
    reader_image.null?.should be_false
    reader_image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    second_reader = Qt6::QImageReader.new(source_path)
    reused_reader_image = Qt6::QImage.new(1, 1)
    second_reader.read(reused_reader_image).should be_true
    reused_reader_image.size.should eq(Qt6::Size.new(12, 10))
    reused_reader_image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    encoded_png = source.save_to_data("PNG")
    buffer = Qt6::QBuffer.new
    buffer.open(Qt6::IODeviceOpenMode::ReadWrite).should be_true
    source.save(buffer, "PNG").should be_true
    buffer.position.should be > 0
    buffer.seek(0).should be_true
    buffer.peek(8).bytes.should eq(encoded_png[0, 8])
    buffer.read(8).bytes.should eq(encoded_png[0, 8])

    device_loaded_image = Qt6::QImage.new(1, 1)
    buffer.seek(0).should be_true
    device_loaded_image.load(buffer, "PNG").should be_true
    device_loaded_image.size.should eq(Qt6::Size.new(12, 10))
    device_loaded_image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    buffer.seek(0).should be_true
    device_reader = Qt6::QImageReader.new(buffer, "png")
    device_reader.can_read?.should be_true
    device_reader.size.should eq(Qt6::Size.new(12, 10))
    device_reader.read.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    clipboard = application.clipboard
    clipboard.clear
    clipboard.text = "clipboard sample"
    application.process_events
    clipboard.has_text?.should be_true
    clipboard.text.should eq("clipboard sample")

    clipboard.image = loaded_image
    application.process_events
    clipboard.has_image?.should be_true
    clipboard_image = clipboard.image
    clipboard_image.null?.should be_false
    clipboard_image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    clipboard.pixmap = loaded_pixmap
    application.process_events
    clipboard.has_pixmap?.should be_true
    clipboard_pixmap = clipboard.pixmap
    clipboard_pixmap.null?.should be_false
    clipboard_pixmap.to_image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))

    mime_data = Qt6::MimeData.new
    mime_data.text = "mime sample"
    mime_data.html = "<b>mime sample</b>"
    mime_data.image = loaded_image
    mime_data.set_data("application/x-crystal-qt6-layer", Bytes[1_u8, 7_u8, 9_u8])
    mime_data.has_html?.should be_true
    mime_data.has_image?.should be_true
    mime_data.image.pixel_color(4, 3).should eq(Qt6::Color.new(12, 34, 56, 255))
    mime_data.formats.should contain("application/x-crystal-qt6-layer")
    clipboard.mime_data = mime_data
    application.process_events

    clipboard_mime = clipboard.mime_data
    clipboard_mime.should_not be_nil
    clipboard_mime = clipboard_mime.not_nil!
    clipboard_mime.has_text?.should be_true
    clipboard_mime.text.should eq("mime sample")
    clipboard_mime.has_html?.should be_true
    clipboard_mime.html.should contain("mime sample")
    clipboard_mime.formats.should contain("application/x-crystal-qt6-layer")
    clipboard_mime.has_format?("application/x-crystal-qt6-layer").should be_true
    clipboard_mime.data("application/x-crystal-qt6-layer").should eq(Bytes[1_u8, 7_u8, 9_u8])
    clipboard.clear
  end

  it "loads SVG content from memory" do
    app
    svg_markup = <<-SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="18" height="10" viewBox="0 0 18 10">
        <rect id="memory-box" x="4" y="2" width="6" height="4" fill="#00aa00"/>
      </svg>
    SVG

    renderer = Qt6::QSvgRenderer.from_data(svg_markup)
    renderer.valid?.should be_true
    renderer.default_size.should eq(Qt6::Size.new(18, 10))
    renderer.element_exists?("memory-box").should be_true

    image = Qt6::QImage.new(18, 10)
    image.fill(Qt6::Color.new(255, 255, 255))

    Qt6::QPainter.paint(image) do |painter|
      renderer.render(painter)
    end

    image.pixel_color(5, 3).should eq(Qt6::Color.new(0, 170, 0, 255))

    widget = Qt6::QSvgWidget.from_data(svg_markup)
    widget.size_hint.should eq(Qt6::Size.new(18, 10))
    widget.resize(18, 10)
    widget.show
    app.process_events

    preview = widget.grab
    preview.null?.should be_false
    preview.width.should be >= 18
    preview.height.should be >= 10
    widget.release
  end

  it "displays SVG content in QSvgWidget" do
    application = app
    svg_path = File.join(Dir.tempdir, "crystal-qt6-widget-#{Process.pid}.svg")
    File.write(svg_path, <<-SVG)
      <svg xmlns="http://www.w3.org/2000/svg" width="24" height="16" viewBox="0 0 24 16">
        <rect x="3" y="2" width="8" height="6" fill="#ff0000"/>
      </svg>
    SVG

    widget = Qt6::QSvgWidget.new(svg_path)
    renderer = widget.renderer

    renderer.valid?.should be_true
    renderer.default_size.should eq(Qt6::Size.new(24, 16))
    renderer.element_exists?("missing").should be_false
    widget.size_hint.should eq(Qt6::Size.new(24, 16))
    widget.resize(24, 16)
    widget.visible?.should be_false
    widget.show
    application.process_events
    widget.update
    application.process_events

    preview = widget.grab

    widget.visible?.should be_true
    widget.size.should eq(Qt6::Size.new(24, 16))
    preview.null?.should be_false
    preview.width.should be >= 24
    preview.height.should be >= 16

    render_probe = Qt6::QImage.new(24, 16)
    render_probe.fill(Qt6::Color.new(255, 255, 255))
    Qt6::QPainter.paint(render_probe) do |painter|
      renderer.render(painter)
    end
    render_probe.pixel_color(4, 3).should eq(Qt6::Color.new(255, 0, 0, 255))

    widget.release
  end

  it "provides convenience helpers for common dialogs" do
    app
    window = Qt6::MainWindow.new

    message_result = Qt6::MessageBox.information(window, title: "About", text: "Helper test") do |dialog|
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    selected_color = Qt6::ColorDialog.get_color(window, current_color: Qt6::Color.new(8, 16, 32, 64), title: "Accent", show_alpha_channel: true) do |dialog|
      dialog.native_dialog = false
      dialog.current_color = Qt6::Color.new(32, 64, 96, 128)
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    text_value = Qt6::InputDialog.get_text(window, title: "Rename", label: "Layer", value: "Terrain") do |dialog|
      dialog.text_value = "Roads"
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    int_value = Qt6::InputDialog.get_int(window, title: "Count", label: "Columns", value: 3, minimum: 1, maximum: 12) do |dialog|
      dialog.int_value = 7
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    double_value = Qt6::InputDialog.get_double(window, title: "Scale", label: "Zoom", value: 1.0, minimum: 0.5, maximum: 4.0) do |dialog|
      dialog.double_value = 1.25
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    item_value = Qt6::InputDialog.get_item(window, title: "Layer Type", label: "Kind", items: ["Terrain", "Units", "Roads"], current: 1, editable: false) do |dialog|
      dialog.combo_box_items.should eq(["Terrain", "Units", "Roads"])
      dialog.combo_box_editable?.should be_false
      dialog.text_value = "Roads"
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    message_result.should eq(Qt6::MessageBoxButton::Ok)
    selected_color.should eq(Qt6::Color.new(32, 64, 96, 128))
    text_value.should eq("Roads")
    int_value.should eq(7)
    double_value.should eq(1.25)
    item_value.should eq("Roads")
    window.release
  end

  it "configures color and input dialogs" do
    app
    window = Qt6::MainWindow.new
    color_dialog = Qt6::ColorDialog.new(window)
    input_dialog = Qt6::InputDialog.new(window)

    color_dialog.window_title = "Pick Accent Color"
    color_dialog.native_dialog = false
    color_dialog.show_alpha_channel = true
    color_dialog.current_color = Qt6::Color.new(32, 96, 192, 180)

    input_dialog.window_title = "Layer Details"
    input_dialog.input_mode = Qt6::InputDialogInputMode::Text
    input_dialog.label_text = "Layer name"
    input_dialog.text_value = "Terrain"
    input_dialog.input_mode = Qt6::InputDialogInputMode::Int
    input_dialog.int_range = 1..12
    input_dialog.int_value = 4
    input_dialog.input_mode = Qt6::InputDialogInputMode::Double
    input_dialog.double_range = 0.5..4.0
    input_dialog.double_value = 1.5
    input_dialog.input_mode = Qt6::InputDialogInputMode::Text
    input_dialog.combo_box_items = ["Terrain", "Units", "Roads"]
    input_dialog.combo_box_editable = false
    input_dialog.text_value = "Units"

    color_dialog.window_title.should eq("Pick Accent Color")
    color_dialog.native_dialog?.should be_false
    color_dialog.current_color.should eq(Qt6::Color.new(32, 96, 192, 180))
    color_dialog.show_alpha_channel?.should be_true

    input_dialog.window_title.should eq("Layer Details")
    input_dialog.label_text.should eq("Layer name")
    input_dialog.text_value.should eq("Units")
    input_dialog.int_minimum.should eq(1)
    input_dialog.int_maximum.should eq(12)
    input_dialog.int_value.should eq(4)
    input_dialog.double_minimum.should eq(0.5)
    input_dialog.double_maximum.should eq(4.0)
    input_dialog.double_value.should eq(1.5)
    input_dialog.combo_box_items.should eq(["Terrain", "Units", "Roads"])
    input_dialog.combo_box_editable?.should be_false
    window.release
  end

  it "configures standard message and file dialogs" do
    app
    window = Qt6::MainWindow.new
    message_box = Qt6::MessageBox.new(window)
    file_dialog = Qt6::FileDialog.new(window, "/tmp", "Maps (*.map *.json)")

    message_box.window_title = "Unsaved Changes"
    message_box.icon = Qt6::MessageBoxIcon::Warning
    message_box.text = "This map has unsaved changes."
    message_box.informative_text = "Save before closing?"
    message_box.standard_buttons = Qt6::MessageBoxButton::Save | Qt6::MessageBoxButton::Discard | Qt6::MessageBoxButton::Cancel
    message_box.accept

    file_dialog.accept_mode = Qt6::FileDialogAcceptMode::Save
    file_dialog.file_mode = Qt6::FileDialogFileMode::AnyFile
    file_dialog.directory = "/tmp"
    file_dialog.name_filter = "Maps (*.map *.json)"
    file_dialog.select_file("/tmp/example.map")

    message_box.window_title.should eq("Unsaved Changes")
    message_box.icon.should eq(Qt6::MessageBoxIcon::Warning)
    message_box.text.should eq("This map has unsaved changes.")
    message_box.informative_text.should eq("Save before closing?")
    message_box.standard_buttons.includes?(Qt6::MessageBoxButton::Save).should be_true
    message_box.standard_buttons.includes?(Qt6::MessageBoxButton::Discard).should be_true
    message_box.standard_buttons.includes?(Qt6::MessageBoxButton::Cancel).should be_true
    message_box.result.should eq(Qt6::DialogCode::Accepted)

    file_dialog.accept_mode.should eq(Qt6::FileDialogAcceptMode::Save)
    file_dialog.file_mode.should eq(Qt6::FileDialogFileMode::AnyFile)
    file_dialog.directory.should eq("/tmp")
    file_dialog.name_filter.should eq("Maps (*.map *.json)")
    window.release
  end

  it "supports progress dialogs and splash screens" do
    application = app
    window = Qt6::MainWindow.new
    progress = Qt6::ProgressDialog.new(window, label_text: "Loading tiles", cancel_button_text: "Stop", minimum: 0, maximum: 10)

    progress.label_text.should eq("Loading tiles")
    progress.minimum.should eq(0)
    progress.maximum.should eq(10)
    progress.minimum_duration = 0
    progress.minimum_duration.should eq(0)
    progress.auto_close = false
    progress.auto_reset = false
    progress.auto_close?.should be_false
    progress.auto_reset?.should be_false
    progress.range = 1..5
    progress.minimum.should eq(1)
    progress.maximum.should eq(5)
    progress.value = 2
    progress.value.should eq(2)
    progress.was_canceled?.should be_false

    cancel_timer = Qt6::QTimer.new(progress)
    cancel_timer.single_shot = true
    cancel_timer.on_timeout do
      progress.cancel
    end
    progress.show
    cancel_timer.start(0)
    10.times do
      application.process_events
      break if progress.was_canceled?
    end

    progress.was_canceled?.should be_true
    progress.reset

    splash_image = Qt6::QImage.new(24, 16)
    splash_image.fill(Qt6::Color.new(250, 240, 220))
    splash_image.set_pixel_color(2, 2, Qt6::Color.new(30, 90, 180))
    splash = Qt6::SplashScreen.new(splash_image.to_pixmap)
    replacement_pixmap = Qt6::QPixmap.new(12, 12)
    replacement_pixmap.fill(Qt6::Color.new(18, 36, 72))

    splash.pixmap.null?.should be_false
    splash.show
    splash.show_message("Booting", Qt6::Color.new(12, 34, 56))
    application.process_events
    splash.message.should eq("Booting")
    splash.pixmap = replacement_pixmap
    splash.pixmap.size.should eq(Qt6::Size.new(12, 12))
    window.show
    application.process_events
    splash.finish(window)
    application.process_events
    splash.visible?.should be_false
    splash.clear_message
    splash.message.should eq("")

    splash.release
    window.release
  end

  it "supports action shortcuts and exclusive action groups" do
    app
    window = Qt6::MainWindow.new
    menu = window.menu_bar.add_menu("View")
    group = Qt6::ActionGroup.new(window)
    map_action = Qt6::Action.new("Map", window)
    units_action = Qt6::Action.new("Units", window)

    map_action.shortcut = Qt6::KeySequence.new("Ctrl+1")
    units_action.shortcut = "Ctrl+2"
    map_action.checkable = true
    units_action.checkable = true
    group.exclusive = true
    group << map_action
    group << units_action
    menu << map_action
    menu << units_action

    map_action.checked = true
    units_action.checked = true

    map_action.shortcut.to_s.should eq("Ctrl+1")
    units_action.shortcut.to_s.should eq("Ctrl+2")
    map_action.checkable?.should be_true
    units_action.checkable?.should be_true
    group.exclusive?.should be_true
    map_action.checked?.should be_false
    units_action.checked?.should be_true
    window.release
  end

  it "builds a reduced shell with menus, toolbars, docks, dialogs, and controls" do
    application = app
    main = Qt6::MainWindow.new
    triggered = 0
    accepted = 0
    rejected = 0
    toggled = [] of Bool
    indices = [] of Int32

    main.window_title = "Editor Shell"
    main.resize(960, 640)
    main.central_widget = Qt6::Label.new("Canvas")

    file_menu = main.menu_bar.add_menu("File")
    recent_menu = file_menu.add_menu("Recent")
    open_action = Qt6::Action.new("Open", main)
    open_action.on_triggered do
      triggered += 1
    end
    file_menu << open_action
    file_menu.add_separator

    tool_bar = Qt6::ToolBar.new("Primary", main)
    main.add_tool_bar(tool_bar)
    tool_bar << open_action

    dock = Qt6::DockWidget.new("Inspector", main)
    inspector = Qt6::Widget.new
    line_edit = Qt6::LineEdit.new("Hexes")
    check_box = Qt6::CheckBox.new("Snap")
    combo_box = Qt6::ComboBox.new
    check_box.on_toggled do |value|
      toggled << value
    end
    combo_box.on_current_index_changed do |index|
      indices << index
    end
    combo_box << "Units" << "Terrain"

    inspector.vbox do |column|
      column << line_edit
      column << check_box
      column << combo_box
    end

    dock.widget = inspector
    main.add_dock_widget(dock, Qt6::DockArea::Left)
    main.status_bar.show_message("Ready")

    dialog = Qt6::Dialog.new(main)
    dialog.on_accepted do
      accepted += 1
    end
    dialog.on_rejected do
      rejected += 1
    end

    dialog.accept
    check_box.checked = true
    combo_box.current_index = 1
    open_action.trigger
    application.process_events

    recent_menu.title.should eq("Recent")
    main.status_bar.current_message.should eq("Ready")
    line_edit.text = "Terrain"
    line_edit.text.should eq("Terrain")
    check_box.checked?.should be_true
    combo_box.count.should eq(2)
    combo_box.current_text.should eq("Terrain")
    toggled.last.should be_true
    indices.last.should eq(1)
    triggered.should eq(1)
    dialog.result.should eq(Qt6::DialogCode::Accepted)
    accepted.should eq(1)
    rejected.should eq(0)
    main.release
  end

  it "supports abstract spin boxes and general geometry value types" do
    application = app
    spin_box = Qt6::SpinBox.new
    double_spin_box = Qt6::DoubleSpinBox.new
    image = Qt6::QImage.new(32, 18)
    pixmap = Qt6::QPixmap.new(12, 7)

    spin_box.button_symbols = Qt6::AbstractSpinBoxButtonSymbol::NoButtons
    spin_box.read_only = true
    spin_box.wrapping = true
    spin_box.accelerated = true
    spin_box.prefix = "Zoom "
    spin_box.suffix = "%"
    spin_box.special_value_text = "Auto"
    spin_box.set_range(0, 100)
    spin_box.value = 25
    double_spin_box.button_symbols = Qt6::AbstractSpinBoxButtonSymbol::PlusMinus
    double_spin_box.read_only = false
    double_spin_box.wrapping = false
    double_spin_box.accelerated = true
    double_spin_box.prefix = "~"
    double_spin_box.suffix = "x"
    double_spin_box.special_value_text = "Default"
    double_spin_box.decimals = 3
    double_spin_box.set_range(0.0, 10.0)
    double_spin_box.value = 1.25

    rect = Qt6::Rect.new(1, 2, 30, 40)
    rect_f = rect.to_rect_f
    size = Qt6::Size.new(14, 9)
    size_f = size.to_size_f
    page_size = Qt6::PageSize.new(size_f)

    spin_box.should be_a(Qt6::AbstractSpinBox)
    double_spin_box.should be_a(Qt6::AbstractSpinBox)
    spin_box.button_symbols.should eq(Qt6::AbstractSpinBoxButtonSymbol::NoButtons)
    spin_box.read_only?.should be_true
    spin_box.wrapping?.should be_true
    spin_box.accelerated?.should be_true
    spin_box.prefix.should eq("Zoom ")
    spin_box.suffix.should eq("%")
    spin_box.special_value_text.should eq("Auto")
    spin_box.clean_text.should eq("25")
    double_spin_box.button_symbols.should eq(Qt6::AbstractSpinBoxButtonSymbol::PlusMinus)
    double_spin_box.read_only?.should be_false
    double_spin_box.wrapping?.should be_false
    double_spin_box.accelerated?.should be_true
    double_spin_box.decimals.should eq(3)
    double_spin_box.prefix.should eq("~")
    double_spin_box.suffix.should eq("x")
    double_spin_box.special_value_text.should eq("Default")
    double_spin_box.clean_text.should eq("1.250")

    rect_f.should eq(Qt6::RectF.new(1.0, 2.0, 30.0, 40.0))
    rect_f.to_rect.should eq(rect)
    size_f.should eq(Qt6::SizeF.new(14.0, 9.0))
    size_f.to_size.should eq(size)
    page_size.size.should eq(size_f)
    image.rect.should eq(Qt6::Rect.new(0, 0, 32, 18))
    pixmap.rect.should eq(Qt6::Rect.new(0, 0, 12, 7))
    application.process_events

    spin_box.release
    double_spin_box.release
    image.release
    pixmap.release
  end

  it "supports editor controls and container widgets" do
    application = app
    window = Qt6::MainWindow.new
    radio_states = [] of Bool
    slider_values = [] of Int32
    spin_values = [] of Int32
    double_values = [] of Float64
    group_states = [] of Bool
    tab_indices = [] of Int32

    splitter = Qt6::Splitter.new(Qt6::Orientation::Horizontal)
    scroll_area = Qt6::ScrollArea.new
    tab_widget = Qt6::TabWidget.new
    inspector = Qt6::Widget.new
    options_group = Qt6::GroupBox.new("Options")
    auto_mode = Qt6::RadioButton.new("Auto")
    manual_mode = Qt6::RadioButton.new("Manual")
    slider = Qt6::Slider.new
    spin_box = Qt6::SpinBox.new
    double_spin_box = Qt6::DoubleSpinBox.new

    manual_mode.on_toggled do |value|
      radio_states << value
    end
    slider.on_value_changed do |value|
      slider_values << value
    end
    spin_box.on_value_changed do |value|
      spin_values << value
    end
    double_spin_box.on_value_changed do |value|
      double_values << value
    end
    options_group.on_toggled do |value|
      group_states << value
    end
    tab_widget.on_current_index_changed do |value|
      tab_indices << value
    end

    options_group.checkable = true
    options_group.vbox do |column|
      column << auto_mode
      column << manual_mode
      column << slider
      column << spin_box
      column << double_spin_box
    end

    inspector.vbox do |column|
      column << options_group
    end

    scroll_area.widget_resizable = true
    scroll_area.widget = inspector
    tab_widget.add_tab(Qt6::Label.new("Layers"), "Layers")
    tab_widget.add_tab(Qt6::Label.new("Export"), "Export")
    splitter << scroll_area
    splitter << tab_widget
    window.central_widget = splitter

    slider.set_range(0, 100)
    slider.value = 42
    spin_box.set_range(1, 9)
    spin_box.single_step = 2
    spin_box.value = 5
    double_spin_box.set_range(0.5, 4.0)
    double_spin_box.single_step = 0.25
    double_spin_box.value = 1.75
    manual_mode.checked = true
    options_group.checked = false
    options_group.checked = true
    tab_widget.current_index = 1
    splitter.orientation = Qt6::Orientation::Vertical
    application.process_events

    scroll_area.widget_resizable?.should be_true
    splitter.count.should eq(2)
    splitter.orientation.should eq(Qt6::Orientation::Vertical)
    tab_widget.count.should eq(2)
    tab_widget.current_index.should eq(1)
    options_group.title.should eq("Options")
    options_group.checkable?.should be_true
    options_group.checked?.should be_true
    auto_mode.checked?.should be_false
    manual_mode.checked?.should be_true
    slider.orientation.should eq(Qt6::Orientation::Horizontal)
    slider.minimum.should eq(0)
    slider.maximum.should eq(100)
    slider.value.should eq(42)
    spin_box.minimum.should eq(1)
    spin_box.maximum.should eq(9)
    spin_box.single_step.should eq(2)
    spin_box.value.should eq(5)
    double_spin_box.minimum.should eq(0.5)
    double_spin_box.maximum.should eq(4.0)
    double_spin_box.single_step.should eq(0.25)
    double_spin_box.value.should eq(1.75)
    radio_states.last.should be_true
    slider_values.last.should eq(42)
    spin_values.last.should eq(5)
    double_values.last.should eq(1.75)
    group_states.last.should be_true
    tab_indices.last.should eq(1)
    window.release
  end

  it "supports app-shell helpers for actions, toolbars, timers, and file dialogs" do
    app
    window = Qt6::MainWindow.new
    toolbar = Qt6::ToolBar.new("Shell", window)
    action = Qt6::Action.new("Export", window)
    file_dialog = Qt6::FileDialog.new(window, "/tmp", "Maps (*.map *.json)")
    loop = Qt6::QEventLoop.new
    triggered = [] of String

    action.tool_tip = "Export the active map"
    action.enabled = false
    action.data = "export-png"
    toolbar.movable = false
    toolbar.add_separator
    toolbar << action
    action.on_triggered do
      triggered << action.data.to_s
    end

    file_dialog.file_mode = Qt6::FileDialogFileMode::ExistingFiles
    file_dialog.select_file("/tmp/first.map")
    file_dialog.select_file("/tmp/second.map")

    Qt6::QTimer.single_shot(0) do
      action.enabled = true
      action.trigger
      loop.quit
    end

    loop.run.should eq(0)

    action.tool_tip.should eq("Export the active map")
    action.enabled?.should be_true
    action.data.should eq("export-png")
    toolbar.movable?.should be_false
    file_dialog.file_mode.should eq(Qt6::FileDialogFileMode::ExistingFiles)
    file_dialog.directory.should eq("/tmp")
    file_dialog.name_filter.should eq("Maps (*.map *.json)")
    triggered.should eq(["export-png"])

    loop.release
    window.release
  end

  it "supports desktop-shell action, menu, toolbar, and window polish" do
    application = app
    window = Qt6::MainWindow.new
    toggled = [] of Bool

    window.window_title = "Shell Polish"
    file_menu = window.menu_bar.add_menu("File")
    view_menu = window.menu_bar.add_menu("View")
    quick_open = file_menu.add_action("Quick Open")
    separator_action = file_menu.add_action("Separator Marker")
    toolbar = Qt6::ToolBar.new("Inspector", window)
    search = Qt6::LineEdit.new(parent: window)

    quick_open.shortcut = "Ctrl+Shift+O"
    quick_open.checkable = true
    quick_open.status_tip = "Open a project quickly"
    quick_open.tool_tip = "Quick Open"
    quick_open.visible = false
    quick_open.visible = true
    quick_open.on_toggled do |value|
      toggled << value
    end
    quick_open.checked = true
    quick_open.checked = false

    separator_action.separator = true
    view_menu.title = "Panels"
    menu_action = view_menu.menu_action
    menu_action.text.should eq("Panels")

    window.add_tool_bar(toolbar)
    toolbar.movable = false
    toolbar.add_widget(search)
    toolbar.add_separator
    toolbar_action = toolbar.add_action("Refresh")
    toggle_view_action = toolbar.toggle_view_action
    toolbar_action.text.should eq("Refresh")
    toolbar.title = "Inspector Tools"
    window.remove_tool_bar(toolbar)
    window.add_tool_bar(toolbar)
    toolbar.clear
    toolbar << quick_open
    application.process_events

    quick_open.shortcut.to_s.should eq("Ctrl+Shift+O")
    quick_open.status_tip.should eq("Open a project quickly")
    quick_open.tool_tip.should eq("Quick Open")
    quick_open.visible?.should be_true
    quick_open.checkable?.should be_true
    quick_open.checked?.should be_false
    toggled.should eq([true, false])
    separator_action.separator?.should be_true
    file_menu.add_action(Qt6::Action.new("Manual", window)).text.should eq("Manual")
    file_menu.clear
    toolbar.movable?.should be_false
    toolbar.title.should eq("Inspector Tools")
    toggle_view_action.checkable?.should be_true
    toggle_view_action.text.should eq("Inspector Tools")
    window.window_title.should eq("Shell Polish")

    menu_action.release
    toggle_view_action.release
    window.release
  end

  it "supports common control widgets and date-based editors" do
    application = app
    progress_bar = Qt6::ProgressBar.new
    scroll_bar = Qt6::ScrollBar.new(Qt6::Orientation::Horizontal)
    dial = Qt6::Dial.new
    date_time_edit = Qt6::DateTimeEdit.new
    date_edit = Qt6::DateEdit.new
    time_edit = Qt6::TimeEdit.new
    calendar = Qt6::CalendarWidget.new
    lcd = Qt6::LcdNumber.new
    command_link = Qt6::CommandLinkButton.new("Export", "Save the current map")
    tab_bar = Qt6::TabBar.new
    stacked_host = Qt6::Widget.new
    stacked_layout = Qt6::StackedLayout.new(stacked_host)
    first_page = Qt6::Label.new("General")
    second_page = Qt6::Label.new("Preview")

    scroll_values = [] of Int32
    dial_values = [] of Int32
    date_time_values = [] of String
    date_values = [] of String
    time_values = [] of String
    calendar_values = [] of String
    tab_indices = [] of Int32
    stacked_indices = [] of Int32

    scroll_bar.on_value_changed do |value|
      scroll_values << value
    end
    dial.on_value_changed do |value|
      dial_values << value
    end
    date_time_edit.on_date_time_changed do |value|
      date_time_values << value.to_string
    end
    date_edit.on_date_changed do |value|
      date_values << value.to_string
    end
    time_edit.on_time_changed do |value|
      time_values << value.to_string
    end
    calendar.on_selection_changed do
      calendar_values << calendar.selected_date.to_string
    end
    tab_bar.on_current_index_changed do |value|
      tab_indices << value
    end
    stacked_layout.on_current_index_changed do |value|
      stacked_indices << value
    end

    progress_bar.set_range(0, 12)
    progress_bar.value = 7
    progress_bar.text_visible = false
    progress_bar.format = "%v/%m"
    progress_bar.orientation = Qt6::Orientation::Vertical

    scroll_bar.set_range(5, 20)
    scroll_bar.single_step = 2
    scroll_bar.page_step = 5
    scroll_bar.value = 11

    dial.set_range(0, 360)
    dial.wrapping = true
    dial.notches_visible = true
    dial.value = 90

    date_time = Qt6::QDateTime.new(2026, 4, 14, 9, 30, 15)
    initial_calendar_date = calendar.selected_date.to_string
    date = initial_calendar_date == "2026-04-15" ? Qt6::QDate.new(2026, 4, 16) : Qt6::QDate.new(2026, 4, 15)
    time = Qt6::QTime.new(11, 45, 0)

    date_time_edit.display_format = "yyyy/MM/dd HH:mm:ss"
    date_time_edit.calendar_popup = true
    date_time_edit.date_time = date_time
    date_edit.date = date
    time_edit.time = time

    calendar.minimum_date = Qt6::QDate.new(2026, 1, 1)
    calendar.maximum_date = Qt6::QDate.new(2026, 12, 31)
    calendar.grid_visible = true
    calendar.selected_date = date

    lcd.digit_count = 6
    lcd.mode = Qt6::LcdNumberMode::Hex
    lcd.segment_style = Qt6::LcdNumberSegmentStyle::Flat
    lcd.display(255)

    command_link.description = "Save the current map as an image"

    tab_bar.add_tab("Layers")
    tab_bar.add_tab("Export")
    tab_bar.set_tab_text(1, "Preview")
    tab_bar.draw_base = false
    tab_bar.current_index = 1

    stacked_layout << first_page
    stacked_layout << second_page
    stacked_layout.current_index = 1

    application.process_events

    progress_bar.minimum.should eq(0)
    progress_bar.maximum.should eq(12)
    progress_bar.value.should eq(7)
    progress_bar.text_visible?.should be_false
    progress_bar.format.should eq("%v/%m")
    progress_bar.orientation.should eq(Qt6::Orientation::Vertical)

    scroll_bar.orientation.should eq(Qt6::Orientation::Horizontal)
    scroll_bar.minimum.should eq(5)
    scroll_bar.maximum.should eq(20)
    scroll_bar.single_step.should eq(2)
    scroll_bar.page_step.should eq(5)
    scroll_bar.value.should eq(11)
    scroll_values.last.should eq(11)

    dial.minimum.should eq(0)
    dial.maximum.should eq(360)
    dial.wrapping?.should be_true
    dial.notches_visible?.should be_true
    dial.value.should eq(90)
    dial_values.last.should eq(90)

    date_time_edit.display_format.should eq("yyyy/MM/dd HH:mm:ss")
    date_time_edit.calendar_popup?.should be_true
    date_time_edit.date_time.to_string.should eq(date_time.to_string)
    date_time_values.last.should eq(date_time.to_string)

    date_edit.date.to_string.should eq(date.to_string)
    date_values.last.should eq(date.to_string)

    time_edit.time.to_string.should eq(time.to_string)
    time_values.last.should eq(time.to_string)

    calendar.minimum_date.to_string.should eq("2026-01-01")
    calendar.maximum_date.to_string.should eq("2026-12-31")
    calendar.grid_visible?.should be_true
    calendar.selected_date.to_string.should eq(date.to_string)
    calendar_values.last.should eq(date.to_string)

    lcd.digit_count.should eq(6)
    lcd.mode.should eq(Qt6::LcdNumberMode::Hex)
    lcd.segment_style.should eq(Qt6::LcdNumberSegmentStyle::Flat)
    lcd.int_value.should eq(255)

    command_link.text.should eq("Export")
    command_link.description.should eq("Save the current map as an image")

    tab_bar.count.should eq(2)
    tab_bar.current_index.should eq(1)
    tab_bar.tab_text(1).should eq("Preview")
    tab_bar.draw_base?.should be_false
    tab_indices.last.should eq(1)

    stacked_layout.count.should eq(2)
    stacked_layout.current_index.should eq(1)
    stacked_indices.last.should eq(1)

    progress_bar.release
    scroll_bar.release
    dial.release
    date_time_edit.release
    date_edit.release
    time_edit.release
    calendar.release
    lcd.release
    command_link.release
    tab_bar.release
    stacked_host.release
  end

  it "supports WargameMapTool-style panel primitives" do
    application = app
    dialog = Qt6::Dialog.new
    dialog.minimum_width = 280

    mode_group = Qt6::ButtonGroup.new(dialog)
    mode_group.exclusive = true

    place_button = Qt6::PushButton.new("Place")
    select_button = Qt6::PushButton.new("Select")
    tool_button = Qt6::ToolButton.new
    tool_button.text = "Brush"
    tool_button.tool_button_style = Qt6::ToolButtonStyle::TextUnderIcon
    tool_button.icon = Qt6::QIcon.new
    tool_button.icon_size = Qt6::Size.new(24, 24)
    tool_button.set_fixed_size(72, 88)
    tool_button.enabled = false
    tool_button.enabled = true

    toggled_states = [] of Bool
    select_button.on_toggled do |value|
      toggled_states << value
    end

    place_button.checkable = true
    select_button.checkable = true
    mode_group.add(place_button, 0)
    mode_group.add(select_button, 1)
    place_button.checked = true
    select_button.checked = true

    separator = Qt6::Frame.new
    separator.frame_shape = Qt6::FrameShape::HLine
    separator.frame_shadow = Qt6::FrameShadow::Sunken

    host = Qt6::Widget.new
    layout = host.vbox do |column|
      column.spacing = 6
      column.set_contents_margins(4, 5, 6, 7)
    end
    layout << place_button
    layout << select_button
    layout.insert(0, tool_button)
    layout << separator
    layout.remove(separator)
    layout << separator

    scroll_area = Qt6::ScrollArea.new
    scroll_area.frame_shape = Qt6::FrameShape::NoFrame
    scroll_area.vertical_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOff
    scroll_area.horizontal_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOn
    scroll_area.widget_resizable = true
    scroll_area.widget = host

    button_box = Qt6::DialogButtonBox.new(
      Qt6::DialogButtonBoxStandardButton::Ok | Qt6::DialogButtonBoxStandardButton::Cancel,
      dialog
    )
    accepted = 0
    rejected = 0
    button_box.on_accepted { accepted += 1 }
    button_box.on_rejected { rejected += 1 }

    ok_button = button_box.button(Qt6::DialogButtonBoxStandardButton::Ok).not_nil!
    cancel_button = button_box.button(Qt6::DialogButtonBoxStandardButton::Cancel).not_nil!
    ok_button.text = "Export"
    ok_button.click
    cancel_button.click
    application.process_events

    dialog.minimum_width.should eq(280)
    layout.spacing.should eq(6)
    tool_button.tool_button_style.should eq(Qt6::ToolButtonStyle::TextUnderIcon)
    tool_button.icon_size.should eq(Qt6::Size.new(24, 24))
    tool_button.enabled?.should be_true
    tool_button.size.should eq(Qt6::Size.new(72, 88))
    place_button.checkable?.should be_true
    place_button.checked?.should be_false
    select_button.checked?.should be_true
    mode_group.checked_id.should eq(1)
    mode_group.button(1).not_nil!.text.should eq("Select")
    mode_group.button(1).not_nil!.checked?.should be_true
    toggled_states.last.should be_true
    separator.frame_shape.should eq(Qt6::FrameShape::HLine)
    separator.frame_shadow.should eq(Qt6::FrameShadow::Sunken)
    scroll_area.frame_shape.should eq(Qt6::FrameShape::NoFrame)
    scroll_area.vertical_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOff)
    scroll_area.horizontal_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOn)
    scroll_area.widget_resizable?.should be_true
    ok_button.text.should eq("Export")
    accepted.should eq(1)
    rejected.should eq(1)

    dialog.release
  end

  it "supports WargameMapTool-style font, stack, and browser widgets" do
    application = app
    host = Qt6::Widget.new
    host.resize(320, 220)

    font_combo = Qt6::FontComboBox.new(host)
    font_combo.set_size_policy(Qt6::SizePolicy::Ignored, Qt6::SizePolicy::Fixed)

    font_families = [] of String
    font_combo.on_current_font_changed do |font|
      font_families << font.family
    end

    font_combo.count.should be > 0
    original_font_index = font_combo.current_index
    if font_combo.count > 1
      alternate_index = original_font_index == 0 ? 1 : 0
      font_combo.current_index = alternate_index
    end
    application.process_events

    browser = Qt6::TextBrowser.new(host)
    browser.open_external_links = false
    browser.default_style_sheet = "a { color: #c00; }"
    browser.html = <<-HTML
      <h1>Guide</h1>
      <p><a href="page:intro">Intro</a></p>
    HTML
    browser.scroll_to_top

    clicked_links = [] of String
    browser.on_anchor_clicked do |href|
      clicked_links << href
    end

    stack = Qt6::StackedWidget.new(host)
    info_page = Qt6::Label.new("Info")
    stack.add_widget(info_page)
    stack.add_widget(browser)
    stack.current_index = 1
    application.process_events

    font_combo.horizontal_size_policy.should eq(Qt6::SizePolicy::Ignored)
    font_combo.vertical_size_policy.should eq(Qt6::SizePolicy::Fixed)
    font_combo.current_font.family.should_not be_empty
    font_families.last?.should_not be_nil if font_combo.count > 1 && font_combo.current_index != original_font_index
    browser.open_external_links?.should be_false
    browser.default_style_sheet.should contain("#c00")
    browser.plain_text.should contain("Guide")
    browser.html.should contain("page:intro")
    browser.vertical_scroll_value.should eq(0)
    clicked_links.should be_empty
    stack.count.should eq(2)
    stack.current_index.should eq(1)

    host.release
  end

  it "supports text editors, documents, and cursors" do
    application = app
    host = Qt6::Widget.new
    host.resize(360, 260)

    rich_document = Qt6::TextDocument.new(host)
    rich_document.default_style_sheet = "p { color: #333; }"
    rich_document.html = "<p>Alpha beta</p>"
    rich_document.title = "Layer Notes"
    rich_document.undo_redo_enabled = true
    rich_document.modified = false

    document_cursor = Qt6::TextCursor.new(rich_document)
    document_cursor.move_position(Qt6::TextCursorMoveOperation::End)
    document_cursor.insert_text("!")
    document_cursor.set_position(0)
    document_cursor.move_position(Qt6::TextCursorMoveOperation::Right, Qt6::TextCursorMoveMode::KeepAnchor, 5)

    text_edit = Qt6::TextEdit.new(parent: host)
    rich_text_changes = 0
    text_edit.on_text_changed do
      rich_text_changes += 1
    end
    text_edit.accept_rich_text = true
    text_edit.undo_redo_enabled = true
    text_edit.read_only = false
    text_edit.placeholder_text = "Describe the selected layer"
    text_edit.document = rich_document
    editor_cursor = text_edit.text_cursor
    editor_cursor.move_position(Qt6::TextCursorMoveOperation::End)
    text_edit.text_cursor = editor_cursor
    text_edit.append("Gamma")

    plain_edit = Qt6::PlainTextEdit.new(parent: host)
    plain_text_changes = 0
    plain_edit.on_text_changed do
      plain_text_changes += 1
    end
    plain_edit.placeholder_text = "Notes"
    plain_edit.undo_redo_enabled = true
    plain_edit.read_only = false
    plain_edit.plain_text = "Terrain"
    plain_document = plain_edit.document
    plain_cursor = plain_edit.text_cursor
    plain_cursor.move_position(Qt6::TextCursorMoveOperation::End)
    plain_cursor.insert_text("\nUnits")
    plain_edit.text_cursor = plain_cursor
    plain_edit.append_plain_text("Roads")
    plain_edit.insert_plain_text("\nSupply")
    document_cursor.remove_selected_text
    document_cursor.insert_text("Omega")
    document_cursor.delete_previous_char
    document_cursor.insert_text("a")
    document_cursor.clear_selection
    text_edit.insert_html("<b> Delta</b>")
    text_edit.insert_plain_text(" Epsilon")
    found_omega = rich_document.find("Omega")
    found_units = plain_document.find("Units")
    missing_text = rich_document.find("Missing")
    found_omega.replace_selected_text("Omega")
    text_edit.can_undo?.should be_true
    text_edit.undo
    text_edit.can_redo?.should be_true
    text_edit.redo
    plain_edit.can_undo?.should be_true
    plain_edit.undo
    plain_edit.can_redo?.should be_true
    plain_edit.redo
    text_edit.select_all
    selected_rich_text = text_edit.text_cursor
    selected_rich_text.has_selection?.should be_true
    selected_rich_text.release
    plain_edit.select_all
    selected_plain_text = plain_edit.text_cursor
    selected_plain_text.has_selection?.should be_true
    selected_plain_text.release
    application.process_events

    rich_document.default_style_sheet.should contain("#333")
    rich_document.title.should eq("Layer Notes")
    rich_document.undo_redo_enabled?.should be_true
    rich_document.plain_text.should contain("Omega beta!")
    rich_document.plain_text.should contain("Gamma")
    rich_document.empty?.should be_false
    rich_document.block_count.should be >= 1
    rich_document.character_count.should be > 0
    rich_document.modified?.should be_true

    document_cursor.position.should eq(5)
    document_cursor.has_selection?.should be_false
    document_cursor.selection_start.should eq(5)
    document_cursor.selection_end.should eq(5)
    document_cursor.selected_text.should eq("")
    document_cursor.at_end?.should be_false
    found_omega.null?.should be_false
    found_omega.selected_text.should eq("")
    found_units.null?.should be_false
    found_units.selected_text.should eq("Units")
    missing_text.null?.should be_true

    text_edit.accept_rich_text?.should be_true
    text_edit.undo_redo_enabled?.should be_true
    text_edit.read_only?.should be_false
    text_edit.placeholder_text.should eq("Describe the selected layer")
    text_edit.plain_text.should contain("Omega beta!")
    text_edit.plain_text.should contain("Gamma")
    text_edit.plain_text.should contain("Delta Epsilon")
    text_edit.can_undo?.should be_true
    text_edit.document.plain_text.should eq(text_edit.plain_text)
    rich_text_changes.should be >= 1

    plain_document.plain_text.should contain("Terrain")
    plain_document.plain_text.should contain("Units")
    plain_document.plain_text.should contain("Roads")
    plain_document.plain_text.should contain("Supply")
    plain_edit.undo_redo_enabled?.should be_true
    plain_edit.read_only?.should be_false
    plain_edit.placeholder_text.should eq("Notes")
    plain_edit.plain_text.should contain("Units")
    plain_edit.plain_text.should contain("Roads")
    plain_edit.can_undo?.should be_true
    plain_edit.document.plain_text.should eq(plain_edit.plain_text)
    plain_text_changes.should be >= 1

    missing_text.release
    found_units.release
    found_omega.release
    editor_cursor.release
    plain_cursor.release
    document_cursor.release
    host.release
  end

  it "provides QObject-derived signals and timer callbacks" do
    application = app
    timer = Qt6::QTimer.new
    destroyed = 0
    fired = 0

    timer.destroyed.connect do
      destroyed += 1
    end

    timer.on_timeout do
      fired += 1
    end

    timer.single_shot = true
    timer.start(0)

    10.times do
      application.process_events
      break if fired == 1
    end

    fired.should eq(1)
    timer.active?.should be_false
    timer.release
    destroyed.should eq(1)
  end

  it "keeps parent-owned QObject wrappers alive until Qt destroys them" do
    app
    content_destroyed = 0
    layout_destroyed = 0
    scroll_area = Qt6::ScrollArea.new

    begin
      content = Qt6::Widget.new
      layout = Qt6::VBoxLayout.new(content)
      content.destroyed.connect { content_destroyed += 1 }
      layout.destroyed.connect { layout_destroyed += 1 }
      scroll_area.widget = content
    end

    GC.collect
    scroll_area.release

    content_destroyed.should eq(1)
    layout_destroyed.should eq(1)
  end

  it "supports nested event loops driven by timers" do
    app
    exit_loop = Qt6::QEventLoop.new
    exit_timer = Qt6::QTimer.new(exit_loop)
    exit_codes = [] of Int32

    exit_timer.single_shot = true
    exit_timer.on_timeout do
      exit_loop.running?.should be_true
      exit_codes << exit_loop.exit(23)
    end
    exit_timer.start(0)

    exit_loop.running?.should be_false
    exit_loop.run.should eq(23)
    exit_loop.running?.should be_false
    exit_codes.should eq([23])

    quit_loop = Qt6::QEventLoop.new
    quit_timer = Qt6::QTimer.new(quit_loop)
    quit_timer.single_shot = true
    quit_timer.on_timeout do
      quit_loop.running?.should be_true
      quit_loop.quit
    end
    quit_timer.start(0)

    quit_loop.run.should eq(0)
    quit_loop.running?.should be_false
  end

  it "supports list and tree widgets for editor panels" do
    application = app
    list_widget = Qt6::ListWidget.new
    tree_widget = Qt6::TreeWidget.new
    row_changes = [] of Int32
    tree_changes = 0

    list_widget.on_current_row_changed do |row|
      row_changes << row
    end

    terrain_item = list_widget.add_item("Terrain")
    unit_item = Qt6::ListWidgetItem.new("Units")
    list_widget.add_item(unit_item)
    list_widget.current_row = 1

    tree_widget.on_current_item_changed do
      tree_changes += 1
    end

    tree_widget.column_count = 2
    tree_widget.header_label = "Layer"
    tree_widget.set_header_label(1, "State")
    root_item = tree_widget.add_top_level_item("Terrain")
    root_item.set_text(1, "Visible")
    child_item = Qt6::TreeWidgetItem.new("Contours")
    child_item.set_text(1, "Locked")
    root_item.add_child(child_item)
    overlay_item = Qt6::TreeWidgetItem.new("Units")
    overlay_item.set_text(1, "Hidden")
    tree_widget.add_top_level_item(overlay_item)
    tree_widget.current_item = child_item
    tree_widget.expand_all
    application.process_events

    list_widget.count.should eq(2)
    terrain_item.text.should eq("Terrain")
    list_widget.item(1).not_nil!.text.should eq("Units")
    list_widget.item_text(0).should eq("Terrain")
    list_widget.current_row.should eq(1)
    list_widget.current_item.not_nil!.text.should eq("Units")
    list_widget.current_text.should eq("Units")
    row_changes.last.should eq(1)

    tree_widget.column_count.should eq(2)
    tree_widget.header_label.should eq("Layer")
    tree_widget.header_label(1).should eq("State")
    tree_widget.top_level_item_count.should eq(2)
    tree_widget.top_level_item(0).not_nil!.text.should eq("Terrain")
    root_item.child_count.should eq(1)
    root_item.child(0).not_nil!.text.should eq("Contours")
    root_item.child(0).not_nil!.text(1).should eq("Locked")
    tree_widget.current_item.not_nil!.text.should eq("Contours")
    tree_widget.current_item_text(1).should eq("Locked")
    tree_changes.should be >= 1

    list_widget.clear
    tree_widget.collapse_all
    tree_widget.clear

    list_widget.count.should eq(0)
    tree_widget.top_level_item_count.should eq(0)
    list_widget.release
    tree_widget.release
  end

  it "supports advanced list widget item hooks and reorder state" do
    application = app
    list_widget = Qt6::ListWidget.new
    list_widget.resize(240, 180)
    list_widget.show

    changed_texts = [] of String
    double_clicked_texts = [] of String
    rows_moved = 0

    list_widget.on_item_changed do |item|
      changed_texts << item.text
    end

    list_widget.on_item_double_clicked do |item|
      double_clicked_texts << item.text
    end

    list_widget.on_rows_moved do
      rows_moved += 1
    end

    list_widget.drag_drop_mode = Qt6::ItemViewDragDropMode::InternalMove
    list_widget.selection_mode = Qt6::ItemSelectionMode::ExtendedSelection
    list_widget.default_drop_action = Qt6::DropAction::MoveAction

    terrain_item = Qt6::ListWidgetItem.new(Qt6::QIcon.new, "Terrain")
    terrain_item.flags = Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable | Qt6::ItemFlag::UserCheckable | Qt6::ItemFlag::DragEnabled | Qt6::ItemFlag::DropEnabled
    terrain_item.check_state = Qt6::CheckState::Checked
    terrain_item.set_data("ground", Qt6::ItemDataRole::User)
    terrain_item.foreground = Qt6::Color.new(32, 96, 192)
    list_widget.add_item(terrain_item)
    list_widget.add_item("Units")
    list_widget.add_item("Roads")
    application.process_events

    terrain_item.text = "Terrain Layer"
    application.process_events

    list_widget.move_item(0, 2).should be_true
    application.process_events
    Qt6::LibQt6.qt6cr_list_widget_emit_item_double_clicked(list_widget.to_unsafe, 2)
    application.process_events

    list_widget.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::InternalMove)
    list_widget.selection_mode.should eq(Qt6::ItemSelectionMode::ExtendedSelection)
    list_widget.default_drop_action.should eq(Qt6::DropAction::MoveAction)
    terrain_item.flags.includes?(Qt6::ItemFlag::Editable).should be_true
    terrain_item.flags.includes?(Qt6::ItemFlag::UserCheckable).should be_true
    terrain_item.check_state.should eq(Qt6::CheckState::Checked)
    terrain_item.data(Qt6::ItemDataRole::User).should eq("ground")
    terrain_item.foreground.should eq(Qt6::Color.new(32, 96, 192, 255))
    changed_texts.includes?("Terrain Layer").should be_true
    list_widget.item_text(2).should eq("Terrain Layer")
    double_clicked_texts.should eq(["Terrain Layer"])
    rows_moved.should be >= 1

    list_widget.release
  end

  it "supports item-view editor polish for widgets and model views" do
    application = app
    list_widget = Qt6::ListWidget.new
    tree_widget = Qt6::TreeWidget.new
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new
    list_model = Qt6::StandardItemModel.new(list_view)
    tree_model = Qt6::StandardItemModel.new(tree_view)

    list_widget.spacing = 2

    tree_widget.header_hidden = true
    category_item = Qt6::TreeWidgetItem.new("Guides")
    category_item.flags = category_item.flags & ~Qt6::ItemFlag::Selectable
    category_font = category_item.font
    category_font.bold = true
    category_item.font = category_font
    category_item.foreground = Qt6::Color.new(90, 90, 90)
    category_item << Qt6::TreeWidgetItem.new("  Layers")
    tree_widget << category_item
    tree_widget.expand_all

    list_model << Qt6::StandardItem.new("Terrain")
    list_model << Qt6::StandardItem.new("Units")

    root_item = Qt6::StandardItem.new("Terrain")
    root_item.set_child(0, 0, Qt6::StandardItem.new("Contours"))
    tree_model << root_item

    list_view.model = list_model
    list_view.selection_mode = Qt6::ItemSelectionMode::SingleSelection
    list_view.alternating_row_colors = true

    tree_view.model = tree_model
    tree_view.selection_mode = Qt6::ItemSelectionMode::SingleSelection
    tree_view.alternating_row_colors = true
    tree_view.header_hidden = true
    tree_view.root_is_decorated = false
    tree_view.uniform_row_heights = true
    tree_view.indentation = 14
    tree_view.expand_all
    application.process_events

    list_widget.spacing.should eq(2)
    tree_widget.header_hidden?.should be_true
    category_item.flags.includes?(Qt6::ItemFlag::Selectable).should be_false
    category_item.font.bold?.should be_true
    category_item.foreground.should eq(Qt6::Color.new(90, 90, 90, 255))
    category_item.child_count.should eq(1)

    list_view.selection_mode.should eq(Qt6::ItemSelectionMode::SingleSelection)
    list_view.alternating_row_colors?.should be_true
    tree_view.selection_mode.should eq(Qt6::ItemSelectionMode::SingleSelection)
    tree_view.alternating_row_colors?.should be_true
    tree_view.header_hidden?.should be_true
    tree_view.root_is_decorated?.should be_false
    tree_view.uniform_row_heights?.should be_true
    tree_view.indentation.should eq(14)

    list_view.release
    tree_view.release
    list_widget.release
    tree_widget.release
  end

  it "supports model-view panels with roles, delegates, and proxy sorting/filtering" do
    application = app
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new
    list_model = Qt6::StandardItemModel.new(list_view)
    tree_model = Qt6::StandardItemModel.new(tree_view)
    proxy_model = Qt6::SortFilterProxyModel.new(list_view)
    delegate = Qt6::StyledItemDelegate.new(list_view)
    list_changes = 0
    tree_changes = 0

    list_view.on_current_index_changed do
      list_changes += 1
    end

    tree_view.on_current_index_changed do
      tree_changes += 1
    end

    terrain_list_item = Qt6::StandardItem.new("Terrain")
    terrain_list_item.set_data("Terrain tools", Qt6::ItemDataRole::ToolTip)
    terrain_list_item.set_data(20, Qt6::ItemDataRole::User)
    units_list_item = Qt6::StandardItem.new("Units")
    units_list_item.set_data(Qt6::Color.new(0, 64, 192), Qt6::ItemDataRole::Foreground)
    units_list_item.set_data(10, Qt6::ItemDataRole::User)
    list_model << terrain_list_item
    list_model << units_list_item

    tree_model.set_horizontal_header_label(0, "Layer")
    tree_model.set_horizontal_header_label(1, "State")
    terrain_item = Qt6::StandardItem.new("Terrain")
    terrain_state = Qt6::StandardItem.new("Visible")
    tree_model.set_item(0, 0, terrain_item)
    tree_model.set_item(0, 1, terrain_state)
    contour_item = Qt6::StandardItem.new("Contours")
    contour_state = Qt6::StandardItem.new("Locked")
    terrain_item.set_child(0, 0, contour_item)
    terrain_item.set_child(0, 1, contour_state)

    terrain_state_index = tree_model.index(0, 1)
    tree_model.set_data(terrain_state_index, "Shown", Qt6::ItemDataRole::Edit).should be_true

    delegate.on_display_text do |text|
      ">> #{text.upcase}"
    end

    proxy_model.source_model = list_model
    proxy_model.sort_role = Qt6::ItemDataRole::User
    proxy_model.filter_role = Qt6::ItemDataRole::Display
    proxy_model.filter_case_sensitivity = Qt6::CaseSensitivity::Insensitive
    proxy_model.dynamic_sort_filter = true
    proxy_model.sort
    proxy_model.sort_column.should eq(0)
    proxy_model.sort_order.should eq(Qt6::SortOrder::Ascending)

    list_view.model = proxy_model
    list_view.item_delegate = delegate
    tree_view.model = tree_model
    tree_view.expand_all

    list_index = proxy_model.index(0)
    tree_index = tree_model.index_from_item(contour_item)
    list_view.current_index = list_index
    tree_view.current_index = tree_index
    application.process_events

    current_list_index = list_view.current_index
    current_tree_index = tree_view.current_index
    source_list_index = proxy_model.map_to_source(current_list_index)

    list_model.row_count.should eq(2)
    list_model.column_count.should eq(1)
    list_model.item(0).not_nil!.text.should eq("Terrain")
    terrain_list_item.data(Qt6::ItemDataRole::ToolTip).should eq("Terrain tools")
    units_list_item.data(Qt6::ItemDataRole::Foreground).should eq(Qt6::Color.new(0, 64, 192, 255))
    list_model.data(source_list_index, Qt6::ItemDataRole::User).should eq(10)
    proxy_model.data(current_list_index).should eq("Units")
    delegate.display_text(proxy_model.data(current_list_index)).should eq(">> UNITS")
    current_list_index.valid?.should be_true
    current_list_index.row.should eq(0)
    current_list_index.column.should eq(0)
    source_list_index.row.should eq(1)
    list_changes.should be >= 1

    proxy_model.filter_regular_expression = "uni.*"
    proxy_model.filter_pattern.should eq("uni.*")
    proxy_model.invalidate
    application.process_events
    proxy_model.row_count.should eq(1)
    proxy_model.clear_filter
    proxy_model.invalidate
    proxy_model.sort(0, Qt6::SortOrder::Descending)
    application.process_events
    proxy_model.row_count.should eq(2)
    proxy_model.sort_column.should eq(0)
    proxy_model.sort_order.should eq(Qt6::SortOrder::Descending)
    sorted_proxy_index = proxy_model.index(0)
    proxy_model.data(sorted_proxy_index).should eq("Terrain")

    tree_proxy = Qt6::SortFilterProxyModel.new(tree_view)
    tree_proxy.source_model = tree_model
    tree_proxy.filter_case_sensitivity = Qt6::CaseSensitivity::Insensitive
    tree_proxy.recursive_filtering_enabled = true
    tree_proxy.filter_regular_expression = "contour"
    tree_proxy.invalidate
    application.process_events

    terrain_proxy_index = tree_proxy.index(0, 0)
    contour_proxy_index = tree_proxy.index(0, 0, terrain_proxy_index)
    contour_source_index = tree_proxy.map_to_source(contour_proxy_index)
    contour_proxy_roundtrip = tree_proxy.map_from_source(tree_model.index_from_item(contour_item))

    tree_model.row_count.should eq(1)
    tree_model.column_count.should eq(2)
    tree_model.horizontal_header_label.should eq("Layer")
    tree_model.horizontal_header_label(1).should eq("State")
    tree_model.data(terrain_state_index).should eq("Shown")
    terrain_item.row_count.should eq(1)
    terrain_item.child(0).not_nil!.text.should eq("Contours")
    terrain_item.child(0, 1).not_nil!.text.should eq("Locked")
    current_tree_index.valid?.should be_true
    current_tree_index.row.should eq(0)
    current_tree_index.column.should eq(0)
    tree_model.item_from_index(current_tree_index).not_nil!.text.should eq("Contours")
    tree_changes.should be >= 1
    tree_proxy.recursive_filtering_enabled?.should be_true
    tree_proxy.filter_pattern.should eq("contour")
    tree_proxy.row_count.should eq(1)
    tree_proxy.row_count(terrain_proxy_index).should eq(1)
    tree_proxy.data(terrain_proxy_index).should eq("Terrain")
    tree_proxy.data(contour_proxy_index).should eq("Contours")
    tree_model.data(contour_source_index).should eq("Contours")
    contour_proxy_roundtrip.valid?.should be_true
    contour_proxy_roundtrip.row.should eq(0)

    contour_proxy_roundtrip.release
    contour_source_index.release
    contour_proxy_index.release
    terrain_proxy_index.release
    sorted_proxy_index.release
    tree_proxy.release
    current_list_index.release
    current_tree_index.release
    source_list_index.release
    terrain_state_index.release
    list_index.release
    tree_index.release
    list_view.release
    tree_view.release
  end

  it "supports model drag sources and model-view drops" do
    application = app
    model = DraggableLayerListModel.new(["Terrain", "Units", "Roads"])
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new

    list_view.model = model
    tree_view.model = model

    list_view.drag_enabled = true
    list_view.drag_drop_mode = Qt6::ItemViewDragDropMode::InternalMove
    list_view.default_drop_action = Qt6::DropAction::MoveAction
    list_view.drop_indicator_shown = true
    list_view.accept_drops = true

    tree_view.drag_enabled = true
    tree_view.drag_drop_mode = Qt6::ItemViewDragDropMode::DragDrop
    tree_view.default_drop_action = Qt6::DropAction::MoveAction
    tree_view.drop_indicator_shown = true
    tree_view.accept_drops = true

    dragged_index = model.index(1)
    payload = model.mime_data([dragged_index]).not_nil!

    payload.text.should eq("Units")
    payload.has_format?(DraggableLayerListModel::MIME_TYPE).should be_true
    String.new(payload.data(DraggableLayerListModel::MIME_TYPE)).should eq("Units")
    model.mime_types.should eq([DraggableLayerListModel::MIME_TYPE, "text/plain"])
    model.supported_drag_actions.includes?(Qt6::DropAction::MoveAction).should be_true
    model.supported_drop_actions.includes?(Qt6::DropAction::MoveAction).should be_true

    model.drop_mime_data(payload, Qt6::DropAction::MoveAction, 0).should be_true
    application.process_events

    model.layers.should eq(["Units", "Terrain", "Roads"])
    list_view.drag_enabled?.should be_true
    list_view.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::InternalMove)
    list_view.default_drop_action.should eq(Qt6::DropAction::MoveAction)
    list_view.drop_indicator_shown?.should be_true
    list_view.accept_drops?.should be_true
    tree_view.drag_enabled?.should be_true
    tree_view.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::DragDrop)
    tree_view.default_drop_action.should eq(Qt6::DropAction::MoveAction)
    tree_view.drop_indicator_shown?.should be_true
    tree_view.accept_drops?.should be_true
    model.data(model.index(0)).should eq("Units")

    payload.release
    dragged_index.release
    list_view.release
    tree_view.release
  end

  it "supports table views and table widgets" do
    application = app
    table_view = Qt6::TableView.new
    table_widget = Qt6::TableWidget.new
    model = Qt6::StandardItemModel.new(table_view)
    current_index_changes = 0
    current_cell_changes = 0
    changed_item_texts = [] of String

    table_view.on_current_index_changed do
      current_index_changes += 1
    end

    table_widget.on_current_cell_changed do
      current_cell_changes += 1
    end

    table_widget.on_item_changed do |item|
      changed_item_texts << item.text
    end

    model.set_horizontal_header_label(0, "Layer")
    model.set_horizontal_header_label(1, "State")
    model.set_item(0, 0, Qt6::StandardItem.new("Terrain"))
    model.set_item(0, 1, Qt6::StandardItem.new("Visible"))
    model.set_item(1, 0, Qt6::StandardItem.new("Units"))
    model.set_item(1, 1, Qt6::StandardItem.new("Hidden"))

    table_view.model = model
    table_view.selection_mode = Qt6::ItemSelectionMode::SingleSelection
    table_view.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
    table_view.alternating_row_colors = true
    table_view.show_grid = false
    table_view.word_wrap = false
    table_view.sorting_enabled = true
    table_view.drag_enabled = true
    table_view.drag_drop_mode = Qt6::ItemViewDragDropMode::DragOnly
    table_view.default_drop_action = Qt6::DropAction::CopyAction
    table_view.drop_indicator_shown = true

    horizontal_header = table_view.horizontal_header
    horizontal_header.default_section_size = 96
    horizontal_header.stretch_last_section = true
    horizontal_header.set_section_resize_mode(0, Qt6::HeaderResizeMode::Fixed)
    horizontal_header.resize_section(0, 120)
    vertical_header = table_view.vertical_header
    vertical_header.set_section_hidden(1, true)

    selected_index = model.index(1, 1)
    table_view.current_index = selected_index
    table_view.set_span(0, 0, 1, 2)
    table_view.sort_by_column(0, Qt6::SortOrder::Descending)
    table_view.resize_columns_to_contents
    table_view.resize_rows_to_contents

    table_widget.row_count = 2
    table_widget.column_count = 2
    table_widget.set_horizontal_header_label(0, "Layer")
    table_widget.set_horizontal_header_label(1, "Visible")
    table_widget.set_vertical_header_label(0, "Base")
    table_widget.set_vertical_header_label(1, "Overlay")
    table_widget.selection_mode = Qt6::ItemSelectionMode::SingleSelection
    table_widget.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
    table_widget.alternating_row_colors = true
    table_widget.show_grid = false

    terrain_item = Qt6::TableWidgetItem.new("Terrain")
    terrain_item.flags = Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable
    terrain_item.set_data("terrain", Qt6::ItemDataRole::User)
    visible_item = Qt6::TableWidgetItem.new("Shown")
    visible_item.check_state = Qt6::CheckState::Checked
    visible_item.foreground = Qt6::Color.new(24, 120, 48)

    table_widget.set_item(0, 0, terrain_item)
    table_widget.set_item(0, 1, visible_item)
    terrain_item.text = "Terrain Layer"
    table_widget.set_span(1, 0, 1, 2)
    table_widget.set_current_cell(0, 1)
    table_widget.sort_by_column(0, Qt6::SortOrder::Descending)
    table_widget.resize_columns_to_contents
    table_widget.resize_rows_to_contents
    application.process_events

    current_index = table_view.current_index

    table_view.selection_mode.should eq(Qt6::ItemSelectionMode::SingleSelection)
    table_view.selection_behavior.should eq(Qt6::ItemSelectionBehavior::SelectRows)
    table_view.alternating_row_colors?.should be_true
    table_view.show_grid?.should be_false
    table_view.word_wrap?.should be_false
    table_view.sorting_enabled?.should be_true
    table_view.drag_enabled?.should be_true
    table_view.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::DragOnly)
    table_view.default_drop_action.should eq(Qt6::DropAction::CopyAction)
    table_view.drop_indicator_shown?.should be_true
    current_index.valid?.should be_true
    current_index.row.should eq(1)
    current_index.column.should eq(1)
    current_index_changes.should be >= 1
    horizontal_header.count.should eq(2)
    horizontal_header.default_section_size.should eq(96)
    horizontal_header.stretch_last_section?.should be_true
    horizontal_header.section_size(0).should be > 0
    horizontal_header.section_resize_mode(0).should eq(Qt6::HeaderResizeMode::Fixed)
    vertical_header.count.should eq(2)
    vertical_header.section_hidden?(1).should be_true
    table_view.row_span(0, 0).should eq(1)
    table_view.column_span(0, 0).should eq(2)
    first_sorted_index = model.index(0, 0)
    model.data(first_sorted_index).should eq("Units")

    table_widget.row_count.should eq(2)
    table_widget.column_count.should eq(2)
    table_widget.horizontal_header_label.should eq("Layer")
    table_widget.horizontal_header_label(1).should eq("Visible")
    table_widget.vertical_header_label.should eq("Base")
    table_widget.vertical_header_label(1).should eq("Overlay")
    table_widget.selection_mode.should eq(Qt6::ItemSelectionMode::SingleSelection)
    table_widget.selection_behavior.should eq(Qt6::ItemSelectionBehavior::SelectRows)
    table_widget.alternating_row_colors?.should be_true
    table_widget.show_grid?.should be_false
    table_widget.current_row.should eq(0)
    table_widget.current_column.should eq(1)
    table_widget.current_item.not_nil!.text.should eq("Shown")
    table_widget.item(0, 0).not_nil!.text.should eq("Terrain Layer")
    table_widget.item(0, 0).not_nil!.data(Qt6::ItemDataRole::User).should eq("terrain")
    table_widget.item(0, 1).not_nil!.check_state.should eq(Qt6::CheckState::Checked)
    table_widget.item(0, 1).not_nil!.foreground.should eq(Qt6::Color.new(24, 120, 48, 255))
    current_cell_changes.should be >= 1
    changed_item_texts.includes?("Terrain Layer").should be_true
    table_widget.horizontal_header.count.should eq(2)
    table_widget.horizontal_header.section_size(0).should be > 0
    table_widget.vertical_header.count.should eq(2)
    table_widget.row_span(1, 0).should eq(1)
    table_widget.column_span(1, 0).should eq(2)

    first_sorted_index.release
    current_index.release
    selected_index.release
    table_view.release
    table_widget.release
  end

  it "supports custom delegate editor creation and commit hooks" do
    app
    host = Qt6::Widget.new
    model = Qt6::StandardItemModel.new(host)
    item = Qt6::StandardItem.new("terrain")
    model << item
    index = model.index(0)
    delegate = Qt6::StyledItemDelegate.new(host)
    created_editors = [] of Qt6::LineEdit
    populated_values = [] of Qt6::ModelData
    committed_values = [] of String

    delegate.on_create_editor do |parent, editor_index|
      editor_index.row.should eq(0)
      editor = Qt6::LineEdit.new(parent: parent)
      created_editors << editor
      editor
    end

    delegate.on_set_editor_data do |editor, value, editor_index|
      editor_index.column.should eq(0)
      line_edit = editor.as(Qt6::LineEdit)
      populated_values << value
      line_edit.text = "#{value}-editor"
    end

    delegate.on_set_model_data do |editor, target_model, editor_index|
      line_edit = editor.as(Qt6::LineEdit)
      committed_values << line_edit.text
      target_model.set_data(editor_index, line_edit.text.upcase)
    end

    editor = delegate.create_editor(host, index)
    editor.should be_a(Qt6::LineEdit)
    line_edit = editor.as(Qt6::LineEdit)
    delegate.set_editor_data(line_edit, index)
    line_edit.text.should eq("terrain-editor")
    line_edit.text = "contours"
    delegate.set_model_data(line_edit, model, index)

    created_editors.size.should eq(1)
    populated_values.should eq(["terrain"])
    committed_values.should eq(["contours"])
    model.data(index).should eq("CONTOURS")

    index.release
    host.release
  end

  it "supports edit triggers and persistent editors in item views" do
    application = app
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new
    table_view = Qt6::TableView.new
    table_widget = Qt6::TableWidget.new

    list_model = Qt6::StandardItemModel.new(list_view)
    list_model << Qt6::StandardItem.new("Terrain")

    tree_model = Qt6::StandardItemModel.new(tree_view)
    branch = Qt6::StandardItem.new("Units")
    branch.append_row(Qt6::StandardItem.new("Infantry"))
    tree_model.append_row(branch)

    table_model = Qt6::StandardItemModel.new(table_view)
    table_model.set_item(0, 0, Qt6::StandardItem.new("Layer"))

    delegate = Qt6::StyledItemDelegate.new(list_view)
    delegate.on_create_editor do |parent, _index|
      Qt6::LineEdit.new(parent: parent)
    end

    list_view.model = list_model
    tree_view.model = tree_model
    table_view.model = table_model

    list_view.item_delegate = delegate
    tree_view.item_delegate = delegate
    table_view.item_delegate = delegate

    list_index = list_model.index(0)
    tree_index = tree_model.index(0, 0)
    table_index = table_model.index(0, 0)

    list_view.edit_triggers = Qt6::EditTrigger::DoubleClicked | Qt6::EditTrigger::EditKeyPressed
    tree_view.edit_triggers = Qt6::EditTrigger::CurrentChanged | Qt6::EditTrigger::SelectedClicked
    table_view.edit_triggers = Qt6::EditTrigger::AllEditTriggers

    list_view.open_persistent_editor(list_index)
    tree_view.open_persistent_editor(tree_index)
    table_view.open_persistent_editor(table_index)

    table_widget.row_count = 1
    table_widget.column_count = 1
    table_widget.edit_triggers = Qt6::EditTrigger::AnyKeyPressed | Qt6::EditTrigger::EditKeyPressed
    table_item = Qt6::TableWidgetItem.new("Visible")
    table_widget.set_item(0, 0, table_item)
    table_widget.open_persistent_editor(table_item)

    application.process_events

    list_view.edit_triggers.should eq(Qt6::EditTrigger::DoubleClicked | Qt6::EditTrigger::EditKeyPressed)
    tree_view.edit_triggers.should eq(Qt6::EditTrigger::CurrentChanged | Qt6::EditTrigger::SelectedClicked)
    table_view.edit_triggers.should eq(Qt6::EditTrigger::AllEditTriggers)
    table_widget.edit_triggers.should eq(Qt6::EditTrigger::AnyKeyPressed | Qt6::EditTrigger::EditKeyPressed)

    list_view.persistent_editor_open?(list_index).should be_true
    tree_view.persistent_editor_open?(tree_index).should be_true
    table_view.persistent_editor_open?(table_index).should be_true
    table_widget.persistent_editor_open?(table_item).should be_true

    list_view.close_persistent_editor(list_index)
    tree_view.close_persistent_editor(tree_index)
    table_view.close_persistent_editor(table_index)
    table_widget.close_persistent_editor(table_item)

    application.process_events

    list_view.persistent_editor_open?(list_index).should be_false
    tree_view.persistent_editor_open?(tree_index).should be_false
    table_view.persistent_editor_open?(table_index).should be_false
    table_widget.persistent_editor_open?(table_item).should be_false

    list_index.release
    tree_index.release
    table_index.release
    list_view.release
    tree_view.release
    table_view.release
    table_widget.release
  end

  it "supports proxy headers and shared selection models across views" do
    application = app
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new
    source_model = Qt6::StandardItemModel.new(list_view)
    proxy_model = Qt6::SortFilterProxyModel.new(list_view)
    source_model << Qt6::StandardItem.new("Terrain")
    source_model << Qt6::StandardItem.new("Units")
    source_model.set_header_data(0, "Panel", Qt6::Orientation::Horizontal).should be_true
    proxy_model.source_model = source_model
    list_view.model = proxy_model
    tree_view.model = proxy_model

    shared_selection = Qt6::ItemSelectionModel.new(proxy_model, list_view)
    selection_changes = 0
    list_changes = 0
    tree_changes = 0

    shared_selection.on_current_index_changed do
      selection_changes += 1
    end

    list_view.on_current_index_changed do
      list_changes += 1
    end

    tree_view.on_current_index_changed do
      tree_changes += 1
    end

    list_view.selection_model = shared_selection
    tree_view.selection_model = shared_selection

    units_index = proxy_model.index(1)
    list_view.current_index = units_index
    application.process_events

    proxy_model.header_data.should eq("Panel")
    list_view.selection_model.not_nil!.current_index.row.should eq(1)
    tree_view.selection_model.not_nil!.current_index.row.should eq(1)
    tree_view.current_index.row.should eq(1)
    selection_changes.should be >= 1
    list_changes.should be >= 1
    tree_changes.should be >= 1

    units_index.release
    list_view.release
    tree_view.release
  end

  it "supports selection-model commands and model-index convenience helpers" do
    application = app
    list_view = Qt6::ListView.new
    model = Qt6::StandardItemModel.new(list_view)
    model << Qt6::StandardItem.new("Terrain")
    model << Qt6::StandardItem.new("Units")
    list_view.model = model

    selection_model = Qt6::ItemSelectionModel.new(model, list_view)
    list_view.selection_model = selection_model

    terrain_index = model.index(0)
    units_index = model.index(1)
    parent_index = units_index.parent(model)

    units_index.data(model).should eq("Units")
    units_index.set_data(model, "Counter").should be_true
    units_index.data(model).should eq("Counter")
    units_index.flags(model).should eq(model.flags(units_index))
    parent_index.valid?.should be_false

    selection_model.current_index.valid?.should be_false

    selection_model.current_index = terrain_index
    application.process_events
    selection_model.current_index.row.should eq(0)

    selection_model.select(units_index, Qt6::SelectionFlag::ClearAndSelect)
    application.process_events

    selection_model.current_index.row.should eq(0)
    selection_model.has_selection?.should be_true
    selection_model.selected?(units_index).should be_true
    selection_model.selected?(terrain_index).should be_false

    selection_model.set_current_index(units_index, Qt6::SelectionFlag::Current)
    application.process_events
    selection_model.current_index.row.should eq(1)

    selection_model.clear_selection
    application.process_events
    selection_model.has_selection?.should be_false

    selection_model.clear
    application.process_events
    selection_model.current_index.valid?.should be_false

    terrain_index.release
    units_index.release
    parent_index.release
    list_view.release
  end

  it "shares abstract item-view coverage across item-based widgets" do
    application = app
    list_widget = Qt6::ListWidget.new
    tree_widget = Qt6::TreeWidget.new
    table_widget = Qt6::TableWidget.new

    list_widget << "Terrain"
    list_widget << "Units"
    tree_widget.column_count = 1
    tree_root = Qt6::TreeWidgetItem.new("Layers")
    tree_widget << tree_root
    table_widget.row_count = 1
    table_widget.column_count = 1
    table_widget.set_item(0, 0, Qt6::TableWidgetItem.new("Visible"))

    list_widget.selection_mode = Qt6::ItemSelectionMode::ExtendedSelection
    list_widget.drag_enabled = true
    list_widget.drag_drop_mode = Qt6::ItemViewDragDropMode::InternalMove
    list_widget.default_drop_action = Qt6::DropAction::MoveAction
    list_widget.drop_indicator_shown = true
    list_widget.edit_triggers = Qt6::EditTrigger::SelectedClicked

    tree_widget.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
    tree_widget.alternating_row_colors = true
    tree_widget.drag_enabled = true
    tree_widget.drop_indicator_shown = true

    table_widget.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
    table_widget.alternating_row_colors = true

    list_widget.current_row = 1
    tree_widget.current_item = tree_root
    table_widget.set_current_cell(0, 0)
    application.process_events

    list_index = list_widget.current_index
    tree_index = tree_widget.current_index
    table_index = table_widget.current_index

    list_widget.selection_mode.should eq(Qt6::ItemSelectionMode::ExtendedSelection)
    list_widget.drag_enabled?.should be_true
    list_widget.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::InternalMove)
    list_widget.default_drop_action.should eq(Qt6::DropAction::MoveAction)
    list_widget.drop_indicator_shown?.should be_true
    list_widget.edit_triggers.should eq(Qt6::EditTrigger::SelectedClicked)
    list_widget.selection_model.should_not be_nil
    list_index.row.should eq(1)

    tree_widget.selection_behavior.should eq(Qt6::ItemSelectionBehavior::SelectRows)
    tree_widget.alternating_row_colors?.should be_true
    tree_widget.drag_enabled?.should be_true
    tree_widget.drop_indicator_shown?.should be_true
    tree_widget.selection_model.should_not be_nil
    tree_index.valid?.should be_true
    tree_index.row.should eq(0)

    table_widget.selection_behavior.should eq(Qt6::ItemSelectionBehavior::SelectRows)
    table_widget.alternating_row_colors?.should be_true
    table_widget.selection_model.should_not be_nil
    table_index.row.should eq(0)
    table_index.column.should eq(0)

    list_index.release
    tree_index.release
    table_index.release
    list_widget.release
    tree_widget.release
    table_widget.release
  end

  it "shares abstract scroll-area policies and scroll bars across descendants" do
    app
    scroll_area = Qt6::ScrollArea.new
    text_edit = Qt6::TextEdit.new("alpha\nbeta\ngamma")
    plain_text_edit = Qt6::PlainTextEdit.new("delta\nepsilon\nzeta")

    scroll_area.widget = Qt6::Label.new("Scrollable")
    scroll_area.vertical_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOff
    text_edit.horizontal_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOn
    plain_text_edit.vertical_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOn

    scroll_area.vertical_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOff)
    text_edit.horizontal_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOn)
    plain_text_edit.vertical_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOn)

    scroll_area.vertical_scroll_bar.orientation.should eq(Qt6::Orientation::Vertical)
    scroll_area.horizontal_scroll_bar.orientation.should eq(Qt6::Orientation::Horizontal)
    text_edit.vertical_scroll_bar.orientation.should eq(Qt6::Orientation::Vertical)
    plain_text_edit.horizontal_scroll_bar.orientation.should eq(Qt6::Orientation::Horizontal)

    scroll_area.release
    text_edit.release
    plain_text_edit.release
  end

  it "hosts a vertical editor slice with docks, canvas interaction, and PNG export" do
    application = app
    state = EditorVerticalSliceSpecState.new
    main = Qt6::MainWindow.new
    main.window_title = "Vertical Slice Spec"
    main.resize(960, 680)
    status_bar = main.status_bar
    canvas = Qt6::EventWidget.new
    canvas.resize(720, 480)
    export_path = File.join(Dir.tempdir, "crystal-qt6-vertical-slice-#{Process.pid}.png")

    grid_pen = Qt6::QPen.new(Qt6::Color.new(198, 206, 214), 1.0)
    frame_pen = Qt6::QPen.new(Qt6::Color.new(72, 80, 90), 2.0)
    route_pen = Qt6::QPen.new(state.accent, 3.0)
    hud_font = Qt6::QFont.new(point_size: 11, bold: true)

    scene_to_view = ->(point : Qt6::PointF) do
      Qt6::PointF.new(state.pan_x + point.x * state.zoom, state.pan_y + point.y * state.zoom)
    end

    canvas.on_mouse_press do |event|
      state.dragging = true
      state.last_pointer = event.position
    end

    canvas.on_mouse_move do |event|
      next unless state.dragging

      state.pan_x += event.position.x - state.last_pointer.x
      state.pan_y += event.position.y - state.last_pointer.y
      state.last_pointer = event.position
      canvas.update
    end

    canvas.on_mouse_release do |_event|
      state.dragging = false
    end

    canvas.on_wheel do |event|
      state.zoom = (state.zoom * (event.angle_delta.y >= 0 ? 1.1 : 0.9)).clamp(0.5, 3.0)
      canvas.update
    end

    canvas.on_paint_with_painter do |event, painter|
      painter.fill_rect(event.rect, Qt6::Color.new(245, 243, 238))

      scene_rect = Qt6::RectF.new(0.0, 0.0, 520.0, 320.0)
      painter.pen = frame_pen
      painter.brush = Qt6::Color.new(255, 255, 255)
      painter.draw_rect(Qt6::RectF.new(state.pan_x, state.pan_y, scene_rect.width * state.zoom, scene_rect.height * state.zoom))

      painter.pen = grid_pen
      x = 0
      while x <= scene_rect.width
        painter.draw_line(scene_to_view.call(Qt6::PointF.new(x.to_f, 0.0)), scene_to_view.call(Qt6::PointF.new(x.to_f, scene_rect.height)))
        x += 48
      end

      y = 0
      while y <= scene_rect.height
        painter.draw_line(scene_to_view.call(Qt6::PointF.new(0.0, y.to_f)), scene_to_view.call(Qt6::PointF.new(scene_rect.width, y.to_f)))
        y += 48
      end

      route_pen.color = state.accent
      painter.pen = route_pen
      painter.brush = state.accent
      points = case state.active_layer
               when "Units"
                 [
                   Qt6::PointF.new(96.0, 88.0),
                   Qt6::PointF.new(180.0, 156.0),
                   Qt6::PointF.new(276.0, 132.0),
                 ]
               else
                 [
                   Qt6::PointF.new(112.0, 92.0),
                   Qt6::PointF.new(210.0, 142.0),
                   Qt6::PointF.new(308.0, 118.0),
                 ]
               end.map { |point| scene_to_view.call(point) }

      points.each_cons(2) do |segment|
        painter.draw_line(segment[0], segment[1])
      end

      points.each_with_index do |point, index|
        size = 18.0 * state.zoom
        painter.draw_ellipse(Qt6::RectF.new(point.x - size / 2.0, point.y - size / 2.0, size, size))
        painter.draw_text(Qt6::PointF.new(point.x + size / 2.0 + 6.0, point.y + 4.0), "#{index + 1}")
      end

      painter.font = hud_font
      painter.pen = Qt6::Color.new(50, 56, 62)
      painter.draw_text(Qt6::PointF.new(18.0, 24.0), "Layer #{state.active_layer} | zoom #{state.zoom.round(2)}x")
    end

    main.central_widget = canvas

    layer_model = Qt6::StandardItemModel.new(main)
    terrain_item = Qt6::StandardItem.new("Terrain")
    terrain_item.set_data(10, Qt6::ItemDataRole::User)
    units_item = Qt6::StandardItem.new("Units")
    units_item.set_data(20, Qt6::ItemDataRole::User)
    layer_model.set_item(0, 0, terrain_item)
    layer_model.set_item(0, 1, Qt6::StandardItem.new("Visible"))
    layer_model.set_item(1, 0, units_item)
    layer_model.set_item(1, 1, Qt6::StandardItem.new("Visible"))
    layer_model.set_horizontal_header_label(0, "Layer")
    layer_model.set_horizontal_header_label(1, "State")

    proxy_model = Qt6::SortFilterProxyModel.new(main)
    proxy_model.source_model = layer_model
    proxy_model.sort_role = Qt6::ItemDataRole::User
    proxy_model.sort

    tree_view = Qt6::TreeView.new
    tree_view.model = proxy_model
    selection_model = Qt6::ItemSelectionModel.new(proxy_model, tree_view)
    tree_view.selection_model = selection_model
    tree_view.on_current_index_changed do
      current = tree_view.current_index
      if current.valid?
        name_index = proxy_model.index(current.row, 0)
        state.active_layer = proxy_model.data(name_index).to_s
        state.accent = state.active_layer == "Units" ? Qt6::Color.new(204, 86, 62) : Qt6::Color.new(62, 130, 109)
        status_bar.show_message("Active #{state.active_layer}", 1200)
        name_index.release
      end
      current.release
      canvas.update
    end

    layers_dock = Qt6::DockWidget.new("Layers", main)
    layers_dock.widget = Qt6::Widget.new.tap do |panel|
      panel.vbox do |column|
        column << Qt6::Label.new("Manager")
        column << tree_view
      end
    end
    main.add_dock_widget(layers_dock, Qt6::DockArea::Left)

    inspector_dock = Qt6::DockWidget.new("Inspector", main)
    inspector_dock.widget = Qt6::Widget.new.tap do |panel|
      panel.form do |form|
        form.add_row("Layer", Qt6::Label.new("Driven by the manager dock"))
        form.add_row(Qt6::PushButton.new("Reset View").tap do |button|
          button.on_clicked do
            state.zoom = 1.0
            state.pan_x = 24.0
            state.pan_y = 28.0
            canvas.update
          end
        end)
      end
    end
    main.add_dock_widget(inspector_dock, Qt6::DockArea::Right)

    file_menu = main.menu_bar.add_menu("File")
    export_action = Qt6::Action.new("Export PNG", main)
    export_action.shortcut = "Ctrl+E"
    export_action.on_triggered do
      canvas.grab.save(export_path).should be_true
      status_bar.show_message("Exported PNG", 1200)
    end
    file_menu << export_action

    toolbar = Qt6::ToolBar.new("Editor", main)
    toolbar << export_action
    main.add_tool_bar(toolbar)

    initial_index = proxy_model.index(1, 0)
    tree_view.current_index = initial_index
    initial_index.release

    main.show
    application.process_events

    zoom_before = state.zoom
    pan_x_before = state.pan_x
    pan_y_before = state.pan_y

    canvas.simulate_wheel(Qt6::PointF.new(180.0, 180.0))
    canvas.simulate_mouse_press(Qt6::PointF.new(140.0, 140.0))
    canvas.simulate_mouse_move(Qt6::PointF.new(196.0, 188.0), buttons: 1)
    canvas.simulate_mouse_release(Qt6::PointF.new(196.0, 188.0))
    5.times { application.process_events }

    export_action.trigger
    application.process_events

    png_header = File.open(export_path) do |file|
      bytes = Bytes.new(8)
      file.read_fully(bytes)
      bytes
    end

    state.active_layer.should eq("Units")
    proxy_model.header_data.should eq("Layer")
    tree_view.selection_model.not_nil!.current_index.row.should eq(1)
    state.zoom.should be > zoom_before
    state.pan_x.should be > pan_x_before
    state.pan_y.should be > pan_y_before
    File.exists?(export_path).should be_true
    png_header.should eq(Bytes[0x89_u8, 0x50_u8, 0x4E_u8, 0x47_u8, 0x0D_u8, 0x0A_u8, 0x1A_u8, 0x0A_u8])

    main.release
  end

  it "supports callback-backed abstract list models with edits and row notifications" do
    application = app
    model = EditableLayerListModel.new(["Terrain", "Units"])
    proxy = Qt6::SortFilterProxyModel.new
    proxy.source_model = model
    list_view = Qt6::ListView.new
    list_view.model = proxy

    delegate = Qt6::StyledItemDelegate.new(list_view)
    delegate.on_create_editor do |parent, _index|
      Qt6::LineEdit.new(parent: parent)
    end
    delegate.on_set_editor_data do |editor, value, _index|
      editor.as(Qt6::LineEdit).text = value.to_s
    end
    delegate.on_set_model_data do |editor, target_model, index|
      target_model.set_data(index, editor.as(Qt6::LineEdit).text).should be_true
    end
    list_view.item_delegate = delegate

    source_index = model.index(0)
    proxy_index = proxy.index(1)
    editor = delegate.create_editor(list_view, proxy_index)
    editor.should be_a(Qt6::LineEdit)
    line_edit = editor.as(Qt6::LineEdit)
    delegate.set_editor_data(line_edit, proxy_index)
    line_edit.text.should eq("Units")
    line_edit.text = "Counter"
    delegate.set_model_data(line_edit, proxy, proxy_index)
    application.process_events

    model.layers.should eq(["Terrain", "Counter"])
    proxy.data(proxy_index).should eq("Counter")
    proxy.header_data.should eq("Layer")
    model.flags(source_index).should eq(Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable)

    model.append_layer("Labels")
    application.process_events
    proxy.row_count.should eq(3)

    removed = model.remove_layer(0)
    application.process_events
    removed.should eq("Terrain")
    proxy.row_count.should eq(2)

    refreshed_index = proxy.index(0)
    proxy.data(refreshed_index).should eq("Counter")

    model.replace_layers(["Roads"])
    application.process_events
    proxy.row_count.should eq(1)

    reset_index = proxy.index(0)
    proxy.data(reset_index).should eq("Roads")

    source_index.release
    proxy_index.release
    refreshed_index.release
    reset_index.release
    list_view.release
    proxy.release
    model.release
  end

  it "supports callback-backed tree models in tree views" do
    application = app
    model = LayerTreeModel.new
    tree_view = Qt6::TreeView.new
    tree_view.model = model
    tree_view.expand_all

    terrain_index = model.index(0)
    contours_index = model.index(0, 0, terrain_index)
    units_index = model.index(1)
    parent_index = model.parent_index(contours_index)

    tree_changes = 0
    tree_view.on_current_index_changed do
      tree_changes += 1
    end

    tree_view.current_index = contours_index
    application.process_events
    model.set_data(contours_index, "Contours Overlay").should be_true
    application.process_events

    model.row_count.should eq(2)
    model.row_count(terrain_index).should eq(2)
    model.row_count(units_index).should eq(1)
    model.column_count(terrain_index).should eq(1)
    model.header_data.should eq("Layer")
    model.data(contours_index).should eq("Contours Overlay")
    parent_index.valid?.should be_true
    parent_index.row.should eq(0)
    parent_index.internal_id.should eq(1_u64)
    model.data(parent_index).should eq("Terrain")
    tree_view.current_index.internal_id.should eq(2_u64)
    tree_changes.should be >= 1

    parent_index.release
    units_index.release
    contours_index.release
    terrain_index.release
    tree_view.release
    model.release
  end

  it "supports mutable callback-backed tree models with row inserts, removals, and moves" do
    application = app
    model = MutableLayerTreeModel.new
    tree_view = Qt6::TreeView.new
    tree_view.model = model
    tree_view.expand_all

    terrain_index = model.index(0)
    terrain_index.internal_id.should eq(1_u64)

    model.append_child("Roads", terrain_index)
    application.process_events

    refreshed_terrain_index = model.index(0)
    roads_index = model.index(2, 0, refreshed_terrain_index)
    tree_view.current_index = roads_index
    application.process_events

    model.row_count(refreshed_terrain_index).should eq(3)
    model.data(roads_index).should eq("Roads")
    tree_view.current_index.internal_id.should eq(5_u64)

    model.move_child(2, 0, refreshed_terrain_index).should be_true
    application.process_events

    moved_first_index = model.index(0, 0, refreshed_terrain_index)
    model.data(moved_first_index).should eq("Roads")

    removed_label = model.remove_child(1, refreshed_terrain_index)
    application.process_events

    removed_label.should eq("Contours")
    model.row_count(refreshed_terrain_index).should eq(2)
    remaining_first_index = model.index(0, 0, refreshed_terrain_index)
    remaining_second_index = model.index(1, 0, refreshed_terrain_index)
    model.data(remaining_first_index).should eq("Roads")
    model.data(remaining_second_index).should eq("Labels")

    remaining_second_index.release
    remaining_first_index.release
    moved_first_index.release
    roads_index.release
    refreshed_terrain_index.release
    terrain_index.release
    tree_view.release
    model.release
  end

  it "supports widget event filters and no-scroll guards" do
    application = app
    host = Qt6::Widget.new
    spin_box = Qt6::SpinBox.new(host)
    spin_box.set_range(0, 10)
    spin_box.value = 5
    spin_box.focus_policy = Qt6::FocusPolicy::StrongFocus

    filter_events = [] of Int32
    filter = Qt6::EventFilter.new(host)
    filter.on_event do |watched, event|
      filter_events << event.type_value
      watched.try(&.to_unsafe) == spin_box.to_unsafe && event.type == Qt6::EventType::Wheel && !spin_box.has_focus?
    end
    spin_box.install_event_filter(filter)

    spin_box.show
    application.process_events
    spin_box.simulate_wheel(Qt6::PointF.new(10.0, 10.0))
    application.process_events

    spin_box.value.should eq(5)
    filter_events.should contain(Qt6::EventType::Wheel.value)

    spin_box.remove_event_filter(filter)
    no_scroll = Qt6::NoScrollFilter.new(host)
    spin_box.install_event_filter(no_scroll)
    spin_box.simulate_wheel(Qt6::PointF.new(10.0, 10.0))
    application.process_events
    spin_box.value.should eq(5)

    spin_box.remove_event_filter(no_scroll)
    application.process_events
    spin_box.simulate_wheel(Qt6::PointF.new(10.0, 10.0))
    application.process_events

    spin_box.value.should be > 5
    spin_box.focus_policy.should eq(Qt6::FocusPolicy::StrongFocus)

    host.release
  end

  it "exposes geometry types and custom widget event hooks" do
    application = app
    widget = Qt6::EventWidget.new
    paint_events = [] of Qt6::PaintEvent
    painter_events = [] of Qt6::PaintEvent
    resize_events = [] of Qt6::ResizeEvent
    mouse_presses = [] of Qt6::MouseEvent
    mouse_moves = [] of Qt6::MouseEvent
    mouse_releases = [] of Qt6::MouseEvent
    mouse_double_clicks = [] of Qt6::MouseEvent
    wheels = [] of Qt6::WheelEvent
    keys = [] of Qt6::KeyEvent
    key_releases = [] of Qt6::KeyEvent
    enters = [] of Qt6::WidgetEvent
    leaves = [] of Qt6::WidgetEvent
    focus_ins = [] of Qt6::WidgetEvent
    focus_outs = [] of Qt6::WidgetEvent

    widget.on_paint { |event| paint_events << event }
    widget.on_paint_with_painter do |event, painter|
      painter_events << event
      painter.active?.should be_true
      painter.fill_rect(Qt6::RectF.new(0.0, 0.0, 24.0, 16.0), Qt6::Color.new(255, 0, 0))
    end
    widget.on_resize { |event| resize_events << event }
    widget.on_mouse_press { |event| mouse_presses << event }
    widget.on_mouse_move { |event| mouse_moves << event }
    widget.on_mouse_release { |event| mouse_releases << event }
    widget.on_mouse_double_click { |event| mouse_double_clicks << event }
    widget.on_wheel { |event| wheels << event }
    widget.on_key_press { |event| keys << event }
    widget.on_key_release { |event| key_releases << event }
    widget.on_enter { |event| enters << event }
    widget.on_leave { |event| leaves << event }
    widget.on_focus_in { |event| focus_ins << event }
    widget.on_focus_out { |event| focus_outs << event }

    widget.resize(200, 120)
    widget.show
    application.process_events

    widget.repaint_now
    10.times do
      application.process_events
      break unless paint_events.empty?
    end
    widget.simulate_mouse_press(Qt6::PointF.new(10.0, 20.0))
    widget.simulate_mouse_move(Qt6::PointF.new(15.0, 25.0))
    widget.simulate_mouse_release(Qt6::PointF.new(18.0, 28.0))
    widget.simulate_mouse_double_click(Qt6::PointF.new(22.0, 32.0))
    widget.simulate_wheel(Qt6::PointF.new(20.0, 30.0), angle_delta: Qt6::PointF.new(0.0, 120.0))
    widget.simulate_key_press(65)
    widget.simulate_key_release(65)
    widget.simulate_enter(Qt6::PointF.new(4.0, 5.0))
    widget.simulate_leave
    widget.simulate_focus_in
    widget.simulate_focus_out
    application.process_events
    snapshot = widget.grab.to_image

    widget.size.should eq(Qt6::Size.new(200, 120))
    widget.rect.width.should eq(200.0)
    resize_events.last.size.should eq(Qt6::Size.new(200, 120))
    paint_events.empty?.should be_false
    painter_events.empty?.should be_false
    mouse_presses.last.position.should eq(Qt6::PointF.new(10.0, 20.0))
    mouse_moves.last.position.should eq(Qt6::PointF.new(15.0, 25.0))
    mouse_releases.last.position.should eq(Qt6::PointF.new(18.0, 28.0))
    mouse_double_clicks.last.position.should eq(Qt6::PointF.new(22.0, 32.0))
    wheels.last.angle_delta.should eq(Qt6::PointF.new(0.0, 120.0))
    keys.last.key.should eq(65)
    key_releases.last.key.should eq(65)
    enters.last.type.should eq(Qt6::EventType::Enter)
    leaves.last.type.should eq(Qt6::EventType::Leave)
    focus_ins.last.type.should eq(Qt6::EventType::FocusIn)
    focus_outs.last.type.should eq(Qt6::EventType::FocusOut)
    snapshot.pixel_color(5, 5).should eq(Qt6::Color.new(255, 0, 0, 255))
    widget.release
  end

  it "supports drop callbacks and synthetic text drops on event widgets" do
    application = app
    widget = Qt6::EventWidget.new
    drag_enter_payloads = [] of String
    drag_move_positions = [] of Qt6::PointF
    dropped_payloads = [] of String
    acceptance_states = [] of Bool

    widget.accept_drops = true
    widget.on_drag_enter do |event|
      drag_enter_payloads << event.mime_data.not_nil!.text
      event.accept_proposed_action
      acceptance_states << event.accepted?
    end
    widget.on_drag_move do |event|
      drag_move_positions << event.position
      event.accept
    end
    widget.on_drop do |event|
      dropped_payloads << event.mime_data.not_nil!.text
      event.accept_proposed_action
      acceptance_states << event.accepted?
    end

    widget.resize(180, 100)
    widget.show
    application.process_events

    widget.simulate_drag_enter_text(Qt6::PointF.new(12.0, 14.0), "terrain")
    widget.simulate_drag_move_text(Qt6::PointF.new(18.0, 24.0), "terrain")
    widget.simulate_drop_text(Qt6::PointF.new(20.0, 26.0), "terrain")
    application.process_events

    widget.accept_drops?.should be_true
    drag_enter_payloads.should eq(["terrain"])
    drag_move_positions.should eq([Qt6::PointF.new(18.0, 24.0)])
    dropped_payloads.should eq(["terrain"])
    acceptance_states.should eq([true, true])
    widget.release
  end

  it "shuts down without the Qt thread storage warning" do
    stdout = IO::Memory.new
    stderr = IO::Memory.new
    status = Process.run(
      "crystal",
      ["run", "spec/support/exit_warning_probe.cr"],
      output: stdout,
      error: stderr
    )

    status.success?.should be_true
    stderr.to_s.should_not contain("QThreadStorage: entry")
  end

  it "creates a widget with a readable title and visibility state" do
    application = app
    window = Qt6::Widget.new
    window.window_title = "Spec Window"
    window.resize(320, 180)

    window.window_title.should eq("Spec Window")
    window.visible?.should be_false

    window.show
    application.process_events
    window.visible?.should be_true

    window.visible = false
    application.process_events
    window.visible?.should be_false

    window.visible = true
    application.process_events
    window.visible?.should be_true

    window.hide
    application.process_events
    window.visible?.should be_false

    window.show
    application.process_events
    window.visible?.should be_true

    window.close
    application.process_events
    window.visible?.should be_false
    window.release
  end

  it "supports core widget sizing and tooltip controls" do
    app
    label = Qt6::Label.new("Widget Controls")
    line_edit = Qt6::LineEdit.new

    label.tool_tip = "Shared widget affordances"
    label.word_wrap = true
    label.minimum_width = 120
    label.minimum_height = 32
    label.maximum_width = 360
    label.maximum_height = 120
    label.set_minimum_size(140, 40)
    label.set_maximum_size(420, 160)
    label.mouse_tracking = true
    label.cursor_shape = Qt6::CursorShape::PointingHand
    label.transparent_for_mouse_events = true
    label.set_attribute(Qt6::WidgetAttribute::OpaquePaintEvent)
    label.set_attribute(Qt6::WidgetAttribute::ShowWithoutActivating, true)
    label.clear_attribute(Qt6::WidgetAttribute::ShowWithoutActivating)
    label.move(14, 18)
    label.adjust_size
    line_edit.placeholder_text = "Enter a layer name"

    label.tool_tip.should eq("Shared widget affordances")
    label.word_wrap?.should be_true
    label.minimum_size.should eq(Qt6::Size.new(140, 40))
    label.minimum_width.should eq(140)
    label.minimum_height.should eq(40)
    label.maximum_size.should eq(Qt6::Size.new(420, 160))
    label.maximum_width.should eq(420)
    label.maximum_height.should eq(160)
    label.mouse_tracking?.should be_true
    label.cursor_shape.should eq(Qt6::CursorShape::PointingHand)
    label.transparent_for_mouse_events?.should be_true
    label.attribute?(Qt6::WidgetAttribute::TransparentForMouseEvents).should be_true
    label.attribute?(Qt6::WidgetAttribute::OpaquePaintEvent).should be_true
    label.attribute?(Qt6::WidgetAttribute::ShowWithoutActivating).should be_false
    label.size.width.should be > 0
    label.size.height.should be > 0
    line_edit.placeholder_text.should eq("Enter a layer name")

    label.fixed_width = 200
    label.fixed_height = 48
    label.minimum_width.should eq(200)
    label.maximum_width.should eq(200)
    label.minimum_height.should eq(48)
    label.maximum_height.should eq(48)

    label.set_attribute(Qt6::WidgetAttribute::TransparentForMouseEvents, false)
    label.transparent_for_mouse_events?.should be_false

    line_edit.release
    label.release
  end

  it "supports validators, completers, and rich line-edit editing helpers" do
    application = app
    host = Qt6::Widget.new
    line_edit = Qt6::LineEdit.new("Alpha", host)
    int_validator = Qt6::IntValidator.new(10, 99, line_edit)
    double_validator = Qt6::DoubleValidator.new(0.5, 9.5, 2, line_edit)
    regex_validator = Qt6::RegexValidator.new("^[A-Z][a-z]+$", line_edit)
    completer = Qt6::Completer.new(["Terrain", "Units", "Roads"], line_edit)
    changed_texts = [] of String

    line_edit.on_text_changed do |value|
      changed_texts << value
    end

    completer.case_sensitivity = Qt6::CaseSensitivity::Insensitive
    completer.completion_mode = Qt6::CompleterCompletionMode::PopupCompletion
    completer.completion_prefix = "uni"

    line_edit.echo_mode = Qt6::EchoMode::Password
    line_edit.input_mask = "00-00;_"
    line_edit.alignment = Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter
    line_edit.validator = regex_validator
    line_edit.completer = completer
    line_edit.input_mask.should eq("00-00;_")
    line_edit.input_mask = ""
    line_edit.text = "Bravo"
    line_edit.cursor_position = 2
    line_edit.set_selection(1, 2)
    application.process_events

    int_validator.validate("42").should eq(Qt6::ValidatorState::Acceptable)
    int_validator.validate("abc").should eq(Qt6::ValidatorState::Invalid)
    double_validator.validate("1.25").should eq(Qt6::ValidatorState::Acceptable)
    double_validator.validate("oops").should eq(Qt6::ValidatorState::Invalid)
    regex_validator.validate("Terrain").should eq(Qt6::ValidatorState::Acceptable)
    regex_validator.validate("terrain").should eq(Qt6::ValidatorState::Invalid)

    int_validator.bottom.should eq(10)
    int_validator.top.should eq(99)
    double_validator.bottom.should eq(0.5)
    double_validator.top.should eq(9.5)
    double_validator.decimals.should eq(2)
    regex_validator.pattern.should eq("^[A-Z][a-z]+$")
    completer.case_sensitivity.should eq(Qt6::CaseSensitivity::Insensitive)
    completer.completion_mode.should eq(Qt6::CompleterCompletionMode::PopupCompletion)
    completer.completion_prefix.should eq("uni")
    completer.current_completion.should eq("Units")

    line_edit.echo_mode.should eq(Qt6::EchoMode::Password)
    line_edit.input_mask.should eq("")
    line_edit.alignment.includes?(Qt6::AlignmentFlag::Right).should be_true
    line_edit.alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
    line_edit.validator.not_nil!.validate("Roads").should eq(Qt6::ValidatorState::Acceptable)
    line_edit.completer.not_nil!.completion_prefix.should eq("uni")
    line_edit.text.should eq("Bravo")
    line_edit.cursor_position.should eq(3)
    line_edit.selected_text.should eq("ra")
    line_edit.has_selected_text?.should be_true
    line_edit.selection_start.should eq(1)
    changed_texts.last.should eq("Bravo")

    line_edit.select_all
    line_edit.selected_text.should eq("Bravo")
    line_edit.clear_selection
    line_edit.has_selected_text?.should be_false
    line_edit.clear
    line_edit.text.should eq("")

    host.release
  end

  it "supports application metadata, stylesheets, and window icons" do
    application = app
    icon_path = File.join(Dir.tempdir, "crystal-qt6-window-icon-#{Process.pid}.png")
    icon_image = Qt6::QImage.new(16, 16)
    icon_image.fill(Qt6::Color.new(0, 0, 0, 0))
    icon_image.set_pixel_color(4, 4, Qt6::Color.new(32, 96, 180, 255))
    icon_image.save(icon_path).should be_true

    previous_name = application.name
    previous_organization_name = application.organization_name
    previous_organization_domain = application.organization_domain
    previous_style_sheet = application.style_sheet
    previous_window_icon = application.window_icon

    icon = Qt6::QIcon.from_file(icon_path)
    icon.null?.should be_false

    application.name = "crystal-qt6 specs"
    application.organization_name = "Spec Org"
    application.organization_domain = "spec.example"
    application.style_sheet = "QWidget { color: rgb(12, 34, 56); }"
    application.window_icon = icon

    window = Qt6::Widget.new
    window.style_sheet = "QWidget { background-color: rgb(22, 44, 66); }"
    window.window_icon = icon

    application.name.should eq("crystal-qt6 specs")
    application.organization_name.should eq("Spec Org")
    application.organization_domain.should eq("spec.example")
    application.style_sheet.should eq("QWidget { color: rgb(12, 34, 56); }")
    application.window_icon.null?.should be_false
    window.style_sheet.should eq("QWidget { background-color: rgb(22, 44, 66); }")
    window.window_icon.null?.should be_false

    window.release
    application.name = previous_name
    application.organization_name = previous_organization_name
    application.organization_domain = previous_organization_domain
    application.style_sheet = previous_style_sheet
    application.window_icon = previous_window_icon
  end

  it "updates label and button text" do
    app
    label = Qt6::Label.new("Ready")
    button = Qt6::PushButton.new("Launch")

    label.text.should eq("Ready")
    button.text.should eq("Launch")

    label.text = "Running"
    button.text = "Stop"

    label.text.should eq("Running")
    button.text.should eq("Stop")
    label.release
    button.release
  end

  it "supports layouts and click callbacks" do
    application = app
    window = Qt6::Widget.new
    layout = Qt6::VBoxLayout.new(window)
    label = Qt6::Label.new("0")
    button = Qt6::PushButton.new("Increment")
    clicks = 0

    layout << label
    layout << button

    button.on_clicked do
      clicks += 1
      label.text = clicks.to_s
    end

    button.click
    application.process_events

    clicks.should eq(1)
    label.text.should eq("1")
    window.release
  end

  it "supports hbox, form, and grid layouts" do
    app
    window = Qt6::Widget.new
    name_field = Qt6::LineEdit.new("Terrain")
    kind_field = Qt6::ComboBox.new
    kind_field << "Hexes" << "Terrain"
    primary = Qt6::PushButton.new("Primary")
    secondary = Qt6::PushButton.new("Secondary")
    top_left = Qt6::Label.new("A")
    top_right = Qt6::Label.new("B")
    footer = Qt6::Label.new("Footer")

    window.form do |form|
      form.add_row("Name", name_field)
      form.add_row(Qt6::Label.new("Kind"), kind_field)
      form.add_row(Qt6::Widget.new.tap do |button_row|
        button_row.hbox do |row|
          row << primary
          row << secondary
        end
      end)
      form.add_row(Qt6::Widget.new.tap do |grid_host|
        grid_host.grid do |grid|
          grid.add(top_left, 0, 0)
          grid.add(top_right, 0, 1)
          grid.add(footer, 1, 0, 1, 2)
        end
      end)
    end

    name_field.text.should eq("Terrain")
    kind_field.count.should eq(2)
    top_left.text.should eq("A")
    top_right.text.should eq("B")
    footer.text.should eq("Footer")
    window.release
  end

  it "builds a window with the helper DSL" do
    app
    window = Qt6.window("Helper Window", 420, 240) do |widget|
      widget.vbox do |column|
        column << Qt6::Label.new("Top")
        column << Qt6::PushButton.new("Action")
      end
    end

    window.window_title.should eq("Helper Window")
    window.release
  end
end
