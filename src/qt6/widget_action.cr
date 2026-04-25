module Qt6
  # Wraps `QWidgetAction` for embedding widgets inside menus.
  class WidgetAction < Action
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_widget_action_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def default_widget : Widget?
      handle = LibQt6.qt6cr_widget_action_default_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    def default_widget=(widget : Widget?) : Widget?
      LibQt6.qt6cr_widget_action_set_default_widget(to_unsafe, widget.try(&.to_unsafe) || Pointer(Void).null)
      widget.try(&.adopt_by_parent!)
      widget
    end
  end
end
