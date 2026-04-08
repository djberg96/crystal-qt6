require "../src/qt6"

app = Qt6.application

window = Qt6.window("Crystal Qt6", 480, 180) do |widget|
  widget.vbox do |column|
    column << Qt6::Label.new("Qt6 from Crystal, with a small and explicit API.")
    button = Qt6::PushButton.new("Close")
    button.on_clicked { app.quit }
    column << button
  end
end

window.show
app.run
