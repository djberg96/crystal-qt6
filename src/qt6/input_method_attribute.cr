module Qt6
  record InputMethodAttribute, type : InputMethodAttributeType, start : Int32, length : Int32, value : ModelData = nil do
    def self.from_native(value : LibQt6::InputMethodAttributeValue) : self
      new(
        InputMethodAttributeType.from_value(value.type),
        value.start,
        value.length,
        Qt6.model_data_from_native(value.value)
      )
    end

    def to_native : LibQt6::InputMethodAttributeValue
      LibQt6::InputMethodAttributeValue.new(
        type: type.value,
        start: start,
        length: length,
        value: Qt6.model_data_to_native(value)
      )
    end
  end
end
