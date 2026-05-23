require "../src/qt6"

OUTPUT_DIR = File.expand_path("../docs/book/images", __DIR__)
Dir.mkdir_p(OUTPUT_DIR)

def process_paints(app : Qt6::Application)
  10.times { app.process_events }
end

def save_widget(app : Qt6::Application, widget : Qt6::Widget, file_name : String)
  widget.show
  widget.update
  process_paints(app)

  output = File.join(OUTPUT_DIR, file_name)
  abort "Could not write #{output}" unless widget.grab.save(output)
  puts output

  widget.close
  process_paints(app)
end

def build_style_painter_preview(app : Qt6::Application) : Qt6::QPixmap
  button = Qt6::PushButton.new("Deploy")
  combo_box = Qt6::ComboBox.new
  progress_bar = Qt6::ProgressBar.new
  canvas = Qt6::QPixmap.new(520, 180)
  badge = Qt6::QPixmap.new(14, 14)
  palette = Qt6::QPalette.new
  button_option = Qt6::StyleOptionButton.new
  focus_option = Qt6::StyleOptionFocusRect.new
  combo_option = Qt6::StyleOptionComboBox.new
  progress_option = Qt6::StyleOptionProgressBar.new
  painter = Qt6::StylePainter.new

  button.resize(140, 36)
  button.show
  combo_box.add_item("Terrain")
  combo_box.add_item("Roads")
  combo_box.add_item("Labels")
  combo_box.current_index = 1
  combo_box.resize(180, 30)
  combo_box.show
  progress_bar.resize(260, 28)
  progress_bar.minimum = 0
  progress_bar.maximum = 100
  progress_bar.value = 68
  progress_bar.format = "Preview 68%"
  progress_bar.text_visible = true
  progress_bar.show
  process_paints(app)

  canvas.fill(Qt6::Color.new(250, 250, 248))
  badge.fill(Qt6::Color.new(220, 40, 40))
  palette.set_color(Qt6::ColorRole::Text, Qt6::Color.new(48, 58, 68))

  if painter.begin(canvas, button)
    button_option.init_from(button)
    button_option.rect = Qt6::Rect.new(16, 16, 140, 36)
    painter.draw_control(Qt6::StyleControlElement::PushButton, button_option)

    focus_option.init_from(button)
    focus_option.rect = Qt6::Rect.new(166, 16, 28, 28)
    painter.draw_primitive(Qt6::StylePrimitiveElement::FrameFocusRect, focus_option)

    combo_option.init_from(combo_box)
    combo_option.rect = Qt6::Rect.new(16, 66, 180, 30)
    painter.draw_complex_control(Qt6::StyleComplexControl::ComboBox, combo_option)

    progress_option.init_from(progress_bar)
    progress_option.rect = Qt6::Rect.new(16, 116, 260, 28)
    painter.draw_control(Qt6::StyleControlElement::ProgressBar, progress_option)

    painter.draw_item_text(
      Qt6::Rect.new(214, 70, 190, 24),
      Qt6::AlignmentFlag::Left | Qt6::AlignmentFlag::VCenter,
      palette,
      true,
      "Rendered through StylePainter"
    )

    painter.draw_item_pixmap(
      Qt6::Rect.new(420, 68, 18, 18),
      Qt6::AlignmentFlag::Center,
      badge
    )

    painter.end
  end

  output = File.join(OUTPUT_DIR, "styles-style-painter.png")
  abort "Could not write #{output}" unless canvas.save(output)
  puts output

  painter.release
  progress_option.release
  combo_option.release
  focus_option.release
  button_option.release
  palette.release
  badge.release
  progress_bar.release
  combo_box.release
  button.release

  canvas
end

app = Qt6.application(["capture-style-screenshots"])
app.name = "Style Screenshots"
app.organization_name = "crystal-qt6"
app.style_sheet = "QWidget { font-size: 14px; }"
app.set_style("Fusion") if Qt6::StyleFactory.keys.includes?("Fusion")

style_preview = build_style_painter_preview(app)

main = Qt6::MainWindow.new
main.window_title = "Style Workbench"
main.resize(1060, 740)
main.status_bar.show_message("Style-aware controls, painter preview, and delegate-backed editing")

toolbar = Qt6::ToolBar.new("Commands", main)
toolbar.tool_button_style = Qt6::ToolButtonStyle::TextBesideIcon

open_action = Qt6::Action.new("Open", main)
refresh_action = Qt6::Action.new("Refresh", main)
apply_action = Qt6::Action.new("Apply", main)
apply_action.enabled = false

toolbar << open_action
toolbar << refresh_action
toolbar.add_separator
toolbar << apply_action
main.add_tool_bar(toolbar)

central = Qt6::Widget.new
main.central_widget = central

splitter = Qt6::Splitter.new(Qt6::Orientation::Horizontal)
splitter.children_collapsible = false

left_panel = Qt6::Widget.new
right_panel = Qt6::Widget.new
splitter << left_panel
splitter << right_panel
splitter.set_sizes([470, 540])

central.vbox do |column|
  intro = Qt6::Label.new(
    "Styles choose how standard controls look and size themselves. " \
    "This workbench uses Fusion when it is available, shows a StylePainter preview, " \
    "and keeps the table editor inside StyledItemDelegate."
  )
  intro.word_wrap = true
  column << intro
  column << splitter
