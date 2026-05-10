module Qt6
  # Wraps `QListView` for model-driven list displays.
  class ListView < AbstractItemView
    @current_index_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current index changes.
    getter current_index_changed : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a list view with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_list_view_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    # Assigns the backing model and returns it.
    def model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_list_view_set_model(to_unsafe, model.to_unsafe)
      model
    end

    # Returns the layout flow used to place items.
    def flow : ListViewFlow
      ListViewFlow.from_value(LibQt6.qt6cr_list_view_flow(to_unsafe))
    end

    # Sets the layout flow used to place items.
    def flow=(value : ListViewFlow) : ListViewFlow
      LibQt6.qt6cr_list_view_set_flow(to_unsafe, value.value)
      value
    end

    # Returns `true` when items wrap into additional rows or columns.
    def wrapping? : Bool
      LibQt6.qt6cr_list_view_is_wrapping(to_unsafe)
    end

    # Enables or disables wrapping into additional rows or columns.
    def wrapping=(value : Bool) : Bool
      LibQt6.qt6cr_list_view_set_wrapping(to_unsafe, value)
      value
    end

    # Returns how the view reacts when its geometry changes.
    def resize_mode : ListViewResizeMode
      ListViewResizeMode.from_value(LibQt6.qt6cr_list_view_resize_mode(to_unsafe))
    end

    # Sets how the view reacts when its geometry changes.
    def resize_mode=(value : ListViewResizeMode) : ListViewResizeMode
      LibQt6.qt6cr_list_view_set_resize_mode(to_unsafe, value.value)
      value
    end

    # Returns the layout strategy used when placing items.
    def layout_mode : ListViewLayoutMode
      ListViewLayoutMode.from_value(LibQt6.qt6cr_list_view_layout_mode(to_unsafe))
    end

    # Sets the layout strategy used when placing items.
    def layout_mode=(value : ListViewLayoutMode) : ListViewLayoutMode
      LibQt6.qt6cr_list_view_set_layout_mode(to_unsafe, value.value)
      value
    end

    # Returns the overall presentation mode.
    def view_mode : ListViewViewMode
      ListViewViewMode.from_value(LibQt6.qt6cr_list_view_view_mode(to_unsafe))
    end

    # Sets the overall presentation mode.
    def view_mode=(value : ListViewViewMode) : ListViewViewMode
      LibQt6.qt6cr_list_view_set_view_mode(to_unsafe, value.value)
      value
    end

    # Returns how items may be moved within the view.
    def movement : ListViewMovement
      ListViewMovement.from_value(LibQt6.qt6cr_list_view_movement(to_unsafe))
    end

    # Sets how items may be moved within the view.
    def movement=(value : ListViewMovement) : ListViewMovement
      LibQt6.qt6cr_list_view_set_movement(to_unsafe, value.value)
      value
    end

    # Returns the spacing between laid-out items.
    def spacing : Int32
      LibQt6.qt6cr_list_view_spacing(to_unsafe)
    end

    # Sets the spacing between laid-out items.
    def spacing=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_list_view_set_spacing(to_unsafe, int_value)
      int_value
    end

    # Returns the grid size used for item placement.
    def grid_size : Size
      Size.from_native(LibQt6.qt6cr_list_view_grid_size(to_unsafe))
    end

    # Sets the grid size used for item placement.
    def grid_size=(value : Size) : Size
      LibQt6.qt6cr_list_view_set_grid_size(to_unsafe, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    # Returns which model column is shown by the view.
    def model_column : Int32
      LibQt6.qt6cr_list_view_model_column(to_unsafe)
    end

    # Sets which model column is shown by the view.
    def model_column=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_list_view_set_model_column(to_unsafe, int_value)
      int_value
    end

    # Returns `true` when all items are assumed to share the same size.
    def uniform_item_sizes? : Bool
      LibQt6.qt6cr_list_view_uniform_item_sizes(to_unsafe)
    end

    # Enables or disables uniform item-size assumptions.
    def uniform_item_sizes=(value : Bool) : Bool
      LibQt6.qt6cr_list_view_set_uniform_item_sizes(to_unsafe, value)
      value
    end

    # Returns `true` when item text may wrap onto multiple lines.
    def word_wrap? : Bool
      LibQt6.qt6cr_list_view_word_wrap(to_unsafe)
    end

    # Enables or disables item text wrapping.
    def word_wrap=(value : Bool) : Bool
      LibQt6.qt6cr_list_view_set_word_wrap(to_unsafe, value)
      value
    end

    # Returns `true` when rubber-band selection rectangles are shown.
    def selection_rect_visible? : Bool
      LibQt6.qt6cr_list_view_selection_rect_visible(to_unsafe)
    end

    # Shows or hides rubber-band selection rectangles.
    def selection_rect_visible=(value : Bool) : Bool
      LibQt6.qt6cr_list_view_set_selection_rect_visible(to_unsafe, value)
      value
    end

    # Returns the batch size used during batched layout.
    def batch_size : Int32
      LibQt6.qt6cr_list_view_batch_size(to_unsafe)
    end

    # Sets the batch size used during batched layout.
    def batch_size=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_list_view_set_batch_size(to_unsafe, int_value)
      int_value
    end

    # Returns `true` when the given row is hidden.
    def row_hidden?(row : Int) : Bool
      LibQt6.qt6cr_list_view_is_row_hidden(to_unsafe, row.to_i32)
    end

    # Shows or hides the given row.
    def set_row_hidden(row : Int, value : Bool) : self
      LibQt6.qt6cr_list_view_set_row_hidden(to_unsafe, row.to_i32, value)
      self
    end

    # Opens a persistent editor for the given index.
    def open_persistent_editor(index : ModelIndex) : self
      LibQt6.qt6cr_list_view_open_persistent_editor(to_unsafe, index.to_unsafe)
      self
    end

    # Closes a persistent editor for the given index.
    def close_persistent_editor(index : ModelIndex) : self
      LibQt6.qt6cr_list_view_close_persistent_editor(to_unsafe, index.to_unsafe)
      self
    end

    # Returns `true` when the given index currently has a persistent editor.
    def persistent_editor_open?(index : ModelIndex) : Bool
      LibQt6.qt6cr_list_view_is_persistent_editor_open(to_unsafe, index.to_unsafe)
    end

    # Qt-style alias for `flow=`.
    def set_flow(value : ListViewFlow) : self
      self.flow = value
      self
    end

    # Qt-style alias for `wrapping=`.
    def set_wrapping(value : Bool) : self
      self.wrapping = value
      self
    end

    # Qt-style alias for `resize_mode=`.
    def set_resize_mode(value : ListViewResizeMode) : self
      self.resize_mode = value
      self
    end

    # Qt-style alias for `layout_mode=`.
    def set_layout_mode(value : ListViewLayoutMode) : self
      self.layout_mode = value
      self
    end

    # Qt-style alias for `view_mode=`.
    def set_view_mode(value : ListViewViewMode) : self
      self.view_mode = value
      self
    end

    # Qt-style alias for `movement=`.
    def set_movement(value : ListViewMovement) : self
      self.movement = value
      self
    end

    # Qt-style alias for `spacing=`.
    def set_spacing(value : Int) : self
      self.spacing = value
      self
    end

    # Qt-style alias for `grid_size=`.
    def set_grid_size(value : Size) : self
      self.grid_size = value
      self
    end

    # Qt-style alias for `model_column=`.
    def set_model_column(value : Int) : self
      self.model_column = value
      self
    end

    # Qt-style alias for `uniform_item_sizes=`.
    def set_uniform_item_sizes(value : Bool) : self
      self.uniform_item_sizes = value
      self
    end

    # Qt-style alias for `word_wrap=`.
    def set_word_wrap(value : Bool) : self
      self.word_wrap = value
      self
    end

    # Qt-style alias for `selection_rect_visible=`.
    def set_selection_rect_visible(value : Bool) : self
      self.selection_rect_visible = value
      self
    end

    # Qt-style alias for `batch_size=`.
    def set_batch_size(value : Int) : self
      self.batch_size = value
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

    private def register_callbacks : Nil
      @current_index_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_list_view_on_current_index_changed(to_unsafe, CURRENT_INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    private CURRENT_INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(ListView).unbox(userdata).emit_current_index_changed
    end
  end
end
