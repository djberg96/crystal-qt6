module Qt6
  # Wraps `QPixmap` for paint-device interop and display-oriented images.
  class QPixmap < NativeResource
    # Creates an empty pixmap with the requested dimensions.
    def initialize(width : Int, height : Int)
      super(LibQt6.qt6cr_qpixmap_create(width, height))
    end

    # Wraps an existing native pixmap handle.
    def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Builds a pixmap copy from an image.
    def self.from_image(image : QImage) : self
      new(LibQt6.qt6cr_qpixmap_from_image(image.to_unsafe), true)
    end

    # Returns the pixmap width in pixels.
    def width : Int32
      LibQt6.qt6cr_qpixmap_width(to_unsafe)
    end

    # Returns the pixmap height in pixels.
    def height : Int32
      LibQt6.qt6cr_qpixmap_height(to_unsafe)
    end

    # Returns the pixmap size in pixels.
    def size : Size
      Size.new(width, height)
    end

    # Returns `true` if the pixmap is null.
    def null? : Bool
      LibQt6.qt6cr_qpixmap_is_null(to_unsafe)
    end

    # Fills the entire pixmap with a color.
    def fill(color : Color) : self
      LibQt6.qt6cr_qpixmap_fill(to_unsafe, color.to_native)
      self
    end

    # Saves the pixmap to disk.
    def save(path : String) : Bool
      LibQt6.qt6cr_qpixmap_save(to_unsafe, path.to_unsafe)
    end

    # Returns an image copy of the pixmap.
    def to_image : QImage
      QImage.new(LibQt6.qt6cr_qpixmap_to_image(to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpixmap_destroy(to_unsafe)
    end
  end
end