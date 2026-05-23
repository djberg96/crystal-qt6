module Qt6
  @[Flags]
  enum StyleOptionToolButtonFeature : Int32
    None            = 0x00
    Arrow           = 0x01
    Menu            = 0x04
    MenuButtonPopup = 0x04
    PopupDelay      = 0x08
    HasMenu         = 0x10
  end
end
