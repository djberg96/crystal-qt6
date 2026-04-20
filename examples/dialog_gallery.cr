require "../src/qt6"

app = Qt6.application
auto_dialog = ARGV.find { |arg| arg.starts_with?("--auto=") }.try { |arg| arg.split("=", 2)[1]? || "" }

main = Qt6::MainWindow.new
main.window_title = "Dialog Gallery"
main.resize(760, 520)
main.move(120, 80) if auto_dialog

status_bar = main.status_bar
status_bar.show_message("Ready")

last_color = Qt6::Color.new(52, 112, 176)
last_font = Qt6::QFont.new("Sans Serif", 12)

summary = Qt6::Label.new("Open a dialog to see the result here.")
color_summary = Qt6::Label.new("Current color: rgba(52, 112, 176, 255)")
font_summary = Qt6::Label.new("Current font: Sans Serif, 12 pt")
file_summary = Qt6::Label.new("No file selected")
input_summary = Qt6::Label.new("No input value chosen")
progress_summary = Qt6::Label.new("No progress run yet")

swatch = Qt6::Label.new("")
swatch.set_fixed_size(128, 28)
swatch.style_sheet = "background-color: rgba(52, 112, 176, 255); border: 1px solid #6b7280;"

record_result = ->(title : String, detail : String) do
  summary.text = "#{title}: #{detail}"
  status_bar.show_message(detail, 3000)
end

show_message = -> do
  answer = Qt6::MessageBox.question(
    main,
    title: "Save Changes?",
    text: "This is a QMessageBox convenience helper.",
    informative_text: "The selected button is returned as a Crystal enum.",
    buttons: Qt6::MessageBoxButton::Yes | Qt6::MessageBoxButton::No | Qt6::MessageBoxButton::Cancel
  )
  record_result.call("MessageBox", "selected #{answer}")
end

show_warning_message = -> do
  answer = Qt6::MessageBox.warning(
    main,
    title: "Layer Warning",
    text: "The selected layer is locked.",
    informative_text: "Unlock the layer before editing its geometry.",
    buttons: Qt6::MessageBoxButton::Ok | Qt6::MessageBoxButton::Cancel
  )
  record_result.call("MessageBox", "selected #{answer}")
end

show_file = -> do
  if path = Qt6::FileDialog.get_open_file_name(main, "Open Example File", Dir.current, "Crystal files (*.cr);;All Files (*)")
    file_summary.text = path.empty? ? "No file selected" : path
    record_result.call("FileDialog", path.empty? ? "no file selected" : File.basename(path))
  else
    record_result.call("FileDialog", "canceled")
  end
end

show_save_file = -> do
  if path = Qt6::FileDialog.get_save_file_name(main, "Save Example File", Dir.current, "Map files (*.json *.map);;All Files (*)")
    file_summary.text = path.empty? ? "No file selected" : path
    record_result.call("FileDialog", path.empty? ? "no file selected" : File.basename(path))
  else
    record_result.call("FileDialog", "canceled")
  end
end

show_color = -> do
  if color = Qt6::ColorDialog.get_color(main, current_color: last_color, title: "Pick Accent Color", show_alpha_channel: true)
    last_color = color
    rgba = "rgba(#{color.red}, #{color.green}, #{color.blue}, #{color.alpha})"
    color_summary.text = "Current color: #{rgba}"
    swatch.style_sheet = "background-color: #{rgba}; border: 1px solid #6b7280;"
    record_result.call("ColorDialog", rgba)
  else
    record_result.call("ColorDialog", "canceled")
  end
end

show_color_without_alpha = -> do
  if color = Qt6::ColorDialog.get_color(main, current_color: last_color, title: "Pick Layer Color", show_alpha_channel: false)
    last_color = color
    rgba = "rgba(#{color.red}, #{color.green}, #{color.blue}, #{color.alpha})"
    color_summary.text = "Current color: #{rgba}"
    swatch.style_sheet = "background-color: #{rgba}; border: 1px solid #6b7280;"
    record_result.call("ColorDialog", rgba)
  else
    record_result.call("ColorDialog", "canceled")
  end
