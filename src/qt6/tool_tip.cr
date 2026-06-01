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
      show_text(widget, Point.new(position.x.to_i, position.y.to_i), text, nil, msec_display_time)
    end

    def self.show_text(widget : Widget, position : Point, text : String, rect : Rect? = nil, msec_display_time : Int = -1) : Nil
      show_text(widget.map_to_global(position), text, widget, rect, msec_display_time)
    end

    def self.show_text(position : PointF, text : String, widget : Widget? = nil, rect : Rect? = nil, msec_display_time : Int = -1) : Nil
      show_text(Point.new(position.x.to_i, position.y.to_i), text, widget, rect, msec_display_time)
    end

    def self.show_text(position : Point, text : String, widget : Widget? = nil, rect : Rect? = nil, msec_display_time : Int = -1) : Nil
      LibQt6.qt6cr_tool_tip_show_text_at(
        widget.try(&.to_unsafe) || Pointer(Void).null,
        position.to_native,
        text.to_unsafe,
        (rect || Rect.new(0, 0, 0, 0)).to_native,
        msec_display_time.to_i32
      )
    end

    def self.text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tool_tip_text)
    end
  end
end
