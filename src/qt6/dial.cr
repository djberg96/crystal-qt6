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

    def notches_visible? : Bool
      LibQt6.qt6cr_dial_notches_visible(to_unsafe)
    end

    def notches_visible=(value : Bool) : Bool
      LibQt6.qt6cr_dial_set_notches_visible(to_unsafe, value)
      value
    end
  end
end
