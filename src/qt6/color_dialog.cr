module Qt6
  # Wraps `QColorDialog`.
  class ColorDialog < Dialog
    # Creates a color dialog with an optional parent widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_color_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
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

    # Returns `true` when the alpha channel option is enabled.
    def show_alpha_channel? : Bool
      LibQt6.qt6cr_color_dialog_show_alpha_channel(to_unsafe)
    end

    # Enables or disables editing of the alpha channel.
    def show_alpha_channel=(value : Bool) : Bool
      LibQt6.qt6cr_color_dialog_set_show_alpha_channel(to_unsafe, value)
      value
    end

    # Shows a modal color dialog and returns the chosen color, or `nil` if the
    # dialog is canceled.
    def self.get_color(parent : Widget? = nil, current_color : Color = Color.new(0, 0, 0), title : String = "Select Color", show_alpha_channel : Bool = false) : Color?
      dialog = new(parent)
      dialog.window_title = title
      dialog.current_color = current_color
      dialog.show_alpha_channel = show_alpha_channel
      begin
        dialog.exec == DialogCode::Accepted ? dialog.current_color : nil
      ensure
        dialog.release
      end
    end

    # Shows a modal color dialog, yields it for customization, and returns the
    # chosen color, or `nil` if the dialog is canceled.
    def self.get_color(parent : Widget? = nil, current_color : Color = Color.new(0, 0, 0), title : String = "Select Color", show_alpha_channel : Bool = false, &block : ColorDialog ->) : Color?
      dialog = new(parent)
      dialog.window_title = title
      dialog.current_color = current_color
      dialog.show_alpha_channel = show_alpha_channel
      begin
        yield dialog
        dialog.exec == DialogCode::Accepted ? dialog.current_color : nil
      ensure
        dialog.release
      end
    end
  end
end