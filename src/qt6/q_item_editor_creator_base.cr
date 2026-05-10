module Qt6
  # Wraps `QItemEditorCreatorBase` with callback-backed widget creation.
  class QItemEditorCreatorBase < NativeResource
    @create_widget_callback : Proc(Widget, Widget?)? = nil
    @create_widget_userdata : LibQt6::Handle = Pointer(Void).null
    @widget_wrappers = {} of LibQt6::Handle => Widget

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(value_property_name : String = "")
      super(LibQt6.qt6cr_item_editor_creator_base_create(value_property_name.to_unsafe))
      initialize_creator_userdata
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      initialize_creator_userdata
    end

    # Registers a block that builds the editor widget for a given parent.
    def on_create_widget(&block : Widget -> Widget?) : self
      @create_widget_callback = block
      LibQt6.qt6cr_item_editor_creator_base_set_create_widget_callback(to_unsafe, CREATE_WIDGET_TRAMPOLINE, @create_widget_userdata)
      self
    end

    # Creates an editor widget for the given parent.
    def create_widget(parent : Widget) : Widget?
      handle = LibQt6.qt6cr_item_editor_creator_base_create_widget(to_unsafe, parent.to_unsafe)
      handle.null? ? nil : resolve_widget(handle)
    end

    # Returns the widget property name used to read/write edited values.
    def value_property_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_item_editor_creator_base_value_property_name(to_unsafe))
    end

    # Sets the widget property name used to read/write edited values.
    def value_property_name=(value : String) : String
      LibQt6.qt6cr_item_editor_creator_base_set_value_property_name(to_unsafe, value.to_unsafe)
      value
    end

    protected def build_widget(parent : Widget) : Widget?
      callback = @create_widget_callback
      return nil unless callback

      widget = callback.call(parent)
      remember_widget(widget) if widget
      widget
    end

    protected def resolve_widget(handle : LibQt6::Handle) : Widget
      @widget_wrappers[handle]? || Widget.wrap(handle)
    end

    def created_widget_wrapper?(handle : LibQt6::Handle) : Widget?
      @widget_wrappers[handle]?
    end

    private def remember_widget(widget : Widget) : Widget
      @widget_wrappers[widget.to_unsafe] = widget
      widget.destroyed.connect { @widget_wrappers.delete(widget.to_unsafe) }
      widget
    end

    private def initialize_creator_userdata : Nil
      @create_widget_userdata = Box.box(self)
    end

    private CREATE_WIDGET_TRAMPOLINE = ->(userdata : Void*, parent_handle : Void*) do
      creator = Box(QItemEditorCreatorBase).unbox(userdata)
      parent = Widget.wrap(parent_handle)
      creator.build_widget(parent).try(&.to_unsafe) || Pointer(Void).null
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_item_editor_creator_base_destroy(to_unsafe)
    end
  end
end
