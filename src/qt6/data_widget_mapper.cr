module Qt6
  # Wraps `QDataWidgetMapper` for binding widget properties to item-model data.
  class DataWidgetMapper < QObject
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Signal emitted when the mapped row/column index changes.
    getter current_index_changed : Signal(Int32)

    # Creates a mapper with an optional parent.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_data_widget_mapper_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      initialize_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      initialize_callbacks
    end

    # Assigns the source model and returns it.
    def model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_data_widget_mapper_set_model(to_unsafe, model.to_unsafe)
      model
    end

    # Returns the current source model, if any.
    def model : AbstractItemModel?
      handle = LibQt6.qt6cr_data_widget_mapper_model(to_unsafe)
      handle.null? ? nil : AbstractItemModel.wrap(handle)
    end

    # Assigns the item delegate and returns it.
    def item_delegate=(delegate : StyledItemDelegate) : StyledItemDelegate
      LibQt6.qt6cr_data_widget_mapper_set_item_delegate(to_unsafe, delegate.to_unsafe)
      delegate
    end

    # Returns the current item delegate, if any.
    def item_delegate : StyledItemDelegate?
      handle = LibQt6.qt6cr_data_widget_mapper_item_delegate(to_unsafe)
      handle.null? ? nil : StyledItemDelegate.wrap(handle)
    end

    # Sets the root model index used by the mapper and returns it.
    def root_index=(index : ModelIndex) : ModelIndex
      LibQt6.qt6cr_data_widget_mapper_set_root_index(to_unsafe, index.to_unsafe)
      index
    end

    # Returns the current root model index.
    def root_index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_data_widget_mapper_root_index(to_unsafe), true)
    end

    # Sets the mapping orientation and returns it.
    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_data_widget_mapper_set_orientation(to_unsafe, value.value)
      value
    end

    # Returns the current mapping orientation.
    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_data_widget_mapper_orientation(to_unsafe))
    end

    # Sets the submit policy and returns it.
    def submit_policy=(value : DataWidgetMapperSubmitPolicy) : DataWidgetMapperSubmitPolicy
      LibQt6.qt6cr_data_widget_mapper_set_submit_policy(to_unsafe, value.value)
      value
    end

    # Returns the current submit policy.
    def submit_policy : DataWidgetMapperSubmitPolicy
      DataWidgetMapperSubmitPolicy.from_value(LibQt6.qt6cr_data_widget_mapper_submit_policy(to_unsafe))
    end

    # Adds a widget mapping for the given section and returns the widget.
    def add_mapping(widget : Widget, section : Int) : Widget
      LibQt6.qt6cr_data_widget_mapper_add_mapping(to_unsafe, widget.to_unsafe, section.to_i32)
      widget
    end

    # Adds a widget mapping for the given section/property and returns the widget.
    def add_mapping(widget : Widget, section : Int, property_name : String) : Widget
      LibQt6.qt6cr_data_widget_mapper_add_mapping_property(to_unsafe, widget.to_unsafe, section.to_i32, property_name.to_unsafe)
      widget
    end

    # Removes the mapping for the given widget and returns it.
    def remove_mapping(widget : Widget) : Widget
      LibQt6.qt6cr_data_widget_mapper_remove_mapping(to_unsafe, widget.to_unsafe)
      widget
    end

    # Returns the section mapped to the given widget, or `-1` when absent.
    def mapped_section(widget : Widget) : Int32
      LibQt6.qt6cr_data_widget_mapper_mapped_section(to_unsafe, widget.to_unsafe)
    end

    # Returns the mapped property name for the given widget.
    def mapped_property_name(widget : Widget) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_data_widget_mapper_mapped_property_name(to_unsafe, widget.to_unsafe))
    end

    # Returns the widget mapped at the given section, if present.
    def mapped_widget_at(section : Int) : Widget?
      handle = LibQt6.qt6cr_data_widget_mapper_mapped_widget_at(to_unsafe, section.to_i32)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Clears all mappings.
    def clear_mapping : self
      LibQt6.qt6cr_data_widget_mapper_clear_mapping(to_unsafe)
      self
    end

    # Returns the current mapped row/column index.
    def current_index : Int32
      LibQt6.qt6cr_data_widget_mapper_current_index(to_unsafe)
    end

    # Sets the current mapped row/column index and returns it.
    def current_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_data_widget_mapper_set_current_index(to_unsafe, int_value)
      int_value
    end

    # Positions the mapper at the given model index.
    def set_current_model_index(index : ModelIndex) : ModelIndex
      LibQt6.qt6cr_data_widget_mapper_set_current_model_index(to_unsafe, index.to_unsafe)
      index
    end

    # Restores the current widget values from the model.
    def revert : self
      LibQt6.qt6cr_data_widget_mapper_revert(to_unsafe)
      self
    end

    # Commits current widget values back into the model.
    def submit : Bool
      LibQt6.qt6cr_data_widget_mapper_submit(to_unsafe)
    end

    # Moves to the first mapped row/column.
    def to_first : self
      LibQt6.qt6cr_data_widget_mapper_to_first(to_unsafe)
      self
    end

    # Moves to the last mapped row/column.
    def to_last : self
      LibQt6.qt6cr_data_widget_mapper_to_last(to_unsafe)
      self
    end

    # Moves to the next mapped row/column.
    def to_next : self
      LibQt6.qt6cr_data_widget_mapper_to_next(to_unsafe)
      self
    end

    # Moves to the previous mapped row/column.
    def to_previous : self
      LibQt6.qt6cr_data_widget_mapper_to_previous(to_unsafe)
      self
    end

    # Registers a block to run when the current mapped index changes.
    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    private def initialize_callbacks : Nil
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_data_widget_mapper_on_current_index_changed(to_unsafe, CURRENT_INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    private CURRENT_INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(DataWidgetMapper).unbox(userdata).emit_current_index_changed(value)
    end
  end
end
