module Qt6
  # Wraps `QMimeData` for clipboard and drag/drop payloads.
  class MimeData < QObject
    # Wraps an existing mime-data handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an empty mime-data payload.
    def initialize
      super(LibQt6.qt6cr_mime_data_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` when a text payload is present.
    def has_text? : Bool
      LibQt6.qt6cr_mime_data_has_text(to_unsafe)
    end

    # Returns the text payload.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_mime_data_text(to_unsafe))
    end

    # Sets the text payload.
    def text=(value : String) : String
      LibQt6.qt6cr_mime_data_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when an HTML payload is present.
    def has_html? : Bool
      LibQt6.qt6cr_mime_data_has_html(to_unsafe)
    end

    # Returns the HTML payload.
    def html : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_mime_data_html(to_unsafe))
    end

    # Sets the HTML payload.
    def html=(value : String) : String
      LibQt6.qt6cr_mime_data_set_html(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when an image payload is present.
    def has_image? : Bool
      LibQt6.qt6cr_mime_data_has_image(to_unsafe)
    end

    # Returns a copy of the image payload.
    def image : QImage
      QImage.wrap(LibQt6.qt6cr_mime_data_image(to_unsafe), true)
    end

    # Sets the image payload.
    def image=(value : QImage) : QImage
      LibQt6.qt6cr_mime_data_set_image(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the MIME formats currently stored in the payload.
    def formats : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_mime_data_formats(to_unsafe))
    end

    # Returns `true` when the payload contains the requested MIME format.
    def has_format?(format : String) : Bool
      LibQt6.qt6cr_mime_data_has_format(to_unsafe, format.to_unsafe)
    end

    # Returns the raw bytes for a MIME format.
    def data(format : String) : Bytes
      Qt6.copy_and_release_bytes(LibQt6.qt6cr_mime_data_data(to_unsafe, format.to_unsafe))
    end

    # Stores raw bytes for a MIME format.
    def set_data(format : String, value : Bytes) : Bytes
      pointer = value.empty? ? Pointer(UInt8).null : value.to_unsafe
      LibQt6.qt6cr_mime_data_set_data(to_unsafe, format.to_unsafe, pointer, value.size)
      value
    end

    # Stores a UTF-8 string payload for a MIME format.
    def set_data(format : String, value : String) : String
      set_data(format, value.to_slice)
      value
    end
  end
end
