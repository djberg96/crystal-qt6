module Qt6
  # Wraps `QGraphicsDropShadowEffect`.
  class GraphicsDropShadowEffect < GraphicsEffect
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a drop-shadow effect with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_drop_shadow_effect_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the blur radius.
    def blur_radius : Float64
      LibQt6.qt6cr_graphics_drop_shadow_effect_blur_radius(to_unsafe)
    end

    # Sets the blur radius and returns it.
    def blur_radius=(value : Number) : Float64
      radius = value.to_f64
      LibQt6.qt6cr_graphics_drop_shadow_effect_set_blur_radius(to_unsafe, radius)
      radius
    end

    # Returns the shadow color.
    def color : Color
      Color.from_native(LibQt6.qt6cr_graphics_drop_shadow_effect_color(to_unsafe))
    end

    # Sets the shadow color and returns it.
    def color=(value : Color) : Color
      LibQt6.qt6cr_graphics_drop_shadow_effect_set_color(to_unsafe, value.to_native)
      value
    end

    # Returns the shadow offset.
    def offset : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_drop_shadow_effect_offset(to_unsafe))
    end

    # Sets the full shadow offset and returns it.
    def offset=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_drop_shadow_effect_set_offset(to_unsafe, value.to_native)
      value
    end

    # Returns the horizontal shadow offset.
    def x_offset : Float64
      LibQt6.qt6cr_graphics_drop_shadow_effect_x_offset(to_unsafe)
    end

    # Sets the horizontal shadow offset and returns it.
    def x_offset=(value : Number) : Float64
      offset = value.to_f64
      LibQt6.qt6cr_graphics_drop_shadow_effect_set_x_offset(to_unsafe, offset)
      offset
    end

    # Returns the vertical shadow offset.
    def y_offset : Float64
      LibQt6.qt6cr_graphics_drop_shadow_effect_y_offset(to_unsafe)
    end

    # Sets the vertical shadow offset and returns it.
    def y_offset=(value : Number) : Float64
      offset = value.to_f64
      LibQt6.qt6cr_graphics_drop_shadow_effect_set_y_offset(to_unsafe, offset)
      offset
    end
  end
end
