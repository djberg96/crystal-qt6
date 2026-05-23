module Qt6
  @[Flags]
  enum StyleOptionViewItemFeature : Int32
    None                      = 0x00
    WrapText                  = 0x01
    Alternate                 = 0x02
    HasCheckIndicator         = 0x04
    HasDisplay                = 0x08
    HasDecoration             = 0x10
    IsDecoratedRootColumn     = 0x20
    IsDecorationForRootColumn = 0x40
  end
end
