module Qt6
  # Wraps a copied `QTextBlock` value for document block inspection.
  class TextBlock < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns a copied wrapper for this block value.
    def copy : TextBlock
      TextBlock.wrap(LibQt6.qt6cr_text_block_copy(to_unsafe), true)
    end

    # Returns `true` when this block refers to a valid document block.
    def valid? : Bool
      LibQt6.qt6cr_text_block_is_valid(to_unsafe)
    end

    # Returns the block's plain text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_block_text(to_unsafe))
    end

    # Returns the block's zero-based number within the document.
    def block_number : Int32
      LibQt6.qt6cr_text_block_block_number(to_unsafe)
    end

    # Returns the character position where this block starts.
    def position : Int32
      LibQt6.qt6cr_text_block_position(to_unsafe)
    end

    # Returns the block length including Qt's trailing paragraph separator.
    def length : Int32
      LibQt6.qt6cr_text_block_length(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_text_block_destroy(to_unsafe)
    end
  end
end
