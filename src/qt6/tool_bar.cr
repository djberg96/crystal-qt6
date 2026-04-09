module Qt6
  class ToolBar < Widget
    def initialize(title : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_tool_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe), parent.nil?)
    end

    def add_action(action : Action) : Action
      LibQt6.qt6cr_tool_bar_add_action(to_unsafe, action.to_unsafe)
      action.adopt_by_parent!
      action
    end

    def <<(action : Action) : self
      add_action(action)
      self
    end
  end
end
