module Qt6
  record TableWidgetSelectionRange,
    top_row : Int32,
    left_column : Int32,
    bottom_row : Int32,
    right_column : Int32 do
    def self.from_native(value : LibQt6::TableWidgetSelectionRangeValue) : self
      new(value.top_row, value.left_column, value.bottom_row, value.right_column)
    end

    def to_native : LibQt6::TableWidgetSelectionRangeValue
      LibQt6::TableWidgetSelectionRangeValue.new(
        top_row: top_row,
        left_column: left_column,
        bottom_row: bottom_row,
        right_column: right_column
      )
    end

    def row_count : Int32
      bottom_row - top_row + 1
    end

    def column_count : Int32
      right_column - left_column + 1
    end
  end
end
