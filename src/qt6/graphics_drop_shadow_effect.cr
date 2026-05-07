module Qt6
  # Wraps `QGraphicsDropShadowEffect`.
  class GraphicsDropShadowEffect < GraphicsEffect
    @blur_radius_changed : Signal(Float64) = Signal(Float64).new
    @color_changed : Signal(Color) = Signal(Color).new
    @offset_changed : Signal(PointF) = Signal(PointF).new
    @blur_radius_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @color_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @offset_changed_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the blur radius changes.
    getter blur_radius_changed : Signal(Float64)
    # Signal emitted whenever the shadow color changes.
    getter color_changed : Signal(Color)
    # Signal emitted whenever the shadow offset changes.
    getter offset_changed : Signal(PointF)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a drop-shadow effect with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_drop_shadow_effect_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @blur_radius_changed = Signal(Float64).new
      @color_changed = Signal(Color).new
      @offset_changed = Signal(PointF).new
      @blur_radius_changed_userdata = Box.box(self)
      @color_changed_userdata = Box.box(self)
      @offset_changed_userdata = Box.box(self)
      LibQt6.qt6cr_graphics_drop_shadow_effect_on_blur_radius_changed(to_unsafe, BLUR_RADIUS_CHANGED_TRAMPOLINE, @blur_radius_changed_userdata)
      LibQt6.qt6cr_graphics_drop_shadow_effect_on_color_changed(to_unsafe, COLOR_CHANGED_TRAMPOLINE, @color_changed_userdata)
      LibQt6.qt6cr_graphics_drop_shadow_effect_on_offset_changed(to_unsafe, OFFSET_CHANGED_TRAMPOLINE, @offset_changed_userdata)
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

    # Qt-style alias for `blur_radius=`.
    def set_blur_radius(value : Number) : self
      self.blur_radius = value
      self
    end

    # Qt-style alias for `color=`.
    def set_color(value : Color) : self
      self.color = value
      self
    end

    # Qt-style alias for assigning the full offset.
    def set_offset(value : PointF) : self
      self.offset = value
      self
    end

    # Qt-style overload for assigning the full offset from coordinates.
    def set_offset(x : Number, y : Number) : self
      self.offset = PointF.new(x.to_f64, y.to_f64)
      self
    end

    # Qt-style alias for `x_offset=`.
    def set_x_offset(value : Number) : self
      self.x_offset = value
      self
    end

    # Qt-style alias for `y_offset=`.
    def set_y_offset(value : Number) : self
      self.y_offset = value
      self
    end

    # Registers a block to run when the blur radius changes.
    def on_blur_radius_changed(&block : Float64 ->) : self
      @blur_radius_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the shadow color changes.
    def on_color_changed(&block : Color ->) : self
      @color_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the shadow offset changes.
    def on_offset_changed(&block : PointF ->) : self
      @offset_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_blur_radius_changed(value : Float64) : Nil
      @blur_radius_changed.emit(value)
    end

    protected def emit_color_changed : Nil
      @color_changed.emit(color)
    end

    protected def emit_offset_changed : Nil
      @offset_changed.emit(offset)
    end

    private BLUR_RADIUS_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Float64) do
      Box(GraphicsDropShadowEffect).unbox(userdata).emit_blur_radius_changed(value)
    end

    private COLOR_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsDropShadowEffect).unbox(userdata).emit_color_changed
    end

    private OFFSET_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsDropShadowEffect).unbox(userdata).emit_offset_changed
    end
  end
end
