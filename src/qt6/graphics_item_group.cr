module Qt6
  # Wraps `QGraphicsItemGroup`.
  class GraphicsItemGroup < GraphicsItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an item group, optionally parented to another graphics item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_item_group_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Adds an item to the group and returns `self`.
    def add_to_group(item : GraphicsItem) : self
      LibQt6.qt6cr_graphics_item_group_add_to_group(to_unsafe, item.to_unsafe)
      item.adopt_by_owner!
      self
    end

    # Removes an item from the group and returns `self`.
    def remove_from_group(item : GraphicsItem) : self
      LibQt6.qt6cr_graphics_item_group_remove_from_group(to_unsafe, item.to_unsafe)
      item.assume_ownership! if item.parent_item.nil? && item.group.nil?
      self
    end

    # Returns the group's local bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_item_group_bounding_rect(to_unsafe))
    end

    # Returns `true` when the given item obscures this group.
    def obscured_by?(item : GraphicsItem) : Bool
      LibQt6.qt6cr_graphics_item_group_is_obscured_by(to_unsafe, item.to_unsafe)
    end

    # Returns the group's opaque area as a painter path.
    def opaque_area : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_graphics_item_group_opaque_area(to_unsafe), true)
    end
  end
end
