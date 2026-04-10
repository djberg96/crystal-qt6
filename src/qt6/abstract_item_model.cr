module Qt6
  # Base wrapper for `QAbstractItemModel` instances.
  class AbstractItemModel < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the number of rows under the optional parent index.
    def row_count(parent : ModelIndex? = nil) : Int32
      LibQt6.qt6cr_abstract_item_model_row_count(to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    # Returns the number of columns under the optional parent index.
    def column_count(parent : ModelIndex? = nil) : Int32
      LibQt6.qt6cr_abstract_item_model_column_count(to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    # Returns an index for the requested row, column, and optional parent.
    def index(row : Int, column : Int = 0, parent : ModelIndex? = nil) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_abstract_item_model_index(to_unsafe, row.to_i32, column.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null), true)
    end

    # Returns role-backed model data for an index.
    def data(index : ModelIndex, role : ItemDataRole = ItemDataRole::Display) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_abstract_item_model_data(to_unsafe, index.to_unsafe, role.value))
    end

    # Sets role-backed model data and returns whether Qt accepted the change.
    def set_data(index : ModelIndex, value, role : ItemDataRole = ItemDataRole::Edit) : Bool
      LibQt6.qt6cr_abstract_item_model_set_data(to_unsafe, index.to_unsafe, Qt6.model_data_to_native(value), role.value)
    end
  end
end