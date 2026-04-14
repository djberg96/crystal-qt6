module Qt6
  # Wraps a `QModelIndex` copy for model/view navigation.
  class ModelIndex < NativeResource
    # Wraps an existing native index handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an invalid model index.
    def initialize
      super(LibQt6.qt6cr_model_index_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` if the index points to a valid model entry.
    def valid? : Bool
      LibQt6.qt6cr_model_index_is_valid(to_unsafe)
    end

    # Returns the index row.
    def row : Int32
      LibQt6.qt6cr_model_index_row(to_unsafe)
    end

    # Returns the index column.
    def column : Int32
      LibQt6.qt6cr_model_index_column(to_unsafe)
    end

    # Returns the model-provided internal identifier for this index.
    def internal_id : UInt64
      LibQt6.qt6cr_model_index_internal_id(to_unsafe)
    end

    # Returns role-backed data for this index from the given model.
    def data(model : AbstractItemModel, role : ItemDataRole = ItemDataRole::Display) : ModelData
      model.data(self, role)
    end

    # Sets role-backed data for this index on the given model.
    def set_data(model : AbstractItemModel, value, role : ItemDataRole = ItemDataRole::Edit) : Bool
      model.set_data(self, value, role)
    end

    # Returns the item flags for this index from the given model.
    def flags(model : AbstractItemModel) : ItemFlag
      model.flags(self)
    end

    # Returns the parent index for this index from the given model.
    def parent(model : AbstractItemModel) : ModelIndex
      model.parent_index(self)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_model_index_destroy(to_unsafe)
    end
  end
end
