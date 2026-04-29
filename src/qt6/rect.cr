module Qt6
  record Rect, x : Int32, y : Int32, width : Int32, height : Int32 do
    def self.from_native(value : LibQt6::RectValue) : self
      new(value.x, value.y, value.width, value.height)
    end

    def to_native : LibQt6::RectValue
      LibQt6::RectValue.new(x: x, y: y, width: width, height: height)
    end

    def to_rect_f : RectF
      RectF.new(x.to_f64, y.to_f64, width.to_f64, height.to_f64)
    end
  end
end
