module Qt6
  # Wraps `QSplashScreen`.
  class SplashScreen < Widget
    # Creates a splash screen from a pixmap.
    def initialize(pixmap : QPixmap)
      super(LibQt6.qt6cr_splash_screen_create(pixmap.to_unsafe), true)
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

    # Returns the currently displayed message text.
    def message : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_splash_screen_message(to_unsafe))
    end

    # Shows a status message on the splash screen.
    def show_message(message : String, color : Color = Color.new(0, 0, 0)) : String
      LibQt6.qt6cr_splash_screen_show_message(to_unsafe, message.to_unsafe, color.to_native)
      message
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
  end
end
