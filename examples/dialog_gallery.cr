require "../src/qt6"

app = Qt6.application

main = Qt6::MainWindow.new
main.window_title = "Dialog Gallery"
main.resize(760, 520)

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

show_file = -> do
  if path = Qt6::FileDialog.get_open_file_name(main, "Open Example File", Dir.current, "Crystal files (*.cr);;All Files (*)")
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

open_message_action = Qt6::Action.new("Message Box", main)
open_file_action = Qt6::Action.new("Open File", main)
open_color_action = Qt6::Action.new("Color", main)
open_font_action = Qt6::Action.new("Font", main)
open_text_action = Qt6::Action.new("Text Input", main)
open_int_action = Qt6::Action.new("Integer Input", main)
open_choice_action = Qt6::Action.new("Choice Input", main)
open_progress_action = Qt6::Action.new("Progress", main)
quit_action = Qt6::Action.new("Quit", main)

open_message_action.on_triggered { show_message.call }
open_file_action.on_triggered { show_file.call }
open_color_action.on_triggered { show_color.call }
open_font_action.on_triggered { show_font.call }
open_text_action.on_triggered { show_input.call }
open_int_action.on_triggered { show_numeric_input.call }
open_choice_action.on_triggered { show_choice_input.call }
open_progress_action.on_triggered { show_progress.call }
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

toolbar = Qt6::ToolBar.new("Dialogs", main)
toolbar << open_message_action
toolbar << open_file_action
toolbar << open_color_action
toolbar << open_font_action
toolbar << open_text_action
toolbar << open_progress_action
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
app.run
