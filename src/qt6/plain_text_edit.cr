module Qt6
  # Wraps `QPlainTextEdit`.
  class PlainTextEdit < AbstractScrollArea
    @text_changed : Signal() = Signal().new
    @block_count_changed : Signal(Int32) = Signal(Int32).new
    @modification_changed : Signal(Bool) = Signal(Bool).new
    @cursor_position_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the document text changes.
    getter text_changed : Signal()
    # Signal emitted when the editor block count changes.
    getter block_count_changed : Signal(Int32)
    # Signal emitted when the document modified state changes.
    getter modification_changed : Signal(Bool)
    # Signal emitted when the text cursor position changes.
    getter cursor_position_changed : Signal()

    # Creates a plain-text editor with optional starting text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_plain_text_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @text_changed = Signal().new
      @block_count_changed = Signal(Int32).new
      @modification_changed = Signal(Bool).new
      @cursor_position_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_plain_text_edit_on_text_changed(to_unsafe, TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_plain_text_edit_on_block_count_changed(to_unsafe, BLOCK_COUNT_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_plain_text_edit_on_modification_changed(to_unsafe, MODIFICATION_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_plain_text_edit_on_cursor_position_changed(to_unsafe, CURSOR_POSITION_CHANGED_TRAMPOLINE, @callback_userdata)
      self.plain_text = text unless text.empty?
    end

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @text_changed = Signal().new
      @block_count_changed = Signal(Int32).new
      @modification_changed = Signal(Bool).new
      @cursor_position_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_plain_text_edit_on_text_changed(to_unsafe, TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_plain_text_edit_on_block_count_changed(to_unsafe, BLOCK_COUNT_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_plain_text_edit_on_modification_changed(to_unsafe, MODIFICATION_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_plain_text_edit_on_cursor_position_changed(to_unsafe, CURSOR_POSITION_CHANGED_TRAMPOLINE, @callback_userdata)
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

    # Inserts plain text at the current cursor position.
    def insert_plain_text(value : String) : self
      LibQt6.qt6cr_plain_text_edit_insert_plain_text(to_unsafe, value.to_unsafe)
      self
    end

    # Returns the editor line-wrap mode.
    def line_wrap_mode : PlainTextEditLineWrapMode
      PlainTextEditLineWrapMode.from_value(LibQt6.qt6cr_plain_text_edit_line_wrap_mode(to_unsafe))
    end

    # Sets the editor line-wrap mode and returns it.
    def line_wrap_mode=(value : PlainTextEditLineWrapMode) : PlainTextEditLineWrapMode
      LibQt6.qt6cr_plain_text_edit_set_line_wrap_mode(to_unsafe, value.value)
      value
    end

    # Returns the editor word-wrap policy.
    def word_wrap_mode : TextOptionWrapMode
      TextOptionWrapMode.from_value(LibQt6.qt6cr_plain_text_edit_word_wrap_mode(to_unsafe))
    end

    # Sets the editor word-wrap policy and returns it.
    def word_wrap_mode=(value : TextOptionWrapMode) : TextOptionWrapMode
      LibQt6.qt6cr_plain_text_edit_set_word_wrap_mode(to_unsafe, value.value)
      value
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

    # Returns `true` when pressing Tab moves focus instead of inserting a tab.
    def tab_changes_focus? : Bool
      LibQt6.qt6cr_plain_text_edit_tab_changes_focus(to_unsafe)
    end

    # Enables or disables Tab-to-focus behavior.
    def tab_changes_focus=(value : Bool) : Bool
      LibQt6.qt6cr_plain_text_edit_set_tab_changes_focus(to_unsafe, value)
      value
    end

    # Returns `true` when typed text overwrites existing characters.
    def overwrite_mode? : Bool
      LibQt6.qt6cr_plain_text_edit_overwrite_mode(to_unsafe)
    end

    # Enables or disables overwrite mode.
    def overwrite_mode=(value : Bool) : Bool
      LibQt6.qt6cr_plain_text_edit_set_overwrite_mode(to_unsafe, value)
      value
    end

    # Returns the tab stop distance in device-independent pixels.
    def tab_stop_distance : Float64
      LibQt6.qt6cr_plain_text_edit_tab_stop_distance(to_unsafe)
    end

    # Sets the tab stop distance and returns it.
    def tab_stop_distance=(value : Number) : Float64
      LibQt6.qt6cr_plain_text_edit_set_tab_stop_distance(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Returns `true` when the editor background is painted even beyond the document end.
    def background_visible? : Bool
      LibQt6.qt6cr_plain_text_edit_background_visible(to_unsafe)
    end

    # Enables or disables background painting beyond the document end.
    def background_visible=(value : Bool) : Bool
      LibQt6.qt6cr_plain_text_edit_set_background_visible(to_unsafe, value)
      value
    end

    # Returns `true` when scrolling keeps the cursor centered where possible.
    def center_on_scroll? : Bool
      LibQt6.qt6cr_plain_text_edit_center_on_scroll(to_unsafe)
    end

    # Enables or disables center-on-scroll behavior.
    def center_on_scroll=(value : Bool) : Bool
      LibQt6.qt6cr_plain_text_edit_set_center_on_scroll(to_unsafe, value)
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

    # Returns the plain-text layout backing the current document.
    def document_layout : PlainTextDocumentLayout
      document.document_layout.not_nil!
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

    # Returns the current document block count as reported by the editor.
    def block_count : Int32
      LibQt6.qt6cr_plain_text_edit_block_count(to_unsafe)
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

    # Qt-style alias for `plain_text=`.
    def set_plain_text(value : String) : self
      self.plain_text = value
      self
    end

    # Qt-style alias for `line_wrap_mode=`.
    def set_line_wrap_mode(value : PlainTextEditLineWrapMode) : self
      self.line_wrap_mode = value
      self
    end

    # Qt-style alias for `word_wrap_mode=`.
    def set_word_wrap_mode(value : TextOptionWrapMode) : self
      self.word_wrap_mode = value
      self
    end

    # Qt-style alias for `read_only=`.
    def set_read_only(value : Bool) : self
      self.read_only = value
      self
    end

    # Qt-style alias for `undo_redo_enabled=`.
    def set_undo_redo_enabled(value : Bool) : self
      self.undo_redo_enabled = value
      self
    end

    # Qt-style alias for `placeholder_text=`.
    def set_placeholder_text(value : String) : self
      self.placeholder_text = value
      self
    end

    # Qt-style alias for `tab_changes_focus=`.
    def set_tab_changes_focus(value : Bool) : self
      self.tab_changes_focus = value
      self
    end

    # Qt-style alias for `overwrite_mode=`.
    def set_overwrite_mode(value : Bool) : self
      self.overwrite_mode = value
      self
    end

    # Qt-style alias for `tab_stop_distance=`.
    def set_tab_stop_distance(value : Number) : self
      self.tab_stop_distance = value
      self
    end

    # Qt-style alias for `background_visible=`.
    def set_background_visible(value : Bool) : self
      self.background_visible = value
      self
    end

    # Qt-style alias for `center_on_scroll=`.
    def set_center_on_scroll(value : Bool) : self
      self.center_on_scroll = value
      self
    end

    # Registers a block to run when the editor block count changes.
    def on_block_count_changed(&block : Int32 ->) : self
      @block_count_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the document modified state changes.
    def on_modification_changed(&block : Bool ->) : self
      @modification_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the text cursor position changes.
    def on_cursor_position_changed(&block : ->) : self
      @cursor_position_changed.connect { block.call }
      self
    end

    # Registers a block to run when the text changes.
    def on_text_changed(&block : ->) : self
      @text_changed.connect { block.call }
      self
    end

    protected def emit_block_count_changed(value : Int32) : Nil
      @block_count_changed.emit(value)
    end

    protected def emit_modification_changed(value : Bool) : Nil
      @modification_changed.emit(value)
    end

    protected def emit_cursor_position_changed : Nil
      @cursor_position_changed.emit
    end

    protected def emit_text_changed : Nil
      @text_changed.emit
    end

    private BLOCK_COUNT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(PlainTextEdit).unbox(userdata).emit_block_count_changed(value)
    end

    private MODIFICATION_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(PlainTextEdit).unbox(userdata).emit_modification_changed(value)
    end

    private CURSOR_POSITION_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(PlainTextEdit).unbox(userdata).emit_cursor_position_changed
    end

    private TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(PlainTextEdit).unbox(userdata).emit_text_changed
    end
  end
end
