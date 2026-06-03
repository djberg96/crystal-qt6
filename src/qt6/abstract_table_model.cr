module Qt6
  # Wraps `QAbstractTableModel` and lets Crystal provide table-model logic.
  class AbstractTableModel < AbstractItemModel
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Creates a callback-backed table model.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_abstract_table_model_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    private def register_callbacks : Nil
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_abstract_table_model_on_row_count(to_unsafe, ROW_COUNT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_column_count(to_unsafe, COLUMN_COUNT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_data(to_unsafe, DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_set_data(to_unsafe, SET_DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_header_data(to_unsafe, HEADER_DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_flags(to_unsafe, FLAGS_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_mime_type_count(to_unsafe, MIME_TYPE_COUNT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_mime_type(to_unsafe, MIME_TYPE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_mime_data(to_unsafe, MIME_DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_drop_mime_data(to_unsafe, DROP_MIME_DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_supported_drag_actions(to_unsafe, SUPPORTED_DRAG_ACTIONS_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_table_model_on_supported_drop_actions(to_unsafe, SUPPORTED_DROP_ACTIONS_TRAMPOLINE, @callback_userdata)
    end

    def begin_reset_model : self
      LibQt6.qt6cr_abstract_table_model_begin_reset_model(to_unsafe)
      self
    end

    def end_reset_model : self
      LibQt6.qt6cr_abstract_table_model_end_reset_model(to_unsafe)
      self
    end

    def begin_insert_rows(first : Int, last : Int, parent : ModelIndex? = nil) : self
      LibQt6.qt6cr_abstract_table_model_begin_insert_rows(to_unsafe, first.to_i32, last.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
      self
    end

    def end_insert_rows : self
      LibQt6.qt6cr_abstract_table_model_end_insert_rows(to_unsafe)
      self
    end

    def begin_remove_rows(first : Int, last : Int, parent : ModelIndex? = nil) : self
      LibQt6.qt6cr_abstract_table_model_begin_remove_rows(to_unsafe, first.to_i32, last.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
      self
    end

    def end_remove_rows : self
      LibQt6.qt6cr_abstract_table_model_end_remove_rows(to_unsafe)
      self
    end

    def begin_move_rows(source_first : Int, source_last : Int, destination_child : Int, source_parent : ModelIndex? = nil, destination_parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_table_model_begin_move_rows(to_unsafe, source_first.to_i32, source_last.to_i32, source_parent.try(&.to_unsafe) || Pointer(Void).null, destination_child.to_i32, destination_parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    def end_move_rows : self
      LibQt6.qt6cr_abstract_table_model_end_move_rows(to_unsafe)
      self
    end

    def begin_insert_columns(first : Int, last : Int, parent : ModelIndex? = nil) : self
      LibQt6.qt6cr_abstract_table_model_begin_insert_columns(to_unsafe, first.to_i32, last.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
      self
    end

    def end_insert_columns : self
      LibQt6.qt6cr_abstract_table_model_end_insert_columns(to_unsafe)
      self
    end

    def begin_remove_columns(first : Int, last : Int, parent : ModelIndex? = nil) : self
      LibQt6.qt6cr_abstract_table_model_begin_remove_columns(to_unsafe, first.to_i32, last.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
      self
    end

    def end_remove_columns : self
      LibQt6.qt6cr_abstract_table_model_end_remove_columns(to_unsafe)
      self
    end

    def begin_move_columns(source_first : Int, source_last : Int, destination_child : Int, source_parent : ModelIndex? = nil, destination_parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_table_model_begin_move_columns(to_unsafe, source_first.to_i32, source_last.to_i32, source_parent.try(&.to_unsafe) || Pointer(Void).null, destination_child.to_i32, destination_parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    def end_move_columns : self
      LibQt6.qt6cr_abstract_table_model_end_move_columns(to_unsafe)
      self
    end

    def data_changed(top_left : ModelIndex, bottom_right : ModelIndex = top_left) : self
      LibQt6.qt6cr_abstract_table_model_data_changed(to_unsafe, top_left.to_unsafe, bottom_right.to_unsafe)
      self
    end

    def header_data_changed(orientation : Orientation, first : Int, last : Int = first) : self
      LibQt6.qt6cr_abstract_table_model_header_data_changed(to_unsafe, orientation.value, first.to_i32, last.to_i32)
      self
    end

    def layout_about_to_be_changed : self
      LibQt6.qt6cr_abstract_table_model_layout_about_to_be_changed(to_unsafe)
      self
    end

    def layout_changed : self
      LibQt6.qt6cr_abstract_table_model_layout_changed(to_unsafe)
      self
    end

    protected def model_row_count : Int32
      0
    end

    protected def model_column_count : Int32
      0
    end

    protected def model_data(index : ModelIndex, role : Int32) : ModelData
      nil
    end

    protected def model_set_data(index : ModelIndex, value : ModelData, role : Int32) : Bool
      false
    end

    protected def model_header_data(section : Int32, orientation : Orientation, role : Int32) : ModelData
      nil
    end

    protected def model_flags(index : ModelIndex) : ItemFlag
      index.valid? ? (ItemFlag::Enabled | ItemFlag::Selectable) : ItemFlag::None
    end

    protected def model_mime_types : Array(String)
      [] of String
    end

    protected def model_mime_data(indexes : Array(ModelIndex)) : MimeData?
      nil
    end

    protected def model_drop_mime_data(mime_data : MimeData, action : DropAction, row : Int32, column : Int32, parent : ModelIndex) : Bool
      false
    end

    protected def model_drop_mime_data_handle(mime_data_handle : LibQt6::Handle, action : DropAction, row : Int32, column : Int32, parent : ModelIndex) : Bool
      model_drop_mime_data(MimeData.wrap(mime_data_handle), action, row, column, parent)
    end

    protected def model_supported_drag_actions : DropAction
      DropAction::CopyAction
    end

    protected def model_supported_drop_actions : DropAction
      DropAction::CopyAction
    end

    private ROW_COUNT_TRAMPOLINE = ->(userdata : Void*) { Box(AbstractTableModel).unbox(userdata).model_row_count }
    private COLUMN_COUNT_TRAMPOLINE = ->(userdata : Void*) { Box(AbstractTableModel).unbox(userdata).model_column_count }

    private DATA_TRAMPOLINE = ->(userdata : Void*, index_handle : Void*, role : Int32) do
      model = Box(AbstractTableModel).unbox(userdata)
      Qt6.model_data_to_native(model.model_data(ModelIndex.wrap(index_handle), role))
    end

    private SET_DATA_TRAMPOLINE = ->(userdata : Void*, index_handle : Void*, value : LibQt6::VariantValue, role : Int32) do
      model = Box(AbstractTableModel).unbox(userdata)
      model.model_set_data(ModelIndex.wrap(index_handle), Qt6.model_data_from_native(value), role)
    end

    private HEADER_DATA_TRAMPOLINE = ->(userdata : Void*, section : Int32, orientation : Int32, role : Int32) do
      model = Box(AbstractTableModel).unbox(userdata)
      Qt6.model_data_to_native(model.model_header_data(section, Orientation.from_value(orientation), role))
    end

    private FLAGS_TRAMPOLINE = ->(userdata : Void*, index_handle : Void*) do
      Box(AbstractTableModel).unbox(userdata).model_flags(ModelIndex.wrap(index_handle)).value
    end

    private MIME_TYPE_COUNT_TRAMPOLINE = ->(userdata : Void*) { Box(AbstractTableModel).unbox(userdata).model_mime_types.size.to_i32 }

    private MIME_TYPE_TRAMPOLINE = ->(userdata : Void*, index : Int32) do
      Qt6.malloc_string(Box(AbstractTableModel).unbox(userdata).model_mime_types[index]? || "")
    end

    private MIME_DATA_TRAMPOLINE = ->(userdata : Void*, index_handles : Pointer(LibQt6::Handle), count : Int32) do
      model = Box(AbstractTableModel).unbox(userdata)
      indexes = Array(ModelIndex).new(count) { |index| ModelIndex.wrap(index_handles[index]) }
      model.model_mime_data(indexes).try(&.to_unsafe) || Pointer(Void).null
    end

    private DROP_MIME_DATA_TRAMPOLINE = ->(userdata : Void*, mime_data_handle : Void*, action : Int32, row : Int32, column : Int32, parent_handle : Void*) do
      model = Box(AbstractTableModel).unbox(userdata)
      model.model_drop_mime_data_handle(mime_data_handle, DropAction.from_value(action), row, column, ModelIndex.wrap(parent_handle))
    end

    private SUPPORTED_DRAG_ACTIONS_TRAMPOLINE = ->(userdata : Void*) { Box(AbstractTableModel).unbox(userdata).model_supported_drag_actions.value }
    private SUPPORTED_DROP_ACTIONS_TRAMPOLINE = ->(userdata : Void*) { Box(AbstractTableModel).unbox(userdata).model_supported_drop_actions.value }
  end
end
