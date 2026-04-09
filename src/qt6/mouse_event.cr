module Qt6
  record MouseEvent, position : PointF, button : Int32, buttons : Int32, modifiers : Int32 do
    def self.from_native(value : LibQt6::MouseEventValue) : self
      new(PointF.from_native(value.position), value.button, value.buttons, value.modifiers)
    end
  end
end
