module Qt6
  # Base wrapper for `QGraphicsEffect`.
  class GraphicsEffect < QObject
    @enabled_changed : Signal(Bool) = Signal(Bool).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter enabled_changed : Signal(Bool)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @enabled_changed = Signal(Bool).new
      @callback_userdata = Box.box(self.as(GraphicsEffect))
      LibQt6.qt6cr_graphics_effect_on_enabled_changed(to_unsafe, ENABLED_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns `true` when the effect is active.
    def enabled? : Bool
      LibQt6.qt6cr_graphics_effect_is_enabled(to_unsafe)
    end

    # Enables or disables the effect.
    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_effect_set_enabled(to_unsafe, value)
      value
    end

    # Qt-style alias for `enabled=`.
    def set_enabled(value : Bool) : self
      self.enabled = value
      self
    end

    # Returns the effect's current bounding rect.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_effect_bounding_rect(to_unsafe))
    end

    # Returns the effective bounding rect for a given source rect.
    def bounding_rect_for(source_rect : RectF) : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_effect_bounding_rect_for(to_unsafe, source_rect.to_native))
    end

    # Requests a redraw of the effect and returns `self`.
    def update : self
      LibQt6.qt6cr_graphics_effect_update(to_unsafe)
      self
    end

    # Registers a block to run when the enabled state changes.
    def on_enabled_changed(&block : Bool ->) : self
      @enabled_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_enabled_changed(value : Bool) : Nil
      @enabled_changed.emit(value)
    end

    private ENABLED_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(GraphicsEffect).unbox(userdata).emit_enabled_changed(value)
    end
  end
end
