module Qt6
  # Wraps `QDoubleValidator`.
  class DoubleValidator < Validator
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(bottom : Float = -1_000_000_000.0, top : Float = 1_000_000_000.0, decimals : Int = 2, parent : QObject? = nil)
      super(LibQt6.qt6cr_double_validator_create(parent.try(&.to_unsafe) || Pointer(Void).null, bottom.to_f64, top.to_f64, decimals.to_i32), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def bottom : Float64
      LibQt6.qt6cr_double_validator_bottom(to_unsafe)
    end

    def bottom=(value : Float) : Float64
      float_value = value.to_f64
      LibQt6.qt6cr_double_validator_set_bottom(to_unsafe, float_value)
      float_value
    end

    def top : Float64
      LibQt6.qt6cr_double_validator_top(to_unsafe)
    end

    def top=(value : Float) : Float64
      float_value = value.to_f64
      LibQt6.qt6cr_double_validator_set_top(to_unsafe, float_value)
      float_value
    end

    def decimals : Int32
      LibQt6.qt6cr_double_validator_decimals(to_unsafe)
    end

    def decimals=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_double_validator_set_decimals(to_unsafe, int_value)
      int_value
    end

    def set_range(bottom : Float, top : Float, decimals : Int = self.decimals) : Tuple(Float64, Float64, Int32)
      min_value = bottom.to_f64
      max_value = top.to_f64
      decimals_value = decimals.to_i32
      LibQt6.qt6cr_double_validator_set_range(to_unsafe, min_value, max_value, decimals_value)
      {min_value, max_value, decimals_value}
    end
  end
end
