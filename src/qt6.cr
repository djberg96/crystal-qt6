require "./qt6/native"
require "./qt6/error"
require "./qt6/point_f"
require "./qt6/size"
require "./qt6/rect_f"
require "./qt6/paint_event"
require "./qt6/resize_event"
require "./qt6/mouse_event"
require "./qt6/wheel_event"
require "./qt6/key_event"
require "./qt6/signal"
require "./qt6/application"
require "./qt6/q_object"
require "./qt6/dock_area"
require "./qt6/dialog_code"
require "./qt6/widget"
require "./qt6/action"
require "./qt6/menu"
require "./qt6/menu_bar"
require "./qt6/status_bar"
require "./qt6/tool_bar"
require "./qt6/main_window"
require "./qt6/dialog"
require "./qt6/dock_widget"
require "./qt6/event_widget"
require "./qt6/label"
require "./qt6/push_button"
require "./qt6/line_edit"
require "./qt6/check_box"
require "./qt6/combo_box"
require "./qt6/q_timer"
require "./qt6/v_box_layout"

module Qt6
  VERSION = "0.1.0"
  @@application : Application?
  @@tracked_objects = [] of QObject
  @@shutdown_registered = false

  def self.application(args : Enumerable(String) = ARGV)
    register_shutdown_hook
    @@application ||= Application.new(args.to_a)
  end

  def self.shutdown : Nil
    tracked_objects = @@tracked_objects.dup
    tracked_objects.reverse_each(&.release)
    @@tracked_objects.clear

    application = @@application
    return unless application

    application.shutdown
    @@application = nil
  end

  def self.window(title : String, width : Int32 = 800, height : Int32 = 600, &)
    widget = Widget.new
    widget.window_title = title
    widget.resize(width, height)
    yield widget
    widget
  end

  def self.copy_and_release_string(pointer : UInt8*) : String
    return "" if pointer.null?

    value = String.new(pointer)
    LibQt6.qt6cr_string_free(pointer)
    value
  end

  def self.track_object(object : QObject) : Nil
    @@tracked_objects << object
  end

  def self.untrack_object(object : QObject) : Nil
    @@tracked_objects.delete(object)
  end

  private def self.register_shutdown_hook : Nil
    return if @@shutdown_registered

    at_exit { Qt6.shutdown }
    @@shutdown_registered = true
  end
end
