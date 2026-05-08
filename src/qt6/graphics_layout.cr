module Qt6
  # Wraps `QGraphicsLayout` handles shared by concrete graphics layouts.
  abstract class GraphicsLayout < NativeResource
    private ANCHOR_KIND = 1
    private GRID_KIND   = 2

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : GraphicsLayout
      case LibQt6.qt6cr_graphics_layout_kind(handle)
      when ANCHOR_KIND
        GraphicsAnchorLayout.wrap(handle, owned)
      when GRID_KIND
        GraphicsGridLayout.wrap(handle, owned)
      else
        raise Error.new("Unsupported QGraphicsLayout handle")
      end
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the number of layout items currently tracked by the layout.
    def count : Int32
      LibQt6.qt6cr_graphics_layout_count(to_unsafe)
    end

    # Activates the layout and returns `self`.
    def activate : self
      LibQt6.qt6cr_graphics_layout_activate(to_unsafe)
      self
    end

    # Returns `true` when the layout has been activated.
    def activated? : Bool
      LibQt6.qt6cr_graphics_layout_is_activated(to_unsafe)
    end

    # Invalidates cached layout geometry.
    def invalidate : self
      LibQt6.qt6cr_graphics_layout_invalidate(to_unsafe)
      self
    end

    # Notifies the parent widget that this layout's geometry hints changed.
    def update_geometry : self
      LibQt6.qt6cr_graphics_layout_update_geometry(to_unsafe)
      self
    end

    # Removes the layout item at the given linear index.
    def remove_at(index : Int) : self
      LibQt6.qt6cr_graphics_layout_remove_at(to_unsafe, index.to_i)
      self
    end

    # Sets the contents margins and returns `self`.
    def set_contents_margins(left : Number, top : Number, right : Number, bottom : Number) : self
      LibQt6.qt6cr_graphics_layout_set_contents_margins(
        to_unsafe,
        left.to_f64,
        top.to_f64,
        right.to_f64,
        bottom.to_f64
      )
      self
    end

    # Returns the current contents margins.
    def contents_margins : MarginsF
      value = LibQt6.qt6cr_graphics_layout_contents_margins(to_unsafe)
      MarginsF.new(value.left, value.top, value.right, value.bottom)
    end

    # Returns the layout item's horizontal size policy.
    def horizontal_size_policy : SizePolicy
      SizePolicy.from_value(LibQt6.qt6cr_graphics_layout_item_horizontal_size_policy(to_unsafe))
    end

    # Returns the layout item's vertical size policy.
    def vertical_size_policy : SizePolicy
      SizePolicy.from_value(LibQt6.qt6cr_graphics_layout_item_vertical_size_policy(to_unsafe))
    end

    # Sets both size policies and returns `self`.
    def set_size_policy(horizontal : SizePolicy, vertical : SizePolicy) : self
      LibQt6.qt6cr_graphics_layout_item_set_size_policy(to_unsafe, horizontal.value, vertical.value)
      self
    end

    # Returns the minimum size constraint.
    def minimum_size : SizeF
      SizeF.from_native(LibQt6.qt6cr_graphics_layout_item_minimum_size(to_unsafe))
    end

    # Sets the minimum size constraint and returns `self`.
    def set_minimum_size(width : Number, height : Number) : self
      LibQt6.qt6cr_graphics_layout_item_set_minimum_size(to_unsafe, width.to_f64, height.to_f64)
      self
    end

    # Returns the preferred size constraint.
    def preferred_size : SizeF
      SizeF.from_native(LibQt6.qt6cr_graphics_layout_item_preferred_size(to_unsafe))
    end

    # Sets the preferred size constraint and returns `self`.
    def set_preferred_size(width : Number, height : Number) : self
      LibQt6.qt6cr_graphics_layout_item_set_preferred_size(to_unsafe, width.to_f64, height.to_f64)
      self
    end

    # Returns the maximum size constraint.
    def maximum_size : SizeF
      SizeF.from_native(LibQt6.qt6cr_graphics_layout_item_maximum_size(to_unsafe))
    end

    # Sets the maximum size constraint and returns `self`.
    def set_maximum_size(width : Number, height : Number) : self
      LibQt6.qt6cr_graphics_layout_item_set_maximum_size(to_unsafe, width.to_f64, height.to_f64)
      self
    end

    # Returns the current layout geometry.
    def geometry : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_layout_item_geometry(to_unsafe))
    end

    # Returns the rectangle inside the current contents margins.
    def contents_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_layout_item_contents_rect(to_unsafe))
    end

    # Returns the effective size hint for the given hint type.
    def effective_size_hint(which : GraphicsLayoutItemSizeHint) : SizeF
      effective_size_hint(which, SizeF.new(-1.0, -1.0))
    end

    # Returns the effective size hint for the given hint type and constraint.
    def effective_size_hint(which : GraphicsLayoutItemSizeHint, constraint : SizeF) : SizeF
      SizeF.from_native(
        LibQt6.qt6cr_graphics_layout_item_effective_size_hint(
          to_unsafe,
          which.value,
          constraint.width,
          constraint.height
        )
      )
    end

    # Returns `true` when the layout item contributes no visible geometry.
    def empty? : Bool
      LibQt6.qt6cr_graphics_layout_item_is_empty(to_unsafe)
    end

    # Returns the parent layout item, if any.
    def parent_layout_item : GraphicsLayout | GraphicsWidget | Nil
      handle = LibQt6.qt6cr_graphics_layout_item_parent_layout_item(to_unsafe)
      handle.null? ? nil : GraphicsLayoutItem.wrap(handle)
    end

    # Returns `true` when this layout item is itself a graphics layout.
    def graphics_layout? : Bool
      LibQt6.qt6cr_graphics_layout_item_is_layout(to_unsafe)
    end

    # Returns the associated graphics item, if this layout item has one.
    def graphics_item : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_layout_item_graphics_item(to_unsafe)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    # Returns `true` when ownership currently belongs to a parent layout.
    def owned_by_layout? : Bool
      LibQt6.qt6cr_graphics_layout_item_owned_by_layout(to_unsafe)
    end

    # Enables or disables Qt's instant invalidate propagation globally.
    def self.instant_invalidate_propagation=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_layout_set_instant_invalidate_propagation(value)
      value
    end

    # Returns `true` when instant invalidate propagation is enabled globally.
    def self.instant_invalidate_propagation? : Bool
      LibQt6.qt6cr_graphics_layout_instant_invalidate_propagation
    end
  end
end
