module Qt6
  # Wraps `QScrollBar`.
  class ScrollBar < AbstractSlider
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(orientation : Orientation = Orientation::Vertical, parent : Widget? = nil)
      super(LibQt6.qt6cr_scroll_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null, orientation.value), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end
  end
end
