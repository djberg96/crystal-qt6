require "../src/qt6"

OUTPUT_DIR = File.expand_path("../docs/book/images", __DIR__)
Dir.mkdir_p(OUTPUT_DIR)

def process_paints(app : Qt6::Application)
  12.times { app.process_events }
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

def token_pixmap(fill : Qt6::Color, label : String) : Qt6::QPixmap
  image = Qt6::QImage.new(72, 72)
  image.fill(Qt6::Color.new(0, 0, 0, 0))

  Qt6::QPainter.paint(image) do |painter|
    painter.antialiasing = true
    painter.pen = Qt6::QPen.new(Qt6::Color.new(36, 44, 52), 3.0)
    painter.brush = Qt6::QBrush.new(fill)
    painter.draw_ellipse(Qt6::RectF.new(6.0, 6.0, 60.0, 60.0))

    painter.font = Qt6::QFont.new("Helvetica", 22, bold: true)
    painter.pen = Qt6::Color.new(255, 255, 255)
    painter.draw_text(
      Qt6::RectF.new(6.0, 6.0, 60.0, 60.0),
      Qt6::AlignmentFlag::Center,
      label
    )
  end

  Qt6::QPixmap.from_image(image)
end

app = Qt6.application(["capture-graphics-view-screenshots"])
app.name = "Graphics View Screenshots"
app.organization_name = "crystal-qt6"
app.style_sheet = <<-CSS
  QWidget {
    font-size: 14px;
  }
  QLabel {
    color: rgb(33, 43, 54);
  }
  QLineEdit, QComboBox, QPushButton {
    background: white;
    border: 1px solid rgb(188, 198, 207);
    border-radius: 4px;
    padding: 4px 6px;
  }
  QPushButton {
    background: rgb(235, 241, 246);
    font-weight: bold;
  }
CSS

scene = Qt6::GraphicsScene.new(0, 0, 520, 320)
scene.background_brush = Qt6::QBrush.new(Qt6::Color.new(244, 246, 248))
scene.foreground_brush = Qt6::QBrush.new(Qt6::Color.new(45, 55, 65, 10))

scene.add_rect(
  24, 24, 180, 120,
  Qt6::QPen.new(Qt6::Color.new(78, 93, 105), 2.0),
  Qt6::QBrush.new(Qt6::Color.new(219, 231, 214))
)

scene.add_ellipse(
  360, 170, 104, 92,
  Qt6::QPen.new(Qt6::Color.new(144, 58, 68), 3.0),
  Qt6::QBrush.new(Qt6::Color.new(225, 123, 132, 220))
)

route = Qt6::QPainterPath.new
route.move_to(Qt6::PointF.new(84.0, 94.0))
route.cubic_to(
  Qt6::PointF.new(162.0, 40.0),
  Qt6::PointF.new(286.0, 222.0),
  Qt6::PointF.new(396.0, 112.0)
)
route_item = scene.add_path(
  route,
  Qt6::QPen.new(Qt6::Color.new(34, 89, 140), 7.0)
)
route_item.z_value = 2.0

overview_label = Qt6::GraphicsSimpleTextItem.new("Supply Corridor")
overview_label.font = Qt6::QFont.new("Helvetica", 18, bold: true)
overview_label.brush = Qt6::QBrush.new(Qt6::Color.new(39, 47, 56))
overview_label.set_pos(68, 44)
scene.add_item(overview_label)

pixmap_item = scene.add_pixmap(token_pixmap(Qt6::Color.new(58, 136, 212), "HQ"))
pixmap_item.set_offset(-36, -36)
pixmap_item.set_pos(300, 236)
pixmap_item.z_value = 3.0

overview = Qt6::GraphicsView.new(scene)
overview.window_title = "Graphics View Overview"
overview.resize(680, 430)
overview.render_hints =
  Qt6::PainterRenderHint::Antialiasing |
  Qt6::PainterRenderHint::TextAntialiasing |
  Qt6::PainterRenderHint::SmoothPixmapTransform
overview.background_brush = Qt6::QBrush.new(Qt6::Color.new(249, 250, 252))
overview.alignment = Qt6::AlignmentFlag::Center
save_widget(app, overview, "graphics-view-overview.png")

panel_scene = Qt6::GraphicsScene.new(0, 0, 520, 320)
panel_scene.background_brush = Qt6::QBrush.new(Qt6::Color.new(241, 244, 246))

grid_pen = Qt6::QPen.new(Qt6::Color.new(204, 212, 219), 1.0)
0.step(to: 520, by: 40) do |x|
  panel_scene.add_line(x, 0, x, 320, grid_pen)
end
0.step(to: 320, by: 40) do |y|
  panel_scene.add_line(0, y, 520, y, grid_pen)
end

