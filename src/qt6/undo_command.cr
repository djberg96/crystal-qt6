module Qt6
  # Crystal-backed command for use with `UndoStack`.
  class UndoCommand < NativeResource
    @redo_callback : Proc(Nil)?
    @undo_callback : Proc(Nil)?
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @owner_stack : UndoStack?

    # Creates an undo command with optional redo and undo callbacks.
    def initialize(text : String = "", redo : Proc(Nil)? = nil, undo : Proc(Nil)? = nil)
      super(LibQt6.qt6cr_undo_command_create(text.to_unsafe))
      @redo_callback = redo
      @undo_callback = undo
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_undo_command_set_callbacks(
        to_unsafe,
        REDO_TRAMPOLINE,
        @callback_userdata,
        UNDO_TRAMPOLINE,
        @callback_userdata,
        DESTROYED_TRAMPOLINE,
        @callback_userdata
      )
    end

    # Returns the command text shown by undo and redo actions.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_undo_command_text(to_unsafe))
    end

    # Sets the command text shown by undo and redo actions.
    def text=(value : String) : String
      LibQt6.qt6cr_undo_command_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Replaces the redo callback and returns `self`.
    def on_redo(&block : ->) : self
      @redo_callback = block
      self
    end

    # Replaces the undo callback and returns `self`.
    def on_undo(&block : ->) : self
      @undo_callback = block
      self
    end

    # Stops direct release after ownership moves to a native undo stack.
    def adopt_by_stack!(stack : UndoStack) : Nil
      return if destroyed?

      Qt6.untrack_object(self) if @owned
      @owned = false
      @owner_stack = stack
    end

    protected def mark_destroyed_from_qt : Nil
      return if destroyed?

      mark_destroyed
      @owner_stack.try(&.remove_command(self))
      @owner_stack = nil
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_undo_command_destroy(to_unsafe)
    end

    protected def emit_redo : Nil
      @redo_callback.try(&.call)
    end

    protected def emit_undo : Nil
      @undo_callback.try(&.call)
    end

    private REDO_TRAMPOLINE = ->(userdata : Void*) do
      Box(UndoCommand).unbox(userdata).emit_redo
    end

    private UNDO_TRAMPOLINE = ->(userdata : Void*) do
      Box(UndoCommand).unbox(userdata).emit_undo
    end

    private DESTROYED_TRAMPOLINE = ->(userdata : Void*) do
      Box(UndoCommand).unbox(userdata).mark_destroyed_from_qt
    end
  end
end
