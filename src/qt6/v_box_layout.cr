module Qt6
  # Wraps `QVBoxLayout`.
  class VBoxLayout < BoxLayout
    def self.wrap(handle : LibQt6::Handle) : self
      new(handle)
    end

    # Creates a vertical layout attached to the given parent widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_v_box_layout_create(parent.try(&.to_unsafe) || Pointer(Void).null))
    end

    protected def initialize(handle : LibQt6::Handle)
      super(handle)
    end
  end
end
