require "../src/qt6"

app = Qt6.application

main = Qt6::MainWindow.new
main.window_title = "Inspector Workbench"
main.resize(1080, 720)

status_bar = main.status_bar
canvas = Qt6::EventWidget.new
canvas.resize(640, 640)

size_label = Qt6::Label.new("Canvas size: waiting for first resize")
mode_label = Qt6::Label.new
grid_label = Qt6::Label.new
style_label = Qt6::Label.new
tab_label = Qt6::Label.new
hint_label = Qt6::Label.new("Drag the splitter, switch tabs, or tweak the controls to redraw the scene.")

mode_group = Qt6::GroupBox.new("Render Mode")
auto_mode = Qt6::RadioButton.new("Auto layout")
manual_mode = Qt6::RadioButton.new("Manual layout")
auto_mode.checked = true

grid_group = Qt6::GroupBox.new("Grid")
grid_group.checkable = true
grid_group.checked = true
spacing_slider = Qt6::Slider.new(Qt6::Orientation::Horizontal)
spacing_slider.set_range(12, 52)
spacing_slider.value = 28

marker_spin = Qt6::SpinBox.new
marker_spin.set_range(8, 48)
marker_spin.single_step = 2
marker_spin.value = 20

line_width_spin = Qt6::DoubleSpinBox.new
line_width_spin.set_range(1.0, 6.0)
line_width_spin.single_step = 0.5
line_width_spin.value = 2.5

zoom_spin = Qt6::DoubleSpinBox.new
zoom_spin.set_range(0.5, 2.0)
zoom_spin.single_step = 0.1
zoom_spin.value = 1.0

layers_group = Qt6::GroupBox.new("Layers")
layers_group.checkable = true
layers_group.checked = true
layer_tabs = Qt6::TabWidget.new

terrain_page = Qt6::Widget.new
terrain_page.vbox do |column|
  column << Qt6::Label.new("Terrain")
  column << Qt6::Label.new("Drives the grid color and density.")
  column << Qt6::Label.new("Use the slider to tighten or loosen the spacing.")
end

units_page = Qt6::Widget.new
units_page.vbox do |column|
  column << Qt6::Label.new("Units")
  column << Qt6::Label.new("Uses the spin boxes to size markers and line weight.")
  column << Qt6::Label.new("Switch render mode to compare automatic and manual placement.")
end

export_page = Qt6::Widget.new
export_page.vbox do |column|
  column << Qt6::Label.new("Export")
  column << Qt6::Label.new("This example is focused on live inspector updates.")
  column << Qt6::Label.new("Use rendering_stack.cr for file export examples.")
end

layer_tabs.add_tab(terrain_page, "Terrain")
layer_tabs.add_tab(units_page, "Units")
layer_tabs.add_tab(export_page, "Export")

refresh_status = -> do
  mode = manual_mode.checked? ? "Manual" : "Auto"
  spacing = spacing_slider.value
  marker = marker_spin.value
  width = line_width_spin.value.round(1)
  zoom = zoom_spin.value.round(2)
  grid_on = grid_group.checked? ? "on" : "off"
  layer_on = layers_group.checked? ? "on" : "off"

  mode_label.text = "Mode: #{mode}"
  grid_label.text = "Grid #{grid_on} | spacing #{spacing} | zoom #{zoom}x"
  style_label.text = "Markers #{marker}px | line width #{width} | layers #{layer_on}"
  tab_label.text = "Inspector tab: #{layer_tabs.current_index + 1} / #{layer_tabs.count}"
  canvas.update
end

display_tab = Qt6::Widget.new
display_tab.vbox do |column|
  mode_group.vbox do |mode_column|
    mode_column << auto_mode
    mode_column << manual_mode
  end

  grid_group.form do |form|
    form.add_row("Spacing", spacing_slider)
    form.add_row("Marker size", marker_spin)
    form.add_row("Line width", line_width_spin)
    form.add_row("Zoom", zoom_spin)
  end

  column << mode_group
  column << grid_group
  column << mode_label
  column << grid_label
  column << style_label
end

layers_tab = Qt6::Widget.new
layers_tab.vbox do |column|
  layers_group.vbox do |group_column|
    group_column << layer_tabs
  end
  column << layers_group
  column << tab_label
  column << hint_label
end

inspector_tabs = Qt6::TabWidget.new
inspector_tabs.add_tab(display_tab, "Display")
inspector_tabs.add_tab(layers_tab, "Layers")

inspector_root = Qt6::Widget.new
inspector_root.vbox do |column|
  column << inspector_tabs
  column << size_label
end

scroll_area = Qt6::ScrollArea.new
scroll_area.widget_resizable = true
scroll_area.widget = inspector_root

splitter = Qt6::Splitter.new(Qt6::Orientation::Horizontal)
splitter << scroll_area
splitter << canvas
main.central_widget = splitter

