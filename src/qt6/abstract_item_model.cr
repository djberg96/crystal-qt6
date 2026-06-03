module Qt6
  # Base wrapper for `QAbstractItemModel` instances.
  class AbstractItemModel < QObject
    alias ModelRowsColumnsEvent = NamedTuple(parent: ModelIndex, first: Int32, last: Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    @data_changed : Signal(ModelIndex, ModelIndex) = Signal(ModelIndex, ModelIndex).new
    @header_data_changed : Signal(Orientation, Int32, Int32) = Signal(Orientation, Int32, Int32).new
    @layout_about_to_be_changed : Signal() = Signal().new
    @layout_changed : Signal() = Signal().new
    @model_about_to_be_reset : Signal() = Signal().new
    @model_reset : Signal() = Signal().new
    @rows_about_to_be_inserted : Signal(ModelRowsColumnsEvent) = Signal(ModelRowsColumnsEvent).new
    @rows_inserted : Signal(ModelRowsColumnsEvent) = Signal(ModelRowsColumnsEvent).new
    @rows_about_to_be_removed : Signal(ModelRowsColumnsEvent) = Signal(ModelRowsColumnsEvent).new
    @rows_removed : Signal(ModelRowsColumnsEvent) = Signal(ModelRowsColumnsEvent).new
    @columns_about_to_be_inserted : Signal(ModelRowsColumnsEvent) = Signal(ModelRowsColumnsEvent).new
    @columns_inserted : Signal(ModelRowsColumnsEvent) = Signal(ModelRowsColumnsEvent).new
    @columns_about_to_be_removed : Signal(ModelRowsColumnsEvent) = Signal(ModelRowsColumnsEvent).new
    @columns_removed : Signal(ModelRowsColumnsEvent) = Signal(ModelRowsColumnsEvent).new
    @model_signal_userdata : LibQt6::Handle = Pointer(Void).null

    getter data_changed, header_data_changed, layout_about_to_be_changed, layout_changed,
      model_about_to_be_reset, model_reset, rows_about_to_be_inserted, rows_inserted,
      rows_about_to_be_removed, rows_removed, columns_about_to_be_inserted, columns_inserted,
      columns_about_to_be_removed, columns_removed

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_model_signals
    end

    private def register_model_signals : Nil
      @data_changed = Signal(ModelIndex, ModelIndex).new
      @header_data_changed = Signal(Orientation, Int32, Int32).new
      @layout_about_to_be_changed = Signal().new
      @layout_changed = Signal().new
      @model_about_to_be_reset = Signal().new
      @model_reset = Signal().new
      @rows_about_to_be_inserted = Signal(ModelRowsColumnsEvent).new
      @rows_inserted = Signal(ModelRowsColumnsEvent).new
      @rows_about_to_be_removed = Signal(ModelRowsColumnsEvent).new
      @rows_removed = Signal(ModelRowsColumnsEvent).new
      @columns_about_to_be_inserted = Signal(ModelRowsColumnsEvent).new
      @columns_inserted = Signal(ModelRowsColumnsEvent).new
      @columns_about_to_be_removed = Signal(ModelRowsColumnsEvent).new
      @columns_removed = Signal(ModelRowsColumnsEvent).new
      @model_signal_userdata = Box.box(self)
      LibQt6.qt6cr_abstract_item_model_on_data_changed(to_unsafe, DATA_CHANGED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_header_data_changed(to_unsafe, HEADER_DATA_CHANGED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_layout_about_to_be_changed(to_unsafe, LAYOUT_ABOUT_TO_BE_CHANGED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_layout_changed(to_unsafe, LAYOUT_CHANGED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_model_about_to_be_reset(to_unsafe, MODEL_ABOUT_TO_BE_RESET_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_model_reset(to_unsafe, MODEL_RESET_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_rows_about_to_be_inserted(to_unsafe, ROWS_ABOUT_TO_BE_INSERTED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_rows_inserted(to_unsafe, ROWS_INSERTED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_rows_about_to_be_removed(to_unsafe, ROWS_ABOUT_TO_BE_REMOVED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_rows_removed(to_unsafe, ROWS_REMOVED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_columns_about_to_be_inserted(to_unsafe, COLUMNS_ABOUT_TO_BE_INSERTED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_columns_inserted(to_unsafe, COLUMNS_INSERTED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_columns_about_to_be_removed(to_unsafe, COLUMNS_ABOUT_TO_BE_REMOVED_TRAMPOLINE, @model_signal_userdata)
      LibQt6.qt6cr_abstract_item_model_on_columns_removed(to_unsafe, COLUMNS_REMOVED_TRAMPOLINE, @model_signal_userdata)
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

    # Returns the parent index for the given child index.
    def parent_index(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_abstract_item_model_parent(to_unsafe, index.to_unsafe), true)
    end

    # Returns whether an index exists for the requested row and column.
    def has_index?(row : Int, column : Int = 0, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_has_index(to_unsafe, row.to_i32, column.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    # Returns whether the optional parent has child rows.
    def has_children?(parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_has_children(to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    # Returns a sibling index for the given model index.
    def sibling(row : Int, column : Int, index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_abstract_item_model_sibling(to_unsafe, row.to_i32, column.to_i32, index.to_unsafe), true)
    end

    # Returns role-backed model data for an index.
    def data(index : ModelIndex, role : ItemDataRole = ItemDataRole::Display) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_abstract_item_model_data(to_unsafe, index.to_unsafe, role.value))
    end

    # Sets role-backed model data and returns whether Qt accepted the change.
    def set_data(index : ModelIndex, value, role : ItemDataRole = ItemDataRole::Edit) : Bool
      LibQt6.qt6cr_abstract_item_model_set_data(to_unsafe, index.to_unsafe, Qt6.model_data_to_native(value), role.value)
    end

    # Returns all role data currently associated with an index.
    def item_data(index : ModelIndex) : Hash(Int32, ModelData)
      Qt6.copy_and_release_model_data_pairs(LibQt6.qt6cr_abstract_item_model_item_data(to_unsafe, index.to_unsafe))
    end

    # Replaces role data for an index.
    def set_item_data(index : ModelIndex, values : Hash(Int32, ModelData)) : Bool
      native_pairs = values.map do |role, value|
        LibQt6::ModelDataPairValue.new(role: role, value: Qt6.model_data_to_native(value))
      end

      LibQt6.qt6cr_abstract_item_model_set_item_data(
        to_unsafe,
        index.to_unsafe,
        native_pairs.empty? ? Pointer(LibQt6::ModelDataPairValue).null : native_pairs.to_unsafe,
        native_pairs.size
      )
    end

    # Clears all role data for an index.
    def clear_item_data(index : ModelIndex) : Bool
      LibQt6.qt6cr_abstract_item_model_clear_item_data(to_unsafe, index.to_unsafe)
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

    # Returns whether the model can accept a MIME payload at the requested location.
    def can_drop_mime_data?(mime_data : MimeData, action : DropAction = DropAction::CopyAction, row : Int = -1, column : Int = 0, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_can_drop_mime_data(
        to_unsafe,
        mime_data.to_unsafe,
        action.value,
        row.to_i32,
        column.to_i32,
        parent.try(&.to_unsafe) || Pointer(Void).null
      )
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

    def insert_rows(row : Int, count : Int = 1, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_insert_rows(to_unsafe, row.to_i32, count.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    def insert_columns(column : Int, count : Int = 1, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_insert_columns(to_unsafe, column.to_i32, count.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    def remove_rows(row : Int, count : Int = 1, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_remove_rows(to_unsafe, row.to_i32, count.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    def remove_columns(column : Int, count : Int = 1, parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_remove_columns(to_unsafe, column.to_i32, count.to_i32, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    def move_rows(source_row : Int, count : Int, destination_child : Int, source_parent : ModelIndex? = nil, destination_parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_move_rows(to_unsafe, source_parent.try(&.to_unsafe) || Pointer(Void).null, source_row.to_i32, count.to_i32, destination_parent.try(&.to_unsafe) || Pointer(Void).null, destination_child.to_i32)
    end

    def move_columns(source_column : Int, count : Int, destination_child : Int, source_parent : ModelIndex? = nil, destination_parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_move_columns(to_unsafe, source_parent.try(&.to_unsafe) || Pointer(Void).null, source_column.to_i32, count.to_i32, destination_parent.try(&.to_unsafe) || Pointer(Void).null, destination_child.to_i32)
    end

    def can_fetch_more?(parent : ModelIndex? = nil) : Bool
      LibQt6.qt6cr_abstract_item_model_can_fetch_more(to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null)
    end

    def fetch_more(parent : ModelIndex? = nil) : self
      LibQt6.qt6cr_abstract_item_model_fetch_more(to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null)
      self
    end

    def sort(column : Int = 0, order : SortOrder = SortOrder::Ascending) : self
      LibQt6.qt6cr_abstract_item_model_sort(to_unsafe, column.to_i32, order.value)
      self
    end

    def buddy(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_abstract_item_model_buddy(to_unsafe, index.to_unsafe), true)
    end

    def match(start : ModelIndex, value, role : ItemDataRole = ItemDataRole::Display, hits : Int = 1, flags : MatchFlag = MatchFlag::StartsWith | MatchFlag::Wrap) : Array(ModelIndex)
      Qt6.copy_and_release_handles(
        LibQt6.qt6cr_abstract_item_model_match(to_unsafe, start.to_unsafe, role.value, Qt6.model_data_to_native(value), hits.to_i32, flags.value)
      ).map { |handle| ModelIndex.wrap(handle, true) }
    end

    def span(index : ModelIndex) : Size
      Size.from_native(LibQt6.qt6cr_abstract_item_model_span(to_unsafe, index.to_unsafe))
    end

    def role_names : Hash(Int32, String)
      Qt6.copy_and_release_model_role_names(LibQt6.qt6cr_abstract_item_model_role_names(to_unsafe))
    end

    def check_index?(index : ModelIndex, options : ModelCheckIndexOption = ModelCheckIndexOption::NoOption) : Bool
      LibQt6.qt6cr_abstract_item_model_check_index(to_unsafe, index.to_unsafe, options.value)
    end

    def submit : Bool
      LibQt6.qt6cr_abstract_item_model_submit(to_unsafe)
    end

    def revert : self
      LibQt6.qt6cr_abstract_item_model_revert(to_unsafe)
      self
    end

    def on_data_changed(&block : ModelIndex, ModelIndex ->) : self
      @data_changed.connect { |top_left, bottom_right| block.call(top_left, bottom_right) }
      self
    end

    def on_header_data_changed(&block : Orientation, Int32, Int32 ->) : self
      @header_data_changed.connect { |orientation, first, last| block.call(orientation, first, last) }
      self
    end

    def on_layout_about_to_be_changed(&block : ->) : self
      @layout_about_to_be_changed.connect { block.call }
      self
    end

    def on_layout_changed(&block : ->) : self
      @layout_changed.connect { block.call }
      self
    end

    def on_model_about_to_be_reset(&block : ->) : self
      @model_about_to_be_reset.connect { block.call }
      self
    end

    def on_model_reset(&block : ->) : self
      @model_reset.connect { block.call }
      self
    end

    def on_rows_about_to_be_inserted(&block : ModelRowsColumnsEvent ->) : self
      @rows_about_to_be_inserted.connect { |event| block.call(event) }
      self
    end

    def on_rows_inserted(&block : ModelRowsColumnsEvent ->) : self
      @rows_inserted.connect { |event| block.call(event) }
      self
    end

    def on_rows_about_to_be_removed(&block : ModelRowsColumnsEvent ->) : self
      @rows_about_to_be_removed.connect { |event| block.call(event) }
      self
    end

    def on_rows_removed(&block : ModelRowsColumnsEvent ->) : self
      @rows_removed.connect { |event| block.call(event) }
      self
    end

    def on_columns_about_to_be_inserted(&block : ModelRowsColumnsEvent ->) : self
      @columns_about_to_be_inserted.connect { |event| block.call(event) }
      self
    end

    def on_columns_inserted(&block : ModelRowsColumnsEvent ->) : self
      @columns_inserted.connect { |event| block.call(event) }
      self
    end

    def on_columns_about_to_be_removed(&block : ModelRowsColumnsEvent ->) : self
      @columns_about_to_be_removed.connect { |event| block.call(event) }
      self
    end

    def on_columns_removed(&block : ModelRowsColumnsEvent ->) : self
      @columns_removed.connect { |event| block.call(event) }
      self
    end

    private DATA_CHANGED_TRAMPOLINE = ->(userdata : Void*, top_left : Void*, bottom_right : Void*) do
      Box(AbstractItemModel).unbox(userdata).@data_changed.emit(ModelIndex.wrap(top_left, true), ModelIndex.wrap(bottom_right, true))
    end

    private HEADER_DATA_CHANGED_TRAMPOLINE = ->(userdata : Void*, orientation : Int32, first : Int32, last : Int32) do
      Box(AbstractItemModel).unbox(userdata).@header_data_changed.emit(Orientation.from_value(orientation), first, last)
    end

    private LAYOUT_ABOUT_TO_BE_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractItemModel).unbox(userdata).@layout_about_to_be_changed.emit
    end

    private LAYOUT_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractItemModel).unbox(userdata).@layout_changed.emit
    end

    private MODEL_ABOUT_TO_BE_RESET_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractItemModel).unbox(userdata).@model_about_to_be_reset.emit
    end

    private MODEL_RESET_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractItemModel).unbox(userdata).@model_reset.emit
    end

    private ROWS_ABOUT_TO_BE_INSERTED_TRAMPOLINE = ->(userdata : Void*, parent : Void*, first : Int32, last : Int32) do
      Box(AbstractItemModel).unbox(userdata).@rows_about_to_be_inserted.emit({parent: ModelIndex.wrap(parent, true), first: first, last: last})
    end

    private ROWS_INSERTED_TRAMPOLINE = ->(userdata : Void*, parent : Void*, first : Int32, last : Int32) do
      Box(AbstractItemModel).unbox(userdata).@rows_inserted.emit({parent: ModelIndex.wrap(parent, true), first: first, last: last})
    end

    private ROWS_ABOUT_TO_BE_REMOVED_TRAMPOLINE = ->(userdata : Void*, parent : Void*, first : Int32, last : Int32) do
      Box(AbstractItemModel).unbox(userdata).@rows_about_to_be_removed.emit({parent: ModelIndex.wrap(parent, true), first: first, last: last})
    end

    private ROWS_REMOVED_TRAMPOLINE = ->(userdata : Void*, parent : Void*, first : Int32, last : Int32) do
      Box(AbstractItemModel).unbox(userdata).@rows_removed.emit({parent: ModelIndex.wrap(parent, true), first: first, last: last})
    end

    private COLUMNS_ABOUT_TO_BE_INSERTED_TRAMPOLINE = ->(userdata : Void*, parent : Void*, first : Int32, last : Int32) do
      Box(AbstractItemModel).unbox(userdata).@columns_about_to_be_inserted.emit({parent: ModelIndex.wrap(parent, true), first: first, last: last})
    end

    private COLUMNS_INSERTED_TRAMPOLINE = ->(userdata : Void*, parent : Void*, first : Int32, last : Int32) do
      Box(AbstractItemModel).unbox(userdata).@columns_inserted.emit({parent: ModelIndex.wrap(parent, true), first: first, last: last})
    end

    private COLUMNS_ABOUT_TO_BE_REMOVED_TRAMPOLINE = ->(userdata : Void*, parent : Void*, first : Int32, last : Int32) do
      Box(AbstractItemModel).unbox(userdata).@columns_about_to_be_removed.emit({parent: ModelIndex.wrap(parent, true), first: first, last: last})
    end

    private COLUMNS_REMOVED_TRAMPOLINE = ->(userdata : Void*, parent : Void*, first : Int32, last : Int32) do
      Box(AbstractItemModel).unbox(userdata).@columns_removed.emit({parent: ModelIndex.wrap(parent, true), first: first, last: last})
    end
  end
end
