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

about_dialog = Qt6::Dialog.new(main)
about_dialog.window_title = "About crystal-qt6"
about_dialog.vbox do |column|
  column << Qt6::Label.new("This example uses QMainWindow, menus, actions, docks, dialogs, and common controls.")
  close_button = Qt6::PushButton.new("Close")
  close_button.on_clicked { about_dialog.accept }
  column << close_button
end

layer_name = Qt6::LineEdit.new("Terrain")
snap_check = Qt6::CheckBox.new("Enable snapping")
layer_kind = Qt6::ComboBox.new
layer_kind << "Hexes" << "Terrain" << "Units"

apply_changes = -> do
  canvas_label.text = "#{layer_kind.current_text}: #{layer_name.text}"
  mode = snap_check.checked? ? "Snapping on" : "Snapping off"
  status_bar.show_message("#{mode} for #{layer_kind.current_text.downcase}")
end

about_action = Qt6::Action.new("About", main)
about_action.on_triggered do
  about_dialog.exec
end

apply_action = Qt6::Action.new("Apply", main)
apply_action.on_triggered do
  apply_changes.call
end

quit_action = Qt6::Action.new("Quit", main)
quit_action.on_triggered do
  app.quit
end

file_menu << about_action
file_menu.add_separator
file_menu << quit_action
tools_menu << apply_action

toolbar = Qt6::ToolBar.new("Main", main)
toolbar << about_action
toolbar << apply_action
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