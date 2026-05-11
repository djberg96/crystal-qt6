module Qt6
  # Wraps `QMenu`.
  class Menu < Widget
    # Creates a standalone menu with an optional title and parent.
    def initialize(title : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_menu_create(parent.try(&.to_unsafe) || Pointer(Void).null, title.to_unsafe), parent.nil?)
    end

    # Wraps an existing native menu handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the menu title.
    def title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_menu_title(to_unsafe))
    end

    # Sets the menu title and returns the assigned value.
    def title=(value : String) : String
      LibQt6.qt6cr_menu_set_title(to_unsafe, value.to_unsafe)
      value
    end

    # Creates and returns a submenu with the given title.
    def add_menu(title : String) : Menu
      Menu.wrap(LibQt6.qt6cr_menu_add_menu(to_unsafe, title.to_unsafe))
    end

    # Adds an existing submenu and returns it.
    def add_menu(menu : Menu) : Menu
      LibQt6.qt6cr_menu_add_existing_menu(to_unsafe, menu.to_unsafe)
      menu.adopt_by_parent!
      menu
    end

    # Creates a menu-owned action with the given text and returns it.
    def add_action(text : String) : Action
      Action.wrap(LibQt6.qt6cr_menu_add_text_action(to_unsafe, text.to_unsafe))
    end

    # Adds an action to the menu and returns it.
    def add_action(action : Action) : Action
      LibQt6.qt6cr_menu_add_action(to_unsafe, action.to_unsafe)
      action.adopt_by_parent!
      action
    end

    # Returns the current actions, including submenu actions.
    def actions : Array(Action)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_menu_actions(to_unsafe)).map do |handle|
        Action.wrap(handle)
      end
    end

    # Returns the currently active action, if any.
    def active_action : Action?
      handle = LibQt6.qt6cr_menu_active_action(to_unsafe)
      handle.null? ? nil : Action.wrap(handle)
    end

    # Sets the active action and returns it.
    def active_action=(action : Action?) : Action?
      LibQt6.qt6cr_menu_set_active_action(to_unsafe, action.try(&.to_unsafe) || Pointer(Void).null)
      action
    end

    # Returns the default action, if any.
    def default_action : Action?
      handle = LibQt6.qt6cr_menu_default_action(to_unsafe)
      handle.null? ? nil : Action.wrap(handle)
    end

    # Sets the default action and returns it.
    def default_action=(action : Action?) : Action?
      LibQt6.qt6cr_menu_set_default_action(to_unsafe, action.try(&.to_unsafe) || Pointer(Void).null)
      action
    end

    # Adds a separator to the menu.
    def add_separator : self
      LibQt6.qt6cr_menu_add_separator(to_unsafe)
      self
    end

    # Removes all actions from the menu.
    def clear : self
      LibQt6.qt6cr_menu_clear(to_unsafe)
      self
    end

    # Returns the action representing this menu in its parent container.
    def menu_action : Action
      Action.wrap(LibQt6.qt6cr_menu_menu_action(to_unsafe))
    end

    # Opens the menu at a position local to the given widget.
    def exec_at(widget : Widget, position : PointF) : self
      LibQt6.qt6cr_menu_exec_at(to_unsafe, widget.to_unsafe, position.to_native)
      self
    end

    # Qt-style alias for `active_action=`.
    def set_active_action(action : Action?) : self
      self.active_action = action
      self
    end

    # Qt-style alias for `default_action=`.
    def set_default_action(action : Action?) : self
      self.default_action = action
      self
    end

    # Appends an action to the menu and returns `self`.
    def <<(action : Action) : self
      add_action(action)
      self
    end
  end
end
