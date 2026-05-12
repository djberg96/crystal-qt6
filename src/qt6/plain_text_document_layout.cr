module Qt6
  # Wraps `QPlainTextDocumentLayout`.
  class PlainTextDocumentLayout < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a plain-text document layout attached to the given document.
    #
    # Qt transfers lifetime to the document, so the wrapper is borrowed.
    def initialize(document : TextDocument)
      super(LibQt6.qt6cr_plain_text_document_layout_create(document.to_unsafe), false)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the document currently using this layout.
    def document : TextDocument
      TextDocument.wrap(LibQt6.qt6cr_plain_text_document_layout_document(to_unsafe))
    end

    # Returns the bounding rectangle Qt computed for the given text block.
    def block_bounding_rect(block : TextBlock) : RectF
      RectF.from_native(LibQt6.qt6cr_plain_text_document_layout_block_bounding_rect(to_unsafe, block.to_unsafe))
    end

    # Ensures Qt has laid out the given block and returns `self`.
    def ensure_block_layout(block : TextBlock) : self
      LibQt6.qt6cr_plain_text_document_layout_ensure_block_layout(to_unsafe, block.to_unsafe)
      self
    end

    # Returns the cursor width used when painting the text caret.
    def cursor_width : Int32
      LibQt6.qt6cr_plain_text_document_layout_cursor_width(to_unsafe)
    end

    # Sets the cursor width and returns it.
    def cursor_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_plain_text_document_layout_set_cursor_width(to_unsafe, int_value)
      int_value
    end

    # Returns the laid-out document size.
    def document_size : SizeF
      SizeF.from_native(LibQt6.qt6cr_plain_text_document_layout_document_size(to_unsafe))
    end

    # Returns the number of pages reported by the layout.
    def page_count : Int32
      LibQt6.qt6cr_plain_text_document_layout_page_count(to_unsafe)
    end

    # Requests a repaint/update pass from Qt and returns `self`.
    def request_update : self
      LibQt6.qt6cr_plain_text_document_layout_request_update(to_unsafe)
      self
    end

    # Qt-style alias for `cursor_width=`.
    def set_cursor_width(value : Int) : self
      self.cursor_width = value
      self
    end
  end
end
