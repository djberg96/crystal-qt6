module Qt6
  # Wraps `QLinearGradient` for brush-backed linear color interpolation.
  class QLinearGradient < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(x1 : Number, y1 : Number, x2 : Number, y2 : Number)
      super(LibQt6.qt6cr_qlinear_gradient_create(x1.to_f64, y1.to_f64, x2.to_f64, y2.to_f64))
    end

    def initialize(start : PointF, final_stop : PointF)
      initialize(start.x, start.y, final_stop.x, final_stop.y)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def set_color_at(position : Number, color : Color) : self
      LibQt6.qt6cr_qlinear_gradient_set_color_at(to_unsafe, position.to_f64, color.to_native)
      self
    end

    def start : PointF
      PointF.from_native(LibQt6.qt6cr_qlinear_gradient_start(to_unsafe))
    end

    def final_stop : PointF
      PointF.from_native(LibQt6.qt6cr_qlinear_gradient_final_stop(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qlinear_gradient_destroy(to_unsafe)
    end
  end
end
