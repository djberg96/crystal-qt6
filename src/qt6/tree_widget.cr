module Qt6
  # Wraps `QTreeWidget` for hierarchical side panels and managers.
  class TreeWidget < Widget
    @current_item_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current item changes.
    getter current_item_changed : Signal()

    # Creates a tree widget with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tree_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_item_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tree_widget_on_current_item_changed(to_unsafe, CURRENT_ITEM_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the number of columns.
    def column_count : Int32
      LibQt6.qt6cr_tree_widget_column_count(to_unsafe)
    end

    # Sets the number of columns and returns it.
    def column_count=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_tree_widget_set_column_count(to_unsafe, int_value)
      int_value
    end

    # Returns the first header label.
    def header_label : String
      header_label(0)
    end

    # Returns the header label in the given column.
    def header_label(column : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tree_widget_header_label(to_unsafe, column.to_i32))
    end

    # Sets the first header label.
    def header_label=(value : String) : String
      set_header_label(0, value)
    end

    # Sets the header label in the given column.
    def set_header_label(column : Int, value : String) : String
      LibQt6.qt6cr_tree_widget_set_header_label(to_unsafe, column.to_i32, value.to_unsafe)
      value
    end

    # Returns whether the header is hidden.
    def header_hidden? : Bool
      LibQt6.qt6cr_tree_widget_header_hidden(to_unsafe)
    end

    # Shows or hides the header.
    def header_hidden=(value : Bool) : Bool
      LibQt6.qt6cr_tree_widget_set_header_hidden(to_unsafe, value)
      value
    end

    # Adds an existing top-level item and returns it.
    def add_top_level_item(item : TreeWidgetItem) : TreeWidgetItem
      LibQt6.qt6cr_tree_widget_add_top_level_item(to_unsafe, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Creates, adds, and returns a borrowed top-level item.
    def add_top_level_item(text : String) : TreeWidgetItem
      TreeWidgetItem.wrap(LibQt6.qt6cr_tree_widget_add_top_level_item_text(to_unsafe, text.to_unsafe))
    end

    # Appends a top-level item and returns `self`.
    def <<(item : TreeWidgetItem) : self
      add_top_level_item(item)
      self
    end

    # Returns the number of top-level items.
    def top_level_item_count : Int32
      LibQt6.qt6cr_tree_widget_top_level_item_count(to_unsafe)
    end

    # Returns the top-level item at the given index, if present.
    def top_level_item(index : Int) : TreeWidgetItem?
      handle = LibQt6.qt6cr_tree_widget_top_level_item(to_unsafe, index.to_i32)
      handle.null? ? nil : TreeWidgetItem.wrap(handle)
    end

    # Returns the current item, if any.
    def current_item : TreeWidgetItem?
      handle = LibQt6.qt6cr_tree_widget_current_item(to_unsafe)
      handle.null? ? nil : TreeWidgetItem.wrap(handle)
    end

    # Sets the current item and returns it.
    def current_item=(item : TreeWidgetItem) : TreeWidgetItem
      LibQt6.qt6cr_tree_widget_set_current_item(to_unsafe, item.to_unsafe)
      item
    end

    # Returns the current item's text in the first column.
    def current_item_text : String
      current_item_text(0)
    end

    # Returns the current item's text in the given column.
    def current_item_text(column : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tree_widget_current_item_text(to_unsafe, column.to_i32))
    end

    # Expands all nodes.
    def expand_all : self
      LibQt6.qt6cr_tree_widget_expand_all(to_unsafe)
      self
    end

    # Collapses all nodes.
    def collapse_all : self
      LibQt6.qt6cr_tree_widget_collapse_all(to_unsafe)
      self
    end

    # Removes all items.
    def clear : self
      LibQt6.qt6cr_tree_widget_clear(to_unsafe)
      self
    end

    # Registers a block to run when the current item changes.
    def on_current_item_changed(&block : ->) : self
      @current_item_changed.connect { block.call }
      self
    end

    protected def emit_current_item_changed : Nil
      @current_item_changed.emit
    end

    private CURRENT_ITEM_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(TreeWidget).unbox(userdata).emit_current_item_changed
    end
  end
end
