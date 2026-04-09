module Qt6
  # Groups related `Action` instances so Qt can coordinate their checked state.
  class ActionGroup < QObject
    # Creates an action group, optionally parented to another object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_action_group_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Adds an action to the group and returns it.
    def add(action : Action) : Action
      LibQt6.qt6cr_action_group_add_action(to_unsafe, action.to_unsafe)
      action.adopt_by_parent!
      action
    end

    # Appends an action to the group and returns `self`.
    def <<(action : Action) : self
      add(action)
      self
    end

    # Returns `true` when the group enforces a single checked action.
    def exclusive? : Bool
      LibQt6.qt6cr_action_group_is_exclusive(to_unsafe)
    end

    # Enables or disables exclusive checked-action behavior.
    def exclusive=(value : Bool) : Bool
      LibQt6.qt6cr_action_group_set_exclusive(to_unsafe, value)
      value
    end
  end
end
