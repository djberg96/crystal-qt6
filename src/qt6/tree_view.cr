module Qt6
  # Wraps `QTreeView` for model-driven hierarchical displays.
  class TreeView < AbstractItemView
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
