module Qt6
  # Wraps `QGraphicsColorizeEffect`.
  class GraphicsColorizeEffect < GraphicsEffect
    @color_changed : Signal(Color) = Signal(Color).new
    @strength_changed : Signal(Float64) = Signal(Float64).new
    @color_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @strength_changed_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the tint color changes.
    getter color_changed : Signal(Color)
    # Signal emitted whenever the colorize strength changes.
    getter strength_changed : Signal(Float64)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a colorize effect with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_colorize_effect_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @color_changed = Signal(Color).new
      @strength_changed = Signal(Float64).new
      @color_changed_userdata = Box.box(self)
      @strength_changed_userdata = Box.box(self)
      LibQt6.qt6cr_graphics_colorize_effect_on_color_changed(to_unsafe, COLOR_CHANGED_TRAMPOLINE, @color_changed_userdata)
      LibQt6.qt6cr_graphics_colorize_effect_on_strength_changed(to_unsafe, STRENGTH_CHANGED_TRAMPOLINE, @strength_changed_userdata)
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

    # Qt-style alias for `color=`.
    def set_color(value : Color) : self
      self.color = value
      self
    end

    # Qt-style alias for `strength=`.
    def set_strength(value : Number) : self
      self.strength = value
      self
    end

    # Registers a block to run when the tint color changes.
    def on_color_changed(&block : Color ->) : self
      @color_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the strength changes.
    def on_strength_changed(&block : Float64 ->) : self
      @strength_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_color_changed : Nil
      @color_changed.emit(color)
    end

    protected def emit_strength_changed(value : Float64) : Nil
      @strength_changed.emit(value)
    end

    private COLOR_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsColorizeEffect).unbox(userdata).emit_color_changed
    end

    private STRENGTH_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Float64) do
      Box(GraphicsColorizeEffect).unbox(userdata).emit_strength_changed(value)
    end
  end
end
