module Qt6
  # Wraps `QImageWriter` for configured image encoding.
  class QImageWriter < NativeResource
    # Returns writable image format names supported by the current Qt plugins.
    def self.supported_image_formats : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_qimage_writer_supported_image_formats)
    end

    # Returns writable image MIME types supported by the current Qt plugins.
    def self.supported_mime_types : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_qimage_writer_supported_mime_types)
    end

    # Creates a writer for a file, optionally forcing the image format.
    def initialize(file_name : String = "", format : String? = nil)
      super(LibQt6.qt6cr_qimage_writer_create(file_name.to_unsafe, format.try(&.to_unsafe) || Pointer(UInt8).null))
    end

    # Creates a writer for an already-open device, optionally forcing the image format.
    def initialize(device : IODevice, format : String? = nil)
      super(LibQt6.qt6cr_qimage_writer_create_from_device(device.to_unsafe, format.try(&.to_unsafe) || Pointer(UInt8).null))
    end

    # Returns the current destination file name.
    def file_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qimage_writer_file_name(to_unsafe))
    end

    # Updates the destination file name.
    def file_name=(value : String) : String
      LibQt6.qt6cr_qimage_writer_set_file_name(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the current image format hint, such as `png`.
    def format : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qimage_writer_format(to_unsafe))
    end

    # Overrides the output image format.
    def format=(value : String) : String
      LibQt6.qt6cr_qimage_writer_set_format(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the writer can encode to the current destination.
    def can_write? : Bool
      LibQt6.qt6cr_qimage_writer_can_write(to_unsafe)
    end

    # Encodes the image to the current destination.
    def write(image : QImage) : Bool
      LibQt6.qt6cr_qimage_writer_write(to_unsafe, image.to_unsafe)
    end

    # Returns the writer quality setting, or `-1` when the plugin default is used.
    def quality : Int32
      LibQt6.qt6cr_qimage_writer_quality(to_unsafe)
    end

    # Sets the writer quality setting.
    def quality=(value : Int) : Int32
      LibQt6.qt6cr_qimage_writer_set_quality(to_unsafe, value.to_i32)
      value.to_i32
    end

    # Returns the writer compression setting, or `-1` when the plugin default is used.
    def compression : Int32
      LibQt6.qt6cr_qimage_writer_compression(to_unsafe)
    end

    # Sets the writer compression setting.
    def compression=(value : Int) : Int32
      LibQt6.qt6cr_qimage_writer_set_compression(to_unsafe, value.to_i32)
      value.to_i32
    end

    # Returns whether optimized output is requested when the plugin supports it.
    def optimized_write? : Bool
      LibQt6.qt6cr_qimage_writer_optimized_write(to_unsafe)
    end

    # Enables or disables optimized output when the plugin supports it.
    def optimized_write=(value : Bool) : Bool
      LibQt6.qt6cr_qimage_writer_set_optimized_write(to_unsafe, value)
      value
    end

    # Returns whether progressive output is requested when the plugin supports it.
    def progressive_scan_write? : Bool
      LibQt6.qt6cr_qimage_writer_progressive_scan_write(to_unsafe)
    end

    # Enables or disables progressive output when the plugin supports it.
    def progressive_scan_write=(value : Bool) : Bool
      LibQt6.qt6cr_qimage_writer_set_progressive_scan_write(to_unsafe, value)
      value
    end

    # Returns Qt's last writer error message.
    def error_string : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qimage_writer_error_string(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qimage_writer_destroy(to_unsafe)
    end
  end
end
