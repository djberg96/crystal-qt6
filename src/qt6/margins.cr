module Qt6
  struct Margins
    getter left : Int32
    getter top : Int32
    getter right : Int32
    getter bottom : Int32

    def initialize(left : Int, top : Int, right : Int, bottom : Int)
      @left = left.to_i32
      @top = top.to_i32
      @right = right.to_i32
      @bottom = bottom.to_i32
    end

    def horizontal : Int32
      left + right
    end

    def vertical : Int32
      top + bottom
    end
  end
end
