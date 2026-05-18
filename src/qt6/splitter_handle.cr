module Qt6
  # Wraps `QSplitterHandle`.
  class SplitterHandle < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the handle orientation.
    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_splitter_handle_orientation(to_unsafe))
    end

    # Sets the handle orientation and returns it.
    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_splitter_handle_set_orientation(to_unsafe, value.value)
      value
    end

    # Returns `true` when dragging this handle resizes panes continuously.
    def opaque_resize? : Bool
      LibQt6.qt6cr_splitter_handle_opaque_resize(to_unsafe)
    end

    # Returns the owning splitter.
    def splitter : Splitter?
      handle = LibQt6.qt6cr_splitter_handle_splitter(to_unsafe)
      handle.null? ? nil : Splitter.wrap(handle)
    end

    # Returns the preferred handle size.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_splitter_handle_size_hint(to_unsafe))
    end

    # Qt-style alias for `orientation=`.
    def set_orientation(value : Orientation) : self
      self.orientation = value
      self
    end
  end
end
