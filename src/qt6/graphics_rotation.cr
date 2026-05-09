module Qt6
  # Wraps `QGraphicsRotation`.
  class GraphicsRotation < GraphicsTransform
    @origin_changed : Signal() = Signal().new
    @angle_changed : Signal() = Signal().new
    @axis_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter origin_changed : Signal()
    getter angle_changed : Signal()
    getter axis_changed : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a rotation transform with an optional QObject parent.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_rotation_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @origin_changed = Signal().new
      @angle_changed = Signal().new
      @axis_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_graphics_rotation_on_origin_changed(to_unsafe, ORIGIN_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_rotation_on_angle_changed(to_unsafe, ANGLE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_rotation_on_axis_changed(to_unsafe, AXIS_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the 3D origin point used for the rotation.
    def origin : Vector3D
      Vector3D.from_native(LibQt6.qt6cr_graphics_rotation_origin(to_unsafe))
    end

    # Sets the 3D origin point and returns it.
    def origin=(value : Vector3D) : Vector3D
      LibQt6.qt6cr_graphics_rotation_set_origin(to_unsafe, value.to_native)
      value
    end

    # Returns the rotation angle in degrees.
    def angle : Float64
      LibQt6.qt6cr_graphics_rotation_angle(to_unsafe)
    end

    # Sets the rotation angle and returns it.
    def angle=(value : Number) : Float64
      angle = value.to_f64
      LibQt6.qt6cr_graphics_rotation_set_angle(to_unsafe, angle)
      angle
    end

    # Returns the current rotation axis vector.
    def axis : Vector3D
      Vector3D.from_native(LibQt6.qt6cr_graphics_rotation_axis(to_unsafe))
    end

    # Sets the rotation axis vector and returns it.
    def axis=(value : Vector3D) : Vector3D
      LibQt6.qt6cr_graphics_rotation_set_axis_vector(to_unsafe, value.to_native)
      value
    end

    # Sets the rotation axis from a named axis and returns it.
    def axis=(value : Axis) : Axis
      LibQt6.qt6cr_graphics_rotation_set_axis_enum(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `origin=`.
    def set_origin(value : Vector3D) : self
      self.origin = value
      self
    end

    # Qt-style alias for `angle=`.
    def set_angle(value : Number) : self
      self.angle = value
      self
    end

    # Qt-style alias for assigning the axis vector.
    def set_axis(value : Vector3D) : self
      self.axis = value
      self
    end

    # Qt-style overload for assigning the axis from a named axis.
    def set_axis(value : Axis) : self
      self.axis = value
      self
    end

    # Registers a block for origin changes.
    def on_origin_changed(&block : ->) : self
      @origin_changed.connect { block.call }
      self
    end

    # Registers a block for angle changes.
    def on_angle_changed(&block : ->) : self
      @angle_changed.connect { block.call }
      self
    end

    # Registers a block for axis changes.
    def on_axis_changed(&block : ->) : self
      @axis_changed.connect { block.call }
      self
    end

    protected def emit_origin_changed : Nil
      @origin_changed.emit
    end

    protected def emit_angle_changed : Nil
      @angle_changed.emit
    end

    protected def emit_axis_changed : Nil
      @axis_changed.emit
    end

    private ORIGIN_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsRotation).unbox(userdata).emit_origin_changed
    end

    private ANGLE_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsRotation).unbox(userdata).emit_angle_changed
    end

    private AXIS_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsRotation).unbox(userdata).emit_axis_changed
    end
  end
end
