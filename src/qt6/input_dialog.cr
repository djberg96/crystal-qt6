module Qt6
  class InputDialog < Dialog
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_input_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def input_mode : InputDialogInputMode
      InputDialogInputMode.from_value(LibQt6.qt6cr_input_dialog_input_mode(to_unsafe))
    end

    def input_mode=(value : InputDialogInputMode) : InputDialogInputMode
      LibQt6.qt6cr_input_dialog_set_input_mode(to_unsafe, value.value)
      value
    end

    def label_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_input_dialog_label_text(to_unsafe))
    end

    def label_text=(value : String) : String
      LibQt6.qt6cr_input_dialog_set_label_text(to_unsafe, value.to_unsafe)
      value
    end

    def text_value : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_input_dialog_text_value(to_unsafe))
    end

    def text_value=(value : String) : String
      LibQt6.qt6cr_input_dialog_set_text_value(to_unsafe, value.to_unsafe)
      value
    end

    def int_value : Int32
      LibQt6.qt6cr_input_dialog_int_value(to_unsafe)
    end

    def int_value=(value : Int) : Int32
      LibQt6.qt6cr_input_dialog_set_int_value(to_unsafe, value)
      value.to_i
    end

    def int_range=(value : Range(Int32, Int32)) : Range(Int32, Int32)
      LibQt6.qt6cr_input_dialog_set_int_range(to_unsafe, value.begin, value.end)
      value
    end

    def int_minimum : Int32
      LibQt6.qt6cr_input_dialog_int_minimum(to_unsafe)
    end

    def int_maximum : Int32
      LibQt6.qt6cr_input_dialog_int_maximum(to_unsafe)
    end

    def double_value : Float64
      LibQt6.qt6cr_input_dialog_double_value(to_unsafe)
    end

    def double_value=(value : Float) : Float64
      LibQt6.qt6cr_input_dialog_set_double_value(to_unsafe, value)
      value.to_f64
    end

    def double_range=(value : Range(Float64, Float64)) : Range(Float64, Float64)
      LibQt6.qt6cr_input_dialog_set_double_range(to_unsafe, value.begin, value.end)
      value
    end

    def double_minimum : Float64
      LibQt6.qt6cr_input_dialog_double_minimum(to_unsafe)
    end

    def double_maximum : Float64
      LibQt6.qt6cr_input_dialog_double_maximum(to_unsafe)
    end

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
  end
end