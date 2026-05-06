module Qt6
  # Wraps `QButtonGroup` for grouped mode buttons.
  class ButtonGroup < QObject
    @button_clicked : Signal(AbstractButton?) = Signal(AbstractButton?).new
    @button_pressed : Signal(AbstractButton?) = Signal(AbstractButton?).new
    @button_released : Signal(AbstractButton?) = Signal(AbstractButton?).new
    @button_toggled : Signal(AbstractButton?, Bool) = Signal(AbstractButton?, Bool).new
    @id_clicked : Signal(Int32) = Signal(Int32).new
    @id_pressed : Signal(Int32) = Signal(Int32).new
    @id_released : Signal(Int32) = Signal(Int32).new
    @id_toggled : Signal(Int32, Bool) = Signal(Int32, Bool).new
    @button_clicked_userdata : LibQt6::Handle = Pointer(Void).null
    @button_pressed_userdata : LibQt6::Handle = Pointer(Void).null
    @button_released_userdata : LibQt6::Handle = Pointer(Void).null
    @button_toggled_userdata : LibQt6::Handle = Pointer(Void).null
    @id_clicked_userdata : LibQt6::Handle = Pointer(Void).null
    @id_pressed_userdata : LibQt6::Handle = Pointer(Void).null
    @id_released_userdata : LibQt6::Handle = Pointer(Void).null
    @id_toggled_userdata : LibQt6::Handle = Pointer(Void).null

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    getter button_clicked : Signal(AbstractButton?)
    getter button_pressed : Signal(AbstractButton?)
    getter button_released : Signal(AbstractButton?)
    getter button_toggled : Signal(AbstractButton?, Bool)
    getter id_clicked : Signal(Int32)
    getter id_pressed : Signal(Int32)
    getter id_released : Signal(Int32)
    getter id_toggled : Signal(Int32, Bool)

    # Creates a button group, optionally parented to another object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_button_group_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_button_group_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_button_group_callbacks
    end

    # Returns `true` when only one button in the group can stay checked.
    def exclusive? : Bool
      LibQt6.qt6cr_button_group_is_exclusive(to_unsafe)
    end

    # Enables or disables exclusive checked-button behavior.
    def exclusive=(value : Bool) : Bool
      LibQt6.qt6cr_button_group_set_exclusive(to_unsafe, value)
      value
    end

    # Adds a button to the group and optionally assigns a stable id.
    def add(button : AbstractButton, id : Int32 = -1) : AbstractButton
      LibQt6.qt6cr_button_group_add_button(to_unsafe, button.to_unsafe, id)
      button
    end

    # Appends a button to the group and returns `self`.
    def <<(button : AbstractButton) : self
      add(button)
      self
    end

    # Returns every button currently assigned to the group.
    def buttons : Array(AbstractButton)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_button_group_buttons(to_unsafe)).map do |handle|
        AbstractButton.wrap(handle)
      end
    end

    # Returns the grouped button for the given id, if one exists.
    def button(id : Int32) : AbstractButton?
      handle = LibQt6.qt6cr_button_group_button(to_unsafe, id)
      handle.null? ? nil : AbstractButton.wrap(handle)
    end

    # Returns the currently checked button id, or `-1` when nothing is checked.
    def checked_id : Int32
      LibQt6.qt6cr_button_group_checked_id(to_unsafe)
    end

    # Returns the currently checked button, if one exists.
    def checked_button : AbstractButton?
      handle = LibQt6.qt6cr_button_group_checked_button(to_unsafe)
      handle.null? ? nil : AbstractButton.wrap(handle)
    end

    # Returns the current group id for the given button, or `-1` when absent.
    def id(button : AbstractButton) : Int32
      LibQt6.qt6cr_button_group_id(to_unsafe, button.to_unsafe)
    end

    # Reassigns the given button's group id and returns it.
    def set_id(button : AbstractButton, id : Int32) : Int32
      LibQt6.qt6cr_button_group_set_id(to_unsafe, button.to_unsafe, id)
      id
    end

    # Removes a button from the group and returns it.
    def remove(button : AbstractButton) : AbstractButton
      LibQt6.qt6cr_button_group_remove_button(to_unsafe, button.to_unsafe)
      button
    end

    # Registers a block to run when any grouped button is clicked.
    def on_button_clicked(&block : AbstractButton? ->) : self
      @button_clicked.connect { |button| block.call(button) }
      self
    end

    # Registers a block to run when any grouped button is pressed.
    def on_button_pressed(&block : AbstractButton? ->) : self
      @button_pressed.connect { |button| block.call(button) }
      self
    end

    # Registers a block to run when any grouped button is released.
    def on_button_released(&block : AbstractButton? ->) : self
      @button_released.connect { |button| block.call(button) }
      self
    end

    # Registers a block to run when a grouped button changes checked state.
    def on_button_toggled(&block : AbstractButton?, Bool ->) : self
      @button_toggled.connect { |button, checked| block.call(button, checked) }
      self
    end

    # Registers a block to run when a grouped button id is clicked.
    def on_id_clicked(&block : Int32 ->) : self
      @id_clicked.connect { |id| block.call(id) }
      self
    end

    # Registers a block to run when a grouped button id is pressed.
    def on_id_pressed(&block : Int32 ->) : self
      @id_pressed.connect { |id| block.call(id) }
      self
    end

    # Registers a block to run when a grouped button id is released.
    def on_id_released(&block : Int32 ->) : self
      @id_released.connect { |id| block.call(id) }
      self
    end

    # Registers a block to run when a grouped button id changes checked state.
    def on_id_toggled(&block : Int32, Bool ->) : self
      @id_toggled.connect { |id, checked| block.call(id, checked) }
      self
    end

    protected def emit_button_clicked(handle : LibQt6::Handle) : Nil
      @button_clicked.emit(handle.null? ? nil : AbstractButton.wrap(handle))
    end

    protected def emit_button_pressed(handle : LibQt6::Handle) : Nil
      @button_pressed.emit(handle.null? ? nil : AbstractButton.wrap(handle))
    end

    protected def emit_button_released(handle : LibQt6::Handle) : Nil
      @button_released.emit(handle.null? ? nil : AbstractButton.wrap(handle))
    end

    protected def emit_button_toggled(handle : LibQt6::Handle, checked : Bool) : Nil
      @button_toggled.emit(handle.null? ? nil : AbstractButton.wrap(handle), checked)
    end

    protected def emit_id_clicked(id : Int32) : Nil
      @id_clicked.emit(id)
    end

    protected def emit_id_pressed(id : Int32) : Nil
      @id_pressed.emit(id)
    end

    protected def emit_id_released(id : Int32) : Nil
      @id_released.emit(id)
    end

    protected def emit_id_toggled(id : Int32, checked : Bool) : Nil
      @id_toggled.emit(id, checked)
    end

    private def register_button_group_callbacks : Nil
      @button_clicked = Signal(AbstractButton?).new
      @button_pressed = Signal(AbstractButton?).new
      @button_released = Signal(AbstractButton?).new
      @button_toggled = Signal(AbstractButton?, Bool).new
      @id_clicked = Signal(Int32).new
      @id_pressed = Signal(Int32).new
      @id_released = Signal(Int32).new
      @id_toggled = Signal(Int32, Bool).new
      @button_clicked_userdata = Box.box(self.as(ButtonGroup))
      @button_pressed_userdata = Box.box(self.as(ButtonGroup))
      @button_released_userdata = Box.box(self.as(ButtonGroup))
      @button_toggled_userdata = Box.box(self.as(ButtonGroup))
      @id_clicked_userdata = Box.box(self.as(ButtonGroup))
      @id_pressed_userdata = Box.box(self.as(ButtonGroup))
      @id_released_userdata = Box.box(self.as(ButtonGroup))
      @id_toggled_userdata = Box.box(self.as(ButtonGroup))
      LibQt6.qt6cr_button_group_on_button_clicked(to_unsafe, BUTTON_CLICKED_TRAMPOLINE, @button_clicked_userdata)
      LibQt6.qt6cr_button_group_on_button_pressed(to_unsafe, BUTTON_PRESSED_TRAMPOLINE, @button_pressed_userdata)
      LibQt6.qt6cr_button_group_on_button_released(to_unsafe, BUTTON_RELEASED_TRAMPOLINE, @button_released_userdata)
      LibQt6.qt6cr_button_group_on_button_toggled(to_unsafe, BUTTON_TOGGLED_TRAMPOLINE, @button_toggled_userdata)
      LibQt6.qt6cr_button_group_on_id_clicked(to_unsafe, ID_CLICKED_TRAMPOLINE, @id_clicked_userdata)
      LibQt6.qt6cr_button_group_on_id_pressed(to_unsafe, ID_PRESSED_TRAMPOLINE, @id_pressed_userdata)
      LibQt6.qt6cr_button_group_on_id_released(to_unsafe, ID_RELEASED_TRAMPOLINE, @id_released_userdata)
      LibQt6.qt6cr_button_group_on_id_toggled(to_unsafe, ID_TOGGLED_TRAMPOLINE, @id_toggled_userdata)
    end

    private BUTTON_CLICKED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(ButtonGroup).unbox(userdata).emit_button_clicked(handle)
    end

    private BUTTON_PRESSED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(ButtonGroup).unbox(userdata).emit_button_pressed(handle)
    end

    private BUTTON_RELEASED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(ButtonGroup).unbox(userdata).emit_button_released(handle)
    end

    private BUTTON_TOGGLED_TRAMPOLINE = ->(userdata : Void*, handle : Void*, checked : Bool) do
      Box(ButtonGroup).unbox(userdata).emit_button_toggled(handle, checked)
    end

    private ID_CLICKED_TRAMPOLINE = ->(userdata : Void*, id : Int32) do
      Box(ButtonGroup).unbox(userdata).emit_id_clicked(id)
    end

    private ID_PRESSED_TRAMPOLINE = ->(userdata : Void*, id : Int32) do
      Box(ButtonGroup).unbox(userdata).emit_id_pressed(id)
    end

    private ID_RELEASED_TRAMPOLINE = ->(userdata : Void*, id : Int32) do
      Box(ButtonGroup).unbox(userdata).emit_id_released(id)
    end

    private ID_TOGGLED_TRAMPOLINE = ->(userdata : Void*, id : Int32, checked : Int32) do
      Box(ButtonGroup).unbox(userdata).emit_id_toggled(id, checked != 0)
    end
  end
end
