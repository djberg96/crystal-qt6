
class EditorVerticalSliceSpecState
  property active_layer : String
  property zoom : Float64
  property pan_x : Float64
  property pan_y : Float64
  property grid_spacing : Int32
  property marker_size : Int32
  property show_grid : Bool
  property dragging : Bool
  property last_pointer : Qt6::PointF
  property accent : Qt6::Color

  def initialize
    @active_layer = "Terrain"
    @zoom = 1.0
    @pan_x = 24.0
    @pan_y = 28.0
    @grid_spacing = 48
    @marker_size = 18
    @show_grid = true
    @dragging = false
    @last_pointer = Qt6::PointF.new(0.0, 0.0)
    @accent = Qt6::Color.new(62, 130, 109)
  end

  def apply_layer(name : String) : Nil
    @active_layer = name

    case name
    when "Units"
      @accent = Qt6::Color.new(204, 86, 62)
      @grid_spacing = 44
      @marker_size = 22
    else
      @accent = Qt6::Color.new(62, 130, 109)
      @grid_spacing = 48
      @marker_size = 18
    end
  end
end

record EditorVerticalSliceSpecSnapshot,
  active_layer : String,
  zoom : Float64,
  pan_x : Float64,
  pan_y : Float64,
  grid_spacing : Int32,
  marker_size : Int32,
  show_grid : Bool,
  accent : Qt6::Color

def snapshot_editor_slice_spec(state : EditorVerticalSliceSpecState) : EditorVerticalSliceSpecSnapshot
  EditorVerticalSliceSpecSnapshot.new(
    state.active_layer,
    state.zoom,
    state.pan_x,
    state.pan_y,
    state.grid_spacing,
    state.marker_size,
    state.show_grid,
    state.accent
  )
end

def restore_editor_slice_spec(state : EditorVerticalSliceSpecState, snapshot : EditorVerticalSliceSpecSnapshot) : Nil
  state.active_layer = snapshot.active_layer
  state.zoom = snapshot.zoom
  state.pan_x = snapshot.pan_x
  state.pan_y = snapshot.pan_y
  state.grid_spacing = snapshot.grid_spacing
  state.marker_size = snapshot.marker_size
  state.show_grid = snapshot.show_grid
  state.accent = snapshot.accent
end

class EditableLayerListModel < Qt6::AbstractListModel
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

class EditableLayerTableModel < Qt6::AbstractTableModel
  getter rows

  def initialize(rows : Array(Array(String)), parent : Qt6::QObject? = nil)
    @rows = rows
    super(parent)
  end

  def append_row(values : Array(String)) : Nil
    position = @rows.size
    begin_insert_rows(position, position)
    @rows << values
    end_insert_rows
  end

  def append_column(default_value : String) : Nil
    position = model_column_count
    begin_insert_columns(position, position)
    @rows.each { |row| row << default_value }
    end_insert_columns
  end

  protected def model_row_count : Int32
    @rows.size.to_i32
  end

  protected def model_column_count : Int32
    (@rows.first?.try(&.size) || 0).to_i32
  end

  protected def model_data(index : Qt6::ModelIndex, role : Int32) : Qt6::ModelData
    return nil unless index.valid?
    return nil unless role == Qt6::ItemDataRole::Display.value || role == Qt6::ItemDataRole::Edit.value

    @rows[index.row]?.try(&.[](index.column))
  end

  protected def model_set_data(index : Qt6::ModelIndex, value : Qt6::ModelData, role : Int32) : Bool
    return false unless index.valid? && role == Qt6::ItemDataRole::Edit.value

    @rows[index.row][index.column] = value.to_s
    data_changed(index)
    true
  end

  protected def model_header_data(section : Int32, orientation : Qt6::Orientation, role : Int32) : Qt6::ModelData
    return nil unless role == Qt6::ItemDataRole::Display.value

    orientation == Qt6::Orientation::Horizontal ? "Column #{section}" : "Row #{section}"
  end

  protected def model_flags(index : Qt6::ModelIndex) : Qt6::ItemFlag
    return Qt6::ItemFlag::None unless index.valid?

    Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable
  end
end

class DraggableLayerListModel < Qt6::AbstractListModel
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

