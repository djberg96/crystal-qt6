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
  QLineEdit, QComboBox, QSpinBox, QPlainTextEdit {
    background: white;
    border: 1px solid rgb(188, 198, 207);
    border-radius: 4px;
    padding: 4px 6px;
  }
  QPushButton {
    padding: 6px 12px;
  }
CSS

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
