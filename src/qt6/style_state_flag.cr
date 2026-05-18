module Qt6
  @[Flags]
  enum StyleStateFlag : Int32
    None                = 0x00000000
    Enabled             = 0x00000001
    Raised              = 0x00000002
    Sunken              = 0x00000004
    Off                 = 0x00000008
    NoChange            = 0x00000010
    On                  = 0x00000020
    DownArrow           = 0x00000040
    Horizontal          = 0x00000080
    HasFocus            = 0x00000100
    Top                 = 0x00000200
    Bottom              = 0x00000400
    FocusAtBorder       = 0x00000800
    AutoRaise           = 0x00001000
    MouseOver           = 0x00002000
    UpArrow             = 0x00004000
    Selected            = 0x00008000
    Active              = 0x00010000
    Window              = 0x00020000
    Open                = 0x00040000
    Children            = 0x00080000
    Item                = 0x00100000
    Sibling             = 0x00200000
    KeyboardFocusChange = 0x00800000
    ReadOnly            = 0x02000000
    Small               = 0x04000000
    Mini                = 0x08000000
  end
end
