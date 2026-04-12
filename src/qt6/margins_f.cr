module Qt6
  struct MarginsF
    getter left : Float64
    getter top : Float64
    getter right : Float64
    getter bottom : Float64

    def initialize(left : Number, top : Number, right : Number, bottom : Number)
      @left = left.to_f64
      @top = top.to_f64
      @right = right.to_f64
      @bottom = bottom.to_f64
    end

    def horizontal : Float64
      left + right
    end

    def vertical : Float64
      top + bottom
    end
  end
end
