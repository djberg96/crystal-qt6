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

    # Returns the number of child columns.
    def column_count : Int32
      LibQt6.qt6cr_standard_item_column_count(to_unsafe)
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