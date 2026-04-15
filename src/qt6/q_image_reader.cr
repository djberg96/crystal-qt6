module Qt6
  # Wraps `QImageReader` for file-backed image probing and decoding.
  class QImageReader < NativeResource
    # Creates a reader for a file, optionally forcing the image format.
    def initialize(file_name : String = "", format : String? = nil)
      super(LibQt6.qt6cr_qimage_reader_create(file_name.to_unsafe, format.try(&.to_unsafe) || Pointer(UInt8).null))
    end

    # Creates a reader for an already-open device, optionally forcing the image format.
    def initialize(device : IODevice, format : String? = nil)
      super(LibQt6.qt6cr_qimage_reader_create_from_device(device.to_unsafe, format.try(&.to_unsafe) || Pointer(UInt8).null))
    end

    # Returns the current source file name.
    def file_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qimage_reader_file_name(to_unsafe))
    end

    # Updates the source file name.
    def file_name=(value : String) : String
      LibQt6.qt6cr_qimage_reader_set_file_name(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current image format hint, such as `png`.
    def format : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qimage_reader_format(to_unsafe))
    end

    # Overrides the expected image format.
    def format=(value : String) : String
      LibQt6.qt6cr_qimage_reader_set_format(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the probed image size.
    def size : Size
      Size.from_native(LibQt6.qt6cr_qimage_reader_size(to_unsafe))
    end

    # Returns `true` when the reader can decode the current source.
    def can_read? : Bool
      LibQt6.qt6cr_qimage_reader_can_read(to_unsafe)
    end

    # Returns `true` when EXIF-orientation style transforms are enabled.
    def auto_transform? : Bool
      LibQt6.qt6cr_qimage_reader_auto_transform(to_unsafe)
    end

    # Enables or disables automatic orientation transforms.
    def auto_transform=(value : Bool) : Bool
      LibQt6.qt6cr_qimage_reader_set_auto_transform(to_unsafe, value)
      value
    end

    # Returns Qt's last reader error message.
    def error_string : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qimage_reader_error_string(to_unsafe))
    end

    # Decodes the source into a new image.
    def read : QImage
      QImage.wrap(LibQt6.qt6cr_qimage_reader_read(to_unsafe), true)
    end

    # Decodes the source into an existing image instance.
    def read(image : QImage) : Bool
      LibQt6.qt6cr_qimage_reader_read_into(to_unsafe, image.to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qimage_reader_destroy(to_unsafe)
    end
  end
end
