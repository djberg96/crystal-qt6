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

    # Returns the item's current flags.
    def flags : ItemFlag
      ItemFlag.from_value(LibQt6.qt6cr_tree_widget_item_flags(to_unsafe))
    end

    # Sets the item's current flags.
    def flags=(value : ItemFlag) : ItemFlag
      LibQt6.qt6cr_tree_widget_item_set_flags(to_unsafe, value.value)
      value
    end

    # Returns the font for the first column.
    def font : QFont
      font(0)
    end

    # Returns the font for the given column.
    def font(column : Int) : QFont
      QFont.wrap(LibQt6.qt6cr_tree_widget_item_font(to_unsafe, column.to_i32), true)
    end

    # Sets the font for the first column.
    def font=(value : QFont) : QFont
      set_font(0, value)
    end

    # Sets the font for the given column and returns it.
    def set_font(column : Int, value : QFont) : QFont
      LibQt6.qt6cr_tree_widget_item_set_font(to_unsafe, column.to_i32, value.to_unsafe)
      value
    end

    # Returns the foreground color for the first column.
    def foreground : Color
      foreground(0)
    end

    # Returns the foreground color for the given column.
    def foreground(column : Int) : Color
      Color.from_native(LibQt6.qt6cr_tree_widget_item_foreground(to_unsafe, column.to_i32))
    end

    # Sets the foreground color for the first column.
    def foreground=(value : Color) : Color
      set_foreground(0, value)
    end

    # Sets the foreground color for the given column and returns it.
    def set_foreground(column : Int, value : Color) : Color
      LibQt6.qt6cr_tree_widget_item_set_foreground(to_unsafe, column.to_i32, value.to_native)
      value
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
