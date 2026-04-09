module Qt6
  class ActionGroup < QObject
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_action_group_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def add(action : Action) : Action
      LibQt6.qt6cr_action_group_add_action(to_unsafe, action.to_unsafe)
      action.adopt_by_parent!
      action
    end

    def <<(action : Action) : self
      add(action)
      self
    end

    def exclusive? : Bool
      LibQt6.qt6cr_action_group_is_exclusive(to_unsafe)
    end

    def exclusive=(value : Bool) : Bool
      LibQt6.qt6cr_action_group_set_exclusive(to_unsafe, value)
      value
    end
  end
end
