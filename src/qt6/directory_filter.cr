module Qt6
  @[Flags]
  enum DirectoryFilter : Int32
    Dirs              = 0x001
    Files             = 0x002
    Drives            = 0x004
    NoSymLinks        = 0x008
    AllEntries        = 0x00F
    Readable          = 0x010
    Writable          = 0x020
    Executable        = 0x040
    Hidden            = 0x100
    System            = 0x200
    AllDirs           = 0x400
    CaseSensitive     = 0x800
    NoDot             = 0x2000
    NoDotDot          = 0x4000
    NoDotAndDotDot    = 0x6000
    NoFilter          = -1
  end
end
