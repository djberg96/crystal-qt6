module Qt6
  # Wraps `QShortcut`.
  class Shortcut < QObject
    @activated : Signal() = Signal().new
    @activated_ambiguously : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @ambiguous_userdata : LibQt6::Handle = Pointer(Void).null

    getter activated : Signal()
    getter activated_ambiguously : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a shortcut on the given widget.
    def initialize(key_sequence : String | KeySequence, parent : Widget)
      sequence = key_sequence.is_a?(KeySequence) ? key_sequence : KeySequence.new(key_sequence)
      super(LibQt6.qt6cr_shortcut_create(parent.to_unsafe, sequence.to_s.to_unsafe), false)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @activated = Signal().new
      @activated_ambiguously = Signal().new
      @callback_userdata = Box.box(self.as(Shortcut))
      @ambiguous_userdata = Box.box(self.as(Shortcut))
      LibQt6.qt6cr_shortcut_on_activated(to_unsafe, ACTIVATED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_shortcut_on_activated_ambiguously(to_unsafe, ACTIVATED_AMBIGUOUSLY_TRAMPOLINE, @ambiguous_userdata)
    end

    # Returns the current key sequence.
    def key_sequence : KeySequence
      KeySequence.new(Qt6.copy_and_release_string(LibQt6.qt6cr_shortcut_key_sequence(to_unsafe)))
    end

    # Sets the key sequence and returns it.
    def key_sequence=(value : String | KeySequence) : KeySequence
      sequence = value.is_a?(KeySequence) ? value : KeySequence.new(value)
      LibQt6.qt6cr_shortcut_set_key_sequence(to_unsafe, sequence.to_s.to_unsafe)
      sequence
    end

    # Returns `true` when the shortcut is enabled.
    def enabled? : Bool
      LibQt6.qt6cr_shortcut_is_enabled(to_unsafe)
    end

    # Enables or disables the shortcut.
    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_shortcut_set_enabled(to_unsafe, value)
      value
    end

    # Returns `true` when auto-repeat is enabled.
    def auto_repeat? : Bool
      LibQt6.qt6cr_shortcut_auto_repeat(to_unsafe)
    end

    # Enables or disables shortcut auto-repeat.
    def auto_repeat=(value : Bool) : Bool
      LibQt6.qt6cr_shortcut_set_auto_repeat(to_unsafe, value)
      value
    end

    # Returns the shortcut context.
    def context : ShortcutContext
      ShortcutContext.from_value(LibQt6.qt6cr_shortcut_context(to_unsafe))
    end

    # Sets the shortcut context and returns it.
    def context=(value : ShortcutContext) : ShortcutContext
      LibQt6.qt6cr_shortcut_set_context(to_unsafe, value.value)
      value
    end

    # Returns the parent widget that owns the shortcut.
    def parent_widget : Widget?
      handle = LibQt6.qt6cr_shortcut_parent_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Registers a block for shortcut activation.
    def on_activated(&block : ->) : self
      @activated.connect { block.call }
      self
    end

    # Registers a block for ambiguous shortcut activation.
    def on_activated_ambiguously(&block : ->) : self
      @activated_ambiguously.connect { block.call }
      self
    end

    protected def emit_activated : Nil
      @activated.emit
    end

    protected def emit_activated_ambiguously : Nil
      @activated_ambiguously.emit
    end

    private ACTIVATED_TRAMPOLINE = ->(userdata : Void*) do
      Box(Shortcut).unbox(userdata).emit_activated
    end

    private ACTIVATED_AMBIGUOUSLY_TRAMPOLINE = ->(userdata : Void*) do
      Box(Shortcut).unbox(userdata).emit_activated_ambiguously
    end
  end
end
