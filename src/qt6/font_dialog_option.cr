module Qt6
  # Options accepted by `QFontDialog`.
  @[Flags]
  enum FontDialogOption : Int32
    None                = 0x00000000
    NoButtons           = 0x00000001
    DontUseNativeDialog = 0x00000002
    ScalableFonts       = 0x00000004
    NonScalableFonts    = 0x00000008
    MonospacedFonts     = 0x00000010
    ProportionalFonts   = 0x00000020
  end
end
