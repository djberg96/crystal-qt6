require "../src/qt6"

OUTPUT_DIR = File.expand_path("../docs/book/images", __DIR__)
Dir.mkdir_p(OUTPUT_DIR)

def process_paints(app : Qt6::Application)
  12.times { app.process_events }
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
  widget.show
  widget.update
  process_paints(app)

  output = File.join(OUTPUT_DIR, file_name)
  abort "Could not write #{output}" unless widget.grab.save(output)
  flatten_png(output)
  puts output

  widget.close
  process_paints(app)
end

app = Qt6.application(["capture-application-shell-screenshots"])
app.name = "Application Shell Screenshots"
app.organization_name = "crystal-qt6"
app.style_sheet = <<-CSS
  QMainWindow, QWidget {
    font-size: 14px;
  }
  QMainWindow, QToolBar, QStatusBar, QDockWidget {
    background: rgb(246, 248, 250);
    color: rgb(31, 41, 55);
  }
  QToolButton {
    color: white;
    padding: 4px 10px;
  }
  QLabel {
    color: rgb(17, 24, 39);
  }
  QDockWidget {
    font-weight: bold;
  }
  QLineEdit, QComboBox {
    background: white;
    color: rgb(17, 24, 39);
    border: 1px solid rgb(188, 198, 207);
    border-radius: 4px;
    padding: 4px 6px;
  }
  QCheckBox {
    color: rgb(17, 24, 39);
  }
CSS

main = Qt6::MainWindow.new
main.window_title = "Project Shell"
main.resize(980, 640)

status = main.status_bar
status.show_message("Ready")

canvas = Qt6::Label.new("Project canvas\n\nCentral widget: the primary work area")
canvas.set_minimum_size(520, 360)
canvas.style_sheet = "background: rgb(246, 248, 250); border: 1px solid rgb(190, 202, 214); color: rgb(31, 41, 55); padding: 18px;"
main.central_widget = canvas

open_action = Qt6::Action.new("Open", main)
open_action.shortcut = "Ctrl+O"
open_action.status_tip = "Open a project"

save_action = Qt6::Action.new("Save", main)
save_action.shortcut = "Ctrl+S"
save_action.status_tip = "Save the current project"
save_action.enabled = false

apply_action = Qt6::Action.new("Apply", main)
apply_action.shortcut = Qt6::KeySequence.new("Ctrl+Return")

quit_action = Qt6::Action.new("Quit", main)
quit_action.shortcut = "Ctrl+Q"

file_menu = main.menu_bar.add_menu("File")
file_menu << open_action
file_menu << save_action
file_menu.add_separator
file_menu << quit_action

view_menu = main.menu_bar.add_menu("View")
tools_menu = main.menu_bar.add_menu("Tools")
tools_menu << apply_action

toolbar = Qt6::ToolBar.new("Main", main)
toolbar << open_action
toolbar << save_action
toolbar.add_separator
toolbar << apply_action
toolbar.movable = true
main.add_tool_bar(toolbar)
view_menu << toolbar.toggle_view_action

layer_name = Qt6::LineEdit.new("Terrain")
layer_kind = Qt6::ComboBox.new
layer_kind << "Hexes" << "Terrain" << "Units"
layer_kind.current_index = 1
snap_check = Qt6::CheckBox.new("Enable snapping")
snap_check.checked = true

inspector = Qt6::Widget.new
inspector.form do |form|
  form.add_row("Layer name", layer_name)
  form.add_row("Layer kind", layer_kind)
  form.add_row(snap_check)
end

dock = Qt6::DockWidget.new("Inspector", main)
dock.widget = inspector
main.add_dock_widget(dock, Qt6::DockArea::Left)

dock_visible = Qt6::Action.new("Inspector", main)
dock_visible.checkable = true
dock_visible.checked = true
dock_visible.on_toggled { |visible| dock.visible = visible }
view_menu << dock_visible

save_widget(app, main, "application-shell-main-window.png")
