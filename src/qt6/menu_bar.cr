module Qt6
  # Wraps `QMenuBar`.
  class MenuBar < Widget
    # Wraps an existing native menu-bar handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Adds a top-level menu and returns it.
    def add_menu(title : String) : Menu
      Menu.wrap(LibQt6.qt6cr_menu_bar_add_menu(to_unsafe, title.to_unsafe))
    end

    # Removes all menus from the menu bar.
    def clear : self
      LibQt6.qt6cr_menu_bar_clear(to_unsafe)
      self
    end
  end
end
