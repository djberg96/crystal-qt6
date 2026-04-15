module Qt6
  # Wraps `QPlainTextEdit`.
  class PlainTextEdit < AbstractScrollArea
    @text_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the document text changes.
    getter text_changed : Signal()

    # Creates a plain-text editor with optional starting text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_plain_text_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @text_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_plain_text_edit_on_text_changed(to_unsafe, TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
      self.plain_text = text unless text.empty?
    end

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @text_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_plain_text_edit_on_text_changed(to_unsafe, TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the current plain-text content.
    def plain_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_plain_text_edit_plain_text(to_unsafe))
    end

    # Sets the current plain-text content and returns it.
    def plain_text=(value : String) : String
      LibQt6.qt6cr_plain_text_edit_set_plain_text(to_unsafe, value.to_unsafe)
      value
    end

    # Appends a new plain-text paragraph.
    def append_plain_text(value : String) : self
      LibQt6.qt6cr_plain_text_edit_append_plain_text(to_unsafe, value.to_unsafe)
      self
    end

    # Returns `true` when editing is disabled.
    def read_only? : Bool
      LibQt6.qt6cr_plain_text_edit_is_read_only(to_unsafe)
    end

    # Enables or disables read-only mode.
    def read_only=(value : Bool) : Bool
      LibQt6.qt6cr_plain_text_edit_set_read_only(to_unsafe, value)
      value
    end

    # Returns `true` when undo and redo are enabled.
    def undo_redo_enabled? : Bool
      LibQt6.qt6cr_plain_text_edit_undo_redo_enabled(to_unsafe)
    end

    # Enables or disables undo and redo support.
    def undo_redo_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_plain_text_edit_set_undo_redo_enabled(to_unsafe, value)
      value
    end

    # Returns the placeholder text shown when empty.
    def placeholder_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_plain_text_edit_placeholder_text(to_unsafe))
    end

    # Sets the placeholder text and returns it.
    def placeholder_text=(value : String) : String
      LibQt6.qt6cr_plain_text_edit_set_placeholder_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current backing document.
    def document : TextDocument
      TextDocument.wrap(LibQt6.qt6cr_plain_text_edit_document(to_unsafe))
    end

    # Assigns the backing document and returns it.
    def document=(value : TextDocument) : TextDocument
      LibQt6.qt6cr_plain_text_edit_set_document(to_unsafe, value.to_unsafe)
      value
    end

    # Returns a copy of the current text cursor.
    def text_cursor : TextCursor
      TextCursor.wrap(LibQt6.qt6cr_plain_text_edit_text_cursor(to_unsafe), true)
    end

    # Assigns the current text cursor and returns it.
    def text_cursor=(value : TextCursor) : TextCursor
      LibQt6.qt6cr_plain_text_edit_set_text_cursor(to_unsafe, value.to_unsafe)
      value
    end

    # Clears the editor contents.
    def clear : self
      LibQt6.qt6cr_plain_text_edit_clear(to_unsafe)
      self
    end

    # Returns `true` when the editor has an undo step available.
    def can_undo? : Bool
      LibQt6.qt6cr_plain_text_edit_can_undo(to_unsafe)
    end

    # Returns `true` when the editor has a redo step available.
    def can_redo? : Bool
      LibQt6.qt6cr_plain_text_edit_can_redo(to_unsafe)
    end

    # Undoes the last editing step.
    def undo : self
      LibQt6.qt6cr_plain_text_edit_undo(to_unsafe)
      self
    end

    # Redoes the last undone editing step.
    def redo : self
      LibQt6.qt6cr_plain_text_edit_redo(to_unsafe)
      self
    end

    # Selects the entire document contents.
    def select_all : self
      LibQt6.qt6cr_plain_text_edit_select_all(to_unsafe)
      self
    end

    # Copies the current selection to the clipboard.
    def copy : self
      LibQt6.qt6cr_plain_text_edit_copy(to_unsafe)
      self
    end

    # Cuts the current selection to the clipboard.
    def cut : self
      LibQt6.qt6cr_plain_text_edit_cut(to_unsafe)
      self
    end

    # Pastes clipboard contents at the current cursor position.
    def paste : self
      LibQt6.qt6cr_plain_text_edit_paste(to_unsafe)
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
      Box(PlainTextEdit).unbox(userdata).emit_text_changed
    end
  end
end
