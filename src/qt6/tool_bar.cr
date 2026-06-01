module Qt6
  # Wraps `QToolBar`.
  class ToolBar < Widget
    @action_triggered : Signal(Action) = Signal(Action).new
    @movable_changed : Signal(Bool) = Signal(Bool).new
    @allowed_areas_changed : Signal(ToolBarArea) = Signal(ToolBarArea).new
    @orientation_changed : Signal(Orientation) = Signal(Orientation).new
    @icon_size_changed : Signal(Size) = Signal(Size).new
    @tool_button_style_changed : Signal(ToolButtonStyle) = Signal(ToolButtonStyle).new
    @top_level_changed : Signal(Bool) = Signal(Bool).new
    @visibility_changed : Signal(Bool) = Signal(Bool).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter action_triggered : Signal(Action)
    getter movable_changed : Signal(Bool)
    getter allowed_areas_changed : Signal(ToolBarArea)
    getter orientation_changed : Signal(Orientation)
    getter icon_size_changed : Signal(Size)
    getter tool_button_style_changed : Signal(ToolButtonStyle)
    getter top_level_changed : Signal(Bool)
    getter visibility_changed : Signal(Bool)

    # Creates a toolbar with optional title and parent.
    def initialize(title : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_tool_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @action_triggered = Signal(Action).new
      @movable_changed = Signal(Bool).new
      @allowed_areas_changed = Signal(ToolBarArea).new
      @orientation_changed = Signal(Orientation).new
      @icon_size_changed = Signal(Size).new
      @tool_button_style_changed = Signal(ToolButtonStyle).new
      @top_level_changed = Signal(Bool).new
      @visibility_changed = Signal(Bool).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tool_bar_on_action_triggered(to_unsafe, ACTION_TRIGGERED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tool_bar_on_movable_changed(to_unsafe, MOVABLE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tool_bar_on_allowed_areas_changed(to_unsafe, ALLOWED_AREAS_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tool_bar_on_orientation_changed(to_unsafe, ORIENTATION_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tool_bar_on_icon_size_changed(to_unsafe, ICON_SIZE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tool_bar_on_tool_button_style_changed(to_unsafe, TOOL_BUTTON_STYLE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tool_bar_on_top_level_changed(to_unsafe, TOP_LEVEL_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tool_bar_on_visibility_changed(to_unsafe, VISIBILITY_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the toolbar title.
    def title : String
      window_title
    end

    # Sets the toolbar title.
    def title=(value : String) : String
      self.window_title = value
    end

    # Creates a toolbar-owned action with the given text and returns it.
    def add_action(text : String) : Action
      Action.wrap(LibQt6.qt6cr_tool_bar_add_text_action(to_unsafe, text.to_unsafe))
    end

    # Creates a toolbar-owned action with the given icon and text and returns it.
    def add_action(icon : QIcon, text : String) : Action
      Action.wrap(LibQt6.qt6cr_tool_bar_add_icon_text_action(to_unsafe, icon.to_unsafe, text.to_unsafe))
    end

    # Adds an action to the toolbar and returns it.
    def add_action(action : Action) : Action
      LibQt6.qt6cr_tool_bar_add_action(to_unsafe, action.to_unsafe)
      action.adopt_by_parent!
      action
    end

    # Adds a widget to the toolbar and returns it.
    def add_widget(widget : Widget) : Widget
      LibQt6.qt6cr_tool_bar_add_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Adds a separator to the toolbar.
    def add_separator : self
      LibQt6.qt6cr_tool_bar_add_separator(to_unsafe)
      self
    end

    # Inserts a separator before another action and returns the separator action.
    def insert_separator(before : Action) : Action
      Action.wrap(LibQt6.qt6cr_tool_bar_insert_separator(to_unsafe, before.to_unsafe))
    end

    # Inserts a widget before another action and returns the widget action used to host it.
    def insert_widget(before : Action, widget : Widget) : Action
      action = Action.wrap(LibQt6.qt6cr_tool_bar_insert_widget(to_unsafe, before.to_unsafe, widget.to_unsafe))
      widget.adopt_by_parent!
      action
    end

    # Returns the geometry used to render a toolbar action.
    def action_geometry(action : Action) : Rect
      Rect.from_native(LibQt6.qt6cr_tool_bar_action_geometry(to_unsafe, action.to_unsafe))
    end

    # Returns the action at the given toolbar-local position, if any.
    def action_at(position : Point) : Action?
      handle = LibQt6.qt6cr_tool_bar_action_at(to_unsafe, position.to_native)
      handle.null? ? nil : Action.wrap(handle)
    end

    # Returns the action at the given toolbar-local position, if any.
    def action_at(x : Int, y : Int) : Action?
      action_at(Point.new(x, y))
    end

    # Returns the toolbar-hosted widget for an action, if it has one.
    def widget_for_action(action : Action) : Widget?
      handle = LibQt6.qt6cr_tool_bar_widget_for_action(to_unsafe, action.to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Removes all toolbar items.
    def clear : self
      LibQt6.qt6cr_tool_bar_clear(to_unsafe)
      self
    end

    # Returns `true` when the toolbar can be repositioned by the user.
    def movable? : Bool
      LibQt6.qt6cr_tool_bar_is_movable(to_unsafe)
    end

    # Enables or disables toolbar repositioning.
    def movable=(value : Bool) : Bool
      LibQt6.qt6cr_tool_bar_set_movable(to_unsafe, value)
      value
    end

    # Returns the set of main-window areas that accept this toolbar.
    def allowed_areas : ToolBarArea
      ToolBarArea.from_value(LibQt6.qt6cr_tool_bar_allowed_areas(to_unsafe))
    end

    # Sets the main-window areas that accept this toolbar.
    def allowed_areas=(value : ToolBarArea) : ToolBarArea
      LibQt6.qt6cr_tool_bar_set_allowed_areas(to_unsafe, value.value)
      value
    end

    # Returns `true` when the given main-window area accepts this toolbar.
    def area_allowed?(area : ToolBarArea) : Bool
      LibQt6.qt6cr_tool_bar_is_area_allowed(to_unsafe, area.value)
    end

    # Returns the current toolbar orientation.
    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_tool_bar_orientation(to_unsafe))
    end

    # Sets the current toolbar orientation.
    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_tool_bar_set_orientation(to_unsafe, value.value)
      value
    end

    # Returns `true` when the toolbar may detach into a floating window.
    def floatable? : Bool
      LibQt6.qt6cr_tool_bar_is_floatable(to_unsafe)
    end

    # Enables or disables toolbar floating.
    def floatable=(value : Bool) : Bool
      LibQt6.qt6cr_tool_bar_set_floatable(to_unsafe, value)
      value
    end

    # Returns `true` when the toolbar is currently floating in its own window.
    def floating? : Bool
      LibQt6.qt6cr_tool_bar_is_floating(to_unsafe)
    end

    # Returns the icon size used for toolbar actions and buttons.
    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_tool_bar_icon_size(to_unsafe))
    end

    # Sets the icon size used for toolbar actions and buttons.
    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_tool_bar_set_icon_size(to_unsafe, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    # Returns the style used when toolbar actions are shown as buttons.
    def tool_button_style : ToolButtonStyle
      ToolButtonStyle.from_value(LibQt6.qt6cr_tool_bar_tool_button_style(to_unsafe))
    end

    # Sets the style used when toolbar actions are shown as buttons.
    def tool_button_style=(value : ToolButtonStyle) : ToolButtonStyle
      LibQt6.qt6cr_tool_bar_set_tool_button_style(to_unsafe, value.value)
      value
    end

    # Returns the built-in visibility toggle action for this toolbar.
    def toggle_view_action : Action
      Action.wrap(LibQt6.qt6cr_tool_bar_toggle_view_action(to_unsafe))
    end

    def on_action_triggered(&block : Action ->) : self
      @action_triggered.connect { |action| block.call(action) }
      self
    end

    def on_movable_changed(&block : Bool ->) : self
      @movable_changed.connect { |value| block.call(value) }
      self
    end

    def on_allowed_areas_changed(&block : ToolBarArea ->) : self
      @allowed_areas_changed.connect { |value| block.call(value) }
      self
    end

    def on_orientation_changed(&block : Orientation ->) : self
      @orientation_changed.connect { |value| block.call(value) }
      self
    end

    def on_icon_size_changed(&block : Size ->) : self
      @icon_size_changed.connect { |value| block.call(value) }
      self
    end

    def on_tool_button_style_changed(&block : ToolButtonStyle ->) : self
      @tool_button_style_changed.connect { |value| block.call(value) }
      self
    end

    def on_top_level_changed(&block : Bool ->) : self
      @top_level_changed.connect { |value| block.call(value) }
      self
    end

    def on_visibility_changed(&block : Bool ->) : self
      @visibility_changed.connect { |value| block.call(value) }
      self
    end

    def set_allowed_areas(value : ToolBarArea) : self
      self.allowed_areas = value
      self
    end

    def set_orientation(value : Orientation) : self
      self.orientation = value
      self
    end

    def set_movable(value : Bool) : self
      self.movable = value
      self
    end

    def set_floatable(value : Bool) : self
      self.floatable = value
      self
    end

    def set_icon_size(value : Size) : self
      self.icon_size = value
      self
    end

    def set_tool_button_style(value : ToolButtonStyle) : self
      self.tool_button_style = value
      self
    end

    protected def emit_action_triggered(handle : LibQt6::Handle) : Nil
      @action_triggered.emit(Action.wrap(handle))
    end

    protected def emit_movable_changed(value : Bool) : Nil
      @movable_changed.emit(value)
    end

    protected def emit_allowed_areas_changed(value : Int32) : Nil
      @allowed_areas_changed.emit(ToolBarArea.from_value(value))
    end

    protected def emit_orientation_changed(value : Int32) : Nil
      @orientation_changed.emit(Orientation.from_value(value))
    end

    protected def emit_icon_size_changed(value : LibQt6::SizeValue) : Nil
      @icon_size_changed.emit(Size.from_native(value))
    end

    protected def emit_tool_button_style_changed(value : Int32) : Nil
      @tool_button_style_changed.emit(ToolButtonStyle.from_value(value))
    end

    protected def emit_top_level_changed(value : Bool) : Nil
      @top_level_changed.emit(value)
    end

    protected def emit_visibility_changed(value : Bool) : Nil
      @visibility_changed.emit(value)
    end

    private ACTION_TRIGGERED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(ToolBar).unbox(userdata).emit_action_triggered(handle)
    end

    private MOVABLE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(ToolBar).unbox(userdata).emit_movable_changed(value)
    end

    private ALLOWED_AREAS_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ToolBar).unbox(userdata).emit_allowed_areas_changed(value)
    end

    private ORIENTATION_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ToolBar).unbox(userdata).emit_orientation_changed(value)
    end

    private ICON_SIZE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : LibQt6::SizeValue) do
      Box(ToolBar).unbox(userdata).emit_icon_size_changed(value)
    end

    private TOOL_BUTTON_STYLE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ToolBar).unbox(userdata).emit_tool_button_style_changed(value)
    end

    private TOP_LEVEL_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(ToolBar).unbox(userdata).emit_top_level_changed(value)
    end

    private VISIBILITY_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(ToolBar).unbox(userdata).emit_visibility_changed(value)
    end

    # Appends an action to the toolbar and returns `self`.
    def <<(action : Action) : self
      add_action(action)
      self
    end
  end
end
