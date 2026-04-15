module Qt6
  # Wraps the process-wide `QClipboard`.
  class Clipboard < QObject
    # Wraps an existing clipboard handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the clipboard text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_clipboard_text(to_unsafe))
    end

    # Replaces the clipboard text.
    def text=(value : String) : String
      LibQt6.qt6cr_clipboard_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the clipboard currently holds text.
    def has_text? : Bool
      LibQt6.qt6cr_clipboard_has_text(to_unsafe)
    end

    # Returns a copy of the clipboard image.
    def image : QImage
      QImage.wrap(LibQt6.qt6cr_clipboard_image(to_unsafe), true)
    end

    # Replaces the clipboard image.
    def image=(value : QImage) : QImage
      LibQt6.qt6cr_clipboard_set_image(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the clipboard currently holds image data.
    def has_image? : Bool
      LibQt6.qt6cr_clipboard_has_image(to_unsafe)
    end

    # Returns a copy of the clipboard pixmap.
    def pixmap : QPixmap
      QPixmap.wrap(LibQt6.qt6cr_clipboard_pixmap(to_unsafe), true)
    end

    # Replaces the clipboard pixmap.
    def pixmap=(value : QPixmap) : QPixmap
      LibQt6.qt6cr_clipboard_set_pixmap(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the clipboard currently holds pixmap-compatible data.
    def has_pixmap? : Bool
      LibQt6.qt6cr_clipboard_has_pixmap(to_unsafe)
    end

    # Returns the current clipboard MIME payload.
    def mime_data : MimeData?
      handle = LibQt6.qt6cr_clipboard_mime_data(to_unsafe)
      handle.null? ? nil : MimeData.wrap(handle)
    end

    # Replaces the clipboard MIME payload.
    def mime_data=(value : MimeData) : MimeData
      LibQt6.qt6cr_clipboard_set_mime_data(to_unsafe, value.to_unsafe)
      value
    end

    # Clears the clipboard.
    def clear : self
      LibQt6.qt6cr_clipboard_clear(to_unsafe)
      self
    end
  end
end
