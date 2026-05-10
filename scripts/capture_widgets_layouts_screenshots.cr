require "../src/qt6"

OUTPUT_DIR = File.expand_path("../docs/book/images", __DIR__)
Dir.mkdir_p(OUTPUT_DIR)

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

app = Qt6.application(["capture-widgets-layouts-screenshots"])
app.name = "Widgets And Layouts Screenshots"
app.organization_name = "crystal-qt6"
app.style_sheet = <<-CSS
  QWidget {
    font-size: 15px;
  }
  QGroupBox {
    font-weight: bold;
    margin-top: 12px;
  }
  QGroupBox::title {
    subcontrol-origin: margin;
    left: 10px;
    padding: 0 4px;
  }
  QLineEdit, QComboBox, QSpinBox, QDoubleSpinBox, QPlainTextEdit, QToolBox {
    background: white;
    border: 1px solid rgb(188, 198, 207);
    border-radius: 4px;
    padding: 4px 6px;
  }
  QCalendarWidget QWidget {
    alternate-background-color: rgb(245, 248, 250);
  }
  QPushButton {
    padding: 6px 12px;
  }
CSS

profile_name = Qt6::LineEdit.new("Terrain")
profile_name.tool_tip = "Layer name shown in the list"

theme = Qt6::ComboBox.new
theme << "Classic" << "Slate" << "Field"
theme.editable = true
theme.current_text = "Slate"

visible_state = Qt6::CheckBox.new("Visible")
visible_state.tristate = true
visible_state.check_state = Qt6::CheckState::PartiallyChecked

opacity_value = Qt6::SpinBox.new
opacity_value.set_range(0, 100)
opacity_value.value = 72

scale_value = Qt6::DoubleSpinBox.new
scale_value.set_range(0.25, 4.0)
scale_value.value = 1.25

zoom_slider = Qt6::Slider.new(Qt6::Orientation::Horizontal)
zoom_slider.set_range(25, 400)
zoom_slider.value = 125
zoom_slider.click_to_position = true

terrain_mode = Qt6::RadioButton.new("Terrain")
units_mode = Qt6::RadioButton.new("Units")
roads_mode = Qt6::RadioButton.new("Roads")
roads_mode.checked = true

calendar = Qt6::CalendarWidget.new
calendar.set_date_range(Qt6::QDate.new(2026, 1, 1), Qt6::QDate.new(2026, 12, 31))
calendar.selected_date = Qt6::QDate.new(2026, 5, 5)
calendar.navigation_bar_visible = true
calendar.grid_visible = true
calendar.set_fixed_size(320, 220)

controls = Qt6::Widget.new
controls.window_title = "Core Controls"
controls.resize(520, 690)
controls.vbox do |column|
  column << Qt6::Label.new("Core Controls")

  identity = Qt6::GroupBox.new("Identity")
  identity.form do |form|
    form.add_row("Name", profile_name)
    form.add_row("Theme", theme)
    form.add_row("Opacity", opacity_value)
    form.add_row("Scale", scale_value)
    form.add_row(visible_state)
  end
  column << identity

  interaction = Qt6::GroupBox.new("Interaction")
  interaction.vbox do |inner|
    inner << Qt6::Label.new("Zoom")
    inner << zoom_slider

    mode_row = Qt6::Widget.new
    mode_row.hbox do |row|
      row << terrain_mode
      row << units_mode
      row << roads_mode
    end
    inner << mode_row
  end
  column << interaction

  schedule = Qt6::GroupBox.new("Schedule")
  schedule.vbox do |inner|
    inner << calendar
  end
  column << schedule
end

save_widget(app, controls, "widgets-core-controls-panel.png")

name = Qt6::LineEdit.new("Terrain")
kind = Qt6::ComboBox.new
kind << "Hexes" << "Terrain" << "Units"
kind.current_index = 1

visible = Qt6::CheckBox.new("Visible")
visible.checked = true

opacity = Qt6::SpinBox.new
opacity.set_range(0, 100)
opacity.value = 72

density = Qt6::Slider.new(Qt6::Orientation::Horizontal)
density.set_range(1, 10)
density.value = 6

