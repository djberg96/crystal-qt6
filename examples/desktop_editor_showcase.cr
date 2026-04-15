require "../src/qt6"

class DesktopEditorShowcaseState
  property zoom : Float64
  property pan_x : Float64
  property pan_y : Float64
  property dragging : Bool
  property last_pointer : Qt6::PointF
  property active_layer : String
  property active_status : String
  property accent : Qt6::Color
  property preview_image : Qt6::QImage
  property source_description : String
  getter notes_by_layer : Hash(String, String)

  def initialize
    @zoom = 1.0
    @pan_x = 46.0
    @pan_y = 42.0
    @dragging = false
    @last_pointer = Qt6::PointF.new(0.0, 0.0)
    @active_layer = "Terrain"
    @active_status = "Visible"
    @accent = Qt6::Color.new(62, 130, 109)
    @preview_image = build_preview_image(@active_layer, @active_status, @accent)
    @source_description = "Generated in memory via QImage/QBuffer/QImageReader"
    @notes_by_layer = {
      "Terrain" => "Grid, contours, and movement cost overlays live here.",
      "Units"   => "Stacks, facing, and movement markers update frequently.",
      "Labels"  => "Rich notes, quick annotations, and export-only labels.",
    }
  end

  def note_for(name : String) : String
    @notes_by_layer[name]? || "Add notes for #{name.downcase}."
  end

  def store_note(name : String, value : String) : Nil
    @notes_by_layer[name] = value
  end

  def apply_layer(name : String, status : String) : Nil
    @active_layer = name
    @active_status = status

    @accent = case name
              when "Terrain"
                Qt6::Color.new(62, 130, 109)
              when "Units"
                Qt6::Color.new(198, 92, 62)
              else
                Qt6::Color.new(88, 104, 176)
              end

    @preview_image = build_preview_image(name, status, @accent)
    @source_description = "Generated in memory via QImage/QBuffer/QImageReader"
  end

  def use_loaded_image(name : String, status : String, image : Qt6::QImage, source_description : String) : Nil
    @active_layer = name
    @active_status = status
    @preview_image = image
    @source_description = source_description
  end

  def reset_view : Nil
    @zoom = 1.0
    @pan_x = 46.0
    @pan_y = 42.0
  end
end

def build_preview_image(layer_name : String, status : String, accent : Qt6::Color) : Qt6::QImage
  base = Qt6::QImage.new(540, 340)
  base.fill(Qt6::Color.new(245, 242, 234))

  Qt6::QPainter.paint(base) do |painter|
    painter.antialiasing = true
    painter.fill_rect(Qt6::RectF.new(24.0, 24.0, 492.0, 292.0), Qt6::Color.new(255, 255, 255))
    painter.pen = Qt6::QPen.new(Qt6::Color.new(210, 214, 220), 1.0)

    x = 24
    while x <= 516
      painter.draw_line(Qt6::PointF.new(x.to_f, 24.0), Qt6::PointF.new(x.to_f, 316.0))
      x += 41
    end

    y = 24
    while y <= 316
      painter.draw_line(Qt6::PointF.new(24.0, y.to_f), Qt6::PointF.new(516.0, y.to_f))
      y += 41
    end

    painter.pen = Qt6::QPen.new(accent, 4.0)
    painter.brush = accent
    points = [
      Qt6::PointF.new(88.0, 92.0),
      Qt6::PointF.new(196.0, 162.0),
      Qt6::PointF.new(320.0, 136.0),
      Qt6::PointF.new(438.0, 238.0),
    ]
    points.each_cons(2) do |segment|
      painter.draw_line(segment[0], segment[1])
    end

    points.each_with_index do |point, index|
      painter.draw_ellipse(Qt6::RectF.new(point.x - 12.0, point.y - 12.0, 24.0, 24.0))
      painter.draw_text(Qt6::PointF.new(point.x + 18.0, point.y + 4.0), "#{index + 1}")
    end

    painter.pen = Qt6::Color.new(46, 52, 58)
    painter.font = Qt6::QFont.new(point_size: 12, bold: true)
    painter.draw_text(Qt6::PointF.new(32.0, 42.0), "#{layer_name} preview")
    painter.font = Qt6::QFont.new(point_size: 10)
    painter.draw_text(Qt6::PointF.new(32.0, 62.0), "Status: #{status}")
    painter.draw_text(Qt6::PointF.new(32.0, 80.0), "Generated through QPainter, then round-tripped through QBuffer and QImageReader.")
  end

  encoded = base.save_to_data("PNG")
  buffer = Qt6::QBuffer.new
  buffer.open(Qt6::IODeviceOpenMode::ReadWrite)
  buffer.write(encoded)
  buffer.seek(0)

  reader = Qt6::QImageReader.new(buffer, "png")
  preview = reader.read
  reader.release
  buffer.release
  preview