class RootDropListModel < Qt6::AbstractListModel
  def initialize(parent : Qt6::QObject? = nil)
    super(parent)
  end

  protected def model_row_count : Int32
    1
  end

  protected def model_data(index : Qt6::ModelIndex, role : Int32) : Qt6::ModelData
    return nil unless index.valid?
    return nil unless role == Qt6::ItemDataRole::Display.value

    "Layer"
  end

  protected def model_flags(index : Qt6::ModelIndex) : Qt6::ItemFlag
    return Qt6::ItemFlag::DropEnabled unless index.valid?

    Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable
  end
end

class RawDropHandleListModel < Qt6::AbstractListModel
  getter raw_drop_handle : Qt6::LibQt6::Handle = Pointer(Void).null
  getter raw_drop_action : Qt6::DropAction? = nil
  getter raw_drop_row : Int32? = nil
  getter raw_drop_column : Int32? = nil
  getter raw_drop_parent_valid : Bool? = nil

  def initialize(parent : Qt6::QObject? = nil)
    super(parent)
  end

  protected def model_row_count : Int32
    0
  end

  protected def model_drop_mime_data_handle(mime_data_handle : Qt6::LibQt6::Handle, action : Qt6::DropAction, row : Int32, column : Int32, parent : Qt6::ModelIndex) : Bool
    @raw_drop_handle = mime_data_handle
    @raw_drop_action = action
    @raw_drop_row = row
    @raw_drop_column = column
    @raw_drop_parent_valid = parent.valid?
    true
  end
end

class LayerTreeModel < Qt6::AbstractTreeModel
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

class RootDropTreeModel < Qt6::AbstractTreeModel
  def initialize(parent : Qt6::QObject? = nil)
    super(parent)
  end

  protected def model_row_count(parent : Qt6::ModelIndex) : Int32
    parent.valid? ? 0 : 1
  end

  protected def model_column_count(parent : Qt6::ModelIndex) : Int32
    1
  end

  protected def model_index_internal_id(row : Int32, column : Int32, parent : Qt6::ModelIndex) : UInt64?
    return nil if parent.valid?
    return nil unless row == 0 && column == 0

    1_u64
  end

  protected def model_parent(index : Qt6::ModelIndex) : Qt6::ModelIndexSpec?
    nil
  end

  protected def model_data(index : Qt6::ModelIndex, role : Int32) : Qt6::ModelData
    return nil unless index.valid?
    return nil unless role == Qt6::ItemDataRole::Display.value

    "Layer"
  end

  protected def model_flags(index : Qt6::ModelIndex) : Qt6::ItemFlag
    return Qt6::ItemFlag::DropEnabled unless index.valid?

    Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable
  end
end

class RawDropHandleTreeModel < Qt6::AbstractTreeModel
  getter raw_drop_handle : Qt6::LibQt6::Handle = Pointer(Void).null
  getter raw_drop_action : Qt6::DropAction? = nil
  getter raw_drop_row : Int32? = nil
  getter raw_drop_column : Int32? = nil
  getter raw_drop_parent_valid : Bool? = nil

  def initialize(parent : Qt6::QObject? = nil)
    super(parent)
  end

  protected def model_row_count(parent : Qt6::ModelIndex) : Int32
    0
  end

  protected def model_column_count(parent : Qt6::ModelIndex) : Int32
    1
  end

  protected def model_index_internal_id(row : Int32, column : Int32, parent : Qt6::ModelIndex) : UInt64?
    nil
  end

  protected def model_parent(index : Qt6::ModelIndex) : Qt6::ModelIndexSpec?
    nil
  end

  protected def model_drop_mime_data_handle(mime_data_handle : Qt6::LibQt6::Handle, action : Qt6::DropAction, row : Int32, column : Int32, parent : Qt6::ModelIndex) : Bool
    @raw_drop_handle = mime_data_handle
    @raw_drop_action = action
    @raw_drop_row = row
    @raw_drop_column = column
    @raw_drop_parent_valid = parent.valid?
    true
  end
end

class MutableTreeNode
  property label : String
  property parent_id : UInt64?
  getter children : Array(UInt64)

  def initialize(@label : String, @parent_id : UInt64?, @children : Array(UInt64) = [] of UInt64)
  end
end

class MutableLayerTreeModel < Qt6::AbstractTreeModel
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
