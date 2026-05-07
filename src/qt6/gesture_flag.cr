module Qt6
  @[Flags]
  enum GestureFlag : Int32
    None                             =    0
    DontStartGestureOnChildren       = 0x01
    ReceivePartialGestures           = 0x02
    IgnoredGesturesPropagateToParent = 0x04
  end
end
