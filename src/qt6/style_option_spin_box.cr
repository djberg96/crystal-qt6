module Qt6
  # Wraps `QStyleOptionSpinBox` for spin-box paint and layout state.
  class StyleOptionSpinBox < StyleOptionComplex
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_spin_box_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def button_symbols : AbstractSpinBoxButtonSymbol
      AbstractSpinBoxButtonSymbol.from_value(LibQt6.qt6cr_style_option_spin_box_button_symbols(to_unsafe))
    end

    def button_symbols=(value : AbstractSpinBoxButtonSymbol) : AbstractSpinBoxButtonSymbol
      LibQt6.qt6cr_style_option_spin_box_set_button_symbols(to_unsafe, value.value)
      value
    end

    def step_enabled : AbstractSpinBoxStepEnabled
      AbstractSpinBoxStepEnabled.from_value(LibQt6.qt6cr_style_option_spin_box_step_enabled(to_unsafe))
    end

    def step_enabled=(value : AbstractSpinBoxStepEnabled) : AbstractSpinBoxStepEnabled
      LibQt6.qt6cr_style_option_spin_box_set_step_enabled(to_unsafe, value.value)
      value
    end

    def frame? : Bool
      LibQt6.qt6cr_style_option_spin_box_has_frame(to_unsafe)
    end

    def frame=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_spin_box_set_frame(to_unsafe, value)
      value
    end

    def init_from(spin_box : AbstractSpinBox) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, spin_box.to_unsafe)
      LibQt6.qt6cr_abstract_spin_box_init_style_option(spin_box.to_unsafe, to_unsafe)
      self
    end

    def set_button_symbols(value : AbstractSpinBoxButtonSymbol) : self
      self.button_symbols = value
      self
    end

    def set_step_enabled(value : AbstractSpinBoxStepEnabled) : self
      self.step_enabled = value
      self
    end

    def set_frame(value : Bool) : self
      self.frame = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_spin_box_destroy(to_unsafe)
    end
  end
end
