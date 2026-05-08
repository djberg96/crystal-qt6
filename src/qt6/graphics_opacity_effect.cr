module Qt6
  # Wraps `QGraphicsOpacityEffect`.
  class GraphicsOpacityEffect < GraphicsEffect
    @opacity_changed : Signal(Float64) = Signal(Float64).new
    @opacity_mask_changed : Signal(QBrush) = Signal(QBrush).new
    @opacity_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @opacity_mask_changed_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the effect opacity changes.
    getter opacity_changed : Signal(Float64)
    # Signal emitted whenever the effect opacity mask changes.
    getter opacity_mask_changed : Signal(QBrush)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an opacity effect with an optional parent object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_graphics_opacity_effect_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @opacity_changed = Signal(Float64).new
      @opacity_mask_changed = Signal(QBrush).new
      @opacity_changed_userdata = Box.box(self)
      @opacity_mask_changed_userdata = Box.box(self)
      LibQt6.qt6cr_graphics_opacity_effect_on_opacity_changed(to_unsafe, OPACITY_CHANGED_TRAMPOLINE, @opacity_changed_userdata)
      LibQt6.qt6cr_graphics_opacity_effect_on_opacity_mask_changed(to_unsafe, OPACITY_MASK_CHANGED_TRAMPOLINE, @opacity_mask_changed_userdata)
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

    # Returns the current opacity mask brush.
    def opacity_mask : QBrush
      QBrush.wrap(LibQt6.qt6cr_graphics_opacity_effect_opacity_mask(to_unsafe), true)
    end

    # Sets the opacity mask brush and returns it.
    def opacity_mask=(value : QBrush) : QBrush
      LibQt6.qt6cr_graphics_opacity_effect_set_opacity_mask(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `opacity=`.
    def set_opacity(value : Number) : self
      self.opacity = value
      self
    end

    # Qt-style alias for `opacity_mask=`.
    def set_opacity_mask(value : QBrush) : self
      self.opacity_mask = value
      self
    end

    # Registers a block to run when the opacity changes.
    def on_opacity_changed(&block : Float64 ->) : self
      @opacity_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the opacity mask changes.
    def on_opacity_mask_changed(&block : QBrush ->) : self
      @opacity_mask_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_opacity_changed(value : Float64) : Nil
      @opacity_changed.emit(value)
    end

    protected def emit_opacity_mask_changed(handle : LibQt6::Handle) : Nil
      @opacity_mask_changed.emit(QBrush.wrap(handle, true))
    end

    private OPACITY_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Float64) do
      Box(GraphicsOpacityEffect).unbox(userdata).emit_opacity_changed(value)
    end

    private OPACITY_MASK_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(GraphicsOpacityEffect).unbox(userdata).emit_opacity_mask_changed(handle)
    end
  end
end
