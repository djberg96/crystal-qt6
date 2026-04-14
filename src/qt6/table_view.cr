module Qt6
  # Wraps `QTableView` for model-driven tabular displays.
  class TableView < Widget
    @current_index_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current index changes.
    getter current_index_changed : Signal()

    # Creates a table view with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_table_view_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_table_view_on_current_index_changed(to_unsafe, CURRENT_INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Assigns the backing model and returns it.
    def model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_table_view_set_model(to_unsafe, model.to_unsafe)
      model
    end

    # Assigns the item delegate used for display/edit behavior.
    def item_delegate=(delegate : StyledItemDelegate) : StyledItemDelegate
      LibQt6.qt6cr_table_view_set_item_delegate(to_unsafe, delegate.to_unsafe)
      delegate
    end

    # Returns the active selection model, if one is installed.
    def selection_model : ItemSelectionModel?
      handle = LibQt6.qt6cr_table_view_selection_model(to_unsafe)
      handle.null? ? nil : ItemSelectionModel.wrap(handle)
    end

    # Assigns the selection model used by the view and returns it.
    def selection_model=(selection_model : ItemSelectionModel) : ItemSelectionModel
      LibQt6.qt6cr_table_view_set_selection_model(to_unsafe, selection_model.to_unsafe)
      selection_model
    end

    # Returns the current model index.
    def current_index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_table_view_current_index(to_unsafe), true)
    end

    # Changes the current model index and returns it.
    def current_index=(index : ModelIndex) : ModelIndex
      LibQt6.qt6cr_table_view_set_current_index(to_unsafe, index.to_unsafe)
      index
    end

    # Returns the current selection mode.
    def selection_mode : ItemSelectionMode
      ItemSelectionMode.from_value(LibQt6.qt6cr_table_view_selection_mode(to_unsafe))
    end

    # Sets the current selection mode.
    def selection_mode=(value : ItemSelectionMode) : ItemSelectionMode
      LibQt6.qt6cr_table_view_set_selection_mode(to_unsafe, value.value)
      value
    end

    # Returns how selections expand across table cells.
    def selection_behavior : ItemSelectionBehavior
      ItemSelectionBehavior.from_value(LibQt6.qt6cr_table_view_selection_behavior(to_unsafe))
    end

    # Sets how selections expand across table cells.
    def selection_behavior=(value : ItemSelectionBehavior) : ItemSelectionBehavior
      LibQt6.qt6cr_table_view_set_selection_behavior(to_unsafe, value.value)
      value
    end

    # Returns whether alternating row colors are enabled.
    def alternating_row_colors? : Bool
      LibQt6.qt6cr_table_view_alternating_row_colors(to_unsafe)
    end

    # Enables or disables alternating row colors.
    def alternating_row_colors=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_alternating_row_colors(to_unsafe, value)
      value
    end

    # Returns whether the view can start drag operations.
    def drag_enabled? : Bool
      LibQt6.qt6cr_table_view_drag_enabled(to_unsafe)
    end

    # Enables or disables drag initiation from the view.
    def drag_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_drag_enabled(to_unsafe, value)
      value
    end

    # Returns the current model/view drag/drop mode.
    def drag_drop_mode : ItemViewDragDropMode
      ItemViewDragDropMode.from_value(LibQt6.qt6cr_table_view_drag_drop_mode(to_unsafe))
    end

    # Sets the current model/view drag/drop mode.
    def drag_drop_mode=(value : ItemViewDragDropMode) : ItemViewDragDropMode
      LibQt6.qt6cr_table_view_set_drag_drop_mode(to_unsafe, value.value)
      value
    end

    # Returns the default drop action used by the view.
    def default_drop_action : DropAction
      DropAction.from_value(LibQt6.qt6cr_table_view_default_drop_action(to_unsafe))
    end

    # Sets the default drop action used by the view.
    def default_drop_action=(value : DropAction) : DropAction
      LibQt6.qt6cr_table_view_set_default_drop_action(to_unsafe, value.value)
      value
    end

    # Returns whether the drop indicator is shown while dragging.
    def drop_indicator_shown? : Bool
      LibQt6.qt6cr_table_view_drop_indicator_shown(to_unsafe)
    end

    # Shows or hides the drop indicator while dragging.
    def drop_indicator_shown=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_drop_indicator_shown(to_unsafe, value)
      value
    end

    # Returns whether the cell grid is drawn.
    def show_grid? : Bool
      LibQt6.qt6cr_table_view_show_grid(to_unsafe)
    end

    # Enables or disables cell grid drawing.
    def show_grid=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_show_grid(to_unsafe, value)
      value
    end

    # Returns whether cell text is wrapped.
    def word_wrap? : Bool
      LibQt6.qt6cr_table_view_word_wrap(to_unsafe)
    end

    # Enables or disables cell text wrapping.
    def word_wrap=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_word_wrap(to_unsafe, value)
      value
    end

    # Returns whether sorting is enabled.
    def sorting_enabled? : Bool
      LibQt6.qt6cr_table_view_sorting_enabled(to_unsafe)
    end

    # Enables or disables built-in sorting.
    def sorting_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_table_view_set_sorting_enabled(to_unsafe, value)
      value
    end

    # Returns the horizontal header view.
    def horizontal_header : HeaderView
      HeaderView.wrap(LibQt6.qt6cr_table_view_horizontal_header(to_unsafe))
    end

    # Returns the vertical header view.
    def vertical_header : HeaderView
      HeaderView.wrap(LibQt6.qt6cr_table_view_vertical_header(to_unsafe))
    end

    # Sets a visual span for the given cell.
    def set_span(row : Int, column : Int, row_span : Int, column_span : Int) : self
      LibQt6.qt6cr_table_view_set_span(to_unsafe, row.to_i32, column.to_i32, row_span.to_i32, column_span.to_i32)
      self
    end

    # Returns the current visual row span for the given cell.
    def row_span(row : Int, column : Int) : Int32
      LibQt6.qt6cr_table_view_row_span(to_unsafe, row.to_i32, column.to_i32)
    end

    # Returns the current visual column span for the given cell.
    def column_span(row : Int, column : Int) : Int32
      LibQt6.qt6cr_table_view_column_span(to_unsafe, row.to_i32, column.to_i32)
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
      Box(TableView).unbox(userdata).emit_current_index_changed
    end
  end
end
