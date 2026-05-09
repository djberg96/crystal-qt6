module Qt6
  # Wraps `QGraphicsScale`.
  class GraphicsScale < GraphicsTransform
    @origin_changed : Signal() = Signal().new
    @x_scale_changed : Signal() = Signal().new
    @y_scale_changed : Signal() = Signal().new
    @z_scale_changed : Signal() = Signal().new
    @scale_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter origin_changed : Signal()
    getter x_scale_changed : Signal()
    getter y_scale_changed : Signal()
    getter z_scale_changed : Signal()
    getter scale_changed : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a scale transform with an optional QObject parent.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_scale_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @origin_changed = Signal().new
      @x_scale_changed = Signal().new
      @y_scale_changed = Signal().new
      @z_scale_changed = Signal().new
      @scale_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_graphics_scale_on_origin_changed(to_unsafe, ORIGIN_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_scale_on_x_scale_changed(to_unsafe, X_SCALE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_scale_on_y_scale_changed(to_unsafe, Y_SCALE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_scale_on_z_scale_changed(to_unsafe, Z_SCALE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_scale_on_scale_changed(to_unsafe, SCALE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the 3D origin point used for the scale transform.
    def origin : Vector3D
      Vector3D.from_native(LibQt6.qt6cr_graphics_scale_origin(to_unsafe))
    end

    # Sets the 3D origin point and returns it.
    def origin=(value : Vector3D) : Vector3D
      LibQt6.qt6cr_graphics_scale_set_origin(to_unsafe, value.to_native)
      value
    end

    # Returns the scale factor along the X axis.
    def x_scale : Float64
      LibQt6.qt6cr_graphics_scale_x_scale(to_unsafe)
    end

    # Sets the X-axis scale factor and returns it.
    def x_scale=(value : Number) : Float64
      scale = value.to_f64
      LibQt6.qt6cr_graphics_scale_set_x_scale(to_unsafe, scale)
      scale
    end

    # Returns the scale factor along the Y axis.
    def y_scale : Float64
      LibQt6.qt6cr_graphics_scale_y_scale(to_unsafe)
    end

    # Sets the Y-axis scale factor and returns it.
    def y_scale=(value : Number) : Float64
      scale = value.to_f64
      LibQt6.qt6cr_graphics_scale_set_y_scale(to_unsafe, scale)
      scale
    end

    # Returns the scale factor along the Z axis.
    def z_scale : Float64
      LibQt6.qt6cr_graphics_scale_z_scale(to_unsafe)
    end

    # Sets the Z-axis scale factor and returns it.
    def z_scale=(value : Number) : Float64
      scale = value.to_f64
      LibQt6.qt6cr_graphics_scale_set_z_scale(to_unsafe, scale)
      scale
    end

    # Qt-style alias for `origin=`.
    def set_origin(value : Vector3D) : self
      self.origin = value
      self
    end

    # Qt-style alias for `x_scale=`.
    def set_x_scale(value : Number) : self
      self.x_scale = value
      self
    end

    # Qt-style alias for `y_scale=`.
    def set_y_scale(value : Number) : self
      self.y_scale = value
      self
    end

    # Qt-style alias for `z_scale=`.
    def set_z_scale(value : Number) : self
      self.z_scale = value
      self
    end

    # Registers a block for origin changes.
    def on_origin_changed(&block : ->) : self
      @origin_changed.connect { block.call }
      self
    end

    # Registers a block for X-scale changes.
    def on_x_scale_changed(&block : ->) : self
      @x_scale_changed.connect { block.call }
      self
    end

    # Registers a block for Y-scale changes.
    def on_y_scale_changed(&block : ->) : self
      @y_scale_changed.connect { block.call }
      self
    end

    # Registers a block for Z-scale changes.
    def on_z_scale_changed(&block : ->) : self
      @z_scale_changed.connect { block.call }
      self
    end

    # Registers a block for aggregate scale changes.
    def on_scale_changed(&block : ->) : self
      @scale_changed.connect { block.call }
      self
    end

    protected def emit_origin_changed : Nil
      @origin_changed.emit
    end

    protected def emit_x_scale_changed : Nil
      @x_scale_changed.emit
    end

    protected def emit_y_scale_changed : Nil
      @y_scale_changed.emit
    end

    protected def emit_z_scale_changed : Nil
      @z_scale_changed.emit
    end

    protected def emit_scale_changed : Nil
      @scale_changed.emit
    end

    private ORIGIN_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsScale).unbox(userdata).emit_origin_changed
    end

    private X_SCALE_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsScale).unbox(userdata).emit_x_scale_changed
    end

    private Y_SCALE_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsScale).unbox(userdata).emit_y_scale_changed
    end

    private Z_SCALE_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsScale).unbox(userdata).emit_z_scale_changed
    end

    private SCALE_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsScale).unbox(userdata).emit_scale_changed
    end
  end
end
