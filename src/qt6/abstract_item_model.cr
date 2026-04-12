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

    # Returns header-backed data for a section, orientation, and role.
    def header_data(section : Int = 0, orientation : Orientation = Orientation::Horizontal, role : ItemDataRole = ItemDataRole::Display) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_abstract_item_model_header_data(to_unsafe, section.to_i32, orientation.value, role.value))
    end

    # Sets header-backed data and returns whether Qt accepted the change.
    def set_header_data(section : Int, value, orientation : Orientation = Orientation::Horizontal, role : ItemDataRole = ItemDataRole::Edit) : Bool
      LibQt6.qt6cr_abstract_item_model_set_header_data(to_unsafe, section.to_i32, orientation.value, Qt6.model_data_to_native(value), role.value)
    end

    # Returns the item flags for the given index.
    def flags(index : ModelIndex) : ItemFlag
      ItemFlag.from_value(LibQt6.qt6cr_abstract_item_model_flags(to_unsafe, index.to_unsafe))
    end

    # Returns the MIME types advertised by the model for drag/drop payloads.
    def mime_types : Array(String)
      count = LibQt6.qt6cr_abstract_item_model_mime_type_count(to_unsafe)
      Array(String).new(count) do |index|
        Qt6.copy_and_release_string(LibQt6.qt6cr_abstract_item_model_mime_type(to_unsafe, index))
      end
    end

    # Builds a drag payload for the provided indexes.
    def mime_data(indexes : Enumerable(ModelIndex)) : MimeData?
      handles = indexes.to_a.map(&.to_unsafe)
      handle = LibQt6.qt6cr_abstract_item_model_mime_data_for_indexes(
        to_unsafe,
        handles.empty? ? Pointer(LibQt6::Handle).null : handles.to_unsafe,
        handles.size
      )
      handle.null? ? nil : MimeData.wrap(handle, true)
    end

    # Attempts to drop MIME payload data into the model.
    def drop_mime_data(mime_data : MimeData, action : DropAction = DropAction::CopyAction, row : Int = -1, column : Int = 0, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_drop_mime_data(
        to_unsafe,
        mime_data.to_unsafe,
        action.value,
        row.to_i32,
        column.to_i32,
        parent.try(&.to_unsafe) || Pointer(Void).null
      )
    end

    # Returns the drag actions the model can initiate.
    def supported_drag_actions : DropAction
      DropAction.from_value(LibQt6.qt6cr_abstract_item_model_supported_drag_actions(to_unsafe))
    end

    # Returns the drop actions the model can accept.
    def supported_drop_actions : DropAction
      DropAction.from_value(LibQt6.qt6cr_abstract_item_model_supported_drop_actions(to_unsafe))
    end
  end
end
