module Qt6
  @[Flags]
  enum TreeWidgetItemIteratorFlag : Int32
    Hidden        = 0x00000001
    NotHidden     = 0x00000002
    Selected      = 0x00000004
    Unselected    = 0x00000008
    Selectable    = 0x00000010
    NotSelectable = 0x00000020
    DragEnabled   = 0x00000040
    DragDisabled  = 0x00000080
    DropEnabled   = 0x00000100
    DropDisabled  = 0x00000200
    HasChildren   = 0x00000400
    NoChildren    = 0x00000800
    Checked       = 0x00001000
    NotChecked    = 0x00002000
    Enabled       = 0x00004000
    Disabled      = 0x00008000
    Editable      = 0x00010000
    NotEditable   = 0x00020000
    UserFlag      = 0x01000000
  end
end
