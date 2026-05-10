module Qt6
  # Wraps `QInputDialog`.
  class InputDialog < Dialog
    @text_value_changed : Signal(String) = Signal(String).new
    @text_value_selected : Signal(String) = Signal(String).new
    @int_value_changed : Signal(Int32) = Signal(Int32).new
    @int_value_selected : Signal(Int32) = Signal(Int32).new
    @double_value_changed : Signal(Float64) = Signal(Float64).new
    @double_value_selected : Signal(Float64) = Signal(Float64).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter text_value_changed : Signal(String)
    getter text_value_selected : Signal(String)
    getter int_value_changed : Signal(Int32)
    getter int_value_selected : Signal(Int32)
    getter double_value_changed : Signal(Float64)
    getter double_value_selected : Signal(Float64)

    # Creates an input dialog with an optional parent widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_input_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    # Returns the current input mode.
    def input_mode : InputDialogInputMode
      InputDialogInputMode.from_value(LibQt6.qt6cr_input_dialog_input_mode(to_unsafe))
    end

    # Sets the input mode and returns it.
    def input_mode=(value : InputDialogInputMode) : InputDialogInputMode
      LibQt6.qt6cr_input_dialog_set_input_mode(to_unsafe, value.value)
      value
    end

    # Returns the enabled input-dialog options.
    def options : InputDialogOption
      InputDialogOption.from_value(LibQt6.qt6cr_input_dialog_options(to_unsafe))
    end

    # Sets the enabled input-dialog options.
    def options=(value : InputDialogOption) : InputDialogOption
      LibQt6.qt6cr_input_dialog_set_options(to_unsafe, value.value)
      value
    end

    # Returns `true` when the option is enabled.
    def option?(option : InputDialogOption) : Bool
      LibQt6.qt6cr_input_dialog_test_option(to_unsafe, option.value)
    end

    # Enables or disables an option and returns `self`.
    def set_option(option : InputDialogOption, value : Bool = true) : self
      LibQt6.qt6cr_input_dialog_set_option(to_unsafe, option.value, value)
      self
    end

    # Clears an option and returns `self`.
    def clear_option(option : InputDialogOption) : self
      set_option(option, false)
    end

    # Returns the label text shown above the input widget.
    def label_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_input_dialog_label_text(to_unsafe))
    end

    # Sets the label text shown above the input widget.
    def label_text=(value : String) : String
      LibQt6.qt6cr_input_dialog_set_label_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the OK button text.
    def ok_button_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_input_dialog_ok_button_text(to_unsafe))
    end

    # Sets the OK button text.
    def ok_button_text=(value : String) : String
      LibQt6.qt6cr_input_dialog_set_ok_button_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the Cancel button text.
    def cancel_button_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_input_dialog_cancel_button_text(to_unsafe))
    end

    # Sets the Cancel button text.
    def cancel_button_text=(value : String) : String
      LibQt6.qt6cr_input_dialog_set_cancel_button_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the text echo mode used for text input.
    def text_echo_mode : EchoMode
      EchoMode.from_value(LibQt6.qt6cr_input_dialog_text_echo_mode(to_unsafe))
    end

    # Sets the text echo mode used for text input.
    def text_echo_mode=(value : EchoMode) : EchoMode
      LibQt6.qt6cr_input_dialog_set_text_echo_mode(to_unsafe, value.value)
      value
    end

    # Returns the current text value.
    def text_value : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_input_dialog_text_value(to_unsafe))
    end

    # Sets the current text value.
    def text_value=(value : String) : String
      LibQt6.qt6cr_input_dialog_set_text_value(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current integer value.
    def int_value : Int32
      LibQt6.qt6cr_input_dialog_int_value(to_unsafe)
    end

    # Sets the current integer value.
    def int_value=(value : Int) : Int32
      LibQt6.qt6cr_input_dialog_set_int_value(to_unsafe, value)
      value.to_i32
    end

    # Sets the allowed integer range.
    def int_range=(value : Range(Int32, Int32)) : Range(Int32, Int32)
      LibQt6.qt6cr_input_dialog_set_int_range(to_unsafe, value.begin, value.end)
      value
    end

    # Returns the minimum allowed integer value.
    def int_minimum : Int32
      LibQt6.qt6cr_input_dialog_int_minimum(to_unsafe)
    end

    # Returns the maximum allowed integer value.
    def int_maximum : Int32
      LibQt6.qt6cr_input_dialog_int_maximum(to_unsafe)
    end

    # Returns the integer step size.
    def int_step : Int32
      LibQt6.qt6cr_input_dialog_int_step(to_unsafe)
    end

    # Sets the integer step size.
    def int_step=(value : Int) : Int32
      LibQt6.qt6cr_input_dialog_set_int_step(to_unsafe, value)
      value.to_i32
    end

    # Returns the current floating-point value.
    def double_value : Float64
      LibQt6.qt6cr_input_dialog_double_value(to_unsafe)
    end

    # Sets the current floating-point value.
    def double_value=(value : Float) : Float64
      LibQt6.qt6cr_input_dialog_set_double_value(to_unsafe, value)
      value.to_f64
    end

    # Sets the allowed floating-point range.
    def double_range=(value : Range(Float64, Float64)) : Range(Float64, Float64)
      LibQt6.qt6cr_input_dialog_set_double_range(to_unsafe, value.begin, value.end)
      value
    end

    # Returns the minimum allowed floating-point value.
    def double_minimum : Float64
      LibQt6.qt6cr_input_dialog_double_minimum(to_unsafe)
    end

    # Returns the maximum allowed floating-point value.
    def double_maximum : Float64
      LibQt6.qt6cr_input_dialog_double_maximum(to_unsafe)
    end

    # Returns the number of decimals shown for floating-point input.
    def double_decimals : Int32
      LibQt6.qt6cr_input_dialog_double_decimals(to_unsafe)
    end

    # Sets the number of decimals shown for floating-point input.
    def double_decimals=(value : Int) : Int32
      LibQt6.qt6cr_input_dialog_set_double_decimals(to_unsafe, value)
      value.to_i32
    end

    # Returns the combo-box items used by item-selection dialogs.
    def combo_box_items : Array(String)
      count = LibQt6.qt6cr_input_dialog_combo_box_item_count(to_unsafe)
      Array(String).new(count) do |index|
        Qt6.copy_and_release_string(LibQt6.qt6cr_input_dialog_combo_box_item_text(to_unsafe, index))
      end
    end

    # Sets the combo-box items used by item-selection dialogs.
    def combo_box_items=(items : Enumerable(String)) : Array(String)
      values = items.to_a
      pointers = values.map(&.to_unsafe)
      LibQt6.qt6cr_input_dialog_set_combo_box_items(to_unsafe, pointers.to_unsafe, pointers.size)
      values
    end

    # Returns whether the combo box allows arbitrary text entry.
    def combo_box_editable? : Bool
      LibQt6.qt6cr_input_dialog_combo_box_editable(to_unsafe)
    end

    # Sets whether the combo box allows arbitrary text entry.
    def combo_box_editable=(value : Bool) : Bool
      LibQt6.qt6cr_input_dialog_set_combo_box_editable(to_unsafe, value)
      value
    end

    # Registers a block to run when the text value changes.
    def on_text_value_changed(&block : String ->) : self
      @text_value_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the text value is selected.
    def on_text_value_selected(&block : String ->) : self
      @text_value_selected.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the integer value changes.
    def on_int_value_changed(&block : Int32 ->) : self
      @int_value_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the integer value is selected.
    def on_int_value_selected(&block : Int32 ->) : self
      @int_value_selected.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the floating-point value changes.
    def on_double_value_changed(&block : Float64 ->) : self
      @double_value_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the floating-point value is selected.
    def on_double_value_selected(&block : Float64 ->) : self
      @double_value_selected.connect { |value| block.call(value) }
      self
    end

    # Shows a modal text-input dialog and returns the entered value, or `nil`
    # if the dialog is canceled.
    def self.get_text(parent : Widget? = nil, *, title : String, label : String, value : String = "", echo_mode : EchoMode = EchoMode::Normal, options : InputDialogOption = InputDialogOption::None) : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
      dialog.options = options unless options.none?
      dialog.label_text = label
      dialog.text_echo_mode = echo_mode
      dialog.text_value = value
      begin
        dialog.exec == DialogCode::Accepted ? dialog.text_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal text-input dialog, yields it for customization, and returns
    # the entered value, or `nil` if the dialog is canceled.
    def self.get_text(parent : Widget? = nil, *, title : String, label : String, value : String = "", echo_mode : EchoMode = EchoMode::Normal, options : InputDialogOption = InputDialogOption::None, &block : InputDialog ->) : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
      dialog.options = options unless options.none?
      dialog.label_text = label
      dialog.text_echo_mode = echo_mode
      dialog.text_value = value
      begin
        yield dialog
        dialog.exec == DialogCode::Accepted ? dialog.text_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal multiline text-input dialog and returns the entered value,
    # or `nil` if the dialog is canceled.
    def self.get_multi_line_text(parent : Widget? = nil, *, title : String, label : String, value : String = "", options : InputDialogOption = InputDialogOption::None) : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
      dialog.options = options | InputDialogOption::UsePlainTextEditForTextInput
      dialog.label_text = label
      dialog.text_value = value
      begin
        dialog.exec == DialogCode::Accepted ? dialog.text_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal multiline text-input dialog, yields it for customization,
    # and returns the entered value, or `nil` if the dialog is canceled.
    def self.get_multi_line_text(parent : Widget? = nil, *, title : String, label : String, value : String = "", options : InputDialogOption = InputDialogOption::None, &block : InputDialog ->) : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
      dialog.options = options | InputDialogOption::UsePlainTextEditForTextInput
      dialog.label_text = label
      dialog.text_value = value
      begin
        yield dialog
        dialog.exec == DialogCode::Accepted ? dialog.text_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal integer-input dialog and returns the selected value, or
    # `nil` if the dialog is canceled.
    def self.get_int(parent : Widget? = nil, *, title : String, label : String, value : Int = 0, minimum : Int = 0, maximum : Int = 99, step : Int? = nil, options : InputDialogOption = InputDialogOption::None) : Int32?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Int
      dialog.options = options unless options.none?
      dialog.label_text = label
      dialog.int_range = minimum.to_i32..maximum.to_i32
      dialog.int_step = step.not_nil! if step
      dialog.int_value = value
      begin
        dialog.exec == DialogCode::Accepted ? dialog.int_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal integer-input dialog, yields it for customization, and
    # returns the selected value, or `nil` if the dialog is canceled.
    def self.get_int(parent : Widget? = nil, *, title : String, label : String, value : Int = 0, minimum : Int = 0, maximum : Int = 99, step : Int? = nil, options : InputDialogOption = InputDialogOption::None, &block : InputDialog ->) : Int32?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Int
      dialog.options = options unless options.none?
      dialog.label_text = label
      dialog.int_range = minimum.to_i32..maximum.to_i32
      dialog.int_step = step.not_nil! if step
      dialog.int_value = value
      begin
        yield dialog
        dialog.exec == DialogCode::Accepted ? dialog.int_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal floating-point input dialog and returns the selected value,
    # or `nil` if the dialog is canceled.
    def self.get_double(parent : Widget? = nil, *, title : String, label : String, value : Float = 0.0, minimum : Float = 0.0, maximum : Float = 99.0, decimals : Int? = nil, options : InputDialogOption = InputDialogOption::None) : Float64?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Double
      dialog.options = options unless options.none?
      dialog.label_text = label
      dialog.double_range = minimum.to_f64..maximum.to_f64
      dialog.double_decimals = decimals.not_nil! if decimals
      dialog.double_value = value
      begin
        dialog.exec == DialogCode::Accepted ? dialog.double_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal floating-point input dialog, yields it for customization,
    # and returns the selected value, or `nil` if the dialog is canceled.
    def self.get_double(parent : Widget? = nil, *, title : String, label : String, value : Float = 0.0, minimum : Float = 0.0, maximum : Float = 99.0, decimals : Int? = nil, options : InputDialogOption = InputDialogOption::None, &block : InputDialog ->) : Float64?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Double
      dialog.options = options unless options.none?
      dialog.label_text = label
      dialog.double_range = minimum.to_f64..maximum.to_f64
      dialog.double_decimals = decimals.not_nil! if decimals
      dialog.double_value = value
      begin
        yield dialog
        dialog.exec == DialogCode::Accepted ? dialog.double_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal item-selection dialog and returns the selected value, or
    # `nil` if the dialog is canceled.
    def self.get_item(parent : Widget? = nil, *, title : String, label : String, items : Enumerable(String), current : Int = 0, editable : Bool = true, options : InputDialogOption = InputDialogOption::None) : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
      dialog.options = options unless options.none?
      dialog.label_text = label
      dialog.combo_box_items = items
      dialog.combo_box_editable = editable
      dialog.text_value = dialog.combo_box_items[current]? || ""
      begin
        dialog.exec == DialogCode::Accepted ? dialog.text_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal item-selection dialog, yields it for customization, and
    # returns the selected value, or `nil` if the dialog is canceled.
    def self.get_item(parent : Widget? = nil, *, title : String, label : String, items : Enumerable(String), current : Int = 0, editable : Bool = true, options : InputDialogOption = InputDialogOption::None, &block : InputDialog ->) : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
      dialog.options = options unless options.none?
      dialog.label_text = label
      dialog.combo_box_items = items
      dialog.combo_box_editable = editable
      dialog.text_value = dialog.combo_box_items[current]? || ""
      begin
        yield dialog
        dialog.exec == DialogCode::Accepted ? dialog.text_value : nil
      ensure
        dialog.release
      end
    end

    protected def emit_text_value_changed(value : String) : Nil
      @text_value_changed.emit(value)
    end

    protected def emit_text_value_selected(value : String) : Nil
      @text_value_selected.emit(value)
    end

    protected def emit_int_value_changed(value : Int32) : Nil
      @int_value_changed.emit(value)
    end

    protected def emit_int_value_selected(value : Int32) : Nil
      @int_value_selected.emit(value)
    end

    protected def emit_double_value_changed(value : Float64) : Nil
      @double_value_changed.emit(value)
    end

    protected def emit_double_value_selected(value : Float64) : Nil
      @double_value_selected.emit(value)
    end

    private def register_callbacks : Nil
      @text_value_changed = Signal(String).new
      @text_value_selected = Signal(String).new
      @int_value_changed = Signal(Int32).new
      @int_value_selected = Signal(Int32).new
      @double_value_changed = Signal(Float64).new
      @double_value_selected = Signal(Float64).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_input_dialog_on_text_value_changed(to_unsafe, TEXT_VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_input_dialog_on_text_value_selected(to_unsafe, TEXT_VALUE_SELECTED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_input_dialog_on_int_value_changed(to_unsafe, INT_VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_input_dialog_on_int_value_selected(to_unsafe, INT_VALUE_SELECTED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_input_dialog_on_double_value_changed(to_unsafe, DOUBLE_VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_input_dialog_on_double_value_selected(to_unsafe, DOUBLE_VALUE_SELECTED_TRAMPOLINE, @callback_userdata)
    end

    private TEXT_VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(InputDialog).unbox(userdata).emit_text_value_changed(Qt6.copy_string(value))
    end

    private TEXT_VALUE_SELECTED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(InputDialog).unbox(userdata).emit_text_value_selected(Qt6.copy_string(value))
    end

    private INT_VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(InputDialog).unbox(userdata).emit_int_value_changed(value)
    end

    private INT_VALUE_SELECTED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(InputDialog).unbox(userdata).emit_int_value_selected(value)
    end

    private DOUBLE_VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Float64) do
      Box(InputDialog).unbox(userdata).emit_double_value_changed(value)
    end

    private DOUBLE_VALUE_SELECTED_TRAMPOLINE = ->(userdata : Void*, value : Float64) do
      Box(InputDialog).unbox(userdata).emit_double_value_selected(value)
    end
  end
end
