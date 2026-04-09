module Qt6
  class Widget < QObject
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def window_title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_window_title(@to_unsafe))
    end

    def window_title=(value : String) : String
      LibQt6.qt6cr_widget_set_window_title(@to_unsafe, value.to_unsafe)
      value
    end

    def resize(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_resize(@to_unsafe, width, height)
      self
    end

    def show : self
      LibQt6.qt6cr_widget_show(@to_unsafe)
      self
    end

    def close : self
      LibQt6.qt6cr_widget_close(@to_unsafe)
      self
    end

    def visible? : Bool
      LibQt6.qt6cr_widget_is_visible(@to_unsafe)
    end

    def size : Size
      Size.from_native(LibQt6.qt6cr_widget_size(@to_unsafe))
    end

    def rect : RectF
      RectF.from_native(LibQt6.qt6cr_widget_rect(@to_unsafe))
    end

    def update : self
      LibQt6.qt6cr_widget_update(@to_unsafe)
      self
    end

    def vbox(&block : VBoxLayout ->)
      layout = VBoxLayout.new(self)
      yield layout
      layout
    end

    def adopt_by_parent! : Nil
      Qt6.untrack_object(self) if @owned
      @owned = false
    end
  end
end
