module Qt6
  # Wraps a `QTextCursor`.
  class TextCursor < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a text cursor, optionally attached to a document.
    def initialize(document : TextDocument? = nil)
      super(LibQt6.qt6cr_text_cursor_create(document.try(&.to_unsafe) || Pointer(Void).null))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` when the cursor does not point at a valid document position.
    def null? : Bool
      LibQt6.qt6cr_text_cursor_is_null(to_unsafe)
    end

    # Returns the current character position.
    def position : Int32
      LibQt6.qt6cr_text_cursor_position(to_unsafe)
    end

    # Moves the cursor to an absolute character position.
    def position=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_text_cursor_set_position(to_unsafe, int_value, false)
      int_value
    end

    # Moves the cursor to an absolute character position and optionally keeps
    # the current anchor to extend the selection.
    def set_position(value : Int, keep_anchor : Bool = false) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_text_cursor_set_position(to_unsafe, int_value, keep_anchor)
      int_value
    end

    # Moves the cursor using Qt's cursor-navigation operations.
    def move_position(operation : TextCursorMoveOperation, mode : TextCursorMoveMode = TextCursorMoveMode::MoveAnchor, count : Int = 1) : Bool
      LibQt6.qt6cr_text_cursor_move_position(to_unsafe, operation.value, mode.value, count.to_i32)
    end

    # Inserts text at the current cursor position.
    def insert_text(value : String) : String
      LibQt6.qt6cr_text_cursor_insert_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the selected text, if any.
    def selected_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_cursor_selected_text(to_unsafe))
    end

    # Returns `true` when the cursor currently spans a selection.
    def has_selection? : Bool
      LibQt6.qt6cr_text_cursor_has_selection(to_unsafe)
    end

    # Returns the current selection start position.
    def selection_start : Int32
      LibQt6.qt6cr_text_cursor_selection_start(to_unsafe)
    end

    # Returns the current selection end position.
    def selection_end : Int32
      LibQt6.qt6cr_text_cursor_selection_end(to_unsafe)
    end

    # Clears the current selection while keeping the cursor position.
    def clear_selection : self
      LibQt6.qt6cr_text_cursor_clear_selection(to_unsafe)
      self
    end

    # Removes the selected text without moving the cursor out of the document.
    def remove_selected_text : self
      LibQt6.qt6cr_text_cursor_remove_selected_text(to_unsafe)
      self
    end

    # Replaces the selected text with the provided string.
    def replace_selected_text(value : String) : self
      remove_selected_text
      insert_text(value)
      self
    end

    # Deletes the character after the cursor.
    def delete_char : self
      LibQt6.qt6cr_text_cursor_delete_char(to_unsafe)
      self
    end

    # Deletes the character before the cursor.
    def delete_previous_char : self
      LibQt6.qt6cr_text_cursor_delete_previous_char(to_unsafe)
      self
    end

    # Returns `true` when the cursor is at the beginning of the document.
    def at_start? : Bool
      LibQt6.qt6cr_text_cursor_at_start(to_unsafe)
    end

    # Returns `true` when the cursor is at the end of the document.
    def at_end? : Bool
      LibQt6.qt6cr_text_cursor_at_end(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_text_cursor_destroy(to_unsafe)
    end
  end
end
