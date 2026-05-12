module Qt6
  @[Flags]
  enum PinchGestureChangeFlag : Int32
    NoChange             = 0x00
    ScaleFactorChanged   = 0x01
    RotationAngleChanged = 0x02
    CenterPointChanged   = 0x04
  end
end
