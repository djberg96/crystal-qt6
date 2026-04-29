module Qt6
  record GradientStop, position : Float64, color : Color do
    def self.from_native(value : LibQt6::GradientStopValue) : self
      new(value.position, Color.from_native(value.color))
    end
  end
end
