module Qt6
  # Wraps `QStandardItemModel` for an initial model/view layer.
  class StandardItemModel < AbstractItemModel
    @item_changed : Signal(StandardItem) = Signal(StandardItem).new
    @item_changed_userdata : LibQt6::Handle = Pointer(Void).null

    getter item_changed : Signal(StandardItem)

    # Creates a standard item model, optionally parented to another object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_standard_item_model_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_standard_item_model_callbacks
    end

    # Creates a standard item model with an initial row and column count.
    def initialize(rows : Int, columns : Int, parent : QObject? = nil)
      super(LibQt6.qt6cr_standard_item_model_create_with_size(rows.to_i32, columns.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_standard_item_model_callbacks
    end

    private def register_standard_item_model_callbacks : Nil
      @item_changed = Signal(StandardItem).new
      @item_changed_userdata = Box.box(self)
      LibQt6.qt6cr_standard_item_model_on_item_changed(to_unsafe, ITEM_CHANGED_TRAMPOLINE, @item_changed_userdata)
    end

    # Removes all items and headers.
    def clear : self
      LibQt6.qt6cr_standard_item_model_clear(to_unsafe)
      self
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

    # Sets the number of top-level rows.
    def row_count=(value : Int) : Int32
      LibQt6.qt6cr_standard_item_model_set_row_count(to_unsafe, value.to_i32)
      value.to_i32
    end

    # Sets the number of top-level columns.
    def column_count=(value : Int) : Int32
      LibQt6.qt6cr_standard_item_model_set_column_count(to_unsafe, value.to_i32)
      value.to_i32
    end

    # Appends a top-level column and returns it.
    def append_column(item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_model_append_column(to_unsafe, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Inserts a top-level row in the first column and returns it.
    def insert_row(row : Int, item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_model_insert_row_item(to_unsafe, row.to_i32, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    # Inserts a top-level column and returns it.
    def insert_column(column : Int, item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_model_insert_column_item(to_unsafe, column.to_i32, item.to_unsafe)
      item.adopt_by_parent!
      item
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

    # Takes an item out of the model and returns an owning wrapper.
    def take_item(row : Int, column : Int = 0) : StandardItem?
      handle = LibQt6.qt6cr_standard_item_model_take_item(to_unsafe, row.to_i32, column.to_i32)
      handle.null? ? nil : StandardItem.wrap(handle, true)
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

    # Sets a vertical header label and returns it.
    def set_vertical_header_label(row : Int, value : String) : String
      LibQt6.qt6cr_standard_item_model_set_vertical_header_label(to_unsafe, row.to_i32, value.to_unsafe)
      value
    end

    # Returns the vertical header label for the given row.
    def vertical_header_label(row : Int = 0) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_standard_item_model_vertical_header_label(to_unsafe, row.to_i32))
    end

    def invisible_root_item : StandardItem?
      handle = LibQt6.qt6cr_standard_item_model_invisible_root_item(to_unsafe)
      handle.null? ? nil : StandardItem.wrap(handle)
    end

    def horizontal_header_item(column : Int) : StandardItem?
      handle = LibQt6.qt6cr_standard_item_model_horizontal_header_item(to_unsafe, column.to_i32)
      handle.null? ? nil : StandardItem.wrap(handle)
    end

    def set_horizontal_header_item(column : Int, item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_model_set_horizontal_header_item(to_unsafe, column.to_i32, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    def vertical_header_item(row : Int) : StandardItem?
      handle = LibQt6.qt6cr_standard_item_model_vertical_header_item(to_unsafe, row.to_i32)
      handle.null? ? nil : StandardItem.wrap(handle)
    end

    def set_vertical_header_item(row : Int, item : StandardItem) : StandardItem
      LibQt6.qt6cr_standard_item_model_set_vertical_header_item(to_unsafe, row.to_i32, item.to_unsafe)
      item.adopt_by_parent!
      item
    end

    def take_horizontal_header_item(column : Int) : StandardItem?
      handle = LibQt6.qt6cr_standard_item_model_take_horizontal_header_item(to_unsafe, column.to_i32)
      handle.null? ? nil : StandardItem.wrap(handle, true)
    end

    def take_vertical_header_item(row : Int) : StandardItem?
      handle = LibQt6.qt6cr_standard_item_model_take_vertical_header_item(to_unsafe, row.to_i32)
      handle.null? ? nil : StandardItem.wrap(handle, true)
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

    def find_items(text : String, flags : MatchFlag = MatchFlag::Exactly, column : Int = 0) : Array(StandardItem)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_standard_item_model_find_items(to_unsafe, text.to_unsafe, flags.value, column.to_i32)).map do |handle|
        StandardItem.wrap(handle)
      end
    end

    def sort_role : Int32
      LibQt6.qt6cr_standard_item_model_sort_role(to_unsafe)
    end

    def sort_role=(role : ItemDataRole) : ItemDataRole
      LibQt6.qt6cr_standard_item_model_set_sort_role(to_unsafe, role.value)
      role
    end

    def sort_role=(role : Int) : Int32
      LibQt6.qt6cr_standard_item_model_set_sort_role(to_unsafe, role.to_i32)
      role.to_i32
    end

    def set_item_role_names(names : Hash(Int32, String)) : self
      native_names = names.map do |role, name|
        LibQt6::ModelRoleNameValue.new(role: role, name: name.to_unsafe)
      end
      LibQt6.qt6cr_standard_item_model_set_item_role_names(
        to_unsafe,
        native_names.empty? ? Pointer(LibQt6::ModelRoleNameValue).null : native_names.to_unsafe,
        native_names.size
      )
      self
    end

    def on_item_changed(&block : StandardItem ->) : self
      @item_changed.connect { |item| block.call(item) }
      self
    end

    private ITEM_CHANGED_TRAMPOLINE = ->(userdata : Void*, item_handle : Void*) do
      Box(StandardItemModel).unbox(userdata).@item_changed.emit(StandardItem.wrap(item_handle))
    end
  end
end
