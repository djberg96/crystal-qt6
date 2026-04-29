module Qt6
  # Wraps `QConicalGradient` for brush-backed angular color interpolation.
  class QConicalGradient < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(center_x : Number, center_y : Number, angle : Number)
      super(LibQt6.qt6cr_qconical_gradient_create(center_x.to_f64, center_y.to_f64, angle.to_f64))
    end

    def initialize(center : PointF, angle : Number)
      initialize(center.x, center.y, angle)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def set_color_at(position : Number, color : Color) : self
      LibQt6.qt6cr_qconical_gradient_set_color_at(to_unsafe, position.to_f64, color.to_native)
      self
    end

    def center : PointF
      PointF.from_native(LibQt6.qt6cr_qconical_gradient_center(to_unsafe))
    end

    def angle : Float64
      LibQt6.qt6cr_qconical_gradient_angle(to_unsafe)
    end

    def angle=(value : Number) : Float64
      angle = value.to_f64
      LibQt6.qt6cr_qconical_gradient_set_angle(to_unsafe, angle)
      angle
    end

    def spread : GradientSpread
      GradientSpread.from_value(LibQt6.qt6cr_qconical_gradient_spread(to_unsafe))
    end

    def spread=(value : GradientSpread) : GradientSpread
      LibQt6.qt6cr_qconical_gradient_set_spread(to_unsafe, value.value)
      value
    end

    def coordinate_mode : GradientCoordinateMode
      GradientCoordinateMode.from_value(LibQt6.qt6cr_qconical_gradient_coordinate_mode(to_unsafe))
    end

    def coordinate_mode=(value : GradientCoordinateMode) : GradientCoordinateMode
      LibQt6.qt6cr_qconical_gradient_set_coordinate_mode(to_unsafe, value.value)
      value
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qconical_gradient_destroy(to_unsafe)
    end
  end
end
