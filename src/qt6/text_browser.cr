module Qt6
  # Wraps `QTextBrowser`.
  class TextBrowser < Frame
    @anchor_clicked : Signal(String) = Signal(String).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when a link is activated.
    getter anchor_clicked : Signal(String)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a text browser with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_text_browser_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @anchor_clicked = Signal(String).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_text_browser_on_anchor_clicked(to_unsafe, ANCHOR_CLICKED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @anchor_clicked = Signal(String).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_text_browser_on_anchor_clicked(to_unsafe, ANCHOR_CLICKED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the current HTML content.
    def html : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_browser_html(to_unsafe))
    end

    # Sets the current HTML content and returns it.
    def html=(value : String) : String
      LibQt6.qt6cr_text_browser_set_html(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for assigning HTML content.
    def set_html(value : String) : self
      self.html = value
      self
    end

    # Returns the plain-text rendering of the document.
    def plain_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_browser_plain_text(to_unsafe))
    end

    # Returns `true` when external links open immediately.
    def open_external_links? : Bool
      LibQt6.qt6cr_text_browser_open_external_links(to_unsafe)
    end

    # Enables or disables automatic opening of external links.
    def open_external_links=(value : Bool) : Bool
      LibQt6.qt6cr_text_browser_set_open_external_links(to_unsafe, value)
      value
    end

    # Returns the document's default style sheet.
    def default_style_sheet : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_browser_default_style_sheet(to_unsafe))
    end

    # Sets the document's default style sheet and returns it.
    def default_style_sheet=(value : String) : String
      LibQt6.qt6cr_text_browser_set_default_style_sheet(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for assigning the default style sheet.
    def set_default_style_sheet(value : String) : self
      self.default_style_sheet = value
      self
    end

    # Returns the vertical scroll bar position.
    def vertical_scroll_value : Int32
      LibQt6.qt6cr_text_browser_vertical_scroll_value(to_unsafe)
    end

    # Sets the vertical scroll bar position and returns the assigned value.
    def vertical_scroll_value=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_text_browser_set_vertical_scroll_value(to_unsafe, int_value)
      int_value
    end

    # Scrolls back to the top of the current document.
    def scroll_to_top : self
      self.vertical_scroll_value = 0
      self
    end

    # Registers a block to run when a link is activated.
    def on_anchor_clicked(&block : String ->) : self
      @anchor_clicked.connect { |value| block.call(value) }
      self
    end

    protected def emit_anchor_clicked(value : UInt8*) : Nil
      @anchor_clicked.emit(Qt6.copy_string(value))
    end

    private ANCHOR_CLICKED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(TextBrowser).unbox(userdata).emit_anchor_clicked(value)
    end
  end
end