end

show_font = -> do
  if font = Qt6::FontDialog.get_font(main, last_font, "Choose Label Font")
    last_font = font
    style = [font.bold? ? "bold" : nil, font.italic? ? "italic" : nil].compact.join(", ")
    style = "regular" if style.empty?
    font_summary.text = "Current font: #{font.family}, #{font.point_size} pt, #{style}"
    record_result.call("FontDialog", "#{font.family}, #{font.point_size} pt")
  else
    record_result.call("FontDialog", "canceled")
  end
end

show_monospaced_font = -> do
  if font = Qt6::FontDialog.get_font(main, Qt6::QFont.new("Menlo", 12), "Choose Code Font", Qt6::FontDialogOption::MonospacedFonts)
    last_font = font
    style = [font.bold? ? "bold" : nil, font.italic? ? "italic" : nil].compact.join(", ")
    style = "regular" if style.empty?
    font_summary.text = "Current font: #{font.family}, #{font.point_size} pt, #{style}"
    record_result.call("FontDialog", "#{font.family}, #{font.point_size} pt")
  else
    record_result.call("FontDialog", "canceled")
  end
end

show_input = -> do
  if name = Qt6::InputDialog.get_text(main, title: "Rename Layer", label: "Layer name", value: "Terrain")
    input_summary.text = "Text value: #{name}"
    record_result.call("InputDialog", "text #{name}")
  else
    record_result.call("InputDialog", "canceled")
  end
end

show_numeric_input = -> do
  if opacity = Qt6::InputDialog.get_int(main, title: "Layer Opacity", label: "Opacity percent", value: 72, minimum: 0, maximum: 100)
    input_summary.text = "Integer value: #{opacity}%"
    record_result.call("InputDialog", "integer #{opacity}%")
  else
    record_result.call("InputDialog", "canceled")
  end
end

show_choice_input = -> do
  choices = ["Terrain", "Roads", "Units", "Annotations"]
  if layer = Qt6::InputDialog.get_item(main, title: "Layer Kind", label: "Kind", items: choices, current: 1, editable: false)
    input_summary.text = "Choice value: #{layer}"
    record_result.call("InputDialog", "choice #{layer}")
  else
    record_result.call("InputDialog", "canceled")
  end
end

show_progress = -> do
  progress = Qt6::ProgressDialog.new(main, "Generating preview assets...", "Cancel", 0, 100)
  progress.window_title = "ProgressDialog"
  progress.minimum_duration = 0
  progress.auto_close = true
  progress.auto_reset = true
  progress.value = 0
  progress.show

  timer = Qt6::QTimer.new(main)
  value = 0

  progress.on_canceled do
    timer.stop
    progress_summary.text = "Progress canceled at #{progress.value}%"
    record_result.call("ProgressDialog", "canceled")
  end

  timer.on_timeout do
    value += 8
    value = 100 if value > 100
    progress.value = value
    progress_summary.text = "Progress value: #{progress.value}%"

    if value >= 100
      timer.stop
      progress_summary.text = "Progress completed"
      record_result.call("ProgressDialog", "completed")
    end
  end

  timer.start(80)
end

