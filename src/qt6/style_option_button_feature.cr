module Qt6
  @[Flags]
  enum StyleOptionButtonFeature : Int32
    None              = 0x00
    Flat              = 0x01
    HasMenu           = 0x02
    DefaultButton     = 0x04
    AutoDefaultButton = 0x08
    CommandLinkButton = 0x10
  end
end