end

tabs = Qt6::TabWidget.new

controls_page = Qt6::Widget.new
controls_page.vbox do |column|
  profile_group = Qt6::GroupBox.new("Application Style")
  profile_group.form do |form|
    style_name = app.style.try(&.name) || "unknown"
    style_keys = Qt6::StyleFactory.keys.join(", ")
    form.add_row("Active style", Qt6::Label.new(style_name))
    form.add_row("Available styles", Qt6::Label.new(style_keys))
  end

  controls_group = Qt6::GroupBox.new("Control Surface")
  controls_group.vbox do |inner|
    name_row = Qt6::Widget.new
    name_row.hbox do |row|
      row << Qt6::Label.new("Layer name")
      row << Qt6::LineEdit.new("Terrain overlay")
    end

    mode_row = Qt6::Widget.new
    mode_row.hbox do |row|
      mode = Qt6::ComboBox.new
      mode << "Visible" << "Draft" << "Locked"
      mode.current_index = 1
      row << Qt6::Label.new("State")
      row << mode
      row << Qt6::CheckBox.new("Snap").tap { |box| box.checked = true }
    end

    tuning_row = Qt6::Widget.new
    tuning_row.hbox do |row|
      slider = Qt6::Slider.new(Qt6::Orientation::Horizontal)
      slider.minimum = 0
      slider.maximum = 100
      slider.value = 68
      slider.tick_position = Qt6::SliderTickPosition::TicksBelow
      slider.tick_interval = 10
      slider.minimum_width = 180

      spin = Qt6::SpinBox.new
      spin.minimum = 0
      spin.maximum = 100
      spin.value = 68

      row << Qt6::Label.new("Opacity")
      row << slider
      row << spin
    end

    progress = Qt6::ProgressBar.new
    progress.minimum = 0
    progress.maximum = 100
    progress.value = 68
    progress.format = "Preview 68%"

    inner << name_row
    inner << mode_row
    inner << tuning_row
    inner << progress
  end

  column << profile_group
  column << controls_group
end

delegate_page = Qt6::Widget.new
delegate_page.vbox do |column|
  column << Qt6::Label.new(
    "StyledItemDelegate formats the view text and supplies the in-place editor. " \
    "The first row stays open so the editing path is visible in the screenshot."
  ).tap(&.word_wrap = true)

  delegate_model = Qt6::StandardItemModel.new(delegate_page)
  delegate_model.set_horizontal_header_label(0, "Layer")
  delegate_model.set_horizontal_header_label(1, "State")
  [
    {"Terrain", "Visible"},
    {"Roads", "Visible"},
    {"Labels", "Draft"},
  ].each_with_index do |entry, row|
    name, state = entry
    delegate_model.set_item(row, 0, Qt6::StandardItem.new(name))
    delegate_model.set_item(row, 1, Qt6::StandardItem.new(state))
  end

  delegate_table = Qt6::TableView.new
  delegate_table.model = delegate_model
  delegate_table.alternating_row_colors = true
  delegate_table.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
  delegate_table.selection_mode = Qt6::ItemSelectionMode::SingleSelection
  delegate_table.edit_triggers = Qt6::EditTrigger::DoubleClicked | Qt6::EditTrigger::EditKeyPressed
  delegate_table.horizontal_header.resize_section(0, 220)
  delegate_table.horizontal_header.stretch_last_section = true

  delegate = Qt6::StyledItemDelegate.new(delegate_table)
  delegate.on_display_text do |text|
    "#{text}  [delegate]"
  end
  delegate.on_create_editor do |parent, _index|
    Qt6::LineEdit.new(parent: parent)
  end
  delegate.on_set_editor_data do |editor, value, _index|
    editor.as(Qt6::LineEdit).text = value.to_s
  end
  delegate.on_set_model_data do |editor, target_model, index|
    target_model.set_data(index, editor.as(Qt6::LineEdit).text)
  end
  delegate_table.item_delegate = delegate

  edit_index = delegate_model.index(0, 0)
  delegate_table.current_index = edit_index
  delegate_table.open_persistent_editor(edit_index)

  column << delegate_table
end

tabs.add_tab(controls_page, "Controls")
tabs.add_tab(delegate_page, "Delegates")
tabs.current_index = 1

left_panel.vbox do |column|
  column << tabs
end

right_panel.vbox do |column|
  painter_group = Qt6::GroupBox.new("StylePainter Preview")
  painter_group.vbox do |inner|
    inner << Qt6::Label.new(
      "This image was drawn offscreen with StylePainter and control-specific " \
      "StyleOption wrappers, not grabbed from a live widget tree."
    ).tap(&.word_wrap = true)

    preview = Qt6::Label.new("")
    preview.pixmap = style_preview
    inner << preview
  end

  option_group = Qt6::GroupBox.new("Where The Style Surface Shows Up")
  option_group.vbox do |inner|
    inner << Qt6::Label.new("StyleFactory / Application#style=: choose the active look")
    inner << Qt6::Label.new("StylePainter + StyleOption*: render controls offscreen")
    inner << Qt6::Label.new("StyledItemDelegate: keep item views style-aware while customizing editing")
  end

  column << painter_group
  column << option_group
end

save_widget(app, main, "styles-workbench.png")
style_preview.release
