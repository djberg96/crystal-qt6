module Qt6
  # Wraps `QAbstractSpinBox` for shared spin-box controls.
  class AbstractSpinBox < Widget
    @editing_finished : Signal() = Signal().new
    @return_pressed : Signal() = Signal().new
    @editing_finished_userdata : LibQt6::Handle = Pointer(Void).null
    @return_pressed_userdata : LibQt6::Handle = Pointer(Void).null

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    getter editing_finished : Signal()
    getter return_pressed : Signal()

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_spin_box_callbacks
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

    # Returns the current rendered text in the editor.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_abstract_spin_box_text(to_unsafe))
    end

    # Returns the special text displayed at the minimum value.
    def special_value_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_abstract_spin_box_special_value_text(to_unsafe))
    end

    # Sets the special text displayed at the minimum value.
    def special_value_text=(value : String) : String
      LibQt6.qt6cr_abstract_spin_box_set_special_value_text(to_unsafe, value.to_unsafe)
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

    # Returns `true` when stepping wraps at the range edges.
    def wrapping? : Bool
      LibQt6.qt6cr_abstract_spin_box_wrapping(to_unsafe)
    end

    # Enables or disables range wrapping while stepping.
    def wrapping=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_spin_box_set_wrapping(to_unsafe, value)
      value
    end

    # Returns `true` when long presses accelerate stepping.
    def accelerated? : Bool
      LibQt6.qt6cr_abstract_spin_box_is_accelerated(to_unsafe)
    end

    # Enables or disables accelerated stepping.
    def accelerated=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_spin_box_set_accelerated(to_unsafe, value)
      value
    end

    # Returns how invalid text is corrected when editing ends.
    def correction_mode : AbstractSpinBoxCorrectionMode
      AbstractSpinBoxCorrectionMode.from_value(LibQt6.qt6cr_abstract_spin_box_correction_mode(to_unsafe))
    end

    # Sets how invalid text is corrected when editing ends.
    def correction_mode=(value : AbstractSpinBoxCorrectionMode) : AbstractSpinBoxCorrectionMode
      LibQt6.qt6cr_abstract_spin_box_set_correction_mode(to_unsafe, value.value)
      value
    end

    # Returns `true` when the current editor text satisfies the validator.
    def acceptable_input? : Bool
      LibQt6.qt6cr_abstract_spin_box_has_acceptable_input(to_unsafe)
    end

    # Returns `true` when typing updates the value continuously.
    def keyboard_tracking? : Bool
      LibQt6.qt6cr_abstract_spin_box_keyboard_tracking(to_unsafe)
    end

    # Enables or disables continuous value updates while typing.
    def keyboard_tracking=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_spin_box_set_keyboard_tracking(to_unsafe, value)
      value
    end

    # Returns the text alignment flags.
    def alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_abstract_spin_box_alignment(to_unsafe))
    end

    # Sets the text alignment flags.
    def alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_abstract_spin_box_set_alignment(to_unsafe, value.value)
      value
    end

    # Returns `true` when the spin-box frame is shown.
    def frame? : Bool
      LibQt6.qt6cr_abstract_spin_box_has_frame(to_unsafe)
    end

    # Shows or hides the spin-box frame.
    def frame=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_spin_box_set_frame(to_unsafe, value)
      value
    end

    # Returns `true` when group separators are shown in numeric displays.
    def group_separator_shown? : Bool
      LibQt6.qt6cr_abstract_spin_box_group_separator_shown(to_unsafe)
    end

    # Shows or hides group separators in numeric displays.
    def group_separator_shown=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_spin_box_set_group_separator_shown(to_unsafe, value)
      value
    end

    # Returns the embedded line edit used for editing text.
    def line_edit : LineEdit
      LineEdit.wrap(LibQt6.qt6cr_abstract_spin_box_line_edit(to_unsafe))
    end

    # Forces the current text to be interpreted and committed.
    def interpret_text : self
      LibQt6.qt6cr_abstract_spin_box_interpret_text(to_unsafe)
      self
    end

    # Steps the value up once.
    def step_up : self
      LibQt6.qt6cr_abstract_spin_box_step_up(to_unsafe)
      self
    end

    # Steps the value down once.
    def step_down : self
      LibQt6.qt6cr_abstract_spin_box_step_down(to_unsafe)
      self
    end

    # Selects all text in the editor.
    def select_all : self
      LibQt6.qt6cr_abstract_spin_box_select_all(to_unsafe)
      self
    end

    # Clears the editor text.
    def clear : self
      LibQt6.qt6cr_abstract_spin_box_clear(to_unsafe)
      self
    end

    # Registers a block to run when editing finishes.
    def on_editing_finished(&block : ->) : self
      @editing_finished.connect { block.call }
      self
    end

    # Registers a block to run when Return is pressed in the editor.
    def on_return_pressed(&block : ->) : self
      @return_pressed.connect { block.call }
      self
    end

    protected def emit_editing_finished : Nil
      @editing_finished.emit
    end

    protected def emit_return_pressed : Nil
      @return_pressed.emit
    end

    private def register_spin_box_callbacks : Nil
      @editing_finished = Signal().new
      @return_pressed = Signal().new
      @editing_finished_userdata = Box.box(self.as(AbstractSpinBox))
      @return_pressed_userdata = Box.box(self.as(AbstractSpinBox))
      LibQt6.qt6cr_abstract_spin_box_on_editing_finished(to_unsafe, EDITING_FINISHED_TRAMPOLINE, @editing_finished_userdata)
      LibQt6.qt6cr_abstract_spin_box_on_return_pressed(to_unsafe, RETURN_PRESSED_TRAMPOLINE, @return_pressed_userdata)
    end

    private EDITING_FINISHED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractSpinBox).unbox(userdata).emit_editing_finished
    end

    private RETURN_PRESSED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractSpinBox).unbox(userdata).emit_return_pressed
    end
  end
end
