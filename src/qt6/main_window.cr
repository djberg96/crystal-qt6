module Qt6
  # Wraps `QMainWindow`.
  class MainWindow < Widget
    # Creates a main window with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_main_window_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Sets the central widget and returns it.
    def central_widget=(widget : Widget) : Widget
      LibQt6.qt6cr_main_window_set_central_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Returns the main window's menu bar.
    def menu_bar : MenuBar
      MenuBar.wrap(LibQt6.qt6cr_main_window_menu_bar(to_unsafe))
    end

    # Returns the main window's status bar.
    def status_bar : StatusBar
      StatusBar.wrap(LibQt6.qt6cr_main_window_status_bar(to_unsafe))
    end

    # Adds a toolbar to the main window and returns it.
    def add_tool_bar(toolbar : ToolBar) : ToolBar
      LibQt6.qt6cr_main_window_add_tool_bar(to_unsafe, toolbar.to_unsafe)
      toolbar.adopt_by_parent!
      toolbar
    end

    # Adds a dock widget to the main window in the given dock area.
    def add_dock_widget(dock_widget : DockWidget, area : DockArea = DockArea::Left) : DockWidget
      LibQt6.qt6cr_main_window_add_dock_widget(to_unsafe, area.value, dock_widget.to_unsafe)
      dock_widget.adopt_by_parent!
      dock_widget
    end
  end
end
