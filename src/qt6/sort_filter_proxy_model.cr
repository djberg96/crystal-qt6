module Qt6
  # Wraps `QSortFilterProxyModel` for sorting and filtering over any item model.
  class SortFilterProxyModel < AbstractItemModel
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_sort_filter_proxy_model_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Assigns the source model and returns it.
    def source_model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_sort_filter_proxy_model_set_source_model(to_unsafe, model.to_unsafe)
      model
    end

    # Returns the current source model, if any.
    def source_model : AbstractItemModel?
      handle = LibQt6.qt6cr_sort_filter_proxy_model_source_model(to_unsafe)
      handle.null? ? nil : AbstractItemModel.wrap(handle)
    end

    # Maps a proxy index back to the source model.
    def map_to_source(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_sort_filter_proxy_model_map_to_source(to_unsafe, index.to_unsafe), true)
    end

    # Maps a source index into the proxy model.
    def map_from_source(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_sort_filter_proxy_model_map_from_source(to_unsafe, index.to_unsafe), true)
    end

    # Sorts the proxy rows by the given column and order.
    def sort(column : Int = 0, order : SortOrder = SortOrder::Ascending) : self
      LibQt6.qt6cr_sort_filter_proxy_model_sort(to_unsafe, column.to_i32, order.value)
      self
    end

    # Returns the column currently used for sorting.
    def sort_column : Int32
      LibQt6.qt6cr_sort_filter_proxy_model_sort_column(to_unsafe)
    end

    # Returns the current sort order.
    def sort_order : SortOrder
      SortOrder.from_value(LibQt6.qt6cr_sort_filter_proxy_model_sort_order(to_unsafe))
    end

    # Sets an exact string filter and returns it.
    def filter_fixed_string=(value : String) : String
      LibQt6.qt6cr_sort_filter_proxy_model_set_filter_fixed_string(to_unsafe, value.to_unsafe)
      value
    end

    # Sets a wildcard filter and returns it.
    def filter_wildcard=(value : String) : String
      LibQt6.qt6cr_sort_filter_proxy_model_set_filter_wildcard(to_unsafe, value.to_unsafe)
      value
    end

    # Sets the filter regular expression pattern and returns it.
    def filter_regular_expression=(value : String) : String
      LibQt6.qt6cr_sort_filter_proxy_model_set_filter_regular_expression(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current filter pattern.
    def filter_pattern : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_sort_filter_proxy_model_filter_pattern(to_unsafe))
    end

    # Sets the column used for text filtering and returns it.
    def filter_key_column=(column : Int) : Int32
      LibQt6.qt6cr_sort_filter_proxy_model_set_filter_key_column(to_unsafe, column.to_i32)
      column.to_i32
    end

    # Returns the column used for text filtering.
    def filter_key_column : Int32
      LibQt6.qt6cr_sort_filter_proxy_model_filter_key_column(to_unsafe)
    end

    # Sets the role used during filtering and returns it.
    def filter_role=(role : ItemDataRole) : ItemDataRole
      LibQt6.qt6cr_sort_filter_proxy_model_set_filter_role(to_unsafe, role.value)
      role
    end

    # Returns the role used during filtering.
    def filter_role : ItemDataRole
      ItemDataRole.from_value(LibQt6.qt6cr_sort_filter_proxy_model_filter_role(to_unsafe))
    end

    # Sets the role used during sorting and returns it.
    def sort_role=(role : ItemDataRole) : ItemDataRole
      LibQt6.qt6cr_sort_filter_proxy_model_set_sort_role(to_unsafe, role.value)
      role
    end

    # Returns the role used during sorting.
    def sort_role : ItemDataRole
      ItemDataRole.from_value(LibQt6.qt6cr_sort_filter_proxy_model_sort_role(to_unsafe))
    end

    # Sets whether filtering is case-sensitive and returns it.
    def filter_case_sensitivity=(value : CaseSensitivity) : CaseSensitivity
      LibQt6.qt6cr_sort_filter_proxy_model_set_filter_case_sensitivity(to_unsafe, value.value)
      value
    end

    # Returns the current filter case-sensitivity mode.
    def filter_case_sensitivity : CaseSensitivity
      CaseSensitivity.from_value(LibQt6.qt6cr_sort_filter_proxy_model_filter_case_sensitivity(to_unsafe))
    end

    # Enables or disables dynamic sort/filter updates.
    def dynamic_sort_filter=(value : Bool) : Bool
      LibQt6.qt6cr_sort_filter_proxy_model_set_dynamic_sort_filter(to_unsafe, value)
      value
    end

    # Returns whether dynamic sort/filter updates are enabled.
    def dynamic_sort_filter? : Bool
      LibQt6.qt6cr_sort_filter_proxy_model_dynamic_sort_filter(to_unsafe)
    end

    # Enables or disables recursive filtering for tree models.
    def recursive_filtering_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_sort_filter_proxy_model_set_recursive_filtering_enabled(to_unsafe, value)
      value
    end

    # Returns whether recursive filtering is enabled.
    def recursive_filtering_enabled? : Bool
      LibQt6.qt6cr_sort_filter_proxy_model_recursive_filtering_enabled(to_unsafe)
    end

    # Refreshes the proxy after external state changes.
    def invalidate : self
      LibQt6.qt6cr_sort_filter_proxy_model_invalidate(to_unsafe)
      self
    end

    # Clears any active proxy filter pattern.
    def clear_filter : self
      LibQt6.qt6cr_sort_filter_proxy_model_clear_filter(to_unsafe)
      self
    end
  end
end