end

def row_for_proxy_text(proxy : Qt6::SortFilterProxyModel, value : String) : Int32?
  row = 0
  while row < proxy.row_count
    index = proxy.index(row, 0)
    if proxy.data(index).to_s == value
      return row
    end
    row += 1
  end

  nil
end

app = Qt6.application
app.name = "Desktop Editor Showcase"
app.organization_name = "crystal-qt6"
app.organization_domain = "crystal-qt6.example"
app.style_sheet = <<-CSS
  QWidget { font-family: "Avenir Next"; font-size: 13px; color: rgb(52, 48, 42); }
  QMainWindow { background: rgb(246, 242, 235); }
  QDockWidget { font-size: 13px; }
  QLineEdit, QTextEdit, QPlainTextEdit, QTextBrowser {
    background: rgb(255, 255, 255);
    color: rgb(40, 44, 49);
    border: 1px solid rgb(205, 198, 188);
    selection-background-color: rgb(88, 104, 176);
    selection-color: rgb(255, 255, 255);
  }
  QPushButton {
    padding: 6px 12px;
    color: rgb(52, 48, 42);
    background: rgb(237, 231, 221);
    border: 1px solid rgb(201, 193, 182);
  }
  QPushButton:pressed {
    background: rgb(224, 216, 205);
  }
  QTabWidget::pane {
    background: rgb(252, 250, 246);
    border: 1px solid rgb(210, 204, 194);
  }
  QTabBar::tab {
    color: rgb(90, 84, 76);
    background: rgb(231, 225, 215);
    border: 1px solid rgb(210, 204, 194);
    padding: 6px 12px;
  }
  QTabBar::tab:selected {
    color: rgb(40, 44, 49);
    background: rgb(252, 250, 246);
  }
CSS

settings = Qt6::QSettings.for_application("crystal-qt6", "desktop_editor_showcase")
state = DesktopEditorShowcaseState.new

main = Qt6::MainWindow.new
main.window_title = "Desktop Editor Showcase"
main.resize(1380, 860)

status_bar = main.status_bar
status_bar.show_message("Preparing desktop editor showcase")

preview = Qt6::EventWidget.new
preview.resize(860, 620)
preview.accept_drops = true
preview.tool_tip = "Wheel to zoom, drag to pan, drop plain text into the preview to append it to notes."

layer_model = Qt6::StandardItemModel.new(main)
layer_model.set_horizontal_header_label(0, "Layer")
layer_model.set_horizontal_header_label(1, "State")

[
  {"Terrain", "Visible", 10, Qt6::Color.new(62, 130, 109)},
  {"Units", "Visible", 20, Qt6::Color.new(198, 92, 62)},
  {"Labels", "Draft", 30, Qt6::Color.new(88, 104, 176)},
].each_with_index do |entry, row|
  layer_item = Qt6::StandardItem.new(entry[0])
  layer_item.set_data(entry[2], Qt6::ItemDataRole::User)
  layer_item.set_data(entry[3], Qt6::ItemDataRole::Foreground)
  state_item = Qt6::StandardItem.new(entry[1])
  layer_model.set_item(row, 0, layer_item)
  layer_model.set_item(row, 1, state_item)
end

proxy = Qt6::SortFilterProxyModel.new(main)
proxy.source_model = layer_model
proxy.sort_role = Qt6::ItemDataRole::User
proxy.filter_role = Qt6::ItemDataRole::Display
proxy.filter_key_column = 0
proxy.filter_case_sensitivity = Qt6::CaseSensitivity::Insensitive
proxy.dynamic_sort_filter = true
proxy.sort

