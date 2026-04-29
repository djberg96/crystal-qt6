module Qt6
  # Wraps `QComboBox`.
  class ComboBox < Widget
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the selected index changes.
    getter current_index_changed : Signal(Int32)

    # Creates an empty combo box.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_combo_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_combo_box_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_combo_box_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Adds an item to the combo box.
    def add_item(text : String) : self
      LibQt6.qt6cr_combo_box_add_item(to_unsafe, text.to_unsafe)
      self
    end

    # Inserts an item at the requested index.
    def insert_item(index : Int, text : String) : self
      LibQt6.qt6cr_combo_box_insert_item(to_unsafe, index.to_i32, text.to_unsafe)
      self
    end

    # Removes the item at the requested index.
    def remove_item(index : Int) : self
      LibQt6.qt6cr_combo_box_remove_item(to_unsafe, index.to_i32)
      self
    end

    # Appends an item and returns `self`.
    def <<(text : String) : self
      add_item(text)
      self
    end

    # Returns the number of items in the combo box.
    def count : Int32
      LibQt6.qt6cr_combo_box_count(to_unsafe)
    end

    # Returns the selected index.
    def current_index : Int32
      LibQt6.qt6cr_combo_box_current_index(to_unsafe)
    end

    # Changes the selected index and returns the assigned value.
    def current_index=(value : Int) : Int32
      LibQt6.qt6cr_combo_box_set_current_index(to_unsafe, value)
      value.to_i
    end

    # Returns the selected item text.
    def current_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_combo_box_current_text(to_unsafe))
    end

    # Changes the selected text when possible and returns the assigned value.
    def current_text=(value : String) : String
      LibQt6.qt6cr_combo_box_set_current_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the item text at the given index.
    def item_text(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_combo_box_item_text(to_unsafe, index.to_i32))
    end

    # Returns the first matching item index, or `-1` when no item matches.
    def find_text(text : String) : Int32
      LibQt6.qt6cr_combo_box_find_text(to_unsafe, text.to_unsafe)
    end

    # Removes every item from the combo box.
    def clear : self
      LibQt6.qt6cr_combo_box_clear(to_unsafe)
      self
    end

    # Returns `true` when the combo box supports text editing.
    def editable? : Bool
      LibQt6.qt6cr_combo_box_editable(to_unsafe)
    end

    # Enables or disables inline text editing.
    def editable=(value : Bool) : Bool
      LibQt6.qt6cr_combo_box_set_editable(to_unsafe, value)
      value
    end

    # Qt-style alias for assigning the current text.
    def set_current_text(value : String) : self
      self.current_text = value
      self
    end

    # Registers a block to run when the selected index changes.
    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ComboBox).unbox(userdata).emit_current_index_changed(value)
    end
  end
end
