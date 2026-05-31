module Qt6
  # Value wrapper for `QTileRules`.
  struct TileRules
    property horizontal : TileRule
    property vertical : TileRule

    def initialize(@horizontal : TileRule, @vertical : TileRule)
    end

    def initialize(rule : TileRule = TileRule::StretchTile)
      @horizontal = rule
      @vertical = rule
    end

    def self.from_native(value : LibQt6::TileRulesValue) : self
      new(
        TileRule.from_value(value.horizontal),
        TileRule.from_value(value.vertical)
      )
    end

    def to_native : LibQt6::TileRulesValue
      LibQt6::TileRulesValue.new(
        horizontal: horizontal.value,
        vertical: vertical.value
      )
    end
  end
end
