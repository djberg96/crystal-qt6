module Qt6
  # Wraps `QLineEdit`.
  class LineEdit < Widget
    @text_changed_callbacks = [] of Proc(String, Nil)
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @text_changed_connected = false

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a line edit with optional starting text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_line_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      @text_changed_callbacks = [] of Proc(String, Nil)
      @callback_userdata = Pointer(Void).null
      @text_changed_connected = false
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @text_changed_callbacks = [] of Proc(String, Nil)
      @callback_userdata = Pointer(Void).null
      @text_changed_connected = false
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

    # Returns the placeholder text shown when the line edit is empty.
    def placeholder_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_line_edit_placeholder_text(to_unsafe))
    end

    # Sets the placeholder text and returns the assigned value.
    def placeholder_text=(value : String) : String
      LibQt6.qt6cr_line_edit_set_placeholder_text(to_unsafe, value.to_unsafe)
      value
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

    # Returns the input mask.
    def input_mask : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_line_edit_input_mask(to_unsafe))
    end

    # Sets the input mask.
    def input_mask=(value : String) : String
      LibQt6.qt6cr_line_edit_set_input_mask(to_unsafe, value.to_unsafe)
      value
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

    # Registers a block to run whenever the text changes.
    def on_text_changed(&block : String ->) : self
      ensure_text_changed_connection
      @text_changed_callbacks << block
      self
    end

    protected def emit_text_changed(value : UInt8*) : Nil
      text = Qt6.copy_string(value)
      @text_changed_callbacks.each { |callback| callback.call(text) }
    end

    private TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(LineEdit).unbox(userdata).emit_text_changed(value)
    end

    private def ensure_text_changed_connection : Nil
      return if @text_changed_connected

      @callback_userdata = Box.box(self) if @callback_userdata.null?
      LibQt6.qt6cr_line_edit_on_text_changed(to_unsafe, TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
      @text_changed_connected = true
    end
  end
end
