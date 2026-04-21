require "../src/qt6"

Qt6.application

OUTPUT_DIR = File.expand_path("../docs/book/images", __DIR__)
Dir.mkdir_p(OUTPUT_DIR)

def render_image(file_name : String, width : Int32 = 1200, height : Int32 = 720, &block : Qt6::QPainter, Qt6::RectF ->)
  image = Qt6::QImage.new(width, height)
  image.fill(Qt6::Color.new(252, 252, 250))
  rect = Qt6::RectF.new(0.0, 0.0, width.to_f64, height.to_f64)

  Qt6::QPainter.paint(image) do |painter|
    painter.antialiasing = true
    yield painter, rect
  end

  output = File.join(OUTPUT_DIR, file_name)
  abort "Could not write #{output}" unless image.save(output)
  puts output
end

def label(painter : Qt6::QPainter, x : Number, y : Number, text : String, size : Int32 = 24, bold : Bool = false)
  painter.font = Qt6::QFont.new(point_size: size, bold: bold)
  painter.pen = Qt6::Color.new(38, 46, 54)
  painter.draw_text(Qt6::PointF.new(x.to_f64, y.to_f64), text)
end

def no_pen : Qt6::QPen
  Qt6::QPen.new.tap { |pen| pen.style = Qt6::PenStyle::NoPen }
end

def draw_export_badge(painter : Qt6::QPainter, x : Float64, y : Float64, title : String, accent : Qt6::Color)
  painter.save
  painter.translate(x, y)

  gradient = Qt6::QLinearGradient.new(0.0, 0.0, 0.0, 190.0)
  gradient.set_color_at(0.0, Qt6::Color.new(255, 255, 255))
  gradient.set_color_at(1.0, Qt6::Color.new(230, 238, 244))

  painter.pen = Qt6::QPen.new(Qt6::Color.new(86, 98, 110), 3.0)
  painter.brush = Qt6::QBrush.new(gradient)
  painter.draw_rect(Qt6::RectF.new(0.0, 0.0, 250.0, 190.0))

  painter.pen = no_pen
  painter.brush = accent
  painter.draw_ellipse(Qt6::PointF.new(72.0, 72.0), 34.0, 34.0)
  painter.fill_rect(Qt6::RectF.new(120.0, 50.0, 76.0, 52.0), accent)

  path = Qt6::QPainterPath.new
  path.move_to(Qt6::PointF.new(52.0, 138.0))
  path.cubic_to(
    Qt6::PointF.new(92.0, 96.0),
    Qt6::PointF.new(154.0, 176.0),
    Qt6::PointF.new(202.0, 122.0)
  )
  route_pen = Qt6::QPen.new(Qt6::Color.new(42, 68, 94), 7.0)
  route_pen.cap_style = Qt6::PenCapStyle::RoundCap
  painter.pen = route_pen
  painter.brush = Qt6::QBrush.new(Qt6::Color.new(0, 0, 0, 0))
  painter.draw_path(path)

  painter.font = Qt6::QFont.new(point_size: 28, bold: true)
  painter.pen = Qt6::Color.new(32, 42, 52)
  painter.draw_text(Qt6::PointF.new(24.0, 232.0), title)

  painter.restore
end

render_image("painting-painter-state.png") do |painter, rect|
  background = Qt6::QLinearGradient.new(0.0, 0.0, 0.0, rect.height)
  background.set_color_at(0.0, Qt6::Color.new(249, 251, 252))
  background.set_color_at(1.0, Qt6::Color.new(232, 238, 242))
  painter.fill_rect(rect, Qt6::QBrush.new(background))

  label(painter, 56, 72, "Painter state: save, transform, clip, opacity, composition", 30, true)

  grid_pen = Qt6::QPen.new(Qt6::Color.new(213, 220, 226), 1.0)
  painter.pen = grid_pen
  (0..12).each do |index|
    x = 80.0 + index * 80.0
    painter.draw_line(Qt6::PointF.new(x, 120.0), Qt6::PointF.new(x, 650.0))
  end
  (0..6).each do |index|
    y = 140.0 + index * 72.0
    painter.draw_line(Qt6::PointF.new(70.0, y), Qt6::PointF.new(1130.0, y))
  end

  painter.pen = Qt6::QPen.new(Qt6::Color.new(62, 78, 92), 3.0)
  painter.brush = Qt6::Color.new(255, 255, 255)
  painter.draw_rect(Qt6::RectF.new(86.0, 146.0, 330.0, 220.0))
  label(painter, 112, 200, "base state", 24, true)

  painter.save
  painter.translate(620, 280)
  painter.rotate(-18)
  painter.opacity = 0.78
  painter.pen = Qt6::QPen.new(Qt6::Color.new(112, 58, 52), 4.0)
  painter.brush = Qt6::Color.new(224, 105, 82)
  painter.draw_rect(Qt6::RectF.new(-150.0, -70.0, 300.0, 140.0))
  painter.pen = Qt6::Color.new(255, 255, 255)
  painter.font = Qt6::QFont.new(point_size: 30, bold: true)
  painter.draw_text(Qt6::PointF.new(-106.0, 12.0), "rotated")
  painter.restore

  clip_path = Qt6::QPainterPath.new
  clip_path.add_ellipse(Qt6::RectF.new(790.0, 160.0, 270.0, 210.0))
  painter.save
  painter.clip_path = clip_path
  painter.fill_rect(Qt6::RectF.new(760.0, 130.0, 330.0, 270.0), Qt6::Color.new(96, 151, 196))
  painter.pen = Qt6::QPen.new(Qt6::Color.new(255, 255, 255, 170), 8.0)
  (0..8).each do |index|
    y = 150.0 + index * 34.0
    painter.draw_line(Qt6::PointF.new(760.0, y), Qt6::PointF.new(1090.0, y + 64.0))
  end
  painter.restore
  painter.pen = Qt6::QPen.new(Qt6::Color.new(38, 74, 105), 4.0)
  painter.brush = Qt6::QBrush.new(Qt6::Color.new(0, 0, 0, 0))
  painter.draw_path(clip_path)
  label(painter, 818, 438, "clip path restored", 24, true)

  painter.brush = Qt6::Color.new(92, 160, 114)
  painter.pen = no_pen
  painter.draw_ellipse(Qt6::PointF.new(222.0, 520.0), 86.0, 86.0)
  painter.composition_mode = Qt6::PainterCompositionMode::Multiply
  painter.brush = Qt6::Color.new(218, 102, 86)
  painter.draw_ellipse(Qt6::PointF.new(278.0, 520.0), 86.0, 86.0)
  painter.composition_mode = Qt6::PainterCompositionMode::SourceOver
  label(painter, 132, 638, "composition mode", 24, true)
