require "../../src/qt6"

app = Qt6.application(["crystal-qt6-exit-probe"])

window = Qt6.window("Exit Probe", 240, 100) do |widget|
  widget.vbox do |column|
    column << Qt6::Label.new("Shutdown should be quiet.")
  end
end

window.show
app.process_events
window.close
app.process_events
