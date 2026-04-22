require "../src/qt6"

class EditorVerticalSliceState
  property active_layer : String
  property zoom : Float64
  property pan_x : Float64
  property pan_y : Float64
  property grid_spacing : Int32
  property marker_size : Int32
  property show_grid : Bool
  property accent : Qt6::Color
  property dragging : Bool
  property last_pointer : Qt6::PointF

  def initialize
    @active_layer = "Terrain"
    @zoom = 1.0
    @pan_x = 32.0
    @pan_y = 36.0
    @grid_spacing = 48
    @marker_size = 18
    @show_grid = true
    @accent = Qt6::Color.new(62, 130, 109)
    @dragging = false
    @last_pointer = Qt6::PointF.new(0.0, 0.0)
  end

  def reset_view : Nil
    @zoom = 1.0
    @pan_x = 32.0
    @pan_y = 36.0
  end

  def apply_layer(name : String) : Nil
    @active_layer = name

    case name
    when "Terrain"
      @accent = Qt6::Color.new(62, 130, 109)
      @grid_spacing = 48
      @marker_size = 18
    when "Units"
      @accent = Qt6::Color.new(204, 86, 62)
      @grid_spacing = 44
      @marker_size = 22
    else
      @accent = Qt6::Color.new(92, 88, 176)
      @grid_spacing = 56
      @marker_size = 16
    end
  end

  def scene_points : Array(Qt6::PointF)
    case @active_layer
    when "Terrain"
      [
        Qt6::PointF.new(120.0, 92.0),
        Qt6::PointF.new(236.0, 154.0),
        Qt6::PointF.new(358.0, 128.0),
        Qt6::PointF.new(468.0, 224.0),
      ]
    when "Units"
      [
        Qt6::PointF.new(110.0, 110.0),
        Qt6::PointF.new(208.0, 194.0),
        Qt6::PointF.new(324.0, 176.0),
        Qt6::PointF.new(430.0, 270.0),
      ]
    else
      [
        Qt6::PointF.new(142.0, 82.0),
        Qt6::PointF.new(252.0, 118.0),
        Qt6::PointF.new(360.0, 142.0),
        Qt6::PointF.new(486.0, 188.0),
      ]
    end
  end
end

record EditorVerticalSliceSnapshot,
  active_layer : String,
  zoom : Float64,
  pan_x : Float64,
  pan_y : Float64,
  grid_spacing : Int32,
  marker_size : Int32,
  show_grid : Bool,
  accent : Qt6::Color

