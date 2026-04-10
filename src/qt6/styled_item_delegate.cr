module Qt6
  # Wraps `QStyledItemDelegate` and supports display-text formatting.
  class StyledItemDelegate < QObject
    @display_text_formatter : Proc(String, String)? = nil
    @display_text_userdata : LibQt6::Handle = Pointer(Void).null

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_styled_item_delegate_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @display_text_userdata = Box.box(self)
    end

    # Registers a block to format display text before Qt paints it.
    def on_display_text(&block : String -> String) : self
      @display_text_formatter = block
      LibQt6.qt6cr_styled_item_delegate_on_display_text(to_unsafe, DISPLAY_TEXT_TRAMPOLINE, @display_text_userdata)
      self
    end

    # Returns the delegate's display text for a model value.
    def display_text(value) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_styled_item_delegate_display_text(to_unsafe, Qt6.model_data_to_native(value)))
    end

    protected def format_display_text(text : String) : String
      formatter = @display_text_formatter
      formatter ? formatter.call(text) : text
    end

    private DISPLAY_TEXT_TRAMPOLINE = ->(userdata : Void*, text : UInt8*) do
      formatted = Box(StyledItemDelegate).unbox(userdata).format_display_text(Qt6.copy_string(text))
      Qt6.malloc_string(formatted)
    end
  end
end