module Qt6
  class ShortcutEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(key : String | KeySequence, id : Int32, ambiguous : Bool = false)
      sequence = key.is_a?(KeySequence) ? key : KeySequence.new(key)
      super(LibQt6.qt6cr_shortcut_event_create(sequence.to_s.to_unsafe, id, ambiguous), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def key : KeySequence
      KeySequence.new(Qt6.copy_and_release_string(LibQt6.qt6cr_shortcut_event_key(to_unsafe)))
    end

    def shortcut_id : Int32
      LibQt6.qt6cr_shortcut_event_shortcut_id(to_unsafe)
    end

    def ambiguous? : Bool
      LibQt6.qt6cr_shortcut_event_is_ambiguous(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_shortcut_event_destroy(to_unsafe)
    end
  end
end
