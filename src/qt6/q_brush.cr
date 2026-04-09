module Qt6
  # Wraps `QBrush` for fill styling.
  class QBrush < NativeResource
    # Creates a solid-color brush.
    def initialize(color : Color = Color.new(0, 0, 0))
      super(LibQt6.qt6cr_qbrush_create(color.to_native))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the brush color.
    def color : Color
      Color.from_native(LibQt6.qt6cr_qbrush_color(to_unsafe))
    end

    # Sets the brush color.
    def color=(value : Color) : Color
      LibQt6.qt6cr_qbrush_set_color(to_unsafe, value.to_native)
      value
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qbrush_destroy(to_unsafe)
    end
  end
end