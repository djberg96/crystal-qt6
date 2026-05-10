module Qt6
  # Wraps `QLayoutItem` values returned from layout queries and extraction APIs.
  class LayoutItem < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = true) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the preferred item size.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_layout_item_size_hint(to_unsafe))
    end

    # Returns the minimum item size.
    def minimum_size : Size
      Size.from_native(LibQt6.qt6cr_layout_item_minimum_size(to_unsafe))
    end

    # Returns the maximum item size.
    def maximum_size : Size
      Size.from_native(LibQt6.qt6cr_layout_item_maximum_size(to_unsafe))
    end

    # Returns the current geometry assigned to the item.
    def geometry : Rect
      Rect.from_native(LibQt6.qt6cr_layout_item_geometry(to_unsafe))
    end

    # Returns the item's alignment flags within its parent layout.
    def alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_layout_item_alignment(to_unsafe))
    end

    # Returns `true` when the item contributes no visible or measurable content.
    def empty? : Bool
      LibQt6.qt6cr_layout_item_is_empty(to_unsafe)
    end

    # Returns the wrapped widget when this item represents one.
    def widget : Widget?
      handle = LibQt6.qt6cr_layout_item_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Returns the wrapped layout when this item represents one.
    def layout : Layout?
      handle = LibQt6.qt6cr_layout_item_layout(to_unsafe)
      handle.null? ? nil : LayoutHandle.wrap(handle)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_layout_item_destroy(to_unsafe)
    end
  end
end
