require "../src/qt6"

app = Qt6.application

heartbeat = Qt6::Label.new("Timer ticks: 0")
size_label = Qt6::Label.new("Canvas size: waiting for first resize")
event_label = Qt6::Label.new("Last event: none")
hint_label = Qt6::Label.new("Click the canvas, move the mouse, scroll, or press a key after focusing it.")
canvas = Qt6::EventWidget.new
ticks = 0

canvas.on_resize do |event|
  size_label.text = "Canvas size: #{event.size.width}x#{event.size.height}"
end

canvas.on_paint do |event|
  event_label.text = "Paint rect: #{event.rect.width.to_i}x#{event.rect.height.to_i}"
end

canvas.on_mouse_press do |event|
  event_label.text = "Mouse press at (#{event.position.x.to_i}, #{event.position.y.to_i})"
end

canvas.on_mouse_move do |event|
  event_label.text = "Mouse move at (#{event.position.x.to_i}, #{event.position.y.to_i})"
end

canvas.on_wheel do |event|
  event_label.text = "Wheel delta: #{event.angle_delta.y.to_i}"
end

canvas.on_key_press do |event|
  event_label.text = "Key press: #{event.key}"
end

timer = Qt6::QTimer.new
timer.on_timeout do
  ticks += 1
  heartbeat.text = "Timer ticks: #{ticks}"
end
timer.start(500)

window = Qt6.window("Event Monitor", 480, 360) do |widget|
  widget.vbox do |column|
    column << heartbeat
    column << size_label
    column << event_label
    column << hint_label
    column << canvas
  end
end

canvas.resize(420, 220)
window.show
app.run