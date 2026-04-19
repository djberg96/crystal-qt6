module Qt6
  # Wraps `QFontDialog`.
  class FontDialog < Dialog
    @current_font_changed : Signal(QFont) = Signal(QFont).new
    @font_selected : Signal(QFont) = Signal(QFont).new
    @current_font_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @font_selected_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_font_changed : Signal(QFont)
    getter font_selected : Signal(QFont)

    # Creates a font dialog with an optional parent and initial font.
    def initialize(parent : Widget? = nil, initial_font : QFont? = nil)
      super(LibQt6.qt6cr_font_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null, initial_font.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_font_callbacks
    end

    # Returns the currently highlighted font.
    def current_font : QFont
      QFont.wrap(LibQt6.qt6cr_font_dialog_current_font(to_unsafe), true)
    end

    # Sets the currently highlighted font.
    def current_font=(value : QFont) : QFont
      LibQt6.qt6cr_font_dialog_set_current_font(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the selected font after the dialog is accepted.
    def selected_font : QFont
      QFont.wrap(LibQt6.qt6cr_font_dialog_selected_font(to_unsafe), true)
    end

    # Returns the enabled font-dialog options.
    def options : FontDialogOption
      FontDialogOption.from_value(LibQt6.qt6cr_font_dialog_options(to_unsafe))
    end

    # Sets the enabled font-dialog options.
    def options=(value : FontDialogOption) : FontDialogOption
      LibQt6.qt6cr_font_dialog_set_options(to_unsafe, value.value)
      value
    end

    # Returns `true` when the option is enabled.
    def option?(option : FontDialogOption) : Bool
      LibQt6.qt6cr_font_dialog_test_option(to_unsafe, option.value)
    end

    # Enables or disables an option and returns `self`.
    def set_option(option : FontDialogOption, value : Bool = true) : self
      LibQt6.qt6cr_font_dialog_set_option(to_unsafe, option.value, value)
      self
    end

    # Clears an option and returns `self`.
    def clear_option(option : FontDialogOption) : self
      set_option(option, false)
    end

    # Returns `true` when Qt uses the platform-native font dialog.
    def native_dialog? : Bool
      LibQt6.qt6cr_font_dialog_native_dialog(to_unsafe)
    end

    # Enables or disables use of the platform-native font dialog.
    def native_dialog=(value : Bool) : Bool
      LibQt6.qt6cr_font_dialog_set_native_dialog(to_unsafe, value)
      value
    end

    # Registers a block to run when the current font changes.
    def on_current_font_changed(&block : QFont ->) : self
      @current_font_changed.connect { |font| block.call(font) }
      self
    end

    # Registers a block to run when a font is selected.
    def on_font_selected(&block : QFont ->) : self
      @font_selected.connect { |font| block.call(font) }
      self
    end

    # Shows a modal font dialog and returns the chosen font, or `nil` if the
    # dialog is canceled.
    def self.get_font(parent : Widget? = nil, initial_font : QFont? = nil, title : String = "Select Font", options : FontDialogOption = FontDialogOption::None) : QFont?
      dialog = new(parent, initial_font)
      dialog.window_title = title
      dialog.options = options unless options.none?
      begin
        dialog.exec == DialogCode::Accepted ? dialog.selected_font : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal font dialog, yields it for customization, and returns the
    # chosen font, or `nil` if the dialog is canceled.
    def self.get_font(parent : Widget? = nil, initial_font : QFont? = nil, title : String = "Select Font", options : FontDialogOption = FontDialogOption::None, &block : FontDialog ->) : QFont?
      dialog = new(parent, initial_font)
      dialog.window_title = title
      dialog.options = options unless options.none?
      begin
        yield dialog
        dialog.exec == DialogCode::Accepted ? dialog.selected_font : nil
      ensure
        dialog.release
      end
    end

    private def register_font_callbacks : Nil
      @current_font_changed = Signal(QFont).new
      @font_selected = Signal(QFont).new
      @current_font_changed_userdata = Box.box(self)
      @font_selected_userdata = Box.box(self)
      LibQt6.qt6cr_font_dialog_on_current_font_changed(to_unsafe, CURRENT_FONT_CHANGED_TRAMPOLINE, @current_font_changed_userdata)
      LibQt6.qt6cr_font_dialog_on_font_selected(to_unsafe, FONT_SELECTED_TRAMPOLINE, @font_selected_userdata)
    end

    protected def emit_current_font_changed(handle : LibQt6::Handle) : Nil
      @current_font_changed.emit(QFont.wrap(handle, true))
    end

    protected def emit_font_selected(handle : LibQt6::Handle) : Nil
      @font_selected.emit(QFont.wrap(handle, true))
    end

    private CURRENT_FONT_CHANGED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(FontDialog).unbox(userdata).emit_current_font_changed(handle)
    end

    private FONT_SELECTED_TRAMPOLINE = ->(userdata : Void*, handle : Void*) do
      Box(FontDialog).unbox(userdata).emit_font_selected(handle)
    end
  end
end
