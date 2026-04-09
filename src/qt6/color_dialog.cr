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
  end
end