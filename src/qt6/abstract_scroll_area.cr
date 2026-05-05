module Qt6
  # Shared wrapper for `QAbstractScrollArea` descendants.
  abstract class AbstractScrollArea < Frame
    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the borrowed viewport widget used to display scrollable content.
    def viewport : Widget
      Widget.wrap(LibQt6.qt6cr_abstract_scroll_area_viewport(to_unsafe))
    end

    # Returns the vertical scrollbar policy.
    def vertical_scroll_bar_policy : ScrollBarPolicy
      ScrollBarPolicy.from_value(LibQt6.qt6cr_abstract_scroll_area_vertical_scroll_bar_policy(to_unsafe))
    end

    # Sets the vertical scrollbar policy and returns it.
    def vertical_scroll_bar_policy=(value : ScrollBarPolicy) : ScrollBarPolicy
      LibQt6.qt6cr_abstract_scroll_area_set_vertical_scroll_bar_policy(to_unsafe, value.value)
      value
    end

    # Returns the horizontal scrollbar policy.
    def horizontal_scroll_bar_policy : ScrollBarPolicy
      ScrollBarPolicy.from_value(LibQt6.qt6cr_abstract_scroll_area_horizontal_scroll_bar_policy(to_unsafe))
    end

    # Sets the horizontal scrollbar policy and returns it.
    def horizontal_scroll_bar_policy=(value : ScrollBarPolicy) : ScrollBarPolicy
      LibQt6.qt6cr_abstract_scroll_area_set_horizontal_scroll_bar_policy(to_unsafe, value.value)
      value
    end

    # Returns the vertical scrollbar wrapper.
    def vertical_scroll_bar : ScrollBar
      ScrollBar.wrap(LibQt6.qt6cr_abstract_scroll_area_vertical_scroll_bar(to_unsafe))
    end

    # Returns the horizontal scrollbar wrapper.
    def horizontal_scroll_bar : ScrollBar
      ScrollBar.wrap(LibQt6.qt6cr_abstract_scroll_area_horizontal_scroll_bar(to_unsafe))
    end

    # Returns the widget placed in the scrollbar corner, if present.
    def corner_widget : Widget?
      handle = LibQt6.qt6cr_abstract_scroll_area_corner_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Sets or clears the widget placed in the scrollbar corner.
    def corner_widget=(widget : Widget?) : Widget?
      LibQt6.qt6cr_abstract_scroll_area_set_corner_widget(to_unsafe, widget.try(&.to_unsafe) || Pointer(Void).null)
      widget.try(&.adopt_by_parent!)
      widget
    end

    # Returns the largest viewport size currently available inside the frame.
    def maximum_viewport_size : Size
      Size.from_native(LibQt6.qt6cr_abstract_scroll_area_maximum_viewport_size(to_unsafe))
    end

    # Returns how the scroll area adjusts itself to its viewport contents.
    def size_adjust_policy : AbstractScrollAreaSizeAdjustPolicy
      AbstractScrollAreaSizeAdjustPolicy.from_value(LibQt6.qt6cr_abstract_scroll_area_size_adjust_policy(to_unsafe))
    end

    # Sets how the scroll area adjusts itself to its viewport contents.
    def size_adjust_policy=(value : AbstractScrollAreaSizeAdjustPolicy) : AbstractScrollAreaSizeAdjustPolicy
      LibQt6.qt6cr_abstract_scroll_area_set_size_adjust_policy(to_unsafe, value.value)
      value
    end
  end
end