show_custom_settings = -> do
  dialog = Qt6::Dialog.new(main)
  dialog.window_title = "Layer Settings"
  dialog.resize(420, 220)

  name_edit = Qt6::LineEdit.new("Terrain", dialog)
  opacity_spin = Qt6::SpinBox.new(dialog)
  opacity_spin.set_range(0, 100)
  opacity_spin.value = 72
  opacity_spin.suffix = "%"

  kind_combo = Qt6::ComboBox.new(dialog)
  ["Terrain", "Roads", "Units", "Annotations"].each { |item| kind_combo << item }
  kind_combo.current_index = 1

  visible_check = Qt6::CheckBox.new("Visible", dialog)
  visible_check.checked = true

  buttons = Qt6::DialogButtonBox.new(
    Qt6::DialogButtonBoxStandardButton::Ok | Qt6::DialogButtonBoxStandardButton::Cancel,
    dialog
  )
  buttons.on_accepted { dialog.accept }
  buttons.on_rejected { dialog.reject }

  dialog.vbox do |layout|
    form_host = Qt6::Widget.new(dialog)
    form_host.form do |form|
      form.add_row("Name", name_edit)
      form.add_row("Opacity", opacity_spin)
      form.add_row("Kind", kind_combo)
      form.add_row("", visible_check)
    end
    layout << form_host
    layout << buttons
  end

  begin
    if dialog.exec == Qt6::DialogCode::Accepted
      input_summary.text = "Settings: #{name_edit.text}, #{opacity_spin.value}%, #{kind_combo.current_text}"
      record_result.call("Dialog", "accepted layer settings")
    else
      record_result.call("Dialog", "canceled")
    end
  ensure
    dialog.release
  end
end

auto_widgets = [] of Qt6::Widget

auto_message_question = -> do
  dialog = Qt6::MessageBox.new(main)
  dialog.window_title = "Save Changes?"
  dialog.icon = Qt6::MessageBoxIcon::Question
  dialog.text = "This is a QMessageBox convenience helper."
  dialog.informative_text = "The selected button is returned as a Crystal enum."
  dialog.standard_buttons = Qt6::MessageBoxButton::Yes | Qt6::MessageBoxButton::No | Qt6::MessageBoxButton::Cancel
  dialog.show
  auto_widgets << dialog
end

auto_message_warning = -> do
  dialog = Qt6::MessageBox.new(main)
  dialog.window_title = "Layer Warning"
  dialog.icon = Qt6::MessageBoxIcon::Warning
  dialog.text = "The selected layer is locked."
  dialog.informative_text = "Unlock the layer before editing its geometry."
  dialog.standard_buttons = Qt6::MessageBoxButton::Ok | Qt6::MessageBoxButton::Cancel
  dialog.show
  auto_widgets << dialog
end

auto_file_open = -> do
  dialog = Qt6::FileDialog.new(main, Dir.current, "Crystal files (*.cr);;All Files (*)")
  dialog.window_title = "Open Example File"
  dialog.accept_mode = Qt6::FileDialogAcceptMode::Open
  dialog.file_mode = Qt6::FileDialogFileMode::ExistingFile
  dialog.show
  auto_widgets << dialog
end

auto_file_save = -> do
  dialog = Qt6::FileDialog.new(main, Dir.current, "Map files (*.json *.map);;All Files (*)")
  dialog.window_title = "Save Example File"
  dialog.accept_mode = Qt6::FileDialogAcceptMode::Save
  dialog.file_mode = Qt6::FileDialogFileMode::AnyFile
  dialog.select_file("project-output.map")
  dialog.show
  auto_widgets << dialog
end

auto_color_dialog = -> do
  dialog = Qt6::ColorDialog.new(main)
  dialog.window_title = "Pick Layer Color"
  dialog.current_color = last_color
  dialog.native_dialog = false
  dialog.show_alpha_channel = false
  dialog.show
  auto_widgets << dialog
end

auto_color_alpha = -> do
  dialog = Qt6::ColorDialog.new(main)
  dialog.window_title = "Pick Accent Color"
  dialog.current_color = last_color
  dialog.native_dialog = false
  dialog.show_alpha_channel = true
  dialog.show
  auto_widgets << dialog
end

auto_font_dialog = -> do
  dialog = Qt6::FontDialog.new(main, last_font)
  dialog.window_title = "Choose Label Font"
  dialog.native_dialog = false
  dialog.show
  auto_widgets << dialog
end

