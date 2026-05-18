module Qt6
  # Value wrapper for `QSizePolicy`.
  struct SizePolicyValue
    property horizontal_policy : SizePolicy
    property vertical_policy : SizePolicy
    property control_type : SizePolicyControlType
    property height_for_width : Bool
    property width_for_height : Bool
    property horizontal_stretch : Int32
    property vertical_stretch : Int32
    property retain_size_when_hidden : Bool

    def initialize(
      @horizontal_policy : SizePolicy = SizePolicy::Preferred,
      @vertical_policy : SizePolicy = SizePolicy::Preferred,
      @control_type : SizePolicyControlType = SizePolicyControlType::DefaultType,
      @height_for_width : Bool = false,
      @width_for_height : Bool = false,
      horizontal_stretch : Int = 0,
      vertical_stretch : Int = 0,
      @retain_size_when_hidden : Bool = false
    )
      @horizontal_stretch = clamp_stretch(horizontal_stretch)
      @vertical_stretch = clamp_stretch(vertical_stretch)
    end

    def self.from_native(value : LibQt6::SizePolicyStructValue) : self
      new(
        SizePolicy.from_value(value.horizontal_policy),
        SizePolicy.from_value(value.vertical_policy),
        SizePolicyControlType.from_value(value.control_type),
        value.height_for_width,
        value.width_for_height,
        value.horizontal_stretch,
        value.vertical_stretch,
        value.retain_size_when_hidden
      )
    end

    def to_native : LibQt6::SizePolicyStructValue
      LibQt6::SizePolicyStructValue.new(
        horizontal_policy: horizontal_policy.value,
        vertical_policy: vertical_policy.value,
        control_type: control_type.value,
        height_for_width: height_for_width,
        width_for_height: width_for_height,
        horizontal_stretch: horizontal_stretch,
        vertical_stretch: vertical_stretch,
        retain_size_when_hidden: retain_size_when_hidden
      )
    end

    def horizontal_stretch=(value : Int) : Int32
      @horizontal_stretch = clamp_stretch(value)
    end

    def vertical_stretch=(value : Int) : Int32
      @vertical_stretch = clamp_stretch(value)
    end

    def horizontal_expanding? : Bool
      horizontal_policy.expand?
    end

    def vertical_expanding? : Bool
      vertical_policy.expand?
    end

    # Returns a new value with horizontal and vertical policies and stretch factors swapped.
    # `height_for_width` and `width_for_height` intentionally remain unchanged to match Qt.
    def transposed : self
      self.class.new(
        vertical_policy,
        horizontal_policy,
        control_type,
        height_for_width,
        width_for_height,
        vertical_stretch,
        horizontal_stretch,
        retain_size_when_hidden
      )
    end

    # Qt-style alias for `transposed`.
    def transpose : self
      transposed
    end

    private def clamp_stretch(value : Int) : Int32
      value.clamp(0, 255).to_i32
    end
  end
end
