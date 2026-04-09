module Qt6
  record WheelEvent, position : PointF, pixel_delta : PointF, angle_delta : PointF, buttons : Int32, modifiers : Int32 do
    def self.from_native(value : LibQt6::WheelEventValue) : self
      new(
        PointF.from_native(value.position),
        PointF.from_native(value.pixel_delta),
        PointF.from_native(value.angle_delta),
        value.buttons,
        value.modifiers
      )
    end
  end
end
