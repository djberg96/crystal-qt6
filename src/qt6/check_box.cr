module Qt6
  # Wraps `QCheckBox`.
  class CheckBox < AbstractButton
    @state_changed : Signal(CheckState) = Signal(CheckState).new
    @state_changed_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the full Qt check state changes.
    getter state_changed : Signal(CheckState)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a checkbox with optional text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_check_box_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      register_check_box_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_check_box_callbacks
    end

    # Returns `true` when the checkbox supports a partially checked state.
    def tristate? : Bool
      LibQt6.qt6cr_check_box_is_tristate(to_unsafe)
    end

    # Enables or disables tri-state behavior.
    def tristate=(value : Bool) : Bool
      LibQt6.qt6cr_check_box_set_tristate(to_unsafe, value)
      value
    end

    # Returns the full Qt check state.
    def check_state : CheckState
      CheckState.from_value(LibQt6.qt6cr_check_box_check_state(to_unsafe))
    end

    # Sets the full Qt check state and returns it.
    def check_state=(value : CheckState) : CheckState
      LibQt6.qt6cr_check_box_set_check_state(to_unsafe, value.value)
      value
    end

    # Registers a block to run when the full Qt check state changes.
    def on_state_changed(&block : CheckState ->) : self
      @state_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_state_changed(value : Int32) : Nil
      @state_changed.emit(CheckState.from_value(value))
    end

    private def register_check_box_callbacks : Nil
      @state_changed = Signal(CheckState).new
      @state_changed_userdata = Box.box(self.as(CheckBox))
      LibQt6.qt6cr_check_box_on_state_changed(to_unsafe, STATE_CHANGED_TRAMPOLINE, @state_changed_userdata)
    end

    private STATE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(CheckBox).unbox(userdata).emit_state_changed(value)
    end
  end
end