notes = Qt6::PlainTextEdit.new
notes.plain_text = "Use grouped controls for related state. Keep command rows separate from the form."
notes.set_fixed_size(360, 92)

identity = Qt6::GroupBox.new("Layer")
identity.form do |form|
  form.add_row("Name", name)
  form.add_row("Kind", kind)
  form.add_row(visible)
end

appearance = Qt6::GroupBox.new("Appearance")
appearance.form do |form|
  form.add_row("Opacity", opacity)
  form.add_row("Density", density)
  form.add_row("Notes", notes)
end

reset = Qt6::PushButton.new("Reset")
apply = Qt6::PushButton.new("Apply")

panel = Qt6::Widget.new
panel.window_title = "Layer Inspector"
panel.resize(460, 410)
panel.vbox do |column|
  column << Qt6::Label.new("Layer Inspector")
  column << identity
  column << appearance

  actions = Qt6::Widget.new
  actions.hbox do |row|
    row << reset
    row << apply
  end
  column << actions
end

save_widget(app, panel, "widgets-layer-inspector-panel.png")

toolbox = Qt6::ToolBox.new
toolbox.add_item(Qt6::Label.new("Layer list"), "Layers")

brush_page = Qt6::Widget.new
brush_page.form do |form|
  size = Qt6::SpinBox.new
  size.set_range(1, 64)
  size.value = 18

  density = Qt6::Slider.new(Qt6::Orientation::Horizontal)
  density.set_range(1, 10)
  density.value = 6

  form.add_row("Size", size)
  form.add_row("Density", density)
end
toolbox.add_item(brush_page, "Brushes")
toolbox.current_index = 1

general_page = Qt6::Widget.new
general_page.vbox do |column|
  long_form = Qt6::Widget.new
  long_form.form do |form|
    profile = Qt6::LineEdit.new("Commander")
    accent = Qt6::ComboBox.new
    accent << "Blue" << "Green" << "Red"
    accent.current_index = 1
    restore = Qt6::CheckBox.new("Restore last project")
    restore.checked = true
    notes = Qt6::PlainTextEdit.new
    notes.plain_text = "Scrollable pages let the panel grow without shrinking controls too aggressively."
    notes.set_fixed_size(300, 120)

    form.add_row("Profile", profile)
    form.add_row("Accent", accent)
    form.add_row(restore)
    form.add_row("Notes", notes)
  end

  scroll = Qt6::ScrollArea.new
  scroll.widget = long_form
  scroll.widget_resizable = true
  scroll.alignment = Qt6::AlignmentFlag::Top
  scroll.set_fixed_size(340, 210)
  column << scroll

  page_mode = Qt6::ComboBox.new
  page_mode << "Simple" << "Advanced"
  page_mode.current_index = 1

  pages = Qt6::StackedWidget.new
  simple_page = Qt6::Label.new("Simple page")
  advanced_page = Qt6::Label.new("Advanced page")
  pages << simple_page
  pages << advanced_page
  pages.current_widget = advanced_page

  column << page_mode
  column << pages
end

editor_page = Qt6::Widget.new
editor_page.form do |form|
  tab_width = Qt6::SpinBox.new
  tab_width.set_range(2, 8)
  tab_width.value = 4

  wrap = Qt6::CheckBox.new("Wrap lines")
  wrap.checked = true

  form.add_row("Tab width", tab_width)
  form.add_row(wrap)
end

tabs = Qt6::TabWidget.new
tabs.add_tab(general_page, "General")
tabs.add_tab(editor_page, "Editing")
tabs.current_widget = general_page

splitter = Qt6::Splitter.new(Qt6::Orientation::Horizontal)
splitter.children_collapsible = false
splitter.handle_width = 10
splitter << toolbox
splitter << tabs
splitter.set_sizes([180, 470])

containers = Qt6::Widget.new
containers.window_title = "Containers"
containers.resize(720, 420)
containers.vbox do |column|
  column << Qt6::Label.new("Containers")
  column << splitter
end

save_widget(app, containers, "widgets-container-workbench.png")
