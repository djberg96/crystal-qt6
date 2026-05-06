module Qt6
  # Wraps `QDial`.
  class Dial < AbstractSlider
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_dial_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def wrapping? : Bool
      LibQt6.qt6cr_dial_wrapping(to_unsafe)
    end

    def wrapping=(value : Bool) : Bool
      LibQt6.qt6cr_dial_set_wrapping(to_unsafe, value)
      value
    end

    # Returns the effective pixel spacing between visible notches.
    def notch_size : Int32
      LibQt6.qt6cr_dial_notch_size(to_unsafe)
    end

    # Returns the target pixel spacing Qt uses when calculating notch layout.
    def notch_target : Float64
      LibQt6.qt6cr_dial_notch_target(to_unsafe)
    end

    # Sets the target pixel spacing Qt uses when calculating notch layout.
    def notch_target=(value : Number) : Float64
      float_value = value.to_f64
      LibQt6.qt6cr_dial_set_notch_target(to_unsafe, float_value)
      float_value
    end

    def notches_visible? : Bool
      LibQt6.qt6cr_dial_notches_visible(to_unsafe)
    end

    def notches_visible=(value : Bool) : Bool
      LibQt6.qt6cr_dial_set_notches_visible(to_unsafe, value)
      value
    end
  end
end
