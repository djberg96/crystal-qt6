module Qt6
  # Wraps `QAbstractButton`-style behavior shared by multiple button widgets.
  class AbstractButton < Widget
    @clicked : Signal() = Signal().new
    @toggled : Signal(Bool) = Signal(Bool).new
    @clicked_userdata : LibQt6::Handle = Pointer(Void).null
    @toggled_userdata : LibQt6::Handle = Pointer(Void).null

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Signal emitted when the button is clicked.
    getter clicked : Signal()
    # Signal emitted when the checked state changes.
    getter toggled : Signal(Bool)

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

    # Registers a block to run when the checked state changes.
    def on_toggled(&block : Bool ->) : self
      @toggled.connect { |value| block.call(value) }
      self
    end

    # Programmatically clicks the button.
    def click : self
      LibQt6.qt6cr_abstract_button_click(to_unsafe)
      self
    end

    protected def emit_clicked : Nil
      @clicked.emit
    end

    protected def emit_toggled(value : Bool) : Nil
      @toggled.emit(value)
    end

    private def register_button_callbacks : Nil
      @clicked = Signal().new
      @toggled = Signal(Bool).new
      @clicked_userdata = Box.box(self.as(AbstractButton))
      @toggled_userdata = Box.box(self.as(AbstractButton))
      LibQt6.qt6cr_abstract_button_on_clicked(to_unsafe, CLICKED_TRAMPOLINE, @clicked_userdata)
      LibQt6.qt6cr_abstract_button_on_toggled(to_unsafe, TOGGLED_TRAMPOLINE, @toggled_userdata)
    end

    private CLICKED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractButton).unbox(userdata).emit_clicked
    end

    private TOGGLED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(AbstractButton).unbox(userdata).emit_toggled(value)
    end
  end
end