layer_search = Qt6::LineEdit.new
layer_search.placeholder_text = "Filter layers"
layer_search.text = settings.value("ui/filter", "").to_s
layer_search.completer = Qt6::Completer.new(["Terrain", "Units", "Labels"], main).tap do |completer|
  completer.case_sensitivity = Qt6::CaseSensitivity::Insensitive
  completer.completion_mode = Qt6::CompleterCompletionMode::PopupCompletion
end
proxy.filter_fixed_string = layer_search.text
proxy.invalidate

layer_tree = Qt6::TreeView.new
layer_tree.model = proxy
layer_tree.alternating_row_colors = true
layer_tree.root_is_decorated = false
layer_tree.uniform_row_heights = true
layer_tree.expand_all

selection_model = Qt6::ItemSelectionModel.new(proxy, main)
layer_tree.selection_model = selection_model

layer_name = Qt6::LineEdit.new(state.active_layer)
layer_name.placeholder_text = "Layer name"
state_combo = Qt6::ComboBox.new
state_combo << "Visible" << "Draft" << "Locked"
state_combo.current_index = 0

notes_edit = Qt6::TextEdit.new(parent: main)
notes_edit.accept_rich_text = false
notes_edit.undo_redo_enabled = true
notes_edit.placeholder_text = "Notes for the active layer"
notes_edit.plain_text = state.note_for(state.active_layer)
notes_edit.document.title = "#{state.active_layer} Notes"

summary_browser = Qt6::TextBrowser.new
summary_browser.open_external_links = false
summary_browser.default_style_sheet = "body { font-family: 'Avenir Next'; color: #32363a; } h3 { margin-bottom: 4px; } code { background: #f0eee8; padding: 1px 4px; }"

clipboard_browser = Qt6::TextBrowser.new
clipboard_browser.open_external_links = false
clipboard_browser.default_style_sheet = summary_browser.default_style_sheet

load_action = Qt6::Action.new("Load Image", main)
load_action.shortcut = "Ctrl+O"
load_action.status_tip = "Load a preview image from disk through QImageReader"

export_action = Qt6::Action.new("Export PNG", main)
export_action.shortcut = "Ctrl+E"
export_action.status_tip = "Export the current preview widget as a PNG"

copy_action = Qt6::Action.new("Copy Payload", main)
copy_action.shortcut = "Ctrl+Shift+C"
copy_action.status_tip = "Copy text, HTML, image, and a custom MIME payload to the clipboard"

inspect_action = Qt6::Action.new("Inspect Clipboard", main)
inspect_action.shortcut = "Ctrl+Shift+V"
inspect_action.status_tip = "Inspect the current clipboard MIME payload"

reset_view_action = Qt6::Action.new("Reset View", main)
reset_view_action.shortcut = "0"
reset_view_action.status_tip = "Reset preview pan and zoom"

quit_action = Qt6::Action.new("Quit", main)
quit_action.shortcut = "Ctrl+Q"
quit_action.on_triggered { app.quit }

file_menu = main.menu_bar.add_menu("File")
file_menu << load_action
file_menu << export_action
file_menu.add_separator
file_menu << quit_action

edit_menu = main.menu_bar.add_menu("Edit")
edit_menu << copy_action
edit_menu << inspect_action
edit_menu << reset_view_action

toolbar = Qt6::ToolBar.new("Workspace", main)
toolbar << load_action
toolbar << export_action
toolbar.add_separator
toolbar << copy_action
toolbar << inspect_action
toolbar.add_separator
toolbar << reset_view_action
main.add_tool_bar(toolbar)

apply_button = Qt6::PushButton.new("Apply Layer Changes")
copy_button = Qt6::PushButton.new("Copy Layer Payload")
inspect_button = Qt6::PushButton.new("Inspect Clipboard")
reset_button = Qt6::PushButton.new("Reset View")

summary_page = Qt6::Widget.new
summary_page.vbox do |column|
  column << summary_browser