apply_change = ->(message : String) do
  refresh_status.call
  status_bar.show_message(message, 1800)
end

auto_mode.on_toggled do |checked|
  apply_change.call(checked ? "Switched to automatic placement" : "Automatic placement disabled")
end

manual_mode.on_toggled do |checked|
  apply_change.call(checked ? "Switched to manual placement" : "Manual placement disabled")
end

spacing_slider.on_value_changed do |value|
  apply_change.call("Grid spacing #{value}")
end

marker_spin.on_value_changed do |value|
  apply_change.call("Marker size #{value}")
end

line_width_spin.on_value_changed do |value|
  apply_change.call("Line width #{value.round(1)}")
end

zoom_spin.on_value_changed do |value|
  apply_change.call("Zoom #{value.round(2)}x")
end

grid_group.on_toggled do |checked|
  apply_change.call(checked ? "Grid enabled" : "Grid hidden")
end

layers_group.on_toggled do |checked|
  apply_change.call(checked ? "Layer overlays enabled" : "Layer overlays hidden")
end

layer_tabs.on_current_index_changed do |_index|
  apply_change.call("Layer tab #{layer_tabs.current_index + 1}")
end

inspector_tabs.on_current_index_changed do |_index|
  apply_change.call("Inspector page #{inspector_tabs.current_index + 1}")
end

canvas.on_resize do |event|
  size_label.text = "Canvas size: #{event.size.width}x#{event.size.height}"
end

canvas.on_paint_with_painter do |event, painter|
  background = manual_mode.checked? ? Qt6::Color.new(248, 240, 232) : Qt6::Color.new(236, 244, 246)
  painter.fill_rect(event.rect, background)

  margin = 18.0
  zoom = zoom_spin.value
  spacing = spacing_slider.value.to_f * zoom
  grid_width = line_width_spin.value
  marker_size = marker_spin.value.to_f
  working_rect = Qt6::RectF.new(margin, margin, event.rect.width - margin * 2.0, event.rect.height - margin * 2.0)

  painter.pen = Qt6::QPen.new(Qt6::Color.new(56, 78, 89), grid_width)
  painter.draw_rect(working_rect)

  if grid_group.checked?
    grid_pen = Qt6::QPen.new(Qt6::Color.new(176, 188, 196), 1.0)
    painter.pen = grid_pen

    x = working_rect.x + spacing
    while x < working_rect.x + working_rect.width
      painter.draw_line(Qt6::PointF.new(x, working_rect.y), Qt6::PointF.new(x, working_rect.y + working_rect.height))
      x += spacing
    end

    y = working_rect.y + spacing
    while y < working_rect.y + working_rect.height
      painter.draw_line(Qt6::PointF.new(working_rect.x, y), Qt6::PointF.new(working_rect.x + working_rect.width, y))
      y += spacing
    end
  end

  overlay_pen = Qt6::QPen.new(Qt6::Color.new(32, 96, 192), grid_width)
  painter.pen = overlay_pen

  points = if manual_mode.checked?
             [
               Qt6::PointF.new(working_rect.x + 52.0, working_rect.y + 64.0),
               Qt6::PointF.new(working_rect.x + 180.0, working_rect.y + 112.0),
               Qt6::PointF.new(working_rect.x + 310.0, working_rect.y + 86.0),
             ]
           else
             [
               Qt6::PointF.new(working_rect.x + 72.0, working_rect.y + 72.0),
               Qt6::PointF.new(working_rect.x + 196.0, working_rect.y + 120.0),
               Qt6::PointF.new(working_rect.x + 320.0, working_rect.y + 96.0),
             ]
           end

  if layers_group.checked?
    points.each_cons(2) do |segment|
      painter.draw_line(segment[0], segment[1])
    end
  end

  marker_color = layer_tabs.current_index == 1 ? Qt6::Color.new(212, 86, 66) : Qt6::Color.new(62, 130, 109)
  marker_brush = Qt6::QBrush.new(marker_color)
  painter.brush = marker_brush

  points.each_with_index do |point, index|
    painter.draw_ellipse(Qt6::RectF.new(point.x - marker_size / 2.0, point.y - marker_size / 2.0, marker_size, marker_size))
    painter.draw_text(Qt6::PointF.new(point.x + marker_size / 2.0 + 6.0, point.y + 4.0), "#{index + 1}")
  end

  painter.pen = Qt6::Color.new(52, 52, 52)
  painter.draw_text(Qt6::PointF.new(working_rect.x, working_rect.y - 4.0), "#{manual_mode.checked? ? "Manual" : "Auto"} scene | #{layer_tabs.current_index == 2 ? "Export notes" : layer_tabs.current_index == 1 ? "Units" : "Terrain"}")
end

refresh_status.call
status_bar.show_message("Ready")
main.show
app.run