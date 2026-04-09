{% unless env("QT6CR_SKIP_BUILD") == "1" %}
  {% build_output = system(%(sh "#{__DIR__}/../../scripts/build_qt6cr.sh")) %}
{% end %}

module Qt6
  {% if flag?(:darwin) %}
    @[Link(ldflags: "-L#{__DIR__}/../../ext/qt6cr/build -lqt6cr -lc++", pkg_config: "Qt6Widgets")]
  {% else %}
    @[Link(ldflags: "-L#{__DIR__}/../../ext/qt6cr/build -lqt6cr -lstdc++", pkg_config: "Qt6Widgets")]
  {% end %}
  lib LibQt6
    alias Handle = Void*

    struct PointFValue
      x : Float64
      y : Float64
    end

    struct SizeValue
      width : LibC::Int
      height : LibC::Int
    end

    struct RectFValue
      x : Float64
      y : Float64
      width : Float64
      height : Float64
    end

    struct MouseEventValue
      position : PointFValue
      button : LibC::Int
      buttons : LibC::Int
      modifiers : LibC::Int
    end

    struct WheelEventValue
      position : PointFValue
      pixel_delta : PointFValue
      angle_delta : PointFValue
      buttons : LibC::Int
      modifiers : LibC::Int
    end

    struct KeyEventValue
      key : LibC::Int
      modifiers : LibC::Int
      auto_repeat : Bool
      count : LibC::Int
    end

    fun qt6cr_object_destroy = qt6cr_object_destroy(handle : Handle)
    fun qt6cr_object_on_destroyed = qt6cr_object_on_destroyed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_application_create = qt6cr_application_create(argc : LibC::Int, argv : UInt8**) : Handle
    fun qt6cr_application_destroy = qt6cr_application_destroy(handle : Handle)
    fun qt6cr_application_exec = qt6cr_application_exec(handle : Handle) : LibC::Int
    fun qt6cr_application_process_events = qt6cr_application_process_events(handle : Handle)
    fun qt6cr_application_quit = qt6cr_application_quit(handle : Handle)

    fun qt6cr_widget_create = qt6cr_widget_create(parent : Handle) : Handle
    fun qt6cr_widget_destroy = qt6cr_widget_destroy(handle : Handle)
    fun qt6cr_widget_show = qt6cr_widget_show(handle : Handle)
    fun qt6cr_widget_close = qt6cr_widget_close(handle : Handle)
    fun qt6cr_widget_resize = qt6cr_widget_resize(handle : Handle, width : LibC::Int, height : LibC::Int)
    fun qt6cr_widget_set_window_title = qt6cr_widget_set_window_title(handle : Handle, title : UInt8*)
    fun qt6cr_widget_window_title = qt6cr_widget_window_title(handle : Handle) : UInt8*
    fun qt6cr_widget_is_visible = qt6cr_widget_is_visible(handle : Handle) : Bool
    fun qt6cr_widget_size = qt6cr_widget_size(handle : Handle) : SizeValue
    fun qt6cr_widget_rect = qt6cr_widget_rect(handle : Handle) : RectFValue
    fun qt6cr_widget_update = qt6cr_widget_update(handle : Handle)

    fun qt6cr_event_widget_create = qt6cr_event_widget_create(parent : Handle) : Handle
    fun qt6cr_event_widget_on_paint = qt6cr_event_widget_on_paint(handle : Handle, callback : (Handle, RectFValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_resize = qt6cr_event_widget_on_resize(handle : Handle, callback : (Handle, SizeValue, SizeValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_mouse_press = qt6cr_event_widget_on_mouse_press(handle : Handle, callback : (Handle, MouseEventValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_mouse_move = qt6cr_event_widget_on_mouse_move(handle : Handle, callback : (Handle, MouseEventValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_mouse_release = qt6cr_event_widget_on_mouse_release(handle : Handle, callback : (Handle, MouseEventValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_wheel = qt6cr_event_widget_on_wheel(handle : Handle, callback : (Handle, WheelEventValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_key_press = qt6cr_event_widget_on_key_press(handle : Handle, callback : (Handle, KeyEventValue ->), userdata : Handle)
    fun qt6cr_event_widget_repaint = qt6cr_event_widget_repaint(handle : Handle)
    fun qt6cr_event_widget_send_mouse_press = qt6cr_event_widget_send_mouse_press(handle : Handle, position : PointFValue, button : LibC::Int, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_mouse_move = qt6cr_event_widget_send_mouse_move(handle : Handle, position : PointFValue, button : LibC::Int, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_mouse_release = qt6cr_event_widget_send_mouse_release(handle : Handle, position : PointFValue, button : LibC::Int, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_wheel = qt6cr_event_widget_send_wheel(handle : Handle, position : PointFValue, pixel_delta : PointFValue, angle_delta : PointFValue, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_key_press = qt6cr_event_widget_send_key_press(handle : Handle, key : LibC::Int, modifiers : LibC::Int, auto_repeat : Bool, count : LibC::Int)

    fun qt6cr_label_create = qt6cr_label_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_label_set_text = qt6cr_label_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_label_text = qt6cr_label_text(handle : Handle) : UInt8*

    fun qt6cr_push_button_create = qt6cr_push_button_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_push_button_set_text = qt6cr_push_button_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_push_button_text = qt6cr_push_button_text(handle : Handle) : UInt8*
    fun qt6cr_push_button_on_clicked = qt6cr_push_button_on_clicked(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_push_button_click = qt6cr_push_button_click(handle : Handle)

    fun qt6cr_timer_create = qt6cr_timer_create(parent : Handle) : Handle
    fun qt6cr_timer_set_interval = qt6cr_timer_set_interval(handle : Handle, interval : LibC::Int)
    fun qt6cr_timer_interval = qt6cr_timer_interval(handle : Handle) : LibC::Int
    fun qt6cr_timer_set_single_shot = qt6cr_timer_set_single_shot(handle : Handle, value : Bool)
    fun qt6cr_timer_is_single_shot = qt6cr_timer_is_single_shot(handle : Handle) : Bool
    fun qt6cr_timer_is_active = qt6cr_timer_is_active(handle : Handle) : Bool
    fun qt6cr_timer_start = qt6cr_timer_start(handle : Handle)
    fun qt6cr_timer_stop = qt6cr_timer_stop(handle : Handle)
    fun qt6cr_timer_on_timeout = qt6cr_timer_on_timeout(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_v_box_layout_create = qt6cr_v_box_layout_create(parent_widget : Handle) : Handle
    fun qt6cr_v_box_layout_add_widget = qt6cr_v_box_layout_add_widget(handle : Handle, widget : Handle)

    fun qt6cr_string_free = qt6cr_string_free(value : UInt8*)
  end
end
