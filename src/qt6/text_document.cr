module Qt6
  # Wraps `QTextDocument`.
  class TextDocument < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a text document, optionally parented to another object.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_text_document_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the document's plain-text contents.
    def plain_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_document_plain_text(to_unsafe))
    end

    # Replaces the document's contents with plain text.
    def plain_text=(value : String) : String
      LibQt6.qt6cr_text_document_set_plain_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the document's HTML contents.
    def html : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_document_html(to_unsafe))
    end

    # Replaces the document's contents with HTML.
    def html=(value : String) : String
      LibQt6.qt6cr_text_document_set_html(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the default style sheet applied to the document.
    def default_style_sheet : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_document_default_style_sheet(to_unsafe))
    end

    # Sets the default style sheet applied to the document.
    def default_style_sheet=(value : String) : String
      LibQt6.qt6cr_text_document_set_default_style_sheet(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the document has unsaved changes.
    def modified? : Bool
      LibQt6.qt6cr_text_document_is_modified(to_unsafe)
    end

    # Marks the document as modified or clean.
    def modified=(value : Bool) : Bool
      LibQt6.qt6cr_text_document_set_modified(to_unsafe, value)
      value
    end

    # Returns `true` when the document contains no user-visible content.
    def empty? : Bool
      LibQt6.qt6cr_text_document_is_empty(to_unsafe)
    end

    # Returns the number of characters tracked by the document.
    def character_count : Int32
      LibQt6.qt6cr_text_document_character_count(to_unsafe)
    end
  end
end
