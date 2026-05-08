module Qt6
  # Concrete wrapper for the shared `QGraphicsObject` property and signal surface.
  class GraphicsObject < GraphicsItem
    @destroyed_signal : Signal() = Signal().new
    @parent_changed : Signal() = Signal().new
    @opacity_changed : Signal() = Signal().new
    @visible_changed : Signal() = Signal().new
    @enabled_changed : Signal() = Signal().new
    @x_changed : Signal() = Signal().new
    @y_changed : Signal() = Signal().new
    @z_changed : Signal() = Signal().new
    @rotation_changed : Signal() = Signal().new
    @scale_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter destroyed_signal : Signal()
    getter parent_changed : Signal()
    getter opacity_changed : Signal()
    getter visible_changed : Signal()
    getter enabled_changed : Signal()
    getter x_changed : Signal()
    getter y_changed : Signal()
    getter z_changed : Signal()
    getter rotation_changed : Signal()
    getter scale_changed : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a minimal graphics object, optionally parented to another graphics item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_object_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      setup_graphics_object_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      setup_graphics_object_callbacks
    end

    # Returns the parent graphics object, if present.
    def parent_object : GraphicsObject?
      handle = LibQt6.qt6cr_graphics_object_parent_object(to_unsafe)
      handle.null? ? nil : GraphicsObject.wrap(handle)
    end

    # Returns the installed graphics effect, if one is present.
    def graphics_effect : GraphicsEffect?
      handle = LibQt6.qt6cr_graphics_object_graphics_effect(to_unsafe)
      handle.null? ? nil : GraphicsEffect.wrap(handle)
    end

    # Installs or clears a graphics effect.
    def graphics_effect=(value : GraphicsEffect?) : GraphicsEffect?
      LibQt6.qt6cr_graphics_object_set_graphics_effect(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.try(&.adopt_by_parent!)
      value
    end

    # Blocks or unblocks this object's signal emissions.
    def block_signals=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_object_block_signals(to_unsafe, value)
    end

    # Returns `true` when signal delivery is currently blocked.
    def signals_blocked? : Bool
      LibQt6.qt6cr_graphics_object_signals_blocked(to_unsafe)
    end

    # Installs an event filter on this graphics object.
    def install_event_filter(filter : EventFilter) : EventFilter
      LibQt6.qt6cr_graphics_object_install_event_filter(to_unsafe, filter.to_unsafe)
      filter
    end

    # Removes an event filter from this graphics object.
    def remove_event_filter(filter : EventFilter) : EventFilter
      LibQt6.qt6cr_graphics_object_remove_event_filter(to_unsafe, filter.to_unsafe)
      filter
    end

    # Registers a gesture type for delivery to this graphics object.
    def grab_gesture(type : GestureType, flags : GestureFlag = GestureFlag::None) : self
      grab_gesture(type.value, flags)
      self
    end

    # Registers a raw gesture type id for delivery to this graphics object.
    def grab_gesture(type : Int, flags : GestureFlag = GestureFlag::None) : self
      LibQt6.qt6cr_graphics_object_grab_gesture(to_unsafe, type.to_i32, flags.value)
      self
    end

    # Unregisters a previously grabbed gesture type from this graphics object.
    def ungrab_gesture(type : GestureType) : self
      ungrab_gesture(type.value)
      self
    end

    # Unregisters a previously grabbed raw gesture type id from this graphics object.
    def ungrab_gesture(type : Int) : self
      LibQt6.qt6cr_graphics_object_ungrab_gesture(to_unsafe, type.to_i32)
      self
    end

    def on_destroyed(&block : ->) : self
      destroyed_signal.connect { block.call }
      self
    end

    def on_parent_changed(&block : ->) : self
      parent_changed.connect { block.call }
      self
    end

    def on_opacity_changed(&block : ->) : self
      opacity_changed.connect { block.call }
      self
    end

    def on_visible_changed(&block : ->) : self
      visible_changed.connect { block.call }
      self
    end

    def on_enabled_changed(&block : ->) : self
      enabled_changed.connect { block.call }
      self
    end

    def on_x_changed(&block : ->) : self
      x_changed.connect { block.call }
      self
    end

    def on_y_changed(&block : ->) : self
      y_changed.connect { block.call }
      self
    end

    def on_z_changed(&block : ->) : self
      z_changed.connect { block.call }
      self
    end

    def on_rotation_changed(&block : ->) : self
      rotation_changed.connect { block.call }
      self
    end

    def on_scale_changed(&block : ->) : self
      scale_changed.connect { block.call }
      self
    end

    protected def mark_destroyed_from_qt : Nil
      return if destroyed?

      mark_destroyed
      @destroyed_signal.emit
    end

    protected def emit_parent_changed : Nil
      @parent_changed.emit
    end

    protected def emit_opacity_changed : Nil
      @opacity_changed.emit
    end

    protected def emit_visible_changed : Nil
      @visible_changed.emit
    end

    protected def emit_enabled_changed : Nil
      @enabled_changed.emit
    end

    protected def emit_x_changed : Nil
      @x_changed.emit
    end

    protected def emit_y_changed : Nil
      @y_changed.emit
    end

    protected def emit_z_changed : Nil
      @z_changed.emit
    end

    protected def emit_rotation_changed : Nil
      @rotation_changed.emit
    end

    protected def emit_scale_changed : Nil
      @scale_changed.emit
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_object_destroy(to_unsafe)
    end

    private def setup_graphics_object_callbacks : Nil
      @destroyed_signal = Signal().new
      @parent_changed = Signal().new
      @opacity_changed = Signal().new
      @visible_changed = Signal().new
      @enabled_changed = Signal().new
      @x_changed = Signal().new
      @y_changed = Signal().new
      @z_changed = Signal().new
      @rotation_changed = Signal().new
      @scale_changed = Signal().new
      @callback_userdata = Box.box(self.as(GraphicsObject))
      LibQt6.qt6cr_graphics_object_on_destroyed(to_unsafe, DESTROYED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_object_on_parent_changed(to_unsafe, PARENT_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_object_on_opacity_changed(to_unsafe, OPACITY_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_object_on_visible_changed(to_unsafe, VISIBLE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_object_on_enabled_changed(to_unsafe, ENABLED_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_object_on_x_changed(to_unsafe, X_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_object_on_y_changed(to_unsafe, Y_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_object_on_z_changed(to_unsafe, Z_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_object_on_rotation_changed(to_unsafe, ROTATION_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_graphics_object_on_scale_changed(to_unsafe, SCALE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    private DESTROYED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).mark_destroyed_from_qt
    end

    private PARENT_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).emit_parent_changed
    end

    private OPACITY_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).emit_opacity_changed
    end

    private VISIBLE_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).emit_visible_changed
    end

    private ENABLED_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).emit_enabled_changed
    end

    private X_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).emit_x_changed
    end

    private Y_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).emit_y_changed
    end

    private Z_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).emit_z_changed
    end

    private ROTATION_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).emit_rotation_changed
    end

    private SCALE_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(GraphicsObject).unbox(userdata).emit_scale_changed
    end
  end
end
