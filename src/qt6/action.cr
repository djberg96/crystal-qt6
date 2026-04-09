module Qt6
  class Action < QObject
    @triggered : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter triggered : Signal()

    def initialize(text : String = "", parent : QObject? = nil)
      super(LibQt6.qt6cr_action_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      @triggered = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_action_on_triggered(to_unsafe, TRIGGERED_TRAMPOLINE, @callback_userdata)
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_action_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_action_set_text(to_unsafe, value.to_unsafe)
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

    def on_triggered(&block : ->) : self
      @triggered.connect { block.call }
      self
    end

    def trigger : self
      LibQt6.qt6cr_action_trigger(to_unsafe)
      self
    end

    protected def emit_triggered : Nil
      @triggered.emit
    end

    private TRIGGERED_TRAMPOLINE = ->(userdata : Void*) do
      Box(Action).unbox(userdata).emit_triggered
    end
  end
end
