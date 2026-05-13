module Qt6
  # Wraps `QRhiWidget`.
  class RhiWidget < Widget
    @frame_submitted : Signal() = Signal().new
    @render_failed : Signal() = Signal().new
    @sample_count_changed : Signal(Int32) = Signal(Int32).new
    @color_buffer_format_changed : Signal(RhiWidgetTextureFormat) = Signal(RhiWidgetTextureFormat).new
    @fixed_color_buffer_size_changed : Signal(Size) = Signal(Size).new
    @mirror_vertically_changed : Signal(Bool) = Signal(Bool).new
    @frame_submitted_userdata : LibQt6::Handle = Pointer(Void).null
    @render_failed_userdata : LibQt6::Handle = Pointer(Void).null
    @sample_count_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @color_buffer_format_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @fixed_color_buffer_size_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @mirror_vertically_changed_userdata : LibQt6::Handle = Pointer(Void).null

    getter frame_submitted : Signal()
    getter render_failed : Signal()
    getter sample_count_changed : Signal(Int32)
    getter color_buffer_format_changed : Signal(RhiWidgetTextureFormat)
    getter fixed_color_buffer_size_changed : Signal(Size)
    getter mirror_vertically_changed : Signal(Bool)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.available? : Bool
      LibQt6.qt6cr_rhi_widget_is_available
    end

    # Creates an RHI-backed widget with an optional parent.
    def initialize(parent : Widget? = nil)
      unless self.class.available?
        raise Error.new("QRhiWidget is not available in this Qt build")
      end

      super(LibQt6.qt6cr_rhi_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_rhi_widget_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_rhi_widget_callbacks
    end

    # Returns the graphics API used by the widget.
    def api : RhiWidgetApi
      RhiWidgetApi.from_value(LibQt6.qt6cr_rhi_widget_api(to_unsafe))
    end

    # Selects the graphics API used by the widget.
    def api=(value : RhiWidgetApi) : RhiWidgetApi
      LibQt6.qt6cr_rhi_widget_set_api(to_unsafe, value.value)
      value
    end

    # Returns `true` when API-level validation or debug layers are enabled.
    def debug_layer_enabled? : Bool
      LibQt6.qt6cr_rhi_widget_debug_layer_enabled(to_unsafe)
    end

    # Enables or disables the graphics debug layer.
    def debug_layer_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_rhi_widget_set_debug_layer_enabled(to_unsafe, value)
      value
    end

    # Returns the MSAA sample count used for rendering.
    def sample_count : Int32
      LibQt6.qt6cr_rhi_widget_sample_count(to_unsafe)
    end

    # Sets the MSAA sample count.
    def sample_count=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_rhi_widget_set_sample_count(to_unsafe, int_value)
      int_value
    end

    # Returns the color buffer texture format.
    def color_buffer_format : RhiWidgetTextureFormat
      RhiWidgetTextureFormat.from_value(LibQt6.qt6cr_rhi_widget_color_buffer_format(to_unsafe))
    end

    # Sets the color buffer texture format.
    def color_buffer_format=(value : RhiWidgetTextureFormat) : RhiWidgetTextureFormat
      LibQt6.qt6cr_rhi_widget_set_color_buffer_format(to_unsafe, value.value)
      value
    end

    # Returns the fixed color-buffer size override.
    def fixed_color_buffer_size : Size
      Size.from_native(LibQt6.qt6cr_rhi_widget_fixed_color_buffer_size(to_unsafe))
    end

    # Sets a fixed color-buffer size override.
    def fixed_color_buffer_size=(value : Size) : Size
      LibQt6.qt6cr_rhi_widget_set_fixed_color_buffer_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    # Returns `true` when the captured image is mirrored vertically.
    def mirror_vertically? : Bool
      LibQt6.qt6cr_rhi_widget_is_mirror_vertically_enabled(to_unsafe)
    end

    # Enables or disables vertical mirroring.
    def mirror_vertically=(value : Bool) : Bool
      LibQt6.qt6cr_rhi_widget_set_mirror_vertically(to_unsafe, value)
      value
    end

    # Captures the widget's current framebuffer into an image.
    def grab_framebuffer : QImage
      QImage.wrap(LibQt6.qt6cr_rhi_widget_grab_framebuffer(to_unsafe), true)
    end

    # Qt-style alias for `api=`.
    def set_api(value : RhiWidgetApi) : self
      self.api = value
      self
    end

    # Qt-style alias for `debug_layer_enabled=`.
    def set_debug_layer_enabled(value : Bool) : self
      self.debug_layer_enabled = value
      self
    end

    # Qt-style alias for `sample_count=`.
    def set_sample_count(value : Int) : self
      self.sample_count = value
      self
    end

    # Qt-style alias for `color_buffer_format=`.
    def set_color_buffer_format(value : RhiWidgetTextureFormat) : self
      self.color_buffer_format = value
      self
    end

    # Qt-style alias for `fixed_color_buffer_size=`.
    def set_fixed_color_buffer_size(value : Size) : self
      self.fixed_color_buffer_size = value
      self
    end

    # Qt-style overload for assigning a fixed color-buffer size from dimensions.
    def set_fixed_color_buffer_size(width : Int, height : Int) : self
      self.fixed_color_buffer_size = Size.new(width, height)
      self
    end

    # Qt-style alias for `mirror_vertically=`.
    def set_mirror_vertically(value : Bool) : self
      self.mirror_vertically = value
      self
    end

    def on_frame_submitted(&block : ->) : self
      @frame_submitted.connect { block.call }
      self
    end

    def on_render_failed(&block : ->) : self
      @render_failed.connect { block.call }
      self
    end

    def on_sample_count_changed(&block : Int32 ->) : self
      @sample_count_changed.connect { |value| block.call(value) }
      self
    end

    def on_color_buffer_format_changed(&block : RhiWidgetTextureFormat ->) : self
      @color_buffer_format_changed.connect { |value| block.call(value) }
      self
    end

    def on_fixed_color_buffer_size_changed(&block : Size ->) : self
      @fixed_color_buffer_size_changed.connect { |value| block.call(value) }
      self
    end

    def on_mirror_vertically_changed(&block : Bool ->) : self
      @mirror_vertically_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_frame_submitted : Nil
      @frame_submitted.emit
    end

    protected def emit_render_failed : Nil
      @render_failed.emit
    end

    protected def emit_sample_count_changed(value : Int32) : Nil
      @sample_count_changed.emit(value)
    end

    protected def emit_color_buffer_format_changed(value : Int32) : Nil
      @color_buffer_format_changed.emit(RhiWidgetTextureFormat.from_value(value))
    end

    protected def emit_fixed_color_buffer_size_changed(value : Size) : Nil
      @fixed_color_buffer_size_changed.emit(value)
    end

    protected def emit_mirror_vertically_changed(value : Bool) : Nil
      @mirror_vertically_changed.emit(value)
    end

    private def register_rhi_widget_callbacks : Nil
      @frame_submitted = Signal().new
      @render_failed = Signal().new
      @sample_count_changed = Signal(Int32).new
      @color_buffer_format_changed = Signal(RhiWidgetTextureFormat).new
      @fixed_color_buffer_size_changed = Signal(Size).new
      @mirror_vertically_changed = Signal(Bool).new
      @frame_submitted_userdata = Box.box(self.as(RhiWidget))
      @render_failed_userdata = Box.box(self.as(RhiWidget))
      @sample_count_changed_userdata = Box.box(self.as(RhiWidget))
      @color_buffer_format_changed_userdata = Box.box(self.as(RhiWidget))
      @fixed_color_buffer_size_changed_userdata = Box.box(self.as(RhiWidget))
      @mirror_vertically_changed_userdata = Box.box(self.as(RhiWidget))
      LibQt6.qt6cr_rhi_widget_on_frame_submitted(to_unsafe, FRAME_SUBMITTED_TRAMPOLINE, @frame_submitted_userdata)
      LibQt6.qt6cr_rhi_widget_on_render_failed(to_unsafe, RENDER_FAILED_TRAMPOLINE, @render_failed_userdata)
      LibQt6.qt6cr_rhi_widget_on_sample_count_changed(to_unsafe, SAMPLE_COUNT_CHANGED_TRAMPOLINE, @sample_count_changed_userdata)
      LibQt6.qt6cr_rhi_widget_on_color_buffer_format_changed(to_unsafe, COLOR_BUFFER_FORMAT_CHANGED_TRAMPOLINE, @color_buffer_format_changed_userdata)
      LibQt6.qt6cr_rhi_widget_on_fixed_color_buffer_size_changed(to_unsafe, FIXED_COLOR_BUFFER_SIZE_CHANGED_TRAMPOLINE, @fixed_color_buffer_size_changed_userdata)
      LibQt6.qt6cr_rhi_widget_on_mirror_vertically_changed(to_unsafe, MIRROR_VERTICALLY_CHANGED_TRAMPOLINE, @mirror_vertically_changed_userdata)
    end

    private FRAME_SUBMITTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(RhiWidget).unbox(userdata).emit_frame_submitted
    end

    private RENDER_FAILED_TRAMPOLINE = ->(userdata : Void*) do
      Box(RhiWidget).unbox(userdata).emit_render_failed
    end

    private SAMPLE_COUNT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(RhiWidget).unbox(userdata).emit_sample_count_changed(value)
    end

    private COLOR_BUFFER_FORMAT_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(RhiWidget).unbox(userdata).emit_color_buffer_format_changed(value)
    end

    private FIXED_COLOR_BUFFER_SIZE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : LibQt6::SizeValue) do
      Box(RhiWidget).unbox(userdata).emit_fixed_color_buffer_size_changed(Size.from_native(value))
    end

    private MIRROR_VERTICALLY_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(RhiWidget).unbox(userdata).emit_mirror_vertically_changed(value)
    end
  end
end
