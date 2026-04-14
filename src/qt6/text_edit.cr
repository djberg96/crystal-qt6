module Qt6
  # Wraps `QTextEdit`.
  class TextEdit < Frame
    @text_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the document text changes.
    getter text_changed : Signal()

    # Creates a text edit with optional starting plain text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_text_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @text_changed = Signal().new
      @callback_userdata = Box.box(self.as(TextEdit))
      LibQt6.qt6cr_text_edit_on_text_changed(to_unsafe, TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
      self.plain_text = text unless text.empty?
    end

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @text_changed = Signal().new
      @callback_userdata = Box.box(self.as(TextEdit))
      LibQt6.qt6cr_text_edit_on_text_changed(to_unsafe, TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the current HTML content.
    def html : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_edit_html(to_unsafe))
    end

    # Sets the current HTML content and returns it.
    def html=(value : String) : String
      LibQt6.qt6cr_text_edit_set_html(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current plain-text content.
    def plain_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_edit_plain_text(to_unsafe))
    end

    # Sets the current plain-text content and returns it.
    def plain_text=(value : String) : String
      LibQt6.qt6cr_text_edit_set_plain_text(to_unsafe, value.to_unsafe)
      value
    end

    # Appends a new paragraph of text to the editor.
    def append(value : String) : self
      LibQt6.qt6cr_text_edit_append(to_unsafe, value.to_unsafe)
      self
    end

    # Returns `true` when editing is disabled.
    def read_only? : Bool
      LibQt6.qt6cr_text_edit_is_read_only(to_unsafe)
    end

    # Enables or disables read-only mode.
    def read_only=(value : Bool) : Bool
      LibQt6.qt6cr_text_edit_set_read_only(to_unsafe, value)
      value
    end

    # Returns `true` when pasted or typed rich text is accepted.
    def accept_rich_text? : Bool
      LibQt6.qt6cr_text_edit_accept_rich_text(to_unsafe)
    end

    # Enables or disables accepting rich text.
    def accept_rich_text=(value : Bool) : Bool
      LibQt6.qt6cr_text_edit_set_accept_rich_text(to_unsafe, value)
      value
    end

    # Returns `true` when undo and redo are enabled.
    def undo_redo_enabled? : Bool
      LibQt6.qt6cr_text_edit_undo_redo_enabled(to_unsafe)
    end

    # Enables or disables undo and redo support.
    def undo_redo_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_text_edit_set_undo_redo_enabled(to_unsafe, value)
      value
    end

    # Returns the placeholder text shown when empty.
    def placeholder_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_edit_placeholder_text(to_unsafe))
    end

    # Sets the placeholder text and returns it.
    def placeholder_text=(value : String) : String
      LibQt6.qt6cr_text_edit_set_placeholder_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current backing document.
    def document : TextDocument
      TextDocument.wrap(LibQt6.qt6cr_text_edit_document(to_unsafe))
    end

    # Assigns the backing document and returns it.
    def document=(value : TextDocument) : TextDocument
      LibQt6.qt6cr_text_edit_set_document(to_unsafe, value.to_unsafe)
      value
    end

    # Returns a copy of the current text cursor.
    def text_cursor : TextCursor
      TextCursor.wrap(LibQt6.qt6cr_text_edit_text_cursor(to_unsafe), true)
    end

    # Assigns the current text cursor and returns it.
    def text_cursor=(value : TextCursor) : TextCursor
      LibQt6.qt6cr_text_edit_set_text_cursor(to_unsafe, value.to_unsafe)
      value
    end

    # Clears the editor contents.
    def clear : self
      LibQt6.qt6cr_text_edit_clear(to_unsafe)
      self
    end

    # Registers a block to run when the text changes.
    def on_text_changed(&block : ->) : self
      @text_changed.connect { block.call }
      self
    end

    protected def emit_text_changed : Nil
      @text_changed.emit
    end

    private TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(TextEdit).unbox(userdata).emit_text_changed
    end
  end
end
