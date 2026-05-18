module Qt6
  # Wraps `QSpacerItem`.
  class SpacerItem < LayoutItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = true) : self
      new(handle, owned)
    end

    # Creates a spacer with the given preferred size and size policies.
    def initialize(width : Int, height : Int, horizontal_policy : SizePolicy = SizePolicy::Minimum, vertical_policy : SizePolicy = SizePolicy::Minimum)
      super(LibQt6.qt6cr_spacer_item_create(width.to_i32, height.to_i32, horizontal_policy.value, vertical_policy.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the full size policy value for the spacer.
    def size_policy : SizePolicyValue
      SizePolicyValue.from_native(LibQt6.qt6cr_spacer_item_size_policy(to_unsafe))
    end

    # Returns the horizontal size policy for the spacer.
    def horizontal_size_policy : SizePolicy
      size_policy.horizontal_policy
    end

    # Returns the vertical size policy for the spacer.
    def vertical_size_policy : SizePolicy
      size_policy.vertical_policy
    end

    # Changes the preferred size and size policies for the spacer.
    def change_size(width : Int, height : Int, horizontal_policy : SizePolicy = SizePolicy::Minimum, vertical_policy : SizePolicy = SizePolicy::Minimum) : self
      LibQt6.qt6cr_spacer_item_change_size(to_unsafe, width.to_i32, height.to_i32, horizontal_policy.value, vertical_policy.value)
      self
    end
  end
end
