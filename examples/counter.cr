require "../src/qt6"

app = Qt6.application
count = 0

window = Qt6.window("Counter", 320, 140) do |widget|
  widget.vbox do |column|
    value = Qt6::Label.new(count.to_s)
    button = Qt6::PushButton.new("Increment")

    button.on_clicked do
      count += 1
      value.text = count.to_s
    end

    column << value
    column << button
  end
end

window.show
app.run
