module Qt6
  @[Flags]
  enum GraphicsSceneLayer : Int32
    ItemLayer       = 0x1
    BackgroundLayer = 0x2
    ForegroundLayer = 0x4
    AllLayers       = 0xffff
  end
end
