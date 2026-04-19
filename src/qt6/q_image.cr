module Qt6
  # Wraps `QImage` for offscreen raster drawing.
  class QImage < NativeResource
    # Wraps an existing native image handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an empty image with the requested dimensions and format.
    def initialize(width : Int, height : Int, format : ImageFormat = ImageFormat::ARGB32)
      super(LibQt6.qt6cr_qimage_create(width, height, format.value))
    end

    # Creates an image by copying raw pixel bytes.
    def initialize(data : Bytes, width : Int, height : Int, bytes_per_line : Int, format : ImageFormat = ImageFormat::ARGB32)
      super(LibQt6.qt6cr_qimage_create_from_raw_data(data.to_unsafe, data.size, width, height, bytes_per_line, format.value))
    end

    # Loads an image from disk.
    def initialize(path : String)
      super(LibQt6.qt6cr_qimage_create_from_file(path.to_unsafe))
    end

    # Loads an image from disk.
    def self.from_file(path : String) : self
      new(path)
    end

    # Loads an image from encoded bytes.
    def self.from_data(data : Bytes, format : String? = nil) : self
      image = new(0, 0)
      image.load(data, format)
      image
    end

    # Creates an image by copying raw pixel bytes.
    def self.from_raw_data(data : Bytes, width : Int, height : Int, bytes_per_line : Int, format : ImageFormat = ImageFormat::ARGB32) : self
      new(data, width, height, bytes_per_line, format)
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

    # Returns the pixel format for formats known by this shard.
    def format : ImageFormat
      ImageFormat.from_value(LibQt6.qt6cr_qimage_format(to_unsafe))
    end

    # Returns the bytes occupied by each image row, including padding.
    def bytes_per_line : Int32
      LibQt6.qt6cr_qimage_bytes_per_line(to_unsafe)
    end

    # Returns the number of bytes occupied by the image data.
    def size_in_bytes : Int32
      LibQt6.qt6cr_qimage_size_in_bytes(to_unsafe)
    end

    # Returns a copy of the image's raw pixel bytes.
    def bytes : Bytes
      Qt6.copy_and_release_bytes(LibQt6.qt6cr_qimage_const_bits(to_unsafe))
    end

    # Returns the image bounds in pixels.
    def rect : Rect
      Rect.new(0, 0, width, height)
    end

    # Returns `true` if the image does not contain valid pixel data.
    def null? : Bool
      LibQt6.qt6cr_qimage_is_null(to_unsafe)
    end

    # Returns a deep copy of the image.
    def copy : QImage
      QImage.wrap(LibQt6.qt6cr_qimage_copy(to_unsafe), true)
    end

    # Returns a deep copy of a rectangular region.
    def copy(rect : Rect) : QImage
      copy(rect.x, rect.y, rect.width, rect.height)
    end

    # Returns a deep copy of a rectangular region.
    def copy(x : Int, y : Int, width : Int, height : Int) : QImage
      QImage.wrap(LibQt6.qt6cr_qimage_copy_rect(to_unsafe, x, y, width, height), true)
    end

    # Returns a converted copy of the image.
    def convert_to_format(format : ImageFormat) : QImage
      QImage.wrap(LibQt6.qt6cr_qimage_convert_to_format(to_unsafe, format.value), true)
    end

    # Fills the entire image with a color.
    def fill(color : Color) : self
      LibQt6.qt6cr_qimage_fill(to_unsafe, color.to_native)
      self
    end

    # Loads image contents from disk into this instance.
    def load(path : String) : Bool
      LibQt6.qt6cr_qimage_load(to_unsafe, path.to_unsafe)
    end

    # Loads image contents from encoded bytes into this instance.
    def load(data : Bytes, format : String? = nil) : Bool
      LibQt6.qt6cr_qimage_load_from_data(to_unsafe, data.to_unsafe, data.size, format.try(&.to_unsafe) || Pointer(UInt8).null)
    end

    # Loads image contents from an already-open device.
    def load(device : IODevice, format : String? = nil) : Bool
      LibQt6.qt6cr_qimage_load_from_device(to_unsafe, device.to_unsafe, format.try(&.to_unsafe) || Pointer(UInt8).null)
    end

    # Saves the image to disk.
    def save(path : String) : Bool
      LibQt6.qt6cr_qimage_save(to_unsafe, path.to_unsafe)
    end

    # Encodes the image into bytes using the given format.
    def save_to_data(format : String) : Bytes
      Qt6.copy_and_release_bytes(LibQt6.qt6cr_qimage_save_to_data(to_unsafe, format.to_unsafe))
    end

    # Saves the image into an open buffer using the given format.
    def save(device : IODevice, format : String? = nil) : Bool
      LibQt6.qt6cr_qimage_save_to_device(to_unsafe, device.to_unsafe, format.try(&.to_unsafe) || Pointer(UInt8).null)
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
