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

def draw_box(painter : Qt6::QPainter, rect : Qt6::RectF, title : String, body : String, accent : Qt6::Color)
  gradient = Qt6::QLinearGradient.new(rect.x, rect.y, rect.x, rect.y + rect.height)
  gradient.set_color_at(0.0, Qt6::Color.new(255, 255, 255))
  gradient.set_color_at(1.0, Qt6::Color.new(236, 242, 246))

  painter.pen = Qt6::QPen.new(Qt6::Color.new(82, 96, 110), 3.0)
  painter.brush = Qt6::QBrush.new(gradient)
  painter.draw_rect(rect)

  painter.pen = no_pen
  painter.brush = accent
  painter.fill_rect(Qt6::RectF.new(rect.x, rect.y, rect.width, 12.0), accent)

  painter.font = Qt6::QFont.new(point_size: 25, bold: true)
  painter.pen = Qt6::Color.new(34, 44, 54)
  painter.draw_text(Qt6::PointF.new(rect.x + 22.0, rect.y + 58.0), title)

  painter.font = Qt6::QFont.new(point_size: 20)
  painter.pen = Qt6::Color.new(62, 74, 86)
  body.split('\n').each_with_index do |line, index|
    painter.draw_text(Qt6::PointF.new(rect.x + 22.0, rect.y + 100.0 + index * 28.0), line)
  end
end

def draw_node(painter : Qt6::QPainter, rect : Qt6::RectF, title : String, body : String, accent : Qt6::Color, title_size : Int32 = 24, body_size : Int32 = 18)
  gradient = Qt6::QLinearGradient.new(rect.x, rect.y, rect.x, rect.y + rect.height)
  gradient.set_color_at(0.0, Qt6::Color.new(255, 255, 255))
  gradient.set_color_at(1.0, Qt6::Color.new(238, 243, 246))

  painter.pen = Qt6::QPen.new(Qt6::Color.new(82, 96, 110), 3.0)
  painter.brush = Qt6::QBrush.new(gradient)
  painter.draw_rect(rect)

  painter.pen = no_pen
  painter.fill_rect(Qt6::RectF.new(rect.x, rect.y, rect.width, 12.0), accent)

  painter.font = Qt6::QFont.new(point_size: title_size, bold: true)
  painter.pen = Qt6::Color.new(34, 44, 54)
  painter.draw_text(Qt6::PointF.new(rect.x + 20.0, rect.y + 48.0), title)

  painter.font = Qt6::QFont.new(point_size: body_size)
  painter.pen = Qt6::Color.new(62, 74, 86)
  body.split('\n').each_with_index do |line, index|
    painter.draw_text(Qt6::PointF.new(rect.x + 20.0, rect.y + 84.0 + index * (body_size + 8).to_f64), line)
  end
end

def arrow(painter : Qt6::QPainter, from_point : Qt6::PointF, to_point : Qt6::PointF, color : Qt6::Color = Qt6::Color.new(120, 132, 144))
  pen = Qt6::QPen.new(color, 5.0)
  pen.cap_style = Qt6::PenCapStyle::RoundCap
  painter.pen = pen
  painter.draw_line(from_point, to_point)

  dx = to_point.x - from_point.x
  dy = to_point.y - from_point.y
  length = Math.sqrt(dx * dx + dy * dy)
  return if length <= 0.0

  ux = dx / length
  uy = dy / length
  size = 24.0
  wing = 15.0

  left = Qt6::PointF.new(to_point.x - ux * size - uy * wing, to_point.y - uy * size + ux * wing)
  right = Qt6::PointF.new(to_point.x - ux * size + uy * wing, to_point.y - uy * size - ux * wing)
  painter.draw_line(to_point, left)
  painter.draw_line(to_point, right)
end

def routed_arrow(painter : Qt6::QPainter, points : Array(Qt6::PointF), color : Qt6::Color = Qt6::Color.new(120, 132, 144))
  return if points.size < 2

  pen = Qt6::QPen.new(color, 5.0)
  pen.cap_style = Qt6::PenCapStyle::RoundCap
  painter.pen = pen

  (points.size - 2).times do |index|
    painter.draw_line(points[index], points[index + 1])
  end

  arrow(painter, points[-2], points[-1], color)
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

