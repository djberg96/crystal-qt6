module Qt6
  @[Flags]
  enum DockWidgetFeature : Int32
    NoDockWidgetFeatures      = 0x00
    DockWidgetClosable        = 0x01
    DockWidgetMovable         = 0x02
    DockWidgetFloatable       = 0x04
    DockWidgetVerticalTitleBar = 0x08
    DockWidgetFeatureMask     = 0x0f
  end
end
