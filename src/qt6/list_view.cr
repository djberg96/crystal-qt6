module Qt6
  # Wraps `QListView` for model-driven list displays.
  class ListView < Widget
    @current_index_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current index changes.
    getter current_index_changed : Signal()

    # Creates a list view with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_list_view_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_list_view_on_current_index_changed(to_unsafe, CURRENT_INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Assigns the backing model and returns it.
    def model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_list_view_set_model(to_unsafe, model.to_unsafe)
      model
    end

    # Assigns the item delegate used for display/edit behavior.
    def item_delegate=(delegate : StyledItemDelegate) : StyledItemDelegate
      LibQt6.qt6cr_list_view_set_item_delegate(to_unsafe, delegate.to_unsafe)
      delegate
    end

    # Returns the active selection model, if one is installed.
    def selection_model : ItemSelectionModel?
      handle = LibQt6.qt6cr_list_view_selection_model(to_unsafe)
      handle.null? ? nil : ItemSelectionModel.wrap(handle)
    end

    # Assigns the selection model used by the view and returns it.
    def selection_model=(selection_model : ItemSelectionModel) : ItemSelectionModel
      LibQt6.qt6cr_list_view_set_selection_model(to_unsafe, selection_model.to_unsafe)
      selection_model
    end

    # Returns the current model index.
    def current_index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_list_view_current_index(to_unsafe), true)
    end

    # Changes the current model index and returns it.
    def current_index=(index : ModelIndex) : ModelIndex
      LibQt6.qt6cr_list_view_set_current_index(to_unsafe, index.to_unsafe)
      index
    end

    # Registers a block to run when the current index changes.
    def on_current_index_changed(&block : ->) : self
      @current_index_changed.connect { block.call }
      self
    end

    protected def emit_current_index_changed : Nil
      @current_index_changed.emit
    end

    private CURRENT_INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(ListView).unbox(userdata).emit_current_index_changed
    end
  end
end
