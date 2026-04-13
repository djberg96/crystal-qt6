module Qt6
  record ModelIndexSpec, row : Int32, column : Int32, internal_id : UInt64 do
    def self.to_native(value : self?) : LibQt6::ModelIndexSpecValue
      if value
        LibQt6::ModelIndexSpecValue.new(valid: true, row: value.row, column: value.column, internal_id: value.internal_id)
      else
        LibQt6::ModelIndexSpecValue.new(valid: false, row: -1, column: -1, internal_id: 0_u64)
      end
    end
  end
end
