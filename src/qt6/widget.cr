module Qt6
  # Wraps a generic `QWidget`.
  class Widget < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

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

    # Hides the widget and returns `self` for chaining.
    def hide : self
      LibQt6.qt6cr_widget_hide(@to_unsafe)
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

    # Shows or hides the widget.
    def visible=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_visible(@to_unsafe, value)
      value
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

    # Returns the widget's style sheet.
    def style_sheet : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_style_sheet(@to_unsafe))
    end

    # Sets the widget's style sheet.
    def style_sheet=(value : String) : String
      LibQt6.qt6cr_widget_set_style_sheet(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget's tooltip text.
    def tool_tip : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_widget_tool_tip(@to_unsafe))
    end

    # Sets the widget's tooltip text.
    def tool_tip=(value : String) : String
      LibQt6.qt6cr_widget_set_tool_tip(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns the widget's current window icon.
    def window_icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_widget_window_icon(@to_unsafe), true)
    end

    # Sets the widget's window icon.
    def window_icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_widget_set_window_icon(@to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the widget accepts input.
    def enabled? : Bool
      LibQt6.qt6cr_widget_is_enabled(@to_unsafe)
    end

    # Enables or disables the widget.
    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_enabled(@to_unsafe, value)
      value
    end

    # Returns `true` when the widget currently owns keyboard focus.
    def has_focus? : Bool
      LibQt6.qt6cr_widget_has_focus(@to_unsafe)
    end

    # Returns the widget's focus policy.
    def focus_policy : FocusPolicy
      FocusPolicy.from_value(LibQt6.qt6cr_widget_focus_policy(@to_unsafe))
    end

    # Sets the widget's focus policy.
    def focus_policy=(value : FocusPolicy) : FocusPolicy
      LibQt6.qt6cr_widget_set_focus_policy(@to_unsafe, value.value)
      value
    end

    # Gives the widget keyboard focus.
    def set_focus : self
      LibQt6.qt6cr_widget_set_focus(@to_unsafe)
      self
    end

    # Clears keyboard focus from the widget.
    def clear_focus : self
      LibQt6.qt6cr_widget_clear_focus(@to_unsafe)
      self
    end

    # Moves the widget to the given parent-relative position and returns `self`.
    def move(x : Int, y : Int) : self
      LibQt6.qt6cr_widget_move(@to_unsafe, x, y)
      self
    end

    # Recomputes the widget size from its contents and returns `self`.
    def adjust_size : self
      LibQt6.qt6cr_widget_adjust_size(@to_unsafe)
      self
    end

    # Raises the widget above overlapping siblings and returns `self`.
    def raise_to_front : self
      LibQt6.qt6cr_widget_raise_to_front(@to_unsafe)
      self
    end

    # Locks the widget width and returns the assigned value.
    def fixed_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_widget_set_fixed_width(@to_unsafe, int_value)
      int_value
    end

    # Locks the widget height and returns the assigned value.
    def fixed_height=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_widget_set_fixed_height(@to_unsafe, int_value)
      int_value
    end

    # Locks the widget to a fixed size and returns `self`.
    def set_fixed_size(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_set_fixed_size(@to_unsafe, width, height)
      self
    end

    # Sends a synthetic wheel event to the widget.
    def simulate_wheel(position : PointF, pixel_delta : PointF = PointF.new(0.0, 0.0), angle_delta : PointF = PointF.new(0.0, 120.0), buttons : Int = 0, modifiers : Int = 0) : self
      LibQt6.qt6cr_widget_simulate_wheel(@to_unsafe, position.to_native, pixel_delta.to_native, angle_delta.to_native, buttons, modifiers)
      self
    end

    # Returns the widget's horizontal size policy.
    def horizontal_size_policy : SizePolicy
      SizePolicy.from_value(LibQt6.qt6cr_widget_horizontal_size_policy(@to_unsafe))
    end

    # Returns the widget's vertical size policy.
    def vertical_size_policy : SizePolicy
      SizePolicy.from_value(LibQt6.qt6cr_widget_vertical_size_policy(@to_unsafe))
    end

    # Sets both size policies and returns `self`.
    def set_size_policy(horizontal : SizePolicy, vertical : SizePolicy) : self
      LibQt6.qt6cr_widget_set_size_policy(@to_unsafe, horizontal.value, vertical.value)
      self
    end

    # Returns the widget's minimum size.
    def minimum_size : Size
      Size.from_native(LibQt6.qt6cr_widget_minimum_size(@to_unsafe))
    end

    # Sets the widget's minimum size.
    def set_minimum_size(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_set_minimum_size(@to_unsafe, width, height)
      self
    end

    # Returns the widget's minimum width.
    def minimum_width : Int32
      LibQt6.qt6cr_widget_minimum_width(@to_unsafe)
    end

    # Sets the widget's minimum width.
    def minimum_width=(value : Int) : Int32
      LibQt6.qt6cr_widget_set_minimum_width(@to_unsafe, value)
      value.to_i
    end

    # Returns the widget's minimum height.
    def minimum_height : Int32
      LibQt6.qt6cr_widget_minimum_height(@to_unsafe)
    end

    # Sets the widget's minimum height.
    def minimum_height=(value : Int) : Int32
      LibQt6.qt6cr_widget_set_minimum_height(@to_unsafe, value)
      value.to_i
    end

    # Returns the widget's maximum size.
    def maximum_size : Size
      Size.from_native(LibQt6.qt6cr_widget_maximum_size(@to_unsafe))
    end

    # Sets the widget's maximum size.
    def set_maximum_size(width : Int, height : Int) : self
      LibQt6.qt6cr_widget_set_maximum_size(@to_unsafe, width, height)
      self
    end

    # Returns the widget's maximum width.
    def maximum_width : Int32
      LibQt6.qt6cr_widget_maximum_width(@to_unsafe)
    end

    # Sets the widget's maximum width.
    def maximum_width=(value : Int) : Int32
      LibQt6.qt6cr_widget_set_maximum_width(@to_unsafe, value)
      value.to_i
    end

    # Returns the widget's maximum height.
    def maximum_height : Int32
      LibQt6.qt6cr_widget_maximum_height(@to_unsafe)
    end

    # Sets the widget's maximum height.
    def maximum_height=(value : Int) : Int32
      LibQt6.qt6cr_widget_set_maximum_height(@to_unsafe, value)
      value.to_i
    end

    # Returns `true` when the widget accepts drops.
    def accept_drops? : Bool
      LibQt6.qt6cr_widget_accept_drops(@to_unsafe)
    end

    # Enables or disables drop acceptance.
    def accept_drops=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_accept_drops(@to_unsafe, value)
      value
    end

    # Returns `true` when mouse move events are delivered without a pressed button.
    def mouse_tracking? : Bool
      LibQt6.qt6cr_widget_mouse_tracking(@to_unsafe)
    end

    # Enables or disables mouse tracking.
    def mouse_tracking=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_mouse_tracking(@to_unsafe, value)
      value
    end

    # Returns the widget's cursor shape.
    def cursor_shape : CursorShape
      CursorShape.from_value(LibQt6.qt6cr_widget_cursor_shape(@to_unsafe))
    end

    # Sets the widget's cursor shape.
    def cursor_shape=(value : CursorShape) : CursorShape
      LibQt6.qt6cr_widget_set_cursor_shape(@to_unsafe, value.value)
      value
    end

    # Returns `true` when mouse events pass through this widget to widgets below.
    def transparent_for_mouse_events? : Bool
      LibQt6.qt6cr_widget_transparent_for_mouse_events(@to_unsafe)
    end

    # Enables or disables transparent-for-mouse-events behavior.
    def transparent_for_mouse_events=(value : Bool) : Bool
      LibQt6.qt6cr_widget_set_transparent_for_mouse_events(@to_unsafe, value)
      value
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
      @owned = false
    end
  end
end
