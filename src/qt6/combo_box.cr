module Qt6
  # Wraps `QComboBox`.
  class ComboBox < Widget
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @current_text_changed : Signal(String) = Signal(String).new
    @edit_text_changed : Signal(String) = Signal(String).new
    @current_index_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @current_text_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @edit_text_changed_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_index_changed : Signal(Int32)
    getter current_text_changed : Signal(String)
    getter edit_text_changed : Signal(String)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an empty combo box.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_combo_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_combo_box_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_combo_box_callbacks
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
      int_value = value.to_i32
      LibQt6.qt6cr_combo_box_set_current_index(to_unsafe, int_value)
      int_value
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

    # Updates the editable text without requiring a matching item.
    def edit_text=(value : String) : String
      LibQt6.qt6cr_combo_box_set_edit_text(to_unsafe, value.to_unsafe)
      value
    end

    # Clears only the editable text content.
    def clear_edit_text : self
      LibQt6.qt6cr_combo_box_clear_edit_text(to_unsafe)
      self
    end

    # Returns the item text at the given index.
    def item_text(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_combo_box_item_text(to_unsafe, index.to_i32))
    end

    # Returns item data for the given index and role.
    def item_data(index : Int, role : ItemDataRole = ItemDataRole::User) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_combo_box_item_data(to_unsafe, index.to_i32, role.value))
    end

    # Sets item data for the given index and role.
    def set_item_data(index : Int, value, role : ItemDataRole = ItemDataRole::User) : self
      LibQt6.qt6cr_combo_box_set_item_data(to_unsafe, index.to_i32, role.value, Qt6.model_data_to_native(value))
      self
    end

    # Returns the selected item data for the given role.
    def current_data(role : ItemDataRole = ItemDataRole::User) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_combo_box_current_data(to_unsafe, role.value))
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

    # Returns the maximum number of rows visible when the popup opens.
    def max_visible_items : Int32
      LibQt6.qt6cr_combo_box_max_visible_items(to_unsafe)
    end

    # Sets the maximum number of rows visible when the popup opens.
    def max_visible_items=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_combo_box_set_max_visible_items(to_unsafe, int_value)
      int_value
    end

    # Returns the maximum number of items the combo box will retain.
    def max_count : Int32
      LibQt6.qt6cr_combo_box_max_count(to_unsafe)
    end

    # Sets the maximum number of items the combo box will retain.
    def max_count=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_combo_box_set_max_count(to_unsafe, int_value)
      int_value
    end

    # Returns `true` when duplicate entries are allowed.
    def duplicates_enabled? : Bool
      LibQt6.qt6cr_combo_box_duplicates_enabled(to_unsafe)
    end

    # Enables or disables duplicate entries.
    def duplicates_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_combo_box_set_duplicates_enabled(to_unsafe, value)
      value
    end

    # Returns `true` when the frame is drawn.
    def frame? : Bool
      LibQt6.qt6cr_combo_box_frame(to_unsafe)
    end

    # Shows or hides the combo box frame.
    def frame=(value : Bool) : Bool
      LibQt6.qt6cr_combo_box_set_frame(to_unsafe, value)
      value
    end

    # Returns the placeholder text shown for editable combos.
    def placeholder_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_combo_box_placeholder_text(to_unsafe))
    end

    # Sets the placeholder text shown for editable combos.
    def placeholder_text=(value : String) : String
      LibQt6.qt6cr_combo_box_set_placeholder_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the insert policy used for new editable entries.
    def insert_policy : ComboBoxInsertPolicy
      ComboBoxInsertPolicy.from_value(LibQt6.qt6cr_combo_box_insert_policy(to_unsafe))
    end

    # Sets the insert policy used for new editable entries.
    def insert_policy=(value : ComboBoxInsertPolicy) : ComboBoxInsertPolicy
      LibQt6.qt6cr_combo_box_set_insert_policy(to_unsafe, value.value)
      value
    end

    # Returns the size-adjust policy used by the combo box.
    def size_adjust_policy : ComboBoxSizeAdjustPolicy
      ComboBoxSizeAdjustPolicy.from_value(LibQt6.qt6cr_combo_box_size_adjust_policy(to_unsafe))
    end

    # Sets the size-adjust policy used by the combo box.
    def size_adjust_policy=(value : ComboBoxSizeAdjustPolicy) : ComboBoxSizeAdjustPolicy
      LibQt6.qt6cr_combo_box_set_size_adjust_policy(to_unsafe, value.value)
      value
    end

    # Returns the currently visible model column.
    def model_column : Int32
      LibQt6.qt6cr_combo_box_model_column(to_unsafe)
    end

    # Sets the currently visible model column.
    def model_column=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_combo_box_set_model_column(to_unsafe, int_value)
      int_value
    end

    # Returns the internal line edit for editable combos, if one exists.
    def line_edit : LineEdit?
      handle = LibQt6.qt6cr_combo_box_line_edit(to_unsafe)
      handle.null? ? nil : LineEdit.wrap(handle)
    end

    # Returns the attached completer, if any.
    def completer : Completer?
      handle = LibQt6.qt6cr_combo_box_completer(to_unsafe)
      handle.null? ? nil : Completer.wrap(handle)
    end

    # Sets the attached completer.
    def completer=(value : Completer) : Completer
      LibQt6.qt6cr_combo_box_set_completer(to_unsafe, value.to_unsafe)
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

    # Registers a block to run when the current text changes.
    def on_current_text_changed(&block : String ->) : self
      @current_text_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the editable text changes.
    def on_edit_text_changed(&block : String ->) : self
      @edit_text_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    protected def emit_current_text_changed(value : UInt8*) : Nil
      @current_text_changed.emit(Qt6.copy_string(value))
    end

    protected def emit_edit_text_changed(value : UInt8*) : Nil
      @edit_text_changed.emit(Qt6.copy_string(value))
    end

    private def register_combo_box_callbacks : Nil
      @current_index_changed = Signal(Int32).new
      @current_text_changed = Signal(String).new
      @edit_text_changed = Signal(String).new
      @current_index_changed_userdata = Box.box(self.as(ComboBox))
      @current_text_changed_userdata = Box.box(self.as(ComboBox))
      @edit_text_changed_userdata = Box.box(self.as(ComboBox))
      LibQt6.qt6cr_combo_box_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @current_index_changed_userdata)
      LibQt6.qt6cr_combo_box_on_current_text_changed(to_unsafe, CURRENT_TEXT_CHANGED_TRAMPOLINE, @current_text_changed_userdata)
      LibQt6.qt6cr_combo_box_on_edit_text_changed(to_unsafe, EDIT_TEXT_CHANGED_TRAMPOLINE, @edit_text_changed_userdata)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ComboBox).unbox(userdata).emit_current_index_changed(value)
    end

    private CURRENT_TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(ComboBox).unbox(userdata).emit_current_text_changed(value)
    end

    private EDIT_TEXT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(ComboBox).unbox(userdata).emit_edit_text_changed(value)
    end
  end
end
