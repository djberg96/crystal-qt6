module Qt6
  # Wraps `QLineEdit`.
  class LineEdit < Widget
    @text_changed : Signal(String) = Signal(String).new
    @editing_finished : Signal() = Signal().new
    @return_pressed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @text_changed_connected = false
    @editing_finished_connected = false
    @return_pressed_connected = false

    getter text_changed : Signal(String)
    getter editing_finished : Signal()
    getter return_pressed : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a line edit with optional starting text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_line_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      @text_changed = Signal(String).new
      @editing_finished = Signal().new
      @return_pressed = Signal().new
      @callback_userdata = Pointer(Void).null
      @text_changed_connected = false
      @editing_finished_connected = false
      @return_pressed_connected = false
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @text_changed = Signal(String).new
      @editing_finished = Signal().new
      @return_pressed = Signal().new
      @callback_userdata = Pointer(Void).null
      @text_changed_connected = false
      @editing_finished_connected = false
      @return_pressed_connected = false
    end

    # Returns the current line-edit text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_line_edit_text(to_unsafe))
    end

    # Sets the current line-edit text and returns the assigned value.
    def text=(value : String) : String
      LibQt6.qt6cr_line_edit_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for assigning text.
    def set_text(value : String) : self
      self.text = value
      self
    end

    # Returns the currently rendered text, including echo-mode masking.
    def display_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_line_edit_display_text(to_unsafe))
    end

    # Returns the placeholder text shown when the line edit is empty.
    def placeholder_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_line_edit_placeholder_text(to_unsafe))
    end

    # Sets the placeholder text and returns the assigned value.
    def placeholder_text=(value : String) : String
      LibQt6.qt6cr_line_edit_set_placeholder_text(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for assigning placeholder text.
    def set_placeholder_text(value : String) : self
      self.placeholder_text = value
      self
    end

    # Returns the line edit echo mode.
    def echo_mode : EchoMode
      EchoMode.from_value(LibQt6.qt6cr_line_edit_echo_mode(to_unsafe))
    end

    # Sets the line edit echo mode.
    def echo_mode=(value : EchoMode) : EchoMode
      LibQt6.qt6cr_line_edit_set_echo_mode(to_unsafe, value.value)
      value
    end

    # Qt-style alias for assigning echo mode.
    def set_echo_mode(value : EchoMode) : self
      self.echo_mode = value
      self
    end

    # Returns the input mask.
    def input_mask : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_line_edit_input_mask(to_unsafe))
    end

    # Sets the input mask.
    def input_mask=(value : String) : String
      LibQt6.qt6cr_line_edit_set_input_mask(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for assigning the input mask.
    def set_input_mask(value : String) : self
      self.input_mask = value
      self
    end

    # Returns the text alignment flags.
    def alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_line_edit_alignment(to_unsafe))
    end

    # Sets the text alignment flags.
    def alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_line_edit_set_alignment(to_unsafe, value.value)
      value
    end

    # Qt-style alias for assigning alignment flags.
    def set_alignment(value : AlignmentFlag) : self
      self.alignment = value
      self
    end

    # Returns `true` when editing is read-only.
    def read_only? : Bool
      LibQt6.qt6cr_line_edit_is_read_only(to_unsafe)
    end

    # Enables or disables read-only editing.
    def read_only=(value : Bool) : Bool
      LibQt6.qt6cr_line_edit_set_read_only(to_unsafe, value)
      value
    end

    # Qt-style alias for assigning read-only mode.
    def set_read_only(value : Bool) : self
      self.read_only = value
      self
    end

    # Returns `true` when the line edit has been marked modified.
    def modified? : Bool
      LibQt6.qt6cr_line_edit_is_modified(to_unsafe)
    end

    # Marks the line edit as modified or unmodified.
    def modified=(value : Bool) : Bool
      LibQt6.qt6cr_line_edit_set_modified(to_unsafe, value)
      value
    end

    # Qt-style alias for assigning modified state.
    def set_modified(value : Bool) : self
      self.modified = value
      self
    end

    # Returns the maximum text length.
    def max_length : Int32
      LibQt6.qt6cr_line_edit_max_length(to_unsafe)
    end

    # Sets the maximum text length.
    def max_length=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_line_edit_set_max_length(to_unsafe, int_value)
      int_value
    end

    # Qt-style alias for assigning the maximum text length.
    def set_max_length(value : Int) : self
      self.max_length = value
      self
    end

    # Returns `true` when the clear button is enabled.
    def clear_button_enabled? : Bool
      LibQt6.qt6cr_line_edit_clear_button_enabled(to_unsafe)
    end

    # Enables or disables the clear button.
    def clear_button_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_line_edit_set_clear_button_enabled(to_unsafe, value)
      value
    end

    # Qt-style alias for assigning clear-button state.
    def set_clear_button_enabled(value : Bool) : self
      self.clear_button_enabled = value
      self
    end

    # Returns `true` when dragging selected text is enabled.
    def drag_enabled? : Bool
      LibQt6.qt6cr_line_edit_drag_enabled(to_unsafe)
    end

    # Enables or disables dragging selected text.
    def drag_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_line_edit_set_drag_enabled(to_unsafe, value)
      value
    end

    # Qt-style alias for assigning drag-enabled state.
    def set_drag_enabled(value : Bool) : self
      self.drag_enabled = value
      self
    end

    # Returns the current cursor position.
    def cursor_position : Int32
      LibQt6.qt6cr_line_edit_cursor_position(to_unsafe)
    end

    # Sets the current cursor position.
    def cursor_position=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_line_edit_set_cursor_position(to_unsafe, int_value)
      int_value
    end

    # Qt-style alias for assigning the cursor position.
    def set_cursor_position(value : Int) : self
      self.cursor_position = value
      self
    end

    # Returns the current selected text.
    def selected_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_line_edit_selected_text(to_unsafe))
    end

    # Returns `true` when there is an active selection.
    def has_selected_text? : Bool
      LibQt6.qt6cr_line_edit_has_selected_text(to_unsafe)
    end

    # Returns the selection start position, or `-1`.
    def selection_start : Int32
      LibQt6.qt6cr_line_edit_selection_start(to_unsafe)
    end

    # Selects all text.
    def select_all : self
      LibQt6.qt6cr_line_edit_select_all(to_unsafe)
      self
    end

    # Clears the current selection.
    def clear_selection : self
      LibQt6.qt6cr_line_edit_clear_selection(to_unsafe)
      self
    end

    # Selects a span of text.
    def set_selection(start : Int, length : Int) : self
      LibQt6.qt6cr_line_edit_set_selection(to_unsafe, start.to_i32, length.to_i32)
      self
    end

    # Clears the current text.
    def clear : self
      LibQt6.qt6cr_line_edit_clear(to_unsafe)
      self
    end

    # Returns the attached validator, if any.
    def validator : Validator?
      handle = LibQt6.qt6cr_line_edit_validator(to_unsafe)
      handle.null? ? nil : Validator.wrap(handle)
    end

    # Sets the attached validator.
    def validator=(value : Validator) : Validator
      LibQt6.qt6cr_line_edit_set_validator(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the attached completer, if any.
    def completer : Completer?
      handle = LibQt6.qt6cr_line_edit_completer(to_unsafe)
      handle.null? ? nil : Completer.wrap(handle)
    end

    # Sets the attached completer.
    def completer=(value : Completer) : Completer
      LibQt6.qt6cr_line_edit_set_completer(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the current text satisfies the validator and mask.
    def acceptable_input? : Bool
      LibQt6.qt6cr_line_edit_has_acceptable_input(to_unsafe)
    end

    # Registers a block to run whenever the text changes.
    def on_text_changed(&block : String ->) : self
      ensure_text_changed_connection
      @text_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when editing finishes.
    def on_editing_finished(&block : ->) : self
      ensure_editing_finished_connection
      @editing_finished.connect { block.call }
      self
    end

    # Registers a block to run when Return is pressed.
    def on_return_pressed(&block : ->) : self
      ensure_return_pressed_connection
      @return_pressed.connect { block.call }
      self
    end

    protected def emit_text_changed(value : UInt8*) : Nil
      @text_changed.emit(Qt6.copy_string(value))
    end

    protected def emit_editing_finished : Nil
      @editing_finished.emit
    end

    protected def emit_return_pressed : Nil
      @return_pressed.emit
    end

    private TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(LineEdit).unbox(userdata).emit_text_changed(value)
    end

    private EDITING_FINISHED_TRAMPOLINE = ->(userdata : Void*) do
      Box(LineEdit).unbox(userdata).emit_editing_finished
    end

    private RETURN_PRESSED_TRAMPOLINE = ->(userdata : Void*) do
      Box(LineEdit).unbox(userdata).emit_return_pressed
    end

    private def ensure_callback_userdata : Nil
      @callback_userdata = Box.box(self) if @callback_userdata.null?
    end

    private def ensure_text_changed_connection : Nil
      return if @text_changed_connected

      ensure_callback_userdata
      LibQt6.qt6cr_line_edit_on_text_changed(to_unsafe, TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
      @text_changed_connected = true
    end

    private def ensure_editing_finished_connection : Nil
      return if @editing_finished_connected

      ensure_callback_userdata
      LibQt6.qt6cr_line_edit_on_editing_finished(to_unsafe, EDITING_FINISHED_TRAMPOLINE, @callback_userdata)
      @editing_finished_connected = true
    end

    private def ensure_return_pressed_connection : Nil
      return if @return_pressed_connected

      ensure_callback_userdata
      LibQt6.qt6cr_line_edit_on_return_pressed(to_unsafe, RETURN_PRESSED_TRAMPOLINE, @callback_userdata)
      @return_pressed_connected = true
    end
  end
end
