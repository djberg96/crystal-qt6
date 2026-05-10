module Qt6
  # Wraps `QItemEditorCreator` with callback-backed widget creation.
  class QItemEditorCreator < QItemEditorCreatorBase
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(value_property_name : String = "")
      super(LibQt6.qt6cr_item_editor_creator_create(value_property_name.to_unsafe), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def create_widget(parent : Widget) : Widget?
      handle = LibQt6.qt6cr_item_editor_creator_create_widget(to_unsafe, parent.to_unsafe)
      handle.null? ? nil : resolve_widget(handle)
    end

    def value_property_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_item_editor_creator_value_property_name(to_unsafe))
    end

    def value_property_name=(value : String) : String
      LibQt6.qt6cr_item_editor_creator_set_value_property_name(to_unsafe, value.to_unsafe)
      value
    end

    def on_create_widget(&block : Widget -> Widget?) : self
      @create_widget_callback = block
      LibQt6.qt6cr_item_editor_creator_set_create_widget_callback(to_unsafe, CREATE_WIDGET_TRAMPOLINE, @create_widget_userdata)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_item_editor_creator_destroy(to_unsafe)
    end
  end
end
