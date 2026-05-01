module Qt6
  @[Flags]
  enum MdiSubWindowOption : Int32
    AllowOutsideAreaHorizontally = 0x1
    AllowOutsideAreaVertically = 0x2
    RubberBandResize = 0x4
    RubberBandMove = 0x8
  end
end
