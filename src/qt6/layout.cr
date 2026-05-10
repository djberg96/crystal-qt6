module Qt6
  # Shared base class for layout wrappers.
  abstract class Layout < QObject
    protected def initialize(handle : LibQt6::Handle)
      super(handle, false)
    end

    # Returns the number of items currently managed by the layout.
    def count : Int32
      LibQt6.qt6cr_layout_count(@to_unsafe)
    end

    # Returns whether the layout is enabled.
    def enabled? : Bool
      LibQt6.qt6cr_layout_is_enabled(@to_unsafe)
    end

    # Enables or disables the layout.
    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_layout_set_enabled(@to_unsafe, value)
      value
    end

    # Qt-style alias for `enabled=`.
    def set_enabled(value : Bool) : self
      self.enabled = value
      self
    end

    # Activates the layout if necessary and returns whether it changed geometry.
    def activate : Bool
      LibQt6.qt6cr_layout_activate(@to_unsafe)
    end

    # Invalidates cached geometry and returns `self`.
    def invalidate : self
      LibQt6.qt6cr_layout_invalidate(@to_unsafe)
      self
    end

    # Schedules a relayout/update and returns `self`.
    def update : self
      LibQt6.qt6cr_layout_update(@to_unsafe)
      self
    end

    # Returns the preferred size for the full layout.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_layout_size_hint(@to_unsafe))
    end

    # Returns the minimum size for the full layout.
    def minimum_size : Size
      Size.from_native(LibQt6.qt6cr_layout_minimum_size(@to_unsafe))
    end

    # Returns the maximum size for the full layout.
    def maximum_size : Size
      Size.from_native(LibQt6.qt6cr_layout_maximum_size(@to_unsafe))
    end

    # Returns the current layout geometry.
    def geometry : Rect
      Rect.from_native(LibQt6.qt6cr_layout_geometry(@to_unsafe))
    end

    # Returns the rectangle inside the current contents margins.
    def contents_rect : Rect
      Rect.from_native(LibQt6.qt6cr_layout_contents_rect(@to_unsafe))
    end

    # Returns the current contents margins.
    def contents_margins : Margins
      value = LibQt6.qt6cr_layout_contents_margins(@to_unsafe)
      Margins.new(value.left, value.top, value.right, value.bottom)
    end

    # Returns the spacing used between layout items.
    def spacing : Int32
      LibQt6.qt6cr_layout_spacing(@to_unsafe)
    end

    # Sets the spacing used between layout items.
    def spacing=(value : Int) : Int32
      LibQt6.qt6cr_layout_set_spacing(@to_unsafe, value)
      value.to_i
    end

    # Sets layout margins in pixels.
    def set_contents_margins(left : Number, top : Number, right : Number, bottom : Number) : self
      LibQt6.qt6cr_layout_set_contents_margins(@to_unsafe, left.to_f64, top.to_f64, right.to_f64, bottom.to_f64)
      self
    end

    # Returns the layout index of the given child widget, or `-1`.
    def index_of(widget : Widget) : Int32
      LibQt6.qt6cr_layout_index_of_widget(@to_unsafe, widget.to_unsafe)
    end

    # Returns the item at the given index, if present.
    def item_at(index : Int) : LayoutItem?
      handle = LibQt6.qt6cr_layout_item_at(@to_unsafe, index.to_i32)
      handle.null? ? nil : LayoutItem.wrap(handle, false)
    end

    # Removes and returns the item at the given index, if present.
    def take_at(index : Int) : LayoutItem?
      handle = LibQt6.qt6cr_layout_take_at(@to_unsafe, index.to_i32)
      handle.null? ? nil : LayoutItem.wrap(handle, true)
    end

    # Removes a widget from the layout and returns it.
    def remove(widget : Widget) : Widget
      LibQt6.qt6cr_layout_remove_widget(@to_unsafe, widget.to_unsafe)
      widget
    end

    protected def adopt(widget : Widget) : Widget
      widget.adopt_by_parent!
      widget
    end
  end
end
