module Qt6
  class Menu < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_menu_title(to_unsafe))
    end

    def title=(value : String) : String
      LibQt6.qt6cr_menu_set_title(to_unsafe, value.to_unsafe)
      value
    end

    def add_menu(title : String) : Menu
      Menu.wrap(LibQt6.qt6cr_menu_add_menu(to_unsafe, title.to_unsafe))
    end

    def add_action(action : Action) : Action
      LibQt6.qt6cr_menu_add_action(to_unsafe, action.to_unsafe)
      action.adopt_by_parent!
      action
    end

    def add_separator : self
      LibQt6.qt6cr_menu_add_separator(to_unsafe)
      self
    end

    def <<(action : Action) : self
      add_action(action)
      self
    end
  end
end
