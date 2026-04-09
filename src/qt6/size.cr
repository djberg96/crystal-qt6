module Qt6
  record Size, width : Int32, height : Int32 do
    def self.from_native(value : LibQt6::SizeValue) : self
      new(value.width, value.height)
    end
  end
end
