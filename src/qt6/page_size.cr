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

    def initialize(size : SizeF, unit : PageSizeUnit = PageSizeUnit::Millimeter)
      initialize(size.width, size.height, unit)
    end

    def size : SizeF
      SizeF.new(width, height)
    end
  end
end
