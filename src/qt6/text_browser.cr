module Qt6
  # Wraps `QTextBrowser`.
  class TextBrowser < TextEdit
    @backward_available : Signal(Bool) = Signal(Bool).new
    @forward_available : Signal(Bool) = Signal(Bool).new
    @history_changed : Signal() = Signal().new
    @source_changed : Signal(String) = Signal(String).new
    @highlighted : Signal(String) = Signal(String).new
    @anchor_clicked : Signal(String) = Signal(String).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when backward navigation availability changes.
    getter backward_available : Signal(Bool)
    # Signal emitted when forward navigation availability changes.
    getter forward_available : Signal(Bool)
    # Signal emitted when the browser history changes.
    getter history_changed : Signal()
    # Signal emitted when the current source URL changes.
    getter source_changed : Signal(String)
    # Signal emitted when a link is highlighted.
    getter highlighted : Signal(String)
    # Signal emitted when a link is activated.
    getter anchor_clicked : Signal(String)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a text browser with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_text_browser_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      hook_text_browser_signals
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      hook_text_browser_signals
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

    # Returns the current source URL.
    def source : QUrl
      QUrl.wrap(LibQt6.qt6cr_text_browser_source(to_unsafe), true)
    end

    # Returns the current source resource type.
    def source_type : TextDocumentResourceType
      TextDocumentResourceType.from_value(LibQt6.qt6cr_text_browser_source_type(to_unsafe))
    end

    # Navigates to the given source URL and returns it.
    def source=(value : QUrl) : QUrl
      set_source(value)
      value
    end

    # Returns the browser search paths used for relative resource resolution.
    def search_paths : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_text_browser_search_paths(to_unsafe))
    end

    # Replaces the browser search paths and returns them.
    def search_paths=(paths : Enumerable(String)) : Array(String)
      values = paths.to_a
      pointers = values.map(&.to_unsafe)
      LibQt6.qt6cr_text_browser_set_search_paths(
        to_unsafe,
        pointers.empty? ? Pointer(UInt8*).null : pointers.to_unsafe,
        pointers.size
      )
      values
    end

    # Qt-style alias for `search_paths=`.
    def set_search_paths(paths : Enumerable(String)) : self
      self.search_paths = paths
      self
    end

    # Returns `true` when backward navigation is currently possible.
    def backward_available? : Bool
      LibQt6.qt6cr_text_browser_is_backward_available(to_unsafe)
    end

    # Returns `true` when forward navigation is currently possible.
    def forward_available? : Bool
      LibQt6.qt6cr_text_browser_is_forward_available(to_unsafe)
    end

    # Clears the browser navigation history.
    def clear_history : self
      LibQt6.qt6cr_text_browser_clear_history(to_unsafe)
      self
    end

    # Returns the history title at the given history index.
    def history_title(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_text_browser_history_title(to_unsafe, index.to_i32))
    end

    # Returns the history URL at the given history index.
    def history_url(index : Int) : QUrl
      QUrl.wrap(LibQt6.qt6cr_text_browser_history_url(to_unsafe, index.to_i32), true)
    end

    # Returns the number of entries available in backward history.
    def backward_history_count : Int32
      LibQt6.qt6cr_text_browser_backward_history_count(to_unsafe)
    end

    # Returns the number of entries available in forward history.
    def forward_history_count : Int32
      LibQt6.qt6cr_text_browser_forward_history_count(to_unsafe)
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

    # Qt-style alias for `open_external_links=`.
    def set_open_external_links(value : Bool) : self
      self.open_external_links = value
      self
    end

    # Returns `true` when clicked links are opened automatically.
    def open_links? : Bool
      LibQt6.qt6cr_text_browser_open_links(to_unsafe)
    end

    # Enables or disables automatic opening of clicked links.
    def open_links=(value : Bool) : Bool
      LibQt6.qt6cr_text_browser_set_open_links(to_unsafe, value)
      value
    end

    # Qt-style alias for `open_links=`.
    def set_open_links(value : Bool) : self
      self.open_links = value
      self
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

    # Navigates to the given source URL with an optional explicit resource type.
    def set_source(value : QUrl, type : TextDocumentResourceType = TextDocumentResourceType::UnknownResource) : self
      LibQt6.qt6cr_text_browser_set_source(to_unsafe, value.to_unsafe, type.value)
      self
    end

    # Convenience overload for string URL sources.
    def set_source(value : String, type : TextDocumentResourceType = TextDocumentResourceType::UnknownResource) : self
      url = QUrl.new(value)
      begin
        set_source(url, type)
      ensure
        url.release
      end
      self
    end

    # Navigates one step backward in browser history.
    def backward : self
      LibQt6.qt6cr_text_browser_backward(to_unsafe)
      self
    end

    # Navigates one step forward in browser history.
    def forward : self
      LibQt6.qt6cr_text_browser_forward(to_unsafe)
      self
    end

    # Navigates to the first history entry.
    def home : self
      LibQt6.qt6cr_text_browser_home(to_unsafe)
      self
    end

    # Reloads the current source.
    def reload : self
      LibQt6.qt6cr_text_browser_reload(to_unsafe)
      self
    end

    # Registers a block to run when backward availability changes.
    def on_backward_available(&block : Bool ->) : self
      @backward_available.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when forward availability changes.
    def on_forward_available(&block : Bool ->) : self
      @forward_available.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when the browser history changes.
    def on_history_changed(&block : ->) : self
      @history_changed.connect { block.call }
      self
    end

    # Registers a block to run when the current source changes.
    def on_source_changed(&block : String ->) : self
      @source_changed.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when a link is highlighted.
    def on_highlighted(&block : String ->) : self
      @highlighted.connect { |value| block.call(value) }
      self
    end

    # Registers a block to run when a link is activated.
    def on_anchor_clicked(&block : String ->) : self
      @anchor_clicked.connect { |value| block.call(value) }
      self
    end

    protected def emit_backward_available(value : Bool) : Nil
      @backward_available.emit(value)
    end

    protected def emit_forward_available(value : Bool) : Nil
      @forward_available.emit(value)
    end

    protected def emit_history_changed : Nil
      @history_changed.emit
    end

    protected def emit_source_changed(value : UInt8*) : Nil
      @source_changed.emit(Qt6.copy_string(value))
    end

    protected def emit_highlighted(value : UInt8*) : Nil
      @highlighted.emit(Qt6.copy_string(value))
    end

    protected def emit_anchor_clicked(value : UInt8*) : Nil
      @anchor_clicked.emit(Qt6.copy_string(value))
    end

    private def hook_text_browser_signals : Nil
      @backward_available = Signal(Bool).new
      @forward_available = Signal(Bool).new
      @history_changed = Signal().new
      @source_changed = Signal(String).new
      @highlighted = Signal(String).new
      @anchor_clicked = Signal(String).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_text_browser_on_backward_available(to_unsafe, BACKWARD_AVAILABLE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_text_browser_on_forward_available(to_unsafe, FORWARD_AVAILABLE_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_text_browser_on_history_changed(to_unsafe, HISTORY_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_text_browser_on_source_changed(to_unsafe, SOURCE_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_text_browser_on_highlighted(to_unsafe, HIGHLIGHTED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_text_browser_on_anchor_clicked(to_unsafe, ANCHOR_CLICKED_TRAMPOLINE, @callback_userdata)
    end

    private BACKWARD_AVAILABLE_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(TextBrowser).unbox(userdata).emit_backward_available(value)
    end

    private FORWARD_AVAILABLE_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(TextBrowser).unbox(userdata).emit_forward_available(value)
    end

    private HISTORY_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(TextBrowser).unbox(userdata).emit_history_changed
    end

    private SOURCE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(TextBrowser).unbox(userdata).emit_source_changed(value)
    end

    private HIGHLIGHTED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(TextBrowser).unbox(userdata).emit_highlighted(value)
    end

    private ANCHOR_CLICKED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(TextBrowser).unbox(userdata).emit_anchor_clicked(value)
    end
  end
end
