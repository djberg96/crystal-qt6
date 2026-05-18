module Qt6
  @[Flags]
  enum SizePolicyControlType
    DefaultType = 0x00000001
    ButtonBox   = 0x00000002
    CheckBox    = 0x00000004
    ComboBox    = 0x00000008
    Frame       = 0x00000010
    GroupBox    = 0x00000020
    Label       = 0x00000040
    Line        = 0x00000080
    LineEdit    = 0x00000100
    PushButton  = 0x00000200
    RadioButton = 0x00000400
    Slider      = 0x00000800
    SpinBox     = 0x00001000
    TabWidget   = 0x00002000
    ToolButton  = 0x00004000
  end
end
