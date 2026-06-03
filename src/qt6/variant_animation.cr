module Qt6
  # Wraps `QVariantAnimation`.
  class VariantAnimation < AbstractAnimation
    @value_changed : Signal(ModelData) = Signal(ModelData).new
    @variant_callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter value_changed : Signal(ModelData)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_variant_animation_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_variant_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_variant_callbacks
    end

    def start_value : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_variant_animation_start_value(to_unsafe))
    end

    def start_value=(value) : ModelData
      normalized = Qt6.normalize_model_data(value)
      LibQt6.qt6cr_variant_animation_set_start_value(to_unsafe, Qt6.model_data_to_native(normalized))
      normalized
    end

    def end_value : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_variant_animation_end_value(to_unsafe))
    end

    def end_value=(value) : ModelData
      normalized = Qt6.normalize_model_data(value)
      LibQt6.qt6cr_variant_animation_set_end_value(to_unsafe, Qt6.model_data_to_native(normalized))
      normalized
    end

    def key_value_at(step : Number) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_variant_animation_key_value_at(to_unsafe, step.to_f64))
    end

    def set_key_value_at(step : Number, value) : self
      LibQt6.qt6cr_variant_animation_set_key_value_at(to_unsafe, step.to_f64, Qt6.model_data_to_native(value))
      self
    end

    def key_values : Array(AnimationKeyValue)
      count = LibQt6.qt6cr_variant_animation_key_value_count(to_unsafe)
      Array(AnimationKeyValue).new(count) do |index|
        AnimationKeyValue.new(
          LibQt6.qt6cr_variant_animation_key_value_step_at(to_unsafe, index),
          Qt6.model_data_from_native(LibQt6.qt6cr_variant_animation_key_value_value_at(to_unsafe, index))
        )
      end
    end

    def key_values=(values : Enumerable(AnimationKeyValue)) : Array(AnimationKeyValue)
      entries = values.to_a
      steps = entries.map(&.step)
      native_values = entries.map { |entry| Qt6.model_data_to_native(entry.value) }
      LibQt6.qt6cr_variant_animation_set_key_values(
        to_unsafe,
        steps.empty? ? Pointer(Float64).null : steps.to_unsafe,
        native_values.empty? ? Pointer(LibQt6::VariantValue).null : native_values.to_unsafe,
        entries.size.to_i32
      )
      entries
    end

    def set_key_values(values : Enumerable(AnimationKeyValue)) : self
      self.key_values = values
      self
    end

    def current_value : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_variant_animation_current_value(to_unsafe))
    end

    def duration=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_variant_animation_set_duration(to_unsafe, int_value)
      int_value
    end

    def easing_curve : EasingCurve
      EasingCurve.wrap(LibQt6.qt6cr_variant_animation_easing_curve(to_unsafe), true)
    end

    def easing_curve=(value : EasingCurve) : EasingCurve
      LibQt6.qt6cr_variant_animation_set_easing_curve(to_unsafe, value.to_unsafe)
      value
    end

    def set_start_value(value) : self
      self.start_value = value
      self
    end

    def set_end_value(value) : self
      self.end_value = value
      self
    end

    def set_duration(value : Int) : self
      self.duration = value
      self
    end

    def set_easing_curve(value : EasingCurve) : self
      self.easing_curve = value
      self
    end

    def on_value_changed(&block : ModelData ->) : self
      @value_changed.connect { |value| block.call(value) }
      self
    end

    private def register_variant_callbacks : Nil
      @value_changed = Signal(ModelData).new
      @variant_callback_userdata = Box.box(self.as(VariantAnimation))
      LibQt6.qt6cr_variant_animation_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @variant_callback_userdata)
    end

    protected def emit_value_changed(value : LibQt6::VariantValue) : Nil
      @value_changed.emit(Qt6.model_data_from_native(value))
    end

    private VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : LibQt6::VariantValue) do
      Box(VariantAnimation).unbox(userdata).emit_value_changed(value)
    end
  end
end
