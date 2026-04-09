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

    # Appends an action to the toolbar and returns `self`.
    def <<(action : Action) : self
      add_action(action)
      self
    end
  end
end
