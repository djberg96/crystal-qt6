module Qt6
  class Action < QObject
    @triggered : Signal() = Signal().new
    @toggled : Signal(Bool) = Signal(Bool).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @toggled_userdata : LibQt6::Handle = Pointer(Void).null

    getter triggered : Signal()
    getter toggled : Signal(Bool)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(text : String = "", parent : QObject? = nil)
      super(LibQt6.qt6cr_action_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @triggered = Signal().new
      @toggled = Signal(Bool).new
      @callback_userdata = Box.box(self)
      @toggled_userdata = Box.box(self)
      LibQt6.qt6cr_action_on_triggered(to_unsafe, TRIGGERED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_action_on_toggled(to_unsafe, TOGGLED_TRAMPOLINE, @toggled_userdata)
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_action_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_action_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_action_icon(to_unsafe), true)
    end

    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_action_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    def shortcut : KeySequence
      KeySequence.new(Qt6.copy_and_release_string(LibQt6.qt6cr_action_shortcut(to_unsafe)))
    end

    def shortcut=(value : String | KeySequence) : KeySequence
      key_sequence = value.is_a?(KeySequence) ? value : KeySequence.new(value)
      LibQt6.qt6cr_action_set_shortcut(to_unsafe, key_sequence.to_s.to_unsafe)
      key_sequence
    end

    def checkable? : Bool
      LibQt6.qt6cr_action_is_checkable(to_unsafe)
    end

    def checkable=(value : Bool) : Bool
      LibQt6.qt6cr_action_set_checkable(to_unsafe, value)
      value
    end

    def checked? : Bool
      LibQt6.qt6cr_action_is_checked(to_unsafe)
    end

    def checked=(value : Bool) : Bool
      LibQt6.qt6cr_action_set_checked(to_unsafe, value)
      value
    end

    def enabled? : Bool
      LibQt6.qt6cr_action_is_enabled(to_unsafe)
    end

    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_action_set_enabled(to_unsafe, value)
      value
    end

    def tool_tip : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_action_tool_tip(to_unsafe))
    end

    def tool_tip=(value : String) : String
      LibQt6.qt6cr_action_set_tool_tip(to_unsafe, value.to_unsafe)
      value
    end

    def status_tip : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_action_status_tip(to_unsafe))
    end

    def status_tip=(value : String) : String
      LibQt6.qt6cr_action_set_status_tip(to_unsafe, value.to_unsafe)
      value
    end

    def visible? : Bool
      LibQt6.qt6cr_action_is_visible(to_unsafe)
    end

    def visible=(value : Bool) : Bool
      LibQt6.qt6cr_action_set_visible(to_unsafe, value)
      value
    end

    def separator? : Bool
      LibQt6.qt6cr_action_is_separator(to_unsafe)
    end

    def separator=(value : Bool) : Bool
      LibQt6.qt6cr_action_set_separator(to_unsafe, value)
      value
    end

    def data : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_action_data(to_unsafe))
    end

    def data=(value) : ModelData
      normalized = Qt6.normalize_model_data(value)
      LibQt6.qt6cr_action_set_data(to_unsafe, Qt6.model_data_to_native(normalized))
      normalized
    end

    def on_triggered(&block : ->) : self
      @triggered.connect { block.call }
      self
    end

    def on_toggled(&block : Bool ->) : self
      @toggled.connect { |value| block.call(value) }
      self
    end

    def trigger : self
      LibQt6.qt6cr_action_trigger(to_unsafe)
      self
    end

    protected def emit_triggered : Nil
      @triggered.emit
    end

    protected def emit_toggled(value : Bool) : Nil
      @toggled.emit(value)
    end

    private TRIGGERED_TRAMPOLINE = ->(userdata : Void*) do
      Box(Action).unbox(userdata).emit_triggered
    end

    private TOGGLED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(Action).unbox(userdata).emit_toggled(value)
    end
  end
end
