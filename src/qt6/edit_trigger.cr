module Qt6
  @[Flags]
  enum EditTrigger
    NoEditTriggers = 0
    CurrentChanged = 1
    DoubleClicked  = 2
    SelectedClicked = 4
    EditKeyPressed = 8
    AnyKeyPressed  = 16
    AllEditTriggers = 31
  end
end
