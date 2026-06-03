module Qt6
  # Wraps `QStandardItem` for use with standard-item models.
  class StandardItem < NativeResource
    # Wraps an existing native item handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an item with optional display text.
    def initialize(text : String = "")
      super(LibQt6.qt6cr_standard_item_create(text.to_unsafe))
    end

    # Creates an item with the requested child table size.
    def initialize(rows : Int, columns : Int = 1)
      super(LibQt6.qt6cr_standard_item_create_with_size(rows.to_i32, columns.to_i32))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the item text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_standard_item_text(to_unsafe))
    end

    # Sets the item text.
    def text=(value : String) : String
      LibQt6.qt6cr_standard_item_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the item icon.
    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_standard_item_icon(to_unsafe), true)
    end

    # Sets the item icon.
    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_standard_item_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the item interaction flags.
    def flags : ItemFlag
      ItemFlag.from_value(LibQt6.qt6cr_standard_item_flags(to_unsafe))
    end

    # Sets the item interaction flags.
    def flags=(value : ItemFlag) : ItemFlag
      LibQt6.qt6cr_standard_item_set_flags(to_unsafe, value.value)
      value
    end

    # Returns role-backed data for the item.
    def data(role : ItemDataRole = ItemDataRole::Display) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_standard_item_data(to_unsafe, role.value))
    end

    # Sets role-backed data and returns `self`.
    def set_data(value, role : ItemDataRole = ItemDataRole::Edit) : self
      LibQt6.qt6cr_standard_item_set_data(to_unsafe, Qt6.model_data_to_native(value), role.value)
      self
    end

    # Appends a child row in the first column and returns it.
    def append_row(item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_append_row(to_unsafe, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Appends a child row and returns `self`.
    def <<(item : StandardItem) : self
      append_row(item)
      self
    end

    # Sets a child item at the given row and column and returns it.
    def set_child(row : Int, column : Int, item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_set_child(to_unsafe, row.to_i32, column.to_i32, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Returns the child item at the given row and column, if present.
    def child(row : Int, column : Int = 0) : StandardItem?
      handle = LibQt6.qt6cr_standard_item_child(to_unsafe, row.to_i32, column.to_i32)
      handle.null? ? nil : StandardItem.wrap(handle)
    end

    # Returns the number of child rows.
    def row_count : Int32
      LibQt6.qt6cr_standard_item_row_count(to_unsafe)
    end

    # Sets the number of child rows.
    def row_count=(value : Int) : Int32
      LibQt6.qt6cr_standard_item_set_row_count(to_unsafe, value.to_i32)
      value.to_i32
    end

    # Returns the number of child columns.
    def column_count : Int32
      LibQt6.qt6cr_standard_item_column_count(to_unsafe)
    end

    # Sets the number of child columns.
    def column_count=(value : Int) : Int32
      LibQt6.qt6cr_standard_item_set_column_count(to_unsafe, value.to_i32)
      value.to_i32
    end

    def has_children? : Bool
      LibQt6.qt6cr_standard_item_has_children(to_unsafe)
    end

    def parent_item : StandardItem?
      handle = LibQt6.qt6cr_standard_item_parent(to_unsafe)
      handle.null? ? nil : StandardItem.wrap(handle)
    end

    def row : Int32
      LibQt6.qt6cr_standard_item_row(to_unsafe)
    end

    def column : Int32
      LibQt6.qt6cr_standard_item_column(to_unsafe)
    end

    def index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_standard_item_index(to_unsafe), true)
    end

    def insert_row(row : Int, item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_insert_row(to_unsafe, row.to_i32, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    def insert_rows(row : Int, count : Int) : self
      LibQt6.qt6cr_standard_item_insert_rows(to_unsafe, row.to_i32, count.to_i32)
      self
    end

    def insert_columns(column : Int, count : Int) : self
      LibQt6.qt6cr_standard_item_insert_columns(to_unsafe, column.to_i32, count.to_i32)
      self
    end

    def remove_row(row : Int) : self
      LibQt6.qt6cr_standard_item_remove_row(to_unsafe, row.to_i32)
      self
    end

    def remove_column(column : Int) : self
      LibQt6.qt6cr_standard_item_remove_column(to_unsafe, column.to_i32)
      self
    end

    def remove_rows(row : Int, count : Int) : self
      LibQt6.qt6cr_standard_item_remove_rows(to_unsafe, row.to_i32, count.to_i32)
      self
    end

    def remove_columns(column : Int, count : Int) : self
      LibQt6.qt6cr_standard_item_remove_columns(to_unsafe, column.to_i32, count.to_i32)
      self
    end

    def take_child(row : Int, column : Int = 0) : StandardItem?
      handle = LibQt6.qt6cr_standard_item_take_child(to_unsafe, row.to_i32, column.to_i32)
      handle.null? ? nil : StandardItem.wrap(handle, true)
    end

    def sort_children(column : Int = 0, order : SortOrder = SortOrder::Ascending) : self
      LibQt6.qt6cr_standard_item_sort_children(to_unsafe, column.to_i32, order.value)
      self
    end

    def enabled? : Bool
      LibQt6.qt6cr_standard_item_is_enabled(to_unsafe)
    end

    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_standard_item_set_enabled(to_unsafe, value)
      value
    end

    def editable? : Bool
      LibQt6.qt6cr_standard_item_is_editable(to_unsafe)
    end

    def editable=(value : Bool) : Bool
      LibQt6.qt6cr_standard_item_set_editable(to_unsafe, value)
      value
    end

    def selectable? : Bool
      LibQt6.qt6cr_standard_item_is_selectable(to_unsafe)
    end

    def selectable=(value : Bool) : Bool
      LibQt6.qt6cr_standard_item_set_selectable(to_unsafe, value)
      value
    end

    def checkable? : Bool
      LibQt6.qt6cr_standard_item_is_checkable(to_unsafe)
    end

    def checkable=(value : Bool) : Bool
      LibQt6.qt6cr_standard_item_set_checkable(to_unsafe, value)
      value
    end

    def check_state : CheckState
      CheckState.from_value(LibQt6.qt6cr_standard_item_check_state(to_unsafe))
    end

    def check_state=(value : CheckState) : CheckState
      LibQt6.qt6cr_standard_item_set_check_state(to_unsafe, value.value)
      value
    end

    # Stops tracking the item after ownership moves to a native parent item or model.
    def adopt_by_parent! : Nil
      return unless @owned

      Qt6.untrack_object(self)
      @owned = false
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_standard_item_destroy(to_unsafe)
    end
  end
end
