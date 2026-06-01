module Qt6
  # Wraps `QItemSelection`, the Qt container for selected model index ranges.
  class ItemSelection < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the number of `QItemSelectionRange` entries in this selection.
    def count : Int32
      LibQt6.qt6cr_item_selection_count(to_unsafe)
    end

    # Returns the selection range at the given position.
    def at(index : Int) : ItemSelectionRange
      ItemSelectionRange.wrap(LibQt6.qt6cr_item_selection_at(to_unsafe, index.to_i32), true)
    end

    # Returns copies of all model indexes covered by this selection.
    def indexes : Array(ModelIndex)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_item_selection_indexes(to_unsafe)).map do |handle|
        ModelIndex.wrap(handle, true)
      end
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_item_selection_destroy(to_unsafe)
    end
  end
end
