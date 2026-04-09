module Qt6
  class ColorDialog < Dialog
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_color_dialog_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def current_color : Color
      Color.from_native(LibQt6.qt6cr_color_dialog_current_color(to_unsafe))
    end

    def current_color=(value : Color) : Color
      LibQt6.qt6cr_color_dialog_set_current_color(to_unsafe, value.to_native)
      value
    end

    def show_alpha_channel? : Bool
      LibQt6.qt6cr_color_dialog_show_alpha_channel(to_unsafe)
    end

    def show_alpha_channel=(value : Bool) : Bool
      LibQt6.qt6cr_color_dialog_set_show_alpha_channel(to_unsafe, value)
      value
    end

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