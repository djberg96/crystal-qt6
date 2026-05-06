module Qt6
  @[Flags]
  enum FontComboBoxFontFilter : Int32
    AllFonts          = 0x0
    ScalableFonts     = 0x1
    NonScalableFonts  = 0x2
    MonospacedFonts   = 0x4
    ProportionalFonts = 0x8
  end
end
