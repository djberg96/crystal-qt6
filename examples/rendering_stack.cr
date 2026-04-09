require "../src/qt6"

Qt6.application

image = Qt6::QImage.new(160, 120)
image.fill(Qt6::Color.new(245, 242, 236))

pen = Qt6::QPen.new(Qt6::Color.new(32, 64, 128), 2.0)
brush = Qt6::QBrush.new(Qt6::Color.new(96, 144, 224))
font = Qt6::QFont.new(point_size: 12, bold: true)
metrics = font.metrics

frame = Qt6::QPainterPath.new
frame.add_rect(Qt6::RectF.new(0.0, 0.0, 36.0, 24.0))

transform = Qt6::QTransform.new
transform.translate(16, 18)

label = "crystal-qt6"
label_width = metrics.horizontal_advance(label)
label_x = ((image.width - label_width) / 2).to_f
label_y = (image.height - 12 - metrics.descent).to_f

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