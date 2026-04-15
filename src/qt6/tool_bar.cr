module Qt6
  # Wraps `QToolBar`.
  class ToolBar < Widget
    # Creates a toolbar with optional title and parent.
    def initialize(title : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_tool_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe), parent.nil?)
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

    # Returns the built-in visibility toggle action for this toolbar.
    def toggle_view_action : Action
      Action.wrap(LibQt6.qt6cr_tool_bar_toggle_view_action(to_unsafe))
    end

    # Appends an action to the toolbar and returns `self`.
    def <<(action : Action) : self
      add_action(action)
      self
    end
  end
end
