module Qt6
  # Wraps `QDockWidget`.
  class DockWidget < Widget
    # Creates a dock widget with optional title and parent.
    def initialize(title : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_dock_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe), parent.nil?)
    end

    # Returns the dock title.
    def title : String
      window_title
    end

    # Sets the dock title.
    def title=(value : String) : String
      self.window_title = value
    end

    # Returns the dock's current child widget, if present.
    def widget : Widget?
      handle = LibQt6.qt6cr_dock_widget_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Sets the dock's child widget and returns it.
    def widget=(widget : Widget) : Widget
      LibQt6.qt6cr_dock_widget_set_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Returns `true` when the dock is detached into its own floating window.
    def floating? : Bool
      LibQt6.qt6cr_dock_widget_is_floating(to_unsafe)
    end

    # Docks or undocks the widget into a floating window.
    def floating=(value : Bool) : Bool
      LibQt6.qt6cr_dock_widget_set_floating(to_unsafe, value)
      value
    end

    # Returns the built-in visibility toggle action for this dock.
    def toggle_view_action : Action
      Action.wrap(LibQt6.qt6cr_dock_widget_toggle_view_action(to_unsafe))
    end
  end
end
