module Qt6
  # Wraps `QTextEdit`.
  class TextEdit < AbstractScrollArea
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

    # Appends a new block of HTML content to the editor.
    def append_html(value : String) : self
      LibQt6.qt6cr_text_edit_append_html(to_unsafe, value.to_unsafe)
      self
    end

    # Inserts plain text at the current cursor position.
    def insert_plain_text(value : String) : self
      LibQt6.qt6cr_text_edit_insert_plain_text(to_unsafe, value.to_unsafe)
      self
    end

    # Inserts HTML at the current cursor position.
    def insert_html(value : String) : self
      LibQt6.qt6cr_text_edit_insert_html(to_unsafe, value.to_unsafe)
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

    # Returns the editor's automatic rich-text formatting flags.
    def auto_formatting : TextEditAutoFormattingFlag
      TextEditAutoFormattingFlag.from_value(LibQt6.qt6cr_text_edit_auto_formatting(to_unsafe))
    end

    # Sets the editor's automatic rich-text formatting flags and returns them.
    def auto_formatting=(value : TextEditAutoFormattingFlag) : TextEditAutoFormattingFlag
      LibQt6.qt6cr_text_edit_set_auto_formatting(to_unsafe, value.value)
      value
    end

    # Returns `true` when pressing Tab moves focus instead of inserting a tab.
    def tab_changes_focus? : Bool
      LibQt6.qt6cr_text_edit_tab_changes_focus(to_unsafe)
    end

    # Enables or disables Tab-to-focus behavior.
    def tab_changes_focus=(value : Bool) : Bool
      LibQt6.qt6cr_text_edit_set_tab_changes_focus(to_unsafe, value)
      value
    end

    # Returns the document title metadata.
    def document_title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_edit_document_title(to_unsafe))
    end

    # Sets the document title metadata and returns it.
    def document_title=(value : String) : String
      LibQt6.qt6cr_text_edit_set_document_title(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the editor line-wrap mode.
    def line_wrap_mode : TextEditLineWrapMode
      TextEditLineWrapMode.from_value(LibQt6.qt6cr_text_edit_line_wrap_mode(to_unsafe))
    end

    # Sets the editor line-wrap mode and returns it.
    def line_wrap_mode=(value : TextEditLineWrapMode) : TextEditLineWrapMode
      LibQt6.qt6cr_text_edit_set_line_wrap_mode(to_unsafe, value.value)
      value
    end

    # Returns the configured line wrap column or width.
    def line_wrap_column_or_width : Int32
      LibQt6.qt6cr_text_edit_line_wrap_column_or_width(to_unsafe)
    end

    # Sets the configured line wrap column or width and returns it.
    def line_wrap_column_or_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_text_edit_set_line_wrap_column_or_width(to_unsafe, int_value)
      int_value
    end

    # Returns the editor word-wrap policy.
    def word_wrap_mode : TextOptionWrapMode
      TextOptionWrapMode.from_value(LibQt6.qt6cr_text_edit_word_wrap_mode(to_unsafe))
    end

    # Sets the editor word-wrap policy and returns it.
    def word_wrap_mode=(value : TextOptionWrapMode) : TextOptionWrapMode
      LibQt6.qt6cr_text_edit_set_word_wrap_mode(to_unsafe, value.value)
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

    # Returns `true` when typed text overwrites existing characters.
    def overwrite_mode? : Bool
      LibQt6.qt6cr_text_edit_overwrite_mode(to_unsafe)
    end

    # Enables or disables overwrite mode.
    def overwrite_mode=(value : Bool) : Bool
      LibQt6.qt6cr_text_edit_set_overwrite_mode(to_unsafe, value)
      value
    end

    # Returns the tab stop distance in device-independent pixels.
    def tab_stop_distance : Float64
      LibQt6.qt6cr_text_edit_tab_stop_distance(to_unsafe)
    end

    # Sets the tab stop distance and returns it.
    def tab_stop_distance=(value : Number) : Float64
      LibQt6.qt6cr_text_edit_set_tab_stop_distance(to_unsafe, value.to_f64)
      value.to_f64
    end

    # Returns the editor cursor width in pixels.
    def cursor_width : Int32
      LibQt6.qt6cr_text_edit_cursor_width(to_unsafe)
    end

    # Sets the editor cursor width in pixels and returns it.
    def cursor_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_text_edit_set_cursor_width(to_unsafe, int_value)
      int_value
    end

    # Returns the active text interaction flags.
    def text_interaction_flags : TextInteractionFlag
      TextInteractionFlag.from_value(LibQt6.qt6cr_text_edit_text_interaction_flags(to_unsafe))
    end

    # Sets the active text interaction flags and returns them.
    def text_interaction_flags=(value : TextInteractionFlag) : TextInteractionFlag
      LibQt6.qt6cr_text_edit_set_text_interaction_flags(to_unsafe, value.value)
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

    # Returns the current rich-text point size at the cursor.
    def font_point_size : Float64
      LibQt6.qt6cr_text_edit_font_point_size(to_unsafe)
    end

    # Returns the current rich-text font weight at the cursor.
    def font_weight : Int32
      LibQt6.qt6cr_text_edit_font_weight(to_unsafe)
    end

    # Returns `true` when the current rich-text font is underlined.
    def font_underline? : Bool
      LibQt6.qt6cr_text_edit_font_underline(to_unsafe)
    end

    # Returns `true` when the current rich-text font is italic.
    def font_italic? : Bool
      LibQt6.qt6cr_text_edit_font_italic(to_unsafe)
    end

    # Returns the current rich-text foreground color.
    def text_color : Color
      Color.from_native(LibQt6.qt6cr_text_edit_text_color(to_unsafe))
    end

    # Returns the current rich-text background color.
    def text_background_color : Color
      Color.from_native(LibQt6.qt6cr_text_edit_text_background_color(to_unsafe))
    end

    # Returns the current rich-text font at the cursor.
    def current_font : QFont
      QFont.wrap(LibQt6.qt6cr_text_edit_current_font(to_unsafe), true)
    end

    # Returns the current paragraph alignment.
    def alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_text_edit_alignment(to_unsafe))
    end

    # Sets the current rich-text point size and returns it.
    def set_font_point_size(value : Number) : self
      LibQt6.qt6cr_text_edit_set_font_point_size(to_unsafe, value.to_f64)
      self
    end

    # Sets the current rich-text font family and returns `self`.
    def set_font_family(value : String) : self
      LibQt6.qt6cr_text_edit_set_font_family(to_unsafe, value.to_unsafe)
      self
    end

    # Sets the current rich-text font weight and returns `self`.
    def set_font_weight(value : Int) : self
      LibQt6.qt6cr_text_edit_set_font_weight(to_unsafe, value.to_i32)
      self
    end

    # Enables or disables underline for the current rich-text font.
    def set_font_underline(value : Bool) : self
      LibQt6.qt6cr_text_edit_set_font_underline(to_unsafe, value)
      self
    end

    # Enables or disables italic for the current rich-text font.
    def set_font_italic(value : Bool) : self
      LibQt6.qt6cr_text_edit_set_font_italic(to_unsafe, value)
      self
    end

    # Sets the current rich-text foreground color.
    def set_text_color(value : Color) : self
      LibQt6.qt6cr_text_edit_set_text_color(to_unsafe, value.to_native)
      self
    end

    # Sets the current rich-text background color.
    def set_text_background_color(value : Color) : self
      LibQt6.qt6cr_text_edit_set_text_background_color(to_unsafe, value.to_native)
      self
    end

    # Sets the current rich-text font.
    def set_current_font(value : QFont) : self
      LibQt6.qt6cr_text_edit_set_current_font(to_unsafe, value.to_unsafe)
      self
    end

    # Sets the current paragraph alignment and returns it.
    def alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_text_edit_set_alignment(to_unsafe, value.value)
      value
    end

    # Returns the current extra selections applied to the editor.
    def extra_selections : Array(TextEditExtraSelection)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_text_edit_extra_selections(to_unsafe)).map do |handle|
        TextEditExtraSelection.wrap(handle, true)
      end
    end

    # Replaces the current extra selections and returns them.
    def extra_selections=(selections : Enumerable(TextEditExtraSelection)) : Array(TextEditExtraSelection)
      values = selections.to_a
      handles = values.map(&.to_unsafe)
      LibQt6.qt6cr_text_edit_set_extra_selections(
        to_unsafe,
        handles.empty? ? Pointer(Void).null.as(LibQt6::Handle*) : handles.to_unsafe,
        handles.size
      )
      values
    end

    # Clears the editor contents.
    def clear : self
      LibQt6.qt6cr_text_edit_clear(to_unsafe)
      self
    end

    # Returns `true` when the editor has an undo step available.
    def can_undo? : Bool
      LibQt6.qt6cr_text_edit_can_undo(to_unsafe)
    end

    # Returns `true` when the editor has a redo step available.
    def can_redo? : Bool
      LibQt6.qt6cr_text_edit_can_redo(to_unsafe)
    end

    # Returns `true` when clipboard contents can be pasted at the current cursor.
    def can_paste? : Bool
      LibQt6.qt6cr_text_edit_can_paste(to_unsafe)
    end

    # Undoes the last editing step.
    def undo : self
      LibQt6.qt6cr_text_edit_undo(to_unsafe)
      self
    end

    # Redoes the last undone editing step.
    def redo : self
      LibQt6.qt6cr_text_edit_redo(to_unsafe)
      self
    end

    # Selects the entire document contents.
    def select_all : self
      LibQt6.qt6cr_text_edit_select_all(to_unsafe)
      self
    end

    # Copies the current selection to the clipboard.
    def copy : self
      LibQt6.qt6cr_text_edit_copy(to_unsafe)
      self
    end

    # Cuts the current selection to the clipboard.
    def cut : self
      LibQt6.qt6cr_text_edit_cut(to_unsafe)
      self
    end

    # Pastes clipboard contents at the current cursor position.
    def paste : self
      LibQt6.qt6cr_text_edit_paste(to_unsafe)
      self
    end

    # Scrolls the viewport as needed to keep the text cursor visible.
    def ensure_cursor_visible : self
      LibQt6.qt6cr_text_edit_ensure_cursor_visible(to_unsafe)
      self
    end

    # Moves the current text cursor using the given operation and move mode.
    def move_cursor(operation : TextCursorMoveOperation, mode : TextCursorMoveMode = TextCursorMoveMode::MoveAnchor) : self
      LibQt6.qt6cr_text_edit_move_cursor(to_unsafe, operation.value, mode.value)
      self
    end

    # Zooms the document in by the given step count.
    def zoom_in(range : Int = 1) : self
      LibQt6.qt6cr_text_edit_zoom_in(to_unsafe, range.to_i32)
      self
    end

    # Zooms the document out by the given step count.
    def zoom_out(range : Int = 1) : self
      LibQt6.qt6cr_text_edit_zoom_out(to_unsafe, range.to_i32)
      self
    end

    # Qt-style alias for `auto_formatting=`.
    def set_auto_formatting(value : TextEditAutoFormattingFlag) : self
      self.auto_formatting = value
      self
    end

    # Qt-style alias for `tab_changes_focus=`.
    def set_tab_changes_focus(value : Bool) : self
      self.tab_changes_focus = value
      self
    end

    # Qt-style alias for `document_title=`.
    def set_document_title(value : String) : self
      self.document_title = value
      self
    end

    # Qt-style alias for `line_wrap_mode=`.
    def set_line_wrap_mode(value : TextEditLineWrapMode) : self
      self.line_wrap_mode = value
      self
    end

    # Qt-style alias for `line_wrap_column_or_width=`.
    def set_line_wrap_column_or_width(value : Int) : self
      self.line_wrap_column_or_width = value
      self
    end

    # Qt-style alias for `word_wrap_mode=`.
    def set_word_wrap_mode(value : TextOptionWrapMode) : self
      self.word_wrap_mode = value
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

    # Qt-style alias for `cursor_width=`.
    def set_cursor_width(value : Int) : self
      self.cursor_width = value
      self
    end

    # Qt-style alias for `text_interaction_flags=`.
    def set_text_interaction_flags(value : TextInteractionFlag) : self
      self.text_interaction_flags = value
      self
    end

    # Qt-style alias for `alignment=`.
    def set_alignment(value : AlignmentFlag) : self
      self.alignment = value
      self
    end

    # Qt-style alias for `extra_selections=`.
    def set_extra_selections(selections : Enumerable(TextEditExtraSelection)) : self
      self.extra_selections = selections
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
