module Qt6
  # Wraps `QColorDialog`.
  class ColorDialog < Dialog
    @current_color_changed : Signal(Color) = Signal(Color).new
    @color_selected : Signal(Color) = Signal(Color).new
    @current_color_changed_userdata : LibQt6::Handle = Pointer(Void).null
    @color_selected_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_color_changed : Signal(Color)
    getter color_selected : Signal(Color)

    # Creates a color dialog with an optional parent widget and initial color.
    def initialize(parent : Widget? = nil, initial_color : Color? = nil)
      super(LibQt6.qt6cr_color_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      self.current_color = initial_color if initial_color
      register_color_callbacks
    end

    # Returns the currently selected color.
    def current_color : Color
      Color.from_native(LibQt6.qt6cr_color_dialog_current_color(to_unsafe))
    end

    # Sets the currently selected color.
    def current_color=(value : Color) : Color
      LibQt6.qt6cr_color_dialog_set_current_color(to_unsafe, value.to_native)
      value
    end

    # Returns the accepted color after the dialog closes.
    def selected_color : Color
      Color.from_native(LibQt6.qt6cr_color_dialog_selected_color(to_unsafe))
    end

    # Returns the enabled color-dialog options.
    def options : ColorDialogOption
      ColorDialogOption.from_value(LibQt6.qt6cr_color_dialog_options(to_unsafe))
    end

    # Sets the enabled color-dialog options.
    def options=(value : ColorDialogOption) : ColorDialogOption
      LibQt6.qt6cr_color_dialog_set_options(to_unsafe, value.value)
      value
    end

    # Returns `true` when the option is enabled.
    def option?(option : ColorDialogOption) : Bool
      LibQt6.qt6cr_color_dialog_test_option(to_unsafe, option.value)
    end

    # Enables or disables an option and returns `self`.
    def set_option(option : ColorDialogOption, value : Bool = true) : self
      LibQt6.qt6cr_color_dialog_set_option(to_unsafe, option.value, value)
      self
    end

    # Clears an option and returns `self`.
    def clear_option(option : ColorDialogOption) : self
      set_option(option, false)
    end

    # Returns `true` when Qt uses the platform-native color dialog.
    def native_dialog? : Bool
      LibQt6.qt6cr_color_dialog_native_dialog(to_unsafe)
    end

    # Enables or disables use of the platform-native color dialog.
    #
    # Turning this off is useful for deterministic automation in specs because
    # the Qt widget-backed dialog responds to `accept` like a normal dialog.
    def native_dialog=(value : Bool) : Bool
      LibQt6.qt6cr_color_dialog_set_native_dialog(to_unsafe, value)
      value
    end

    # Returns `true` when the alpha channel option is enabled.
    def show_alpha_channel? : Bool
      LibQt6.qt6cr_color_dialog_show_alpha_channel(to_unsafe)
    end

    # Enables or disables editing of the alpha channel.
    def show_alpha_channel=(value : Bool) : Bool
      LibQt6.qt6cr_color_dialog_set_show_alpha_channel(to_unsafe, value)
      value
    end

    # Registers a block to run when the current color changes.
    def on_current_color_changed(&block : Color ->) : self
      @current_color_changed.connect { |color| block.call(color) }
      self
    end

    # Registers a block to run when a color is selected.
    def on_color_selected(&block : Color ->) : self
      @color_selected.connect { |color| block.call(color) }
      self
    end

    # Returns the number of shared custom colors tracked by Qt.
    def self.custom_count : Int32
      LibQt6.qt6cr_color_dialog_custom_count
    end

    # Returns a shared custom color.
    def self.custom_color(index : Int) : Color
      Color.from_native(LibQt6.qt6cr_color_dialog_custom_color(index.to_i32))
    end

    # Updates a shared custom color and returns the assigned color.
    def self.set_custom_color(index : Int, value : Color) : Color
      LibQt6.qt6cr_color_dialog_set_custom_color(index.to_i32, value.to_native)
      value
    end

    # Returns a shared standard color.
    def self.standard_color(index : Int) : Color
      Color.from_native(LibQt6.qt6cr_color_dialog_standard_color(index.to_i32))
    end

    # Updates a shared standard color and returns the assigned color.
    def self.set_standard_color(index : Int, value : Color) : Color
      LibQt6.qt6cr_color_dialog_set_standard_color(index.to_i32, value.to_native)
      value
    end

    # Shows a modal color dialog and returns the chosen color, or `nil` if the
    # dialog is canceled.
    def self.get_color(parent : Widget? = nil, current_color : Color = Color.new(0, 0, 0), title : String = "Select Color", show_alpha_channel : Bool = false, options : ColorDialogOption = ColorDialogOption::None) : Color?
      dialog = new(parent, current_color)
      dialog.window_title = title
      dialog.options = options unless options.none?
      dialog.show_alpha_channel = show_alpha_channel
      begin
        dialog.exec == DialogCode::Accepted ? dialog.selected_color : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal color dialog, yields it for customization, and returns the
    # chosen color, or `nil` if the dialog is canceled.
    def self.get_color(parent : Widget? = nil, current_color : Color = Color.new(0, 0, 0), title : String = "Select Color", show_alpha_channel : Bool = false, options : ColorDialogOption = ColorDialogOption::None, &block : ColorDialog ->) : Color?
      dialog = new(parent, current_color)
      dialog.window_title = title
      dialog.options = options unless options.none?
      dialog.show_alpha_channel = show_alpha_channel
      begin
        yield dialog
        dialog.exec == DialogCode::Accepted ? dialog.selected_color : nil
      ensure
        dialog.release
      end
    end

    private def register_color_callbacks : Nil
      @current_color_changed = Signal(Color).new
      @color_selected = Signal(Color).new
      @current_color_changed_userdata = Box.box(self)
      @color_selected_userdata = Box.box(self)
      LibQt6.qt6cr_color_dialog_on_current_color_changed(to_unsafe, CURRENT_COLOR_CHANGED_TRAMPOLINE, @current_color_changed_userdata)
      LibQt6.qt6cr_color_dialog_on_color_selected(to_unsafe, COLOR_SELECTED_TRAMPOLINE, @color_selected_userdata)
    end

    protected def emit_current_color_changed : Nil
      @current_color_changed.emit(current_color)
    end

    protected def emit_color_selected : Nil
      @color_selected.emit(selected_color)
    end

    private CURRENT_COLOR_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(ColorDialog).unbox(userdata).emit_current_color_changed
    end

    private COLOR_SELECTED_TRAMPOLINE = ->(userdata : Void*) do
      Box(ColorDialog).unbox(userdata).emit_color_selected
    end
  end
end
