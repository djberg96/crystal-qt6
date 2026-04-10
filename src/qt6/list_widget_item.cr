module Qt6
  # Wraps `QListWidgetItem` for item-based list panels.
  class ListWidgetItem < NativeResource
    # Wraps an existing native item handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a list item with optional display text.
    def initialize(text : String = "")
      super(LibQt6.qt6cr_list_widget_item_create(text.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the item text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_list_widget_item_text(to_unsafe))
    end

    # Sets the item text.
    def text=(value : String) : String
      LibQt6.qt6cr_list_widget_item_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Stops tracking the item after ownership moves to a native parent widget.
    def adopt_by_parent! : Nil
      return unless @owned

      Qt6.untrack_object(self)
      @owned = false
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_list_widget_item_destroy(to_unsafe)
    end
  end
end