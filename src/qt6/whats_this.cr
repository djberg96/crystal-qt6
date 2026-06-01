module Qt6
  # Provides access to Qt's global `QWhatsThis` helper.
  module WhatsThis
    def self.enter_mode : Nil
      LibQt6.qt6cr_whats_this_enter_mode
    end

    def self.in_mode? : Bool
      LibQt6.qt6cr_whats_this_in_mode
    end

    def self.leave_mode : Nil
      LibQt6.qt6cr_whats_this_leave_mode
    end

    def self.show_text(widget : Widget, position : PointF, text : String) : Nil
      show_text(widget.map_to_global(Point.new(position.x.to_i, position.y.to_i)), text, widget)
    end

    def self.show_text(widget : Widget, position : Point, text : String) : Nil
      show_text(widget.map_to_global(position), text, widget)
    end

    def self.show_text(position : PointF, text : String, widget : Widget? = nil) : Nil
      show_text(Point.new(position.x.to_i, position.y.to_i), text, widget)
    end

    def self.show_text(position : Point, text : String, widget : Widget? = nil) : Nil
      LibQt6.qt6cr_whats_this_show_text(
        position.to_native,
        text.to_unsafe,
        widget.try(&.to_unsafe) || Pointer(Void).null
      )
    end

    def self.hide_text : Nil
      LibQt6.qt6cr_whats_this_hide_text
    end

    def self.create_action(parent : QObject? = nil) : Action
      Action.wrap(
        LibQt6.qt6cr_whats_this_create_action(parent.try(&.to_unsafe) || Pointer(Void).null),
        parent.nil?
      )
    end
  end
end
