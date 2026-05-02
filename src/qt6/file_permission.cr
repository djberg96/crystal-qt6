module Qt6
  @[Flags]
  enum FilePermission : Int32
    None       = 0x0000
    ReadOwner  = 0x4000
    WriteOwner = 0x2000
    ExeOwner   = 0x1000
    ReadUser   = 0x0400
    WriteUser  = 0x0200
    ExeUser    = 0x0100
    ReadGroup  = 0x0040
    WriteGroup = 0x0020
    ExeGroup   = 0x0010
    ReadOther  = 0x0004
    WriteOther = 0x0002
    ExeOther   = 0x0001
  end
end
