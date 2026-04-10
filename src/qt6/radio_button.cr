module Qt6
  # Wraps `QRadioButton`.
  class RadioButton < Widget
    @toggled : Signal(Bool) = Signal(Bool).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the radio button toggles.
    getter toggled : Signal(Bool)

    # Creates a radio button with optional text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_radio_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      @toggled = Signal(Bool).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_radio_button_on_toggled(to_unsafe, TOGGLED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the radio button label text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_radio_button_text(to_unsafe))
    end

    # Sets the radio button label text and returns the assigned value.
    def text=(value : String) : String
      LibQt6.qt6cr_radio_button_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the radio button is checked.
    def checked? : Bool
      LibQt6.qt6cr_radio_button_is_checked(to_unsafe)
    end

    # Sets the checked state and returns the assigned value.
    def checked=(value : Bool) : Bool
      LibQt6.qt6cr_radio_button_set_checked(to_unsafe, value)
      value
    end

    # Registers a block to run when the checked state changes.
    def on_toggled(&block : Bool ->) : self
      @toggled.connect { |value| block.call(value) }
      self
    end

    protected def emit_toggled(value : Bool) : Nil
      @toggled.emit(value)
    end

    private TOGGLED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(RadioButton).unbox(userdata).emit_toggled(value)
    end
  end
end