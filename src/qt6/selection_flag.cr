module Qt6
  @[Flags]
  enum SelectionFlag
    NoUpdate      = 0
    Clear         = 1
    Select        = 2
    Deselect      = 4
    Toggle        = 8
    Current       = 16
    Rows          = 32
    Columns       = 64
    SelectCurrent = 18
    ToggleCurrent = 24
    ClearAndSelect = 3
  end
end
