module Qt6
  @[Flags]
  enum GraphicsViewOptimizationFlag : Int32
    DontSavePainterState      = 0x1
    DontAdjustForAntialiasing = 0x2
    IndirectPainting          = 0x4
  end
end
