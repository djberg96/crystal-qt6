require "../src/qt6"

OUTPUT_DIR = File.expand_path("../docs/book/images", __DIR__)
Dir.mkdir_p(OUTPUT_DIR)

class EditorVerticalSliceCaptureState
  property active_layer : String
  property zoom : Float64
  property pan_x : Float64
  property pan_y : Float64
  property grid_spacing : Int32
  property marker_size : Int32
  property show_grid : Bool
  property accent : Qt6::Color

  def initialize
    @active_layer = "Units"
    @zoom = 1.18
    @pan_x = 42.0
    @pan_y = 46.0
    @grid_spacing = 44
    @marker_size = 22
    @show_grid = true
    @accent = Qt6::Color.new(204, 86, 62)
  end

  def scene_points : Array(Qt6::PointF)
    [
      Qt6::PointF.new(110.0, 110.0),
      Qt6::PointF.new(208.0, 194.0),
      Qt6::PointF.new(324.0, 176.0),
      Qt6::PointF.new(430.0, 270.0),
    ]
  end
end

def process_paints(app : Qt6::Application)
  10.times { app.process_events }
end

def flatten_png(path : String)
  tmp_path = "#{path}.tmp.png"
  status = Process.run(
    "magick",
    [path, "-background", "white", "-alpha", "remove", "-alpha", "off", tmp_path]
  )
  abort "Could not flatten #{path}; ImageMagick `magick` is required" unless status.success?
  File.rename(tmp_path, path)
end

def save_widget(app : Qt6::Application, widget : Qt6::Widget, file_name : String)
  widget.update
  process_paints(app)

  output = File.join(OUTPUT_DIR, file_name)
  abort "Could not write #{output}" unless widget.grab.save(output)
  flatten_png(output)
  puts output
end

def save_widget_region(app : Qt6::Application, widget : Qt6::Widget, file_name : String, width : Int, height : Int)
  widget.update
  process_paints(app)

  pixmap = widget.grab
  image = pixmap.to_image
  cropped = image.copy(0, 0, {width, image.width}.min, {height, image.height}.min)

  output = File.join(OUTPUT_DIR, file_name)
  abort "Could not write #{output}" unless cropped.save(output)
  flatten_png(output)
  puts output
end

app = Qt6.application(["capture-worked-example-screenshots"])
app.name = "Worked Example Screenshots"
app.organization_name = "crystal-qt6"
app.style_sheet = <<-CSS
  QWidget {
    font-size: 15px;
  }
  QMainWindow {
    background: rgb(239, 242, 244);
  }
  QDockWidget::title {
    background: rgb(229, 235, 240);
    padding: 6px;
    font-weight: bold;
  }
  QTreeView {
    background: white;
    alternate-background-color: rgb(245, 248, 250);
    border: 1px solid rgb(190, 198, 206);
    selection-background-color: rgb(72, 126, 176);
    selection-color: white;
  }
  QHeaderView::section {
    background: rgb(236, 241, 245);
    border: 0;
    border-right: 1px solid rgb(190, 198, 206);
    border-bottom: 1px solid rgb(190, 198, 206);
    padding: 6px 8px;
    font-weight: bold;
  }
  QPushButton {
    padding: 6px 10px;
  }
CSS

state = EditorVerticalSliceCaptureState.new

main = Qt6::MainWindow.new
main.window_title = "Editor Vertical Slice"
main.resize(1180, 720)

status_bar = main.status_bar
status_bar.show_message("Switched to units")

canvas = Qt6::EventWidget.new
canvas.set_minimum_size(720, 520)

grid_pen = Qt6::QPen.new(Qt6::Color.new(200, 208, 214), 1.0)
frame_pen = Qt6::QPen.new(Qt6::Color.new(74, 82, 91), 2.0)
route_pen = Qt6::QPen.new(state.accent, 3.0)
hud_font = Qt6::QFont.new(point_size: 11, bold: true)

scene_to_view = ->(point : Qt6::PointF) do
  Qt6::PointF.new(state.pan_x + point.x * state.zoom, state.pan_y + point.y * state.zoom)
end

canvas.on_paint_with_painter do |event, painter|
  painter.fill_rect(event.rect, Qt6::Color.new(245, 243, 238))

  scene_rect = Qt6::RectF.new(0.0, 0.0, 640.0, 420.0)
  visible_rect = Qt6::RectF.new(
    state.pan_x + scene_rect.x * state.zoom,
    state.pan_y + scene_rect.y * state.zoom,
    scene_rect.width * state.zoom,
    scene_rect.height * state.zoom
  )

  painter.pen = frame_pen
  painter.brush = Qt6::Color.new(255, 255, 255)
  painter.draw_rect(visible_rect)

  if state.show_grid
    painter.pen = grid_pen

    x = 0
    while x <= scene_rect.width
      start_point = scene_to_view.call(Qt6::PointF.new(x.to_f, 0.0))
      end_point = scene_to_view.call(Qt6::PointF.new(x.to_f, scene_rect.height))
      painter.draw_line(start_point, end_point)
      x += state.grid_spacing
    end

    y = 0
    while y <= scene_rect.height
      start_point = scene_to_view.call(Qt6::PointF.new(0.0, y.to_f))
      end_point = scene_to_view.call(Qt6::PointF.new(scene_rect.width, y.to_f))
      painter.draw_line(start_point, end_point)
      y += state.grid_spacing
    end
  end

  painter.pen = route_pen
  painter.brush = state.accent

  points = state.scene_points.map { |point| scene_to_view.call(point) }
  points.each_cons(2) { |segment| painter.draw_line(segment[0], segment[1]) }

  marker_size = state.marker_size.to_f * state.zoom
  points.each_with_index do |point, index|
    painter.draw_ellipse(Qt6::RectF.new(point.x - marker_size / 2.0, point.y - marker_size / 2.0, marker_size, marker_size))
    painter.draw_text(Qt6::PointF.new(point.x + marker_size / 2.0 + 8.0, point.y + 4.0), "#{index + 1}")
  end

  painter.font = hud_font
  painter.pen = Qt6::Color.new(46, 52, 58)
  painter.brush = Qt6::Color.new(0, 0, 0, 0)
  painter.draw_text(Qt6::PointF.new(18.0, 24.0), "Layer #{state.active_layer} | zoom #{state.zoom.round(2)}x | pan #{state.pan_x.round.to_i}, #{state.pan_y.round.to_i}")
  painter.draw_text(Qt6::PointF.new(18.0, 44.0), "Wheel to zoom, drag to pan, 0 to reset, export from File or the inspector dock")
