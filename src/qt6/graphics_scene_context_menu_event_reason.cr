module Qt6
  # Reason Qt used to trigger a `QGraphicsSceneContextMenuEvent`.
  enum GraphicsSceneContextMenuEventReason : Int32
    Mouse    = 0
    Keyboard = 1
    Other    = 2
  end
end
