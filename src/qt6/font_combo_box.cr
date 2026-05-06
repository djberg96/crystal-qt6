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

    # Returns the active writing-system filter.
    def writing_system : FontWritingSystem
      FontWritingSystem.from_value(LibQt6.qt6cr_font_combo_box_writing_system(to_unsafe))
    end

    # Sets the active writing-system filter and returns it.
    def writing_system=(value : FontWritingSystem) : FontWritingSystem
      LibQt6.qt6cr_font_combo_box_set_writing_system(to_unsafe, value.value)
      value
    end

    # Returns the active font-filter flags.
    def font_filters : FontComboBoxFontFilter
      FontComboBoxFontFilter.from_value(LibQt6.qt6cr_font_combo_box_font_filters(to_unsafe))
    end

    # Sets the active font-filter flags and returns them.
    def font_filters=(value : FontComboBoxFontFilter) : FontComboBoxFontFilter
      LibQt6.qt6cr_font_combo_box_set_font_filters(to_unsafe, value.value)
      value
    end

    # Returns the combo box's preferred size.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_font_combo_box_size_hint(to_unsafe))
    end

    # Overrides the sample text used for a writing system.
    def set_sample_text_for_system(writing_system : FontWritingSystem, sample_text : String) : self
      LibQt6.qt6cr_font_combo_box_set_sample_text_for_system(to_unsafe, writing_system.value, sample_text.to_unsafe)
      self
    end

    # Returns the sample text used for a writing system.
    def sample_text_for_system(writing_system : FontWritingSystem) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_font_combo_box_sample_text_for_system(to_unsafe, writing_system.value))
    end

    # Overrides the sample text used for a font family.
    def set_sample_text_for_font(family : String, sample_text : String) : self
      LibQt6.qt6cr_font_combo_box_set_sample_text_for_font(to_unsafe, family.to_unsafe, sample_text.to_unsafe)
      self
    end

    # Returns the sample text used for a font family.
    def sample_text_for_font(family : String) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_font_combo_box_sample_text_for_font(to_unsafe, family.to_unsafe))
    end

    # Overrides the display font used to render a font-family entry.
    def set_display_font(family : String, font : QFont) : self
      LibQt6.qt6cr_font_combo_box_set_display_font(to_unsafe, family.to_unsafe, font.to_unsafe)
      self
    end

    # Returns the display font override for a font-family entry, if any.
    def display_font(family : String) : QFont?
      handle = LibQt6.qt6cr_font_combo_box_display_font(to_unsafe, family.to_unsafe)
      handle.null? ? nil : QFont.wrap(handle, true)
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
