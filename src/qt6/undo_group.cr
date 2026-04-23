module Qt6
  # Coordinates undo and redo across multiple document-specific `UndoStack`s.
  class UndoGroup < QObject
    @stacks = [] of UndoStack
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @active_stack_changed : Signal(UndoStack?) = Signal(UndoStack?).new
    @can_undo_changed : Signal(Bool) = Signal(Bool).new
    @can_redo_changed : Signal(Bool) = Signal(Bool).new
    @clean_changed : Signal(Bool) = Signal(Bool).new
    @index_changed : Signal(Int32) = Signal(Int32).new
    @undo_text_changed : Signal(String) = Signal(String).new
    @redo_text_changed : Signal(String) = Signal(String).new

    getter active_stack_changed : Signal(UndoStack?)
    getter can_undo_changed : Signal(Bool)
    getter can_redo_changed : Signal(Bool)
    getter clean_changed : Signal(Bool)
    getter index_changed : Signal(Int32)
    getter undo_text_changed : Signal(String)
    getter redo_text_changed : Signal(String)

    # Creates an undo group, optionally parented to another `QObject`.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_undo_group_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    # Adds a stack to the group and returns it.
    def add_stack(stack : UndoStack) : UndoStack
      LibQt6.qt6cr_undo_group_add_stack(to_unsafe, stack.to_unsafe)
      @stacks << stack unless @stacks.includes?(stack)
      stack
    end

    # Adds a stack to the group and returns `self`.
    def <<(stack : UndoStack) : self
      add_stack(stack)
      self
    end

    # Removes a stack from the group.
    def remove_stack(stack : UndoStack) : UndoStack
      LibQt6.qt6cr_undo_group_remove_stack(to_unsafe, stack.to_unsafe)
      @stacks.reject! { |entry| entry.same?(stack) }
      stack
    end

    # Returns the Crystal wrappers currently added to the group.
    def stacks : Array(UndoStack)
      @stacks.dup
    end

    # Returns the currently active stack, if it is one of this group's stacks.
    def active_stack : UndoStack?
      stack_for(LibQt6.qt6cr_undo_group_active_stack(to_unsafe))
    end

    # Sets the active stack. Passing `nil` leaves the group with no active stack.
    def active_stack=(stack : UndoStack?) : UndoStack?
      add_stack(stack) if stack && !@stacks.includes?(stack)
      LibQt6.qt6cr_undo_group_set_active_stack(to_unsafe, stack.try(&.to_unsafe) || Pointer(Void).null)
      stack
    end

    # Undoes the current command on the active stack.
    def undo : self
      LibQt6.qt6cr_undo_group_undo(to_unsafe)
      self
    end

    # Redoes the current command on the active stack.
    def redo : self
      LibQt6.qt6cr_undo_group_redo(to_unsafe)
      self
    end

    # Returns `true` when the active stack has an undo step available.
    def can_undo? : Bool
      LibQt6.qt6cr_undo_group_can_undo(to_unsafe)
    end

    # Returns `true` when the active stack has a redo step available.
    def can_redo? : Bool
      LibQt6.qt6cr_undo_group_can_redo(to_unsafe)
    end

    # Returns `true` when the active stack is clean, or when there is no active stack.
    def clean? : Bool
      LibQt6.qt6cr_undo_group_is_clean(to_unsafe)
    end

    # Returns the text for the next undo step on the active stack.
    def undo_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_undo_group_undo_text(to_unsafe))
    end

    # Returns the text for the next redo step on the active stack.
    def redo_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_undo_group_redo_text(to_unsafe))
    end

    # Creates a QAction connected to the active stack's undo slot.
    def create_undo_action(parent : QObject = self, prefix : String = "") : Action
      Action.wrap(LibQt6.qt6cr_undo_group_create_undo_action(to_unsafe, parent.to_unsafe, prefix.to_unsafe))
    end

    # Creates a QAction connected to the active stack's redo slot.
    def create_redo_action(parent : QObject = self, prefix : String = "") : Action
      Action.wrap(LibQt6.qt6cr_undo_group_create_redo_action(to_unsafe, parent.to_unsafe, prefix.to_unsafe))
    end

    def on_active_stack_changed(&block : UndoStack? ->) : self
      @active_stack_changed.connect { |stack| block.call(stack) }
      self
    end

    def on_can_undo_changed(&block : Bool ->) : self
      @can_undo_changed.connect { |value| block.call(value) }
      self
    end

    def on_can_redo_changed(&block : Bool ->) : self
      @can_redo_changed.connect { |value| block.call(value) }
      self
    end

    def on_clean_changed(&block : Bool ->) : self
      @clean_changed.connect { |value| block.call(value) }
      self
    end

    def on_index_changed(&block : Int32 ->) : self
      @index_changed.connect { |value| block.call(value) }
      self
    end

    def on_undo_text_changed(&block : String ->) : self
      @undo_text_changed.connect { |value| block.call(value) }
      self
    end

    def on_redo_text_changed(&block : String ->) : self
      @redo_text_changed.connect { |value| block.call(value) }
      self
    end

    private def register_callbacks : Nil
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_undo_group_on_active_stack_changed(to_unsafe, ACTIVE_STACK_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_group_on_can_undo_changed(to_unsafe, CAN_UNDO_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_group_on_can_redo_changed(to_unsafe, CAN_REDO_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_group_on_clean_changed(to_unsafe, CLEAN_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_group_on_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_group_on_undo_text_changed(to_unsafe, UNDO_TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_group_on_redo_text_changed(to_unsafe, REDO_TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    private def stack_for(handle : LibQt6::Handle) : UndoStack?
      return nil if handle.null?

      @stacks.find { |stack| stack.to_unsafe == handle }
    end

    protected def emit_active_stack_changed(handle : LibQt6::Handle) : Nil
      @active_stack_changed.emit(stack_for(handle))
    end

    protected def emit_can_undo_changed(value : Bool) : Nil
      @can_undo_changed.emit(value)
    end

    protected def emit_can_redo_changed(value : Bool) : Nil
      @can_redo_changed.emit(value)
    end

    protected def emit_clean_changed(value : Bool) : Nil
      @clean_changed.emit(value)
    end

    protected def emit_index_changed(value : Int32) : Nil
      @index_changed.emit(value)
    end

    protected def emit_undo_text_changed(value : String) : Nil
      @undo_text_changed.emit(value)
    end

    protected def emit_redo_text_changed(value : String) : Nil
      @redo_text_changed.emit(value)
    end

    private ACTIVE_STACK_CHANGED_TRAMPOLINE = ->(userdata : Void*, stack : Void*) do
      Box(UndoGroup).unbox(userdata).emit_active_stack_changed(stack)
    end

    private CAN_UNDO_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(UndoGroup).unbox(userdata).emit_can_undo_changed(value)
    end

    private CAN_REDO_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(UndoGroup).unbox(userdata).emit_can_redo_changed(value)
    end

    private CLEAN_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(UndoGroup).unbox(userdata).emit_clean_changed(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : LibC::Int) do
      Box(UndoGroup).unbox(userdata).emit_index_changed(value)
    end

    private UNDO_TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(UndoGroup).unbox(userdata).emit_undo_text_changed(Qt6.copy_string(value))
    end

    private REDO_TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(UndoGroup).unbox(userdata).emit_redo_text_changed(Qt6.copy_string(value))
    end
  end
end