def snapshot_editor_state(state : EditorVerticalSliceState) : EditorVerticalSliceSnapshot
  EditorVerticalSliceSnapshot.new(
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

def restore_editor_state(state : EditorVerticalSliceState, snapshot : EditorVerticalSliceSnapshot) : Nil
  state.active_layer = snapshot.active_layer
  state.zoom = snapshot.zoom
  state.pan_x = snapshot.pan_x
  state.pan_y = snapshot.pan_y
  state.grid_spacing = snapshot.grid_spacing
  state.marker_size = snapshot.marker_size
  state.show_grid = snapshot.show_grid
  state.accent = snapshot.accent
end

def setting_float(settings : Qt6::QSettings, key : String, default_value : Float64) : Float64
  value = settings.value(key, default_value)
  case value
  when Float64
    value
  when Int32
    value.to_f64
  else
    default_value
  end
end

def setting_int(settings : Qt6::QSettings, key : String, default_value : Int32) : Int32
  value = settings.value(key, default_value)
  value.is_a?(Int32) ? value : default_value
end

def setting_bool(settings : Qt6::QSettings, key : String, default_value : Bool) : Bool
  value = settings.value(key, default_value)
  value.is_a?(Bool) ? value : default_value
end

app = Qt6.application
state = EditorVerticalSliceState.new
settings = Qt6::QSettings.for_application("crystal-qt6", "editor_vertical_slice")
initial_layer_name = settings.value("ui/active_layer", state.active_layer).to_s
state.apply_layer(initial_layer_name)

state.zoom = setting_float(settings, "view/zoom", state.zoom).clamp(0.5, 3.0)
state.pan_x = setting_float(settings, "view/pan_x", state.pan_x)
state.pan_y = setting_float(settings, "view/pan_y", state.pan_y)
state.grid_spacing = setting_int(settings, "view/grid_spacing", state.grid_spacing).clamp(24, 96)
state.marker_size = setting_int(settings, "view/marker_size", state.marker_size).clamp(10, 36)
state.show_grid = setting_bool(settings, "view/show_grid", state.show_grid)

main = Qt6::MainWindow.new
main.window_title = "Editor Vertical Slice"
main.resize(1240, 780)

status_bar = main.status_bar
status_bar.show_message("Ready")

undo_stack = Qt6::UndoStack.new(main)

canvas = Qt6::EventWidget.new
canvas.resize(860, 620)

grid_pen = Qt6::QPen.new(Qt6::Color.new(200, 208, 214), 1.0)
frame_pen = Qt6::QPen.new(Qt6::Color.new(74, 82, 91), 2.0)
route_pen = Qt6::QPen.new(state.accent, 3.0)
hud_font = Qt6::QFont.new(point_size: 11, bold: true)

scene_to_view = ->(point : Qt6::PointF) do
  Qt6::PointF.new(state.pan_x + point.x * state.zoom, state.pan_y + point.y * state.zoom)
end

export_dialog = Qt6::FileDialog.new(main, Dir.current, "PNG Images (*.png);;All Files (*)")
export_dialog.window_title = "Export Canvas Snapshot"
export_dialog.accept_mode = Qt6::FileDialogAcceptMode::Save
export_dialog.file_mode = Qt6::FileDialogFileMode::AnyFile

persist_state = -> do
  settings.set_value("ui/active_layer", state.active_layer)
  settings.set_value("view/zoom", state.zoom)
  settings.set_value("view/pan_x", state.pan_x)
  settings.set_value("view/pan_y", state.pan_y)
  settings.set_value("view/grid_spacing", state.grid_spacing)
  settings.set_value("view/marker_size", state.marker_size)
  settings.set_value("view/show_grid", state.show_grid)
  settings.sync
end

refresh_canvas = ->(message : String?) do
  route_pen.color = state.accent
  canvas.update
  if text = message
    status_bar.show_message(text, 1800)
  end
end

export_png = -> do
  default_path = File.join(Dir.current, "crystal-qt6-#{state.active_layer.downcase}-slice.png")
  suggested = settings.value("ui/last_export_path", default_path).to_s
  suggested = default_path if suggested.empty?
  export_dialog.select_file(suggested)

  if export_dialog.exec == Qt6::DialogCode::Accepted
    output = export_dialog.selected_file
    output = "#{output}.png" unless output.downcase.ends_with?(".png")

    if canvas.grab.save(output)
      settings.set_value("ui/last_export_path", output)
      settings.sync
      status_bar.show_message("Exported #{File.basename(output)}")
    else
      status_bar.show_message("PNG export failed", 2400)
    end
  else
    status_bar.show_message("PNG export canceled", 1400)
  end
end

copy_snapshot = -> do
  payload = Qt6::MimeData.new
  summary = "Layer #{state.active_layer}, zoom #{state.zoom.round(2)}x, grid #{state.grid_spacing}, marker #{state.marker_size}"
  payload.text = summary
  payload.html = "<strong>#{state.active_layer}</strong><br>Zoom #{state.zoom.round(2)}x<br>Grid #{state.grid_spacing}<br>Marker #{state.marker_size}"
  payload.image = canvas.grab.to_image
  payload.set_data("application/x-crystal-qt6-editor-state", summary)
  Qt6.clipboard.mime_data = payload
  status_bar.show_message("Copied #{state.active_layer.downcase} snapshot to the clipboard", 1800)
end

canvas.on_mouse_press do |event|
  state.dragging = true
  state.last_pointer = event.position
  status_bar.show_message("Dragging canvas", 1000)
end

canvas.on_mouse_move do |event|
  next unless state.dragging

  dx = event.position.x - state.last_pointer.x
  dy = event.position.y - state.last_pointer.y
  state.pan_x += dx
  state.pan_y += dy
  state.last_pointer = event.position
  refresh_canvas.call(nil)
end

canvas.on_mouse_release do |_event|
  state.dragging = false
  persist_state.call
  status_bar.show_message("Canvas settled", 900)
end

canvas.on_wheel do |event|
  step = event.angle_delta.y >= 0 ? 1.1 : 0.9
  state.zoom = (state.zoom * step).clamp(0.5, 3.0)
  persist_state.call
  refresh_canvas.call("Zoom #{state.zoom.round(2)}x")
end

canvas.on_key_press do |event|
  case event.key
  when 43, 61
    state.zoom = (state.zoom * 1.1).clamp(0.5, 3.0)
    persist_state.call
    refresh_canvas.call("Zoom #{state.zoom.round(2)}x")
  when 45
    state.zoom = (state.zoom * 0.9).clamp(0.5, 3.0)
    persist_state.call
    refresh_canvas.call("Zoom #{state.zoom.round(2)}x")
  when 48
    state.reset_view
    persist_state.call
    refresh_canvas.call("View reset")
  end
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

  route_pen.color = state.accent
  painter.pen = route_pen
  painter.brush = state.accent

  points = state.scene_points.map { |point| scene_to_view.call(point) }

  points.each_cons(2) do |segment|
    painter.draw_line(segment[0], segment[1])
  end

  marker_size = state.marker_size.to_f * state.zoom
  points.each_with_index do |point, index|
    painter.draw_ellipse(Qt6::RectF.new(point.x - marker_size / 2.0, point.y - marker_size / 2.0, marker_size, marker_size))
    painter.draw_text(Qt6::PointF.new(point.x + marker_size / 2.0 + 8.0, point.y + 4.0), "#{index + 1}")
  end

  painter.font = hud_font
  painter.pen = Qt6::Color.new(46, 52, 58)
  painter.brush = Qt6::Color.new(0, 0, 0, 0)
  painter.draw_text(Qt6::PointF.new(18.0, 24.0), "Layer #{state.active_layer} | zoom #{state.zoom.round(2)}x | pan #{state.pan_x.round.to_i}, #{state.pan_y.round.to_i}")
  painter.draw_text(Qt6::PointF.new(18.0, 44.0), "Wheel to zoom, drag to pan, 0 to reset, use Edit for undo, redo, and clipboard")
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
  status = Qt6::StandardItem.new(entry[1])
  layer_model.set_item(row, 0, name)
  layer_model.set_item(row, 1, status)
end

layers_proxy = Qt6::SortFilterProxyModel.new(main)
layers_proxy.source_model = layer_model
layers_proxy.sort_role = Qt6::ItemDataRole::User
layers_proxy.sort

layer_tree = Qt6::TreeView.new
layer_tree.model = layers_proxy
layer_tree.expand_all

layer_selection = Qt6::ItemSelectionModel.new(layers_proxy, layer_tree)
layer_tree.selection_model = layer_selection

layer_delegate = Qt6::StyledItemDelegate.new(layer_tree)
layer_delegate.on_display_text do |text|
  text.empty? ? text : "  #{text}"
end
layer_tree.item_delegate = layer_delegate

layer_summary = Qt6::Label.new("Active layer: Terrain")

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

syncing_controls = false

sync_inspector = -> do
  syncing_controls = true
  begin
    zoom_spin.value = state.zoom
    spacing_spin.value = state.grid_spacing
    marker_spin.value = state.marker_size
    show_grid.checked = state.show_grid
  ensure
    syncing_controls = false
  end
end

select_layer = ->(layer_name : String) do
  selected = false

  layers_proxy.row_count.times do |row|
    index = layers_proxy.index(row, 0)

    if layers_proxy.data(index).to_s == layer_name
      layer_tree.current_index = index
      selected = true
      index.release
      break
    end

    index.release
  end

  selected
end

apply_editor_snapshot = ->(snapshot : EditorVerticalSliceSnapshot, message : String?) do
  restore_editor_state(state, snapshot)
  select_layer.call(state.active_layer)
  layer_summary.text = "Active layer: #{state.active_layer}"
  sync_inspector.call
  persist_state.call
  refresh_canvas.call(message)
end

save_action = Qt6::Action.new("Mark Saved", main)
save_action.shortcut = "Ctrl+S"

undo_action = undo_stack.create_undo_action(main, "Undo")
undo_action.shortcut = "Ctrl+Z"

redo_action = undo_stack.create_redo_action(main, "Redo")
redo_action.shortcut = "Ctrl+Shift+Z"

copy_snapshot_action = Qt6::Action.new("Copy Snapshot", main)
copy_snapshot_action.shortcut = "Ctrl+Shift+X"
copy_snapshot_action.on_triggered { copy_snapshot.call }

update_dirty_state = -> do
  dirty = !undo_stack.clean?
  main.window_title = dirty ? "Editor Vertical Slice *" : "Editor Vertical Slice"
  save_action.enabled = dirty
end

save_action.on_triggered do
  undo_stack.set_clean
  persist_state.call
  update_dirty_state.call
  status_bar.show_message("State marked saved", 1500)
end

undo_stack.on_clean_changed { |_clean| update_dirty_state.call }
undo_stack.on_index_changed { |_index| update_dirty_state.call }

push_change = ->(label : String, before : EditorVerticalSliceSnapshot, after : EditorVerticalSliceSnapshot, message : String?) do
  undo_stack.push(Qt6::UndoCommand.new(
    label,
    redo: -> { apply_editor_snapshot.call(after, message) },
    undo: -> { apply_editor_snapshot.call(before, "Undid #{label.downcase}") }
  ))
  update_dirty_state.call
end

activate_layer = ->(layer_name : String, undoable : Bool) do
  unless layer_name == state.active_layer
    before = snapshot_editor_state(state)
    state.apply_layer(layer_name)
    after = snapshot_editor_state(state)
    restore_editor_state(state, before)

    if undoable
      push_change.call("Switch to #{layer_name}", before, after, "Switched to #{layer_name.downcase}")
    else
      apply_editor_snapshot.call(after, "Switched to #{layer_name.downcase}")
    end
  end
end

layer_tree.on_current_index_changed do
  next if syncing_controls

  current = layer_tree.current_index
  if current.valid?
    name_index = layers_proxy.index(current.row, 0)
    activate_layer.call(layers_proxy.data(name_index).to_s, true)
    name_index.release
  end

  current.release
end

zoom_spin.on_value_changed do |value|
  next if syncing_controls || value == state.zoom

  before = snapshot_editor_state(state)
  state.zoom = value
  after = snapshot_editor_state(state)
  restore_editor_state(state, before)
  push_change.call("Change zoom", before, after, "Zoom #{value.round(2)}x")
end

spacing_spin.on_value_changed do |value|
  next if syncing_controls || value == state.grid_spacing

  before = snapshot_editor_state(state)
  state.grid_spacing = value
  after = snapshot_editor_state(state)
  restore_editor_state(state, before)
  push_change.call("Change grid spacing", before, after, "Grid spacing #{value}")
end

marker_spin.on_value_changed do |value|
  next if syncing_controls || value == state.marker_size

  before = snapshot_editor_state(state)
  state.marker_size = value
  after = snapshot_editor_state(state)
  restore_editor_state(state, before)
  push_change.call("Change marker size", before, after, "Marker size #{value}")
end

show_grid.on_toggled do |checked|
  next if syncing_controls || checked == state.show_grid

  before = snapshot_editor_state(state)
  state.show_grid = checked
  after = snapshot_editor_state(state)
  restore_editor_state(state, before)
  push_change.call("Toggle grid", before, after, checked ? "Grid enabled" : "Grid hidden")
end

accent_button.on_clicked do
  if color = Qt6::ColorDialog.get_color(main, current_color: state.accent, title: "Choose Accent Color", show_alpha_channel: false)
    before = snapshot_editor_state(state)
    state.accent = color
    after = snapshot_editor_state(state)
    restore_editor_state(state, before)
    push_change.call("Change accent color", before, after, "Accent color #{color.red},#{color.green},#{color.blue}")
  end
end

reset_button.on_clicked do
  before = snapshot_editor_state(state)
  state.reset_view
  after = snapshot_editor_state(state)
  restore_editor_state(state, before)
  push_change.call("Reset view", before, after, "View reset")
end

export_button.on_clicked do
  export_png.call
end

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
edit_menu = main.menu_bar.add_menu("Edit")
view_menu = main.menu_bar.add_menu("View")
tools_menu = main.menu_bar.add_menu("Tools")

export_action = Qt6::Action.new("Export PNG", main)
export_action.shortcut = "Ctrl+E"
export_action.on_triggered { export_png.call }

reset_view_action = Qt6::Action.new("Reset View", main)
reset_view_action.shortcut = "0"
reset_view_action.on_triggered { reset_button.click }

accent_action = Qt6::Action.new("Accent Color", main)
accent_action.shortcut = "Ctrl+Shift+C"
accent_action.on_triggered { accent_button.click }

quit_action = Qt6::Action.new("Quit", main)
quit_action.shortcut = "Ctrl+Q"
quit_action.on_triggered { app.quit }

file_menu << save_action
file_menu << export_action
file_menu.add_separator
file_menu << quit_action
edit_menu << undo_action
edit_menu << redo_action
edit_menu.add_separator
edit_menu << copy_snapshot_action
view_menu << reset_view_action
tools_menu << accent_action

toolbar = Qt6::ToolBar.new("Editor", main)
toolbar << export_action
toolbar << save_action
toolbar << undo_action
toolbar << redo_action
toolbar << reset_view_action
toolbar << copy_snapshot_action
toolbar << accent_action
main.add_tool_bar(toolbar)

unless select_layer.call(state.active_layer)
  initial_index = layers_proxy.index(0, 0)
  layer_tree.current_index = initial_index
  initial_index.release
end
layer_summary.text = "Active layer: #{state.active_layer}"
sync_inspector.call
undo_stack.set_clean
update_dirty_state.call
persist_state.call
main.show
app.run
