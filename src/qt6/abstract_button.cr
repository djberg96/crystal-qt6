module Qt6
  # Wraps `QAbstractButton`-style behavior shared by multiple button widgets.
  class AbstractButton < Widget
    @clicked : Signal() = Signal().new
    @clicked_checked : Signal(Bool) = Signal(Bool).new
    @toggled : Signal(Bool) = Signal(Bool).new
    @pressed : Signal() = Signal().new
    @released : Signal() = Signal().new
    @clicked_userdata : LibQt6::Handle = Pointer(Void).null
    @clicked_checked_userdata : LibQt6::Handle = Pointer(Void).null
    @toggled_userdata : LibQt6::Handle = Pointer(Void).null
    @pressed_userdata : LibQt6::Handle = Pointer(Void).null
    @released_userdata : LibQt6::Handle = Pointer(Void).null

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Signal emitted when the button is clicked.
    getter clicked : Signal()
    # Signal emitted when the button is clicked, including the checked state.
    getter clicked_checked : Signal(Bool)
    # Signal emitted when the checked state changes.
    getter toggled : Signal(Bool)
    # Signal emitted when the button is pressed.
    getter pressed : Signal()
    # Signal emitted when the button is released.
    getter released : Signal()

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_button_callbacks
    end

    # Returns the button text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_abstract_button_text(to_unsafe))
    end

    # Sets the button text and returns the assigned value.
    def text=(value : String) : String
      LibQt6.qt6cr_abstract_button_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the button can stay checked.
    def checkable? : Bool
      LibQt6.qt6cr_abstract_button_is_checkable(to_unsafe)
    end

    # Enables or disables checkable behavior.
    def checkable=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_button_set_checkable(to_unsafe, value)
      value
    end

    # Returns `true` when the button is checked.
    def checked? : Bool
      LibQt6.qt6cr_abstract_button_is_checked(to_unsafe)
    end

    # Sets the checked state and returns the assigned value.
    def checked=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_button_set_checked(to_unsafe, value)
      value
    end

    # Returns the button shortcut.
    def shortcut : KeySequence
      KeySequence.new(Qt6.copy_and_release_string(LibQt6.qt6cr_abstract_button_shortcut(to_unsafe)))
    end

    # Sets the button shortcut and returns it.
    def shortcut=(value : String | KeySequence) : KeySequence
      key_sequence = value.is_a?(KeySequence) ? value : KeySequence.new(value)
      LibQt6.qt6cr_abstract_button_set_shortcut(to_unsafe, key_sequence.to_s.to_unsafe)
      key_sequence
    end

    # Returns `true` when the button is currently down.
    def down? : Bool
      LibQt6.qt6cr_abstract_button_is_down(to_unsafe)
    end

    # Sets the down state and returns the assigned value.
    def down=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_button_set_down(to_unsafe, value)
      value
    end

    # Returns `true` when auto-repeat is enabled.
    def auto_repeat? : Bool
      LibQt6.qt6cr_abstract_button_auto_repeat(to_unsafe)
    end

    # Enables or disables auto-repeat.
    def auto_repeat=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_button_set_auto_repeat(to_unsafe, value)
      value
    end

    # Returns the auto-repeat delay in milliseconds.
    def auto_repeat_delay : Int32
      LibQt6.qt6cr_abstract_button_auto_repeat_delay(to_unsafe)
    end

    # Sets the auto-repeat delay and returns it.
    def auto_repeat_delay=(value : Int) : Int32
      LibQt6.qt6cr_abstract_button_set_auto_repeat_delay(to_unsafe, value.to_i32)
      value.to_i32
    end

    # Returns the auto-repeat interval in milliseconds.
    def auto_repeat_interval : Int32
      LibQt6.qt6cr_abstract_button_auto_repeat_interval(to_unsafe)
    end

    # Sets the auto-repeat interval and returns it.
    def auto_repeat_interval=(value : Int) : Int32
      LibQt6.qt6cr_abstract_button_set_auto_repeat_interval(to_unsafe, value.to_i32)
      value.to_i32
    end

    # Returns `true` when the button participates in auto-exclusive behavior.
    def auto_exclusive? : Bool
      LibQt6.qt6cr_abstract_button_auto_exclusive(to_unsafe)
    end

    # Enables or disables auto-exclusive behavior.
    def auto_exclusive=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_button_set_auto_exclusive(to_unsafe, value)
      value
    end

    # Returns the owning button group, if any.
    def group : ButtonGroup?
      handle = LibQt6.qt6cr_abstract_button_group(to_unsafe)
      handle.null? ? nil : ButtonGroup.wrap(handle)
    end

    # Returns the button icon.
    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_abstract_button_icon(to_unsafe), true)
    end

    # Sets the button icon.
    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_abstract_button_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the icon size used by the button.
    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_abstract_button_icon_size(to_unsafe))
    end

    # Sets the icon size and returns it.
    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_abstract_button_set_icon_size(to_unsafe, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    # Registers a block to run when the button is clicked.
    def on_clicked(&block : ->) : self
      @clicked.connect { block.call }
      self
    end

    # Registers a block to run when the button is clicked, including the checked state.
    def on_clicked_checked(&block : Bool ->) : self
      @clicked_checked.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the checked state changes.
    def on_toggled(&block : Bool ->) : self
      @toggled.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the button is pressed.
    def on_pressed(&block : ->) : self
      @pressed.connect { block.call }
      self
    end

    # Registers a block to run when the button is released.
    def on_released(&block : ->) : self
      @released.connect { block.call }
      self
    end

    # Programmatically animates a click.
    def animate_click : self
      LibQt6.qt6cr_abstract_button_animate_click(to_unsafe)
      self
    end

    # Programmatically clicks the button.
    def click : self
      LibQt6.qt6cr_abstract_button_click(to_unsafe)
      self
    end

    # Toggles the checked state when the button is checkable.
    def toggle : self
      LibQt6.qt6cr_abstract_button_toggle(to_unsafe)
      self
    end

    protected def emit_clicked : Nil
      @clicked.emit
    end

    protected def emit_clicked_checked(value : Bool) : Nil
      @clicked_checked.emit(value)
    end

    protected def emit_toggled(value : Bool) : Nil
      @toggled.emit(value)
    end

    protected def emit_pressed : Nil
      @pressed.emit
    end

    protected def emit_released : Nil
      @released.emit
    end

    private def register_button_callbacks : Nil
      @clicked = Signal().new
      @clicked_checked = Signal(Bool).new
      @toggled = Signal(Bool).new
      @pressed = Signal().new
      @released = Signal().new
      @clicked_userdata = Box.box(self.as(AbstractButton))
      @clicked_checked_userdata = Box.box(self.as(AbstractButton))
      @toggled_userdata = Box.box(self.as(AbstractButton))
      @pressed_userdata = Box.box(self.as(AbstractButton))
      @released_userdata = Box.box(self.as(AbstractButton))
      LibQt6.qt6cr_abstract_button_on_clicked(to_unsafe, CLICKED_TRAMPOLINE, @clicked_userdata)
      LibQt6.qt6cr_abstract_button_on_clicked_checked(to_unsafe, CLICKED_CHECKED_TRAMPOLINE, @clicked_checked_userdata)
      LibQt6.qt6cr_abstract_button_on_toggled(to_unsafe, TOGGLED_TRAMPOLINE, @toggled_userdata)
      LibQt6.qt6cr_abstract_button_on_pressed(to_unsafe, PRESSED_TRAMPOLINE, @pressed_userdata)
      LibQt6.qt6cr_abstract_button_on_released(to_unsafe, RELEASED_TRAMPOLINE, @released_userdata)
    end

    private CLICKED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractButton).unbox(userdata).emit_clicked
    end

    private CLICKED_CHECKED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(AbstractButton).unbox(userdata).emit_clicked_checked(value)
    end

    private TOGGLED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(AbstractButton).unbox(userdata).emit_toggled(value)
    end

    private PRESSED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractButton).unbox(userdata).emit_pressed
    end

    private RELEASED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractButton).unbox(userdata).emit_released
    end
  end
end
