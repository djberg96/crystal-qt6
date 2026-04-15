module Qt6
  # Wraps `QScrollArea`.
  class ScrollArea < AbstractScrollArea
    # Creates a scroll area with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_scroll_area_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Sets the scroll area's child widget and returns it.
    def widget=(widget : Widget) : Widget
      LibQt6.qt6cr_scroll_area_set_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Returns `true` when the child widget is resized with the viewport.
    def widget_resizable? : Bool
      LibQt6.qt6cr_scroll_area_widget_resizable(to_unsafe)
    end

    # Enables or disables automatic child resizing.
    def widget_resizable=(value : Bool) : Bool
      LibQt6.qt6cr_scroll_area_set_widget_resizable(to_unsafe, value)
      value
    end
  end
end
