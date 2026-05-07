require "../../src/qt6"

app = Qt6.application(["crystal-qt6-error-message-handler-probe"])
host = Qt6::Widget.new
handler = Qt6::ErrorMessage.qt_handler

begin
  host.show
  app.process_events

  raise "qt_handler did not return a stable singleton" unless handler.to_unsafe == Qt6::ErrorMessage.qt_handler.to_unsafe

  handler.show_message("Background importer warning", "import")
  app.process_events
  raise "qt_handler did not become visible" unless handler.visible?

  handler.done(Qt6::DialogCode::Rejected)
  app.process_events
  raise "qt_handler stayed visible after done" if handler.visible?
ensure
  host.release
end