render_image("images-pipeline.png") do |painter, rect|
  background = Qt6::QLinearGradient.new(0.0, 0.0, 0.0, rect.height)
  background.set_color_at(0.0, Qt6::Color.new(250, 252, 253))
  background.set_color_at(1.0, Qt6::Color.new(235, 241, 245))
  painter.fill_rect(rect, Qt6::QBrush.new(background))

  label(painter, 56, 72, "Image and pixmap workflow", 32, true)

  raw_rect = Qt6::RectF.new(70.0, 168.0, 220.0, 160.0)
  image_rect = Qt6::RectF.new(355.0, 168.0, 220.0, 160.0)
  transform_rect = Qt6::RectF.new(640.0, 168.0, 220.0, 160.0)
  pixmap_rect = Qt6::RectF.new(925.0, 168.0, 220.0, 160.0)

  draw_box(painter, raw_rect, "Bytes", "raw pixels\nencoded PNG", Qt6::Color.new(88, 132, 176))
  draw_box(painter, image_rect, "QImage", "inspect pixels\nedit data", Qt6::Color.new(92, 154, 110))
  draw_box(painter, transform_rect, "Transform", "scale\nmirror\nrotate", Qt6::Color.new(204, 132, 62))
  draw_box(painter, pixmap_rect, "QPixmap", "widget grabs\ndisplay edge", Qt6::Color.new(190, 86, 76))

  arrow(painter, Qt6::PointF.new(290.0, 248.0), Qt6::PointF.new(350.0, 248.0))
  arrow(painter, Qt6::PointF.new(575.0, 248.0), Qt6::PointF.new(635.0, 248.0))
  arrow(painter, Qt6::PointF.new(860.0, 248.0), Qt6::PointF.new(920.0, 248.0))

  label(painter, 666, 420, "QImage <-> QPixmap", 24, true)
  label(painter, 674, 454, "to_pixmap / to_image", 21)

  painter.pen = Qt6::QPen.new(Qt6::Color.new(70, 84, 98), 3.0)
  painter.brush = Qt6::Color.new(255, 255, 255)
  painter.draw_rect(Qt6::RectF.new(120.0, 480.0, 250.0, 120.0))
  painter.pen = no_pen
  painter.brush = Qt6::Color.new(82, 137, 190)
  painter.draw_ellipse(Qt6::PointF.new(172.0, 540.0), 26.0, 26.0)
  painter.brush = Qt6::Color.new(92, 154, 110)
  painter.fill_rect(Qt6::RectF.new(218.0, 512.0, 74.0, 54.0), Qt6::Color.new(92, 154, 110))
  painter.brush = Qt6::Color.new(210, 92, 76)
  painter.draw_ellipse(Qt6::PointF.new(316.0, 540.0), 22.0, 22.0)
  label(painter, 132, 640, "same raster content", 22, true)
end

render_image("images-io-clipboard.png") do |painter, rect|
  painter.fill_rect(rect, Qt6::Color.new(248, 250, 250))
  label(painter, 56, 72, "Loading, encoding, and clipboard flow", 32, true)

  file_rect = Qt6::RectF.new(66.0, 158.0, 215.0, 150.0)
  reader_rect = Qt6::RectF.new(342.0, 158.0, 240.0, 150.0)
  image_rect = Qt6::RectF.new(650.0, 158.0, 215.0, 150.0)
  buffer_rect = Qt6::RectF.new(932.0, 158.0, 215.0, 150.0)

  draw_box(painter, file_rect, "File", "png, jpg\nor bytes", Qt6::Color.new(84, 132, 180))
  draw_box(painter, reader_rect, "QImageReader", "probe size\nread safely", Qt6::Color.new(92, 154, 110))
  draw_box(painter, image_rect, "QImage", "working\nraster data", Qt6::Color.new(202, 126, 64))
  draw_box(painter, buffer_rect, "QBuffer", "PNG bytes\nin memory", Qt6::Color.new(180, 88, 112))

  arrow(painter, Qt6::PointF.new(281.0, 233.0), Qt6::PointF.new(337.0, 233.0))
  arrow(painter, Qt6::PointF.new(582.0, 233.0), Qt6::PointF.new(645.0, 233.0))
  arrow(painter, Qt6::PointF.new(865.0, 233.0), Qt6::PointF.new(927.0, 233.0))

  mime_rect = Qt6::RectF.new(342.0, 438.0, 240.0, 150.0)
  clip_rect = Qt6::RectF.new(650.0, 438.0, 215.0, 150.0)
  app_rect = Qt6::RectF.new(932.0, 438.0, 215.0, 150.0)

  draw_box(painter, mime_rect, "MimeData", "text + html\nimage + bytes", Qt6::Color.new(118, 98, 168))
  draw_box(painter, clip_rect, "Clipboard", "copy/paste\nshared payload", Qt6::Color.new(76, 142, 150))
  draw_box(painter, app_rect, "App UI", "preview\npaste target", Qt6::Color.new(206, 148, 72))

  arrow(painter, Qt6::PointF.new(760.0, 308.0), Qt6::PointF.new(480.0, 433.0))
  arrow(painter, Qt6::PointF.new(582.0, 513.0), Qt6::PointF.new(645.0, 513.0))
  arrow(painter, Qt6::PointF.new(865.0, 513.0), Qt6::PointF.new(927.0, 513.0))

  label(painter, 80, 390, "reader.error_string on failure", 23, true)
  label(painter, 786, 390, "save_to_data(\"PNG\")", 23, true)
