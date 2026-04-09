require "../src/qt6"

Qt6.application

image = Qt6::QImage.new(160, 120)
image.fill(Qt6::Color.new(245, 242, 236))

frame = Qt6::QPainterPath.new
frame.add_rect(Qt6::RectF.new(0.0, 0.0, 36.0, 24.0))

transform = Qt6::QTransform.new
transform.translate(16, 18)

Qt6::QPainter.paint(image) do |painter|
  painter.antialiasing = false
  painter.pen = Qt6::Color.new(32, 64, 128)
  painter.brush = Qt6::Color.new(96, 144, 224)
  painter.draw_path(frame.transformed(transform))
  painter.fill_rect(Qt6::RectF.new(72.0, 24.0, 48.0, 32.0), Qt6::Color.new(220, 96, 72))
  painter.draw_text(Qt6::PointF.new(18.0, 92.0), "crystal-qt6")
end

pixmap = image.to_pixmap
Qt6::QPainter.paint(pixmap) do |painter|
  painter.draw_line(Qt6::PointF.new(0.0, 0.0), Qt6::PointF.new(159.0, 119.0))
end

output = File.join(Dir.tempdir, "crystal-qt6-rendering-stack.png")
pixmap.save(output)
puts "Wrote #{output}"