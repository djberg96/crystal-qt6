module Qt6
  record PointF, x : Float64, y : Float64 do
    def self.from_native(value : LibQt6::PointFValue) : self
      new(value.x, value.y)
    end

    def to_native : LibQt6::PointFValue
      LibQt6::PointFValue.new(x: x, y: y)
    end
  end
end
