module Qt6
  # Wraps `QGraphicsColorizeEffect`.
  class GraphicsColorizeEffect < GraphicsEffect
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a colorize effect with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_colorize_effect_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the tint color.
    def color : Color
      Color.from_native(LibQt6.qt6cr_graphics_colorize_effect_color(to_unsafe))
    end

    # Sets the tint color and returns it.
    def color=(value : Color) : Color
      LibQt6.qt6cr_graphics_colorize_effect_set_color(to_unsafe, value.to_native)
      value
    end

    # Returns the colorize strength.
    def strength : Float64
      LibQt6.qt6cr_graphics_colorize_effect_strength(to_unsafe)
    end

    # Sets the colorize strength and returns it.
    def strength=(value : Number) : Float64
      strength = value.to_f64
      LibQt6.qt6cr_graphics_colorize_effect_set_strength(to_unsafe, strength)
      strength
    end
  end
end
