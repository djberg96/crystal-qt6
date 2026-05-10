module Qt6
  # Wraps `QLCDNumber`.
  class LcdNumber < Frame
    @overflow : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter overflow : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_lcd_number_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    def digit_count : Int32
      LibQt6.qt6cr_lcd_number_digit_count(to_unsafe)
    end

    def digit_count=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_lcd_number_set_digit_count(to_unsafe, int_value)
      int_value
    end

    def set_digit_count(value : Int) : self
      self.digit_count = value
      self
    end

    def mode : LcdNumberMode
      LcdNumberMode.from_value(LibQt6.qt6cr_lcd_number_mode(to_unsafe))
    end

    def mode=(value : LcdNumberMode) : LcdNumberMode
      LibQt6.qt6cr_lcd_number_set_mode(to_unsafe, value.value)
      value
    end

    def set_mode(value : LcdNumberMode) : self
      self.mode = value
      self
    end

    def set_bin_mode : self
      self.mode = LcdNumberMode::Bin
      self
    end

    def set_dec_mode : self
      self.mode = LcdNumberMode::Dec
      self
    end

    def set_hex_mode : self
      self.mode = LcdNumberMode::Hex
      self
    end

    def set_oct_mode : self
      self.mode = LcdNumberMode::Oct
      self
    end

    def segment_style : LcdNumberSegmentStyle
      LcdNumberSegmentStyle.from_value(LibQt6.qt6cr_lcd_number_segment_style(to_unsafe))
    end

    def segment_style=(value : LcdNumberSegmentStyle) : LcdNumberSegmentStyle
      LibQt6.qt6cr_lcd_number_set_segment_style(to_unsafe, value.value)
      value
    end

    def set_segment_style(value : LcdNumberSegmentStyle) : self
      self.segment_style = value
      self
    end

    def small_decimal_point? : Bool
      LibQt6.qt6cr_lcd_number_small_decimal_point(to_unsafe)
    end

    def small_decimal_point=(value : Bool) : Bool
      LibQt6.qt6cr_lcd_number_set_small_decimal_point(to_unsafe, value)
      value
    end

    def set_small_decimal_point(value : Bool) : self
      self.small_decimal_point = value
      self
    end

    def value : Float64
      LibQt6.qt6cr_lcd_number_value(to_unsafe)
    end

    def int_value : Int32
      LibQt6.qt6cr_lcd_number_int_value(to_unsafe)
    end

    def overflow?(value : Int) : Bool
      LibQt6.qt6cr_lcd_number_check_overflow_int(to_unsafe, value.to_i32)
    end

    def overflow?(value : Float) : Bool
      LibQt6.qt6cr_lcd_number_check_overflow_double(to_unsafe, value.to_f64)
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

    def on_overflow(&block : ->) : self
      @overflow.connect { block.call }
      self
    end

    protected def emit_overflow : Nil
      @overflow.emit
    end

    private def register_callbacks : Nil
      @overflow = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_lcd_number_on_overflow(to_unsafe, OVERFLOW_TRAMPOLINE, @callback_userdata)
    end

    private OVERFLOW_TRAMPOLINE = ->(userdata : Void*) do
      Box(LcdNumber).unbox(userdata).emit_overflow
    end
  end
end
