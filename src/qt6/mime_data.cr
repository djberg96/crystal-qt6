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
