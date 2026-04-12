module Qt6
  # Wraps `QPixmap` for paint-device interop and display-oriented images.
  class QPixmap < NativeResource
    # Wraps an existing native pixmap handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an empty pixmap with the requested dimensions.
    def initialize(width : Int, height : Int)
      super(LibQt6.qt6cr_qpixmap_create(width, height))
    end

    # Loads a pixmap from disk.
    def initialize(path : String)
      super(LibQt6.qt6cr_qpixmap_create_from_file(path.to_unsafe))
    end

    # Wraps an existing native pixmap handle.
    def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Loads a pixmap from disk.
    def self.from_file(path : String) : self
      new(path)
    end

    # Loads a pixmap from encoded bytes.
    def self.from_data(data : Bytes, format : String? = nil) : self
      pixmap = new(0, 0)
      pixmap.load(data, format)
      pixmap
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

    # Loads pixmap contents from disk into this instance.
    def load(path : String) : Bool
      LibQt6.qt6cr_qpixmap_load(to_unsafe, path.to_unsafe)
    end

    # Loads pixmap contents from encoded bytes into this instance.
    def load(data : Bytes, format : String? = nil) : Bool
      LibQt6.qt6cr_qpixmap_load_from_data(to_unsafe, data.to_unsafe, data.size, format.try(&.to_unsafe) || Pointer(UInt8).null)
    end

    # Saves the pixmap to disk.
    def save(path : String) : Bool
      LibQt6.qt6cr_qpixmap_save(to_unsafe, path.to_unsafe)
    end

    # Encodes the pixmap into bytes using the given format.
    def save_to_data(format : String) : Bytes
      Qt6.copy_and_release_bytes(LibQt6.qt6cr_qpixmap_save_to_data(to_unsafe, format.to_unsafe))
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
