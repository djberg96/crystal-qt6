module Qt6
  @[Flags]
  enum GestureRecognizerResult : Int32
    Ignore           = 0x0001
    MayBeGesture     = 0x0002
    TriggerGesture   = 0x0004
    FinishGesture    = 0x0008
    CancelGesture    = 0x0010
    ResultStateMask  = 0x00ff
    ConsumeEventHint = 0x0100
    ResultHintMask   = 0xff00
  end
end
