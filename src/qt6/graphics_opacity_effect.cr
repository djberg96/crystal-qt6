module Qt6
  # Wraps `QGraphicsOpacityEffect`.
  class GraphicsOpacityEffect < GraphicsEffect
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an opacity effect with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_opacity_effect_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current opacity.
    def opacity : Float64
      LibQt6.qt6cr_graphics_opacity_effect_opacity(to_unsafe)
    end

    # Sets the opacity and returns it.
    def opacity=(value : Number) : Float64
      opacity = value.to_f64
      LibQt6.qt6cr_graphics_opacity_effect_set_opacity(to_unsafe, opacity)
      opacity
    end
  end
end
