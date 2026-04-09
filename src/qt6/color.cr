module Qt6
  record Color, red : Int32, green : Int32, blue : Int32, alpha : Int32 = 255 do
    def self.from_native(value : LibQt6::ColorValue) : self
      new(value.red, value.green, value.blue, value.alpha)
    end

    def to_native : LibQt6::ColorValue
      LibQt6::ColorValue.new(red: red, green: green, blue: blue, alpha: alpha)
    end
  end
end