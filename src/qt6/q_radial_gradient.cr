module Qt6
  # Wraps `QRadialGradient` for brush-backed radial color interpolation.
  class QRadialGradient < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(center_x : Number, center_y : Number, radius : Number)
      super(LibQt6.qt6cr_qradial_gradient_create(center_x.to_f64, center_y.to_f64, radius.to_f64))
    end

    def initialize(center : PointF, radius : Number)
      initialize(center.x, center.y, radius)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def set_color_at(position : Number, color : Color) : self
      LibQt6.qt6cr_qradial_gradient_set_color_at(to_unsafe, position.to_f64, color.to_native)
      self
    end

    def center : PointF
      PointF.from_native(LibQt6.qt6cr_qradial_gradient_center(to_unsafe))
    end

    def radius : Float64
      LibQt6.qt6cr_qradial_gradient_radius(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qradial_gradient_destroy(to_unsafe)
    end
  end
end
