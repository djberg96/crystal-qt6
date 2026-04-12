module Qt6
  # Wraps `QTreeView` for model-driven hierarchical displays.
  class TreeView < Widget
    @current_index_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current index changes.
    getter current_index_changed : Signal()

    # Creates a tree view with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tree_view_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tree_view_on_current_index_changed(to_unsafe, CURRENT_INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Assigns the backing model and returns it.
    def model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_tree_view_set_model(to_unsafe, model.to_unsafe)
      model
    end

    # Assigns the item delegate used for display/edit behavior.
    def item_delegate=(delegate : StyledItemDelegate) : StyledItemDelegate
      LibQt6.qt6cr_tree_view_set_item_delegate(to_unsafe, delegate.to_unsafe)
      delegate
    end

    # Returns the active selection model, if one is installed.
    def selection_model : ItemSelectionModel?
      handle = LibQt6.qt6cr_tree_view_selection_model(to_unsafe)
      handle.null? ? nil : ItemSelectionModel.wrap(handle)
    end

    # Assigns the selection model used by the view and returns it.
    def selection_model=(selection_model : ItemSelectionModel) : ItemSelectionModel
      LibQt6.qt6cr_tree_view_set_selection_model(to_unsafe, selection_model.to_unsafe)
      selection_model
    end

    # Returns the current model index.
    def current_index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_tree_view_current_index(to_unsafe), true)
    end

    # Changes the current model index and returns it.
    def current_index=(index : ModelIndex) : ModelIndex
      LibQt6.qt6cr_tree_view_set_current_index(to_unsafe, index.to_unsafe)
      index
    end

    # Returns whether the view can start drag operations.
    def drag_enabled? : Bool
      LibQt6.qt6cr_tree_view_drag_enabled(to_unsafe)
    end

    # Enables or disables drag initiation from the view.
    def drag_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_drag_enabled(to_unsafe, value)
      value
    end

    # Returns the current model/view drag/drop mode.
    def drag_drop_mode : ItemViewDragDropMode
      ItemViewDragDropMode.from_value(LibQt6.qt6cr_tree_view_drag_drop_mode(to_unsafe))
    end

    # Sets the current model/view drag/drop mode.
    def drag_drop_mode=(value : ItemViewDragDropMode) : ItemViewDragDropMode
      LibQt6.qt6cr_tree_view_set_drag_drop_mode(to_unsafe, value.value)
      value
    end

    # Returns the default drop action used by the view.
    def default_drop_action : DropAction
      DropAction.from_value(LibQt6.qt6cr_tree_view_default_drop_action(to_unsafe))
    end

    # Sets the default drop action used by the view.
    def default_drop_action=(value : DropAction) : DropAction
      LibQt6.qt6cr_tree_view_set_default_drop_action(to_unsafe, value.value)
      value
    end

    # Returns whether the drop indicator is shown while dragging.
    def drop_indicator_shown? : Bool
      LibQt6.qt6cr_tree_view_drop_indicator_shown(to_unsafe)
    end

    # Shows or hides the drop indicator while dragging.
    def drop_indicator_shown=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_drop_indicator_shown(to_unsafe, value)
      value
    end

    # Expands all visible branches.
    def expand_all : self
      LibQt6.qt6cr_tree_view_expand_all(to_unsafe)
      self
    end

    # Collapses all visible branches.
    def collapse_all : self
      LibQt6.qt6cr_tree_view_collapse_all(to_unsafe)
      self
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
      Box(TreeView).unbox(userdata).emit_current_index_changed
    end
  end
end
