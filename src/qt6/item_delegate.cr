module Qt6
  # Wraps `QItemDelegate` and supports display formatting plus custom editor
  # lifecycle hooks.
  class ItemDelegate < QObject
    @display_text_formatter : Proc(String, String)? = nil
    @display_text_userdata : LibQt6::Handle = Pointer(Void).null
    @create_editor_callback : Proc(Widget, ModelIndex, Widget?)? = nil
    @create_editor_with_option_callback : Proc(Widget, StyleOptionViewItem, ModelIndex, Widget?)? = nil
    @create_editor_userdata : LibQt6::Handle = Pointer(Void).null
    @set_editor_data_callback : Proc(Widget, ModelData, ModelIndex, Nil)? = nil
    @set_editor_data_userdata : LibQt6::Handle = Pointer(Void).null
    @set_model_data_callback : Proc(Widget, AbstractItemModel, ModelIndex, Nil)? = nil
    @set_model_data_userdata : LibQt6::Handle = Pointer(Void).null
    @paint_callback : Proc(QPainter, StyleOptionViewItem, ModelIndex, Bool)? = nil
    @paint_userdata : LibQt6::Handle = Pointer(Void).null
    @size_hint_callback : Proc(StyleOptionViewItem, ModelIndex, Size?)? = nil
    @size_hint_userdata : LibQt6::Handle = Pointer(Void).null
    @update_editor_geometry_callback : Proc(Widget, StyleOptionViewItem, ModelIndex, Nil)? = nil
    @update_editor_geometry_userdata : LibQt6::Handle = Pointer(Void).null
    @editor_event_callback : Proc(QEvent, AbstractItemModel, StyleOptionViewItem, ModelIndex, Bool)? = nil
    @editor_event_userdata : LibQt6::Handle = Pointer(Void).null
    @event_filter_callback : Proc(QObject?, QEvent, Bool)? = nil
    @event_filter_userdata : LibQt6::Handle = Pointer(Void).null
    @editor_wrappers = {} of LibQt6::Handle => Widget

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_item_delegate_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      initialize_delegate_userdata
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      initialize_delegate_userdata
    end

    def on_display_text(&block : String -> String) : self
      @display_text_formatter = block
      LibQt6.qt6cr_item_delegate_on_display_text(to_unsafe, DISPLAY_TEXT_TRAMPOLINE, @display_text_userdata)
      self
    end

    def on_create_editor(&block : Widget, ModelIndex -> Widget?) : self
      @create_editor_callback = block
      @create_editor_with_option_callback = nil
      LibQt6.qt6cr_item_delegate_on_create_editor(to_unsafe, CREATE_EDITOR_TRAMPOLINE, @create_editor_userdata)
      self
    end

    def on_create_editor_with_option(&block : Widget, StyleOptionViewItem, ModelIndex -> Widget?) : self
      @create_editor_callback = nil
      @create_editor_with_option_callback = block
      LibQt6.qt6cr_item_delegate_on_create_editor(to_unsafe, CREATE_EDITOR_TRAMPOLINE, @create_editor_userdata)
      self
    end

    def on_set_editor_data(&block : Widget, ModelData, ModelIndex ->) : self
      @set_editor_data_callback = block
      LibQt6.qt6cr_item_delegate_on_set_editor_data(to_unsafe, SET_EDITOR_DATA_TRAMPOLINE, @set_editor_data_userdata)
      self
    end

    def on_set_model_data(&block : Widget, AbstractItemModel, ModelIndex ->) : self
      @set_model_data_callback = block
      LibQt6.qt6cr_item_delegate_on_set_model_data(to_unsafe, SET_MODEL_DATA_TRAMPOLINE, @set_model_data_userdata)
      self
    end

    def on_paint(&block : QPainter, StyleOptionViewItem, ModelIndex -> Bool) : self
      @paint_callback = block
      LibQt6.qt6cr_item_delegate_on_paint(to_unsafe, PAINT_TRAMPOLINE, @paint_userdata)
      self
    end

    def on_size_hint(&block : StyleOptionViewItem, ModelIndex -> Size?) : self
      @size_hint_callback = block
      LibQt6.qt6cr_item_delegate_on_size_hint(to_unsafe, SIZE_HINT_TRAMPOLINE, @size_hint_userdata)
      self
    end

    def on_update_editor_geometry(&block : Widget, StyleOptionViewItem, ModelIndex ->) : self
      @update_editor_geometry_callback = block
      LibQt6.qt6cr_item_delegate_on_update_editor_geometry(to_unsafe, UPDATE_EDITOR_GEOMETRY_TRAMPOLINE, @update_editor_geometry_userdata)
      self
    end

    def on_editor_event(&block : QEvent, AbstractItemModel, StyleOptionViewItem, ModelIndex -> Bool) : self
      @editor_event_callback = block
      LibQt6.qt6cr_item_delegate_on_editor_event(to_unsafe, EDITOR_EVENT_TRAMPOLINE, @editor_event_userdata)
      self
    end

    def on_event_filter(&block : QObject?, QEvent -> Bool) : self
      @event_filter_callback = block
      LibQt6.qt6cr_item_delegate_on_event_filter(to_unsafe, EVENT_FILTER_TRAMPOLINE, @event_filter_userdata)
      self
    end

    def display_text(value) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_item_delegate_display_text(to_unsafe, Qt6.model_data_to_native(value)))
    end

    def create_editor(parent : Widget, index : ModelIndex) : Widget?
      handle = LibQt6.qt6cr_item_delegate_create_editor(to_unsafe, parent.to_unsafe, index.to_unsafe)
      handle.null? ? nil : resolve_editor(handle)
    end

    def create_editor(parent : Widget, option : StyleOptionViewItem, index : ModelIndex) : Widget?
      handle = LibQt6.qt6cr_item_delegate_create_editor_with_option(to_unsafe, parent.to_unsafe, option.to_unsafe, index.to_unsafe)
      handle.null? ? nil : resolve_editor(handle)
    end

    def set_editor_data(editor : Widget, index : ModelIndex) : self
      LibQt6.qt6cr_item_delegate_set_editor_data(to_unsafe, editor.to_unsafe, index.to_unsafe)
      self
    end

    def set_model_data(editor : Widget, model : AbstractItemModel, index : ModelIndex) : self
      LibQt6.qt6cr_item_delegate_set_model_data(to_unsafe, editor.to_unsafe, model.to_unsafe, index.to_unsafe)
      self
    end

    def update_editor_geometry(editor : Widget, option : StyleOptionViewItem, index : ModelIndex) : self
      LibQt6.qt6cr_item_delegate_update_editor_geometry(to_unsafe, editor.to_unsafe, option.to_unsafe, index.to_unsafe)
      self
    end

    def editor_event(event : QEvent, model : AbstractItemModel, option : StyleOptionViewItem, index : ModelIndex) : Bool
      LibQt6.qt6cr_item_delegate_editor_event(to_unsafe, event.to_unsafe, model.to_unsafe, option.to_unsafe, index.to_unsafe)
    end

    def event_filter(object : QObject, event : QEvent) : Bool
      LibQt6.qt6cr_item_delegate_event_filter(to_unsafe, object.to_unsafe, event.to_unsafe)
    end

    def item_editor_factory : QItemEditorFactory?
      handle = LibQt6.qt6cr_item_delegate_item_editor_factory(to_unsafe)
      handle.null? ? nil : QItemEditorFactory.wrap(handle)
    end

    def item_editor_factory=(factory : QItemEditorFactory?) : QItemEditorFactory?
      LibQt6.qt6cr_item_delegate_set_item_editor_factory(to_unsafe, factory.try(&.to_unsafe) || Pointer(Void).null)
      factory
    end

    def clipping? : Bool
      LibQt6.qt6cr_item_delegate_clipping(to_unsafe)
    end

    def clipping=(value : Bool) : Bool
      LibQt6.qt6cr_item_delegate_set_clipping(to_unsafe, value)
      value
    end

    protected def format_display_text(text : String) : String
      formatter = @display_text_formatter
      formatter ? formatter.call(text) : text
    end

    protected def build_editor(parent : Widget, option : StyleOptionViewItem, index : ModelIndex) : Widget?
      if callback = @create_editor_with_option_callback
        editor = callback.call(parent, option, index)
        remember_editor(editor) if editor
        return editor
      end

      callback = @create_editor_callback
      return nil unless callback
      editor = callback.call(parent, index)
      remember_editor(editor) if editor
      editor
    end

    protected def populate_editor(editor : Widget, value : ModelData, index : ModelIndex) : Nil
      @set_editor_data_callback.try(&.call(editor, value, index))
    end

    protected def commit_editor(editor : Widget, model : AbstractItemModel, index : ModelIndex) : Nil
      @set_model_data_callback.try(&.call(editor, model, index))
    end

    protected def paint_item(painter : QPainter, option : StyleOptionViewItem, index : ModelIndex) : Bool
      callback = @paint_callback
      callback ? callback.call(painter, option, index) : false
    end

    protected def item_size_hint(option : StyleOptionViewItem, index : ModelIndex) : Size?
      @size_hint_callback.try(&.call(option, index))
    end

    protected def dispatch_update_editor_geometry(editor : Widget, option : StyleOptionViewItem, index : ModelIndex) : Nil
      @update_editor_geometry_callback.try(&.call(editor, option, index))
    end

    protected def handle_editor_event(event : QEvent, model : AbstractItemModel, option : StyleOptionViewItem, index : ModelIndex) : Bool
      callback = @editor_event_callback
      callback ? callback.call(event, model, option, index) : false
    end

    protected def filter_editor_event(object_handle : LibQt6::Handle, event : QEvent) : Bool
      callback = @event_filter_callback
      return false unless callback

      object = object_handle.null? ? nil : QObject.wrap(object_handle)
      callback.call(object, event)
    end

    private def remember_editor(editor : Widget) : Widget
      @editor_wrappers[editor.to_unsafe] = editor
      editor.destroyed.connect { @editor_wrappers.delete(editor.to_unsafe) }
      editor
    end

    protected def resolve_editor(handle : LibQt6::Handle) : Widget
      @editor_wrappers[handle]? || Widget.wrap(handle)
    end

    private def initialize_delegate_userdata : Nil
      userdata = Box.box(self)
      @display_text_userdata = userdata
      @create_editor_userdata = userdata
      @set_editor_data_userdata = userdata
      @set_model_data_userdata = userdata
      @paint_userdata = userdata
      @size_hint_userdata = userdata
      @update_editor_geometry_userdata = userdata
      @editor_event_userdata = userdata
      @event_filter_userdata = userdata
    end

    private DISPLAY_TEXT_TRAMPOLINE = ->(userdata : Void*, text : UInt8*) do
      formatted = Box(ItemDelegate).unbox(userdata).format_display_text(Qt6.copy_string(text))
      Qt6.malloc_string(formatted)
    end

    private CREATE_EDITOR_TRAMPOLINE = ->(userdata : Void*, parent_handle : Void*, option_handle : Void*, index_handle : Void*) do
      delegate = Box(ItemDelegate).unbox(userdata)
      parent = Widget.wrap(parent_handle)
      option = StyleOptionViewItem.wrap(option_handle)
      index = ModelIndex.wrap(index_handle)
      delegate.build_editor(parent, option, index).try(&.to_unsafe) || Pointer(Void).null
    end

    private SET_EDITOR_DATA_TRAMPOLINE = ->(userdata : Void*, editor_handle : Void*, value : LibQt6::VariantValue, index_handle : Void*) do
      delegate = Box(ItemDelegate).unbox(userdata)
      editor = delegate.resolve_editor(editor_handle)
      index = ModelIndex.wrap(index_handle)
      delegate.populate_editor(editor, Qt6.model_data_from_native(value), index)
    end

    private SET_MODEL_DATA_TRAMPOLINE = ->(userdata : Void*, editor_handle : Void*, model_handle : Void*, index_handle : Void*) do
      delegate = Box(ItemDelegate).unbox(userdata)
      editor = delegate.resolve_editor(editor_handle)
      model = AbstractItemModel.wrap(model_handle)
      index = ModelIndex.wrap(index_handle)
      delegate.commit_editor(editor, model, index)
    end

    private PAINT_TRAMPOLINE = ->(userdata : Void*, painter_handle : Void*, option_handle : Void*, index_handle : Void*) do
      delegate = Box(ItemDelegate).unbox(userdata)
      painter = QPainter.wrap(painter_handle)
      option = StyleOptionViewItem.wrap(option_handle)
      index = ModelIndex.wrap(index_handle)
      delegate.paint_item(painter, option, index)
    end

    private SIZE_HINT_TRAMPOLINE = ->(userdata : Void*, option_handle : Void*, index_handle : Void*) do
      delegate = Box(ItemDelegate).unbox(userdata)
      option = StyleOptionViewItem.wrap(option_handle)
      index = ModelIndex.wrap(index_handle)
      if size = delegate.item_size_hint(option, index)
        LibQt6::SizeValue.new(width: size.width, height: size.height)
      else
        LibQt6::SizeValue.new(width: -1, height: -1)
      end
    end

    private UPDATE_EDITOR_GEOMETRY_TRAMPOLINE = ->(userdata : Void*, editor_handle : Void*, option_handle : Void*, index_handle : Void*) do
      delegate = Box(ItemDelegate).unbox(userdata)
      editor = delegate.resolve_editor(editor_handle)
      option = StyleOptionViewItem.wrap(option_handle)
      index = ModelIndex.wrap(index_handle)
      delegate.dispatch_update_editor_geometry(editor, option, index)
    end

    private EDITOR_EVENT_TRAMPOLINE = ->(userdata : Void*, event_handle : Void*, model_handle : Void*, option_handle : Void*, index_handle : Void*) do
      delegate = Box(ItemDelegate).unbox(userdata)
      event = QEvent.new(event_handle)
      model = AbstractItemModel.wrap(model_handle)
      option = StyleOptionViewItem.wrap(option_handle)
      index = ModelIndex.wrap(index_handle)
      delegate.handle_editor_event(event, model, option, index)
    end

    private EVENT_FILTER_TRAMPOLINE = ->(userdata : Void*, object_handle : Void*, event_handle : Void*) do
      delegate = Box(ItemDelegate).unbox(userdata)
      delegate.filter_editor_event(object_handle, QEvent.new(event_handle))
    end
  end
end
