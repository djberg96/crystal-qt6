module Qt6
  # Wraps `QDockWidget`.
  class DockWidget < Widget
    # Creates a dock widget with optional title and parent.
    def initialize(title : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_dock_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe), parent.nil?)
    end

    # Sets the dock's child widget and returns it.
    def widget=(widget : Widget) : Widget
      LibQt6.qt6cr_dock_widget_set_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end
  end
end
