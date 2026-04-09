module Qt6
  # Wraps a generic `QWidget`.
  class Widget < QObject
    # Creates a widget, optionally parented to another widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current window title.
    def window_title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_window_title(@to_unsafe))
    end

    # Sets the window title and returns the assigned value.
    def window_title=(value : String) : String
      LibQt6.qt6cr_widget_set_window_title(@to_unsafe, value.to_unsafe)
      value
    end

    # Resizes the widget and returns `self` for chaining.
    def resize(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_resize(@to_unsafe, width, height)
      self
    end

    # Shows the widget and returns `self` for chaining.
    def show : self
      LibQt6.qt6cr_widget_show(@to_unsafe)
      self
    end

    # Closes the widget and returns `self` for chaining.
    def close : self
      LibQt6.qt6cr_widget_close(@to_unsafe)
      self
    end

    # Returns `true` when Qt considers the widget visible.
    def visible? : Bool
      LibQt6.qt6cr_widget_is_visible(@to_unsafe)
    end

    # Returns the widget's current size.
    def size : Size
      Size.from_native(LibQt6.qt6cr_widget_size(@to_unsafe))
    end

    # Returns the widget's local rectangle.
    def rect : RectF
      RectF.from_native(LibQt6.qt6cr_widget_rect(@to_unsafe))
    end

    # Schedules the widget for repaint and returns `self`.
    def update : self
      LibQt6.qt6cr_widget_update(@to_unsafe)
      self
    end

    # Captures the widget's current contents into a pixmap.
    def grab : QPixmap
      QPixmap.new(LibQt6.qt6cr_widget_grab(@to_unsafe), true)
    end

    # Creates a `VBoxLayout`, yields it for configuration, and returns it.
    def vbox(&block : VBoxLayout ->)
      layout = VBoxLayout.new(self)
      yield layout
      layout
    end

    # Creates an `HBoxLayout`, yields it for configuration, and returns it.
    def hbox(&block : HBoxLayout ->)
      layout = HBoxLayout.new(self)
      yield layout
      layout
    end

    # Creates a `GridLayout`, yields it for configuration, and returns it.
    def grid(&block : GridLayout ->)
      layout = GridLayout.new(self)
      yield layout
      layout
    end

    # Creates a `FormLayout`, yields it for configuration, and returns it.
    def form(&block : FormLayout ->)
      layout = FormLayout.new(self)
      yield layout
      layout
    end

    # Stops tracking this widget as independently owned because a Qt parent now
    # controls its lifetime.
    def adopt_by_parent! : Nil
      Qt6.untrack_object(self) if @owned
      @owned = false
    end
  end
end
