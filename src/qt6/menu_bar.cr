module Qt6
  class MenuBar < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def add_menu(title : String) : Menu
      Menu.wrap(LibQt6.qt6cr_menu_bar_add_menu(to_unsafe, title.to_unsafe))
    end
  end
end
