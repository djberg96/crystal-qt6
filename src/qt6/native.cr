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

    struct ColorValue
      red : LibC::Int
      green : LibC::Int
      blue : LibC::Int
      alpha : LibC::Int
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
    fun qt6cr_widget_grab = qt6cr_widget_grab(handle : Handle) : Handle

    fun qt6cr_main_window_create = qt6cr_main_window_create(parent : Handle) : Handle
    fun qt6cr_main_window_set_central_widget = qt6cr_main_window_set_central_widget(handle : Handle, widget : Handle)
    fun qt6cr_main_window_menu_bar = qt6cr_main_window_menu_bar(handle : Handle) : Handle
    fun qt6cr_main_window_status_bar = qt6cr_main_window_status_bar(handle : Handle) : Handle
    fun qt6cr_main_window_add_tool_bar = qt6cr_main_window_add_tool_bar(handle : Handle, toolbar : Handle)
    fun qt6cr_main_window_add_dock_widget = qt6cr_main_window_add_dock_widget(handle : Handle, area : LibC::Int, dock_widget : Handle)

    fun qt6cr_dialog_create = qt6cr_dialog_create(parent : Handle) : Handle
    fun qt6cr_dialog_exec = qt6cr_dialog_exec(handle : Handle) : LibC::Int
    fun qt6cr_dialog_accept = qt6cr_dialog_accept(handle : Handle)
    fun qt6cr_dialog_reject = qt6cr_dialog_reject(handle : Handle)
    fun qt6cr_dialog_result = qt6cr_dialog_result(handle : Handle) : LibC::Int
    fun qt6cr_dialog_on_accepted = qt6cr_dialog_on_accepted(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_dialog_on_rejected = qt6cr_dialog_on_rejected(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_message_box_create = qt6cr_message_box_create(parent : Handle) : Handle
    fun qt6cr_message_box_exec = qt6cr_message_box_exec(handle : Handle) : LibC::Int
    fun qt6cr_message_box_set_icon = qt6cr_message_box_set_icon(handle : Handle, icon : LibC::Int)
    fun qt6cr_message_box_icon = qt6cr_message_box_icon(handle : Handle) : LibC::Int
    fun qt6cr_message_box_set_text = qt6cr_message_box_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_message_box_text = qt6cr_message_box_text(handle : Handle) : UInt8*
    fun qt6cr_message_box_set_informative_text = qt6cr_message_box_set_informative_text(handle : Handle, text : UInt8*)
    fun qt6cr_message_box_informative_text = qt6cr_message_box_informative_text(handle : Handle) : UInt8*
    fun qt6cr_message_box_set_standard_buttons = qt6cr_message_box_set_standard_buttons(handle : Handle, buttons : LibC::Int)
    fun qt6cr_message_box_standard_buttons = qt6cr_message_box_standard_buttons(handle : Handle) : LibC::Int

    fun qt6cr_file_dialog_create = qt6cr_file_dialog_create(parent : Handle, directory : UInt8*, filter : UInt8*) : Handle
    fun qt6cr_file_dialog_set_accept_mode = qt6cr_file_dialog_set_accept_mode(handle : Handle, accept_mode : LibC::Int)
    fun qt6cr_file_dialog_accept_mode = qt6cr_file_dialog_accept_mode(handle : Handle) : LibC::Int
    fun qt6cr_file_dialog_set_file_mode = qt6cr_file_dialog_set_file_mode(handle : Handle, file_mode : LibC::Int)
    fun qt6cr_file_dialog_file_mode = qt6cr_file_dialog_file_mode(handle : Handle) : LibC::Int
    fun qt6cr_file_dialog_set_directory = qt6cr_file_dialog_set_directory(handle : Handle, directory : UInt8*)
    fun qt6cr_file_dialog_directory = qt6cr_file_dialog_directory(handle : Handle) : UInt8*
    fun qt6cr_file_dialog_set_name_filter = qt6cr_file_dialog_set_name_filter(handle : Handle, filter : UInt8*)
    fun qt6cr_file_dialog_name_filter = qt6cr_file_dialog_name_filter(handle : Handle) : UInt8*
    fun qt6cr_file_dialog_select_file = qt6cr_file_dialog_select_file(handle : Handle, path : UInt8*)
    fun qt6cr_file_dialog_selected_file = qt6cr_file_dialog_selected_file(handle : Handle) : UInt8*

    fun qt6cr_color_dialog_create = qt6cr_color_dialog_create(parent : Handle) : Handle
    fun qt6cr_color_dialog_set_current_color = qt6cr_color_dialog_set_current_color(handle : Handle, color : ColorValue)
    fun qt6cr_color_dialog_current_color = qt6cr_color_dialog_current_color(handle : Handle) : ColorValue
    fun qt6cr_color_dialog_set_show_alpha_channel = qt6cr_color_dialog_set_show_alpha_channel(handle : Handle, value : Bool)
    fun qt6cr_color_dialog_show_alpha_channel = qt6cr_color_dialog_show_alpha_channel(handle : Handle) : Bool

    fun qt6cr_qimage_create = qt6cr_qimage_create(width : LibC::Int, height : LibC::Int, format : LibC::Int) : Handle
    fun qt6cr_qimage_destroy = qt6cr_qimage_destroy(handle : Handle)
    fun qt6cr_qimage_width = qt6cr_qimage_width(handle : Handle) : LibC::Int
    fun qt6cr_qimage_height = qt6cr_qimage_height(handle : Handle) : LibC::Int
    fun qt6cr_qimage_is_null = qt6cr_qimage_is_null(handle : Handle) : Bool
    fun qt6cr_qimage_fill = qt6cr_qimage_fill(handle : Handle, color : ColorValue)
    fun qt6cr_qimage_save = qt6cr_qimage_save(handle : Handle, path : UInt8*) : Bool
    fun qt6cr_qimage_pixel_color = qt6cr_qimage_pixel_color(handle : Handle, x : LibC::Int, y : LibC::Int) : ColorValue
    fun qt6cr_qimage_set_pixel_color = qt6cr_qimage_set_pixel_color(handle : Handle, x : LibC::Int, y : LibC::Int, color : ColorValue)

    fun qt6cr_qpixmap_create = qt6cr_qpixmap_create(width : LibC::Int, height : LibC::Int) : Handle
    fun qt6cr_qpixmap_destroy = qt6cr_qpixmap_destroy(handle : Handle)
    fun qt6cr_qpixmap_from_image = qt6cr_qpixmap_from_image(image : Handle) : Handle
    fun qt6cr_qpixmap_to_image = qt6cr_qpixmap_to_image(handle : Handle) : Handle
    fun qt6cr_qpixmap_width = qt6cr_qpixmap_width(handle : Handle) : LibC::Int
    fun qt6cr_qpixmap_height = qt6cr_qpixmap_height(handle : Handle) : LibC::Int
    fun qt6cr_qpixmap_is_null = qt6cr_qpixmap_is_null(handle : Handle) : Bool
    fun qt6cr_qpixmap_fill = qt6cr_qpixmap_fill(handle : Handle, color : ColorValue)
    fun qt6cr_qpixmap_save = qt6cr_qpixmap_save(handle : Handle, path : UInt8*) : Bool

    fun qt6cr_qpen_create = qt6cr_qpen_create(color : ColorValue, width : Float64) : Handle
    fun qt6cr_qpen_destroy = qt6cr_qpen_destroy(handle : Handle)
    fun qt6cr_qpen_color = qt6cr_qpen_color(handle : Handle) : ColorValue
    fun qt6cr_qpen_set_color = qt6cr_qpen_set_color(handle : Handle, color : ColorValue)
    fun qt6cr_qpen_width = qt6cr_qpen_width(handle : Handle) : Float64
    fun qt6cr_qpen_set_width = qt6cr_qpen_set_width(handle : Handle, width : Float64)

    fun qt6cr_qbrush_create = qt6cr_qbrush_create(color : ColorValue) : Handle
    fun qt6cr_qbrush_destroy = qt6cr_qbrush_destroy(handle : Handle)
    fun qt6cr_qbrush_color = qt6cr_qbrush_color(handle : Handle) : ColorValue
    fun qt6cr_qbrush_set_color = qt6cr_qbrush_set_color(handle : Handle, color : ColorValue)

    fun qt6cr_qfont_create = qt6cr_qfont_create(family : UInt8*, point_size : LibC::Int, bold : Bool, italic : Bool) : Handle
    fun qt6cr_qfont_destroy = qt6cr_qfont_destroy(handle : Handle)
    fun qt6cr_qfont_family = qt6cr_qfont_family(handle : Handle) : UInt8*
    fun qt6cr_qfont_set_family = qt6cr_qfont_set_family(handle : Handle, family : UInt8*)
    fun qt6cr_qfont_point_size = qt6cr_qfont_point_size(handle : Handle) : LibC::Int
    fun qt6cr_qfont_set_point_size = qt6cr_qfont_set_point_size(handle : Handle, point_size : LibC::Int)
    fun qt6cr_qfont_bold = qt6cr_qfont_bold(handle : Handle) : Bool
    fun qt6cr_qfont_set_bold = qt6cr_qfont_set_bold(handle : Handle, value : Bool)
    fun qt6cr_qfont_italic = qt6cr_qfont_italic(handle : Handle) : Bool
    fun qt6cr_qfont_set_italic = qt6cr_qfont_set_italic(handle : Handle, value : Bool)

    fun qt6cr_qtransform_create = qt6cr_qtransform_create : Handle
    fun qt6cr_qtransform_destroy = qt6cr_qtransform_destroy(handle : Handle)
    fun qt6cr_qtransform_copy = qt6cr_qtransform_copy(handle : Handle) : Handle
    fun qt6cr_qtransform_reset = qt6cr_qtransform_reset(handle : Handle)
    fun qt6cr_qtransform_translate = qt6cr_qtransform_translate(handle : Handle, dx : Float64, dy : Float64)
    fun qt6cr_qtransform_scale = qt6cr_qtransform_scale(handle : Handle, sx : Float64, sy : Float64)
    fun qt6cr_qtransform_rotate = qt6cr_qtransform_rotate(handle : Handle, angle : Float64)
    fun qt6cr_qtransform_map_point = qt6cr_qtransform_map_point(handle : Handle, point : PointFValue) : PointFValue
    fun qt6cr_qtransform_map_rect = qt6cr_qtransform_map_rect(handle : Handle, rect : RectFValue) : RectFValue

    fun qt6cr_qpainter_path_create = qt6cr_qpainter_path_create : Handle
    fun qt6cr_qpainter_path_destroy = qt6cr_qpainter_path_destroy(handle : Handle)
    fun qt6cr_qpainter_path_move_to = qt6cr_qpainter_path_move_to(handle : Handle, point : PointFValue)
    fun qt6cr_qpainter_path_line_to = qt6cr_qpainter_path_line_to(handle : Handle, point : PointFValue)
    fun qt6cr_qpainter_path_quad_to = qt6cr_qpainter_path_quad_to(handle : Handle, control_point : PointFValue, end_point : PointFValue)
    fun qt6cr_qpainter_path_cubic_to = qt6cr_qpainter_path_cubic_to(handle : Handle, control_point1 : PointFValue, control_point2 : PointFValue, end_point : PointFValue)
    fun qt6cr_qpainter_path_add_rect = qt6cr_qpainter_path_add_rect(handle : Handle, rect : RectFValue)
    fun qt6cr_qpainter_path_add_ellipse = qt6cr_qpainter_path_add_ellipse(handle : Handle, rect : RectFValue)
    fun qt6cr_qpainter_path_close_subpath = qt6cr_qpainter_path_close_subpath(handle : Handle)
    fun qt6cr_qpainter_path_bounding_rect = qt6cr_qpainter_path_bounding_rect(handle : Handle) : RectFValue
    fun qt6cr_qpainter_path_transformed = qt6cr_qpainter_path_transformed(handle : Handle, transform : Handle) : Handle

    fun qt6cr_qpainter_create_for_image = qt6cr_qpainter_create_for_image(image : Handle) : Handle
    fun qt6cr_qpainter_create_for_pixmap = qt6cr_qpainter_create_for_pixmap(pixmap : Handle) : Handle
    fun qt6cr_qpainter_destroy = qt6cr_qpainter_destroy(handle : Handle)
    fun qt6cr_qpainter_is_active = qt6cr_qpainter_is_active(handle : Handle) : Bool
    fun qt6cr_qpainter_set_antialiasing = qt6cr_qpainter_set_antialiasing(handle : Handle, value : Bool)
    fun qt6cr_qpainter_set_pen_color = qt6cr_qpainter_set_pen_color(handle : Handle, color : ColorValue)
    fun qt6cr_qpainter_set_pen = qt6cr_qpainter_set_pen(handle : Handle, pen : Handle)
    fun qt6cr_qpainter_set_brush_color = qt6cr_qpainter_set_brush_color(handle : Handle, color : ColorValue)
    fun qt6cr_qpainter_set_brush = qt6cr_qpainter_set_brush(handle : Handle, brush : Handle)
    fun qt6cr_qpainter_set_font = qt6cr_qpainter_set_font(handle : Handle, font : Handle)
    fun qt6cr_qpainter_set_transform = qt6cr_qpainter_set_transform(handle : Handle, transform : Handle)
    fun qt6cr_qpainter_reset_transform = qt6cr_qpainter_reset_transform(handle : Handle)
    fun qt6cr_qpainter_draw_line = qt6cr_qpainter_draw_line(handle : Handle, from_point : PointFValue, to_point : PointFValue)
    fun qt6cr_qpainter_draw_rect = qt6cr_qpainter_draw_rect(handle : Handle, rect : RectFValue)
    fun qt6cr_qpainter_fill_rect = qt6cr_qpainter_fill_rect(handle : Handle, rect : RectFValue, color : ColorValue)
    fun qt6cr_qpainter_draw_ellipse = qt6cr_qpainter_draw_ellipse(handle : Handle, rect : RectFValue)
    fun qt6cr_qpainter_draw_path = qt6cr_qpainter_draw_path(handle : Handle, path : Handle)
    fun qt6cr_qpainter_draw_image = qt6cr_qpainter_draw_image(handle : Handle, position : PointFValue, image : Handle)
    fun qt6cr_qpainter_draw_pixmap = qt6cr_qpainter_draw_pixmap(handle : Handle, position : PointFValue, pixmap : Handle)
    fun qt6cr_qpainter_draw_text = qt6cr_qpainter_draw_text(handle : Handle, position : PointFValue, text : UInt8*)

    fun qt6cr_input_dialog_create = qt6cr_input_dialog_create(parent : Handle) : Handle
    fun qt6cr_input_dialog_set_input_mode = qt6cr_input_dialog_set_input_mode(handle : Handle, input_mode : LibC::Int)
    fun qt6cr_input_dialog_input_mode = qt6cr_input_dialog_input_mode(handle : Handle) : LibC::Int
    fun qt6cr_input_dialog_set_label_text = qt6cr_input_dialog_set_label_text(handle : Handle, text : UInt8*)
    fun qt6cr_input_dialog_label_text = qt6cr_input_dialog_label_text(handle : Handle) : UInt8*
    fun qt6cr_input_dialog_set_text_value = qt6cr_input_dialog_set_text_value(handle : Handle, text : UInt8*)
    fun qt6cr_input_dialog_text_value = qt6cr_input_dialog_text_value(handle : Handle) : UInt8*
    fun qt6cr_input_dialog_set_int_value = qt6cr_input_dialog_set_int_value(handle : Handle, value : LibC::Int)
    fun qt6cr_input_dialog_int_value = qt6cr_input_dialog_int_value(handle : Handle) : LibC::Int
    fun qt6cr_input_dialog_set_int_range = qt6cr_input_dialog_set_int_range(handle : Handle, minimum : LibC::Int, maximum : LibC::Int)
    fun qt6cr_input_dialog_int_minimum = qt6cr_input_dialog_int_minimum(handle : Handle) : LibC::Int
    fun qt6cr_input_dialog_int_maximum = qt6cr_input_dialog_int_maximum(handle : Handle) : LibC::Int
    fun qt6cr_input_dialog_set_double_value = qt6cr_input_dialog_set_double_value(handle : Handle, value : Float64)
    fun qt6cr_input_dialog_double_value = qt6cr_input_dialog_double_value(handle : Handle) : Float64
    fun qt6cr_input_dialog_set_double_range = qt6cr_input_dialog_set_double_range(handle : Handle, minimum : Float64, maximum : Float64)
    fun qt6cr_input_dialog_double_minimum = qt6cr_input_dialog_double_minimum(handle : Handle) : Float64
    fun qt6cr_input_dialog_double_maximum = qt6cr_input_dialog_double_maximum(handle : Handle) : Float64

    fun qt6cr_dock_widget_create = qt6cr_dock_widget_create(parent : Handle, title : UInt8*) : Handle
    fun qt6cr_dock_widget_set_widget = qt6cr_dock_widget_set_widget(handle : Handle, widget : Handle)

    fun qt6cr_action_create = qt6cr_action_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_action_set_text = qt6cr_action_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_action_text = qt6cr_action_text(handle : Handle) : UInt8*
    fun qt6cr_action_set_shortcut = qt6cr_action_set_shortcut(handle : Handle, shortcut : UInt8*)
    fun qt6cr_action_shortcut = qt6cr_action_shortcut(handle : Handle) : UInt8*
    fun qt6cr_action_set_checkable = qt6cr_action_set_checkable(handle : Handle, value : Bool)
    fun qt6cr_action_is_checkable = qt6cr_action_is_checkable(handle : Handle) : Bool
    fun qt6cr_action_set_checked = qt6cr_action_set_checked(handle : Handle, value : Bool)
    fun qt6cr_action_is_checked = qt6cr_action_is_checked(handle : Handle) : Bool
    fun qt6cr_action_on_triggered = qt6cr_action_on_triggered(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_action_trigger = qt6cr_action_trigger(handle : Handle)

    fun qt6cr_action_group_create = qt6cr_action_group_create(parent : Handle) : Handle
    fun qt6cr_action_group_add_action = qt6cr_action_group_add_action(handle : Handle, action : Handle)
    fun qt6cr_action_group_set_exclusive = qt6cr_action_group_set_exclusive(handle : Handle, value : Bool)
    fun qt6cr_action_group_is_exclusive = qt6cr_action_group_is_exclusive(handle : Handle) : Bool

    fun qt6cr_menu_bar_add_menu = qt6cr_menu_bar_add_menu(handle : Handle, title : UInt8*) : Handle

    fun qt6cr_menu_add_menu = qt6cr_menu_add_menu(handle : Handle, title : UInt8*) : Handle
    fun qt6cr_menu_add_action = qt6cr_menu_add_action(handle : Handle, action : Handle)
    fun qt6cr_menu_add_separator = qt6cr_menu_add_separator(handle : Handle)
    fun qt6cr_menu_set_title = qt6cr_menu_set_title(handle : Handle, title : UInt8*)
    fun qt6cr_menu_title = qt6cr_menu_title(handle : Handle) : UInt8*

    fun qt6cr_tool_bar_create = qt6cr_tool_bar_create(parent : Handle, title : UInt8*) : Handle
    fun qt6cr_tool_bar_add_action = qt6cr_tool_bar_add_action(handle : Handle, action : Handle)

    fun qt6cr_status_bar_create = qt6cr_status_bar_create(parent : Handle) : Handle
    fun qt6cr_status_bar_show_message = qt6cr_status_bar_show_message(handle : Handle, message : UInt8*, timeout_ms : LibC::Int)
    fun qt6cr_status_bar_current_message = qt6cr_status_bar_current_message(handle : Handle) : UInt8*
    fun qt6cr_status_bar_clear_message = qt6cr_status_bar_clear_message(handle : Handle)

    fun qt6cr_event_widget_create = qt6cr_event_widget_create(parent : Handle) : Handle
    fun qt6cr_event_widget_on_paint = qt6cr_event_widget_on_paint(handle : Handle, callback : (Handle, RectFValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_paint_with_painter = qt6cr_event_widget_on_paint_with_painter(handle : Handle, callback : (Handle, Handle, RectFValue ->), userdata : Handle)
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

    fun qt6cr_line_edit_create = qt6cr_line_edit_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_line_edit_set_text = qt6cr_line_edit_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_line_edit_text = qt6cr_line_edit_text(handle : Handle) : UInt8*

    fun qt6cr_check_box_create = qt6cr_check_box_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_check_box_set_text = qt6cr_check_box_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_check_box_text = qt6cr_check_box_text(handle : Handle) : UInt8*
    fun qt6cr_check_box_set_checked = qt6cr_check_box_set_checked(handle : Handle, value : Bool)
    fun qt6cr_check_box_is_checked = qt6cr_check_box_is_checked(handle : Handle) : Bool
    fun qt6cr_check_box_on_toggled = qt6cr_check_box_on_toggled(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)

    fun qt6cr_combo_box_create = qt6cr_combo_box_create(parent : Handle) : Handle
    fun qt6cr_combo_box_add_item = qt6cr_combo_box_add_item(handle : Handle, text : UInt8*)
    fun qt6cr_combo_box_count = qt6cr_combo_box_count(handle : Handle) : LibC::Int
    fun qt6cr_combo_box_current_index = qt6cr_combo_box_current_index(handle : Handle) : LibC::Int
    fun qt6cr_combo_box_set_current_index = qt6cr_combo_box_set_current_index(handle : Handle, index : LibC::Int)
    fun qt6cr_combo_box_current_text = qt6cr_combo_box_current_text(handle : Handle) : UInt8*
    fun qt6cr_combo_box_on_current_index_changed = qt6cr_combo_box_on_current_index_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

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

    fun qt6cr_h_box_layout_create = qt6cr_h_box_layout_create(parent_widget : Handle) : Handle
    fun qt6cr_h_box_layout_add_widget = qt6cr_h_box_layout_add_widget(handle : Handle, widget : Handle)

    fun qt6cr_grid_layout_create = qt6cr_grid_layout_create(parent_widget : Handle) : Handle
    fun qt6cr_grid_layout_add_widget = qt6cr_grid_layout_add_widget(handle : Handle, widget : Handle, row : LibC::Int, column : LibC::Int, row_span : LibC::Int, column_span : LibC::Int)

    fun qt6cr_form_layout_create = qt6cr_form_layout_create(parent_widget : Handle) : Handle
    fun qt6cr_form_layout_add_row_label_widget = qt6cr_form_layout_add_row_label_widget(handle : Handle, label : UInt8*, field_widget : Handle)
    fun qt6cr_form_layout_add_row_widget_widget = qt6cr_form_layout_add_row_widget_widget(handle : Handle, label_widget : Handle, field_widget : Handle)
    fun qt6cr_form_layout_add_row_widget = qt6cr_form_layout_add_row_widget(handle : Handle, widget : Handle)

    fun qt6cr_string_free = qt6cr_string_free(value : UInt8*)
  end
end
