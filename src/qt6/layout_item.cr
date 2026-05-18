module Qt6
  # Wraps `QLayoutItem` values returned from layout queries and extraction APIs.
  class LayoutItem < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = true) : LayoutItem
      spacer_handle = LibQt6.qt6cr_layout_item_spacer_item(handle)
      return SpacerItem.wrap(spacer_handle, owned) unless spacer_handle.null?

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

    # Assigns geometry to the item and returns it.
    def geometry=(value : Rect) : Rect
      LibQt6.qt6cr_layout_item_set_geometry(to_unsafe, value.to_native)
      value
    end

    # Qt-style alias for `geometry=`.
    def set_geometry(value : Rect) : self
      self.geometry = value
      self
    end

    # Assigns geometry in pixels and returns `self`.
    def set_geometry(x : Number, y : Number, width : Number, height : Number) : self
      self.geometry = Rect.new(x.to_i, y.to_i, width.to_i, height.to_i)
      self
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

    # Returns the wrapped spacer item when this item represents one.
    def spacer_item : SpacerItem?
      handle = LibQt6.qt6cr_layout_item_spacer_item(to_unsafe)
      handle.null? ? nil : SpacerItem.wrap(handle, false)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_layout_item_destroy(to_unsafe)
    end
  end
end
