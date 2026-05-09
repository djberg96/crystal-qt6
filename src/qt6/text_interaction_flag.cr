module Qt6
  @[Flags]
  enum TextInteractionFlag : Int32
    NoTextInteraction         = 0
    TextSelectableByMouse     = 1
    TextSelectableByKeyboard  = 2
    LinksAccessibleByMouse    = 4
    LinksAccessibleByKeyboard = 8
    TextEditable              = 16
  end
end
