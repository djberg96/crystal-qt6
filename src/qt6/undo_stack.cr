module Qt6
  # Wraps `QUndoStack` for application-level undo/redo history.
  class UndoStack < QObject
    @commands = [] of UndoCommand
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @can_undo_changed : Signal(Bool) = Signal(Bool).new
    @can_redo_changed : Signal(Bool) = Signal(Bool).new
    @clean_changed : Signal(Bool) = Signal(Bool).new
    @index_changed : Signal(Int32) = Signal(Int32).new
    @undo_text_changed : Signal(String) = Signal(String).new
    @redo_text_changed : Signal(String) = Signal(String).new

    getter can_undo_changed : Signal(Bool)
    getter can_redo_changed : Signal(Bool)
    getter clean_changed : Signal(Bool)
    getter index_changed : Signal(Int32)
    getter undo_text_changed : Signal(String)
    getter redo_text_changed : Signal(String)

    # Creates an undo stack, optionally parented to another `QObject`.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_undo_stack_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    # Pushes a command onto the stack. Qt takes ownership and invokes `redo`.
    def push(command : UndoCommand) : UndoCommand
      LibQt6.qt6cr_undo_stack_push(to_unsafe, command.to_unsafe)
      command.adopt_by_stack!(self)
      @commands << command unless @commands.includes?(command)
      command
    end

    # Removes all commands from the stack.
    def clear : self
      LibQt6.qt6cr_undo_stack_clear(to_unsafe)
      @commands.clear
      self
    end

    # Undoes the current command.
    def undo : self
      LibQt6.qt6cr_undo_stack_undo(to_unsafe)
      self
    end

    # Redoes the current command.
    def redo : self
      LibQt6.qt6cr_undo_stack_redo(to_unsafe)
      self
    end

    # Returns `true` when an undo step is available.
    def can_undo? : Bool
      LibQt6.qt6cr_undo_stack_can_undo(to_unsafe)
    end

    # Returns `true` when a redo step is available.
    def can_redo? : Bool
      LibQt6.qt6cr_undo_stack_can_redo(to_unsafe)
    end

    # Returns `true` when the current index is the clean index.
    def clean? : Bool
      LibQt6.qt6cr_undo_stack_is_clean(to_unsafe)
    end

    # Marks the current index as clean.
    def set_clean : self
      LibQt6.qt6cr_undo_stack_set_clean(to_unsafe)
      self
    end

    # Clears the clean index.
    def reset_clean : self
      LibQt6.qt6cr_undo_stack_reset_clean(to_unsafe)
      self
    end

    # Returns the number of commands on the stack.
    def count : Int32
      LibQt6.qt6cr_undo_stack_count(to_unsafe)
    end

    # Returns the current stack index.
    def index : Int32
      LibQt6.qt6cr_undo_stack_index(to_unsafe)
    end

    # Returns the clean index, or `-1` when no clean index is set.
    def clean_index : Int32
      LibQt6.qt6cr_undo_stack_clean_index(to_unsafe)
    end

    # Returns the maximum number of commands retained by the stack.
    def undo_limit : Int32
      LibQt6.qt6cr_undo_stack_undo_limit(to_unsafe)
    end

    # Sets the maximum number of commands retained by the stack.
    def undo_limit=(value : Int) : Int32
      LibQt6.qt6cr_undo_stack_set_undo_limit(to_unsafe, value.to_i32)
      value.to_i32
    end

    # Returns `true` when this is the active undo stack.
    def active? : Bool
      LibQt6.qt6cr_undo_stack_is_active(to_unsafe)
    end

    # Sets whether this is the active undo stack.
    def active=(value : Bool) : Bool
      LibQt6.qt6cr_undo_stack_set_active(to_unsafe, value)
      value
    end

    # Returns the text for the next undo step.
    def undo_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_undo_stack_undo_text(to_unsafe))
    end

    # Returns the text for the next redo step.
    def redo_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_undo_stack_redo_text(to_unsafe))
    end

    # Begins a macro command that groups subsequent pushes.
    def begin_macro(text : String) : self
      LibQt6.qt6cr_undo_stack_begin_macro(to_unsafe, text.to_unsafe)
      self
    end

    # Ends the current macro command.
    def end_macro : self
      LibQt6.qt6cr_undo_stack_end_macro(to_unsafe)
      self
    end

    # Creates a QAction connected to this stack's undo slot.
    def create_undo_action(parent : QObject = self, prefix : String = "") : Action
      Action.wrap(LibQt6.qt6cr_undo_stack_create_undo_action(to_unsafe, parent.to_unsafe, prefix.to_unsafe))
    end

    # Creates a QAction connected to this stack's redo slot.
    def create_redo_action(parent : QObject = self, prefix : String = "") : Action
      Action.wrap(LibQt6.qt6cr_undo_stack_create_redo_action(to_unsafe, parent.to_unsafe, prefix.to_unsafe))
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

    def remove_command(command : UndoCommand) : Nil
      @commands.reject! { |entry| entry.same?(command) }
    end

    private def register_callbacks : Nil
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_undo_stack_on_can_undo_changed(to_unsafe, CAN_UNDO_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_stack_on_can_redo_changed(to_unsafe, CAN_REDO_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_stack_on_clean_changed(to_unsafe, CLEAN_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_stack_on_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_stack_on_undo_text_changed(to_unsafe, UNDO_TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_undo_stack_on_redo_text_changed(to_unsafe, REDO_TEXT_CHANGED_TRAMPOLINE, @callback_userdata)
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

    private CAN_UNDO_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(UndoStack).unbox(userdata).emit_can_undo_changed(value)
    end

    private CAN_REDO_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(UndoStack).unbox(userdata).emit_can_redo_changed(value)
    end

    private CLEAN_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(UndoStack).unbox(userdata).emit_clean_changed(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : LibC::Int) do
      Box(UndoStack).unbox(userdata).emit_index_changed(value)
    end

    private UNDO_TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(UndoStack).unbox(userdata).emit_undo_text_changed(Qt6.copy_string(value))
    end

    private REDO_TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(UndoStack).unbox(userdata).emit_redo_text_changed(Qt6.copy_string(value))
    end
  end
end
