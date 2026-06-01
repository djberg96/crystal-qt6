module Qt6
  # Wraps `QTreeView` for model-driven hierarchical displays.
  class TreeView < AbstractItemView
    @current_index_changed : Signal() = Signal().new
    @expanded : Signal(ModelIndex) = Signal(ModelIndex).new
    @collapsed : Signal(ModelIndex) = Signal(ModelIndex).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current index changes.
    getter current_index_changed : Signal()
    getter expanded : Signal(ModelIndex)
    getter collapsed : Signal(ModelIndex)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a tree view with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tree_view_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      initialize_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      initialize_callbacks
    end

    private def initialize_callbacks : Nil
      @current_index_changed = Signal().new
      @expanded = Signal(ModelIndex).new
      @collapsed = Signal(ModelIndex).new
      @callback_userdata = Box.box(self.as(TreeView))
      LibQt6.qt6cr_tree_view_on_current_index_changed(to_unsafe, CURRENT_INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tree_view_on_expanded(to_unsafe, EXPANDED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tree_view_on_collapsed(to_unsafe, COLLAPSED_TRAMPOLINE, @callback_userdata)
    end

    # Assigns the backing model and returns it.
    def model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_tree_view_set_model(to_unsafe, model.to_unsafe)
      model
    end

    # Returns the header view controlling tree columns.
    def header : HeaderView
      HeaderView.wrap(LibQt6.qt6cr_tree_view_header(to_unsafe))
    end

    # Installs the header view and returns it.
    def header=(header : HeaderView) : HeaderView
      LibQt6.qt6cr_tree_view_set_header(to_unsafe, header.to_unsafe)
      header.adopt_by_parent!
      header
    end

    # Qt-style alias for `header=`.
    def set_header(header : HeaderView) : self
      self.header = header
      self
    end

    # Returns the auto-expand delay in milliseconds.
    def auto_expand_delay : Int32
      LibQt6.qt6cr_tree_view_auto_expand_delay(to_unsafe)
    end

    # Sets the auto-expand delay in milliseconds.
    def auto_expand_delay=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_tree_view_set_auto_expand_delay(to_unsafe, int_value)
      int_value
    end

    # Qt-style alias for `auto_expand_delay=`.
    def set_auto_expand_delay(value : Int) : self
      self.auto_expand_delay = value
      self
    end

    # Returns whether the header is hidden.
    def header_hidden? : Bool
      LibQt6.qt6cr_tree_view_header_hidden(to_unsafe)
    end

    # Shows or hides the header.
    def header_hidden=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_header_hidden(to_unsafe, value)
      value
    end

    # Returns whether root items draw expand/collapse decoration.
    def root_is_decorated? : Bool
      LibQt6.qt6cr_tree_view_root_is_decorated(to_unsafe)
    end

    # Enables or disables root item decoration.
    def root_is_decorated=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_root_is_decorated(to_unsafe, value)
      value
    end

    # Returns whether uniform row heights are enabled.
    def uniform_row_heights? : Bool
      LibQt6.qt6cr_tree_view_uniform_row_heights(to_unsafe)
    end

    # Enables or disables uniform row heights.
    def uniform_row_heights=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_uniform_row_heights(to_unsafe, value)
      value
    end

    # Returns the indentation used for each level.
    def indentation : Int32
      LibQt6.qt6cr_tree_view_indentation(to_unsafe)
    end

    # Sets the indentation used for each level.
    def indentation=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_tree_view_set_indentation(to_unsafe, int_value)
      int_value
    end

    # Restores Qt's default indentation behavior.
    def reset_indentation : self
      LibQt6.qt6cr_tree_view_reset_indentation(to_unsafe)
      self
    end

    # Returns whether items can be expanded interactively.
    def items_expandable? : Bool
      LibQt6.qt6cr_tree_view_items_expandable(to_unsafe)
    end

    # Enables or disables interactive item expansion.
    def items_expandable=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_items_expandable(to_unsafe, value)
      value
    end

    # Returns whether items expand on double click.
    def expands_on_double_click? : Bool
      LibQt6.qt6cr_tree_view_expands_on_double_click(to_unsafe)
    end

    # Enables or disables double-click expansion.
    def expands_on_double_click=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_expands_on_double_click(to_unsafe, value)
      value
    end

    # Returns the viewport x position for the given column.
    def column_viewport_position(column : Int) : Int32
      LibQt6.qt6cr_tree_view_column_viewport_position(to_unsafe, column.to_i32)
    end

    # Returns the width of the given column.
    def column_width(column : Int) : Int32
      LibQt6.qt6cr_tree_view_column_width(to_unsafe, column.to_i32)
    end

    # Sets the width of the given column.
    def set_column_width(column : Int, width : Int) : self
      LibQt6.qt6cr_tree_view_set_column_width(to_unsafe, column.to_i32, width.to_i32)
      self
    end

    # Returns the column at the given viewport x coordinate, or `-1`.
    def column_at(x : Int) : Int32
      LibQt6.qt6cr_tree_view_column_at(to_unsafe, x.to_i32)
    end

    # Returns whether the given column is hidden.
    def column_hidden?(column : Int) : Bool
      LibQt6.qt6cr_tree_view_column_hidden(to_unsafe, column.to_i32)
    end

    # Shows or hides the given column.
    def set_column_hidden(column : Int, value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_column_hidden(to_unsafe, column.to_i32, value)
      value
    end

    # Hides the given column.
    def hide_column(column : Int) : self
      self.set_column_hidden(column, true)
      self
    end

    # Shows the given column.
    def show_column(column : Int) : self
      self.set_column_hidden(column, false)
      self
    end

    # Returns whether the given row is hidden beneath the supplied parent.
    def row_hidden?(row : Int, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_tree_view_row_hidden(to_unsafe, row.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    # Shows or hides the given row beneath the supplied parent.
    def set_row_hidden(row : Int, value : Bool, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_tree_view_set_row_hidden(to_unsafe, row.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null, value)
      value
    end

    # Returns whether the first column is spanned for the row beneath the supplied parent.
    def first_column_spanned?(row : Int, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_tree_view_first_column_spanned(to_unsafe, row.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    # Enables or disables first-column spanning for the row beneath the supplied parent.
    def set_first_column_spanned(row : Int, value : Bool, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_tree_view_set_first_column_spanned(to_unsafe, row.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null, value)
      value
    end

    # Expands the branch at the given index.
    def expand(index : ModelIndex) : self
      LibQt6.qt6cr_tree_view_expand(to_unsafe, index.to_unsafe)
      self
    end

    # Collapses the branch at the given index.
    def collapse(index : ModelIndex) : self
      LibQt6.qt6cr_tree_view_collapse(to_unsafe, index.to_unsafe)
      self
    end

    # Expands or collapses the branch at the given index.
    def set_expanded(index : ModelIndex, value : Bool) : self
      LibQt6.qt6cr_tree_view_set_expanded(to_unsafe, index.to_unsafe, value)
      self
    end

    # Returns whether the branch at the given index is expanded.
    def expanded?(index : ModelIndex) : Bool
      LibQt6.qt6cr_tree_view_is_expanded(to_unsafe, index.to_unsafe)
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

    # Expands the given branch and its descendants up to the requested depth.
    def expand_recursively(index : ModelIndex, depth : Int = -1) : self
      LibQt6.qt6cr_tree_view_expand_recursively(to_unsafe, index.to_unsafe, depth.to_i32)
      self
    end

    # Expands all items through the given depth.
    def expand_to_depth(depth : Int) : self
      LibQt6.qt6cr_tree_view_expand_to_depth(to_unsafe, depth.to_i32)
      self
    end

    # Returns whether sorting is enabled.
    def sorting_enabled? : Bool
      LibQt6.qt6cr_tree_view_sorting_enabled(to_unsafe)
    end

    # Enables or disables sorting.
    def sorting_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_sorting_enabled(to_unsafe, value)
      value
    end

    # Sorts rows by the given column and order.
    def sort_by_column(column : Int, order : SortOrder = SortOrder::Ascending) : self
      LibQt6.qt6cr_tree_view_sort_by_column(to_unsafe, column.to_i32, order.value)
      self
    end

    # Returns whether animated branch expansion is enabled.
    def animated? : Bool
      LibQt6.qt6cr_tree_view_animated(to_unsafe)
    end

    # Enables or disables animated branch expansion.
    def animated=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_animated(to_unsafe, value)
      value
    end

    # Returns whether all columns show focus.
    def all_columns_show_focus? : Bool
      LibQt6.qt6cr_tree_view_all_columns_show_focus(to_unsafe)
    end

    # Enables or disables focus painting across all columns.
    def all_columns_show_focus=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_all_columns_show_focus(to_unsafe, value)
      value
    end

    # Returns whether tree cells wrap text.
    def word_wrap? : Bool
      LibQt6.qt6cr_tree_view_word_wrap(to_unsafe)
    end

    # Enables or disables text wrapping.
    def word_wrap=(value : Bool) : Bool
      LibQt6.qt6cr_tree_view_set_word_wrap(to_unsafe, value)
      value
    end

    # Returns the logical column that draws the tree decoration.
    def tree_position : Int32
      LibQt6.qt6cr_tree_view_tree_position(to_unsafe)
    end

    # Sets the logical column that draws the tree decoration.
    def tree_position=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_tree_view_set_tree_position(to_unsafe, int_value)
      int_value
    end

    # Performs keyboard search within the view.
    def keyboard_search(search : String) : self
      LibQt6.qt6cr_tree_view_keyboard_search(to_unsafe, search.to_unsafe)
      self
    end

    # Returns the index immediately above the given one.
    def index_above(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_tree_view_index_above(to_unsafe, index.to_unsafe), true)
    end

    # Returns the index immediately below the given one.
    def index_below(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_tree_view_index_below(to_unsafe, index.to_unsafe), true)
    end

    # Lays out visible items again.
    def do_items_layout : self
      LibQt6.qt6cr_tree_view_do_items_layout(to_unsafe)
      self
    end

    # Resets the view state from the current model.
    def reset : self
      LibQt6.qt6cr_tree_view_reset(to_unsafe)
      self
    end

    # Resizes the given column to fit its contents.
    def resize_column_to_contents(column : Int) : self
      LibQt6.qt6cr_tree_view_resize_column_to_contents(to_unsafe, column.to_i32)
      self
    end

    # Registers a block to run when the current index changes.
    def on_current_index_changed(&block : ->) : self
      @current_index_changed.connect { block.call }
      self
    end

    # Registers a block to run when an index expands.
    def on_expanded(&block : ModelIndex ->) : self
      @expanded.connect { |index| block.call(index) }
      self
    end

    # Registers a block to run when an index collapses.
    def on_collapsed(&block : ModelIndex ->) : self
      @collapsed.connect { |index| block.call(index) }
      self
    end

    protected def emit_current_index_changed : Nil
      @current_index_changed.emit
    end

    protected def emit_expanded(handle : LibQt6::Handle) : Nil
      @expanded.emit(ModelIndex.wrap(handle, true))
    end

    protected def emit_collapsed(handle : LibQt6::Handle) : Nil
      @collapsed.emit(ModelIndex.wrap(handle, true))
    end

    private CURRENT_INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(TreeView).unbox(userdata).emit_current_index_changed
    end

    private EXPANDED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(TreeView).unbox(userdata).emit_expanded(handle)
    end

    private COLLAPSED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(TreeView).unbox(userdata).emit_collapsed(handle)
    end
  end
end
