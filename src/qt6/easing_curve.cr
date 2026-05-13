module Qt6
  # Wraps `QEasingCurve`.
  class EasingCurve < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(type : EasingCurveType = EasingCurveType::Linear)
      super(LibQt6.qt6cr_easing_curve_create(type.value))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def dup : self
      self.class.wrap(LibQt6.qt6cr_easing_curve_copy(to_unsafe), true)
    end

    def ==(other : EasingCurve) : Bool
      LibQt6.qt6cr_easing_curve_equal(to_unsafe, other.to_unsafe)
    end

    def type : EasingCurveType
      EasingCurveType.from_value(LibQt6.qt6cr_easing_curve_type(to_unsafe))
    end

    def type=(value : EasingCurveType) : EasingCurveType
      LibQt6.qt6cr_easing_curve_set_type(to_unsafe, value.value)
      value
    end

    def amplitude : Float64
      LibQt6.qt6cr_easing_curve_amplitude(to_unsafe)
    end

    def amplitude=(value : Number) : Float64
      real = value.to_f64
      LibQt6.qt6cr_easing_curve_set_amplitude(to_unsafe, real)
      real
    end

    def period : Float64
      LibQt6.qt6cr_easing_curve_period(to_unsafe)
    end

    def period=(value : Number) : Float64
      real = value.to_f64
      LibQt6.qt6cr_easing_curve_set_period(to_unsafe, real)
      real
    end

    def overshoot : Float64
      LibQt6.qt6cr_easing_curve_overshoot(to_unsafe)
    end

    def overshoot=(value : Number) : Float64
      real = value.to_f64
      LibQt6.qt6cr_easing_curve_set_overshoot(to_unsafe, real)
      real
    end

    def value_for_progress(progress : Number) : Float64
      LibQt6.qt6cr_easing_curve_value_for_progress(to_unsafe, progress.to_f64)
    end

    def set_type(value : EasingCurveType) : self
      self.type = value
      self
    end

    def set_amplitude(value : Number) : self
      self.amplitude = value
      self
    end

    def set_period(value : Number) : self
      self.period = value
      self
    end

    def set_overshoot(value : Number) : self
      self.overshoot = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_easing_curve_destroy(to_unsafe)
    end
  end
end
