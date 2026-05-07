module Qt6
  @[Flags]
  enum PainterRenderHint : Int32
    Antialiasing                = 0x01
    TextAntialiasing            = 0x02
    SmoothPixmapTransform       = 0x04
    VerticalSubpixelPositioning = 0x08
    LosslessImageRendering      = 0x40
    NonCosmeticBrushPatterns    = 0x80
  end
end
