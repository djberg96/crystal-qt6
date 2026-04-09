module Qt6
  record KeyEvent, key : Int32, modifiers : Int32, auto_repeat : Bool, count : Int32 do
    def self.from_native(value : LibQt6::KeyEventValue) : self
      new(value.key, value.modifiers, value.auto_repeat, value.count)
    end
  end
end
