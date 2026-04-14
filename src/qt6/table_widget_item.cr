module Qt6
  # Wraps `QTableWidgetItem` for item-based table cells.
  class TableWidgetItem < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a table item with optional display text.
    def initialize(text : String = "")
      super(LibQt6.qt6cr_table_widget_item_create(text.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the item text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_table_widget_item_text(to_unsafe))
    end

    # Sets the item text.
    def text=(value : String) : String
      LibQt6.qt6cr_table_widget_item_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the item's current flags.
    def flags : ItemFlag
      ItemFlag.from_value(LibQt6.qt6cr_table_widget_item_flags(to_unsafe))
    end

    # Sets the item's current flags.
    def flags=(value : ItemFlag) : ItemFlag
      LibQt6.qt6cr_table_widget_item_set_flags(to_unsafe, value.value)
      value
    end

    # Returns the item's check state.
    def check_state : CheckState
      CheckState.from_value(LibQt6.qt6cr_table_widget_item_check_state(to_unsafe))
    end

    # Sets the item's check state.
    def check_state=(value : CheckState) : CheckState
      LibQt6.qt6cr_table_widget_item_set_check_state(to_unsafe, value.value)
      value
    end

    # Returns item data for the given role.
    def data(role : ItemDataRole = ItemDataRole::Display) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_table_widget_item_data(to_unsafe, role.value))
    end

    # Sets item data for the given role.
    def set_data(value, role : ItemDataRole = ItemDataRole::Edit) : self
      LibQt6.qt6cr_table_widget_item_set_data(to_unsafe, role.value, Qt6.model_data_to_native(value))
      self
    end

    # Returns the item's foreground color.
    def foreground : Color
      Color.from_native(LibQt6.qt6cr_table_widget_item_foreground(to_unsafe))
    end

    # Sets the item's foreground color.
    def foreground=(value : Color) : Color
      LibQt6.qt6cr_table_widget_item_set_foreground(to_unsafe, value.to_native)
      value
    end

    # Stops tracking the item after ownership moves to a native parent widget.
    def adopt_by_parent! : Nil
      return unless @owned

      Qt6.untrack_object(self)
      @owned = false
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_table_widget_item_destroy(to_unsafe)
    end
  end
end
