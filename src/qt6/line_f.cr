module Qt6
  record LineF, p1 : PointF, p2 : PointF do
    def self.new(x1 : Number, y1 : Number, x2 : Number, y2 : Number) : self
      new(PointF.new(x1.to_f64, y1.to_f64), PointF.new(x2.to_f64, y2.to_f64))
    end

    def self.from_native(value : LibQt6::LineFValue) : self
      new(value.x1, value.y1, value.x2, value.y2)
    end

    def to_native : LibQt6::LineFValue
      LibQt6::LineFValue.new(x1: x1, y1: y1, x2: x2, y2: y2)
    end

    def x1 : Float64
      p1.x
    end

    def y1 : Float64
      p1.y
    end

    def x2 : Float64
      p2.x
    end

    def y2 : Float64
      p2.y
    end

    def dx : Float64
      x2 - x1
    end

    def dy : Float64
      y2 - y1
    end

    def center : PointF
      PointF.new((x1 + x2) / 2.0, (y1 + y2) / 2.0)
    end

    def length : Float64
      Math.hypot(dx, dy)
    end

    def null? : Bool
      x1 == x2 && y1 == y2
    end

    def angle : Float64
      degrees = Math.atan2(-dy, dx) * 180.0 / Math::PI
      degrees += 360.0 if degrees < 0.0
      degrees
    end

    def point_at(t : Number) : PointF
      ratio = t.to_f64
      PointF.new(x1 + (dx * ratio), y1 + (dy * ratio))
    end

    def translated(dx : Number, dy : Number) : self
      translated(PointF.new(dx.to_f64, dy.to_f64))
    end

    def translated(offset : PointF) : self
      LineF.new(
        x1 + offset.x,
        y1 + offset.y,
        x2 + offset.x,
        y2 + offset.y
      )
    end
  end
end
