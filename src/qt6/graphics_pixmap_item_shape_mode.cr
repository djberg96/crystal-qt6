module Qt6
  # Hit-testing and shape calculation mode used by `QGraphicsPixmapItem`.
  enum GraphicsPixmapItemShapeMode
    MaskShape          = 0
    BoundingRectShape  = 1
    HeuristicMaskShape = 2
  end
end
