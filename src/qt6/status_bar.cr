module Qt6
  # Wraps `QStatusBar`.
  class StatusBar < Widget
    # Wraps an existing native status-bar handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a status bar with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_status_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Shows a status-bar message.
    #
    # `timeout` is expressed in milliseconds; `0` keeps the message until it is
    # replaced or cleared.
    def show_message(message : String, timeout : Int = 0) : self
      LibQt6.qt6cr_status_bar_show_message(to_unsafe, message.to_unsafe, timeout)
      self
    end

    # Returns the current status-bar message.
    def current_message : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_status_bar_current_message(to_unsafe))
    end

    # Clears the current status-bar message.
    def clear_message : self
      LibQt6.qt6cr_status_bar_clear_message(to_unsafe)
      self
    end

    # Adds a temporary widget to the status bar and returns it.
    def add_widget(widget : Widget, stretch : Int = 0) : Widget
      LibQt6.qt6cr_status_bar_add_widget(to_unsafe, widget.to_unsafe, stretch.to_i32)
      widget.adopt_by_parent!
      widget
    end

    # Adds a permanent widget aligned to the right side of the status bar.
    def add_permanent_widget(widget : Widget, stretch : Int = 0) : Widget
      LibQt6.qt6cr_status_bar_add_permanent_widget(to_unsafe, widget.to_unsafe, stretch.to_i32)
      widget.adopt_by_parent!
      widget
    end

    # Removes a widget from the status bar and returns it.
    def remove_widget(widget : Widget) : Widget
      LibQt6.qt6cr_status_bar_remove_widget(to_unsafe, widget.to_unsafe)
      widget
    end

    # Returns `true` when the status bar shows a resize grip.
    def size_grip_enabled? : Bool
      LibQt6.qt6cr_status_bar_is_size_grip_enabled(to_unsafe)
    end

    # Enables or disables the resize grip.
    def size_grip_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_status_bar_set_size_grip_enabled(to_unsafe, value)
      value
    end
  end
end
