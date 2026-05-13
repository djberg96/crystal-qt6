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

    # Returns the preferred size for the scroll bar in its current orientation.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_scroll_bar_size_hint(to_unsafe))
    end

    # Creates the standard scrollbar context menu at the given local position.
    def create_standard_context_menu(position : Point = Point.new(0, 0)) : Menu?
      handle = LibQt6.qt6cr_scroll_bar_create_standard_context_menu(to_unsafe, position.to_native)
      handle.null? ? nil : Menu.wrap(handle, true)
    end

    # Qt-style alias for `value=`.
    def set_value(value : Int) : self
      self.value = value
      self
    end

    # Qt-style alias for `orientation=`.
    def set_orientation(value : Orientation) : self
      self.orientation = value
      self
    end
  end
end
