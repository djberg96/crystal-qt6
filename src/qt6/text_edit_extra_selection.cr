module Qt6
  # Wraps `QTextEdit::ExtraSelection`.
  class TextEditExtraSelection < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(cursor : TextCursor? = nil, format : TextCharFormat? = nil)
      super(LibQt6.qt6cr_text_edit_extra_selection_create(
        cursor.try(&.to_unsafe) || Pointer(Void).null,
        format.try(&.to_unsafe) || Pointer(Void).null
      ))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the selection cursor.
    def cursor : TextCursor
      TextCursor.wrap(LibQt6.qt6cr_text_edit_extra_selection_cursor(to_unsafe), true)
    end

    # Sets the selection cursor and returns it.
    def cursor=(value : TextCursor) : TextCursor
      LibQt6.qt6cr_text_edit_extra_selection_set_cursor(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the selection format.
    def format : TextCharFormat
      TextCharFormat.wrap(LibQt6.qt6cr_text_edit_extra_selection_format(to_unsafe), true)
    end

    # Sets the selection format and returns it.
    def format=(value : TextCharFormat) : TextCharFormat
      LibQt6.qt6cr_text_edit_extra_selection_set_format(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `cursor=`.
    def set_cursor(value : TextCursor) : self
      self.cursor = value
      self
    end

    # Qt-style alias for `format=`.
    def set_format(value : TextCharFormat) : self
      self.format = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_text_edit_extra_selection_destroy(to_unsafe)
    end
  end
end
