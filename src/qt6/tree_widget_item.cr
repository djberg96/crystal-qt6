module Qt6
  # Wraps `QTreeWidgetItem` for hierarchical item panels.
  class TreeWidgetItem < NativeResource
    # Wraps an existing native item handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a tree item with optional text in the first column.
    def initialize(text : String = "")
      super(LibQt6.qt6cr_tree_widget_item_create(text.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the first-column text.
    def text : String
      text(0)
    end

    # Returns the text in the given column.
    def text(column : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tree_widget_item_text(to_unsafe, column.to_i32))
    end

    # Sets the first-column text.
    def text=(value : String) : String
      set_text(0, value)
    end

    # Sets the text in the given column.
    def set_text(column : Int, value : String) : String
      LibQt6.qt6cr_tree_widget_item_set_text(to_unsafe, column.to_i32, value.to_unsafe)
      value
    end

    # Adds a child item and returns it.
    def add_child(item : TreeWidgetItem) : TreeWidgetItem
      LibQt6.qt6cr_tree_widget_item_add_child(to_unsafe, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Appends a child item and returns `self`.
    def <<(item : TreeWidgetItem) : self
      add_child(item)
      self
    end

    # Returns the number of child items.
    def child_count : Int32
      LibQt6.qt6cr_tree_widget_item_child_count(to_unsafe)
    end

    # Returns the child item at the given index, if present.
    def child(index : Int) : TreeWidgetItem?
      handle = LibQt6.qt6cr_tree_widget_item_child(to_unsafe, index.to_i32)
      handle.null? ? nil : TreeWidgetItem.wrap(handle)
    end

    # Stops tracking the item after ownership moves to a native parent item or widget.
    def adopt_by_parent! : Nil
      return unless @owned

      Qt6.untrack_object(self)
      @owned = false
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_tree_widget_item_destroy(to_unsafe)
    end
  end
end