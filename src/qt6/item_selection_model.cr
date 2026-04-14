module Qt6
  # Wraps `QItemSelectionModel` for reusable selection state across views.
  class ItemSelectionModel < QObject
    @current_index_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @current_index_callback_registered = false

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Signal emitted when the current index changes.
    getter current_index_changed : Signal()

    # Creates a selection model for the given item model.
    def initialize(model : AbstractItemModel, parent : QObject? = nil)
      super(LibQt6.qt6cr_item_selection_model_create(model.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      initialize_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      initialize_callbacks
    end

    # Returns the model that owns the current selection state, if any.
    def model : AbstractItemModel?
      handle = LibQt6.qt6cr_item_selection_model_model(to_unsafe)
      handle.null? ? nil : AbstractItemModel.wrap(handle)
    end

    # Returns the current index tracked by the selection model.
    def current_index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_item_selection_model_current_index(to_unsafe), true)
    end

    # Changes the current index using the provided selection command.
    def set_current_index(index : ModelIndex, command : SelectionFlag = SelectionFlag::Current) : ModelIndex
      LibQt6.qt6cr_item_selection_model_set_current_index(to_unsafe, index.to_unsafe, command.value)
      index
    end

    # Changes the current index and returns it.
    def current_index=(index : ModelIndex) : ModelIndex
      set_current_index(index)
    end

    # Applies a selection command to the given index and returns it.
    def select(index : ModelIndex, command : SelectionFlag = SelectionFlag::Select) : ModelIndex
      LibQt6.qt6cr_item_selection_model_select_index(to_unsafe, index.to_unsafe, command.value)
      index
    end

    # Clears the current index and selection state.
    def clear : self
      LibQt6.qt6cr_item_selection_model_clear(to_unsafe)
      self
    end

    # Clears only the current selection.
    def clear_selection : self
      LibQt6.qt6cr_item_selection_model_clear_selection(to_unsafe)
      self
    end

    # Returns whether the selection model currently holds any selected indexes.
    def has_selection? : Bool
      LibQt6.qt6cr_item_selection_model_has_selection(to_unsafe)
    end

    # Returns whether the given index is selected.
    def selected?(index : ModelIndex) : Bool
      LibQt6.qt6cr_item_selection_model_is_selected(to_unsafe, index.to_unsafe)
    end

    # Registers a block to run when the current index changes.
    def on_current_index_changed(&block : ->) : self
      register_current_index_callback
      @current_index_changed.connect { block.call }
      self
    end

    protected def emit_current_index_changed : Nil
      @current_index_changed.emit
    end

    private def initialize_callbacks : Nil
      @current_index_changed = Signal().new
      @callback_userdata = Pointer(Void).null
      @current_index_callback_registered = false
    end

    private def register_current_index_callback : Nil
      return if @current_index_callback_registered

      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_item_selection_model_on_current_index_changed(to_unsafe, CURRENT_INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
      @current_index_callback_registered = true
    end

    private CURRENT_INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(ItemSelectionModel).unbox(userdata).emit_current_index_changed
    end
  end
end