end

render_image("painting-paths.png") do |painter, rect|
  painter.fill_rect(rect, Qt6::Color.new(248, 246, 240))
  label(painter, 56, 72, "Painter paths: curves, bounds, hit regions", 32, true)

  route = Qt6::QPainterPath.new
  route.move_to(Qt6::PointF.new(110.0, 410.0))
  route.cubic_to(
    Qt6::PointF.new(245.0, 120.0),
    Qt6::PointF.new(480.0, 620.0),
    Qt6::PointF.new(650.0, 300.0)
  )
  route.cubic_to(
    Qt6::PointF.new(760.0, 90.0),
    Qt6::PointF.new(980.0, 184.0),
    Qt6::PointF.new(1080.0, 420.0)
  )

  stroker = Qt6::QPainterPathStroker.new
  stroker.width = 54.0
  hit_region = stroker.create_stroke(route)

  painter.pen = no_pen
  painter.brush = Qt6::Color.new(112, 172, 210, 70)
  painter.draw_path(hit_region)

  route_pen = Qt6::QPen.new(Qt6::Color.new(36, 72, 112), 11.0)
  route_pen.cap_style = Qt6::PenCapStyle::RoundCap
  route_pen.join_style = Qt6::PenJoinStyle::RoundJoin
  painter.pen = route_pen
  painter.brush = Qt6::QBrush.new(Qt6::Color.new(0, 0, 0, 0))
  painter.draw_path(route)

  bounds = route.bounding_rect
  bounds_pen = Qt6::QPen.new(Qt6::Color.new(212, 92, 72), 4.0)
  bounds_pen.dash_pattern = [8.0, 5.0]
  painter.pen = bounds_pen
  painter.draw_rect(bounds)

  control_pen = Qt6::QPen.new(Qt6::Color.new(130, 128, 126), 2.0)
  control_pen.dash_pattern = [4.0, 6.0]
  painter.pen = control_pen
  painter.draw_line(Qt6::PointF.new(110.0, 410.0), Qt6::PointF.new(245.0, 120.0))
  painter.draw_line(Qt6::PointF.new(480.0, 620.0), Qt6::PointF.new(650.0, 300.0))
  painter.draw_line(Qt6::PointF.new(650.0, 300.0), Qt6::PointF.new(760.0, 90.0))
  painter.draw_line(Qt6::PointF.new(980.0, 184.0), Qt6::PointF.new(1080.0, 420.0))

  painter.pen = no_pen
  [
    {110.0, 410.0, Qt6::Color.new(36, 72, 112)},
    {245.0, 120.0, Qt6::Color.new(212, 92, 72)},
    {480.0, 620.0, Qt6::Color.new(212, 92, 72)},
    {650.0, 300.0, Qt6::Color.new(36, 72, 112)},
    {760.0, 90.0, Qt6::Color.new(212, 92, 72)},
    {980.0, 184.0, Qt6::Color.new(212, 92, 72)},
    {1080.0, 420.0, Qt6::Color.new(36, 72, 112)},
  ].each do |x, y, color|
    painter.brush = color
    painter.draw_ellipse(Qt6::PointF.new(x, y), 10.0, 10.0)
  end

  label(painter, 132, 548, "stroked hit area", 25, true)
  label(painter, bounds.x + 18.0, bounds.y - 18.0, "bounding_rect", 24, true)
  label(painter, 756, 620, "control points", 25, true)
end

render_image("painting-export-targets.png") do |painter, rect|
  painter.fill_rect(rect, Qt6::Color.new(244, 248, 250))
  label(painter, 56, 72, "One drawing function, several painter targets", 32, true)

  painter.pen = Qt6::QPen.new(Qt6::Color.new(138, 150, 160), 4.0)
  painter.draw_line(Qt6::PointF.new(250.0, 438.0), Qt6::PointF.new(950.0, 438.0))
  [405.0, 605.0, 805.0].each do |x|
    painter.draw_line(Qt6::PointF.new(x, 438.0), Qt6::PointF.new(x - 34.0, 420.0))
    painter.draw_line(Qt6::PointF.new(x, 438.0), Qt6::PointF.new(x - 34.0, 456.0))
  end

  draw_export_badge(painter, 110.0, 142.0, "QImage PNG", Qt6::Color.new(74, 137, 188))
  draw_export_badge(painter, 474.0, 142.0, "SVG", Qt6::Color.new(92, 156, 116))
  draw_export_badge(painter, 812.0, 142.0, "PDF", Qt6::Color.new(204, 94, 76))

  label(painter, 384, 596, "same draw_badge(painter) code", 26, true)
end
