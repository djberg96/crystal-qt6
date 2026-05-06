module Qt6
  @[Flags]
  enum FileDialogOption : Int32
    ShowDirsOnly                = 0x00000001
    DontResolveSymlinks         = 0x00000002
    DontConfirmOverwrite        = 0x00000004
    DontUseNativeDialog         = 0x00000008
    ReadOnly                    = 0x00000010
    HideNameFilterDetails       = 0x00000020
    DontUseCustomDirectoryIcons = 0x00000040
  end
end
