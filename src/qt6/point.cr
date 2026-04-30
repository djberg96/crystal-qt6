module Qt6
  record Point, x : Int32, y : Int32 do
    def self.from_native(value : LibQt6::PointValue) : self
      new(value.x, value.y)
    end

    def to_native : LibQt6::PointValue
      LibQt6::PointValue.new(x: x, y: y)
    end

    def to_point_f : PointF
      PointF.new(x.to_f64, y.to_f64)
    end
  end
end
