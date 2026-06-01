module Qt6
  # Wraps `QWidgetItem`, the layout-item adapter Qt uses for widget-backed entries.
  class WidgetItem < LayoutItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = true) : self
      new(handle, owned)
    end

    # Creates a widget item that adapts the given widget into layout APIs.
    def initialize(widget : Widget)
      super(LibQt6.qt6cr_widget_item_create(widget.to_unsafe), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the wrapped widget.
    def widget : Widget
      super.not_nil!
    end
  end
end