end

clipboard_page = Qt6::Widget.new
clipboard_page.vbox do |column|
  column << copy_button
  column << inspect_button
  column << clipboard_browser
end

editor_page = Qt6::Widget.new
editor_page.form do |form|
  form.add_row("Layer", layer_name)
  form.add_row("State", state_combo)
  form.add_row(notes_edit)
  form.add_row(Qt6::Widget.new.tap do |button_row|
    button_row.hbox do |row|
      row << apply_button
      row << reset_button
    end
  end)
end

inspector_tabs = Qt6::TabWidget.new
inspector_tabs.add_tab(editor_page, "Editor")
inspector_tabs.add_tab(summary_page, "Summary")
inspector_tabs.add_tab(clipboard_page, "Clipboard")

layers_panel = Qt6::Widget.new
layers_panel.vbox do |column|
  column << Qt6::Label.new("Layer Browser")
  column << layer_search
  column << layer_tree
end

layers_dock = Qt6::DockWidget.new("Layers", main)
layers_dock.widget = layers_panel
main.add_dock_widget(layers_dock, Qt6::DockArea::Left)

inspector_dock = Qt6::DockWidget.new("Inspector", main)
inspector_dock.widget = inspector_tabs
main.add_dock_widget(inspector_dock, Qt6::DockArea::Right)

main.central_widget = preview

render_summary = -> do
  notes = notes_edit.plain_text
  summary_browser.html = <<-HTML
    <h3>#{state.active_layer}</h3>
    <p><strong>Status:</strong> #{state.active_status}</p>
    <p><strong>Source:</strong> #{state.source_description}</p>
    <p><strong>View:</strong> zoom #{state.zoom.round(2)}x, pan #{state.pan_x.round.to_i}, #{state.pan_y.round.to_i}</p>
    <p><strong>Document Title:</strong> #{notes_edit.document.title}</p>
    <p><strong>Notes:</strong></p>
    <pre>#{notes}</pre>
  HTML
end

inspect_clipboard = -> do
  if mime = Qt6.clipboard.mime_data
    custom_payload = mime.has_format?("application/x-crystal-qt6-showcase") ? String.new(mime.data("application/x-crystal-qt6-showcase")) : "(none)"
    clipboard_browser.html = <<-HTML
      <h3>Clipboard Payload</h3>
      <p><strong>Has Text:</strong> #{mime.has_text?}</p>
      <p><strong>Has HTML:</strong> #{mime.has_html?}</p>
      <p><strong>Has Image:</strong> #{mime.has_image?}</p>
      <p><strong>Formats:</strong> #{mime.formats.join(", ")}</p>
      <p><strong>Text:</strong> #{mime.has_text? ? mime.text : "(none)"}</p>
      <p><strong>Custom:</strong> <code>#{custom_payload}</code></p>
    HTML
    status_bar.show_message("Inspected clipboard payload", 1600)
  else
    clipboard_browser.html = "<h3>Clipboard Payload</h3><p>Clipboard MIME data is currently unavailable.</p>"
    status_bar.show_message("Clipboard MIME data unavailable", 1600)
  end
end

copy_payload = -> do
  mime_data = Qt6::MimeData.new
  mime_data.text = "#{state.active_layer} | #{state.active_status}\n#{notes_edit.plain_text}"
  mime_data.html = <<-HTML
    <h3>#{state.active_layer}</h3>
    <p><strong>Status:</strong> #{state.active_status}</p>
    <p>#{notes_edit.plain_text}</p>
  HTML
  mime_data.image = state.preview_image
  mime_data.set_data("application/x-crystal-qt6-showcase", "layer=#{state.active_layer};status=#{state.active_status};zoom=#{state.zoom.round(2)}")
  Qt6.clipboard.mime_data = mime_data
  inspect_clipboard.call
  status_bar.show_message("Copied text, HTML, image, and custom MIME payload", 1800)
end