auto_font_monospaced = -> do
  dialog = Qt6::FontDialog.new(main, Qt6::QFont.new("Monospace", 12))
  dialog.window_title = "Choose Code Font"
  dialog.options = Qt6::FontDialogOption::MonospacedFonts
  dialog.show
  auto_widgets << dialog
end

auto_input_text = -> do
  dialog = Qt6::InputDialog.new(main)
  dialog.window_title = "Rename Layer"
  dialog.input_mode = Qt6::InputDialogInputMode::Text
  dialog.label_text = "Layer name"
  dialog.text_value = "Terrain"
  dialog.show
  auto_widgets << dialog
end

auto_input_int = -> do
  dialog = Qt6::InputDialog.new(main)
  dialog.window_title = "Layer Opacity"
  dialog.input_mode = Qt6::InputDialogInputMode::Int
  dialog.label_text = "Opacity percent"
  dialog.int_range = 0..100
  dialog.int_value = 72
  dialog.show
  auto_widgets << dialog
end

auto_input_choice = -> do
  dialog = Qt6::InputDialog.new(main)
  dialog.window_title = "Layer Kind"
  dialog.input_mode = Qt6::InputDialogInputMode::Text
  dialog.label_text = "Kind"
  dialog.combo_box_items = ["Terrain", "Roads", "Units", "Annotations"]
  dialog.combo_box_editable = false
  dialog.text_value = "Roads"
  dialog.show
  auto_widgets << dialog
end

auto_custom_settings = -> do
  dialog = Qt6::Dialog.new(main)
  dialog.window_title = "Layer Settings"
  dialog.resize(420, 220)

  name_edit = Qt6::LineEdit.new("Terrain", dialog)
  opacity_spin = Qt6::SpinBox.new(dialog)
  opacity_spin.set_range(0, 100)
  opacity_spin.value = 72
  opacity_spin.suffix = "%"

  kind_combo = Qt6::ComboBox.new(dialog)
  ["Terrain", "Roads", "Units", "Annotations"].each { |item| kind_combo << item }
  kind_combo.current_index = 1

  visible_check = Qt6::CheckBox.new("Visible", dialog)
  visible_check.checked = true

  buttons = Qt6::DialogButtonBox.new(
    Qt6::DialogButtonBoxStandardButton::Ok | Qt6::DialogButtonBoxStandardButton::Cancel,
    dialog
  )
  buttons.on_accepted { dialog.accept }
  buttons.on_rejected { dialog.reject }

  dialog.vbox do |layout|
    form_host = Qt6::Widget.new(dialog)
    form_host.form do |form|
      form.add_row("Name", name_edit)
      form.add_row("Opacity", opacity_spin)
      form.add_row("Kind", kind_combo)
      form.add_row("", visible_check)
    end
    layout << form_host
    layout << buttons
  end

  dialog.show
  auto_widgets << dialog
end

auto_actions = {} of String => Proc(Nil)
auto_actions["main"] = -> { }
auto_actions["message-question"] = auto_message_question
auto_actions["message-warning"] = auto_message_warning
auto_actions["file-open"] = show_file
auto_actions["file-save"] = show_save_file
auto_actions["color-dialog"] = auto_color_dialog
auto_actions["color-alpha"] = auto_color_alpha
auto_actions["font-dialog"] = auto_font_dialog
auto_actions["font-monospaced"] = show_monospaced_font
auto_actions["input-text"] = auto_input_text
auto_actions["input-int"] = auto_input_int
auto_actions["input-choice"] = auto_input_choice
auto_actions["progress-dialog"] = show_progress
auto_actions["progress-canceled"] = show_progress
auto_actions["custom-settings"] = auto_custom_settings

open_message_action = Qt6::Action.new("Message Box", main)
open_file_action = Qt6::Action.new("Open File", main)
open_color_action = Qt6::Action.new("Color", main)
open_font_action = Qt6::Action.new("Font", main)
open_text_action = Qt6::Action.new("Text Input", main)
open_int_action = Qt6::Action.new("Integer Input", main)
open_choice_action = Qt6::Action.new("Choice Input", main)
open_progress_action = Qt6::Action.new("Progress", main)
open_settings_action = Qt6::Action.new("Settings", main)
quit_action = Qt6::Action.new("Quit", main)

