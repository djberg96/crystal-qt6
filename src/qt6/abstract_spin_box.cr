module Qt6
  # Wraps `QAbstractSpinBox` for shared spin-box controls.
  class AbstractSpinBox < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current button-symbol style.
    def button_symbols : AbstractSpinBoxButtonSymbol
      AbstractSpinBoxButtonSymbol.from_value(LibQt6.qt6cr_abstract_spin_box_button_symbols(to_unsafe))
    end

    # Sets the button-symbol style and returns it.
    def button_symbols=(value : AbstractSpinBoxButtonSymbol) : AbstractSpinBoxButtonSymbol
      LibQt6.qt6cr_abstract_spin_box_set_button_symbols(to_unsafe, value.value)
      value
    end

    # Returns `true` when text editing is read-only.
    def read_only? : Bool
      LibQt6.qt6cr_abstract_spin_box_is_read_only(to_unsafe)
    end

    # Enables or disables read-only text editing.
    def read_only=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_spin_box_set_read_only(to_unsafe, value)
      value
    end
  end
end
