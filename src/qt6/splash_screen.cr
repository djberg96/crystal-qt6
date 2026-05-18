module Qt6
  # Wraps `QSplashScreen`.
  class SplashScreen < Widget
    @message_changed : Signal(String) = Signal(String).new
    @message_changed_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever the displayed splash message changes.
    getter message_changed : Signal(String)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a splash screen from an optional pixmap.
    def initialize(pixmap : QPixmap? = nil)
      super(LibQt6.qt6cr_splash_screen_create(pixmap.try(&.to_unsafe) || Pointer(Void).null), true)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @message_changed = Signal(String).new
      @message_changed_userdata = Box.box(self)
      LibQt6.qt6cr_splash_screen_on_message_changed(to_unsafe, MESSAGE_CHANGED_TRAMPOLINE, @message_changed_userdata)
    end

    # Returns the current splash pixmap.
    def pixmap : QPixmap
      QPixmap.wrap(LibQt6.qt6cr_splash_screen_pixmap(to_unsafe), true)
    end

    # Sets the splash pixmap.
    def pixmap=(value : QPixmap) : QPixmap
      LibQt6.qt6cr_splash_screen_set_pixmap(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `pixmap=`.
    def set_pixmap(value : QPixmap) : self
      self.pixmap = value
      self
    end

    # Returns the currently displayed message text.
    def message : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_splash_screen_message(to_unsafe))
    end

    # Backward-compatible overload for callers that pass only a color.
    def show_message(message : String, color : Color) : String
      show_message(message, AlignmentFlag::Left, color)
    end

    # Shows a status message on the splash screen.
    def show_message(message : String, alignment : AlignmentFlag = AlignmentFlag::Left, color : Color = Color.new(0, 0, 0)) : String
      LibQt6.qt6cr_splash_screen_show_message(to_unsafe, message.to_unsafe, alignment.value, color.to_native)
      message
    end

    # Registers a block to run when the displayed message changes.
    def on_message_changed(&block : String ->) : self
      @message_changed.connect { |value| block.call(value) }
      self
    end

    # Clears the current splash message.
    def clear_message : self
      LibQt6.qt6cr_splash_screen_clear_message(to_unsafe)
      self
    end

    # Hides the splash screen once the target widget is ready.
    def finish(widget : Widget) : Widget
      LibQt6.qt6cr_splash_screen_finish(to_unsafe, widget.to_unsafe)
      widget
    end

    protected def emit_message_changed(message : UInt8*) : Nil
      @message_changed.emit(Qt6.copy_string(message))
    end

    private MESSAGE_CHANGED_TRAMPOLINE = ->(userdata : Void*, message : UInt8*) do
      Box(SplashScreen).unbox(userdata).emit_message_changed(message)
    end
  end
end