open_message_action.on_triggered { show_message.call }
open_file_action.on_triggered { show_file.call }
open_color_action.on_triggered { show_color.call }
open_font_action.on_triggered { show_font.call }
open_text_action.on_triggered { show_input.call }
open_int_action.on_triggered { show_numeric_input.call }
open_choice_action.on_triggered { show_choice_input.call }
open_progress_action.on_triggered { show_progress.call }
open_settings_action.on_triggered { show_custom_settings.call }
quit_action.on_triggered { app.quit }

file_menu = main.menu_bar.add_menu("File")
file_menu << open_file_action
file_menu.add_separator
file_menu << quit_action

dialogs_menu = main.menu_bar.add_menu("Dialogs")
dialogs_menu << open_message_action
dialogs_menu << open_color_action
dialogs_menu << open_font_action
dialogs_menu << open_text_action
dialogs_menu << open_int_action
dialogs_menu << open_choice_action
dialogs_menu << open_progress_action
dialogs_menu << open_settings_action

toolbar = Qt6::ToolBar.new("Dialogs", main)
toolbar << open_message_action
toolbar << open_file_action
toolbar << open_color_action
toolbar << open_font_action
toolbar << open_text_action
toolbar << open_progress_action
toolbar << open_settings_action
main.add_tool_bar(toolbar)

message_button = Qt6::PushButton.new("Message Box")
message_button.on_clicked { show_message.call }

file_button = Qt6::PushButton.new("File Dialog")
file_button.on_clicked { show_file.call }

color_button = Qt6::PushButton.new("Color Dialog")
color_button.on_clicked { show_color.call }

font_button = Qt6::PushButton.new("Font Dialog")
font_button.on_clicked { show_font.call }

text_button = Qt6::PushButton.new("Text Input")
text_button.on_clicked { show_input.call }

int_button = Qt6::PushButton.new("Integer Input")
int_button.on_clicked { show_numeric_input.call }

choice_button = Qt6::PushButton.new("Choice Input")
choice_button.on_clicked { show_choice_input.call }

progress_button = Qt6::PushButton.new("Progress Dialog")
progress_button.on_clicked { show_progress.call }

settings_button = Qt6::PushButton.new("Settings Dialog")
settings_button.on_clicked { show_custom_settings.call }

central = Qt6::Widget.new
central.vbox do |layout|
  intro = Qt6::GroupBox.new("Standard dialog helpers")
  intro.vbox do |box|
    box << Qt6::Label.new("Use the buttons, toolbar, or Dialogs menu to open each wrapped Qt dialog.")
    box << summary
  end
  layout << intro

  controls = Qt6::GroupBox.new("Open dialogs")
  controls.grid do |grid|
    grid.add(message_button, 0, 0)
    grid.add(file_button, 0, 1)
    grid.add(color_button, 0, 2)
    grid.add(font_button, 0, 3)
    grid.add(text_button, 1, 0)
    grid.add(int_button, 1, 1)
    grid.add(choice_button, 1, 2)
    grid.add(progress_button, 1, 3)
    grid.add(settings_button, 2, 0)
  end
  layout << controls

  results = Qt6::GroupBox.new("Last values")
  results.form do |form|
    form.add_row("File", file_summary)
    form.add_row("Color", color_summary)
    form.add_row("Swatch", swatch)
    form.add_row("Font", font_summary)
    form.add_row("Input", input_summary)
    form.add_row("Progress", progress_summary)
  end
  layout << results
end

main.central_widget = central
main.show
if auto_dialog
  Qt6::QTimer.single_shot(600) do
    if action = auto_actions[auto_dialog]?
      action.call
    else
      status_bar.show_message("Unknown auto dialog: #{auto_dialog}", 3000)
    end
  end
end
app.run
