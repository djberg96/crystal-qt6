module Qt6
  # Wraps `QImage` for offscreen raster drawing.
  class QImage < NativeResource
    # Creates an empty image with the requested dimensions and format.
    def initialize(width : Int, height : Int, format : ImageFormat = ImageFormat::ARGB32)
      super(LibQt6.qt6cr_qimage_create(width, height, format.value))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the image width in pixels.
    def width : Int32
      LibQt6.qt6cr_qimage_width(to_unsafe)
    end

    # Returns the image height in pixels.
    def height : Int32
      LibQt6.qt6cr_qimage_height(to_unsafe)
    end

    # Returns the image size in pixels.
    def size : Size
      Size.new(width, height)
    end

    # Returns `true` if the image does not contain valid pixel data.
    def null? : Bool
      LibQt6.qt6cr_qimage_is_null(to_unsafe)
    end

    # Fills the entire image with a color.
    def fill(color : Color) : self
      LibQt6.qt6cr_qimage_fill(to_unsafe, color.to_native)
      self
    end

    # Saves the image to disk.
    def save(path : String) : Bool
      LibQt6.qt6cr_qimage_save(to_unsafe, path.to_unsafe)
    end

    # Returns the color of a single pixel.
    def pixel_color(x : Int, y : Int) : Color
      Color.from_native(LibQt6.qt6cr_qimage_pixel_color(to_unsafe, x, y))
    end

    # Sets the color of a single pixel.
    def set_pixel_color(x : Int, y : Int, color : Color) : Color
      LibQt6.qt6cr_qimage_set_pixel_color(to_unsafe, x, y, color.to_native)
      color
    end

    # Returns a pixmap copy of the image.
    def to_pixmap : QPixmap
      QPixmap.from_image(self)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qimage_destroy(to_unsafe)
    end
  end
end