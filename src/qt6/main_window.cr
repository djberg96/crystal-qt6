module Qt6
  class MainWindow < Widget
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_main_window_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def central_widget=(widget : Widget) : Widget
      LibQt6.qt6cr_main_window_set_central_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    def menu_bar : MenuBar
      MenuBar.wrap(LibQt6.qt6cr_main_window_menu_bar(to_unsafe))
    end

    def status_bar : StatusBar
      StatusBar.wrap(LibQt6.qt6cr_main_window_status_bar(to_unsafe))
    end

    def add_tool_bar(toolbar : ToolBar) : ToolBar
      LibQt6.qt6cr_main_window_add_tool_bar(to_unsafe, toolbar.to_unsafe)
      toolbar.adopt_by_parent!
      toolbar
    end

    def add_dock_widget(dock_widget : DockWidget, area : DockArea = DockArea::Left) : DockWidget
      LibQt6.qt6cr_main_window_add_dock_widget(to_unsafe, area.value, dock_widget.to_unsafe)
      dock_widget.adopt_by_parent!
      dock_widget
    end
  end
end
