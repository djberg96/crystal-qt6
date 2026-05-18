module Qt6
  enum SizePolicy
    Fixed            =  0
    Minimum          =  1
    Maximum          =  4
    Preferred        =  5
    Expanding        =  7
    MinimumExpanding =  3
    Ignored          = 13

    def grow? : Bool
      (value & 1) == 1
    end

    def expand? : Bool
      (value & 2) == 2
    end

    def shrink? : Bool
      (value & 4) == 4
    end

    def ignore? : Bool
      (value & 8) == 8
    end
  end
end
