module Qt6
  # Wraps `QGraphicsAnchor`.
  class GraphicsAnchor < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the anchor spacing.
    def spacing : Float64
      LibQt6.qt6cr_graphics_anchor_spacing(to_unsafe)
    end

    # Sets the anchor spacing and returns it.
    def spacing=(value : Number) : Float64
      spacing = value.to_f64
      LibQt6.qt6cr_graphics_anchor_set_spacing(to_unsafe, spacing)
      spacing
    end

    # Clears any explicitly set spacing.
    def unset_spacing : self
      LibQt6.qt6cr_graphics_anchor_unset_spacing(to_unsafe)
      self
    end

    # Returns the anchor size policy.
    def size_policy : SizePolicy
      SizePolicy.from_value(LibQt6.qt6cr_graphics_anchor_size_policy(to_unsafe))
    end

    # Sets the anchor size policy and returns it.
    def size_policy=(value : SizePolicy) : SizePolicy
      LibQt6.qt6cr_graphics_anchor_set_size_policy(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `spacing=`.
    def set_spacing(value : Number) : self
      self.spacing = value
      self
    end

    # Qt-style alias for `size_policy=`.
    def set_size_policy(value : SizePolicy) : self
      self.size_policy = value
      self
    end
  end
end