end

render_image("model-view-architecture.png", 1400, 800) do |painter, rect|
  background = Qt6::QLinearGradient.new(0.0, 0.0, 0.0, rect.height)
  background.set_color_at(0.0, Qt6::Color.new(251, 252, 250))
  background.set_color_at(1.0, Qt6::Color.new(235, 241, 238))
  painter.fill_rect(rect, Qt6::QBrush.new(background))

  label(painter, 56, 72, "Model/view separates data, presentation, and interaction", 30, true)

  document_rect = Qt6::RectF.new(70.0, 178.0, 260.0, 155.0)
  model_rect = Qt6::RectF.new(405.0, 178.0, 260.0, 155.0)
  proxy_rect = Qt6::RectF.new(740.0, 178.0, 260.0, 155.0)
  view_rect = Qt6::RectF.new(1075.0, 178.0, 260.0, 180.0)
  delegate_rect = Qt6::RectF.new(405.0, 520.0, 260.0, 155.0)
  selection_rect = Qt6::RectF.new(740.0, 520.0, 260.0, 155.0)

  draw_node(painter, document_rect, "Document", "Crystal objects\narrays, ids, state", Qt6::Color.new(82, 132, 176))
  draw_node(painter, model_rect, "Model", "rows and columns\nroles and flags", Qt6::Color.new(92, 154, 110))
  draw_node(painter, proxy_rect, "Proxy", "sort and filter\nwithout copying", Qt6::Color.new(204, 132, 62))
  draw_node(painter, view_rect, "Views", "ListView\nTreeView\nTableView", Qt6::Color.new(174, 91, 85))
  draw_node(painter, delegate_rect, "Delegate", "display text\neditor widgets", Qt6::Color.new(118, 102, 174))
  draw_node(painter, selection_rect, "Selection", "current index\nshared state", Qt6::Color.new(78, 144, 150))

  arrow(painter, Qt6::PointF.new(330.0, 255.0), Qt6::PointF.new(400.0, 255.0))
  arrow(painter, Qt6::PointF.new(665.0, 255.0), Qt6::PointF.new(735.0, 255.0))
  arrow(painter, Qt6::PointF.new(1000.0, 255.0), Qt6::PointF.new(1070.0, 255.0))
  arrow(painter, Qt6::PointF.new(1130.0, 358.0), Qt6::PointF.new(1005.0, 558.0))
  arrow(painter, Qt6::PointF.new(870.0, 520.0), Qt6::PointF.new(870.0, 338.0))
  arrow(painter, Qt6::PointF.new(665.0, 520.0), Qt6::PointF.new(1075.0, 358.0))
  arrow(painter, Qt6::PointF.new(530.0, 520.0), Qt6::PointF.new(530.0, 338.0))

  label(painter, 70, 724, "The model owns meaning; views, proxies, delegates, and selection shape the surface.", 21, true)
end

