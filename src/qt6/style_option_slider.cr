module Qt6
  # Wraps `QStyleOptionSlider` for slider-like complex control paint state.
  class StyleOptionSlider < StyleOptionComplex
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_slider_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_style_option_slider_orientation(to_unsafe))
    end

    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_style_option_slider_set_orientation(to_unsafe, value.value)
      value
    end

    def minimum : Int32
      LibQt6.qt6cr_style_option_slider_minimum(to_unsafe)
    end

    def minimum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_slider_set_minimum(to_unsafe, int_value)
      int_value
    end

    def maximum : Int32
      LibQt6.qt6cr_style_option_slider_maximum(to_unsafe)
    end

    def maximum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_slider_set_maximum(to_unsafe, int_value)
      int_value
    end

    def tick_position : SliderTickPosition
      SliderTickPosition.from_value(LibQt6.qt6cr_style_option_slider_tick_position(to_unsafe))
    end

    def tick_position=(value : SliderTickPosition) : SliderTickPosition
      LibQt6.qt6cr_style_option_slider_set_tick_position(to_unsafe, value.value)
      value
    end

    def tick_interval : Int32
      LibQt6.qt6cr_style_option_slider_tick_interval(to_unsafe)
    end

    def tick_interval=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_slider_set_tick_interval(to_unsafe, int_value)
      int_value
    end

    def upside_down? : Bool
      LibQt6.qt6cr_style_option_slider_upside_down(to_unsafe)
    end

    def upside_down=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_slider_set_upside_down(to_unsafe, value)
      value
    end

    def slider_position : Int32
      LibQt6.qt6cr_style_option_slider_slider_position(to_unsafe)
    end

    def slider_position=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_slider_set_slider_position(to_unsafe, int_value)
      int_value
    end

    def slider_value : Int32
      LibQt6.qt6cr_style_option_slider_slider_value(to_unsafe)
    end

    def slider_value=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_slider_set_slider_value(to_unsafe, int_value)
      int_value
    end

    def single_step : Int32
      LibQt6.qt6cr_style_option_slider_single_step(to_unsafe)
    end

    def single_step=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_slider_set_single_step(to_unsafe, int_value)
      int_value
    end

    def page_step : Int32
      LibQt6.qt6cr_style_option_slider_page_step(to_unsafe)
    end

    def page_step=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_slider_set_page_step(to_unsafe, int_value)
      int_value
    end

    def notch_target : Float64
      LibQt6.qt6cr_style_option_slider_notch_target(to_unsafe)
    end

    def notch_target=(value : Number) : Float64
      float_value = value.to_f64
      LibQt6.qt6cr_style_option_slider_set_notch_target(to_unsafe, float_value)
      float_value
    end

    def dial_wrapping? : Bool
      LibQt6.qt6cr_style_option_slider_dial_wrapping(to_unsafe)
    end

    def dial_wrapping=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_slider_set_dial_wrapping(to_unsafe, value)
      value
    end

    def keyboard_modifiers : KeyboardModifier
      KeyboardModifier.from_value(LibQt6.qt6cr_style_option_slider_keyboard_modifiers(to_unsafe))
    end

    def keyboard_modifiers=(value : KeyboardModifier) : KeyboardModifier
      LibQt6.qt6cr_style_option_slider_set_keyboard_modifiers(to_unsafe, value.value)
      value
    end

    def init_from(slider : Slider) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, slider.to_unsafe)
      LibQt6.qt6cr_slider_init_style_option(slider.to_unsafe, to_unsafe)
      self
    end

    def init_from(scroll_bar : ScrollBar) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, scroll_bar.to_unsafe)
      LibQt6.qt6cr_scroll_bar_init_style_option(scroll_bar.to_unsafe, to_unsafe)
      self
    end

    def init_from(dial : Dial) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, dial.to_unsafe)
      LibQt6.qt6cr_dial_init_style_option(dial.to_unsafe, to_unsafe)
      self
    end

    def set_orientation(value : Orientation) : self
      self.orientation = value
      self
    end

    def set_minimum(value : Int) : self
      self.minimum = value
      self
    end

    def set_maximum(value : Int) : self
      self.maximum = value
      self
    end

    def set_tick_position(value : SliderTickPosition) : self
      self.tick_position = value
      self
    end

    def set_tick_interval(value : Int) : self
      self.tick_interval = value
      self
    end

    def set_upside_down(value : Bool) : self
      self.upside_down = value
      self
    end

    def set_slider_position(value : Int) : self
      self.slider_position = value
      self
    end

    def set_slider_value(value : Int) : self
      self.slider_value = value
      self
    end

    def set_single_step(value : Int) : self
      self.single_step = value
      self
    end

    def set_page_step(value : Int) : self
      self.page_step = value
      self
    end

    def set_notch_target(value : Number) : self
      self.notch_target = value
      self
    end

    def set_dial_wrapping(value : Bool) : self
      self.dial_wrapping = value
      self
    end

    def set_keyboard_modifiers(value : KeyboardModifier) : self
      self.keyboard_modifiers = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_slider_destroy(to_unsafe)
    end
  end
end
