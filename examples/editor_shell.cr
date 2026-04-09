require "../src/qt6"

app = Qt6.application

main = Qt6::MainWindow.new
main.window_title = "Editor Shell"
main.resize(960, 640)

canvas_label = Qt6::Label.new("Pick a layer and press Apply")
main.central_widget = canvas_label

status_bar = main.status_bar
status_bar.show_message("Ready")

file_menu = main.menu_bar.add_menu("File")
tools_menu = main.menu_bar.add_menu("Tools")

about_dialog = Qt6::MessageBox.new(main)
about_dialog.window_title = "About crystal-qt6"
about_dialog.icon = Qt6::MessageBoxIcon::Information
about_dialog.text = "This example uses QMainWindow, menus, actions, docks, standard dialogs, and common controls."
about_dialog.informative_text = "Try Ctrl+O for QFileDialog or Ctrl+, for this message box."
about_dialog.standard_buttons = Qt6::MessageBoxButton::Ok

open_dialog = Qt6::FileDialog.new(main, Dir.current, "Maps (*.map *.json);;All Files (*)")
open_dialog.window_title = "Open Map"
open_dialog.accept_mode = Qt6::FileDialogAcceptMode::Open
open_dialog.file_mode = Qt6::FileDialogFileMode::ExistingFile

color_dialog = Qt6::ColorDialog.new(main)
color_dialog.window_title = "Pick Accent Color"
color_dialog.current_color = Qt6::Color.new(32, 96, 192)
color_dialog.show_alpha_channel = true

rename_dialog = Qt6::InputDialog.new(main)
rename_dialog.window_title = "Rename Layer"
rename_dialog.input_mode = Qt6::InputDialogInputMode::Text
rename_dialog.label_text = "Layer name"

layer_name = Qt6::LineEdit.new("Terrain")
snap_check = Qt6::CheckBox.new("Enable snapping")
layer_kind = Qt6::ComboBox.new
layer_kind << "Hexes" << "Terrain" << "Units"
rename_dialog.text_value = layer_name.text

apply_changes = -> do
  canvas_label.text = "#{layer_kind.current_text}: #{layer_name.text}"
  mode = snap_check.checked? ? "Snapping on" : "Snapping off"
  status_bar.show_message("#{mode} for #{layer_kind.current_text.downcase}")
end

about_action = Qt6::Action.new("About", main)
about_action.shortcut = "Ctrl+,"
about_action.on_triggered do
  about_dialog.exec
end

open_action = Qt6::Action.new("Open", main)
open_action.shortcut = "Ctrl+O"
open_action.on_triggered do
  if open_dialog.exec == Qt6::DialogCode::Accepted
    selected_file = open_dialog.selected_file
    status_bar.show_message(selected_file.empty? ? "No file selected" : "Opened #{File.basename(selected_file)}")
  end
end

rename_action = Qt6::Action.new("Rename Layer", main)
rename_action.shortcut = "Ctrl+R"
rename_action.on_triggered do
  rename_dialog.text_value = layer_name.text
  if rename_dialog.exec == Qt6::DialogCode::Accepted
    layer_name.text = rename_dialog.text_value
    apply_changes.call
  end
end

color_action = Qt6::Action.new("Accent Color", main)
color_action.shortcut = "Ctrl+Shift+C"
color_action.on_triggered do
  if color_dialog.exec == Qt6::DialogCode::Accepted
    color = color_dialog.current_color
    status_bar.show_message("Accent color #{color.red},#{color.green},#{color.blue},#{color.alpha}")
  end
end

apply_action = Qt6::Action.new("Apply", main)
apply_action.shortcut = Qt6::KeySequence.new("Ctrl+Return")
apply_action.on_triggered do
  apply_changes.call
end

quit_action = Qt6::Action.new("Quit", main)
quit_action.shortcut = "Ctrl+Q"
quit_action.on_triggered do
  app.quit
end

mode_group = Qt6::ActionGroup.new(main)
mode_group.exclusive = true
edit_mode = Qt6::Action.new("Edit Mode", main)
preview_mode = Qt6::Action.new("Preview Mode", main)
edit_mode.checkable = true
preview_mode.checkable = true
edit_mode.checked = true
mode_group << edit_mode
mode_group << preview_mode
tools_menu << edit_mode
tools_menu << preview_mode

file_menu << open_action
file_menu << about_action
file_menu.add_separator
file_menu << quit_action
tools_menu << rename_action
tools_menu << color_action
tools_menu << apply_action

toolbar = Qt6::ToolBar.new("Main", main)
toolbar << open_action
toolbar << about_action
toolbar << rename_action
toolbar << color_action
toolbar << apply_action
toolbar << edit_mode
toolbar << preview_mode
main.add_tool_bar(toolbar)

snap_check.on_toggled do |checked|
  status_bar.show_message(checked ? "Snapping enabled" : "Snapping disabled", 1500)
end

layer_kind.on_current_index_changed do |_index|
  status_bar.show_message("Selected #{layer_kind.current_text.downcase} layer", 1500)
end

apply_button = Qt6::PushButton.new("Apply")
apply_button.on_clicked do
  apply_changes.call
end

inspector = Qt6::Widget.new
inspector.vbox do |column|
  column << Qt6::Label.new("Layer name")
  column << layer_name
  column << snap_check
  column << Qt6::Label.new("Layer kind")
  column << layer_kind
  column << apply_button
end

dock = Qt6::DockWidget.new("Inspector", main)
dock.widget = inspector
main.add_dock_widget(dock, Qt6::DockArea::Left)

main.show
app.run