render_image("model-view-choices.png", 1400, 800) do |painter, rect|
  painter.fill_rect(rect, Qt6::Color.new(249, 248, 244))
  label(painter, 56, 72, "Item widgets vs model-backed views", 32, true)

  item_rect = Qt6::RectF.new(80.0, 150.0, 560.0, 510.0)
  model_rect = Qt6::RectF.new(760.0, 150.0, 560.0, 510.0)

  painter.pen = Qt6::QPen.new(Qt6::Color.new(80, 94, 108), 3.0)
  painter.brush = Qt6::Color.new(255, 255, 255)
  painter.draw_rect(item_rect)
  painter.draw_rect(model_rect)

  painter.pen = no_pen
  painter.fill_rect(Qt6::RectF.new(80.0, 150.0, 560.0, 18.0), Qt6::Color.new(82, 132, 176))
  painter.fill_rect(Qt6::RectF.new(760.0, 150.0, 560.0, 18.0), Qt6::Color.new(92, 154, 110))

  label(painter, 120, 212, "Item widget", 29, true)
  label(painter, 800, 212, "Model-backed view", 29, true)

  draw_node(painter, Qt6::RectF.new(132.0, 258.0, 190.0, 125.0), "Widget", "owns its\nitem objects", Qt6::Color.new(82, 132, 176), 23, 18)
  draw_node(painter, Qt6::RectF.new(398.0, 258.0, 190.0, 125.0), "Items", "text, roles\nflags, state", Qt6::Color.new(174, 91, 85), 23, 18)
  arrow(painter, Qt6::PointF.new(322.0, 320.0), Qt6::PointF.new(393.0, 320.0))

  label(painter, 132, 468, "Best for:", 23, true)
  label(painter, 132, 506, "small owned lists", 22)
  label(painter, 132, 540, "quick inspectors", 22)
  label(painter, 132, 574, "fixed preference panes", 22)

  draw_node(painter, Qt6::RectF.new(812.0, 238.0, 190.0, 125.0), "Model", "application\ndata", Qt6::Color.new(92, 154, 110), 23, 18)
  draw_node(painter, Qt6::RectF.new(1078.0, 238.0, 190.0, 125.0), "Views", "list, tree\nor table", Qt6::Color.new(204, 132, 62), 23, 18)
  draw_node(painter, Qt6::RectF.new(946.0, 414.0, 190.0, 125.0), "Proxy", "sort and\nfilter", Qt6::Color.new(118, 102, 174), 23, 18)
  arrow(painter, Qt6::PointF.new(1002.0, 300.0), Qt6::PointF.new(1073.0, 300.0))
  arrow(painter, Qt6::PointF.new(1040.0, 414.0), Qt6::PointF.new(1108.0, 363.0))
  arrow(painter, Qt6::PointF.new(918.0, 363.0), Qt6::PointF.new(986.0, 414.0))

  label(painter, 812, 606, "Best for shared or changing data", 22, true)
end

render_image("model-view-proxy-selection.png", 1400, 800) do |painter, rect|
  background = Qt6::QLinearGradient.new(0.0, 0.0, 0.0, rect.height)
  background.set_color_at(0.0, Qt6::Color.new(250, 252, 253))
  background.set_color_at(1.0, Qt6::Color.new(236, 240, 244))
  painter.fill_rect(rect, Qt6::QBrush.new(background))

  label(painter, 56, 72, "Proxy indexes and shared selection", 32, true)

  source_rect = Qt6::RectF.new(80.0, 220.0, 270.0, 155.0)
  proxy_rect = Qt6::RectF.new(470.0, 220.0, 270.0, 155.0)
  list_rect = Qt6::RectF.new(930.0, 150.0, 270.0, 145.0)
  tree_rect = Qt6::RectF.new(930.0, 395.0, 270.0, 145.0)
  selection_rect = Qt6::RectF.new(450.0, 570.0, 320.0, 145.0)

  draw_node(painter, source_rect, "Source model", "true data order\nrows 0, 1, 2", Qt6::Color.new(92, 154, 110), 24, 18)
  draw_node(painter, proxy_rect, "Proxy model", "visible order\nfiltered rows", Qt6::Color.new(204, 132, 62), 24, 18)
  draw_node(painter, list_rect, "ListView", "shows proxy\ncurrent index", Qt6::Color.new(82, 132, 176), 24, 18)
  draw_node(painter, tree_rect, "TreeView", "same proxy\nsame selection", Qt6::Color.new(174, 91, 85), 24, 18)
  draw_node(painter, selection_rect, "Selection model", "one current index\nfor both views", Qt6::Color.new(78, 144, 150), 24, 18)

  arrow(painter, Qt6::PointF.new(350.0, 298.0), Qt6::PointF.new(465.0, 298.0))
  arrow(painter, Qt6::PointF.new(740.0, 270.0), Qt6::PointF.new(925.0, 220.0))
  arrow(painter, Qt6::PointF.new(740.0, 330.0), Qt6::PointF.new(925.0, 468.0))
  routed_arrow(painter, [
    Qt6::PointF.new(1200.0, 245.0),
    Qt6::PointF.new(1270.0, 245.0),
    Qt6::PointF.new(1270.0, 660.0),
    Qt6::PointF.new(773.0, 660.0),
  ])
  arrow(painter, Qt6::PointF.new(1060.0, 540.0), Qt6::PointF.new(773.0, 615.0))
  routed_arrow(painter, [
    Qt6::PointF.new(450.0, 640.0),
    Qt6::PointF.new(180.0, 640.0),
    Qt6::PointF.new(180.0, 380.0),
  ])

  label(painter, 320, 200, "map_from_source", 20, true)
  label(painter, 210, 500, "map_to_source before edit", 20, true)
  label(painter, 820, 690, "shared selection tracks the proxy model", 20, true)
end
