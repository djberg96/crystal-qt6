require "../src/qt6"

app = Qt6.application
app.name = "Application Services Showcase"
app.organization_name = "crystal-qt6"
app.organization_domain = "crystal-qt6.example"
app.style_sheet = <<-CSS
  QWidget { font-family: "Avenir Next"; font-size: 13px; }
  QMainWindow { background: rgb(248, 244, 236); }
  QLabel { color: rgb(56, 52, 46); }
  QPushButton { padding: 6px 12px; }
CSS

icon_path = File.join(Dir.tempdir, "crystal-qt6-services-#{Process.pid}.png")
icon_source = Qt6::QImage.new(72, 72)
icon_source.fill(Qt6::Color.new(244, 238, 226))

Qt6::QPainter.paint(icon_source) do |painter|
  painter.antialiasing = false
  painter.fill_rect(Qt6::RectF.new(10.0, 10.0, 52.0, 52.0), Qt6::Color.new(62, 130, 109))
  painter.pen = Qt6::QPen.new(Qt6::Color.new(38, 66, 92), 4.0)
  painter.draw_line(Qt6::PointF.new(18.0, 54.0), Qt6::PointF.new(54.0, 18.0))
  painter.draw_text(Qt6::PointF.new(18.0, 40.0), "Qt6")
end
icon_source.save(icon_path)

reader = Qt6::QImageReader.new(icon_path)
reader.auto_transform = true
icon = Qt6::QIcon.from_file(icon_path)
app.window_icon = icon

main = Qt6::MainWindow.new
main.window_title = "Application Services Showcase"
main.resize(1120, 760)
main.window_icon = icon

status_bar = main.status_bar
status_bar.show_message("Preparing startup sequence")

splash = Qt6::SplashScreen.new(icon_source.to_pixmap)
splash.show
splash.show_message("Loading application services...", Qt6::Color.new(32, 64, 96))

startup_progress = Qt6::ProgressDialog.new(main, label_text: "Bootstrapping workbench", cancel_button_text: "Skip", minimum: 0, maximum: 5)
startup_progress.minimum_duration = 0
startup_progress.auto_close = false
startup_progress.auto_reset = false
startup_progress.value = 0

startup_loop = Qt6::QEventLoop.new(main)
startup_step = 0
startup_timer = Qt6::QTimer.new(startup_progress)
startup_timer.interval = 160
startup_timer.on_timeout do
  startup_step += 1
  startup_progress.value = startup_step
  splash.show_message("Startup step #{startup_step}/5", Qt6::Color.new(32, 64, 96))

  if startup_step >= 5 || startup_progress.was_canceled?
    startup_timer.stop
    startup_progress.close
    startup_loop.quit
  end
end
startup_progress.on_canceled do
  status_bar.show_message("Startup flow canceled by user", 1800)
end
startup_progress.show
startup_timer.start
startup_loop.run

reader_label = Qt6::Label.new("ImageReader: #{reader.format.upcase} | #{reader.size.width}x#{reader.size.height} | can_read=#{reader.can_read?}")
app_label = Qt6::Label.new("App: #{app.name} | #{app.organization_name} | #{app.organization_domain}")
style_label = Qt6::Label.new("Stylesheet + window icon are applied at the application and main-window level.")
event_loop_label = Qt6::Label.new("Nested QEventLoop handled the startup progress sequence before the main window appeared.")
clipboard_label = Qt6::Label.new("Clipboard MIME: nothing copied yet")
drop_label = Qt6::Label.new("Drop Target: drag plain text from another app into the panel on the right.")
message_log = Qt6::Label.new("Status: ready")

copy_button = Qt6::PushButton.new("Copy MIME Payload")
inspect_button = Qt6::PushButton.new("Inspect Clipboard")
clear_button = Qt6::PushButton.new("Clear Clipboard")
replay_button = Qt6::PushButton.new("Replay Progress")

copy_button.on_clicked do
  mime_data = Qt6::MimeData.new
  mime_data.text = "terrain overlay"
  mime_data.set_data("application/x-crystal-qt6-demo", "layer=terrain;zoom=1.25")
  Qt6.clipboard.mime_data = mime_data
  status_bar.show_message("Copied text + custom MIME payload to the clipboard", 1800)
