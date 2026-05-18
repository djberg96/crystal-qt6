module Qt6
  # Wraps `QStatusBar`.
  class StatusBar < Widget
    @message_changed : Signal(String) = Signal(String).new
    @message_changed_userdata : LibQt6::Handle = Pointer(Void).null

    getter message_changed : Signal(String)

    # Wraps an existing native status-bar handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a status bar with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_status_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_message_callback
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_message_callback
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

    # Inserts a temporary widget and returns its assigned index.
    def insert_widget(index : Int, widget : Widget, stretch : Int = 0) : Int32
      value = LibQt6.qt6cr_status_bar_insert_widget(to_unsafe, index.to_i32, widget.to_unsafe, stretch.to_i32)
      widget.adopt_by_parent!
      value
    end

    # Adds a permanent widget aligned to the right side of the status bar.
    def add_permanent_widget(widget : Widget, stretch : Int = 0) : Widget
      LibQt6.qt6cr_status_bar_add_permanent_widget(to_unsafe, widget.to_unsafe, stretch.to_i32)
      widget.adopt_by_parent!
      widget
    end

    # Inserts a permanent widget aligned to the right side and returns its assigned index.
    def insert_permanent_widget(index : Int, widget : Widget, stretch : Int = 0) : Int32
      value = LibQt6.qt6cr_status_bar_insert_permanent_widget(to_unsafe, index.to_i32, widget.to_unsafe, stretch.to_i32)
      widget.adopt_by_parent!
      value
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

    # Qt-style alias for `show_message`.
    def set_message(message : String, timeout : Int = 0) : self
      show_message(message, timeout)
    end

    # Qt-style alias for `size_grip_enabled=`.
    def set_size_grip_enabled(value : Bool) : self
      self.size_grip_enabled = value
      self
    end

    # Registers a block to run when the shown message changes.
    def on_message_changed(&block : String ->) : self
      @message_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_message_changed(message : UInt8*) : Nil
      @message_changed.emit(Qt6.copy_string(message))
    end

    private def register_message_callback : Nil
      @message_changed = Signal(String).new
      @message_changed_userdata = Box.box(self)
      LibQt6.qt6cr_status_bar_on_message_changed(to_unsafe, MESSAGE_CHANGED_TRAMPOLINE, @message_changed_userdata)
    end

    private MESSAGE_CHANGED_TRAMPOLINE = ->(userdata : Void*, message : UInt8*) do
      Box(StatusBar).unbox(userdata).emit_message_changed(message)
    end
  end
end
