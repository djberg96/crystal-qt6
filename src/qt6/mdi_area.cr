module Qt6
  # Wraps `QMdiArea` for multi-document desktop shells.
  class MdiArea < AbstractScrollArea
    @sub_window_activated : Signal(MdiSubWindow?) = Signal(MdiSubWindow?).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter sub_window_activated : Signal(MdiSubWindow?)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an MDI workspace with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_mdi_area_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    # Adds a document widget and returns the created subwindow wrapper.
    def add_sub_window(widget : Widget) : MdiSubWindow
      handle = LibQt6.qt6cr_mdi_area_add_sub_window(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      MdiSubWindow.wrap(handle)
    end

    # Removes a document widget from the MDI workspace and returns it.
    def remove_sub_window(widget : Widget) : Widget
      LibQt6.qt6cr_mdi_area_remove_sub_window(to_unsafe, widget.to_unsafe)
      widget
    end

    # Returns the current subwindow, if present.
    def current_sub_window : MdiSubWindow?
      handle = LibQt6.qt6cr_mdi_area_current_sub_window(to_unsafe)
      handle.null? ? nil : MdiSubWindow.wrap(handle)
    end

    # Returns the active subwindow, if present.
    def active_sub_window : MdiSubWindow?
      handle = LibQt6.qt6cr_mdi_area_active_sub_window(to_unsafe)
      handle.null? ? nil : MdiSubWindow.wrap(handle)
    end

    # Returns the background brush used behind subwindows.
    def background : QBrush
      QBrush.wrap(LibQt6.qt6cr_mdi_area_background(to_unsafe), true)
    end

    # Sets the background brush and returns it.
    def background=(value : QBrush) : QBrush
      LibQt6.qt6cr_mdi_area_set_background(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the subwindow activation order.
    def activation_order : MdiWindowOrder
      MdiWindowOrder.from_value(LibQt6.qt6cr_mdi_area_activation_order(to_unsafe))
    end

    # Sets the subwindow activation order and returns it.
    def activation_order=(value : MdiWindowOrder) : MdiWindowOrder
      LibQt6.qt6cr_mdi_area_set_activation_order(to_unsafe, value.value)
      value
    end

    # Returns the current subwindows in the requested order.
    def sub_windows(order : MdiWindowOrder = MdiWindowOrder::CreationOrder) : Array(MdiSubWindow)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_mdi_area_sub_window_list(to_unsafe, order.value)).map do |handle|
        MdiSubWindow.wrap(handle)
      end
    end

    # Enables or disables a single area option.
    def set_option(option : MdiAreaOption, value : Bool = true) : Bool
      LibQt6.qt6cr_mdi_area_set_option(to_unsafe, option.value, value)
      value
    end

    # Returns `true` when the option is enabled.
    def option?(option : MdiAreaOption) : Bool
      LibQt6.qt6cr_mdi_area_test_option(to_unsafe, option.value)
    end

    # Returns the current MDI presentation mode.
    def view_mode : MdiViewMode
      MdiViewMode.from_value(LibQt6.qt6cr_mdi_area_view_mode(to_unsafe))
    end

    # Sets the presentation mode and returns it.
    def view_mode=(value : MdiViewMode) : MdiViewMode
      LibQt6.qt6cr_mdi_area_set_view_mode(to_unsafe, value.value)
      value
    end

    # Returns `true` when document mode is enabled for tabbed view.
    def document_mode? : Bool
      LibQt6.qt6cr_mdi_area_document_mode(to_unsafe)
    end

    # Enables or disables document mode.
    def document_mode=(value : Bool) : Bool
      LibQt6.qt6cr_mdi_area_set_document_mode(to_unsafe, value)
      value
    end

    # Returns the tab position used in tabbed view mode.
    def tab_position : TabPosition
      TabPosition.from_value(LibQt6.qt6cr_mdi_area_tab_position(to_unsafe))
    end

    # Sets the tab position used in tabbed view mode.
    def tab_position=(value : TabPosition) : TabPosition
      LibQt6.qt6cr_mdi_area_set_tab_position(to_unsafe, value.value)
      value
    end

    # Returns the tab shape used in tabbed view mode.
    def tab_shape : TabShape
      TabShape.from_value(LibQt6.qt6cr_mdi_area_tab_shape(to_unsafe))
    end

    # Sets the tab shape used in tabbed view mode.
    def tab_shape=(value : TabShape) : TabShape
      LibQt6.qt6cr_mdi_area_set_tab_shape(to_unsafe, value.value)
      value
    end

    # Returns `true` when subwindow tabs show close buttons.
    def tabs_closable? : Bool
      LibQt6.qt6cr_mdi_area_tabs_closable(to_unsafe)
    end

    # Enables or disables closable tabs.
    def tabs_closable=(value : Bool) : Bool
      LibQt6.qt6cr_mdi_area_set_tabs_closable(to_unsafe, value)
      value
    end

    # Returns `true` when subwindow tabs can be reordered.
    def tabs_movable? : Bool
      LibQt6.qt6cr_mdi_area_tabs_movable(to_unsafe)
    end

    # Enables or disables tab reordering.
    def tabs_movable=(value : Bool) : Bool
      LibQt6.qt6cr_mdi_area_set_tabs_movable(to_unsafe, value)
      value
    end

    # Activates the given subwindow and returns it.
    def set_active_sub_window(sub_window : MdiSubWindow?) : MdiSubWindow?
      LibQt6.qt6cr_mdi_area_set_active_sub_window(to_unsafe, sub_window.try(&.to_unsafe) || Pointer(Void).null)
      sub_window
    end

    # Arranges subwindows in a tiled layout.
    def tile_sub_windows : self
      LibQt6.qt6cr_mdi_area_tile_sub_windows(to_unsafe)
      self
    end

    # Arranges subwindows in a cascade.
    def cascade_sub_windows : self
      LibQt6.qt6cr_mdi_area_cascade_sub_windows(to_unsafe)
      self
    end

    # Closes the currently active subwindow.
    def close_active_sub_window : self
      LibQt6.qt6cr_mdi_area_close_active_sub_window(to_unsafe)
      self
    end

    # Closes every subwindow in the workspace.
    def close_all_sub_windows : self
      LibQt6.qt6cr_mdi_area_close_all_sub_windows(to_unsafe)
      self
    end

    # Moves activation to the next subwindow.
    def activate_next_sub_window : self
      LibQt6.qt6cr_mdi_area_activate_next_sub_window(to_unsafe)
      self
    end

    # Moves activation to the previous subwindow.
    def activate_previous_sub_window : self
      LibQt6.qt6cr_mdi_area_activate_previous_sub_window(to_unsafe)
      self
    end

    # Registers a block to run when the active subwindow changes.
    def on_sub_window_activated(&block : MdiSubWindow? ->) : self
      @sub_window_activated.connect { |sub_window| block.call(sub_window) }
      self
    end

    # Qt-style alias for `background=`.
    def set_background(value : QBrush) : self
      self.background = value
      self
    end

    # Qt-style alias for `activation_order=`.
    def set_activation_order(value : MdiWindowOrder) : self
      self.activation_order = value
      self
    end

    # Qt-style alias for `view_mode=`.
    def set_view_mode(value : MdiViewMode) : self
      self.view_mode = value
      self
    end

    # Qt-style alias for `document_mode=`.
    def set_document_mode(value : Bool) : self
      self.document_mode = value
      self
    end

    # Qt-style alias for `tab_position=`.
    def set_tab_position(value : TabPosition) : self
      self.tab_position = value
      self
    end

    # Qt-style alias for `tab_shape=`.
    def set_tab_shape(value : TabShape) : self
      self.tab_shape = value
      self
    end

    # Qt-style alias for `tabs_closable=`.
    def set_tabs_closable(value : Bool) : self
      self.tabs_closable = value
      self
    end

    # Qt-style alias for `tabs_movable=`.
    def set_tabs_movable(value : Bool) : self
      self.tabs_movable = value
      self
    end

    protected def emit_sub_window_activated(sub_window : MdiSubWindow?) : Nil
      @sub_window_activated.emit(sub_window)
    end

    private def register_callbacks : Nil
      @sub_window_activated = Signal(MdiSubWindow?).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_mdi_area_on_sub_window_activated(to_unsafe, SUB_WINDOW_ACTIVATED_TRAMPOLINE, @callback_userdata)
    end

    private SUB_WINDOW_ACTIVATED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      area = Box(MdiArea).unbox(userdata)
      area.emit_sub_window_activated(handle.null? ? nil : MdiSubWindow.wrap(handle))
    end
  end
end
