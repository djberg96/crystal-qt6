module Qt6
  # Wraps shared `QStyleOptionComplex` state for compound controls.
  class StyleOptionComplex < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_complex_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def sub_controls : StyleSubControl
      raw_value = LibQt6.qt6cr_style_option_complex_sub_controls(to_unsafe)
      raw_value == -1 ? StyleSubControl::All : StyleSubControl.from_value(raw_value)
    end

    def sub_controls=(value : StyleSubControl) : StyleSubControl
      LibQt6.qt6cr_style_option_complex_set_sub_controls(to_unsafe, value.value)
      value
    end

    def active_sub_controls : StyleSubControl
      raw_value = LibQt6.qt6cr_style_option_complex_active_sub_controls(to_unsafe)
      raw_value == -1 ? StyleSubControl::All : StyleSubControl.from_value(raw_value)
    end

    def active_sub_controls=(value : StyleSubControl) : StyleSubControl
      LibQt6.qt6cr_style_option_complex_set_active_sub_controls(to_unsafe, value.value)
      value
    end

    def set_sub_controls(value : StyleSubControl) : self
      self.sub_controls = value
      self
    end

    def set_active_sub_controls(value : StyleSubControl) : self
      self.active_sub_controls = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_complex_destroy(to_unsafe)
    end
  end
end
