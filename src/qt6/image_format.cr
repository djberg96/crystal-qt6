module Qt6
  # Supported image formats for `QImage` creation.
  enum ImageFormat
    Invalid             = -1
    ARGB32              =  0
    RGB32               =  1
    ARGB32Premultiplied =  2
    RGB888              =  3
    Grayscale8          =  4
    Alpha8              =  5
  end
end
