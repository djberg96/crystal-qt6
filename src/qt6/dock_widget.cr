module Qt6
  # Wraps `QDockWidget`.
  class DockWidget < Widget
    @features_changed : Signal(DockWidgetFeature) = Signal(DockWidgetFeature).new
    @top_level_changed : Signal(Bool) = Signal(Bool).new
    @allowed_areas_changed : Signal(DockArea) = Signal(DockArea).new
    @visibility_changed : Signal(Bool) = Signal(Bool).new
    @features_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @top_level_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @allowed_areas_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @visibility_changed_userdata : LibQt6::Handle = Pointer(Void).null

    getter features_changed : Signal(DockWidgetFeature)
    getter top_level_changed : Signal(Bool)
    getter allowed_areas_changed : Signal(DockArea)
    getter visibility_changed : Signal(Bool)

    # Creates a dock widget with optional title and parent.
    def initialize(title : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_dock_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @features_changed = Signal(DockWidgetFeature).new
      @top_level_changed = Signal(Bool).new
      @allowed_areas_changed = Signal(DockArea).new
      @visibility_changed = Signal(Bool).new
      @features_changed_userdata = Box.box(self)
      @top_level_changed_userdata = Box.box(self)
      @allowed_areas_changed_userdata = Box.box(self)
      @visibility_changed_userdata = Box.box(self)
      LibQt6.qt6cr_dock_widget_on_features_changed(to_unsafe, FEATURES_CHANGED_TRAMPOLINE, @features_changed_userdata)
      LibQt6.qt6cr_dock_widget_on_top_level_changed(to_unsafe, TOP_LEVEL_CHANGED_TRAMPOLINE, @top_level_changed_userdata)
      LibQt6.qt6cr_dock_widget_on_allowed_areas_changed(to_unsafe, ALLOWED_AREAS_CHANGED_TRAMPOLINE, @allowed_areas_changed_userdata)
      LibQt6.qt6cr_dock_widget_on_visibility_changed(to_unsafe, VISIBILITY_CHANGED_TRAMPOLINE, @visibility_changed_userdata)
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

    # Returns the custom title-bar widget, if present.
    def title_bar_widget : Widget?
      handle = LibQt6.qt6cr_dock_widget_title_bar_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Sets or clears the custom title-bar widget and returns it.
    def title_bar_widget=(widget : Widget?) : Widget?
      LibQt6.qt6cr_dock_widget_set_title_bar_widget(to_unsafe, widget.try(&.to_unsafe) || Pointer(Void).null)
      widget.try(&.adopt_by_parent!)
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

    # Returns the dock's current interaction and presentation features.
    def features : DockWidgetFeature
      DockWidgetFeature.from_value(LibQt6.qt6cr_dock_widget_features(to_unsafe))
    end

    # Sets the dock's interaction and presentation features.
    def features=(value : DockWidgetFeature) : DockWidgetFeature
      LibQt6.qt6cr_dock_widget_set_features(to_unsafe, value.value)
      value
    end

    # Returns the set of dock areas where the widget may be placed.
    def allowed_areas : DockArea
      DockArea.from_value(LibQt6.qt6cr_dock_widget_allowed_areas(to_unsafe))
    end

    # Sets the dock areas where the widget may be placed.
    def allowed_areas=(value : DockArea) : DockArea
      LibQt6.qt6cr_dock_widget_set_allowed_areas(to_unsafe, value.value)
      value
    end

    # Returns `true` when the given area is currently allowed.
    def area_allowed?(area : DockArea) : Bool
      LibQt6.qt6cr_dock_widget_is_area_allowed(to_unsafe, area.value)
    end

    # Returns the built-in visibility toggle action for this dock.
    def toggle_view_action : Action
      Action.wrap(LibQt6.qt6cr_dock_widget_toggle_view_action(to_unsafe))
    end

    # Registers a block to run when the dock features change.
    def on_features_changed(&block : DockWidgetFeature ->) : self
      @features_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the dock becomes floating or docked.
    def on_top_level_changed(&block : Bool ->) : self
      @top_level_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the allowed dock areas change.
    def on_allowed_areas_changed(&block : DockArea ->) : self
      @allowed_areas_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the dock visibility changes.
    def on_visibility_changed(&block : Bool ->) : self
      @visibility_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_features_changed(value : Int32) : Nil
      @features_changed.emit(DockWidgetFeature.from_value(value))
    end

    protected def emit_top_level_changed(value : Bool) : Nil
      @top_level_changed.emit(value)
    end

    protected def emit_allowed_areas_changed(value : Int32) : Nil
      @allowed_areas_changed.emit(DockArea.from_value(value))
    end

    protected def emit_visibility_changed(value : Bool) : Nil
      @visibility_changed.emit(value)
    end

    private FEATURES_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(DockWidget).unbox(userdata).emit_features_changed(value)
    end

    private TOP_LEVEL_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(DockWidget).unbox(userdata).emit_top_level_changed(value)
    end

    private ALLOWED_AREAS_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(DockWidget).unbox(userdata).emit_allowed_areas_changed(value)
    end

    private VISIBILITY_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(DockWidget).unbox(userdata).emit_visibility_changed(value)
    end
  end
end
