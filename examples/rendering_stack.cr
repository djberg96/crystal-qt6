require "../src/qt6"

Qt6.application

image = Qt6::QImage.new(160, 120)
image.fill(Qt6::Color.new(245, 242, 236))

pen = Qt6::QPen.new(Qt6::Color.new(32, 64, 128), 2.0)
brush = Qt6::QBrush.new(Qt6::Color.new(96, 144, 224))
font = Qt6::QFont.new(point_size: 12, bold: true)
metrics = font.metrics_f

frame = Qt6::QPainterPath.new
frame.add_rect(Qt6::RectF.new(0.0, 0.0, 36.0, 24.0))

transform = Qt6::QTransform.new
transform.translate(16, 18)

label = "crystal-qt6"
label_width = metrics.horizontal_advance(label)
label_x = ((image.width - label_width) / 2).to_f
label_y = image.height.to_f - 12.0 - metrics.descent

Qt6::QPainter.paint(image) do |painter|
  painter.antialiasing = false
  painter.pen = pen
  painter.brush = brush
  painter.font = font
  painter.draw_path(frame.transformed(transform))
  painter.fill_rect(Qt6::RectF.new(72.0, 24.0, 48.0, 32.0), Qt6::Color.new(220, 96, 72))
  painter.draw_text(Qt6::PointF.new(label_x, label_y), label)
end

pixmap = image.to_pixmap
Qt6::QPainter.paint(pixmap) do |painter|
  painter.draw_line(Qt6::PointF.new(0.0, 0.0), Qt6::PointF.new(159.0, 119.0))
end

output = File.join(Dir.tempdir, "crystal-qt6-rendering-stack.png")
pixmap.save(output)
puts "Wrote #{output}"

svg_output = File.join(Dir.tempdir, "crystal-qt6-rendering-stack.svg")
svg = Qt6::QSvgGenerator.new(svg_output, 160, 120, title: "crystal-qt6 rendering stack", description: "Vector export demo")
svg.resolution = 96

Qt6::QPainter.paint(svg) do |painter|
  painter.antialiasing = false
  painter.pen = pen
  painter.brush = brush
  painter.font = font
  painter.draw_path(frame.transformed(transform))
  painter.fill_rect(Qt6::RectF.new(72.0, 24.0, 48.0, 32.0), Qt6::Color.new(220, 96, 72))
  painter.draw_text(Qt6::PointF.new(label_x, label_y), label)
end

svg.release
puts "Wrote #{svg_output}"

svg_renderer = Qt6::QSvgRenderer.from_data(File.read(svg_output))
svg_preview = Qt6::QImage.new(160, 120)
svg_preview.fill(Qt6::Color.new(255, 255, 255))

Qt6::QPainter.paint(svg_preview) do |painter|
  svg_renderer.render(painter, Qt6::RectF.new(0.0, 0.0, 160.0, 120.0))
end

svg_preview_output = File.join(Dir.tempdir, "crystal-qt6-rendering-stack-from-svg.png")
svg_preview.save(svg_preview_output)
puts "Wrote #{svg_preview_output}"

element_svg = %(<svg xmlns="http://www.w3.org/2000/svg" width="160" height="120" viewBox="0 0 160 120">
  <rect id="background" x="8" y="8" width="144" height="104" rx="12" fill="#f6efe2" stroke="#425466" stroke-width="4"/>
  <rect id="accent" x="52" y="28" width="56" height="48" rx="8" fill="#d66853"/>
  <text id="label" x="28" y="98" font-family="Helvetica" font-size="16" font-weight="700" fill="#16324f">element render</text>
</svg>)

element_renderer = Qt6::QSvgRenderer.from_data(element_svg)
element_preview = Qt6::QImage.new(160, 120)
element_preview.fill(Qt6::Color.new(255, 255, 255))

Qt6::QPainter.paint(element_preview) do |painter|
  element_renderer.render(painter, "accent", Qt6::RectF.new(20.0, 18.0, 120.0, 84.0))
end

element_preview_output = File.join(Dir.tempdir, "crystal-qt6-rendering-stack-element.png")
element_preview.save(element_preview_output)
puts "Wrote #{element_preview_output}"

pdf_output = File.join(Dir.tempdir, "crystal-qt6-rendering-stack.pdf")
pdf = Qt6::QPdfWriter.new(pdf_output, title: "crystal-qt6 rendering stack", creator: "crystal-qt6 example")
pdf.page_size_points = Qt6::Size.new(160, 120)
pdf.resolution = 144

Qt6::QPainter.paint(pdf) do |painter|
  painter.antialiasing = false
  painter.pen = pen
  painter.brush = brush
  painter.font = font
  painter.draw_path(frame.transformed(transform))
  painter.fill_rect(Qt6::RectF.new(72.0, 24.0, 48.0, 32.0), Qt6::Color.new(220, 96, 72))
  painter.draw_text(Qt6::PointF.new(label_x, label_y), label)
end

pdf.release
puts "Wrote #{pdf_output}"