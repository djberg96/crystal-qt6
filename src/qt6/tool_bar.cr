module Qt6
  # Wraps `QToolBar`.
  class ToolBar < Widget
    # Creates a toolbar with optional title and parent.
    def initialize(title : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_tool_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe), parent.nil?)
    end

    # Adds an action to the toolbar and returns it.
    def add_action(action : Action) : Action
      LibQt6.qt6cr_tool_bar_add_action(to_unsafe, action.to_unsafe)
      action.adopt_by_parent!
      action
    end

    # Adds a separator to the toolbar.
    def add_separator : self
      LibQt6.qt6cr_tool_bar_add_separator(to_unsafe)
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

    # Appends an action to the toolbar and returns `self`.
    def <<(action : Action) : self
      add_action(action)
      self
    end
  end
end
