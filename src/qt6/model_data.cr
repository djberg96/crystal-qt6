module Qt6
  alias ModelData = String | Int32 | Float64 | Bool | Color | Nil

  def self.normalize_model_data(value : Nil) : ModelData
    nil
  end

  def self.normalize_model_data(value : String) : ModelData
    value
  end

  def self.normalize_model_data(value : Bool) : ModelData
    value
  end

  def self.normalize_model_data(value : Color) : ModelData
    value
  end

  def self.normalize_model_data(value : Float32) : ModelData
    value.to_f64
  end

  def self.normalize_model_data(value : Float64) : ModelData
    value
  end

  def self.normalize_model_data(value : Int) : ModelData
    value.to_i32
  end

  def self.model_data_to_native(value) : LibQt6::VariantValue
    normalized = normalize_model_data(value)

    case normalized
    when Nil
      LibQt6::VariantValue.new(
        type: 0,
        bool_value: false,
        int_value: 0,
        double_value: 0.0,
        color_value: LibQt6::ColorValue.new(red: 0, green: 0, blue: 0, alpha: 0),
        string_value: Pointer(UInt8).null
      )
    when String
      LibQt6::VariantValue.new(
        type: 1,
        bool_value: false,
        int_value: 0,
        double_value: 0.0,
        color_value: LibQt6::ColorValue.new(red: 0, green: 0, blue: 0, alpha: 0),
        string_value: normalized.to_unsafe
      )
    when Bool
      LibQt6::VariantValue.new(
        type: 2,
        bool_value: normalized,
        int_value: 0,
        double_value: 0.0,
        color_value: LibQt6::ColorValue.new(red: 0, green: 0, blue: 0, alpha: 0),
        string_value: Pointer(UInt8).null
      )
    when Int32
      LibQt6::VariantValue.new(
        type: 3,
        bool_value: false,
        int_value: normalized,
        double_value: 0.0,
        color_value: LibQt6::ColorValue.new(red: 0, green: 0, blue: 0, alpha: 0),
        string_value: Pointer(UInt8).null
      )
    when Float64
      LibQt6::VariantValue.new(
        type: 4,
        bool_value: false,
        int_value: 0,
        double_value: normalized,
        color_value: LibQt6::ColorValue.new(red: 0, green: 0, blue: 0, alpha: 0),
        string_value: Pointer(UInt8).null
      )
    when Color
      LibQt6::VariantValue.new(
        type: 5,
        bool_value: false,
        int_value: 0,
        double_value: 0.0,
        color_value: normalized.to_native,
        string_value: Pointer(UInt8).null
      )
    else
      LibQt6::VariantValue.new(
        type: 0,
        bool_value: false,
        int_value: 0,
        double_value: 0.0,
        color_value: LibQt6::ColorValue.new(red: 0, green: 0, blue: 0, alpha: 0),
        string_value: Pointer(UInt8).null
      )
    end
  end

  def self.model_data_from_native(value : LibQt6::VariantValue) : ModelData
    case value.type
    when 1
      copy_and_release_string(value.string_value)
    when 2
      value.bool_value
    when 3
      value.int_value
    when 4
      value.double_value
    when 5
      Color.from_native(value.color_value)
    else
      nil
    end
  end
end