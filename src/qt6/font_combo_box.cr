module Qt6
  # Wraps `QFontComboBox`.
  class FontComboBox < ComboBox
    @current_font_changed : Signal(QFont) = Signal(QFont).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the selected font changes.
    getter current_font_changed : Signal(QFont)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a font combo box with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_font_combo_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_font_changed = Signal(QFont).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_font_combo_box_on_current_font_changed(to_unsafe, CURRENT_FONT_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @current_font_changed = Signal(QFont).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_font_combo_box_on_current_font_changed(to_unsafe, CURRENT_FONT_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Returns the currently selected font.
    def current_font : QFont
      QFont.wrap(LibQt6.qt6cr_font_combo_box_current_font(to_unsafe), true)
    end

    # Selects the given font and returns it.
    def current_font=(value : QFont) : QFont
      LibQt6.qt6cr_font_combo_box_set_current_font(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for assigning the current font.
    def set_current_font(value : QFont) : self
      self.current_font = value
      self
    end

    # Registers a block to run when the selected font changes.
    def on_current_font_changed(&block : QFont ->) : self
      @current_font_changed.connect { |font| block.call(font) }
      self
    end

    protected def emit_current_font_changed(handle : LibQt6::Handle) : Nil
      @current_font_changed.emit(QFont.wrap(handle, true))
    end

    private CURRENT_FONT_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(FontComboBox).unbox(userdata).emit_current_font_changed(handle)
    end
  end
end