panel_route = Qt6::QPainterPath.new
panel_route.move_to(Qt6::PointF.new(40.0, 230.0))
panel_route.cubic_to(
  Qt6::PointF.new(140.0, 90.0),
  Qt6::PointF.new(220.0, 270.0),
  Qt6::PointF.new(320.0, 150.0)
)
panel_scene.add_path(panel_route, Qt6::QPen.new(Qt6::Color.new(50, 108, 160), 6.0))

panel_scene.add_ellipse(
  70, 70, 70, 70,
  Qt6::QPen.new(Qt6::Color.new(152, 64, 76), 3.0),
  Qt6::QBrush.new(Qt6::Color.new(228, 135, 144, 220))
)

panel = Qt6::GraphicsWidget.new
panel.set_geometry(286, 30, 188, 196)

layout = Qt6::GraphicsLinearLayout.new(Qt6::Orientation::Vertical)
layout.set_contents_margins(12, 12, 12, 12)
layout.spacing = 8.0
panel.layout = layout

title_proxy = Qt6::GraphicsProxyWidget.new(Qt6::Label.new("Selection"), panel)
title_proxy.set_preferred_size(156, 24)

name_proxy = Qt6::GraphicsProxyWidget.new(Qt6::LineEdit.new("Rail Bridge"), panel)
name_proxy.set_preferred_size(156, 30)

kind = Qt6::ComboBox.new
kind << "Bridge" << "Depot" << "Checkpoint"
kind.current_index = 0
kind_proxy = Qt6::GraphicsProxyWidget.new(kind, panel)
kind_proxy.set_preferred_size(156, 30)

apply_proxy = Qt6::GraphicsProxyWidget.new(Qt6::PushButton.new("Apply Changes"), panel)
apply_proxy.set_preferred_size(156, 32)

layout.add_item(title_proxy)
layout.add_item(name_proxy)
layout.add_item(kind_proxy)
layout.add_stretch
layout.add_item(apply_proxy)

panel_scene.add_item(panel)

panel_view = Qt6::GraphicsView.new(panel_scene)
panel_view.window_title = "Graphics View Floating Panel"
panel_view.resize(680, 430)
panel_view.render_hints =
  Qt6::PainterRenderHint::Antialiasing |
  Qt6::PainterRenderHint::TextAntialiasing
panel_view.background_brush = Qt6::QBrush.new(Qt6::Color.new(248, 249, 251))
save_widget(app, panel_view, "graphics-view-floating-panel.png")

transform_scene = Qt6::GraphicsScene.new(0, 0, 520, 320)
transform_scene.background_brush = Qt6::QBrush.new(Qt6::Color.new(245, 244, 239))
transform_scene.add_rect(
  26, 24, 468, 272,
  Qt6::QPen.new(Qt6::Color.new(188, 194, 199), 2.0),
  Qt6::QBrush.new(Qt6::Color.new(255, 255, 255))
)

base = transform_scene.add_pixmap(token_pixmap(Qt6::Color.new(58, 136, 212), "A"))
base.set_offset(-36, -36)
base.set_pos(126, 152)

rotated = transform_scene.add_pixmap(token_pixmap(Qt6::Color.new(226, 108, 67), "B"))
rotated.set_offset(-36, -36)
rotated.set_pos(262, 152)
rotation = Qt6::GraphicsRotation.new
rotation.origin = Qt6::Vector3D.new(0.0, 0.0, 0.0)
rotation.angle = 22
rotation.axis = Qt6::Axis::ZAxis
rotated.transformations = [rotation]

scaled = transform_scene.add_pixmap(token_pixmap(Qt6::Color.new(91, 170, 112), "C"))
scaled.set_offset(-36, -36)
scaled.set_pos(398, 152)
scale = Qt6::GraphicsScale.new
scale.origin = Qt6::Vector3D.new(0.0, 0.0, 0.0)
scale.x_scale = 1.35
scale.y_scale = 1.35
scaled.transformations = [scale]

base_label = Qt6::GraphicsSimpleTextItem.new("base")
base_label.set_pos(100, 232)
transform_scene.add_item(base_label)

rotated_label = Qt6::GraphicsSimpleTextItem.new("rotation")
rotated_label.set_pos(228, 232)
transform_scene.add_item(rotated_label)

scaled_label = Qt6::GraphicsSimpleTextItem.new("scale")
scaled_label.set_pos(372, 232)
transform_scene.add_item(scaled_label)

transform_view = Qt6::GraphicsView.new(transform_scene)
transform_view.window_title = "Graphics View Transforms"
transform_view.resize(680, 430)
transform_view.render_hints =
  Qt6::PainterRenderHint::Antialiasing |
  Qt6::PainterRenderHint::TextAntialiasing |
  Qt6::PainterRenderHint::SmoothPixmapTransform
transform_view.background_brush = Qt6::QBrush.new(Qt6::Color.new(250, 249, 246))
save_widget(app, transform_view, "graphics-view-transforms.png")
