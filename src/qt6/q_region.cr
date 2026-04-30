module Qt6
  # Wraps `QRegion` for painter clip regions, widget masks, and region algebra.
  class QRegion < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an empty region.
    def initialize
      super(LibQt6.qt6cr_qregion_create)
    end

    # Creates a rectangular or elliptical region from the given rectangle.
    def initialize(rect : Rect, type : RegionType = RegionType::Rectangle)
      super(LibQt6.qt6cr_qregion_create_rect(rect.to_native, type.value))
    end

    # Creates a region from a bitmap mask.
    def initialize(bitmap : QBitmap)
      super(LibQt6.qt6cr_qregion_create_bitmap(bitmap.to_unsafe))
    end

    # Creates a rectangular or elliptical region from coordinates.
    def initialize(x : Int, y : Int, width : Int, height : Int, type : RegionType = RegionType::Rectangle)
      initialize(Rect.new(x.to_i32, y.to_i32, width.to_i32, height.to_i32), type)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` when the region contains no points.
    def empty? : Bool
      LibQt6.qt6cr_qregion_is_empty(to_unsafe)
    end

    # Returns `true` when the region is null.
    def null? : Bool
      LibQt6.qt6cr_qregion_is_null(to_unsafe)
    end

    # Returns the number of rectangles that compose the region.
    def rect_count : Int32
      LibQt6.qt6cr_qregion_rect_count(to_unsafe)
    end

    # Returns the bounding rectangle of the region.
    def bounding_rect : Rect
      Rect.from_native(LibQt6.qt6cr_qregion_bounding_rect(to_unsafe))
    end

    # Returns `true` when the region contains the given rectangle.
    def contains?(rect : Rect) : Bool
      LibQt6.qt6cr_qregion_contains_rect(to_unsafe, rect.to_native)
    end

    # Returns `true` when the region intersects the given rectangle.
    def intersects?(rect : Rect) : Bool
      LibQt6.qt6cr_qregion_intersects_rect(to_unsafe, rect.to_native)
    end

    # Returns `true` when the region intersects the other region.
    def intersects?(other : QRegion) : Bool
      LibQt6.qt6cr_qregion_intersects(to_unsafe, other.to_unsafe)
    end

    # Returns a translated copy of the region.
    def translated(dx : Int, dy : Int) : QRegion
      QRegion.wrap(LibQt6.qt6cr_qregion_translated(to_unsafe, dx.to_i32, dy.to_i32), true)
    end

    # Translates the region in place.
    def translate(dx : Int, dy : Int) : self
      LibQt6.qt6cr_qregion_translate(to_unsafe, dx.to_i32, dy.to_i32)
      self
    end

    # Returns the union of this region and another region.
    def united(other : QRegion) : QRegion
      QRegion.wrap(LibQt6.qt6cr_qregion_united(to_unsafe, other.to_unsafe), true)
    end

    # Returns the union of this region and a rectangle.
    def united(rect : Rect) : QRegion
      QRegion.wrap(LibQt6.qt6cr_qregion_united_rect(to_unsafe, rect.to_native), true)
    end

    # Returns the intersection of this region and another region.
    def intersected(other : QRegion) : QRegion
      QRegion.wrap(LibQt6.qt6cr_qregion_intersected(to_unsafe, other.to_unsafe), true)
    end

    # Returns the intersection of this region and a rectangle.
    def intersected(rect : Rect) : QRegion
      QRegion.wrap(LibQt6.qt6cr_qregion_intersected_rect(to_unsafe, rect.to_native), true)
    end

    # Returns this region minus another region.
    def subtracted(other : QRegion) : QRegion
      QRegion.wrap(LibQt6.qt6cr_qregion_subtracted(to_unsafe, other.to_unsafe), true)
    end

    # Returns the exclusive-or of this region and another region.
    def xored(other : QRegion) : QRegion
      QRegion.wrap(LibQt6.qt6cr_qregion_xored(to_unsafe, other.to_unsafe), true)
    end

    # Clears the region in place.
    def clear : self
      LibQt6.qt6cr_qregion_clear(to_unsafe)
      self
    end

    # Unites the region with another region in place.
    def unite(other : QRegion) : self
      LibQt6.qt6cr_qregion_unite(to_unsafe, other.to_unsafe)
      self
    end

    # Unites the region with a rectangle in place.
    def unite(rect : Rect) : self
      LibQt6.qt6cr_qregion_unite_rect(to_unsafe, rect.to_native)
      self
    end

    # Intersects the region with another region in place.
    def intersect(other : QRegion) : self
      LibQt6.qt6cr_qregion_intersect(to_unsafe, other.to_unsafe)
      self
    end

    # Intersects the region with a rectangle in place.
    def intersect(rect : Rect) : self
      LibQt6.qt6cr_qregion_intersect_rect(to_unsafe, rect.to_native)
      self
    end

    # Subtracts another region from this region in place.
    def subtract(other : QRegion) : self
      LibQt6.qt6cr_qregion_subtract(to_unsafe, other.to_unsafe)
      self
    end

    # Applies an exclusive-or with another region in place.
    def exclusive_or(other : QRegion) : self
      LibQt6.qt6cr_qregion_xor(to_unsafe, other.to_unsafe)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qregion_destroy(to_unsafe)
    end
  end
end
