module Qt6
  # Wraps `QStyleOptionGraphicsItem` for graphics-view paint state.
  class StyleOptionGraphicsItem < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.level_of_detail_from_transform(transform : QTransform) : Float64
      LibQt6.qt6cr_style_option_graphics_item_level_of_detail_from_transform(transform.to_unsafe)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_graphics_item_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def exposed_rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_graphics_item_exposed_rect(to_unsafe))
    end

    def exposed_rect=(value : RectF) : RectF
      LibQt6.qt6cr_style_option_graphics_item_set_exposed_rect(to_unsafe, value.to_native)
      value
    end

    def exposed_rect=(value : Rect) : Rect
      LibQt6.qt6cr_style_option_graphics_item_set_exposed_rect(to_unsafe, value.to_rect_f.to_native)
      value
    end

    def set_exposed_rect(value : RectF | Rect) : self
      self.exposed_rect = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_graphics_item_destroy(to_unsafe)
    end
  end
end
