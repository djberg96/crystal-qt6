module Qt6
  alias ScrollerMetricValue = Float64 | ScrollerOvershootPolicy | ScrollerFrameRate

  # Wraps `QScrollerProperties`.
  class ScrollerProperties < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.default : self
      wrap(LibQt6.qt6cr_scroller_properties_default, true)
    end

    def self.default=(value : ScrollerProperties) : ScrollerProperties
      LibQt6.qt6cr_scroller_properties_set_default(value.to_unsafe)
      value
    end

    def self.unset_default : Nil
      LibQt6.qt6cr_scroller_properties_unset_default
    end

    def initialize
      super(LibQt6.qt6cr_scroller_properties_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def dup : self
      self.class.wrap(LibQt6.qt6cr_scroller_properties_copy(to_unsafe), true)
    end

    def ==(other : ScrollerProperties) : Bool
      LibQt6.qt6cr_scroller_properties_equal(to_unsafe, other.to_unsafe)
    end

    # Returns the current value for the given scroll metric.
    def scroll_metric(metric : ScrollerMetric) : ScrollerMetricValue
      case metric
      when .horizontal_overshoot_policy?, .vertical_overshoot_policy?
        ScrollerOvershootPolicy.from_value(
          LibQt6.qt6cr_scroller_properties_scroll_metric_overshoot_policy(to_unsafe, metric.value)
        )
      when .frame_rate?
        ScrollerFrameRate.from_value(
          LibQt6.qt6cr_scroller_properties_scroll_metric_frame_rate(to_unsafe)
        )
      else
        LibQt6.qt6cr_scroller_properties_scroll_metric_real(to_unsafe, metric.value)
      end
    end

    # Sets the given scroll metric and returns the assigned value.
    def set_scroll_metric(metric : ScrollerMetric, value : ScrollerOvershootPolicy) : ScrollerOvershootPolicy
      case metric
      when .horizontal_overshoot_policy?, .vertical_overshoot_policy?
        LibQt6.qt6cr_scroller_properties_set_scroll_metric_overshoot_policy(to_unsafe, metric.value, value.value)
      else
        raise ArgumentError.new("#{metric} does not accept a ScrollerOvershootPolicy")
      end
      value
    end

    # Sets the given scroll metric and returns the assigned value.
    def set_scroll_metric(metric : ScrollerMetric, value : ScrollerFrameRate) : ScrollerFrameRate
      case metric
      when .frame_rate?
        LibQt6.qt6cr_scroller_properties_set_scroll_metric_frame_rate(to_unsafe, value.value)
      else
        raise ArgumentError.new("#{metric} does not accept a ScrollerFrameRate")
      end
      value
    end

    # Sets the given scroll metric and returns the assigned value.
    def set_scroll_metric(metric : ScrollerMetric, value : Number) : Float64
      case metric
      when .horizontal_overshoot_policy?, .vertical_overshoot_policy?, .frame_rate?
        raise ArgumentError.new("#{metric} requires an enum value")
      when .scrolling_curve?
        raise ArgumentError.new("ScrollingCurve is not exposed by this wrapper")
      else
        real = value.to_f64
        LibQt6.qt6cr_scroller_properties_set_scroll_metric_real(to_unsafe, metric.value, real)
        real
      end
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_scroller_properties_destroy(to_unsafe)
    end
  end
end
