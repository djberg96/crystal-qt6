module Qt6
  # Wraps `QLCDNumber`.
  class LcdNumber < Frame
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_lcd_number_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def digit_count : Int32
      LibQt6.qt6cr_lcd_number_digit_count(to_unsafe)
    end

    def digit_count=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_lcd_number_set_digit_count(to_unsafe, int_value)
      int_value
    end

    def mode : LcdNumberMode
      LcdNumberMode.from_value(LibQt6.qt6cr_lcd_number_mode(to_unsafe))
    end

    def mode=(value : LcdNumberMode) : LcdNumberMode
      LibQt6.qt6cr_lcd_number_set_mode(to_unsafe, value.value)
      value
    end

    def segment_style : LcdNumberSegmentStyle
      LcdNumberSegmentStyle.from_value(LibQt6.qt6cr_lcd_number_segment_style(to_unsafe))
    end

    def segment_style=(value : LcdNumberSegmentStyle) : LcdNumberSegmentStyle
      LibQt6.qt6cr_lcd_number_set_segment_style(to_unsafe, value.value)
      value
    end

    def value : Float64
      LibQt6.qt6cr_lcd_number_value(to_unsafe)
    end

    def int_value : Int32
      LibQt6.qt6cr_lcd_number_int_value(to_unsafe)
    end

    def display(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_lcd_number_display_int(to_unsafe, int_value)
      int_value
    end

    def display(value : Float) : Float64
      float_value = value.to_f64
      LibQt6.qt6cr_lcd_number_display_double(to_unsafe, float_value)
      float_value
    end

    def display(value : String) : String
      LibQt6.qt6cr_lcd_number_display_string(to_unsafe, value.to_unsafe)
      value
    end
  end
end
