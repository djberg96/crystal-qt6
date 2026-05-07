module Qt6
  @[Flags]
  enum GraphicsItemFlag : Int32
    ItemIsMovable                        =     0x1
    ItemIsSelectable                     =     0x2
    ItemIsFocusable                      =     0x4
    ItemClipsToShape                     =     0x8
    ItemClipsChildrenToShape             =    0x10
    ItemIgnoresTransformations           =    0x20
    ItemIgnoresParentOpacity             =    0x40
    ItemDoesntPropagateOpacityToChildren =    0x80
    ItemStacksBehindParent               =   0x100
    ItemUsesExtendedStyleOption          =   0x200
    ItemHasNoContents                    =   0x400
    ItemSendsGeometryChanges             =   0x800
    ItemAcceptsInputMethod               =  0x1000
    ItemNegativeZStacksBehindParent      =  0x2000
    ItemIsPanel                          =  0x4000
    ItemIsFocusScope                     =  0x8000
    ItemSendsScenePositionChanges        = 0x10000
    ItemStopsClickFocusPropagation       = 0x20000
    ItemStopsFocusHandling               = 0x40000
    ItemContainsChildrenInShape          = 0x80000
  end
end
