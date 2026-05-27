module Qt6
  # Wraps `QTabWidget`.
  class TabWidget < Widget
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @tab_close_requested : Signal(Int32) = Signal(Int32).new
    @tab_bar_clicked : Signal(Int32) = Signal(Int32).new
    @tab_bar_double_clicked : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the current tab changes.
    getter current_index_changed : Signal(Int32)

    # Signal emitted when a tab close button is requested.
    getter tab_close_requested : Signal(Int32)

    # Signal emitted when a tab is clicked.
    getter tab_bar_clicked : Signal(Int32)

    # Signal emitted when a tab is double-clicked.
    getter tab_bar_double_clicked : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a tab widget with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tab_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @current_index_changed = Signal(Int32).new
      @tab_close_requested = Signal(Int32).new
      @tab_bar_clicked = Signal(Int32).new
      @tab_bar_double_clicked = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tab_widget_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tab_widget_on_tab_close_requested(to_unsafe, TAB_CLOSE_REQUESTED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tab_widget_on_tab_bar_clicked(to_unsafe, TAB_BAR_CLICKED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tab_widget_on_tab_bar_double_clicked(to_unsafe, TAB_BAR_DOUBLE_CLICKED_TRAMPOLINE, @callback_userdata)
    end

    # Adds a page widget with the given tab label and returns the page.
    def add_tab(widget : Widget, label : String) : Widget
      LibQt6.qt6cr_tab_widget_add_tab(to_unsafe, widget.to_unsafe, label.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Adds a page widget with an icon and tab label and returns the page.
    def add_tab(widget : Widget, icon : QIcon, label : String) : Widget
      LibQt6.qt6cr_tab_widget_add_tab_with_icon(to_unsafe, widget.to_unsafe, icon.to_unsafe, label.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Inserts a page widget at the requested index and returns the page.
    def insert_tab(index : Int, widget : Widget, label : String) : Widget
      LibQt6.qt6cr_tab_widget_insert_tab(to_unsafe, index.to_i32, widget.to_unsafe, label.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Inserts a page widget with an icon at the requested index and returns the page.
    def insert_tab(index : Int, widget : Widget, icon : QIcon, label : String) : Widget
      LibQt6.qt6cr_tab_widget_insert_tab_with_icon(to_unsafe, index.to_i32, widget.to_unsafe, icon.to_unsafe, label.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Returns the page widget at the given index, if present.
    def widget(index : Int) : Widget?
      handle = LibQt6.qt6cr_tab_widget_widget(to_unsafe, index.to_i32)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Returns the number of tabs.
    def count : Int32
      LibQt6.qt6cr_tab_widget_count(to_unsafe)
    end

    # Returns the selected tab index.
    def current_index : Int32
      LibQt6.qt6cr_tab_widget_current_index(to_unsafe)
    end

    # Changes the selected tab index and returns the assigned value.
    def current_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_tab_widget_set_current_index(to_unsafe, int_value)
      int_value
    end

    # Returns the currently selected page widget, if present.
    def current_widget : Widget?
      handle = LibQt6.qt6cr_tab_widget_current_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Changes the selected page widget and returns it.
    def current_widget=(widget : Widget) : Widget
      LibQt6.qt6cr_tab_widget_set_current_widget(to_unsafe, widget.to_unsafe)
      widget
    end

    # Returns the index of the given page widget, or `-1` when absent.
    def index_of(widget : Widget) : Int32
      LibQt6.qt6cr_tab_widget_index_of(to_unsafe, widget.to_unsafe)
    end

    # Returns the tab label at the given index.
    def tab_text(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tab_widget_tab_text(to_unsafe, index.to_i32))
    end

    # Sets the tab label at the given index and returns it.
    def set_tab_text(index : Int, value : String) : String
      LibQt6.qt6cr_tab_widget_set_tab_text(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    # Returns the tab icon at the given index.
    def tab_icon(index : Int) : QIcon
      QIcon.wrap(LibQt6.qt6cr_tab_widget_tab_icon(to_unsafe, index.to_i32), true)
    end

    # Sets the tab icon at the given index and returns it.
    def set_tab_icon(index : Int, value : QIcon) : QIcon
      LibQt6.qt6cr_tab_widget_set_tab_icon(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    # Returns `true` when the tab at the given index is enabled.
    def tab_enabled?(index : Int) : Bool
      LibQt6.qt6cr_tab_widget_tab_enabled(to_unsafe, index.to_i32)
    end

    # Enables or disables the tab at the given index.
    def set_tab_enabled(index : Int, value : Bool) : Bool
      LibQt6.qt6cr_tab_widget_set_tab_enabled(to_unsafe, index.to_i32, value)
      value
    end

    # Returns `true` when the tab at the given index is visible.
    def tab_visible?(index : Int) : Bool
      LibQt6.qt6cr_tab_widget_tab_visible(to_unsafe, index.to_i32)
    end

    # Shows or hides the tab at the given index.
    def set_tab_visible(index : Int, value : Bool) : Bool
      LibQt6.qt6cr_tab_widget_set_tab_visible(to_unsafe, index.to_i32, value)
      value
    end

    # Returns the tab tooltip at the given index.
    def tab_tool_tip(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tab_widget_tab_tool_tip(to_unsafe, index.to_i32))
    end

    # Sets the tab tooltip at the given index and returns it.
    def set_tab_tool_tip(index : Int, value : String) : String
      LibQt6.qt6cr_tab_widget_set_tab_tool_tip(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    # Returns the tab What's This text at the given index.
    def tab_whats_this(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tab_widget_tab_whats_this(to_unsafe, index.to_i32))
    end

    # Sets the tab What's This text at the given index and returns it.
    def set_tab_whats_this(index : Int, value : String) : String
      LibQt6.qt6cr_tab_widget_set_tab_whats_this(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    # Removes the tab at the given index.
    def remove_tab(index : Int) : self
      LibQt6.qt6cr_tab_widget_remove_tab(to_unsafe, index.to_i32)
      self
    end

    # Removes every tab from the widget.
    def clear : self
      LibQt6.qt6cr_tab_widget_clear(to_unsafe)
      self
    end

    # Returns the tab position around the page frame.
    def tab_position : TabPosition
      TabPosition.from_value(LibQt6.qt6cr_tab_widget_tab_position(to_unsafe))
    end

    # Sets the tab position around the page frame and returns it.
    def tab_position=(value : TabPosition) : TabPosition
      LibQt6.qt6cr_tab_widget_set_tab_position(to_unsafe, value.value)
      value
    end

    # Returns `true` when close buttons are shown on tabs.
    def tabs_closable? : Bool
      LibQt6.qt6cr_tab_widget_tabs_closable(to_unsafe)
    end

    # Shows or hides close buttons on tabs.
    def tabs_closable=(value : Bool) : Bool
      LibQt6.qt6cr_tab_widget_set_tabs_closable(to_unsafe, value)
      value
    end

    # Returns `true` when tabs may be reordered by the user.
    def movable? : Bool
      LibQt6.qt6cr_tab_widget_movable(to_unsafe)
    end

    # Enables or disables user-driven tab reordering.
    def movable=(value : Bool) : Bool
      LibQt6.qt6cr_tab_widget_set_movable(to_unsafe, value)
      value
    end

    # Returns the visual tab shape.
    def tab_shape : TabShape
      TabShape.from_value(LibQt6.qt6cr_tab_widget_tab_shape(to_unsafe))
    end

    # Sets the visual tab shape and returns it.
    def tab_shape=(value : TabShape) : TabShape
      LibQt6.qt6cr_tab_widget_set_tab_shape(to_unsafe, value.value)
      value
    end

    # Returns the preferred overall size of the tab widget.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_tab_widget_size_hint(to_unsafe))
    end

    # Returns the minimum recommended size of the tab widget.
    def minimum_size_hint : Size
      Size.from_native(LibQt6.qt6cr_tab_widget_minimum_size_hint(to_unsafe))
    end

    # Returns the widget installed in the requested tab corner, if present.
    def corner_widget(corner : Corner = Corner::TopRightCorner) : Widget?
      handle = LibQt6.qt6cr_tab_widget_corner_widget(to_unsafe, corner.value)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Installs or clears a widget in the requested tab corner.
    def set_corner_widget(widget : Widget?, corner : Corner = Corner::TopRightCorner) : Widget?
      LibQt6.qt6cr_tab_widget_set_corner_widget(to_unsafe, widget.try(&.to_unsafe) || Pointer(Void).null, corner.value)
      widget.try(&.adopt_by_parent!)
      widget
    end

    # Returns the tab text elide mode.
    def elide_mode : TextElideMode
      TextElideMode.from_value(LibQt6.qt6cr_tab_widget_elide_mode(to_unsafe))
    end

    # Sets the tab text elide mode and returns it.
    def elide_mode=(value : TextElideMode) : TextElideMode
      LibQt6.qt6cr_tab_widget_set_elide_mode(to_unsafe, value.value)
      value
    end

    # Returns the icon size used for tabs.
    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_tab_widget_icon_size(to_unsafe))
    end

    # Sets the icon size used for tabs and returns it.
    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_tab_widget_set_icon_size(to_unsafe, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    # Returns `true` when scroll buttons are used for overflowing tabs.
    def uses_scroll_buttons? : Bool
      LibQt6.qt6cr_tab_widget_uses_scroll_buttons(to_unsafe)
    end

    # Enables or disables scroll buttons for overflowing tabs.
    def uses_scroll_buttons=(value : Bool) : Bool
      LibQt6.qt6cr_tab_widget_set_uses_scroll_buttons(to_unsafe, value)
      value
    end

    # Returns `true` when document-mode styling is enabled.
    def document_mode? : Bool
      LibQt6.qt6cr_tab_widget_document_mode(to_unsafe)
    end

    # Enables or disables document-mode styling.
    def document_mode=(value : Bool) : Bool
      LibQt6.qt6cr_tab_widget_set_document_mode(to_unsafe, value)
      value
    end

    # Returns `true` when the tab bar hides automatically for a single page.
    def tab_bar_auto_hide? : Bool
      LibQt6.qt6cr_tab_widget_tab_bar_auto_hide(to_unsafe)
    end

    # Enables or disables automatic tab-bar hiding for a single page.
    def tab_bar_auto_hide=(value : Bool) : Bool
      LibQt6.qt6cr_tab_widget_set_tab_bar_auto_hide(to_unsafe, value)
      value
    end

    # Returns the borrowed underlying tab bar wrapper.
    def tab_bar : TabBar
      TabBar.wrap(LibQt6.qt6cr_tab_widget_tab_bar(to_unsafe))
    end

    # Qt-style alias for selecting the current page widget.
    def set_current_widget(widget : Widget) : self
      self.current_widget = widget
      self
    end

    # Qt-style alias for `tab_position=`.
    def set_tab_position(value : TabPosition) : self
      self.tab_position = value
      self
    end

    # Qt-style alias for `tabs_closable=`.
    def set_tabs_closable(value : Bool) : self
      self.tabs_closable = value
      self
    end

    # Qt-style alias for `movable=`.
    def set_movable(value : Bool) : self
      self.movable = value
      self
    end

    # Qt-style alias for `tab_shape=`.
    def set_tab_shape(value : TabShape) : self
      self.tab_shape = value
      self
    end

    # Qt-style alias for `elide_mode=`.
    def set_elide_mode(value : TextElideMode) : self
      self.elide_mode = value
      self
    end

    # Qt-style alias for `icon_size=`.
    def set_icon_size(value : Size) : self
      self.icon_size = value
      self
    end

    # Qt-style alias for `uses_scroll_buttons=`.
    def set_uses_scroll_buttons(value : Bool) : self
      self.uses_scroll_buttons = value
      self
    end

    # Qt-style alias for `document_mode=`.
    def set_document_mode(value : Bool) : self
      self.document_mode = value
      self
    end

    # Qt-style alias for `tab_bar_auto_hide=`.
    def set_tab_bar_auto_hide(value : Bool) : self
      self.tab_bar_auto_hide = value
      self
    end

    # Registers a block to run when the selected tab changes.
    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when a tab close button is requested.
    def on_tab_close_requested(&block : Int32 ->) : self
      @tab_close_requested.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when a tab is clicked.
    def on_tab_bar_clicked(&block : Int32 ->) : self
      @tab_bar_clicked.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when a tab is double-clicked.
    def on_tab_bar_double_clicked(&block : Int32 ->) : self
      @tab_bar_double_clicked.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    protected def emit_tab_close_requested(value : Int32) : Nil
      @tab_close_requested.emit(value)
    end

    protected def emit_tab_bar_clicked(value : Int32) : Nil
      @tab_bar_clicked.emit(value)
    end

    protected def emit_tab_bar_double_clicked(value : Int32) : Nil
      @tab_bar_double_clicked.emit(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabWidget).unbox(userdata).emit_current_index_changed(value)
    end

    private TAB_CLOSE_REQUESTED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabWidget).unbox(userdata).emit_tab_close_requested(value)
    end

    private TAB_BAR_CLICKED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabWidget).unbox(userdata).emit_tab_bar_clicked(value)
    end

    private TAB_BAR_DOUBLE_CLICKED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabWidget).unbox(userdata).emit_tab_bar_double_clicked(value)
    end
  end
end
