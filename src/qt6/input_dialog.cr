module Qt6
  # Wraps `QInputDialog`.
  class InputDialog < Dialog
    # Creates an input dialog with an optional parent widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_input_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
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

    # Returns the label text shown above the input widget.
    def label_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_input_dialog_label_text(to_unsafe))
    end

    # Sets the label text shown above the input widget.
    def label_text=(value : String) : String
      LibQt6.qt6cr_input_dialog_set_label_text(to_unsafe, value.to_unsafe)
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
      value.to_i
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

    # Returns whether the combo-box allows arbitrary text entry.
    def combo_box_editable? : Bool
      LibQt6.qt6cr_input_dialog_combo_box_editable(to_unsafe)
    end

    # Sets whether the combo-box allows arbitrary text entry.
    def combo_box_editable=(value : Bool) : Bool
      LibQt6.qt6cr_input_dialog_set_combo_box_editable(to_unsafe, value)
      value
    end

    # Shows a modal text-input dialog and returns the entered value, or `nil`
    # if the dialog is canceled.
    def self.get_text(parent : Widget? = nil, *, title : String, label : String, value : String = "") : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
      dialog.label_text = label
      dialog.text_value = value
      begin
        dialog.exec == DialogCode::Accepted ? dialog.text_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal text-input dialog, yields it for customization, and returns
    # the entered value, or `nil` if the dialog is canceled.
    def self.get_text(parent : Widget? = nil, *, title : String, label : String, value : String = "", &block : InputDialog ->) : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
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
    def self.get_int(parent : Widget? = nil, *, title : String, label : String, value : Int = 0, minimum : Int = 0, maximum : Int = 99) : Int32?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Int
      dialog.label_text = label
      dialog.int_range = minimum.to_i..maximum.to_i
      dialog.int_value = value
      begin
        dialog.exec == DialogCode::Accepted ? dialog.int_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal integer-input dialog, yields it for customization, and
    # returns the selected value, or `nil` if the dialog is canceled.
    def self.get_int(parent : Widget? = nil, *, title : String, label : String, value : Int = 0, minimum : Int = 0, maximum : Int = 99, &block : InputDialog ->) : Int32?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Int
      dialog.label_text = label
      dialog.int_range = minimum.to_i..maximum.to_i
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
    def self.get_double(parent : Widget? = nil, *, title : String, label : String, value : Float = 0.0, minimum : Float = 0.0, maximum : Float = 99.0) : Float64?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Double
      dialog.label_text = label
      dialog.double_range = minimum.to_f64..maximum.to_f64
      dialog.double_value = value
      begin
        dialog.exec == DialogCode::Accepted ? dialog.double_value : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal floating-point input dialog, yields it for customization,
    # and returns the selected value, or `nil` if the dialog is canceled.
    def self.get_double(parent : Widget? = nil, *, title : String, label : String, value : Float = 0.0, minimum : Float = 0.0, maximum : Float = 99.0, &block : InputDialog ->) : Float64?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Double
      dialog.label_text = label
      dialog.double_range = minimum.to_f64..maximum.to_f64
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
    def self.get_item(parent : Widget? = nil, *, title : String, label : String, items : Enumerable(String), current : Int = 0, editable : Bool = true) : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
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
    def self.get_item(parent : Widget? = nil, *, title : String, label : String, items : Enumerable(String), current : Int = 0, editable : Bool = true, &block : InputDialog ->) : String?
      dialog = new(parent)
      dialog.window_title = title
      dialog.input_mode = InputDialogInputMode::Text
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
  end
end
