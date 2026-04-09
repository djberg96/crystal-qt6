require "../src/qt6"

SVG_VARIANTS = [
  %(<svg xmlns="http://www.w3.org/2000/svg" width="360" height="220" viewBox="0 0 360 220">
      <rect id="frame" x="18" y="18" width="324" height="184" rx="18" fill="#f7f3ea" stroke="#274c77" stroke-width="8"/>
      <path id="river" d="M 36 144 C 84 110, 144 176, 188 128 S 286 64, 324 108" fill="none" stroke="#4d9de0" stroke-width="18" stroke-linecap="round"/>
      <circle id="marker" cx="112" cy="92" r="26" fill="#d1495b" stroke="#7f1d1d" stroke-width="6"/>
      <text id="label" x="148" y="98" font-family="Helvetica" font-size="30" font-weight="700" fill="#16324f">Variant A</text>
    </svg>),
  %(<svg xmlns="http://www.w3.org/2000/svg" width="360" height="220" viewBox="0 0 360 220">
      <rect id="frame" x="18" y="18" width="324" height="184" rx="18" fill="#fff7df" stroke="#386641" stroke-width="8"/>
      <path id="river" d="M 34 120 C 86 72, 146 170, 206 118 S 292 98, 326 62" fill="none" stroke="#bc4749" stroke-width="18" stroke-linecap="round"/>
      <circle id="marker" cx="254" cy="142" r="26" fill="#6a4c93" stroke="#3c096c" stroke-width="6"/>
      <text id="label" x="108" y="170" font-family="Helvetica" font-size="30" font-weight="700" fill="#2d6a4f">Variant B</text>
    </svg>),
] of String

def describe_rect(rect : Qt6::RectF) : String
  "#{rect.x.round(1)},#{rect.y.round(1)} #{rect.width.round(1)}x#{rect.height.round(1)}"
end

app = Qt6.application
palette_index = 0

main = Qt6::MainWindow.new
main.window_title = "SVG Widget + Renderer"
main.resize(980, 560)

status_bar = main.status_bar
svg_widget = Qt6::QSvgWidget.from_data(SVG_VARIANTS[palette_index])
svg_widget.resize(420, 320)

element_picker = Qt6::ComboBox.new
{"document", "frame", "river", "marker", "label"}.each do |element_id|
  element_picker << element_id
end

summary_label = Qt6::Label.new
size_label = Qt6::Label.new
bounds_label = Qt6::Label.new
hint_label = Qt6::Label.new("Swap palettes to exercise in-memory load_data. Export Grab writes the live SVG widget image to /tmp.")
preview = Qt6::EventWidget.new
preview.resize(320, 220)

refresh_metadata = -> do
  renderer = svg_widget.renderer
  selected = element_picker.current_text
  default_size = renderer.default_size
  size_hint = svg_widget.size_hint
  summary_label.text = "Renderer valid: #{renderer.valid?} | selected: #{selected}"
  size_label.text = "default #{default_size.width}x#{default_size.height} | hint #{size_hint.width}x#{size_hint.height} | viewBox #{describe_rect(renderer.view_box)}"

  bounds = selected == "document" ? renderer.view_box : renderer.bounds_on_element(selected)
  bounds_label.text = "bounds: #{describe_rect(bounds)}"
end

preview.on_paint_with_painter do |event, painter|
  painter.fill_rect(event.rect, Qt6::Color.new(244, 241, 234))

  content_rect = Qt6::RectF.new(12.0, 12.0, event.rect.width - 24.0, event.rect.height - 36.0)
  painter.pen = Qt6::Color.new(180, 180, 180)
  painter.draw_rect(content_rect)

  renderer = svg_widget.renderer
  selected = element_picker.current_text
  if selected == "document"
    renderer.render(painter, content_rect)
  elsif renderer.element_exists?(selected)
    renderer.render(painter, selected, content_rect)
  end

  painter.pen = Qt6::Color.new(56, 56, 56)
  painter.draw_text(Qt6::PointF.new(14.0, event.rect.height - 10.0), "Preview: #{selected}")
end

swap_palette_button = Qt6::PushButton.new("Swap Palette")
swap_palette_button.on_clicked do
  palette_index = (palette_index + 1) % SVG_VARIANTS.size
  svg_widget.load_data(SVG_VARIANTS[palette_index])
  refresh_metadata.call
  preview.update
  status_bar.show_message("Loaded in-memory SVG variant #{palette_index + 1}", 2000)
end

export_grab_button = Qt6::PushButton.new("Export Grab")
export_grab_button.on_clicked do
  output = File.join(Dir.tempdir, "crystal-qt6-svg-widget-grab-#{Process.pid}.png")
  saved = svg_widget.grab.to_image.save(output)
  status_bar.show_message(saved ? "Saved #{output}" : "Failed to save #{output}", 3000)
end

element_picker.on_current_index_changed do |_index|
  refresh_metadata.call
  preview.update
  status_bar.show_message("Previewing #{element_picker.current_text}", 1500)
end

main.central_widget = Qt6::Widget.new.tap do |root|
  root.hbox do |row|
    row << Qt6::Widget.new.tap do |left_panel|
      left_panel.vbox do |column|
        column << Qt6::Label.new("QSvgWidget loaded from an in-memory document")
        column << svg_widget
        column << Qt6::Label.new("Use Export Grab to capture the widget with the normal QWidget screenshot path.")
      end
    end

    row << Qt6::Widget.new.tap do |right_panel|
      right_panel.vbox do |column|
        column << Qt6::Label.new("Borrowed renderer inspector")
        column << element_picker
        column << summary_label
        column << size_label
        column << bounds_label
        column << hint_label
        column << preview
        column << Qt6::Widget.new.tap do |buttons|
          buttons.hbox do |button_row|
            button_row << swap_palette_button
            button_row << export_grab_button
          end
        end
      end
    end
  end
end

refresh_metadata.call
status_bar.show_message("Ready")
main.show
app.run