end

main.central_widget = canvas

layer_model = Qt6::StandardItemModel.new(main)
layer_model.set_horizontal_header_label(0, "Layer")
layer_model.set_horizontal_header_label(1, "State")

[
  {"Terrain", "Visible", 10, Qt6::Color.new(62, 130, 109)},
  {"Units", "Visible", 20, Qt6::Color.new(204, 86, 62)},
  {"Labels", "Draft", 30, Qt6::Color.new(92, 88, 176)},
].each_with_index do |entry, row|
  name = Qt6::StandardItem.new(entry[0])
  name.set_data(entry[2], Qt6::ItemDataRole::User)
  name.set_data(entry[3], Qt6::ItemDataRole::Foreground)
  layer_model.set_item(row, 0, name)
  layer_model.set_item(row, 1, Qt6::StandardItem.new(entry[1]))
end

layers_proxy = Qt6::SortFilterProxyModel.new(main)
layers_proxy.source_model = layer_model
layers_proxy.sort_role = Qt6::ItemDataRole::User
layers_proxy.sort

layer_tree = Qt6::TreeView.new
layer_tree.model = layers_proxy
layer_tree.expand_all
layer_tree.alternating_row_colors = true
layer_tree.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows

layer_selection = Qt6::ItemSelectionModel.new(layers_proxy, layer_tree)
layer_tree.selection_model = layer_selection

layer_delegate = Qt6::StyledItemDelegate.new(layer_tree)
layer_delegate.on_display_text do |text|
  text.empty? ? text : "  #{text}"
end
layer_tree.item_delegate = layer_delegate

layer_summary = Qt6::Label.new("Active layer: Units")

layers_panel = Qt6::Widget.new
layers_panel.vbox do |column|
  column << Qt6::Label.new("Layer Manager")
  column << layer_tree
  column << layer_summary
end

layers_dock = Qt6::DockWidget.new("Layers", main)
layers_dock.widget = layers_panel
main.add_dock_widget(layers_dock, Qt6::DockArea::Left)

zoom_spin = Qt6::DoubleSpinBox.new
zoom_spin.set_range(0.5, 3.0)
zoom_spin.single_step = 0.1
zoom_spin.value = state.zoom

spacing_spin = Qt6::SpinBox.new
spacing_spin.set_range(24, 96)
spacing_spin.single_step = 4
spacing_spin.value = state.grid_spacing

marker_spin = Qt6::SpinBox.new
marker_spin.set_range(10, 36)
marker_spin.single_step = 2
marker_spin.value = state.marker_size

show_grid = Qt6::CheckBox.new("Show grid")
show_grid.checked = state.show_grid

accent_button = Qt6::PushButton.new("Accent Color")
reset_button = Qt6::PushButton.new("Reset View")
export_button = Qt6::PushButton.new("Export PNG")
inspector_hint = Qt6::Label.new("This dock drives the live canvas. The layer manager drives the scene profile.")
inspector_hint.word_wrap = true

inspector = Qt6::Widget.new
inspector.form do |form|
  form.add_row("Zoom", zoom_spin)
  form.add_row("Grid spacing", spacing_spin)
  form.add_row("Marker size", marker_spin)
  form.add_row(show_grid)
  form.add_row(accent_button)
  form.add_row(reset_button)
  form.add_row(export_button)
  form.add_row(inspector_hint)
end

inspector_dock = Qt6::DockWidget.new("Inspector", main)
inspector_dock.widget = inspector
main.add_dock_widget(inspector_dock, Qt6::DockArea::Right)

file_menu = main.menu_bar.add_menu("File")
view_menu = main.menu_bar.add_menu("View")
tools_menu = main.menu_bar.add_menu("Tools")

export_action = Qt6::Action.new("Export PNG", main)
export_action.shortcut = "Ctrl+E"
reset_view_action = Qt6::Action.new("Reset View", main)
reset_view_action.shortcut = "0"
accent_action = Qt6::Action.new("Accent Color", main)
accent_action.shortcut = "Ctrl+Shift+C"
quit_action = Qt6::Action.new("Quit", main)
quit_action.shortcut = "Ctrl+Q"

file_menu << export_action
file_menu.add_separator
file_menu << quit_action
view_menu << reset_view_action
tools_menu << accent_action

toolbar = Qt6::ToolBar.new("Editor", main)
toolbar << export_action
toolbar << reset_view_action
toolbar << accent_action
main.add_tool_bar(toolbar)

initial_index = layers_proxy.index(1, 0)
layer_tree.current_index = initial_index
initial_index.release

main.show
process_paints(app)

save_widget(app, main, "putting-together-editor-shell.png")
save_widget(app, canvas, "putting-together-canvas.png")
save_widget_region(app, layers_panel, "putting-together-layers-dock.png", 374, 760)
save_widget_region(app, inspector, "putting-together-inspector-dock.png", 542, 700)

main.close
process_paints(app)
