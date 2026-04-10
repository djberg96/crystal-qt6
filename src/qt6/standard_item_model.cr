module Qt6
  # Wraps `QStandardItemModel` for an initial model/view layer.
  class StandardItemModel < QObject
    # Creates a standard item model, optionally parented to another object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_standard_item_model_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Removes all items and headers.
    def clear : self
      LibQt6.qt6cr_standard_item_model_clear(to_unsafe)
      self
    end

    # Returns the number of rows under the optional parent index.
    def row_count(parent : ModelIndex? = nil) : Int32
      LibQt6.qt6cr_standard_item_model_row_count(to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    # Returns the number of columns under the optional parent index.
    def column_count(parent : ModelIndex? = nil) : Int32
      LibQt6.qt6cr_standard_item_model_column_count(to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    # Appends a top-level row in the first column and returns it.
    def append_row(item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_model_append_row(to_unsafe, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Appends a top-level row and returns `self`.
    def <<(item : StandardItem) : self
      append_row(item)
      self
    end

    # Sets an item at the given row and column and returns it.
    def set_item(row : Int, column : Int, item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_model_set_item(to_unsafe, row.to_i32, column.to_i32, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Returns the item at the given row and column, if present.
    def item(row : Int, column : Int = 0) : StandardItem?
      handle = LibQt6.qt6cr_standard_item_model_item(to_unsafe, row.to_i32, column.to_i32)
      handle.null? ? nil : StandardItem.wrap(handle)
    end

    # Sets a horizontal header label and returns it.
    def set_horizontal_header_label(column : Int, value : String) : String
      LibQt6.qt6cr_standard_item_model_set_horizontal_header_label(to_unsafe, column.to_i32, value.to_unsafe)
      value
    end

    # Returns the horizontal header label for the given column.
    def horizontal_header_label(column : Int = 0) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_standard_item_model_horizontal_header_label(to_unsafe, column.to_i32))
    end

    # Returns an index for the requested row, column, and optional parent.
    def index(row : Int, column : Int = 0, parent : ModelIndex? = nil) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_standard_item_model_index(to_unsafe, row.to_i32, column.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null), true)
    end

    # Returns the item referenced by the given index, if present.
    def item_from_index(index : ModelIndex) : StandardItem?
      handle = LibQt6.qt6cr_standard_item_model_item_from_index(to_unsafe, index.to_unsafe)
      handle.null? ? nil : StandardItem.wrap(handle)
    end

    # Returns the model index for the given item.
    def index_from_item(item : StandardItem) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_standard_item_model_index_from_item(to_unsafe, item.to_unsafe), true)
    end
  end
end