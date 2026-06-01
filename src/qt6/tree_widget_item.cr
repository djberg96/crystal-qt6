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

    # Returns the item's check state in the first column.
    def check_state : CheckState
      check_state(0)
    end

    # Returns the item's check state in the given column.
    def check_state(column : Int) : CheckState
      CheckState.from_value(LibQt6.qt6cr_tree_widget_item_check_state(to_unsafe, column.to_i32))
    end

    # Sets the item's check state in the first column.
    def check_state=(value : CheckState) : CheckState
      set_check_state(0, value)
    end

    # Sets the item's check state in the given column.
    def set_check_state(column : Int, value : CheckState) : CheckState
      LibQt6.qt6cr_tree_widget_item_set_check_state(to_unsafe, column.to_i32, value.value)
      value
    end

    # Returns item data for the given column and role.
    def data(column : Int = 0, role : ItemDataRole = ItemDataRole::Display) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_tree_widget_item_data(to_unsafe, column.to_i32, role.value))
    end

    # Sets item data for the given column and role.
    def set_data(column : Int, value, role : ItemDataRole = ItemDataRole::Edit) : self
      LibQt6.qt6cr_tree_widget_item_set_data(to_unsafe, column.to_i32, role.value, Qt6.model_data_to_native(value))
      self
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

    # Returns the background brush for the first column.
    def background : QBrush
      background(0)
    end

    # Returns the background brush for the given column.
    def background(column : Int) : QBrush
      QBrush.wrap(LibQt6.qt6cr_tree_widget_item_background(to_unsafe, column.to_i32), true)
    end

    # Sets the background brush for the first column.
    def background=(value : QBrush) : QBrush
      set_background(0, value)
    end

    # Sets the background brush for the given column.
    def set_background(column : Int, value : QBrush) : QBrush
      LibQt6.qt6cr_tree_widget_item_set_background(to_unsafe, column.to_i32, value.to_unsafe)
      value
    end

    # Returns the icon for the first column.
    def icon : QIcon
      icon(0)
    end

    # Returns the icon for the given column.
    def icon(column : Int) : QIcon
      QIcon.wrap(LibQt6.qt6cr_tree_widget_item_icon(to_unsafe, column.to_i32), true)
    end

    # Sets the icon for the first column.
    def icon=(value : QIcon) : QIcon
      set_icon(0, value)
    end

    # Sets the icon for the given column.
    def set_icon(column : Int, value : QIcon) : QIcon
      LibQt6.qt6cr_tree_widget_item_set_icon(to_unsafe, column.to_i32, value.to_unsafe)
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

    # Returns the status-tip text for the first column.
    def status_tip : String
      status_tip(0)
    end

    # Returns the status-tip text for the given column.
    def status_tip(column : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tree_widget_item_status_tip(to_unsafe, column.to_i32))
    end

    # Sets the status-tip text for the first column.
    def status_tip=(value : String) : String
      set_status_tip(0, value)
    end

    # Sets the status-tip text for the given column.
    def set_status_tip(column : Int, value : String) : String
      LibQt6.qt6cr_tree_widget_item_set_status_tip(to_unsafe, column.to_i32, value.to_unsafe)
      value
    end

    # Returns the tool-tip text for the first column.
    def tool_tip : String
      tool_tip(0)
    end

    # Returns the tool-tip text for the given column.
    def tool_tip(column : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tree_widget_item_tool_tip(to_unsafe, column.to_i32))
    end

    # Sets the tool-tip text for the first column.
    def tool_tip=(value : String) : String
      set_tool_tip(0, value)
    end

    # Sets the tool-tip text for the given column.
    def set_tool_tip(column : Int, value : String) : String
      LibQt6.qt6cr_tree_widget_item_set_tool_tip(to_unsafe, column.to_i32, value.to_unsafe)
      value
    end

    # Returns the What's This help text for the first column.
    def whats_this : String
      whats_this(0)
    end

    # Returns the What's This help text for the given column.
    def whats_this(column : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tree_widget_item_whats_this(to_unsafe, column.to_i32))
    end

    # Sets the What's This help text for the first column.
    def whats_this=(value : String) : String
      set_whats_this(0, value)
    end

    # Sets the What's This help text for the given column.
    def set_whats_this(column : Int, value : String) : String
      LibQt6.qt6cr_tree_widget_item_set_whats_this(to_unsafe, column.to_i32, value.to_unsafe)
      value
    end

    # Returns the item's text alignment flags for the first column.
    def text_alignment : AlignmentFlag
      text_alignment(0)
    end

    # Returns the item's text alignment flags for the given column.
    def text_alignment(column : Int) : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_tree_widget_item_text_alignment(to_unsafe, column.to_i32))
    end

    # Sets the item's text alignment flags for the first column.
    def text_alignment=(value : AlignmentFlag) : AlignmentFlag
      set_text_alignment(0, value)
    end

    # Sets the item's text alignment flags for the given column.
    def set_text_alignment(column : Int, value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_tree_widget_item_set_text_alignment(to_unsafe, column.to_i32, value.value)
      value
    end

    # Returns the preferred size hint for the first column.
    def size_hint : Size
      size_hint(0)
    end

    # Returns the preferred size hint for the given column.
    def size_hint(column : Int) : Size
      Size.from_native(LibQt6.qt6cr_tree_widget_item_size_hint(to_unsafe, column.to_i32))
    end

    # Sets the preferred size hint for the first column.
    def size_hint=(value : Size) : Size
      set_size_hint(0, value)
    end

    # Sets the preferred size hint for the given column.
    def set_size_hint(column : Int, value : Size) : Size
      LibQt6.qt6cr_tree_widget_item_set_size_hint(to_unsafe, column.to_i32, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    # Returns `true` when the item is hidden.
    def hidden? : Bool
      LibQt6.qt6cr_tree_widget_item_is_hidden(to_unsafe)
    end

    # Shows or hides the item.
    def hidden=(value : Bool) : Bool
      LibQt6.qt6cr_tree_widget_item_set_hidden(to_unsafe, value)
      value
    end

    # Returns `true` when the item is selected.
    def selected? : Bool
      LibQt6.qt6cr_tree_widget_item_is_selected(to_unsafe)
    end

    # Selects or deselects the item.
    def selected=(value : Bool) : Bool
      LibQt6.qt6cr_tree_widget_item_set_selected(to_unsafe, value)
      value
    end

    # Returns `true` when the item is expanded.
    def expanded? : Bool
      LibQt6.qt6cr_tree_widget_item_is_expanded(to_unsafe)
    end

    # Expands or collapses the item.
    def expanded=(value : Bool) : Bool
      LibQt6.qt6cr_tree_widget_item_set_expanded(to_unsafe, value)
      value
    end

    # Returns `true` when the first column is spanned across all columns.
    def first_column_spanned? : Bool
      LibQt6.qt6cr_tree_widget_item_is_first_column_spanned(to_unsafe)
    end

    # Enables or disables first-column spanning.
    def first_column_spanned=(value : Bool) : Bool
      LibQt6.qt6cr_tree_widget_item_set_first_column_spanned(to_unsafe, value)
      value
    end

    # Returns `true` when the item is disabled.
    def disabled? : Bool
      LibQt6.qt6cr_tree_widget_item_is_disabled(to_unsafe)
    end

    # Enables or disables the item.
    def disabled=(value : Bool) : Bool
      LibQt6.qt6cr_tree_widget_item_set_disabled(to_unsafe, value)
      value
    end

    # Returns the child-indicator policy.
    def child_indicator_policy : TreeWidgetItemChildIndicatorPolicy
      TreeWidgetItemChildIndicatorPolicy.from_value(LibQt6.qt6cr_tree_widget_item_child_indicator_policy(to_unsafe))
    end

    # Sets the child-indicator policy.
    def child_indicator_policy=(value : TreeWidgetItemChildIndicatorPolicy) : TreeWidgetItemChildIndicatorPolicy
      LibQt6.qt6cr_tree_widget_item_set_child_indicator_policy(to_unsafe, value.value)
      value
    end

    # Returns the owning tree widget, if present.
    def tree_widget : TreeWidget?
      handle = LibQt6.qt6cr_tree_widget_item_tree_widget(to_unsafe)
      handle.null? ? nil : TreeWidget.wrap(handle)
    end

    # Returns the parent item, if present.
    def parent_item : TreeWidgetItem?
      handle = LibQt6.qt6cr_tree_widget_item_parent(to_unsafe)
      handle.null? ? nil : TreeWidgetItem.wrap(handle)
    end

    # Adds a child item and returns it.
    def add_child(item : TreeWidgetItem) : TreeWidgetItem
      LibQt6.qt6cr_tree_widget_item_add_child(to_unsafe, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Inserts a child item at the given index and returns it.
    def insert_child(index : Int, item : TreeWidgetItem) : TreeWidgetItem
      LibQt6.qt6cr_tree_widget_item_insert_child(to_unsafe, index.to_i32, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Removes a child item without destroying it.
    def remove_child(item : TreeWidgetItem) : TreeWidgetItem
      LibQt6.qt6cr_tree_widget_item_remove_child(to_unsafe, item.to_unsafe)
      item.assume_ownership!
      item
    end

    # Takes and returns the child item at the given index, if present.
    def take_child(index : Int) : TreeWidgetItem?
      handle = LibQt6.qt6cr_tree_widget_item_take_child(to_unsafe, index.to_i32)
      handle.null? ? nil : TreeWidgetItem.wrap(handle, true)
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

    # Returns the number of columns currently stored on the item.
    def column_count : Int32
      LibQt6.qt6cr_tree_widget_item_column_count(to_unsafe)
    end

    # Returns the child index for the given item, or `-1`.
    def index_of_child(item : TreeWidgetItem) : Int32
      LibQt6.qt6cr_tree_widget_item_index_of_child(to_unsafe, item.to_unsafe)
    end

    # Sorts this item's children using the given column and order.
    def sort_children(column : Int, order : SortOrder = SortOrder::Ascending) : self
      LibQt6.qt6cr_tree_widget_item_sort_children(to_unsafe, column.to_i32, order.value)
      self
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
