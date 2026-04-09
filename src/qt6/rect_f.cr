module Qt6
  record RectF, x : Float64, y : Float64, width : Float64, height : Float64 do
    def self.from_native(value : LibQt6::RectFValue) : self
      new(value.x, value.y, value.width, value.height)
    end

    def to_native : LibQt6::RectFValue
      LibQt6::RectFValue.new(x: x, y: y, width: width, height: height)
    end
  end
end