apply_layer_controls = -> do
  current = layer_tree.current_index
  if current.valid?
    source_name_index = proxy.map_to_source(proxy.index(current.row, 0))
    source_state_index = layer_model.index(source_name_index.row, 1)
    source_name_item = layer_model.item_from_index(source_name_index).not_nil!

    old_name = state.active_layer
    new_name = layer_name.text.strip
    new_name = old_name if new_name.empty?

    current_note = notes_edit.plain_text
    state.notes_by_layer.delete(old_name) if new_name != old_name
    state.store_note(new_name, current_note)

    source_name_item.text = new_name
    layer_model.set_data(source_state_index, state_combo.current_text)
    proxy.sort

    state.apply_layer(new_name, state_combo.current_text)
    notes_edit.document.title = "#{new_name} Notes"
    settings.set_value("ui/active_layer", new_name)
    settings.sync
    render_summary.call
    preview.update
    status_bar.show_message("Updated #{new_name}", 1600)

    if row = row_for_proxy_text(proxy, new_name)
      layer_tree.current_index = proxy.index(row, 0)
    end
  end
end

sync_from_selection = -> do
  current = layer_tree.current_index
  if current.valid?
    source_name_index = proxy.map_to_source(proxy.index(current.row, 0))
    source_state_index = layer_model.index(source_name_index.row, 1)
    name = layer_model.data(source_name_index).to_s
    status = layer_model.data(source_state_index).to_s

    state.store_note(state.active_layer, notes_edit.plain_text) unless state.active_layer.empty?
    state.apply_layer(name, status)
    layer_name.text = name
    state_combo.current_index = case status
                                when "Draft"  then 1
                                when "Locked" then 2
                                else               0
                                end
    notes_edit.plain_text = state.note_for(name)
    notes_edit.document.title = "#{name} Notes"
    settings.set_value("ui/active_layer", name)
    settings.sync
    render_summary.call
    preview.update
    status_bar.show_message("Selected #{name}", 1400)
  end
end

load_image = -> do
  selected_path = Qt6::FileDialog.get_open_file_name(main, title: "Load Preview Image", directory: Dir.current, filter: "Images (*.png *.jpg *.jpeg *.bmp);;All Files (*)")
  if selected_path && !selected_path.empty?
    reader = Qt6::QImageReader.new(selected_path)
    if reader.can_read?
      image = reader.read
      unless image.null?
        state.use_loaded_image(state.active_layer, state.active_status, image, File.basename(selected_path))
        render_summary.call
        preview.update
        settings.set_value("ui/last_image_path", selected_path)
        settings.sync
        status_bar.show_message("Loaded #{File.basename(selected_path)}", 1800)
      else
        status_bar.show_message("Image reader returned an empty image", 2200)
      end
    else
      status_bar.show_message("Cannot read #{File.basename(selected_path)}: #{reader.error_string}", 2400)
    end
    reader.release
  end
end

export_png = -> do
  suggested_path = settings.value("ui/last_export_path", File.join(Dir.current, "desktop-editor-showcase.png")).to_s
  output_path = Qt6::FileDialog.get_save_file_name(main, title: "Export Preview PNG", directory: suggested_path, filter: "PNG Images (*.png);;All Files (*)")
  if output_path && !output_path.empty?
    output_path = "#{output_path}.png" unless output_path.downcase.ends_with?(".png")
    if preview.grab.save(output_path)
      settings.set_value("ui/last_export_path", output_path)
      settings.sync
      status_bar.show_message("Exported #{File.basename(output_path)}", 1800)
    else
      status_bar.show_message("Failed to export PNG", 2200)
    end
  end
end

layer_search.on_text_changed do |value|
  proxy.filter_fixed_string = value
  proxy.invalidate
  settings.set_value("ui/filter", value)
end

notes_edit.on_text_changed do
  state.store_note(state.active_layer, notes_edit.plain_text)
  render_summary.call
end

layer_tree.on_current_index_changed do
  sync_from_selection.call
end

load_action.on_triggered do
  load_image.call
end

export_action.on_triggered do
  export_png.call
end

copy_action.on_triggered do
  copy_payload.call
end

inspect_action.on_triggered do
  inspect_clipboard.call
end

reset_view_action.on_triggered do
  state.reset_view
  preview.update
  render_summary.call
  status_bar.show_message("Preview view reset", 1400)
