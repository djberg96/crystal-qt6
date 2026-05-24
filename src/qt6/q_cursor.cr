module Qt6
  # Wraps `QCursor` for widget and painter cursor state.
  class QCursor < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a cursor with the given shape.
    def initialize(shape : CursorShape = CursorShape::Arrow)
      super(LibQt6.qt6cr_qcursor_create(shape.value))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the cursor shape.
    def shape : CursorShape
      CursorShape.from_value(LibQt6.qt6cr_qcursor_shape(to_unsafe))
    end

    # Sets the cursor shape.
    def shape=(value : CursorShape) : CursorShape
      LibQt6.qt6cr_qcursor_set_shape(to_unsafe, value.value)
      value
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qcursor_destroy(to_unsafe)
    end
  end
end
