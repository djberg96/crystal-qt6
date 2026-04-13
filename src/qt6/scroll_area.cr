module Qt6
  # Wraps `QScrollArea`.
  class ScrollArea < Frame
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

    # Returns the vertical scrollbar policy.
    def vertical_scroll_bar_policy : ScrollBarPolicy
      ScrollBarPolicy.from_value(LibQt6.qt6cr_scroll_area_vertical_scroll_bar_policy(to_unsafe))
    end

    # Sets the vertical scrollbar policy and returns it.
    def vertical_scroll_bar_policy=(value : ScrollBarPolicy) : ScrollBarPolicy
      LibQt6.qt6cr_scroll_area_set_vertical_scroll_bar_policy(to_unsafe, value.value)
      value
    end

    # Returns the horizontal scrollbar policy.
    def horizontal_scroll_bar_policy : ScrollBarPolicy
      ScrollBarPolicy.from_value(LibQt6.qt6cr_scroll_area_horizontal_scroll_bar_policy(to_unsafe))
    end

    # Sets the horizontal scrollbar policy and returns it.
    def horizontal_scroll_bar_policy=(value : ScrollBarPolicy) : ScrollBarPolicy
      LibQt6.qt6cr_scroll_area_set_horizontal_scroll_bar_policy(to_unsafe, value.value)
      value
    end
  end
end
