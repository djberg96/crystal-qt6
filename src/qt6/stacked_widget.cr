module Qt6
  # Wraps `QStackedWidget`.
  class StackedWidget < Frame
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a stacked widget with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_stacked_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Adds a page widget and returns it.
    def add_widget(widget : Widget) : Widget
      LibQt6.qt6cr_stacked_widget_add_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Returns the page widget at the given index, if present.
    def widget(index : Int) : Widget?
      handle = LibQt6.qt6cr_stacked_widget_widget(to_unsafe, index.to_i32)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Appends a page widget and returns `self`.
    def <<(widget : Widget) : self
      add_widget(widget)
      self
    end

    # Returns the number of pages.
    def count : Int32
      LibQt6.qt6cr_stacked_widget_count(to_unsafe)
    end

    # Returns the selected page index.
    def current_index : Int32
      LibQt6.qt6cr_stacked_widget_current_index(to_unsafe)
    end

    # Changes the selected page index and returns the assigned value.
    def current_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_stacked_widget_set_current_index(to_unsafe, int_value)
      int_value
    end

    # Returns the currently selected page widget, if present.
    def current_widget : Widget?
      handle = LibQt6.qt6cr_stacked_widget_current_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Changes the selected page widget and returns it.
    def current_widget=(widget : Widget) : Widget
      LibQt6.qt6cr_stacked_widget_set_current_widget(to_unsafe, widget.to_unsafe)
      widget
    end

    # Returns the index of the given page widget, or `-1` when absent.
    def index_of(widget : Widget) : Int32
      LibQt6.qt6cr_stacked_widget_index_of(to_unsafe, widget.to_unsafe)
    end

    # Removes the given page widget from the stack.
    def remove_widget(widget : Widget) : self
      LibQt6.qt6cr_stacked_widget_remove_widget(to_unsafe, widget.to_unsafe)
      self
    end

    # Qt-style alias for selecting the current page widget.
    def set_current_widget(widget : Widget) : self
      self.current_widget = widget
      self
    end
  end
end
