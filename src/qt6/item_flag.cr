module Qt6
  @[Flags]
  enum ItemFlag
    None = 0
    Selectable = 1
    Editable = 2
    DragEnabled = 4
    DropEnabled = 8
    UserCheckable = 16
    Enabled = 32
    AutoTristate = 64
    NeverHasChildren = 128
    UserTristate = 256
  end
end
