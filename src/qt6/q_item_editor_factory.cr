module Qt6
  # Wraps `QItemEditorFactory`, which `QStyledItemDelegate` uses to create
  # default editors for model values.
  class QItemEditorFactory < NativeResource
    @@default_factory_ref : QItemEditorFactory?
    @registered_creators = [] of QItemEditorCreatorBase

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_item_editor_factory_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Creates an editor widget for the given Qt user type id.
    def create_editor(user_type : Int, parent : Widget) : Widget?
      handle = LibQt6.qt6cr_item_editor_factory_create_editor(to_unsafe, user_type.to_i32, parent.to_unsafe)
      return nil if handle.null?

      @registered_creators.each do |creator|
        if widget = creator.created_widget_wrapper?(handle)
          return widget
        end
      end

      Widget.wrap(handle)
    end

    # Creates an editor widget for the given example value's Qt user type.
    def create_editor_for(value, parent : Widget) : Widget?
      create_editor(Qt6.model_data_user_type(value), parent)
    end

    # Returns the editor value property name for the given Qt user type id.
    def value_property_name(user_type : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_item_editor_factory_value_property_name(to_unsafe, user_type.to_i32))
    end

    # Returns the editor value property name for the given example value's Qt user type.
    def value_property_name_for(value) : String
      value_property_name(Qt6.model_data_user_type(value))
    end

    # Registers an editor creator for the given Qt user type id.
    def register_editor(user_type : Int, creator : QItemEditorCreatorBase) : QItemEditorCreatorBase
      LibQt6.qt6cr_item_editor_factory_register_editor(to_unsafe, user_type.to_i32, creator.to_unsafe)
      creator.adopt_by_owner!
      @registered_creators << creator
      creator
    end

    # Registers an editor creator for the given example value's Qt user type.
    def register_editor_for(value, creator : QItemEditorCreatorBase) : QItemEditorCreatorBase
      register_editor(Qt6.model_data_user_type(value), creator)
    end

    # Returns the process-wide default item editor factory, if any.
    def self.default_factory : QItemEditorFactory?
      handle = LibQt6.qt6cr_item_editor_factory_default_factory
      handle.null? ? nil : wrap(handle)
    end

    # Sets the process-wide default item editor factory and returns it.
    def self.default_factory=(factory : QItemEditorFactory?) : QItemEditorFactory?
      LibQt6.qt6cr_item_editor_factory_set_default_factory(factory.try(&.to_unsafe) || Pointer(Void).null)
      @@default_factory_ref = factory
      factory
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_item_editor_factory_destroy(to_unsafe)
    end
  end
end
