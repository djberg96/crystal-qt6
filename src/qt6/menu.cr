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

    # Appends an action to the menu and returns `self`.
    def <<(action : Action) : self
      add_action(action)
      self
    end
  end
end
