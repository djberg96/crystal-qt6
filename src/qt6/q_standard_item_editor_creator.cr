module Qt6
  # Wraps `QStandardItemEditorCreator`-style behavior with callback-backed
  # widget creation and automatic user-property discovery from created editors.
  class QStandardItemEditorCreator < QItemEditorCreatorBase
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super("")
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Registers a block that builds the editor widget for a given parent.
    # The first created widget's Qt user property becomes the creator's
    # `value_property_name`, matching Qt's standard creator behavior.
    def on_create_widget(&block : Widget -> Widget?) : self
      @create_widget_callback = block
      LibQt6.qt6cr_item_editor_creator_base_set_create_widget_callback(to_unsafe, CREATE_WIDGET_TRAMPOLINE, @create_widget_userdata)
      self
    end

    protected def build_widget(parent : Widget) : Widget?
      widget = super
      infer_value_property_name(widget) if widget
      widget
    end

    private def infer_value_property_name(widget : Widget) : Nil
      return unless value_property_name.empty?

      property_name = Qt6.copy_and_release_string(LibQt6.qt6cr_widget_user_property_name(widget.to_unsafe))
      return if property_name.empty?

      self.value_property_name = property_name
    end
  end
end
