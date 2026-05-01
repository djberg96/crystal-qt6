module Qt6
  # Wraps `QKeySequenceEdit`.
  class KeySequenceEdit < Widget
    @key_sequence_changed : Signal(KeySequence) = Signal(KeySequence).new
    @editing_finished : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter key_sequence_changed : Signal(KeySequence)
    getter editing_finished : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an empty key-sequence editor.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_key_sequence_edit_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    # Creates an editor preloaded with a shortcut.
    def initialize(key_sequence : KeySequence, parent : Widget? = nil)
      super(LibQt6.qt6cr_key_sequence_edit_create_with_sequence(key_sequence.to_s.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    # Returns the current shortcut value.
    def key_sequence : KeySequence
      KeySequence.new(Qt6.copy_and_release_string(LibQt6.qt6cr_key_sequence_edit_key_sequence(to_unsafe)))
    end

    # Sets the current shortcut and returns it.
    def key_sequence=(value : KeySequence) : KeySequence
      LibQt6.qt6cr_key_sequence_edit_set_key_sequence(to_unsafe, value.to_s.to_unsafe)
      value
    end

    # Convenience overload that accepts plain text.
    def key_sequence=(value : String) : KeySequence
      self.key_sequence = KeySequence.new(value)
    end

    # Qt-style alias for assigning the current shortcut.
    def set_key_sequence(value : KeySequence) : self
      self.key_sequence = value
      self
    end

    # Convenience overload for string shortcuts.
    def set_key_sequence(value : String) : self
      self.key_sequence = value
      self
    end

    # Returns `true` when the clear button is enabled.
    def clear_button_enabled? : Bool
      LibQt6.qt6cr_key_sequence_edit_clear_button_enabled(to_unsafe)
    end

    # Enables or disables the clear button.
    def clear_button_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_key_sequence_edit_set_clear_button_enabled(to_unsafe, value)
      value
    end

    # Clears the current shortcut.
    def clear : self
      LibQt6.qt6cr_key_sequence_edit_clear(to_unsafe)
      self
    end

    # Registers a block for shortcut changes.
    def on_key_sequence_changed(&block : KeySequence ->) : self
      @key_sequence_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block for editing completion.
    def on_editing_finished(&block : ->) : self
      @editing_finished.connect { block.call }
      self
    end

    protected def emit_key_sequence_changed(value : UInt8*) : Nil
      @key_sequence_changed.emit(KeySequence.new(Qt6.copy_string(value)))
    end

    protected def emit_editing_finished : Nil
      @editing_finished.emit
    end

    private def register_callbacks : Nil
      @key_sequence_changed = Signal(KeySequence).new
      @editing_finished = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_key_sequence_edit_on_key_sequence_changed(to_unsafe, KEY_SEQUENCE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_key_sequence_edit_on_editing_finished(to_unsafe, EDITING_FINISHED_TRAMPOLINE, @callback_userdata)
    end

    private KEY_SEQUENCE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(KeySequenceEdit).unbox(userdata).emit_key_sequence_changed(value)
    end

    private EDITING_FINISHED_TRAMPOLINE = ->(userdata : Void*) do
      Box(KeySequenceEdit).unbox(userdata).emit_editing_finished
    end
  end
end