end

copy_button.on_clicked { copy_payload.call }
inspect_button.on_clicked { inspect_clipboard.call }
apply_button.on_clicked { apply_layer_controls.call }
reset_button.on_clicked { reset_view_action.trigger }

preview.on_mouse_press do |event|
  state.dragging = true
  state.last_pointer = event.position
  status_bar.show_message("Dragging preview", 900)
end

preview.on_mouse_move do |event|
  if state.dragging
    state.pan_x += event.position.x - state.last_pointer.x
    state.pan_y += event.position.y - state.last_pointer.y
    state.last_pointer = event.position
    render_summary.call
    preview.update
  end
end

preview.on_mouse_release do |_event|
  state.dragging = false
  status_bar.show_message("Preview settled", 900)
end

preview.on_wheel do |event|
  step = event.angle_delta.y >= 0 ? 1.1 : 0.9
  state.zoom = (state.zoom * step).clamp(0.45, 3.0)
  render_summary.call
  preview.update
  status_bar.show_message("Zoom #{state.zoom.round(2)}x", 1200)
end

preview.on_drag_enter do |event|
  if event.mime_data.try(&.has_text?)
    event.accept_proposed_action
  else
    event.ignore
  end
end

preview.on_drag_move do |event|
  if event.mime_data.try(&.has_text?)
    event.accept_proposed_action
  else
    event.ignore
  end
end

preview.on_drop do |event|
  if payload = event.mime_data
    notes_edit.append(payload.text)
    state.store_note(state.active_layer, notes_edit.plain_text)
    render_summary.call
    preview.update
    status_bar.show_message("Imported dropped text into notes", 1800)
    event.accept_proposed_action
  else
    event.ignore
  end
end

preview.on_key_press do |event|
  case event.key
  when 48
    reset_view_action.trigger
  when 43, 61
    state.zoom = (state.zoom * 1.1).clamp(0.45, 3.0)
    render_summary.call
    preview.update
  when 45
    state.zoom = (state.zoom * 0.9).clamp(0.45, 3.0)
    render_summary.call
    preview.update
  end
end

preview.on_paint_with_painter do |event, painter|
  painter.fill_rect(event.rect, Qt6::Color.new(236, 232, 224))

  x = 0
  while x < event.rect.width.to_i
    painter.fill_rect(Qt6::RectF.new(x.to_f, 0.0, 1.0, event.rect.height), Qt6::Color.new(228, 224, 216))
    x += 28
  end

  y = 0
  while y < event.rect.height.to_i
    painter.fill_rect(Qt6::RectF.new(0.0, y.to_f, event.rect.width, 1.0), Qt6::Color.new(228, 224, 216))
    y += 28
  end

  painter.save
  painter.translate(state.pan_x, state.pan_y)
  painter.scale(state.zoom, state.zoom)
  painter.draw_image(Qt6::PointF.new(0.0, 0.0), state.preview_image)
  painter.restore

  painter.pen = Qt6::QPen.new(state.accent, 2.0)
  painter.brush = Qt6::Color.new(0, 0, 0, 0)
  painter.draw_rect(Qt6::RectF.new(18.0, 18.0, event.rect.width - 36.0, event.rect.height - 36.0))

  painter.pen = Qt6::Color.new(46, 52, 58)
  painter.font = Qt6::QFont.new(point_size: 11, bold: true)
  painter.draw_text(Qt6::PointF.new(22.0, 28.0), "#{state.active_layer} | #{state.active_status} | #{state.source_description}")
  painter.font = Qt6::QFont.new(point_size: 10)
  painter.draw_text(Qt6::PointF.new(22.0, 46.0), "Wheel to zoom, drag to pan, drop plain text to append to notes, Ctrl+Shift+C to copy MIME payload.")
end

render_summary.call
inspect_clipboard.call

initial_layer = settings.value("ui/active_layer", state.active_layer).to_s
if row = row_for_proxy_text(proxy, initial_layer)
  layer_tree.current_index = proxy.index(row, 0)
else
  layer_tree.current_index = proxy.index(0, 0)
end

main.show
status_bar.show_message("Ready")
app.run
