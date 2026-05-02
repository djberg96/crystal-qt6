module Qt6
  # Wraps `QGraphicsBlurEffect`.
  class GraphicsBlurEffect < GraphicsEffect
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a blur effect with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_blur_effect_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the blur radius.
    def blur_radius : Float64
      LibQt6.qt6cr_graphics_blur_effect_blur_radius(to_unsafe)
    end

    # Sets the blur radius and returns it.
    def blur_radius=(value : Number) : Float64
      radius = value.to_f64
      LibQt6.qt6cr_graphics_blur_effect_set_blur_radius(to_unsafe, radius)
      radius
    end
  end
end
