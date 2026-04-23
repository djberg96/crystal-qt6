module Qt6
  # Wraps `QScrollArea`.
  class ScrollArea < AbstractScrollArea
    # Creates a scroll area with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_scroll_area_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Returns the scroll area's child widget, if present.
    def widget : Widget?
      handle = LibQt6.qt6cr_scroll_area_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Sets the scroll area's child widget and returns it.
    def widget=(widget : Widget) : Widget
      LibQt6.qt6cr_scroll_area_set_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Removes and returns the current child widget, if present.
    def take_widget : Widget?
      handle = LibQt6.qt6cr_scroll_area_take_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
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

    # Scrolls until the given content point is visible.
    def ensure_visible(x : Int, y : Int, xmargin : Int = 50, ymargin : Int = 50) : self
      LibQt6.qt6cr_scroll_area_ensure_visible(to_unsafe, x.to_i32, y.to_i32, xmargin.to_i32, ymargin.to_i32)
      self
    end

    # Scrolls until the given child widget is visible.
    def ensure_widget_visible(widget : Widget, xmargin : Int = 50, ymargin : Int = 50) : self
      LibQt6.qt6cr_scroll_area_ensure_widget_visible(to_unsafe, widget.to_unsafe, xmargin.to_i32, ymargin.to_i32)
      self
    end
  end
end