end

inspect_button.on_clicked do
  if mime = Qt6.clipboard.mime_data
    payload = mime.has_format?("application/x-crystal-qt6-demo") ? String.new(mime.data("application/x-crystal-qt6-demo")) : "none"
    clipboard_label.text = "Clipboard MIME: text=#{mime.has_text? ? mime.text : "(none)"} | custom=#{payload}"
    status_bar.show_message("Inspected clipboard MIME payload", 1800)
  else
    clipboard_label.text = "Clipboard MIME: unavailable"
  end
end

clear_button.on_clicked do
  Qt6.clipboard.clear
  clipboard_label.text = "Clipboard MIME: cleared"
  status_bar.show_message("Clipboard cleared", 1400)
end

replay_button.on_clicked do
  progress = Qt6::ProgressDialog.new(main, label_text: "Refreshing service cache", cancel_button_text: "Cancel", minimum: 0, maximum: 4)
  progress.minimum_duration = 0
  progress.auto_close = true
  progress.auto_reset = true
  progress.show

  loop = Qt6::QEventLoop.new(main)
  step = 0
  timer = Qt6::QTimer.new(progress)
  timer.interval = 140
  timer.on_timeout do
    step += 1
    progress.value = step
    if step >= 4 || progress.was_canceled?
      timer.stop
      loop.quit
    end
  end
  timer.start
  loop.run
  progress.close
  status_bar.show_message(progress.was_canceled? ? "Replay canceled" : "Replay finished", 1800)
end

drop_surface = Qt6::EventWidget.new
drop_surface.resize(440, 320)
drop_surface.accept_drops = true
drop_message = "Drop plain text here"
drop_surface.on_drag_enter do |event|
  if payload = event.mime_data
    if payload.has_text?
      drop_message = "Release to import: #{payload.text}"
      event.accept_proposed_action
      drop_surface.update
    else
      event.ignore
    end
  else
    event.ignore
  end
end
drop_surface.on_drag_move do |event|
  if event.mime_data.try(&.has_text?)
    event.accept_proposed_action
  else
    event.ignore
  end
end
drop_surface.on_drop do |event|
  if payload = event.mime_data
    drop_message = "Dropped text: #{payload.text}"
    drop_label.text = "Drop Target: #{payload.text}"
    message_log.text = "Status: imported text at #{event.position.x.round.to_i},#{event.position.y.round.to_i}"
    event.accept_proposed_action
    drop_surface.update
    status_bar.show_message("Imported dropped text", 1800)
  else
    event.ignore
  end
end
drop_surface.on_paint_with_painter do |event, painter|
  painter.fill_rect(event.rect, Qt6::Color.new(232, 238, 242))
  painter.pen = Qt6::QPen.new(Qt6::Color.new(92, 104, 116), 2.0)
  painter.draw_rect(Qt6::RectF.new(8.0, 8.0, event.rect.width - 16.0, event.rect.height - 16.0))
  painter.pen = Qt6::Color.new(36, 52, 68)
  painter.draw_text(Qt6::PointF.new(22.0, 36.0), "Drop Receiver")
  painter.draw_text(Qt6::PointF.new(22.0, 64.0), drop_message)
  painter.draw_text(Qt6::PointF.new(22.0, 92.0), "Clipboard and MIME controls are on the left.")
end

services_panel = Qt6::Widget.new
services_panel.vbox do |column|
  column << Qt6::Label.new("Application Services")
  column << app_label
  column << reader_label
  column << style_label
  column << event_loop_label
  column << clipboard_label
  column << drop_label
  column << message_log
  column << copy_button
  column << inspect_button
  column << clear_button
  column << replay_button
end

splitter = Qt6::Splitter.new(Qt6::Orientation::Horizontal)
splitter << services_panel
splitter << drop_surface
main.central_widget = splitter

main.show
splash.show_message("Ready", Qt6::Color.new(32, 64, 96))
app.process_events
splash.finish(main)
splash.release
status_bar.show_message("Ready")
app.run
