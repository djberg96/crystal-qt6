module Qt6
  # Provides access to Qt's global `QToolTip` helper.
  module ToolTip
    def self.font : QFont
      QFont.wrap(LibQt6.qt6cr_tool_tip_font, true)
    end

    def self.font=(value : QFont) : QFont
      LibQt6.qt6cr_tool_tip_set_font(value.to_unsafe)
      value
    end

    def self.hide_text : Nil
      LibQt6.qt6cr_tool_tip_hide_text
    end

    def self.visible? : Bool
      LibQt6.qt6cr_tool_tip_is_visible
    end

    def self.palette : QPalette
      QPalette.wrap(LibQt6.qt6cr_tool_tip_palette, true)
    end

    def self.palette=(value : QPalette) : QPalette
      LibQt6.qt6cr_tool_tip_set_palette(value.to_unsafe)
      value
    end

    def self.show_text(widget : Widget, position : PointF, text : String, msec_display_time : Int = -1) : Nil
      LibQt6.qt6cr_tool_tip_show_text(widget.to_unsafe, position.to_native, text.to_unsafe, msec_display_time.to_i32)
    end

    def self.text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tool_tip_text)
    end
  end
end
