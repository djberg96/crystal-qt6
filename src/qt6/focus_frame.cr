module Qt6
  # Wraps `QFocusFrame`.
  class FocusFrame < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a focus frame with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_focus_frame_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the widget currently tracked by the focus frame, if any.
    def widget : Widget?
      handle = LibQt6.qt6cr_focus_frame_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Sets or clears the tracked widget and returns it.
    def widget=(value : Widget?) : Widget?
      LibQt6.qt6cr_focus_frame_set_widget(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end
  end
end
