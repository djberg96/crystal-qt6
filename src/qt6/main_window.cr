module Qt6
  # Wraps `QMainWindow`.
  class MainWindow < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a main window with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_main_window_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current central widget, if any.
    def central_widget : Widget?
      handle = LibQt6.qt6cr_main_window_central_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
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

    # Replaces the main window's menu bar and returns it.
    def menu_bar=(value : MenuBar) : MenuBar
      LibQt6.qt6cr_main_window_set_menu_bar(to_unsafe, value.to_unsafe)
      value.adopt_by_parent!
      value
    end

    # Returns the main window's status bar.
    def status_bar : StatusBar
      StatusBar.wrap(LibQt6.qt6cr_main_window_status_bar(to_unsafe))
    end

    # Replaces the main window's status bar and returns it.
    def status_bar=(value : StatusBar) : StatusBar
      LibQt6.qt6cr_main_window_set_status_bar(to_unsafe, value.to_unsafe)
      value.adopt_by_parent!
      value
    end

    # Adds a toolbar to the default area and returns it.
    def add_tool_bar(toolbar : ToolBar) : ToolBar
      LibQt6.qt6cr_main_window_add_tool_bar(to_unsafe, toolbar.to_unsafe)
      toolbar.adopt_by_parent!
      toolbar
    end

    # Adds a toolbar to the given area and returns it.
    def add_tool_bar(area : ToolBarArea, toolbar : ToolBar) : ToolBar
      LibQt6.qt6cr_main_window_add_tool_bar_in_area(to_unsafe, area.value, toolbar.to_unsafe)
      toolbar.adopt_by_parent!
      toolbar
    end

    # Inserts a toolbar before another toolbar and returns it.
    def insert_tool_bar(before : ToolBar, toolbar : ToolBar) : ToolBar
      LibQt6.qt6cr_main_window_insert_tool_bar(to_unsafe, before.to_unsafe, toolbar.to_unsafe)
      toolbar.adopt_by_parent!
      toolbar
    end

    # Removes a toolbar from the main window.
    def remove_tool_bar(toolbar : ToolBar) : ToolBar
      LibQt6.qt6cr_main_window_remove_tool_bar(to_unsafe, toolbar.to_unsafe)
      toolbar
    end

    # Returns the main-window-wide icon size for toolbars and buttons.
    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_main_window_icon_size(to_unsafe))
    end

    # Sets the main-window-wide icon size for toolbars and buttons.
    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_main_window_set_icon_size(to_unsafe, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    # Returns the main-window-wide tool-button style.
    def tool_button_style : ToolButtonStyle
      ToolButtonStyle.from_value(LibQt6.qt6cr_main_window_tool_button_style(to_unsafe))
    end

    # Sets the main-window-wide tool-button style.
    def tool_button_style=(value : ToolButtonStyle) : ToolButtonStyle
      LibQt6.qt6cr_main_window_set_tool_button_style(to_unsafe, value.value)
      value
    end

    # Returns `true` when dock and toolbar animations are enabled.
    def animated? : Bool
      LibQt6.qt6cr_main_window_animated(to_unsafe)
    end

    # Enables or disables dock and toolbar animations.
    def animated=(value : Bool) : Bool
      LibQt6.qt6cr_main_window_set_animated(to_unsafe, value)
      value
    end

    # Returns `true` when document-mode tabs are preferred.
    def document_mode? : Bool
      LibQt6.qt6cr_main_window_document_mode(to_unsafe)
    end

    # Enables or disables document-mode tabs.
    def document_mode=(value : Bool) : Bool
      LibQt6.qt6cr_main_window_set_document_mode(to_unsafe, value)
      value
    end

    # Returns `true` when docks may be nested.
    def dock_nesting_enabled? : Bool
      LibQt6.qt6cr_main_window_dock_nesting_enabled(to_unsafe)
    end

    # Enables or disables dock nesting.
    def dock_nesting_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_main_window_set_dock_nesting_enabled(to_unsafe, value)
      value
    end

    # Returns the dock area assigned to the given corner.
    def corner(corner : Corner) : DockArea
      DockArea.from_value(LibQt6.qt6cr_main_window_corner(to_unsafe, corner.value))
    end

    # Assigns a dock area to the given corner.
    def set_corner(corner : Corner, area : DockArea) : DockArea
      LibQt6.qt6cr_main_window_set_corner(to_unsafe, corner.value, area.value)
      area
    end

    # Adds a dock widget to the main window in the given dock area.
    def add_dock_widget(dock_widget : DockWidget, area : DockArea = DockArea::Left) : DockWidget
      LibQt6.qt6cr_main_window_add_dock_widget(to_unsafe, area.value, dock_widget.to_unsafe)
      dock_widget.adopt_by_parent!
      dock_widget
    end

    # Removes a dock widget from the main window.
    def remove_dock_widget(dock_widget : DockWidget) : DockWidget
      LibQt6.qt6cr_main_window_remove_dock_widget(to_unsafe, dock_widget.to_unsafe)
      dock_widget
    end

    # Saves the current dock/toolbar layout state.
    def save_state : QByteArray
      QByteArray.wrap(LibQt6.qt6cr_main_window_save_state(to_unsafe), true)
    end

    # Restores a previously saved dock/toolbar layout state.
    def restore_state(value : QByteArray) : Bool
      LibQt6.qt6cr_main_window_restore_state(to_unsafe, value.to_unsafe)
    end

    # Convenience overload that accepts raw bytes.
    def restore_state(value : Bytes) : Bool
      state = QByteArray.new(value)
      result = restore_state(state)
      state.release
      result
    end

    # Qt-style alias for `menu_bar=`.
    def set_menu_bar(value : MenuBar) : self
      self.menu_bar = value
      self
    end

    # Qt-style alias for `status_bar=`.
    def set_status_bar(value : StatusBar) : self
      self.status_bar = value
      self
    end

    # Qt-style alias for `icon_size=`.
    def set_icon_size(value : Size) : self
      self.icon_size = value
      self
    end

    # Qt-style alias for `tool_button_style=`.
    def set_tool_button_style(value : ToolButtonStyle) : self
      self.tool_button_style = value
      self
    end

    # Qt-style alias for `animated=`.
    def set_animated(value : Bool) : self
      self.animated = value
      self
    end

    # Qt-style alias for `document_mode=`.
    def set_document_mode(value : Bool) : self
      self.document_mode = value
      self
    end

    # Qt-style alias for `dock_nesting_enabled=`.
    def set_dock_nesting_enabled(value : Bool) : self
      self.dock_nesting_enabled = value
      self
    end
  end
end
