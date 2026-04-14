module Qt6
  record Size, width : Int32, height : Int32 do
    def self.from_native(value : LibQt6::SizeValue) : self
      new(value.width, value.height)
    end

    def to_size_f : SizeF
      SizeF.new(width.to_f64, height.to_f64)
    end
  end
end
