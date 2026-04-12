module Qt6
  # Wraps `QStyledItemDelegate` and supports display formatting plus custom
  # editor lifecycle hooks.
  class StyledItemDelegate < QObject
    @display_text_formatter : Proc(String, String)? = nil
    @display_text_userdata : LibQt6::Handle = Pointer(Void).null
    @create_editor_callback : Proc(Widget, ModelIndex, Widget?)? = nil
    @create_editor_userdata : LibQt6::Handle = Pointer(Void).null
    @set_editor_data_callback : Proc(Widget, ModelData, ModelIndex, Nil)? = nil
    @set_editor_data_userdata : LibQt6::Handle = Pointer(Void).null
    @set_model_data_callback : Proc(Widget, AbstractItemModel, ModelIndex, Nil)? = nil
    @set_model_data_userdata : LibQt6::Handle = Pointer(Void).null
    @editor_wrappers = {} of LibQt6::Handle => Widget

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_styled_item_delegate_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      userdata = Box.box(self)
      @display_text_userdata = userdata
      @create_editor_userdata = userdata
      @set_editor_data_userdata = userdata
      @set_model_data_userdata = userdata
    end

    # Registers a block to format display text before Qt paints it.
    def on_display_text(&block : String -> String) : self
      @display_text_formatter = block
      LibQt6.qt6cr_styled_item_delegate_on_display_text(to_unsafe, DISPLAY_TEXT_TRAMPOLINE, @display_text_userdata)
      self
    end

    # Registers a block to build editors for items entering edit mode.
    #
    # Returning `nil` falls back to Qt's default editor for the index.
    def on_create_editor(&block : Widget, ModelIndex -> Widget?) : self
      @create_editor_callback = block
      LibQt6.qt6cr_styled_item_delegate_on_create_editor(to_unsafe, CREATE_EDITOR_TRAMPOLINE, @create_editor_userdata)
      self
    end

    # Registers a block to populate an editor from the model's edit-role value.
    def on_set_editor_data(&block : Widget, ModelData, ModelIndex ->) : self
      @set_editor_data_callback = block
      LibQt6.qt6cr_styled_item_delegate_on_set_editor_data(to_unsafe, SET_EDITOR_DATA_TRAMPOLINE, @set_editor_data_userdata)
      self
    end

    # Registers a block to commit editor state back into the model.
    def on_set_model_data(&block : Widget, AbstractItemModel, ModelIndex ->) : self
      @set_model_data_callback = block
      LibQt6.qt6cr_styled_item_delegate_on_set_model_data(to_unsafe, SET_MODEL_DATA_TRAMPOLINE, @set_model_data_userdata)
      self
    end

    # Returns the delegate's display text for a model value.
    def display_text(value) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_styled_item_delegate_display_text(to_unsafe, Qt6.model_data_to_native(value)))
    end

    # Invokes the delegate's editor factory for a parent/index pair.
    def create_editor(parent : Widget, index : ModelIndex) : Widget?
      handle = LibQt6.qt6cr_styled_item_delegate_create_editor(to_unsafe, parent.to_unsafe, index.to_unsafe)
      handle.null? ? nil : resolve_editor(handle)
    end

    # Invokes the delegate's editor-population path for an editor/index pair.
    def set_editor_data(editor : Widget, index : ModelIndex) : self
      LibQt6.qt6cr_styled_item_delegate_set_editor_data(to_unsafe, editor.to_unsafe, index.to_unsafe)
      self
    end

    # Invokes the delegate's commit path for an editor/model/index tuple.
    def set_model_data(editor : Widget, model : AbstractItemModel, index : ModelIndex) : self
      LibQt6.qt6cr_styled_item_delegate_set_model_data(to_unsafe, editor.to_unsafe, model.to_unsafe, index.to_unsafe)
      self
    end

    protected def format_display_text(text : String) : String
      formatter = @display_text_formatter
      formatter ? formatter.call(text) : text
    end

    protected def build_editor(parent : Widget, index : ModelIndex) : Widget?
      callback = @create_editor_callback
      return nil unless callback

      editor = callback.call(parent, index)
      remember_editor(editor) if editor
      editor
    end

    protected def populate_editor(editor : Widget, value : ModelData, index : ModelIndex) : Nil
      callback = @set_editor_data_callback
      callback.try(&.call(editor, value, index))
    end

    protected def commit_editor(editor : Widget, model : AbstractItemModel, index : ModelIndex) : Nil
      callback = @set_model_data_callback
      callback.try(&.call(editor, model, index))
    end

    private def remember_editor(editor : Widget) : Widget
      @editor_wrappers[editor.to_unsafe] = editor
      editor.destroyed.connect { @editor_wrappers.delete(editor.to_unsafe) }
      editor
    end

    protected def resolve_editor(handle : LibQt6::Handle) : Widget
      @editor_wrappers[handle]? || Widget.wrap(handle)
    end

    private DISPLAY_TEXT_TRAMPOLINE = ->(userdata : Void*, text : UInt8*) do
      formatted = Box(StyledItemDelegate).unbox(userdata).format_display_text(Qt6.copy_string(text))
      Qt6.malloc_string(formatted)
    end

    private CREATE_EDITOR_TRAMPOLINE = ->(userdata : Void*, parent_handle : Void*, index_handle : Void*) do
      delegate = Box(StyledItemDelegate).unbox(userdata)
      parent = Widget.wrap(parent_handle)
      index = ModelIndex.wrap(index_handle)
      delegate.build_editor(parent, index).try(&.to_unsafe) || Pointer(Void).null
    end

    private SET_EDITOR_DATA_TRAMPOLINE = ->(userdata : Void*, editor_handle : Void*, value : LibQt6::VariantValue, index_handle : Void*) do
      delegate = Box(StyledItemDelegate).unbox(userdata)
      editor = delegate.resolve_editor(editor_handle)
      index = ModelIndex.wrap(index_handle)
      delegate.populate_editor(editor, Qt6.model_data_from_native(value), index)
    end

    private SET_MODEL_DATA_TRAMPOLINE = ->(userdata : Void*, editor_handle : Void*, model_handle : Void*, index_handle : Void*) do
      delegate = Box(StyledItemDelegate).unbox(userdata)
      editor = delegate.resolve_editor(editor_handle)
      model = AbstractItemModel.wrap(model_handle)
      index = ModelIndex.wrap(index_handle)
      delegate.commit_editor(editor, model, index)
    end
  end
end
