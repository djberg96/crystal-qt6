module Qt6
  # Options accepted by `QColorDialog`.
  @[Flags]
  enum ColorDialogOption : Int32
    None                = 0x00000000
    ShowAlphaChannel    = 0x00000001
    NoButtons           = 0x00000002
    DontUseNativeDialog = 0x00000004
    NoEyeDropperButton  = 0x00000008
  end
end
