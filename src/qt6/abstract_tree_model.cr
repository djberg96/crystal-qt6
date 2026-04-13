module Qt6
  # Wraps `QAbstractItemModel` and lets Crystal provide hierarchical model
  # logic for real tree-model use cases.
  class AbstractTreeModel < AbstractItemModel
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Creates a callback-backed tree model.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_abstract_tree_model_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    private def register_callbacks : Nil
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_abstract_tree_model_on_row_count(to_unsafe, ROW_COUNT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_column_count(to_unsafe, COLUMN_COUNT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_index_id(to_unsafe, INDEX_ID_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_parent(to_unsafe, PARENT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_data(to_unsafe, DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_set_data(to_unsafe, SET_DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_header_data(to_unsafe, HEADER_DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_flags(to_unsafe, FLAGS_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_mime_type_count(to_unsafe, MIME_TYPE_COUNT_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_mime_type(to_unsafe, MIME_TYPE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_mime_data(to_unsafe, MIME_DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_drop_mime_data(to_unsafe, DROP_MIME_DATA_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_supported_drag_actions(to_unsafe, SUPPORTED_DRAG_ACTIONS_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_abstract_tree_model_on_supported_drop_actions(to_unsafe, SUPPORTED_DROP_ACTIONS_TRAMPOLINE, @callback_userdata)
    end

    def begin_reset_model : self
      LibQt6.qt6cr_abstract_tree_model_begin_reset_model(to_unsafe)
      self
    end

    def end_reset_model : self
      LibQt6.qt6cr_abstract_tree_model_end_reset_model(to_unsafe)
      self
    end

    def begin_insert_rows(first : Int, last : Int, parent : ModelIndex? = nil) : self
      LibQt6.qt6cr_abstract_tree_model_begin_insert_rows(to_unsafe, first.to_i32, last.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
      self
    end

    def end_insert_rows : self
      LibQt6.qt6cr_abstract_tree_model_end_insert_rows(to_unsafe)
      self
    end

    def begin_remove_rows(first : Int, last : Int, parent : ModelIndex? = nil) : self
      LibQt6.qt6cr_abstract_tree_model_begin_remove_rows(to_unsafe, first.to_i32, last.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
      self
    end

    def end_remove_rows : self
      LibQt6.qt6cr_abstract_tree_model_end_remove_rows(to_unsafe)
      self
    end

    def data_changed(top_left : ModelIndex, bottom_right : ModelIndex = top_left) : self
      LibQt6.qt6cr_abstract_tree_model_data_changed(to_unsafe, top_left.to_unsafe, bottom_right.to_unsafe)
      self
    end

    protected def model_row_count(parent : ModelIndex) : Int32
      0
    end

    protected def model_column_count(parent : ModelIndex) : Int32
      1
    end

    protected def model_index_internal_id(row : Int32, column : Int32, parent : ModelIndex) : UInt64?
      nil
    end

    protected def model_parent(index : ModelIndex) : ModelIndexSpec?
      nil
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

    protected def model_supported_drag_actions : DropAction
      DropAction::CopyAction
    end

    protected def model_supported_drop_actions : DropAction
      DropAction::CopyAction
    end

    private ROW_COUNT_TRAMPOLINE = ->(userdata : Void*, parent_handle : Void*) do
      model = Box(AbstractTreeModel).unbox(userdata)
      parent = ModelIndex.wrap(parent_handle)
      model.model_row_count(parent)
    end

    private COLUMN_COUNT_TRAMPOLINE = ->(userdata : Void*, parent_handle : Void*) do
      model = Box(AbstractTreeModel).unbox(userdata)
      parent = ModelIndex.wrap(parent_handle)
      model.model_column_count(parent)
    end

    private INDEX_ID_TRAMPOLINE = ->(userdata : Void*, row : Int32, column : Int32, parent_handle : Void*) do
      model = Box(AbstractTreeModel).unbox(userdata)
      parent = ModelIndex.wrap(parent_handle)
      model.model_index_internal_id(row, column, parent) || 0_u64
    end

    private PARENT_TRAMPOLINE = ->(userdata : Void*, index_handle : Void*) do
      model = Box(AbstractTreeModel).unbox(userdata)
      index = ModelIndex.wrap(index_handle)
      ModelIndexSpec.to_native(model.model_parent(index))
    end

    private DATA_TRAMPOLINE = ->(userdata : Void*, index_handle : Void*, role : Int32) do
      model = Box(AbstractTreeModel).unbox(userdata)
      index = ModelIndex.wrap(index_handle)
      Qt6.model_data_to_native(model.model_data(index, role))
    end

    private SET_DATA_TRAMPOLINE = ->(userdata : Void*, index_handle : Void*, value : LibQt6::VariantValue, role : Int32) do
      model = Box(AbstractTreeModel).unbox(userdata)
      index = ModelIndex.wrap(index_handle)
      model.model_set_data(index, Qt6.model_data_from_native(value), role)
    end

    private HEADER_DATA_TRAMPOLINE = ->(userdata : Void*, section : Int32, orientation : Int32, role : Int32) do
      model = Box(AbstractTreeModel).unbox(userdata)
      Qt6.model_data_to_native(model.model_header_data(section, Orientation.from_value(orientation), role))
    end

    private FLAGS_TRAMPOLINE = ->(userdata : Void*, index_handle : Void*) do
      model = Box(AbstractTreeModel).unbox(userdata)
      index = ModelIndex.wrap(index_handle)
      model.model_flags(index).value
    end

    private MIME_TYPE_COUNT_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractTreeModel).unbox(userdata).model_mime_types.size.to_i32
    end

    private MIME_TYPE_TRAMPOLINE = ->(userdata : Void*, index : Int32) do
      text = Box(AbstractTreeModel).unbox(userdata).model_mime_types[index]? || ""
      Qt6.malloc_string(text)
    end

    private MIME_DATA_TRAMPOLINE = ->(userdata : Void*, index_handles : Pointer(LibQt6::Handle), count : Int32) do
      model = Box(AbstractTreeModel).unbox(userdata)
      indexes = Array(ModelIndex).new(count) do |index|
        ModelIndex.wrap(index_handles[index])
      end
      model.model_mime_data(indexes).try(&.to_unsafe) || Pointer(Void).null
    end

    private DROP_MIME_DATA_TRAMPOLINE = ->(userdata : Void*, mime_data_handle : Void*, action : Int32, row : Int32, column : Int32, parent_handle : Void*) do
      model = Box(AbstractTreeModel).unbox(userdata)
      mime_data = MimeData.wrap(mime_data_handle)
      parent = ModelIndex.wrap(parent_handle)
      model.model_drop_mime_data(mime_data, DropAction.from_value(action), row, column, parent)
    end

    private SUPPORTED_DRAG_ACTIONS_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractTreeModel).unbox(userdata).model_supported_drag_actions.value
    end

    private SUPPORTED_DROP_ACTIONS_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractTreeModel).unbox(userdata).model_supported_drop_actions.value
    end
  end
end
