module Qt6
  # Wraps a `QStyle` instance.
  class Style < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the style's Qt name.
    def name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_name(to_unsafe))
    end

    # Returns the style's standard palette.
    def standard_palette : QPalette
      QPalette.wrap(LibQt6.qt6cr_style_standard_palette(to_unsafe), true)
    end

    # Applies this style to the given widget and returns it.
    def polish(widget : Widget) : Widget
      LibQt6.qt6cr_style_polish_widget(to_unsafe, widget.to_unsafe)
      widget
    end

    # Removes this style's widget-specific polish and returns the widget.
    def unpolish(widget : Widget) : Widget
      LibQt6.qt6cr_style_unpolish_widget(to_unsafe, widget.to_unsafe)
      widget
    end

    # Applies this style to the given application and returns it.
    def polish(application : Application) : Application
      LibQt6.qt6cr_style_polish_application(to_unsafe, application.to_unsafe)
      application
    end

    # Removes this style's application-specific polish and returns the application.
    def unpolish(application : Application) : Application
      LibQt6.qt6cr_style_unpolish_application(to_unsafe, application.to_unsafe)
      application
    end

    # Applies this style to the given palette and returns it.
    def polish(palette : QPalette) : QPalette
      LibQt6.qt6cr_style_polish_palette(to_unsafe, palette.to_unsafe)
      palette
    end
  end
end
