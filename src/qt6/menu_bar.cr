module Qt6
  # Wraps `QMenuBar`.
  class MenuBar < Widget
    # Creates a standalone menu bar with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_menu_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Wraps an existing native menu-bar handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Adds a top-level menu and returns it.
    def add_menu(title : String) : Menu
      Menu.wrap(LibQt6.qt6cr_menu_bar_add_menu(to_unsafe, title.to_unsafe))
    end

    # Adds an existing menu and returns it.
    def add_menu(menu : Menu) : Menu
      LibQt6.qt6cr_menu_bar_add_existing_menu(to_unsafe, menu.to_unsafe)
      menu.adopt_by_parent!
      menu
    end

    # Creates a menu-bar-owned action with the given text and returns it.
    def add_action(text : String) : Action
      Action.wrap(LibQt6.qt6cr_menu_bar_add_text_action(to_unsafe, text.to_unsafe))
    end

    # Adds an existing action to the menu bar and returns it.
    def add_action(action : Action) : Action
      LibQt6.qt6cr_menu_bar_add_action(to_unsafe, action.to_unsafe)
      action.adopt_by_parent!
      action
    end

    # Returns the current top-level actions.
    def actions : Array(Action)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_menu_bar_actions(to_unsafe)).map do |handle|
        Action.wrap(handle)
      end
    end

    # Returns the currently active action, if any.
    def active_action : Action?
      handle = LibQt6.qt6cr_menu_bar_active_action(to_unsafe)
      handle.null? ? nil : Action.wrap(handle)
    end

    # Sets the active action and returns it.
    def active_action=(action : Action?) : Action?
      LibQt6.qt6cr_menu_bar_set_active_action(to_unsafe, action.try(&.to_unsafe) || Pointer(Void).null)
      action
    end

    # Removes all menus from the menu bar.
    def clear : self
      LibQt6.qt6cr_menu_bar_clear(to_unsafe)
      self
    end

    # Appends an action to the menu bar and returns `self`.
    def <<(action : Action) : self
      add_action(action)
      self
    end

    # Qt-style alias for `active_action=`.
    def set_active_action(action : Action?) : self
      self.active_action = action
      self
    end
  end
end
