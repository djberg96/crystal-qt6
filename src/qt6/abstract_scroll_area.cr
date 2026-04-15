module Qt6
  # Shared wrapper for `QAbstractScrollArea` descendants.
  abstract class AbstractScrollArea < Frame
    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
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
  end
end
