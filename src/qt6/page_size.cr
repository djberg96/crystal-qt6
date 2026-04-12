module Qt6
  struct PageSize
    getter width : Float64
    getter height : Float64
    getter unit : PageSizeUnit

    def initialize(width : Number, height : Number, unit : PageSizeUnit = PageSizeUnit::Millimeter)
      @width = width.to_f64
      @height = height.to_f64
      @unit = unit
    end
  end
end
