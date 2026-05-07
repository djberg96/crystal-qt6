module Qt6
  record SizeF, width : Float64, height : Float64 do
    def self.from_native(value : LibQt6::SizeFValue) : self
      new(value.width, value.height)
    end

    def to_size : Size
      Size.new(width.round.to_i32, height.round.to_i32)
    end
  end
end
