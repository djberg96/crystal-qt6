{% unless env("QT6CR_SKIP_BUILD") == "1" %}
  {% build_output = system(%(sh "#{__DIR__}/../../scripts/build_qt6cr.sh")) %}
{% end %}

module Qt6
  {% if flag?(:darwin) %}
    @[Link(ldflags: "-L#{__DIR__}/../../ext/qt6cr/build -lqt6cr -lc++", pkg_config: "Qt6Widgets Qt6Svg Qt6SvgWidgets")]
  {% else %}
    @[Link(ldflags: "-L#{__DIR__}/../../ext/qt6cr/build -lqt6cr -lstdc++", pkg_config: "Qt6Widgets Qt6Svg Qt6SvgWidgets")]
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

    struct SizeFValue
      width : Float64
      height : Float64
    end

    struct RectFValue
      x : Float64
      y : Float64
      width : Float64
      height : Float64
    end

    struct PainterPathElementValue
      x : Float64
      y : Float64
      type : LibC::Int
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

    struct ByteArrayValue
      data : UInt8*
      size : LibC::Int
    end

    struct StringArrayValue
      data : UInt8**
      size : LibC::Int
    end

    struct VariantValue
      type : LibC::Int
      bool_value : Bool
      int_value : LibC::Int
      double_value : Float64
      color_value : ColorValue
      string_value : UInt8*
    end

    struct ModelIndexSpecValue
      valid : Bool
      row : LibC::Int
      column : LibC::Int
      internal_id : UInt64
    end

    fun qt6cr_object_destroy = qt6cr_object_destroy(handle : Handle)
    fun qt6cr_object_on_destroyed = qt6cr_object_on_destroyed(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_object_block_signals = qt6cr_object_block_signals(handle : Handle, block : Bool) : Bool
    fun qt6cr_object_signals_blocked = qt6cr_object_signals_blocked(handle : Handle) : Bool
    fun qt6cr_object_install_event_filter = qt6cr_object_install_event_filter(handle : Handle, filter : Handle)
    fun qt6cr_object_remove_event_filter = qt6cr_object_remove_event_filter(handle : Handle, filter : Handle)
    fun qt6cr_event_filter_create = qt6cr_event_filter_create(parent : Handle) : Handle
    fun qt6cr_event_filter_on_event = qt6cr_event_filter_on_event(handle : Handle, callback : (Handle, Handle, Handle -> Bool), userdata : Handle)
    fun qt6cr_event_type = qt6cr_event_type(handle : Handle) : LibC::Int
    fun qt6cr_event_accept = qt6cr_event_accept(handle : Handle)
    fun qt6cr_event_ignore = qt6cr_event_ignore(handle : Handle)
    fun qt6cr_event_is_accepted = qt6cr_event_is_accepted(handle : Handle) : Bool

    fun qt6cr_application_create = qt6cr_application_create(argc : LibC::Int, argv : UInt8**) : Handle
    fun qt6cr_application_destroy = qt6cr_application_destroy(handle : Handle)
    fun qt6cr_application_exec = qt6cr_application_exec(handle : Handle) : LibC::Int
    fun qt6cr_application_process_events = qt6cr_application_process_events(handle : Handle)
    fun qt6cr_application_invoke_later = qt6cr_application_invoke_later(handle : Handle, callback : (Handle ->), userdata : Handle) : Bool
    fun qt6cr_application_quit = qt6cr_application_quit(handle : Handle)
    fun qt6cr_application_clipboard = qt6cr_application_clipboard(handle : Handle) : Handle
    fun qt6cr_application_name = qt6cr_application_name(handle : Handle) : UInt8*
    fun qt6cr_application_set_name = qt6cr_application_set_name(handle : Handle, name : UInt8*)
    fun qt6cr_application_organization_name = qt6cr_application_organization_name(handle : Handle) : UInt8*
    fun qt6cr_application_set_organization_name = qt6cr_application_set_organization_name(handle : Handle, name : UInt8*)
    fun qt6cr_application_organization_domain = qt6cr_application_organization_domain(handle : Handle) : UInt8*
    fun qt6cr_application_set_organization_domain = qt6cr_application_set_organization_domain(handle : Handle, domain : UInt8*)
    fun qt6cr_application_style_sheet = qt6cr_application_style_sheet(handle : Handle) : UInt8*
    fun qt6cr_application_set_style_sheet = qt6cr_application_set_style_sheet(handle : Handle, style_sheet : UInt8*)
    fun qt6cr_application_window_icon = qt6cr_application_window_icon(handle : Handle) : Handle
    fun qt6cr_application_set_window_icon = qt6cr_application_set_window_icon(handle : Handle, icon : Handle)

    fun qt6cr_event_loop_create = qt6cr_event_loop_create(parent : Handle) : Handle
    fun qt6cr_event_loop_exec = qt6cr_event_loop_exec(handle : Handle) : LibC::Int
    fun qt6cr_event_loop_quit = qt6cr_event_loop_quit(handle : Handle)
    fun qt6cr_event_loop_exit = qt6cr_event_loop_exit(handle : Handle, return_code : LibC::Int)
    fun qt6cr_event_loop_process_events = qt6cr_event_loop_process_events(handle : Handle)
    fun qt6cr_event_loop_is_running = qt6cr_event_loop_is_running(handle : Handle) : Bool

    fun qt6cr_clipboard_text = qt6cr_clipboard_text(handle : Handle) : UInt8*
    fun qt6cr_clipboard_set_text = qt6cr_clipboard_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_clipboard_has_text = qt6cr_clipboard_has_text(handle : Handle) : Bool
    fun qt6cr_clipboard_image = qt6cr_clipboard_image(handle : Handle) : Handle
    fun qt6cr_clipboard_set_image = qt6cr_clipboard_set_image(handle : Handle, image : Handle)
    fun qt6cr_clipboard_has_image = qt6cr_clipboard_has_image(handle : Handle) : Bool
    fun qt6cr_clipboard_pixmap = qt6cr_clipboard_pixmap(handle : Handle) : Handle
    fun qt6cr_clipboard_set_pixmap = qt6cr_clipboard_set_pixmap(handle : Handle, pixmap : Handle)
    fun qt6cr_clipboard_has_pixmap = qt6cr_clipboard_has_pixmap(handle : Handle) : Bool
    fun qt6cr_clipboard_mime_data = qt6cr_clipboard_mime_data(handle : Handle) : Handle
    fun qt6cr_clipboard_set_mime_data = qt6cr_clipboard_set_mime_data(handle : Handle, mime_data : Handle)
    fun qt6cr_clipboard_clear = qt6cr_clipboard_clear(handle : Handle)

    fun qt6cr_mime_data_create = qt6cr_mime_data_create : Handle
    fun qt6cr_mime_data_has_text = qt6cr_mime_data_has_text(handle : Handle) : Bool
    fun qt6cr_mime_data_text = qt6cr_mime_data_text(handle : Handle) : UInt8*
    fun qt6cr_mime_data_set_text = qt6cr_mime_data_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_mime_data_has_html = qt6cr_mime_data_has_html(handle : Handle) : Bool
    fun qt6cr_mime_data_html = qt6cr_mime_data_html(handle : Handle) : UInt8*
    fun qt6cr_mime_data_set_html = qt6cr_mime_data_set_html(handle : Handle, html : UInt8*)
    fun qt6cr_mime_data_has_image = qt6cr_mime_data_has_image(handle : Handle) : Bool
    fun qt6cr_mime_data_image = qt6cr_mime_data_image(handle : Handle) : Handle
    fun qt6cr_mime_data_set_image = qt6cr_mime_data_set_image(handle : Handle, image : Handle)
    fun qt6cr_mime_data_formats = qt6cr_mime_data_formats(handle : Handle) : StringArrayValue
    fun qt6cr_mime_data_has_format = qt6cr_mime_data_has_format(handle : Handle, format : UInt8*) : Bool
    fun qt6cr_mime_data_data = qt6cr_mime_data_data(handle : Handle, format : UInt8*) : ByteArrayValue
    fun qt6cr_mime_data_set_data = qt6cr_mime_data_set_data(handle : Handle, format : UInt8*, data : UInt8*, size : LibC::Int)

    fun qt6cr_widget_create = qt6cr_widget_create(parent : Handle) : Handle
    fun qt6cr_widget_destroy = qt6cr_widget_destroy(handle : Handle)
    fun qt6cr_widget_show = qt6cr_widget_show(handle : Handle)
    fun qt6cr_widget_hide = qt6cr_widget_hide(handle : Handle)
    fun qt6cr_widget_set_visible = qt6cr_widget_set_visible(handle : Handle, value : Bool)
    fun qt6cr_widget_close = qt6cr_widget_close(handle : Handle)
    fun qt6cr_widget_resize = qt6cr_widget_resize(handle : Handle, width : LibC::Int, height : LibC::Int)
    fun qt6cr_widget_set_window_title = qt6cr_widget_set_window_title(handle : Handle, title : UInt8*)
    fun qt6cr_widget_window_title = qt6cr_widget_window_title(handle : Handle) : UInt8*
    fun qt6cr_widget_is_visible = qt6cr_widget_is_visible(handle : Handle) : Bool
    fun qt6cr_widget_size = qt6cr_widget_size(handle : Handle) : SizeValue
    fun qt6cr_widget_rect = qt6cr_widget_rect(handle : Handle) : RectFValue
    fun qt6cr_widget_update = qt6cr_widget_update(handle : Handle)
    fun qt6cr_widget_grab = qt6cr_widget_grab(handle : Handle) : Handle
    fun qt6cr_widget_style_sheet = qt6cr_widget_style_sheet(handle : Handle) : UInt8*
    fun qt6cr_widget_set_style_sheet = qt6cr_widget_set_style_sheet(handle : Handle, style_sheet : UInt8*)
    fun qt6cr_widget_tool_tip = qt6cr_widget_tool_tip(handle : Handle) : UInt8*
    fun qt6cr_widget_set_tool_tip = qt6cr_widget_set_tool_tip(handle : Handle, tool_tip : UInt8*)
    fun qt6cr_widget_window_icon = qt6cr_widget_window_icon(handle : Handle) : Handle
    fun qt6cr_widget_set_window_icon = qt6cr_widget_set_window_icon(handle : Handle, icon : Handle)
    fun qt6cr_widget_is_enabled = qt6cr_widget_is_enabled(handle : Handle) : Bool
    fun qt6cr_widget_set_enabled = qt6cr_widget_set_enabled(handle : Handle, value : Bool)
    fun qt6cr_widget_has_focus = qt6cr_widget_has_focus(handle : Handle) : Bool
    fun qt6cr_widget_focus_policy = qt6cr_widget_focus_policy(handle : Handle) : LibC::Int
    fun qt6cr_widget_set_focus_policy = qt6cr_widget_set_focus_policy(handle : Handle, value : LibC::Int)
    fun qt6cr_widget_set_focus = qt6cr_widget_set_focus(handle : Handle)
    fun qt6cr_widget_clear_focus = qt6cr_widget_clear_focus(handle : Handle)
    fun qt6cr_widget_move = qt6cr_widget_move(handle : Handle, x : LibC::Int, y : LibC::Int)
    fun qt6cr_widget_adjust_size = qt6cr_widget_adjust_size(handle : Handle)
    fun qt6cr_widget_raise_to_front = qt6cr_widget_raise_to_front(handle : Handle)
    fun qt6cr_widget_add_action = qt6cr_widget_add_action(handle : Handle, action : Handle)
    fun qt6cr_widget_set_fixed_width = qt6cr_widget_set_fixed_width(handle : Handle, value : LibC::Int)
    fun qt6cr_widget_set_fixed_height = qt6cr_widget_set_fixed_height(handle : Handle, value : LibC::Int)
    fun qt6cr_widget_set_fixed_size = qt6cr_widget_set_fixed_size(handle : Handle, width : LibC::Int, height : LibC::Int)
    fun qt6cr_widget_minimum_size = qt6cr_widget_minimum_size(handle : Handle) : SizeValue
    fun qt6cr_widget_set_minimum_size = qt6cr_widget_set_minimum_size(handle : Handle, width : LibC::Int, height : LibC::Int)
    fun qt6cr_widget_maximum_size = qt6cr_widget_maximum_size(handle : Handle) : SizeValue
    fun qt6cr_widget_set_maximum_size = qt6cr_widget_set_maximum_size(handle : Handle, width : LibC::Int, height : LibC::Int)
    fun qt6cr_widget_maximum_width = qt6cr_widget_maximum_width(handle : Handle) : LibC::Int
    fun qt6cr_widget_set_maximum_width = qt6cr_widget_set_maximum_width(handle : Handle, value : LibC::Int)
    fun qt6cr_widget_maximum_height = qt6cr_widget_maximum_height(handle : Handle) : LibC::Int
    fun qt6cr_widget_set_maximum_height = qt6cr_widget_set_maximum_height(handle : Handle, value : LibC::Int)
    fun qt6cr_widget_simulate_wheel = qt6cr_widget_simulate_wheel(handle : Handle, position : PointFValue, pixel_delta : PointFValue, angle_delta : PointFValue, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_widget_horizontal_size_policy = qt6cr_widget_horizontal_size_policy(handle : Handle) : LibC::Int
    fun qt6cr_widget_vertical_size_policy = qt6cr_widget_vertical_size_policy(handle : Handle) : LibC::Int
    fun qt6cr_widget_set_size_policy = qt6cr_widget_set_size_policy(handle : Handle, horizontal : LibC::Int, vertical : LibC::Int)
    fun qt6cr_widget_minimum_width = qt6cr_widget_minimum_width(handle : Handle) : LibC::Int
    fun qt6cr_widget_set_minimum_width = qt6cr_widget_set_minimum_width(handle : Handle, value : LibC::Int)
    fun qt6cr_widget_minimum_height = qt6cr_widget_minimum_height(handle : Handle) : LibC::Int
    fun qt6cr_widget_set_minimum_height = qt6cr_widget_set_minimum_height(handle : Handle, value : LibC::Int)
    fun qt6cr_widget_accept_drops = qt6cr_widget_accept_drops(handle : Handle) : Bool
    fun qt6cr_widget_set_accept_drops = qt6cr_widget_set_accept_drops(handle : Handle, value : Bool)
    fun qt6cr_widget_mouse_tracking = qt6cr_widget_mouse_tracking(handle : Handle) : Bool
    fun qt6cr_widget_set_mouse_tracking = qt6cr_widget_set_mouse_tracking(handle : Handle, value : Bool)
    fun qt6cr_widget_cursor_shape = qt6cr_widget_cursor_shape(handle : Handle) : LibC::Int
    fun qt6cr_widget_set_cursor_shape = qt6cr_widget_set_cursor_shape(handle : Handle, value : LibC::Int)
    fun qt6cr_widget_transparent_for_mouse_events = qt6cr_widget_transparent_for_mouse_events(handle : Handle) : Bool
    fun qt6cr_widget_set_transparent_for_mouse_events = qt6cr_widget_set_transparent_for_mouse_events(handle : Handle, value : Bool)
    fun qt6cr_widget_test_attribute = qt6cr_widget_test_attribute(handle : Handle, attribute : LibC::Int) : Bool
    fun qt6cr_widget_set_attribute = qt6cr_widget_set_attribute(handle : Handle, attribute : LibC::Int, value : Bool)

    fun qt6cr_main_window_create = qt6cr_main_window_create(parent : Handle) : Handle
    fun qt6cr_main_window_set_central_widget = qt6cr_main_window_set_central_widget(handle : Handle, widget : Handle)
    fun qt6cr_main_window_menu_bar = qt6cr_main_window_menu_bar(handle : Handle) : Handle
    fun qt6cr_main_window_status_bar = qt6cr_main_window_status_bar(handle : Handle) : Handle
    fun qt6cr_main_window_add_tool_bar = qt6cr_main_window_add_tool_bar(handle : Handle, toolbar : Handle)
    fun qt6cr_main_window_remove_tool_bar = qt6cr_main_window_remove_tool_bar(handle : Handle, toolbar : Handle)
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
    fun qt6cr_file_dialog_selected_files = qt6cr_file_dialog_selected_files(handle : Handle) : StringArrayValue
    fun qt6cr_file_dialog_get_open_file_name = qt6cr_file_dialog_get_open_file_name(parent : Handle, title : UInt8*, directory : UInt8*, filter : UInt8*) : UInt8*
    fun qt6cr_file_dialog_get_open_file_names = qt6cr_file_dialog_get_open_file_names(parent : Handle, title : UInt8*, directory : UInt8*, filter : UInt8*) : StringArrayValue
    fun qt6cr_file_dialog_get_save_file_name = qt6cr_file_dialog_get_save_file_name(parent : Handle, title : UInt8*, directory : UInt8*, filter : UInt8*) : UInt8*

    fun qt6cr_color_dialog_create = qt6cr_color_dialog_create(parent : Handle) : Handle
    fun qt6cr_color_dialog_set_current_color = qt6cr_color_dialog_set_current_color(handle : Handle, color : ColorValue)
    fun qt6cr_color_dialog_current_color = qt6cr_color_dialog_current_color(handle : Handle) : ColorValue
    fun qt6cr_color_dialog_set_native_dialog = qt6cr_color_dialog_set_native_dialog(handle : Handle, value : Bool)
    fun qt6cr_color_dialog_native_dialog = qt6cr_color_dialog_native_dialog(handle : Handle) : Bool
    fun qt6cr_color_dialog_set_show_alpha_channel = qt6cr_color_dialog_set_show_alpha_channel(handle : Handle, value : Bool)
    fun qt6cr_color_dialog_show_alpha_channel = qt6cr_color_dialog_show_alpha_channel(handle : Handle) : Bool

    fun qt6cr_font_dialog_create = qt6cr_font_dialog_create(parent : Handle, initial_font : Handle) : Handle
    fun qt6cr_font_dialog_set_current_font = qt6cr_font_dialog_set_current_font(handle : Handle, font : Handle)
    fun qt6cr_font_dialog_current_font = qt6cr_font_dialog_current_font(handle : Handle) : Handle
    fun qt6cr_font_dialog_selected_font = qt6cr_font_dialog_selected_font(handle : Handle) : Handle
    fun qt6cr_font_dialog_set_options = qt6cr_font_dialog_set_options(handle : Handle, options : LibC::Int)
    fun qt6cr_font_dialog_options = qt6cr_font_dialog_options(handle : Handle) : LibC::Int
    fun qt6cr_font_dialog_set_option = qt6cr_font_dialog_set_option(handle : Handle, option : LibC::Int, value : Bool)
    fun qt6cr_font_dialog_test_option = qt6cr_font_dialog_test_option(handle : Handle, option : LibC::Int) : Bool
    fun qt6cr_font_dialog_set_native_dialog = qt6cr_font_dialog_set_native_dialog(handle : Handle, value : Bool)
    fun qt6cr_font_dialog_native_dialog = qt6cr_font_dialog_native_dialog(handle : Handle) : Bool
    fun qt6cr_font_dialog_on_current_font_changed = qt6cr_font_dialog_on_current_font_changed(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)
    fun qt6cr_font_dialog_on_font_selected = qt6cr_font_dialog_on_font_selected(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)

    fun qt6cr_progress_dialog_create = qt6cr_progress_dialog_create(parent : Handle, label_text : UInt8*, cancel_button_text : UInt8*, minimum : LibC::Int, maximum : LibC::Int) : Handle
    fun qt6cr_progress_dialog_label_text = qt6cr_progress_dialog_label_text(handle : Handle) : UInt8*
    fun qt6cr_progress_dialog_set_label_text = qt6cr_progress_dialog_set_label_text(handle : Handle, label_text : UInt8*)
    fun qt6cr_progress_dialog_set_cancel_button_text = qt6cr_progress_dialog_set_cancel_button_text(handle : Handle, cancel_button_text : UInt8*)
    fun qt6cr_progress_dialog_minimum = qt6cr_progress_dialog_minimum(handle : Handle) : LibC::Int
    fun qt6cr_progress_dialog_set_minimum = qt6cr_progress_dialog_set_minimum(handle : Handle, value : LibC::Int)
    fun qt6cr_progress_dialog_maximum = qt6cr_progress_dialog_maximum(handle : Handle) : LibC::Int
    fun qt6cr_progress_dialog_set_maximum = qt6cr_progress_dialog_set_maximum(handle : Handle, value : LibC::Int)
    fun qt6cr_progress_dialog_set_range = qt6cr_progress_dialog_set_range(handle : Handle, minimum : LibC::Int, maximum : LibC::Int)
    fun qt6cr_progress_dialog_value = qt6cr_progress_dialog_value(handle : Handle) : LibC::Int
    fun qt6cr_progress_dialog_set_value = qt6cr_progress_dialog_set_value(handle : Handle, value : LibC::Int)
    fun qt6cr_progress_dialog_auto_close = qt6cr_progress_dialog_auto_close(handle : Handle) : Bool
    fun qt6cr_progress_dialog_set_auto_close = qt6cr_progress_dialog_set_auto_close(handle : Handle, value : Bool)
    fun qt6cr_progress_dialog_auto_reset = qt6cr_progress_dialog_auto_reset(handle : Handle) : Bool
    fun qt6cr_progress_dialog_set_auto_reset = qt6cr_progress_dialog_set_auto_reset(handle : Handle, value : Bool)
    fun qt6cr_progress_dialog_minimum_duration = qt6cr_progress_dialog_minimum_duration(handle : Handle) : LibC::Int
    fun qt6cr_progress_dialog_set_minimum_duration = qt6cr_progress_dialog_set_minimum_duration(handle : Handle, value : LibC::Int)
    fun qt6cr_progress_dialog_was_canceled = qt6cr_progress_dialog_was_canceled(handle : Handle) : Bool
    fun qt6cr_progress_dialog_cancel = qt6cr_progress_dialog_cancel(handle : Handle)
    fun qt6cr_progress_dialog_reset = qt6cr_progress_dialog_reset(handle : Handle)
    fun qt6cr_progress_dialog_on_canceled = qt6cr_progress_dialog_on_canceled(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_qimage_create = qt6cr_qimage_create(width : LibC::Int, height : LibC::Int, format : LibC::Int) : Handle
    fun qt6cr_qimage_create_from_file = qt6cr_qimage_create_from_file(path : UInt8*) : Handle
    fun qt6cr_qimage_create_from_raw_data = qt6cr_qimage_create_from_raw_data(data : UInt8*, size : LibC::Int, width : LibC::Int, height : LibC::Int, bytes_per_line : LibC::Int, format : LibC::Int) : Handle
    fun qt6cr_qimage_destroy = qt6cr_qimage_destroy(handle : Handle)
    fun qt6cr_qimage_width = qt6cr_qimage_width(handle : Handle) : LibC::Int
    fun qt6cr_qimage_height = qt6cr_qimage_height(handle : Handle) : LibC::Int
    fun qt6cr_qimage_format = qt6cr_qimage_format(handle : Handle) : LibC::Int
    fun qt6cr_qimage_depth = qt6cr_qimage_depth(handle : Handle) : LibC::Int
    fun qt6cr_qimage_bytes_per_line = qt6cr_qimage_bytes_per_line(handle : Handle) : LibC::Int
    fun qt6cr_qimage_size_in_bytes = qt6cr_qimage_size_in_bytes(handle : Handle) : LibC::Int
    fun qt6cr_qimage_const_bits = qt6cr_qimage_const_bits(handle : Handle) : ByteArrayValue
    fun qt6cr_qimage_is_null = qt6cr_qimage_is_null(handle : Handle) : Bool
    fun qt6cr_qimage_has_alpha_channel = qt6cr_qimage_has_alpha_channel(handle : Handle) : Bool
    fun qt6cr_qimage_all_gray = qt6cr_qimage_all_gray(handle : Handle) : Bool
    fun qt6cr_qimage_is_grayscale = qt6cr_qimage_is_grayscale(handle : Handle) : Bool
    fun qt6cr_qimage_copy = qt6cr_qimage_copy(handle : Handle) : Handle
    fun qt6cr_qimage_copy_rect = qt6cr_qimage_copy_rect(handle : Handle, x : LibC::Int, y : LibC::Int, width : LibC::Int, height : LibC::Int) : Handle
    fun qt6cr_qimage_convert_to_format = qt6cr_qimage_convert_to_format(handle : Handle, format : LibC::Int) : Handle
    fun qt6cr_qimage_scaled = qt6cr_qimage_scaled(handle : Handle, width : LibC::Int, height : LibC::Int, aspect_ratio_mode : LibC::Int, transformation_mode : LibC::Int) : Handle
    fun qt6cr_qimage_scaled_to_width = qt6cr_qimage_scaled_to_width(handle : Handle, width : LibC::Int, transformation_mode : LibC::Int) : Handle
    fun qt6cr_qimage_scaled_to_height = qt6cr_qimage_scaled_to_height(handle : Handle, height : LibC::Int, transformation_mode : LibC::Int) : Handle
    fun qt6cr_qimage_mirrored = qt6cr_qimage_mirrored(handle : Handle, horizontal : Bool, vertical : Bool) : Handle
    fun qt6cr_qimage_rgb_swapped = qt6cr_qimage_rgb_swapped(handle : Handle) : Handle
    fun qt6cr_qimage_transformed = qt6cr_qimage_transformed(handle : Handle, transform : Handle, transformation_mode : LibC::Int) : Handle
    fun qt6cr_qimage_invert_pixels = qt6cr_qimage_invert_pixels(handle : Handle, mode : LibC::Int)
    fun qt6cr_qimage_fill = qt6cr_qimage_fill(handle : Handle, color : ColorValue)
    fun qt6cr_qimage_load = qt6cr_qimage_load(handle : Handle, path : UInt8*) : Bool
    fun qt6cr_qimage_load_from_data = qt6cr_qimage_load_from_data(handle : Handle, data : UInt8*, size : LibC::Int, format : UInt8*) : Bool
    fun qt6cr_qimage_load_from_device = qt6cr_qimage_load_from_device(handle : Handle, device : Handle, format : UInt8*) : Bool
    fun qt6cr_qimage_save = qt6cr_qimage_save(handle : Handle, path : UInt8*) : Bool
    fun qt6cr_qimage_save_to_data = qt6cr_qimage_save_to_data(handle : Handle, format : UInt8*) : ByteArrayValue
    fun qt6cr_qimage_save_to_device = qt6cr_qimage_save_to_device(handle : Handle, device : Handle, format : UInt8*) : Bool
    fun qt6cr_qimage_pixel_color = qt6cr_qimage_pixel_color(handle : Handle, x : LibC::Int, y : LibC::Int) : ColorValue
    fun qt6cr_qimage_set_pixel_color = qt6cr_qimage_set_pixel_color(handle : Handle, x : LibC::Int, y : LibC::Int, color : ColorValue)

    fun qt6cr_qimage_reader_create = qt6cr_qimage_reader_create(file_name : UInt8*, format : UInt8*) : Handle
    fun qt6cr_qimage_reader_create_from_device = qt6cr_qimage_reader_create_from_device(device : Handle, format : UInt8*) : Handle
    fun qt6cr_qimage_reader_destroy = qt6cr_qimage_reader_destroy(handle : Handle)
    fun qt6cr_qimage_reader_file_name = qt6cr_qimage_reader_file_name(handle : Handle) : UInt8*
    fun qt6cr_qimage_reader_set_file_name = qt6cr_qimage_reader_set_file_name(handle : Handle, file_name : UInt8*)
    fun qt6cr_qimage_reader_format = qt6cr_qimage_reader_format(handle : Handle) : UInt8*
    fun qt6cr_qimage_reader_set_format = qt6cr_qimage_reader_set_format(handle : Handle, format : UInt8*)
    fun qt6cr_qimage_reader_size = qt6cr_qimage_reader_size(handle : Handle) : SizeValue
    fun qt6cr_qimage_reader_can_read = qt6cr_qimage_reader_can_read(handle : Handle) : Bool
    fun qt6cr_qimage_reader_auto_transform = qt6cr_qimage_reader_auto_transform(handle : Handle) : Bool
    fun qt6cr_qimage_reader_set_auto_transform = qt6cr_qimage_reader_set_auto_transform(handle : Handle, value : Bool)
    fun qt6cr_qimage_reader_error_string = qt6cr_qimage_reader_error_string(handle : Handle) : UInt8*
    fun qt6cr_qimage_reader_read = qt6cr_qimage_reader_read(handle : Handle) : Handle
    fun qt6cr_qimage_reader_read_into = qt6cr_qimage_reader_read_into(handle : Handle, image : Handle) : Bool

    fun qt6cr_qimage_writer_create = qt6cr_qimage_writer_create(file_name : UInt8*, format : UInt8*) : Handle
    fun qt6cr_qimage_writer_create_from_device = qt6cr_qimage_writer_create_from_device(device : Handle, format : UInt8*) : Handle
    fun qt6cr_qimage_writer_destroy = qt6cr_qimage_writer_destroy(handle : Handle)
    fun qt6cr_qimage_writer_file_name = qt6cr_qimage_writer_file_name(handle : Handle) : UInt8*
    fun qt6cr_qimage_writer_set_file_name = qt6cr_qimage_writer_set_file_name(handle : Handle, file_name : UInt8*)
    fun qt6cr_qimage_writer_format = qt6cr_qimage_writer_format(handle : Handle) : UInt8*
    fun qt6cr_qimage_writer_set_format = qt6cr_qimage_writer_set_format(handle : Handle, format : UInt8*)
    fun qt6cr_qimage_writer_can_write = qt6cr_qimage_writer_can_write(handle : Handle) : Bool
    fun qt6cr_qimage_writer_write = qt6cr_qimage_writer_write(handle : Handle, image : Handle) : Bool
    fun qt6cr_qimage_writer_quality = qt6cr_qimage_writer_quality(handle : Handle) : LibC::Int
    fun qt6cr_qimage_writer_set_quality = qt6cr_qimage_writer_set_quality(handle : Handle, value : LibC::Int)
    fun qt6cr_qimage_writer_compression = qt6cr_qimage_writer_compression(handle : Handle) : LibC::Int
    fun qt6cr_qimage_writer_set_compression = qt6cr_qimage_writer_set_compression(handle : Handle, value : LibC::Int)
    fun qt6cr_qimage_writer_optimized_write = qt6cr_qimage_writer_optimized_write(handle : Handle) : Bool
    fun qt6cr_qimage_writer_set_optimized_write = qt6cr_qimage_writer_set_optimized_write(handle : Handle, value : Bool)
    fun qt6cr_qimage_writer_progressive_scan_write = qt6cr_qimage_writer_progressive_scan_write(handle : Handle) : Bool
    fun qt6cr_qimage_writer_set_progressive_scan_write = qt6cr_qimage_writer_set_progressive_scan_write(handle : Handle, value : Bool)
    fun qt6cr_qimage_writer_error_string = qt6cr_qimage_writer_error_string(handle : Handle) : UInt8*
    fun qt6cr_qimage_writer_supported_image_formats = qt6cr_qimage_writer_supported_image_formats : StringArrayValue
    fun qt6cr_qimage_writer_supported_mime_types = qt6cr_qimage_writer_supported_mime_types : StringArrayValue

    fun qt6cr_qpixmap_create = qt6cr_qpixmap_create(width : LibC::Int, height : LibC::Int) : Handle
    fun qt6cr_qpixmap_create_from_file = qt6cr_qpixmap_create_from_file(path : UInt8*) : Handle
    fun qt6cr_qpixmap_destroy = qt6cr_qpixmap_destroy(handle : Handle)
    fun qt6cr_qpixmap_from_image = qt6cr_qpixmap_from_image(image : Handle) : Handle
    fun qt6cr_qpixmap_to_image = qt6cr_qpixmap_to_image(handle : Handle) : Handle
    fun qt6cr_qpixmap_width = qt6cr_qpixmap_width(handle : Handle) : LibC::Int
    fun qt6cr_qpixmap_height = qt6cr_qpixmap_height(handle : Handle) : LibC::Int
    fun qt6cr_qpixmap_depth = qt6cr_qpixmap_depth(handle : Handle) : LibC::Int
    fun qt6cr_qpixmap_is_null = qt6cr_qpixmap_is_null(handle : Handle) : Bool
    fun qt6cr_qpixmap_has_alpha_channel = qt6cr_qpixmap_has_alpha_channel(handle : Handle) : Bool
    fun qt6cr_qpixmap_scaled = qt6cr_qpixmap_scaled(handle : Handle, width : LibC::Int, height : LibC::Int, aspect_ratio_mode : LibC::Int, transformation_mode : LibC::Int) : Handle
    fun qt6cr_qpixmap_scaled_to_width = qt6cr_qpixmap_scaled_to_width(handle : Handle, width : LibC::Int, transformation_mode : LibC::Int) : Handle
    fun qt6cr_qpixmap_scaled_to_height = qt6cr_qpixmap_scaled_to_height(handle : Handle, height : LibC::Int, transformation_mode : LibC::Int) : Handle
    fun qt6cr_qpixmap_transformed = qt6cr_qpixmap_transformed(handle : Handle, transform : Handle, transformation_mode : LibC::Int) : Handle
    fun qt6cr_qpixmap_fill = qt6cr_qpixmap_fill(handle : Handle, color : ColorValue)
    fun qt6cr_qpixmap_load = qt6cr_qpixmap_load(handle : Handle, path : UInt8*) : Bool
    fun qt6cr_qpixmap_load_from_data = qt6cr_qpixmap_load_from_data(handle : Handle, data : UInt8*, size : LibC::Int, format : UInt8*) : Bool
    fun qt6cr_qpixmap_save = qt6cr_qpixmap_save(handle : Handle, path : UInt8*) : Bool
    fun qt6cr_qpixmap_save_to_data = qt6cr_qpixmap_save_to_data(handle : Handle, format : UInt8*) : ByteArrayValue

    fun qt6cr_qicon_create = qt6cr_qicon_create : Handle
    fun qt6cr_qicon_create_from_file = qt6cr_qicon_create_from_file(path : UInt8*) : Handle
    fun qt6cr_qicon_create_from_theme = qt6cr_qicon_create_from_theme(name : UInt8*) : Handle
    fun qt6cr_qicon_destroy = qt6cr_qicon_destroy(handle : Handle)
    fun qt6cr_qicon_is_null = qt6cr_qicon_is_null(handle : Handle) : Bool

    fun qt6cr_splash_screen_create = qt6cr_splash_screen_create(pixmap : Handle) : Handle
    fun qt6cr_splash_screen_pixmap = qt6cr_splash_screen_pixmap(handle : Handle) : Handle
    fun qt6cr_splash_screen_set_pixmap = qt6cr_splash_screen_set_pixmap(handle : Handle, pixmap : Handle)
    fun qt6cr_splash_screen_message = qt6cr_splash_screen_message(handle : Handle) : UInt8*
    fun qt6cr_splash_screen_show_message = qt6cr_splash_screen_show_message(handle : Handle, message : UInt8*, color : ColorValue)
    fun qt6cr_splash_screen_clear_message = qt6cr_splash_screen_clear_message(handle : Handle)
    fun qt6cr_splash_screen_finish = qt6cr_splash_screen_finish(handle : Handle, widget : Handle)

    fun qt6cr_model_index_create = qt6cr_model_index_create : Handle
    fun qt6cr_model_index_destroy = qt6cr_model_index_destroy(handle : Handle)
    fun qt6cr_model_index_is_valid = qt6cr_model_index_is_valid(handle : Handle) : Bool
    fun qt6cr_model_index_row = qt6cr_model_index_row(handle : Handle) : LibC::Int
    fun qt6cr_model_index_column = qt6cr_model_index_column(handle : Handle) : LibC::Int
    fun qt6cr_model_index_internal_id = qt6cr_model_index_internal_id(handle : Handle) : UInt64

    fun qt6cr_abstract_item_model_row_count = qt6cr_abstract_item_model_row_count(handle : Handle, parent_index : Handle) : LibC::Int
    fun qt6cr_abstract_item_model_column_count = qt6cr_abstract_item_model_column_count(handle : Handle, parent_index : Handle) : LibC::Int
    fun qt6cr_abstract_item_model_index = qt6cr_abstract_item_model_index(handle : Handle, row : LibC::Int, column : LibC::Int, parent_index : Handle) : Handle
    fun qt6cr_abstract_item_model_parent = qt6cr_abstract_item_model_parent(handle : Handle, index : Handle) : Handle
    fun qt6cr_abstract_item_model_data = qt6cr_abstract_item_model_data(handle : Handle, index : Handle, role : LibC::Int) : VariantValue
    fun qt6cr_abstract_item_model_set_data = qt6cr_abstract_item_model_set_data(handle : Handle, index : Handle, value : VariantValue, role : LibC::Int) : Bool
    fun qt6cr_abstract_item_model_header_data = qt6cr_abstract_item_model_header_data(handle : Handle, section : LibC::Int, orientation : LibC::Int, role : LibC::Int) : VariantValue
    fun qt6cr_abstract_item_model_set_header_data = qt6cr_abstract_item_model_set_header_data(handle : Handle, section : LibC::Int, orientation : LibC::Int, value : VariantValue, role : LibC::Int) : Bool
    fun qt6cr_abstract_item_model_flags = qt6cr_abstract_item_model_flags(handle : Handle, index : Handle) : LibC::Int
    fun qt6cr_abstract_item_model_mime_type_count = qt6cr_abstract_item_model_mime_type_count(handle : Handle) : LibC::Int
    fun qt6cr_abstract_item_model_mime_type = qt6cr_abstract_item_model_mime_type(handle : Handle, index : LibC::Int) : UInt8*
    fun qt6cr_abstract_item_model_mime_data_for_indexes = qt6cr_abstract_item_model_mime_data_for_indexes(handle : Handle, indexes : Handle*, count : LibC::Int) : Handle
    fun qt6cr_abstract_item_model_drop_mime_data = qt6cr_abstract_item_model_drop_mime_data(handle : Handle, mime_data : Handle, action : LibC::Int, row : LibC::Int, column : LibC::Int, parent_index : Handle) : Bool
    fun qt6cr_abstract_item_model_supported_drag_actions = qt6cr_abstract_item_model_supported_drag_actions(handle : Handle) : LibC::Int
    fun qt6cr_abstract_item_model_supported_drop_actions = qt6cr_abstract_item_model_supported_drop_actions(handle : Handle) : LibC::Int

    fun qt6cr_abstract_list_model_create = qt6cr_abstract_list_model_create(parent : Handle) : Handle
    fun qt6cr_abstract_list_model_on_row_count = qt6cr_abstract_list_model_on_row_count(handle : Handle, callback : (Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_list_model_on_column_count = qt6cr_abstract_list_model_on_column_count(handle : Handle, callback : (Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_list_model_on_data = qt6cr_abstract_list_model_on_data(handle : Handle, callback : (Handle, Handle, LibC::Int -> VariantValue), userdata : Handle)
    fun qt6cr_abstract_list_model_on_set_data = qt6cr_abstract_list_model_on_set_data(handle : Handle, callback : (Handle, Handle, VariantValue, LibC::Int -> Bool), userdata : Handle)
    fun qt6cr_abstract_list_model_on_header_data = qt6cr_abstract_list_model_on_header_data(handle : Handle, callback : (Handle, LibC::Int, LibC::Int, LibC::Int -> VariantValue), userdata : Handle)
    fun qt6cr_abstract_list_model_on_flags = qt6cr_abstract_list_model_on_flags(handle : Handle, callback : (Handle, Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_list_model_on_mime_type_count = qt6cr_abstract_list_model_on_mime_type_count(handle : Handle, callback : (Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_list_model_on_mime_type = qt6cr_abstract_list_model_on_mime_type(handle : Handle, callback : (Handle, LibC::Int -> UInt8*), userdata : Handle)
    fun qt6cr_abstract_list_model_on_mime_data = qt6cr_abstract_list_model_on_mime_data(handle : Handle, callback : (Handle, Handle*, LibC::Int -> Handle), userdata : Handle)
    fun qt6cr_abstract_list_model_on_drop_mime_data = qt6cr_abstract_list_model_on_drop_mime_data(handle : Handle, callback : (Handle, Handle, LibC::Int, LibC::Int, LibC::Int, Handle -> Bool), userdata : Handle)
    fun qt6cr_abstract_list_model_on_supported_drag_actions = qt6cr_abstract_list_model_on_supported_drag_actions(handle : Handle, callback : (Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_list_model_on_supported_drop_actions = qt6cr_abstract_list_model_on_supported_drop_actions(handle : Handle, callback : (Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_list_model_begin_reset_model = qt6cr_abstract_list_model_begin_reset_model(handle : Handle)
    fun qt6cr_abstract_list_model_end_reset_model = qt6cr_abstract_list_model_end_reset_model(handle : Handle)
    fun qt6cr_abstract_list_model_begin_insert_rows = qt6cr_abstract_list_model_begin_insert_rows(handle : Handle, first : LibC::Int, last : LibC::Int, parent_index : Handle)
    fun qt6cr_abstract_list_model_end_insert_rows = qt6cr_abstract_list_model_end_insert_rows(handle : Handle)
    fun qt6cr_abstract_list_model_begin_remove_rows = qt6cr_abstract_list_model_begin_remove_rows(handle : Handle, first : LibC::Int, last : LibC::Int, parent_index : Handle)
    fun qt6cr_abstract_list_model_end_remove_rows = qt6cr_abstract_list_model_end_remove_rows(handle : Handle)
    fun qt6cr_abstract_list_model_begin_move_rows = qt6cr_abstract_list_model_begin_move_rows(handle : Handle, source_first : LibC::Int, source_last : LibC::Int, source_parent_index : Handle, destination_child : LibC::Int, destination_parent_index : Handle) : Bool
    fun qt6cr_abstract_list_model_end_move_rows = qt6cr_abstract_list_model_end_move_rows(handle : Handle)
    fun qt6cr_abstract_list_model_data_changed = qt6cr_abstract_list_model_data_changed(handle : Handle, top_left : Handle, bottom_right : Handle)
    fun qt6cr_abstract_tree_model_create = qt6cr_abstract_tree_model_create(parent : Handle) : Handle
    fun qt6cr_abstract_tree_model_on_row_count = qt6cr_abstract_tree_model_on_row_count(handle : Handle, callback : (Handle, Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_column_count = qt6cr_abstract_tree_model_on_column_count(handle : Handle, callback : (Handle, Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_index_id = qt6cr_abstract_tree_model_on_index_id(handle : Handle, callback : (Handle, LibC::Int, LibC::Int, Handle -> UInt64), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_parent = qt6cr_abstract_tree_model_on_parent(handle : Handle, callback : (Handle, Handle -> ModelIndexSpecValue), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_data = qt6cr_abstract_tree_model_on_data(handle : Handle, callback : (Handle, Handle, LibC::Int -> VariantValue), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_set_data = qt6cr_abstract_tree_model_on_set_data(handle : Handle, callback : (Handle, Handle, VariantValue, LibC::Int -> Bool), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_header_data = qt6cr_abstract_tree_model_on_header_data(handle : Handle, callback : (Handle, LibC::Int, LibC::Int, LibC::Int -> VariantValue), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_flags = qt6cr_abstract_tree_model_on_flags(handle : Handle, callback : (Handle, Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_mime_type_count = qt6cr_abstract_tree_model_on_mime_type_count(handle : Handle, callback : (Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_mime_type = qt6cr_abstract_tree_model_on_mime_type(handle : Handle, callback : (Handle, LibC::Int -> UInt8*), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_mime_data = qt6cr_abstract_tree_model_on_mime_data(handle : Handle, callback : (Handle, Handle*, LibC::Int -> Handle), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_drop_mime_data = qt6cr_abstract_tree_model_on_drop_mime_data(handle : Handle, callback : (Handle, Handle, LibC::Int, LibC::Int, LibC::Int, Handle -> Bool), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_supported_drag_actions = qt6cr_abstract_tree_model_on_supported_drag_actions(handle : Handle, callback : (Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_tree_model_on_supported_drop_actions = qt6cr_abstract_tree_model_on_supported_drop_actions(handle : Handle, callback : (Handle -> LibC::Int), userdata : Handle)
    fun qt6cr_abstract_tree_model_begin_reset_model = qt6cr_abstract_tree_model_begin_reset_model(handle : Handle)
    fun qt6cr_abstract_tree_model_end_reset_model = qt6cr_abstract_tree_model_end_reset_model(handle : Handle)
    fun qt6cr_abstract_tree_model_begin_insert_rows = qt6cr_abstract_tree_model_begin_insert_rows(handle : Handle, first : LibC::Int, last : LibC::Int, parent_index : Handle)
    fun qt6cr_abstract_tree_model_end_insert_rows = qt6cr_abstract_tree_model_end_insert_rows(handle : Handle)
    fun qt6cr_abstract_tree_model_begin_remove_rows = qt6cr_abstract_tree_model_begin_remove_rows(handle : Handle, first : LibC::Int, last : LibC::Int, parent_index : Handle)
    fun qt6cr_abstract_tree_model_end_remove_rows = qt6cr_abstract_tree_model_end_remove_rows(handle : Handle)
    fun qt6cr_abstract_tree_model_begin_move_rows = qt6cr_abstract_tree_model_begin_move_rows(handle : Handle, source_first : LibC::Int, source_last : LibC::Int, source_parent_index : Handle, destination_child : LibC::Int, destination_parent_index : Handle) : Bool
    fun qt6cr_abstract_tree_model_end_move_rows = qt6cr_abstract_tree_model_end_move_rows(handle : Handle)
    fun qt6cr_abstract_tree_model_data_changed = qt6cr_abstract_tree_model_data_changed(handle : Handle, top_left : Handle, bottom_right : Handle)

    fun qt6cr_item_selection_model_create = qt6cr_item_selection_model_create(model : Handle, parent : Handle) : Handle
    fun qt6cr_item_selection_model_model = qt6cr_item_selection_model_model(handle : Handle) : Handle
    fun qt6cr_item_selection_model_current_index = qt6cr_item_selection_model_current_index(handle : Handle) : Handle
    fun qt6cr_item_selection_model_set_current_index = qt6cr_item_selection_model_set_current_index(handle : Handle, index : Handle, command : LibC::Int)
    fun qt6cr_item_selection_model_select_index = qt6cr_item_selection_model_select_index(handle : Handle, index : Handle, command : LibC::Int)
    fun qt6cr_item_selection_model_clear = qt6cr_item_selection_model_clear(handle : Handle)
    fun qt6cr_item_selection_model_clear_selection = qt6cr_item_selection_model_clear_selection(handle : Handle)
    fun qt6cr_item_selection_model_has_selection = qt6cr_item_selection_model_has_selection(handle : Handle) : Bool
    fun qt6cr_item_selection_model_is_selected = qt6cr_item_selection_model_is_selected(handle : Handle, index : Handle) : Bool
    fun qt6cr_item_selection_model_on_current_index_changed = qt6cr_item_selection_model_on_current_index_changed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_standard_item_create = qt6cr_standard_item_create(text : UInt8*) : Handle
    fun qt6cr_standard_item_destroy = qt6cr_standard_item_destroy(handle : Handle)
    fun qt6cr_standard_item_text = qt6cr_standard_item_text(handle : Handle) : UInt8*
    fun qt6cr_standard_item_set_text = qt6cr_standard_item_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_standard_item_data = qt6cr_standard_item_data(handle : Handle, role : LibC::Int) : VariantValue
    fun qt6cr_standard_item_set_data = qt6cr_standard_item_set_data(handle : Handle, value : VariantValue, role : LibC::Int) : Bool
    fun qt6cr_standard_item_append_row = qt6cr_standard_item_append_row(handle : Handle, item : Handle)
    fun qt6cr_standard_item_set_child = qt6cr_standard_item_set_child(handle : Handle, row : LibC::Int, column : LibC::Int, item : Handle)
    fun qt6cr_standard_item_child = qt6cr_standard_item_child(handle : Handle, row : LibC::Int, column : LibC::Int) : Handle
    fun qt6cr_standard_item_row_count = qt6cr_standard_item_row_count(handle : Handle) : LibC::Int
    fun qt6cr_standard_item_column_count = qt6cr_standard_item_column_count(handle : Handle) : LibC::Int

    fun qt6cr_standard_item_model_create = qt6cr_standard_item_model_create(parent : Handle) : Handle
    fun qt6cr_standard_item_model_clear = qt6cr_standard_item_model_clear(handle : Handle)
    fun qt6cr_standard_item_model_row_count = qt6cr_standard_item_model_row_count(handle : Handle, parent_index : Handle) : LibC::Int
    fun qt6cr_standard_item_model_column_count = qt6cr_standard_item_model_column_count(handle : Handle, parent_index : Handle) : LibC::Int
    fun qt6cr_standard_item_model_append_row = qt6cr_standard_item_model_append_row(handle : Handle, item : Handle)
    fun qt6cr_standard_item_model_set_item = qt6cr_standard_item_model_set_item(handle : Handle, row : LibC::Int, column : LibC::Int, item : Handle)
    fun qt6cr_standard_item_model_item = qt6cr_standard_item_model_item(handle : Handle, row : LibC::Int, column : LibC::Int) : Handle
    fun qt6cr_standard_item_model_set_horizontal_header_label = qt6cr_standard_item_model_set_horizontal_header_label(handle : Handle, column : LibC::Int, text : UInt8*)
    fun qt6cr_standard_item_model_horizontal_header_label = qt6cr_standard_item_model_horizontal_header_label(handle : Handle, column : LibC::Int) : UInt8*
    fun qt6cr_standard_item_model_index = qt6cr_standard_item_model_index(handle : Handle, row : LibC::Int, column : LibC::Int, parent_index : Handle) : Handle
    fun qt6cr_standard_item_model_item_from_index = qt6cr_standard_item_model_item_from_index(handle : Handle, index : Handle) : Handle
    fun qt6cr_standard_item_model_index_from_item = qt6cr_standard_item_model_index_from_item(handle : Handle, item : Handle) : Handle

    fun qt6cr_sort_filter_proxy_model_create = qt6cr_sort_filter_proxy_model_create(parent : Handle) : Handle
    fun qt6cr_sort_filter_proxy_model_set_source_model = qt6cr_sort_filter_proxy_model_set_source_model(handle : Handle, model : Handle)
    fun qt6cr_sort_filter_proxy_model_source_model = qt6cr_sort_filter_proxy_model_source_model(handle : Handle) : Handle
    fun qt6cr_sort_filter_proxy_model_map_to_source = qt6cr_sort_filter_proxy_model_map_to_source(handle : Handle, proxy_index : Handle) : Handle
    fun qt6cr_sort_filter_proxy_model_map_from_source = qt6cr_sort_filter_proxy_model_map_from_source(handle : Handle, source_index : Handle) : Handle
    fun qt6cr_sort_filter_proxy_model_sort = qt6cr_sort_filter_proxy_model_sort(handle : Handle, column : LibC::Int, order : LibC::Int)
    fun qt6cr_sort_filter_proxy_model_sort_column = qt6cr_sort_filter_proxy_model_sort_column(handle : Handle) : LibC::Int
    fun qt6cr_sort_filter_proxy_model_sort_order = qt6cr_sort_filter_proxy_model_sort_order(handle : Handle) : LibC::Int
    fun qt6cr_sort_filter_proxy_model_set_filter_fixed_string = qt6cr_sort_filter_proxy_model_set_filter_fixed_string(handle : Handle, value : UInt8*)
    fun qt6cr_sort_filter_proxy_model_set_filter_wildcard = qt6cr_sort_filter_proxy_model_set_filter_wildcard(handle : Handle, value : UInt8*)
    fun qt6cr_sort_filter_proxy_model_set_filter_regular_expression = qt6cr_sort_filter_proxy_model_set_filter_regular_expression(handle : Handle, value : UInt8*)
    fun qt6cr_sort_filter_proxy_model_filter_pattern = qt6cr_sort_filter_proxy_model_filter_pattern(handle : Handle) : UInt8*
    fun qt6cr_sort_filter_proxy_model_set_filter_key_column = qt6cr_sort_filter_proxy_model_set_filter_key_column(handle : Handle, column : LibC::Int)
    fun qt6cr_sort_filter_proxy_model_filter_key_column = qt6cr_sort_filter_proxy_model_filter_key_column(handle : Handle) : LibC::Int
    fun qt6cr_sort_filter_proxy_model_set_filter_role = qt6cr_sort_filter_proxy_model_set_filter_role(handle : Handle, role : LibC::Int)
    fun qt6cr_sort_filter_proxy_model_filter_role = qt6cr_sort_filter_proxy_model_filter_role(handle : Handle) : LibC::Int
    fun qt6cr_sort_filter_proxy_model_set_sort_role = qt6cr_sort_filter_proxy_model_set_sort_role(handle : Handle, role : LibC::Int)
    fun qt6cr_sort_filter_proxy_model_sort_role = qt6cr_sort_filter_proxy_model_sort_role(handle : Handle) : LibC::Int
    fun qt6cr_sort_filter_proxy_model_set_filter_case_sensitivity = qt6cr_sort_filter_proxy_model_set_filter_case_sensitivity(handle : Handle, sensitivity : LibC::Int)
    fun qt6cr_sort_filter_proxy_model_filter_case_sensitivity = qt6cr_sort_filter_proxy_model_filter_case_sensitivity(handle : Handle) : LibC::Int
    fun qt6cr_sort_filter_proxy_model_set_dynamic_sort_filter = qt6cr_sort_filter_proxy_model_set_dynamic_sort_filter(handle : Handle, value : Bool)
    fun qt6cr_sort_filter_proxy_model_dynamic_sort_filter = qt6cr_sort_filter_proxy_model_dynamic_sort_filter(handle : Handle) : Bool
    fun qt6cr_sort_filter_proxy_model_set_recursive_filtering_enabled = qt6cr_sort_filter_proxy_model_set_recursive_filtering_enabled(handle : Handle, value : Bool)
    fun qt6cr_sort_filter_proxy_model_recursive_filtering_enabled = qt6cr_sort_filter_proxy_model_recursive_filtering_enabled(handle : Handle) : Bool
    fun qt6cr_sort_filter_proxy_model_invalidate = qt6cr_sort_filter_proxy_model_invalidate(handle : Handle)
    fun qt6cr_sort_filter_proxy_model_clear_filter = qt6cr_sort_filter_proxy_model_clear_filter(handle : Handle)

    fun qt6cr_styled_item_delegate_create = qt6cr_styled_item_delegate_create(parent : Handle) : Handle
    fun qt6cr_styled_item_delegate_on_display_text = qt6cr_styled_item_delegate_on_display_text(handle : Handle, callback : (Handle, UInt8* -> UInt8*), userdata : Handle)
    fun qt6cr_styled_item_delegate_on_create_editor = qt6cr_styled_item_delegate_on_create_editor(handle : Handle, callback : (Handle, Handle, Handle -> Handle), userdata : Handle)
    fun qt6cr_styled_item_delegate_on_set_editor_data = qt6cr_styled_item_delegate_on_set_editor_data(handle : Handle, callback : (Handle, Handle, VariantValue, Handle ->), userdata : Handle)
    fun qt6cr_styled_item_delegate_on_set_model_data = qt6cr_styled_item_delegate_on_set_model_data(handle : Handle, callback : (Handle, Handle, Handle, Handle ->), userdata : Handle)
    fun qt6cr_styled_item_delegate_display_text = qt6cr_styled_item_delegate_display_text(handle : Handle, value : VariantValue) : UInt8*
    fun qt6cr_styled_item_delegate_create_editor = qt6cr_styled_item_delegate_create_editor(handle : Handle, parent : Handle, index : Handle) : Handle
    fun qt6cr_styled_item_delegate_set_editor_data = qt6cr_styled_item_delegate_set_editor_data(handle : Handle, editor : Handle, index : Handle)
    fun qt6cr_styled_item_delegate_set_model_data = qt6cr_styled_item_delegate_set_model_data(handle : Handle, editor : Handle, model : Handle, index : Handle)

    fun qt6cr_list_view_create = qt6cr_list_view_create(parent : Handle) : Handle
    fun qt6cr_list_view_set_model = qt6cr_list_view_set_model(handle : Handle, model : Handle)
    fun qt6cr_list_view_set_item_delegate = qt6cr_list_view_set_item_delegate(handle : Handle, delegate : Handle)
    fun qt6cr_list_view_selection_model = qt6cr_list_view_selection_model(handle : Handle) : Handle
    fun qt6cr_list_view_set_selection_model = qt6cr_list_view_set_selection_model(handle : Handle, selection_model : Handle)
    fun qt6cr_list_view_current_index = qt6cr_list_view_current_index(handle : Handle) : Handle
    fun qt6cr_list_view_set_current_index = qt6cr_list_view_set_current_index(handle : Handle, index : Handle)
    fun qt6cr_list_view_selection_mode = qt6cr_list_view_selection_mode(handle : Handle) : LibC::Int
    fun qt6cr_list_view_set_selection_mode = qt6cr_list_view_set_selection_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_list_view_edit_triggers = qt6cr_list_view_edit_triggers(handle : Handle) : LibC::Int
    fun qt6cr_list_view_set_edit_triggers = qt6cr_list_view_set_edit_triggers(handle : Handle, triggers : LibC::Int)
    fun qt6cr_list_view_alternating_row_colors = qt6cr_list_view_alternating_row_colors(handle : Handle) : Bool
    fun qt6cr_list_view_set_alternating_row_colors = qt6cr_list_view_set_alternating_row_colors(handle : Handle, value : Bool)
    fun qt6cr_list_view_drag_enabled = qt6cr_list_view_drag_enabled(handle : Handle) : Bool
    fun qt6cr_list_view_set_drag_enabled = qt6cr_list_view_set_drag_enabled(handle : Handle, value : Bool)
    fun qt6cr_list_view_drag_drop_mode = qt6cr_list_view_drag_drop_mode(handle : Handle) : LibC::Int
    fun qt6cr_list_view_set_drag_drop_mode = qt6cr_list_view_set_drag_drop_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_list_view_default_drop_action = qt6cr_list_view_default_drop_action(handle : Handle) : LibC::Int
    fun qt6cr_list_view_set_default_drop_action = qt6cr_list_view_set_default_drop_action(handle : Handle, action : LibC::Int)
    fun qt6cr_list_view_drop_indicator_shown = qt6cr_list_view_drop_indicator_shown(handle : Handle) : Bool
    fun qt6cr_list_view_set_drop_indicator_shown = qt6cr_list_view_set_drop_indicator_shown(handle : Handle, value : Bool)
    fun qt6cr_list_view_open_persistent_editor = qt6cr_list_view_open_persistent_editor(handle : Handle, index : Handle)
    fun qt6cr_list_view_close_persistent_editor = qt6cr_list_view_close_persistent_editor(handle : Handle, index : Handle)
    fun qt6cr_list_view_is_persistent_editor_open = qt6cr_list_view_is_persistent_editor_open(handle : Handle, index : Handle) : Bool
    fun qt6cr_list_view_on_current_index_changed = qt6cr_list_view_on_current_index_changed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_tree_view_create = qt6cr_tree_view_create(parent : Handle) : Handle
    fun qt6cr_tree_view_set_model = qt6cr_tree_view_set_model(handle : Handle, model : Handle)
    fun qt6cr_tree_view_set_item_delegate = qt6cr_tree_view_set_item_delegate(handle : Handle, delegate : Handle)
    fun qt6cr_tree_view_selection_model = qt6cr_tree_view_selection_model(handle : Handle) : Handle
    fun qt6cr_tree_view_set_selection_model = qt6cr_tree_view_set_selection_model(handle : Handle, selection_model : Handle)
    fun qt6cr_tree_view_current_index = qt6cr_tree_view_current_index(handle : Handle) : Handle
    fun qt6cr_tree_view_set_current_index = qt6cr_tree_view_set_current_index(handle : Handle, index : Handle)
    fun qt6cr_tree_view_selection_mode = qt6cr_tree_view_selection_mode(handle : Handle) : LibC::Int
    fun qt6cr_tree_view_set_selection_mode = qt6cr_tree_view_set_selection_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_tree_view_edit_triggers = qt6cr_tree_view_edit_triggers(handle : Handle) : LibC::Int
    fun qt6cr_tree_view_set_edit_triggers = qt6cr_tree_view_set_edit_triggers(handle : Handle, triggers : LibC::Int)
    fun qt6cr_tree_view_alternating_row_colors = qt6cr_tree_view_alternating_row_colors(handle : Handle) : Bool
    fun qt6cr_tree_view_set_alternating_row_colors = qt6cr_tree_view_set_alternating_row_colors(handle : Handle, value : Bool)
    fun qt6cr_tree_view_header_hidden = qt6cr_tree_view_header_hidden(handle : Handle) : Bool
    fun qt6cr_tree_view_set_header_hidden = qt6cr_tree_view_set_header_hidden(handle : Handle, value : Bool)
    fun qt6cr_tree_view_root_is_decorated = qt6cr_tree_view_root_is_decorated(handle : Handle) : Bool
    fun qt6cr_tree_view_set_root_is_decorated = qt6cr_tree_view_set_root_is_decorated(handle : Handle, value : Bool)
    fun qt6cr_tree_view_uniform_row_heights = qt6cr_tree_view_uniform_row_heights(handle : Handle) : Bool
    fun qt6cr_tree_view_set_uniform_row_heights = qt6cr_tree_view_set_uniform_row_heights(handle : Handle, value : Bool)
    fun qt6cr_tree_view_indentation = qt6cr_tree_view_indentation(handle : Handle) : LibC::Int
    fun qt6cr_tree_view_set_indentation = qt6cr_tree_view_set_indentation(handle : Handle, value : LibC::Int)
    fun qt6cr_tree_view_drag_enabled = qt6cr_tree_view_drag_enabled(handle : Handle) : Bool
    fun qt6cr_tree_view_set_drag_enabled = qt6cr_tree_view_set_drag_enabled(handle : Handle, value : Bool)
    fun qt6cr_tree_view_drag_drop_mode = qt6cr_tree_view_drag_drop_mode(handle : Handle) : LibC::Int
    fun qt6cr_tree_view_set_drag_drop_mode = qt6cr_tree_view_set_drag_drop_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_tree_view_default_drop_action = qt6cr_tree_view_default_drop_action(handle : Handle) : LibC::Int
    fun qt6cr_tree_view_set_default_drop_action = qt6cr_tree_view_set_default_drop_action(handle : Handle, action : LibC::Int)
    fun qt6cr_tree_view_drop_indicator_shown = qt6cr_tree_view_drop_indicator_shown(handle : Handle) : Bool
    fun qt6cr_tree_view_set_drop_indicator_shown = qt6cr_tree_view_set_drop_indicator_shown(handle : Handle, value : Bool)
    fun qt6cr_tree_view_open_persistent_editor = qt6cr_tree_view_open_persistent_editor(handle : Handle, index : Handle)
    fun qt6cr_tree_view_close_persistent_editor = qt6cr_tree_view_close_persistent_editor(handle : Handle, index : Handle)
    fun qt6cr_tree_view_is_persistent_editor_open = qt6cr_tree_view_is_persistent_editor_open(handle : Handle, index : Handle) : Bool
    fun qt6cr_tree_view_expand_all = qt6cr_tree_view_expand_all(handle : Handle)
    fun qt6cr_tree_view_collapse_all = qt6cr_tree_view_collapse_all(handle : Handle)
    fun qt6cr_tree_view_on_current_index_changed = qt6cr_tree_view_on_current_index_changed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_header_view_count = qt6cr_header_view_count(handle : Handle) : LibC::Int
    fun qt6cr_header_view_default_section_size = qt6cr_header_view_default_section_size(handle : Handle) : LibC::Int
    fun qt6cr_header_view_set_default_section_size = qt6cr_header_view_set_default_section_size(handle : Handle, value : LibC::Int)
    fun qt6cr_header_view_stretch_last_section = qt6cr_header_view_stretch_last_section(handle : Handle) : Bool
    fun qt6cr_header_view_set_stretch_last_section = qt6cr_header_view_set_stretch_last_section(handle : Handle, value : Bool)
    fun qt6cr_header_view_section_hidden = qt6cr_header_view_section_hidden(handle : Handle, index : LibC::Int) : Bool
    fun qt6cr_header_view_set_section_hidden = qt6cr_header_view_set_section_hidden(handle : Handle, index : LibC::Int, value : Bool)
    fun qt6cr_header_view_section_resize_mode = qt6cr_header_view_section_resize_mode(handle : Handle, index : LibC::Int) : LibC::Int
    fun qt6cr_header_view_set_section_resize_mode = qt6cr_header_view_set_section_resize_mode(handle : Handle, index : LibC::Int, value : LibC::Int)
    fun qt6cr_header_view_resize_section = qt6cr_header_view_resize_section(handle : Handle, index : LibC::Int, size : LibC::Int)
    fun qt6cr_header_view_section_size = qt6cr_header_view_section_size(handle : Handle, index : LibC::Int) : LibC::Int

    fun qt6cr_table_view_create = qt6cr_table_view_create(parent : Handle) : Handle
    fun qt6cr_table_view_set_model = qt6cr_table_view_set_model(handle : Handle, model : Handle)
    fun qt6cr_table_view_set_item_delegate = qt6cr_table_view_set_item_delegate(handle : Handle, delegate : Handle)
    fun qt6cr_table_view_selection_model = qt6cr_table_view_selection_model(handle : Handle) : Handle
    fun qt6cr_table_view_set_selection_model = qt6cr_table_view_set_selection_model(handle : Handle, selection_model : Handle)
    fun qt6cr_table_view_current_index = qt6cr_table_view_current_index(handle : Handle) : Handle
    fun qt6cr_table_view_set_current_index = qt6cr_table_view_set_current_index(handle : Handle, index : Handle)
    fun qt6cr_table_view_selection_mode = qt6cr_table_view_selection_mode(handle : Handle) : LibC::Int
    fun qt6cr_table_view_set_selection_mode = qt6cr_table_view_set_selection_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_table_view_edit_triggers = qt6cr_table_view_edit_triggers(handle : Handle) : LibC::Int
    fun qt6cr_table_view_set_edit_triggers = qt6cr_table_view_set_edit_triggers(handle : Handle, triggers : LibC::Int)
    fun qt6cr_table_view_selection_behavior = qt6cr_table_view_selection_behavior(handle : Handle) : LibC::Int
    fun qt6cr_table_view_set_selection_behavior = qt6cr_table_view_set_selection_behavior(handle : Handle, behavior : LibC::Int)
    fun qt6cr_table_view_alternating_row_colors = qt6cr_table_view_alternating_row_colors(handle : Handle) : Bool
    fun qt6cr_table_view_set_alternating_row_colors = qt6cr_table_view_set_alternating_row_colors(handle : Handle, value : Bool)
    fun qt6cr_table_view_drag_enabled = qt6cr_table_view_drag_enabled(handle : Handle) : Bool
    fun qt6cr_table_view_set_drag_enabled = qt6cr_table_view_set_drag_enabled(handle : Handle, value : Bool)
    fun qt6cr_table_view_drag_drop_mode = qt6cr_table_view_drag_drop_mode(handle : Handle) : LibC::Int
    fun qt6cr_table_view_set_drag_drop_mode = qt6cr_table_view_set_drag_drop_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_table_view_default_drop_action = qt6cr_table_view_default_drop_action(handle : Handle) : LibC::Int
    fun qt6cr_table_view_set_default_drop_action = qt6cr_table_view_set_default_drop_action(handle : Handle, action : LibC::Int)
    fun qt6cr_table_view_drop_indicator_shown = qt6cr_table_view_drop_indicator_shown(handle : Handle) : Bool
    fun qt6cr_table_view_set_drop_indicator_shown = qt6cr_table_view_set_drop_indicator_shown(handle : Handle, value : Bool)
    fun qt6cr_table_view_show_grid = qt6cr_table_view_show_grid(handle : Handle) : Bool
    fun qt6cr_table_view_set_show_grid = qt6cr_table_view_set_show_grid(handle : Handle, value : Bool)
    fun qt6cr_table_view_word_wrap = qt6cr_table_view_word_wrap(handle : Handle) : Bool
    fun qt6cr_table_view_set_word_wrap = qt6cr_table_view_set_word_wrap(handle : Handle, value : Bool)
    fun qt6cr_table_view_sorting_enabled = qt6cr_table_view_sorting_enabled(handle : Handle) : Bool
    fun qt6cr_table_view_set_sorting_enabled = qt6cr_table_view_set_sorting_enabled(handle : Handle, value : Bool)
    fun qt6cr_table_view_horizontal_header = qt6cr_table_view_horizontal_header(handle : Handle) : Handle
    fun qt6cr_table_view_vertical_header = qt6cr_table_view_vertical_header(handle : Handle) : Handle
    fun qt6cr_table_view_set_span = qt6cr_table_view_set_span(handle : Handle, row : LibC::Int, column : LibC::Int, row_span : LibC::Int, column_span : LibC::Int)
    fun qt6cr_table_view_row_span = qt6cr_table_view_row_span(handle : Handle, row : LibC::Int, column : LibC::Int) : LibC::Int
    fun qt6cr_table_view_column_span = qt6cr_table_view_column_span(handle : Handle, row : LibC::Int, column : LibC::Int) : LibC::Int
    fun qt6cr_table_view_open_persistent_editor = qt6cr_table_view_open_persistent_editor(handle : Handle, index : Handle)
    fun qt6cr_table_view_close_persistent_editor = qt6cr_table_view_close_persistent_editor(handle : Handle, index : Handle)
    fun qt6cr_table_view_is_persistent_editor_open = qt6cr_table_view_is_persistent_editor_open(handle : Handle, index : Handle) : Bool
    fun qt6cr_table_view_on_current_index_changed = qt6cr_table_view_on_current_index_changed(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_table_view_sort_by_column = qt6cr_table_view_sort_by_column(handle : Handle, column : LibC::Int, order : LibC::Int)
    fun qt6cr_table_view_resize_columns_to_contents = qt6cr_table_view_resize_columns_to_contents(handle : Handle)
    fun qt6cr_table_view_resize_rows_to_contents = qt6cr_table_view_resize_rows_to_contents(handle : Handle)

    fun qt6cr_qsvg_generator_create = qt6cr_qsvg_generator_create : Handle
    fun qt6cr_qsvg_generator_destroy = qt6cr_qsvg_generator_destroy(handle : Handle)
    fun qt6cr_qsvg_generator_file_name = qt6cr_qsvg_generator_file_name(handle : Handle) : UInt8*
    fun qt6cr_qsvg_generator_set_file_name = qt6cr_qsvg_generator_set_file_name(handle : Handle, file_name : UInt8*)
    fun qt6cr_qsvg_generator_size = qt6cr_qsvg_generator_size(handle : Handle) : SizeValue
    fun qt6cr_qsvg_generator_set_size = qt6cr_qsvg_generator_set_size(handle : Handle, size : SizeValue)
    fun qt6cr_qsvg_generator_view_box = qt6cr_qsvg_generator_view_box(handle : Handle) : RectFValue
    fun qt6cr_qsvg_generator_set_view_box = qt6cr_qsvg_generator_set_view_box(handle : Handle, rect : RectFValue)
    fun qt6cr_qsvg_generator_title = qt6cr_qsvg_generator_title(handle : Handle) : UInt8*
    fun qt6cr_qsvg_generator_set_title = qt6cr_qsvg_generator_set_title(handle : Handle, title : UInt8*)
    fun qt6cr_qsvg_generator_description = qt6cr_qsvg_generator_description(handle : Handle) : UInt8*
    fun qt6cr_qsvg_generator_set_description = qt6cr_qsvg_generator_set_description(handle : Handle, description : UInt8*)
    fun qt6cr_qsvg_generator_resolution = qt6cr_qsvg_generator_resolution(handle : Handle) : LibC::Int
    fun qt6cr_qsvg_generator_set_resolution = qt6cr_qsvg_generator_set_resolution(handle : Handle, resolution : LibC::Int)

    fun qt6cr_qsvg_renderer_create = qt6cr_qsvg_renderer_create(file_name : UInt8*) : Handle
    fun qt6cr_qsvg_renderer_create_from_data = qt6cr_qsvg_renderer_create_from_data(data : UInt8*, size : LibC::Int) : Handle
    fun qt6cr_qsvg_renderer_destroy = qt6cr_qsvg_renderer_destroy(handle : Handle)
    fun qt6cr_qsvg_renderer_is_valid = qt6cr_qsvg_renderer_is_valid(handle : Handle) : Bool
    fun qt6cr_qsvg_renderer_load = qt6cr_qsvg_renderer_load(handle : Handle, file_name : UInt8*) : Bool
    fun qt6cr_qsvg_renderer_load_data = qt6cr_qsvg_renderer_load_data(handle : Handle, data : UInt8*, size : LibC::Int) : Bool
    fun qt6cr_qsvg_renderer_default_size = qt6cr_qsvg_renderer_default_size(handle : Handle) : SizeValue
    fun qt6cr_qsvg_renderer_view_box = qt6cr_qsvg_renderer_view_box(handle : Handle) : RectFValue
    fun qt6cr_qsvg_renderer_set_view_box = qt6cr_qsvg_renderer_set_view_box(handle : Handle, rect : RectFValue)
    fun qt6cr_qsvg_renderer_element_exists = qt6cr_qsvg_renderer_element_exists(handle : Handle, element_id : UInt8*) : Bool
    fun qt6cr_qsvg_renderer_bounds_on_element = qt6cr_qsvg_renderer_bounds_on_element(handle : Handle, element_id : UInt8*) : RectFValue
    fun qt6cr_qsvg_renderer_render = qt6cr_qsvg_renderer_render(handle : Handle, painter : Handle)
    fun qt6cr_qsvg_renderer_render_with_bounds = qt6cr_qsvg_renderer_render_with_bounds(handle : Handle, painter : Handle, bounds : RectFValue)
    fun qt6cr_qsvg_renderer_render_element = qt6cr_qsvg_renderer_render_element(handle : Handle, painter : Handle, element_id : UInt8*)
    fun qt6cr_qsvg_renderer_render_element_with_bounds = qt6cr_qsvg_renderer_render_element_with_bounds(handle : Handle, painter : Handle, element_id : UInt8*, bounds : RectFValue)

    fun qt6cr_qsvg_widget_create = qt6cr_qsvg_widget_create(parent : Handle, file_name : UInt8*) : Handle
    fun qt6cr_qsvg_widget_load = qt6cr_qsvg_widget_load(handle : Handle, file_name : UInt8*)
    fun qt6cr_qsvg_widget_load_data = qt6cr_qsvg_widget_load_data(handle : Handle, data : UInt8*, size : LibC::Int)
    fun qt6cr_qsvg_widget_renderer = qt6cr_qsvg_widget_renderer(handle : Handle) : Handle
    fun qt6cr_qsvg_widget_size_hint = qt6cr_qsvg_widget_size_hint(handle : Handle) : SizeValue

    fun qt6cr_qpdf_writer_create = qt6cr_qpdf_writer_create(file_name : UInt8*) : Handle
    fun qt6cr_qpdf_writer_destroy = qt6cr_qpdf_writer_destroy(handle : Handle)
    fun qt6cr_qpdf_writer_set_title = qt6cr_qpdf_writer_set_title(handle : Handle, title : UInt8*)
    fun qt6cr_qpdf_writer_set_creator = qt6cr_qpdf_writer_set_creator(handle : Handle, creator : UInt8*)
    fun qt6cr_qpdf_writer_resolution = qt6cr_qpdf_writer_resolution(handle : Handle) : LibC::Int
    fun qt6cr_qpdf_writer_set_resolution = qt6cr_qpdf_writer_set_resolution(handle : Handle, resolution : LibC::Int)
    fun qt6cr_qpdf_writer_set_page_size_points = qt6cr_qpdf_writer_set_page_size_points(handle : Handle, width : LibC::Int, height : LibC::Int)
    fun qt6cr_qpdf_writer_set_page_size_millimeters = qt6cr_qpdf_writer_set_page_size_millimeters(handle : Handle, width : Float64, height : Float64, orientation : LibC::Int)
    fun qt6cr_qpdf_writer_set_page_layout = qt6cr_qpdf_writer_set_page_layout(handle : Handle, width : Float64, height : Float64, unit : LibC::Int, orientation : LibC::Int, left : Float64, top : Float64, right : Float64, bottom : Float64)
    fun qt6cr_qpdf_writer_page_layout_full_rect_points = qt6cr_qpdf_writer_page_layout_full_rect_points(handle : Handle) : RectFValue
    fun qt6cr_qpdf_writer_page_layout_paint_rect_points = qt6cr_qpdf_writer_page_layout_paint_rect_points(handle : Handle) : RectFValue
    fun qt6cr_qpdf_writer_new_page = qt6cr_qpdf_writer_new_page(handle : Handle) : Bool

    fun qt6cr_qbyte_array_create = qt6cr_qbyte_array_create : Handle
    fun qt6cr_qbyte_array_create_from_data = qt6cr_qbyte_array_create_from_data(data : UInt8*, size : LibC::Int) : Handle
    fun qt6cr_qbyte_array_destroy = qt6cr_qbyte_array_destroy(handle : Handle)
    fun qt6cr_qbyte_array_size = qt6cr_qbyte_array_size(handle : Handle) : LibC::Int
    fun qt6cr_qbyte_array_data = qt6cr_qbyte_array_data(handle : Handle) : ByteArrayValue
    fun qt6cr_qbyte_array_clear = qt6cr_qbyte_array_clear(handle : Handle)

    fun qt6cr_io_device_open = qt6cr_io_device_open(handle : Handle, open_mode : LibC::Int) : Bool
    fun qt6cr_io_device_close = qt6cr_io_device_close(handle : Handle)
    fun qt6cr_io_device_is_open = qt6cr_io_device_is_open(handle : Handle) : Bool
    fun qt6cr_io_device_size = qt6cr_io_device_size(handle : Handle) : Int64
    fun qt6cr_io_device_position = qt6cr_io_device_position(handle : Handle) : Int64
    fun qt6cr_io_device_seek = qt6cr_io_device_seek(handle : Handle, position : Int64) : Bool
    fun qt6cr_io_device_at_end = qt6cr_io_device_at_end(handle : Handle) : Bool
    fun qt6cr_io_device_bytes_available = qt6cr_io_device_bytes_available(handle : Handle) : Int64
    fun qt6cr_io_device_read = qt6cr_io_device_read(handle : Handle, size : LibC::Int) : ByteArrayValue
    fun qt6cr_io_device_peek = qt6cr_io_device_peek(handle : Handle, size : LibC::Int) : ByteArrayValue
    fun qt6cr_io_device_read_all = qt6cr_io_device_read_all(handle : Handle) : ByteArrayValue
    fun qt6cr_io_device_write = qt6cr_io_device_write(handle : Handle, data : UInt8*, size : LibC::Int) : Int64

    fun qt6cr_qbuffer_create = qt6cr_qbuffer_create(byte_array : Handle) : Handle
    fun qt6cr_qbuffer_destroy = qt6cr_qbuffer_destroy(handle : Handle)
    fun qt6cr_qbuffer_open = qt6cr_qbuffer_open(handle : Handle, open_mode : LibC::Int) : Bool
    fun qt6cr_qbuffer_close = qt6cr_qbuffer_close(handle : Handle)
    fun qt6cr_qbuffer_is_open = qt6cr_qbuffer_is_open(handle : Handle) : Bool
    fun qt6cr_qbuffer_data = qt6cr_qbuffer_data(handle : Handle) : Handle

    fun qt6cr_qpen_create = qt6cr_qpen_create(color : ColorValue, width : Float64) : Handle
    fun qt6cr_qpen_destroy = qt6cr_qpen_destroy(handle : Handle)
    fun qt6cr_qpen_color = qt6cr_qpen_color(handle : Handle) : ColorValue
    fun qt6cr_qpen_set_color = qt6cr_qpen_set_color(handle : Handle, color : ColorValue)
    fun qt6cr_qpen_width = qt6cr_qpen_width(handle : Handle) : Float64
    fun qt6cr_qpen_set_width = qt6cr_qpen_set_width(handle : Handle, width : Float64)
    fun qt6cr_qpen_style = qt6cr_qpen_style(handle : Handle) : LibC::Int
    fun qt6cr_qpen_set_style = qt6cr_qpen_set_style(handle : Handle, style : LibC::Int)
    fun qt6cr_qpen_cap_style = qt6cr_qpen_cap_style(handle : Handle) : LibC::Int
    fun qt6cr_qpen_set_cap_style = qt6cr_qpen_set_cap_style(handle : Handle, style : LibC::Int)
    fun qt6cr_qpen_join_style = qt6cr_qpen_join_style(handle : Handle) : LibC::Int
    fun qt6cr_qpen_set_join_style = qt6cr_qpen_set_join_style(handle : Handle, style : LibC::Int)
    fun qt6cr_qpen_dash_offset = qt6cr_qpen_dash_offset(handle : Handle) : Float64
    fun qt6cr_qpen_set_dash_offset = qt6cr_qpen_set_dash_offset(handle : Handle, offset : Float64)
    fun qt6cr_qpen_set_dash_pattern = qt6cr_qpen_set_dash_pattern(handle : Handle, values : Float64*, size : LibC::Int)

    fun qt6cr_qlinear_gradient_create = qt6cr_qlinear_gradient_create(x1 : Float64, y1 : Float64, x2 : Float64, y2 : Float64) : Handle
    fun qt6cr_qlinear_gradient_destroy = qt6cr_qlinear_gradient_destroy(handle : Handle)
    fun qt6cr_qlinear_gradient_set_color_at = qt6cr_qlinear_gradient_set_color_at(handle : Handle, position : Float64, color : ColorValue)
    fun qt6cr_qlinear_gradient_start = qt6cr_qlinear_gradient_start(handle : Handle) : PointFValue
    fun qt6cr_qlinear_gradient_final_stop = qt6cr_qlinear_gradient_final_stop(handle : Handle) : PointFValue

    fun qt6cr_qradial_gradient_create = qt6cr_qradial_gradient_create(center_x : Float64, center_y : Float64, radius : Float64) : Handle
    fun qt6cr_qradial_gradient_destroy = qt6cr_qradial_gradient_destroy(handle : Handle)
    fun qt6cr_qradial_gradient_set_color_at = qt6cr_qradial_gradient_set_color_at(handle : Handle, position : Float64, color : ColorValue)
    fun qt6cr_qradial_gradient_center = qt6cr_qradial_gradient_center(handle : Handle) : PointFValue
    fun qt6cr_qradial_gradient_radius = qt6cr_qradial_gradient_radius(handle : Handle) : Float64

    fun qt6cr_qbrush_create = qt6cr_qbrush_create(color : ColorValue) : Handle
    fun qt6cr_qbrush_create_from_pixmap = qt6cr_qbrush_create_from_pixmap(pixmap : Handle) : Handle
    fun qt6cr_qbrush_create_from_image = qt6cr_qbrush_create_from_image(image : Handle) : Handle
    fun qt6cr_qbrush_create_from_linear_gradient = qt6cr_qbrush_create_from_linear_gradient(gradient : Handle) : Handle
    fun qt6cr_qbrush_create_from_radial_gradient = qt6cr_qbrush_create_from_radial_gradient(gradient : Handle) : Handle
    fun qt6cr_qbrush_destroy = qt6cr_qbrush_destroy(handle : Handle)
    fun qt6cr_qbrush_color = qt6cr_qbrush_color(handle : Handle) : ColorValue
    fun qt6cr_qbrush_set_color = qt6cr_qbrush_set_color(handle : Handle, color : ColorValue)
    fun qt6cr_qbrush_transform = qt6cr_qbrush_transform(handle : Handle) : Handle
    fun qt6cr_qbrush_set_transform = qt6cr_qbrush_set_transform(handle : Handle, transform : Handle)

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

    fun qt6cr_qfont_metrics_create = qt6cr_qfont_metrics_create(font : Handle) : Handle
    fun qt6cr_qfont_metrics_destroy = qt6cr_qfont_metrics_destroy(handle : Handle)
    fun qt6cr_qfont_metrics_height = qt6cr_qfont_metrics_height(handle : Handle) : LibC::Int
    fun qt6cr_qfont_metrics_ascent = qt6cr_qfont_metrics_ascent(handle : Handle) : LibC::Int
    fun qt6cr_qfont_metrics_descent = qt6cr_qfont_metrics_descent(handle : Handle) : LibC::Int
    fun qt6cr_qfont_metrics_horizontal_advance = qt6cr_qfont_metrics_horizontal_advance(handle : Handle, text : UInt8*) : LibC::Int
    fun qt6cr_qfont_metrics_bounding_rect = qt6cr_qfont_metrics_bounding_rect(handle : Handle, text : UInt8*) : RectFValue

    fun qt6cr_qfont_metrics_f_create = qt6cr_qfont_metrics_f_create(font : Handle) : Handle
    fun qt6cr_qfont_metrics_f_destroy = qt6cr_qfont_metrics_f_destroy(handle : Handle)
    fun qt6cr_qfont_metrics_f_height = qt6cr_qfont_metrics_f_height(handle : Handle) : Float64
    fun qt6cr_qfont_metrics_f_ascent = qt6cr_qfont_metrics_f_ascent(handle : Handle) : Float64
    fun qt6cr_qfont_metrics_f_descent = qt6cr_qfont_metrics_f_descent(handle : Handle) : Float64
    fun qt6cr_qfont_metrics_f_horizontal_advance = qt6cr_qfont_metrics_f_horizontal_advance(handle : Handle, text : UInt8*) : Float64
    fun qt6cr_qfont_metrics_f_bounding_rect = qt6cr_qfont_metrics_f_bounding_rect(handle : Handle, text : UInt8*) : RectFValue

    fun qt6cr_qurl_create = qt6cr_qurl_create(value : UInt8*) : Handle
    fun qt6cr_qurl_create_from_local_file = qt6cr_qurl_create_from_local_file(path : UInt8*) : Handle
    fun qt6cr_qurl_destroy = qt6cr_qurl_destroy(handle : Handle)
    fun qt6cr_qurl_is_valid = qt6cr_qurl_is_valid(handle : Handle) : Bool
    fun qt6cr_qurl_is_local_file = qt6cr_qurl_is_local_file(handle : Handle) : Bool
    fun qt6cr_qurl_scheme = qt6cr_qurl_scheme(handle : Handle) : UInt8*
    fun qt6cr_qurl_path = qt6cr_qurl_path(handle : Handle) : UInt8*
    fun qt6cr_qurl_to_string = qt6cr_qurl_to_string(handle : Handle) : UInt8*
    fun qt6cr_qurl_to_local_file = qt6cr_qurl_to_local_file(handle : Handle) : UInt8*

    fun qt6cr_qdir_create = qt6cr_qdir_create(path : UInt8*) : Handle
    fun qt6cr_qdir_destroy = qt6cr_qdir_destroy(handle : Handle)
    fun qt6cr_qdir_path = qt6cr_qdir_path(handle : Handle) : UInt8*
    fun qt6cr_qdir_absolute_path = qt6cr_qdir_absolute_path(handle : Handle) : UInt8*
    fun qt6cr_qdir_exists = qt6cr_qdir_exists(handle : Handle) : Bool
    fun qt6cr_qdir_file_path = qt6cr_qdir_file_path(handle : Handle, name : UInt8*) : UInt8*
    fun qt6cr_qdir_absolute_file_path = qt6cr_qdir_absolute_file_path(handle : Handle, name : UInt8*) : UInt8*
    fun qt6cr_qdir_mkpath = qt6cr_qdir_mkpath(handle : Handle, path : UInt8*) : Bool
    fun qt6cr_qdir_current_path = qt6cr_qdir_current_path : UInt8*
    fun qt6cr_qdir_home_path = qt6cr_qdir_home_path : UInt8*
    fun qt6cr_qdir_clean_path = qt6cr_qdir_clean_path(path : UInt8*) : UInt8*

    fun qt6cr_qfile_create = qt6cr_qfile_create(file_name : UInt8*) : Handle
    fun qt6cr_qfile_destroy = qt6cr_qfile_destroy(handle : Handle)
    fun qt6cr_qfile_file_name = qt6cr_qfile_file_name(handle : Handle) : UInt8*
    fun qt6cr_qfile_set_file_name = qt6cr_qfile_set_file_name(handle : Handle, file_name : UInt8*)
    fun qt6cr_qfile_exists = qt6cr_qfile_exists(handle : Handle) : Bool
    fun qt6cr_qfile_exists_at_path = qt6cr_qfile_exists_at_path(file_name : UInt8*) : Bool
    fun qt6cr_qfile_open = qt6cr_qfile_open(handle : Handle, open_mode : LibC::Int) : Bool
    fun qt6cr_qfile_close = qt6cr_qfile_close(handle : Handle)
    fun qt6cr_qfile_is_open = qt6cr_qfile_is_open(handle : Handle) : Bool
    fun qt6cr_qfile_size = qt6cr_qfile_size(handle : Handle) : Int64
    fun qt6cr_qfile_read_all = qt6cr_qfile_read_all(handle : Handle) : ByteArrayValue
    fun qt6cr_qfile_write = qt6cr_qfile_write(handle : Handle, data : UInt8*, size : LibC::Int) : Int64
    fun qt6cr_qfile_flush = qt6cr_qfile_flush(handle : Handle) : Bool
    fun qt6cr_qfile_remove = qt6cr_qfile_remove(handle : Handle) : Bool

    fun qt6cr_qsettings_create_from_file = qt6cr_qsettings_create_from_file(file_name : UInt8*, format : LibC::Int) : Handle
    fun qt6cr_qsettings_create_for_application = qt6cr_qsettings_create_for_application(organization : UInt8*, application : UInt8*, format : LibC::Int) : Handle
    fun qt6cr_qsettings_destroy = qt6cr_qsettings_destroy(handle : Handle)
    fun qt6cr_qsettings_file_name = qt6cr_qsettings_file_name(handle : Handle) : UInt8*
    fun qt6cr_qsettings_contains = qt6cr_qsettings_contains(handle : Handle, key : UInt8*) : Bool
    fun qt6cr_qsettings_value = qt6cr_qsettings_value(handle : Handle, key : UInt8*, default_value : VariantValue) : VariantValue
    fun qt6cr_qsettings_set_value = qt6cr_qsettings_set_value(handle : Handle, key : UInt8*, value : VariantValue)
    fun qt6cr_qsettings_remove = qt6cr_qsettings_remove(handle : Handle, key : UInt8*)
    fun qt6cr_qsettings_clear = qt6cr_qsettings_clear(handle : Handle)
    fun qt6cr_qsettings_sync = qt6cr_qsettings_sync(handle : Handle)
    fun qt6cr_qsettings_all_keys = qt6cr_qsettings_all_keys(handle : Handle) : StringArrayValue

    fun qt6cr_standard_paths_writable_location = qt6cr_standard_paths_writable_location(location : LibC::Int) : UInt8*
    fun qt6cr_standard_paths_standard_locations = qt6cr_standard_paths_standard_locations(location : LibC::Int) : StringArrayValue
    fun qt6cr_standard_paths_display_name = qt6cr_standard_paths_display_name(location : LibC::Int) : UInt8*

    fun qt6cr_desktop_services_open_url = qt6cr_desktop_services_open_url(url : Handle) : Bool

    fun qt6cr_qfile_info_create = qt6cr_qfile_info_create(path : UInt8*) : Handle
    fun qt6cr_qfile_info_destroy = qt6cr_qfile_info_destroy(handle : Handle)
    fun qt6cr_qfile_info_file_name = qt6cr_qfile_info_file_name(handle : Handle) : UInt8*
    fun qt6cr_qfile_info_base_name = qt6cr_qfile_info_base_name(handle : Handle) : UInt8*
    fun qt6cr_qfile_info_suffix = qt6cr_qfile_info_suffix(handle : Handle) : UInt8*
    fun qt6cr_qfile_info_absolute_file_path = qt6cr_qfile_info_absolute_file_path(handle : Handle) : UInt8*
    fun qt6cr_qfile_info_absolute_path = qt6cr_qfile_info_absolute_path(handle : Handle) : UInt8*
    fun qt6cr_qfile_info_exists = qt6cr_qfile_info_exists(handle : Handle) : Bool
    fun qt6cr_qfile_info_is_file = qt6cr_qfile_info_is_file(handle : Handle) : Bool
    fun qt6cr_qfile_info_is_dir = qt6cr_qfile_info_is_dir(handle : Handle) : Bool
    fun qt6cr_qfile_info_size = qt6cr_qfile_info_size(handle : Handle) : Int64

    fun qt6cr_qdate_create = qt6cr_qdate_create(year : LibC::Int, month : LibC::Int, day : LibC::Int) : Handle
    fun qt6cr_qdate_destroy = qt6cr_qdate_destroy(handle : Handle)
    fun qt6cr_qdate_year = qt6cr_qdate_year(handle : Handle) : LibC::Int
    fun qt6cr_qdate_month = qt6cr_qdate_month(handle : Handle) : LibC::Int
    fun qt6cr_qdate_day = qt6cr_qdate_day(handle : Handle) : LibC::Int
    fun qt6cr_qdate_is_valid = qt6cr_qdate_is_valid(handle : Handle) : Bool
    fun qt6cr_qdate_to_string = qt6cr_qdate_to_string(handle : Handle, format : UInt8*) : UInt8*

    fun qt6cr_qtime_create = qt6cr_qtime_create(hour : LibC::Int, minute : LibC::Int, second : LibC::Int) : Handle
    fun qt6cr_qtime_destroy = qt6cr_qtime_destroy(handle : Handle)
    fun qt6cr_qtime_hour = qt6cr_qtime_hour(handle : Handle) : LibC::Int
    fun qt6cr_qtime_minute = qt6cr_qtime_minute(handle : Handle) : LibC::Int
    fun qt6cr_qtime_second = qt6cr_qtime_second(handle : Handle) : LibC::Int
    fun qt6cr_qtime_is_valid = qt6cr_qtime_is_valid(handle : Handle) : Bool
    fun qt6cr_qtime_to_string = qt6cr_qtime_to_string(handle : Handle, format : UInt8*) : UInt8*

    fun qt6cr_qdatetime_create = qt6cr_qdatetime_create(year : LibC::Int, month : LibC::Int, day : LibC::Int, hour : LibC::Int, minute : LibC::Int, second : LibC::Int) : Handle
    fun qt6cr_qdatetime_destroy = qt6cr_qdatetime_destroy(handle : Handle)
    fun qt6cr_qdatetime_date = qt6cr_qdatetime_date(handle : Handle) : Handle
    fun qt6cr_qdatetime_time = qt6cr_qdatetime_time(handle : Handle) : Handle
    fun qt6cr_qdatetime_is_valid = qt6cr_qdatetime_is_valid(handle : Handle) : Bool
    fun qt6cr_qdatetime_to_string = qt6cr_qdatetime_to_string(handle : Handle, format : UInt8*) : UInt8*

    fun qt6cr_qtransform_create = qt6cr_qtransform_create : Handle
    fun qt6cr_qtransform_destroy = qt6cr_qtransform_destroy(handle : Handle)
    fun qt6cr_qtransform_copy = qt6cr_qtransform_copy(handle : Handle) : Handle
    fun qt6cr_qtransform_reset = qt6cr_qtransform_reset(handle : Handle)
    fun qt6cr_qtransform_translate = qt6cr_qtransform_translate(handle : Handle, dx : Float64, dy : Float64)
    fun qt6cr_qtransform_scale = qt6cr_qtransform_scale(handle : Handle, sx : Float64, sy : Float64)
    fun qt6cr_qtransform_rotate = qt6cr_qtransform_rotate(handle : Handle, angle : Float64)
    fun qt6cr_qtransform_map_point = qt6cr_qtransform_map_point(handle : Handle, point : PointFValue) : PointFValue
    fun qt6cr_qtransform_map_rect = qt6cr_qtransform_map_rect(handle : Handle, rect : RectFValue) : RectFValue
    fun qt6cr_qtransform_map_path = qt6cr_qtransform_map_path(handle : Handle, path : Handle) : Handle

    fun qt6cr_qpolygonf_create = qt6cr_qpolygonf_create : Handle
    fun qt6cr_qpolygonf_destroy = qt6cr_qpolygonf_destroy(handle : Handle)
    fun qt6cr_qpolygonf_append = qt6cr_qpolygonf_append(handle : Handle, point : PointFValue)
    fun qt6cr_qpolygonf_size = qt6cr_qpolygonf_size(handle : Handle) : LibC::Int
    fun qt6cr_qpolygonf_at = qt6cr_qpolygonf_at(handle : Handle, index : LibC::Int) : PointFValue
    fun qt6cr_qpolygonf_bounding_rect = qt6cr_qpolygonf_bounding_rect(handle : Handle) : RectFValue

    fun qt6cr_qpainter_path_create = qt6cr_qpainter_path_create : Handle
    fun qt6cr_qpainter_path_destroy = qt6cr_qpainter_path_destroy(handle : Handle)
    fun qt6cr_qpainter_path_clear = qt6cr_qpainter_path_clear(handle : Handle)
    fun qt6cr_qpainter_path_move_to = qt6cr_qpainter_path_move_to(handle : Handle, point : PointFValue)
    fun qt6cr_qpainter_path_line_to = qt6cr_qpainter_path_line_to(handle : Handle, point : PointFValue)
    fun qt6cr_qpainter_path_quad_to = qt6cr_qpainter_path_quad_to(handle : Handle, control_point : PointFValue, end_point : PointFValue)
    fun qt6cr_qpainter_path_cubic_to = qt6cr_qpainter_path_cubic_to(handle : Handle, control_point1 : PointFValue, control_point2 : PointFValue, end_point : PointFValue)
    fun qt6cr_qpainter_path_add_rect = qt6cr_qpainter_path_add_rect(handle : Handle, rect : RectFValue)
    fun qt6cr_qpainter_path_add_ellipse = qt6cr_qpainter_path_add_ellipse(handle : Handle, rect : RectFValue)
    fun qt6cr_qpainter_path_add_polygon = qt6cr_qpainter_path_add_polygon(handle : Handle, polygon : Handle)
    fun qt6cr_qpainter_path_add_path = qt6cr_qpainter_path_add_path(handle : Handle, other : Handle)
    fun qt6cr_qpainter_path_connect_path = qt6cr_qpainter_path_connect_path(handle : Handle, other : Handle)
    fun qt6cr_qpainter_path_close_subpath = qt6cr_qpainter_path_close_subpath(handle : Handle)
    fun qt6cr_qpainter_path_current_position = qt6cr_qpainter_path_current_position(handle : Handle) : PointFValue
    fun qt6cr_qpainter_path_element_count = qt6cr_qpainter_path_element_count(handle : Handle) : LibC::Int
    fun qt6cr_qpainter_path_element_at = qt6cr_qpainter_path_element_at(handle : Handle, index : LibC::Int) : PainterPathElementValue
    fun qt6cr_qpainter_path_bounding_rect = qt6cr_qpainter_path_bounding_rect(handle : Handle) : RectFValue
    fun qt6cr_qpainter_path_control_point_rect = qt6cr_qpainter_path_control_point_rect(handle : Handle) : RectFValue
    fun qt6cr_qpainter_path_transformed = qt6cr_qpainter_path_transformed(handle : Handle, transform : Handle) : Handle
    fun qt6cr_qpainter_path_translated = qt6cr_qpainter_path_translated(handle : Handle, dx : Float64, dy : Float64) : Handle
    fun qt6cr_qpainter_path_simplified = qt6cr_qpainter_path_simplified(handle : Handle) : Handle
    fun qt6cr_qpainter_path_contains = qt6cr_qpainter_path_contains(handle : Handle, point : PointFValue) : Bool
    fun qt6cr_qpainter_path_contains_rect = qt6cr_qpainter_path_contains_rect(handle : Handle, rect : RectFValue) : Bool
    fun qt6cr_qpainter_path_intersects_rect = qt6cr_qpainter_path_intersects_rect(handle : Handle, rect : RectFValue) : Bool
    fun qt6cr_qpainter_path_is_empty = qt6cr_qpainter_path_is_empty(handle : Handle) : Bool

    fun qt6cr_qpainter_path_stroker_create = qt6cr_qpainter_path_stroker_create : Handle
    fun qt6cr_qpainter_path_stroker_destroy = qt6cr_qpainter_path_stroker_destroy(handle : Handle)
    fun qt6cr_qpainter_path_stroker_width = qt6cr_qpainter_path_stroker_width(handle : Handle) : Float64
    fun qt6cr_qpainter_path_stroker_set_width = qt6cr_qpainter_path_stroker_set_width(handle : Handle, width : Float64)
    fun qt6cr_qpainter_path_stroker_create_stroke = qt6cr_qpainter_path_stroker_create_stroke(handle : Handle, path : Handle) : Handle

    fun qt6cr_qpainter_create_for_image = qt6cr_qpainter_create_for_image(image : Handle) : Handle
    fun qt6cr_qpainter_create_for_pixmap = qt6cr_qpainter_create_for_pixmap(pixmap : Handle) : Handle
    fun qt6cr_qpainter_create_for_svg_generator = qt6cr_qpainter_create_for_svg_generator(svg_generator : Handle) : Handle
    fun qt6cr_qpainter_create_for_pdf_writer = qt6cr_qpainter_create_for_pdf_writer(pdf_writer : Handle) : Handle
    fun qt6cr_qpainter_destroy = qt6cr_qpainter_destroy(handle : Handle)
    fun qt6cr_qpainter_is_active = qt6cr_qpainter_is_active(handle : Handle) : Bool
    fun qt6cr_qpainter_end = qt6cr_qpainter_end(handle : Handle) : Bool
    fun qt6cr_qpainter_set_antialiasing = qt6cr_qpainter_set_antialiasing(handle : Handle, value : Bool)
    fun qt6cr_qpainter_set_smooth_pixmap_transform = qt6cr_qpainter_set_smooth_pixmap_transform(handle : Handle, value : Bool)
    fun qt6cr_qpainter_set_pen_color = qt6cr_qpainter_set_pen_color(handle : Handle, color : ColorValue)
    fun qt6cr_qpainter_set_pen = qt6cr_qpainter_set_pen(handle : Handle, pen : Handle)
    fun qt6cr_qpainter_set_brush_color = qt6cr_qpainter_set_brush_color(handle : Handle, color : ColorValue)
    fun qt6cr_qpainter_set_brush = qt6cr_qpainter_set_brush(handle : Handle, brush : Handle)
    fun qt6cr_qpainter_set_font = qt6cr_qpainter_set_font(handle : Handle, font : Handle)
    fun qt6cr_qpainter_set_transform = qt6cr_qpainter_set_transform(handle : Handle, transform : Handle)
    fun qt6cr_qpainter_reset_transform = qt6cr_qpainter_reset_transform(handle : Handle)
    fun qt6cr_qpainter_translate = qt6cr_qpainter_translate(handle : Handle, dx : Float64, dy : Float64)
    fun qt6cr_qpainter_scale = qt6cr_qpainter_scale(handle : Handle, sx : Float64, sy : Float64)
    fun qt6cr_qpainter_rotate = qt6cr_qpainter_rotate(handle : Handle, angle : Float64)
    fun qt6cr_qpainter_save = qt6cr_qpainter_save(handle : Handle)
    fun qt6cr_qpainter_restore = qt6cr_qpainter_restore(handle : Handle)
    fun qt6cr_qpainter_opacity = qt6cr_qpainter_opacity(handle : Handle) : Float64
    fun qt6cr_qpainter_set_opacity = qt6cr_qpainter_set_opacity(handle : Handle, value : Float64)
    fun qt6cr_qpainter_composition_mode = qt6cr_qpainter_composition_mode(handle : Handle) : LibC::Int
    fun qt6cr_qpainter_set_composition_mode = qt6cr_qpainter_set_composition_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_qpainter_set_clipping = qt6cr_qpainter_set_clipping(handle : Handle, value : Bool)
    fun qt6cr_qpainter_set_clip_path = qt6cr_qpainter_set_clip_path(handle : Handle, path : Handle)
    fun qt6cr_qpainter_set_clip_rect = qt6cr_qpainter_set_clip_rect(handle : Handle, rect : RectFValue)
    fun qt6cr_qpainter_draw_line = qt6cr_qpainter_draw_line(handle : Handle, from_point : PointFValue, to_point : PointFValue)
    fun qt6cr_qpainter_draw_rect = qt6cr_qpainter_draw_rect(handle : Handle, rect : RectFValue)
    fun qt6cr_qpainter_fill_rect = qt6cr_qpainter_fill_rect(handle : Handle, rect : RectFValue, color : ColorValue)
    fun qt6cr_qpainter_fill_rect_brush = qt6cr_qpainter_fill_rect_brush(handle : Handle, rect : RectFValue, brush : Handle)
    fun qt6cr_qpainter_draw_ellipse = qt6cr_qpainter_draw_ellipse(handle : Handle, rect : RectFValue)
    fun qt6cr_qpainter_draw_ellipse_center = qt6cr_qpainter_draw_ellipse_center(handle : Handle, center : PointFValue, rx : Float64, ry : Float64)
    fun qt6cr_qpainter_draw_path = qt6cr_qpainter_draw_path(handle : Handle, path : Handle)
    fun qt6cr_qpainter_draw_polygon = qt6cr_qpainter_draw_polygon(handle : Handle, polygon : Handle)
    fun qt6cr_qpainter_draw_image = qt6cr_qpainter_draw_image(handle : Handle, position : PointFValue, image : Handle)
    fun qt6cr_qpainter_draw_image_xy = qt6cr_qpainter_draw_image_xy(handle : Handle, x : Float64, y : Float64, image : Handle)
    fun qt6cr_qpainter_draw_image_rect = qt6cr_qpainter_draw_image_rect(handle : Handle, rect : RectFValue, image : Handle)
    fun qt6cr_qpainter_draw_image_rect_source = qt6cr_qpainter_draw_image_rect_source(handle : Handle, target : RectFValue, image : Handle, source : RectFValue)
    fun qt6cr_qpainter_draw_pixmap = qt6cr_qpainter_draw_pixmap(handle : Handle, position : PointFValue, pixmap : Handle)
    fun qt6cr_qpainter_draw_pixmap_xy = qt6cr_qpainter_draw_pixmap_xy(handle : Handle, x : Float64, y : Float64, pixmap : Handle)
    fun qt6cr_qpainter_draw_pixmap_rect = qt6cr_qpainter_draw_pixmap_rect(handle : Handle, rect : RectFValue, pixmap : Handle)
    fun qt6cr_qpainter_draw_pixmap_rect_source = qt6cr_qpainter_draw_pixmap_rect_source(handle : Handle, target : RectFValue, pixmap : Handle, source : RectFValue)
    fun qt6cr_qpainter_draw_point = qt6cr_qpainter_draw_point(handle : Handle, point : PointFValue)
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
    fun qt6cr_input_dialog_set_combo_box_items = qt6cr_input_dialog_set_combo_box_items(handle : Handle, items : UInt8**, count : LibC::Int)
    fun qt6cr_input_dialog_combo_box_item_count = qt6cr_input_dialog_combo_box_item_count(handle : Handle) : LibC::Int
    fun qt6cr_input_dialog_combo_box_item_text = qt6cr_input_dialog_combo_box_item_text(handle : Handle, index : LibC::Int) : UInt8*
    fun qt6cr_input_dialog_set_combo_box_editable = qt6cr_input_dialog_set_combo_box_editable(handle : Handle, editable : Bool)
    fun qt6cr_input_dialog_combo_box_editable = qt6cr_input_dialog_combo_box_editable(handle : Handle) : Bool
    fun qt6cr_input_dialog_get_item = qt6cr_input_dialog_get_item(parent : Handle, title : UInt8*, label : UInt8*, items : UInt8**, count : LibC::Int, current : LibC::Int, editable : Bool) : UInt8*

    fun qt6cr_dock_widget_create = qt6cr_dock_widget_create(parent : Handle, title : UInt8*) : Handle
    fun qt6cr_dock_widget_set_widget = qt6cr_dock_widget_set_widget(handle : Handle, widget : Handle)
    fun qt6cr_dock_widget_toggle_view_action = qt6cr_dock_widget_toggle_view_action(handle : Handle) : Handle

    fun qt6cr_action_create = qt6cr_action_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_action_set_text = qt6cr_action_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_action_text = qt6cr_action_text(handle : Handle) : UInt8*
    fun qt6cr_action_set_shortcut = qt6cr_action_set_shortcut(handle : Handle, shortcut : UInt8*)
    fun qt6cr_action_shortcut = qt6cr_action_shortcut(handle : Handle) : UInt8*
    fun qt6cr_action_set_checkable = qt6cr_action_set_checkable(handle : Handle, value : Bool)
    fun qt6cr_action_is_checkable = qt6cr_action_is_checkable(handle : Handle) : Bool
    fun qt6cr_action_set_checked = qt6cr_action_set_checked(handle : Handle, value : Bool)
    fun qt6cr_action_is_checked = qt6cr_action_is_checked(handle : Handle) : Bool
    fun qt6cr_action_set_enabled = qt6cr_action_set_enabled(handle : Handle, value : Bool)
    fun qt6cr_action_is_enabled = qt6cr_action_is_enabled(handle : Handle) : Bool
    fun qt6cr_action_set_tool_tip = qt6cr_action_set_tool_tip(handle : Handle, tool_tip : UInt8*)
    fun qt6cr_action_tool_tip = qt6cr_action_tool_tip(handle : Handle) : UInt8*
    fun qt6cr_action_set_status_tip = qt6cr_action_set_status_tip(handle : Handle, status_tip : UInt8*)
    fun qt6cr_action_status_tip = qt6cr_action_status_tip(handle : Handle) : UInt8*
    fun qt6cr_action_set_visible = qt6cr_action_set_visible(handle : Handle, value : Bool)
    fun qt6cr_action_is_visible = qt6cr_action_is_visible(handle : Handle) : Bool
    fun qt6cr_action_set_separator = qt6cr_action_set_separator(handle : Handle, value : Bool)
    fun qt6cr_action_is_separator = qt6cr_action_is_separator(handle : Handle) : Bool
    fun qt6cr_action_set_data = qt6cr_action_set_data(handle : Handle, value : VariantValue)
    fun qt6cr_action_data = qt6cr_action_data(handle : Handle) : VariantValue
    fun qt6cr_action_on_triggered = qt6cr_action_on_triggered(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_action_on_toggled = qt6cr_action_on_toggled(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)
    fun qt6cr_action_trigger = qt6cr_action_trigger(handle : Handle)

    fun qt6cr_action_group_create = qt6cr_action_group_create(parent : Handle) : Handle
    fun qt6cr_action_group_add_action = qt6cr_action_group_add_action(handle : Handle, action : Handle)
    fun qt6cr_action_group_set_exclusive = qt6cr_action_group_set_exclusive(handle : Handle, value : Bool)
    fun qt6cr_action_group_is_exclusive = qt6cr_action_group_is_exclusive(handle : Handle) : Bool

    fun qt6cr_undo_command_create = qt6cr_undo_command_create(text : UInt8*) : Handle
    fun qt6cr_undo_command_destroy = qt6cr_undo_command_destroy(handle : Handle)
    fun qt6cr_undo_command_set_callbacks = qt6cr_undo_command_set_callbacks(handle : Handle, redo_callback : (Handle ->), redo_userdata : Handle, undo_callback : (Handle ->), undo_userdata : Handle, destroy_callback : (Handle ->), destroy_userdata : Handle)
    fun qt6cr_undo_command_text = qt6cr_undo_command_text(handle : Handle) : UInt8*
    fun qt6cr_undo_command_set_text = qt6cr_undo_command_set_text(handle : Handle, text : UInt8*)

    fun qt6cr_undo_stack_create = qt6cr_undo_stack_create(parent : Handle) : Handle
    fun qt6cr_undo_stack_push = qt6cr_undo_stack_push(handle : Handle, command : Handle)
    fun qt6cr_undo_stack_clear = qt6cr_undo_stack_clear(handle : Handle)
    fun qt6cr_undo_stack_undo = qt6cr_undo_stack_undo(handle : Handle)
    fun qt6cr_undo_stack_redo = qt6cr_undo_stack_redo(handle : Handle)
    fun qt6cr_undo_stack_can_undo = qt6cr_undo_stack_can_undo(handle : Handle) : Bool
    fun qt6cr_undo_stack_can_redo = qt6cr_undo_stack_can_redo(handle : Handle) : Bool
    fun qt6cr_undo_stack_is_clean = qt6cr_undo_stack_is_clean(handle : Handle) : Bool
    fun qt6cr_undo_stack_set_clean = qt6cr_undo_stack_set_clean(handle : Handle)
    fun qt6cr_undo_stack_reset_clean = qt6cr_undo_stack_reset_clean(handle : Handle)
    fun qt6cr_undo_stack_count = qt6cr_undo_stack_count(handle : Handle) : LibC::Int
    fun qt6cr_undo_stack_index = qt6cr_undo_stack_index(handle : Handle) : LibC::Int
    fun qt6cr_undo_stack_clean_index = qt6cr_undo_stack_clean_index(handle : Handle) : LibC::Int
    fun qt6cr_undo_stack_undo_limit = qt6cr_undo_stack_undo_limit(handle : Handle) : LibC::Int
    fun qt6cr_undo_stack_set_undo_limit = qt6cr_undo_stack_set_undo_limit(handle : Handle, value : LibC::Int)
    fun qt6cr_undo_stack_is_active = qt6cr_undo_stack_is_active(handle : Handle) : Bool
    fun qt6cr_undo_stack_set_active = qt6cr_undo_stack_set_active(handle : Handle, value : Bool)
    fun qt6cr_undo_stack_undo_text = qt6cr_undo_stack_undo_text(handle : Handle) : UInt8*
    fun qt6cr_undo_stack_redo_text = qt6cr_undo_stack_redo_text(handle : Handle) : UInt8*
    fun qt6cr_undo_stack_begin_macro = qt6cr_undo_stack_begin_macro(handle : Handle, text : UInt8*)
    fun qt6cr_undo_stack_end_macro = qt6cr_undo_stack_end_macro(handle : Handle)
    fun qt6cr_undo_stack_create_undo_action = qt6cr_undo_stack_create_undo_action(handle : Handle, parent : Handle, prefix : UInt8*) : Handle
    fun qt6cr_undo_stack_create_redo_action = qt6cr_undo_stack_create_redo_action(handle : Handle, parent : Handle, prefix : UInt8*) : Handle
    fun qt6cr_undo_stack_on_can_undo_changed = qt6cr_undo_stack_on_can_undo_changed(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)
    fun qt6cr_undo_stack_on_can_redo_changed = qt6cr_undo_stack_on_can_redo_changed(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)
    fun qt6cr_undo_stack_on_clean_changed = qt6cr_undo_stack_on_clean_changed(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)
    fun qt6cr_undo_stack_on_index_changed = qt6cr_undo_stack_on_index_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)
    fun qt6cr_undo_stack_on_undo_text_changed = qt6cr_undo_stack_on_undo_text_changed(handle : Handle, callback : (Handle, UInt8* ->), userdata : Handle)
    fun qt6cr_undo_stack_on_redo_text_changed = qt6cr_undo_stack_on_redo_text_changed(handle : Handle, callback : (Handle, UInt8* ->), userdata : Handle)

    fun qt6cr_undo_group_create = qt6cr_undo_group_create(parent : Handle) : Handle
    fun qt6cr_undo_group_add_stack = qt6cr_undo_group_add_stack(handle : Handle, stack : Handle)
    fun qt6cr_undo_group_remove_stack = qt6cr_undo_group_remove_stack(handle : Handle, stack : Handle)
    fun qt6cr_undo_group_active_stack = qt6cr_undo_group_active_stack(handle : Handle) : Handle
    fun qt6cr_undo_group_set_active_stack = qt6cr_undo_group_set_active_stack(handle : Handle, stack : Handle)
    fun qt6cr_undo_group_undo = qt6cr_undo_group_undo(handle : Handle)
    fun qt6cr_undo_group_redo = qt6cr_undo_group_redo(handle : Handle)
    fun qt6cr_undo_group_can_undo = qt6cr_undo_group_can_undo(handle : Handle) : Bool
    fun qt6cr_undo_group_can_redo = qt6cr_undo_group_can_redo(handle : Handle) : Bool
    fun qt6cr_undo_group_is_clean = qt6cr_undo_group_is_clean(handle : Handle) : Bool
    fun qt6cr_undo_group_undo_text = qt6cr_undo_group_undo_text(handle : Handle) : UInt8*
    fun qt6cr_undo_group_redo_text = qt6cr_undo_group_redo_text(handle : Handle) : UInt8*
    fun qt6cr_undo_group_create_undo_action = qt6cr_undo_group_create_undo_action(handle : Handle, parent : Handle, prefix : UInt8*) : Handle
    fun qt6cr_undo_group_create_redo_action = qt6cr_undo_group_create_redo_action(handle : Handle, parent : Handle, prefix : UInt8*) : Handle
    fun qt6cr_undo_group_on_active_stack_changed = qt6cr_undo_group_on_active_stack_changed(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)
    fun qt6cr_undo_group_on_can_undo_changed = qt6cr_undo_group_on_can_undo_changed(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)
    fun qt6cr_undo_group_on_can_redo_changed = qt6cr_undo_group_on_can_redo_changed(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)
    fun qt6cr_undo_group_on_clean_changed = qt6cr_undo_group_on_clean_changed(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)
    fun qt6cr_undo_group_on_index_changed = qt6cr_undo_group_on_index_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)
    fun qt6cr_undo_group_on_undo_text_changed = qt6cr_undo_group_on_undo_text_changed(handle : Handle, callback : (Handle, UInt8* ->), userdata : Handle)
    fun qt6cr_undo_group_on_redo_text_changed = qt6cr_undo_group_on_redo_text_changed(handle : Handle, callback : (Handle, UInt8* ->), userdata : Handle)

    fun qt6cr_menu_bar_add_menu = qt6cr_menu_bar_add_menu(handle : Handle, title : UInt8*) : Handle
    fun qt6cr_menu_bar_clear = qt6cr_menu_bar_clear(handle : Handle)

    fun qt6cr_menu_add_menu = qt6cr_menu_add_menu(handle : Handle, title : UInt8*) : Handle
    fun qt6cr_menu_add_text_action = qt6cr_menu_add_text_action(handle : Handle, text : UInt8*) : Handle
    fun qt6cr_menu_add_action = qt6cr_menu_add_action(handle : Handle, action : Handle)
    fun qt6cr_menu_add_separator = qt6cr_menu_add_separator(handle : Handle)
    fun qt6cr_menu_set_title = qt6cr_menu_set_title(handle : Handle, title : UInt8*)
    fun qt6cr_menu_title = qt6cr_menu_title(handle : Handle) : UInt8*
    fun qt6cr_menu_clear = qt6cr_menu_clear(handle : Handle)
    fun qt6cr_menu_menu_action = qt6cr_menu_menu_action(handle : Handle) : Handle

    fun qt6cr_tool_bar_create = qt6cr_tool_bar_create(parent : Handle, title : UInt8*) : Handle
    fun qt6cr_tool_bar_add_text_action = qt6cr_tool_bar_add_text_action(handle : Handle, text : UInt8*) : Handle
    fun qt6cr_tool_bar_add_action = qt6cr_tool_bar_add_action(handle : Handle, action : Handle)
    fun qt6cr_tool_bar_add_widget = qt6cr_tool_bar_add_widget(handle : Handle, widget : Handle)
    fun qt6cr_tool_bar_add_separator = qt6cr_tool_bar_add_separator(handle : Handle)
    fun qt6cr_tool_bar_clear = qt6cr_tool_bar_clear(handle : Handle)
    fun qt6cr_tool_bar_set_movable = qt6cr_tool_bar_set_movable(handle : Handle, value : Bool)
    fun qt6cr_tool_bar_is_movable = qt6cr_tool_bar_is_movable(handle : Handle) : Bool
    fun qt6cr_tool_bar_toggle_view_action = qt6cr_tool_bar_toggle_view_action(handle : Handle) : Handle

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
    fun qt6cr_event_widget_on_mouse_double_click = qt6cr_event_widget_on_mouse_double_click(handle : Handle, callback : (Handle, MouseEventValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_wheel = qt6cr_event_widget_on_wheel(handle : Handle, callback : (Handle, WheelEventValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_key_press = qt6cr_event_widget_on_key_press(handle : Handle, callback : (Handle, KeyEventValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_key_release = qt6cr_event_widget_on_key_release(handle : Handle, callback : (Handle, KeyEventValue ->), userdata : Handle)
    fun qt6cr_event_widget_on_enter = qt6cr_event_widget_on_enter(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_event_widget_on_leave = qt6cr_event_widget_on_leave(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_event_widget_on_focus_in = qt6cr_event_widget_on_focus_in(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_event_widget_on_focus_out = qt6cr_event_widget_on_focus_out(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_event_widget_on_drag_enter = qt6cr_event_widget_on_drag_enter(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)
    fun qt6cr_event_widget_on_drag_move = qt6cr_event_widget_on_drag_move(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)
    fun qt6cr_event_widget_on_drop = qt6cr_event_widget_on_drop(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)
    fun qt6cr_event_widget_repaint = qt6cr_event_widget_repaint(handle : Handle)
    fun qt6cr_event_widget_send_mouse_press = qt6cr_event_widget_send_mouse_press(handle : Handle, position : PointFValue, button : LibC::Int, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_mouse_move = qt6cr_event_widget_send_mouse_move(handle : Handle, position : PointFValue, button : LibC::Int, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_mouse_release = qt6cr_event_widget_send_mouse_release(handle : Handle, position : PointFValue, button : LibC::Int, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_mouse_double_click = qt6cr_event_widget_send_mouse_double_click(handle : Handle, position : PointFValue, button : LibC::Int, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_wheel = qt6cr_event_widget_send_wheel(handle : Handle, position : PointFValue, pixel_delta : PointFValue, angle_delta : PointFValue, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_key_press = qt6cr_event_widget_send_key_press(handle : Handle, key : LibC::Int, modifiers : LibC::Int, auto_repeat : Bool, count : LibC::Int)
    fun qt6cr_event_widget_send_key_release = qt6cr_event_widget_send_key_release(handle : Handle, key : LibC::Int, modifiers : LibC::Int, auto_repeat : Bool, count : LibC::Int)
    fun qt6cr_event_widget_send_enter = qt6cr_event_widget_send_enter(handle : Handle, position : PointFValue)
    fun qt6cr_event_widget_send_leave = qt6cr_event_widget_send_leave(handle : Handle)
    fun qt6cr_event_widget_send_focus_in = qt6cr_event_widget_send_focus_in(handle : Handle)
    fun qt6cr_event_widget_send_focus_out = qt6cr_event_widget_send_focus_out(handle : Handle)
    fun qt6cr_event_widget_send_drag_enter_text = qt6cr_event_widget_send_drag_enter_text(handle : Handle, position : PointFValue, text : UInt8*, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_drag_move_text = qt6cr_event_widget_send_drag_move_text(handle : Handle, position : PointFValue, text : UInt8*, buttons : LibC::Int, modifiers : LibC::Int)
    fun qt6cr_event_widget_send_drop_text = qt6cr_event_widget_send_drop_text(handle : Handle, position : PointFValue, text : UInt8*, buttons : LibC::Int, modifiers : LibC::Int)

    fun qt6cr_drop_event_position = qt6cr_drop_event_position(handle : Handle) : PointFValue
    fun qt6cr_drop_event_buttons = qt6cr_drop_event_buttons(handle : Handle) : LibC::Int
    fun qt6cr_drop_event_modifiers = qt6cr_drop_event_modifiers(handle : Handle) : LibC::Int
    fun qt6cr_drop_event_mime_data = qt6cr_drop_event_mime_data(handle : Handle) : Handle
    fun qt6cr_drop_event_accept = qt6cr_drop_event_accept(handle : Handle)
    fun qt6cr_drop_event_accept_proposed_action = qt6cr_drop_event_accept_proposed_action(handle : Handle)
    fun qt6cr_drop_event_ignore = qt6cr_drop_event_ignore(handle : Handle)
    fun qt6cr_drop_event_is_accepted = qt6cr_drop_event_is_accepted(handle : Handle) : Bool

    fun qt6cr_label_create = qt6cr_label_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_label_set_text = qt6cr_label_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_label_text = qt6cr_label_text(handle : Handle) : UInt8*
    fun qt6cr_label_alignment = qt6cr_label_alignment(handle : Handle) : LibC::Int
    fun qt6cr_label_set_alignment = qt6cr_label_set_alignment(handle : Handle, value : LibC::Int)
    fun qt6cr_label_word_wrap = qt6cr_label_word_wrap(handle : Handle) : Bool
    fun qt6cr_label_set_word_wrap = qt6cr_label_set_word_wrap(handle : Handle, value : Bool)
    fun qt6cr_label_set_pixmap = qt6cr_label_set_pixmap(handle : Handle, pixmap : Handle)
    fun qt6cr_label_has_scaled_contents = qt6cr_label_has_scaled_contents(handle : Handle) : Bool
    fun qt6cr_label_set_scaled_contents = qt6cr_label_set_scaled_contents(handle : Handle, value : Bool)

    fun qt6cr_abstract_button_text = qt6cr_abstract_button_text(handle : Handle) : UInt8*
    fun qt6cr_abstract_button_set_text = qt6cr_abstract_button_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_abstract_button_is_checkable = qt6cr_abstract_button_is_checkable(handle : Handle) : Bool
    fun qt6cr_abstract_button_set_checkable = qt6cr_abstract_button_set_checkable(handle : Handle, value : Bool)
    fun qt6cr_abstract_button_is_checked = qt6cr_abstract_button_is_checked(handle : Handle) : Bool
    fun qt6cr_abstract_button_set_checked = qt6cr_abstract_button_set_checked(handle : Handle, value : Bool)
    fun qt6cr_abstract_button_on_clicked = qt6cr_abstract_button_on_clicked(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_abstract_button_on_toggled = qt6cr_abstract_button_on_toggled(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)
    fun qt6cr_abstract_button_click = qt6cr_abstract_button_click(handle : Handle)
    fun qt6cr_abstract_button_icon = qt6cr_abstract_button_icon(handle : Handle) : Handle
    fun qt6cr_abstract_button_set_icon = qt6cr_abstract_button_set_icon(handle : Handle, icon : Handle)
    fun qt6cr_abstract_button_icon_size = qt6cr_abstract_button_icon_size(handle : Handle) : SizeValue
    fun qt6cr_abstract_button_set_icon_size = qt6cr_abstract_button_set_icon_size(handle : Handle, size : SizeValue)

    fun qt6cr_push_button_create = qt6cr_push_button_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_push_button_set_text = qt6cr_push_button_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_push_button_text = qt6cr_push_button_text(handle : Handle) : UInt8*
    fun qt6cr_push_button_on_clicked = qt6cr_push_button_on_clicked(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_push_button_click = qt6cr_push_button_click(handle : Handle)

    fun qt6cr_line_edit_create = qt6cr_line_edit_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_line_edit_set_text = qt6cr_line_edit_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_line_edit_text = qt6cr_line_edit_text(handle : Handle) : UInt8*
    fun qt6cr_line_edit_placeholder_text = qt6cr_line_edit_placeholder_text(handle : Handle) : UInt8*
    fun qt6cr_line_edit_set_placeholder_text = qt6cr_line_edit_set_placeholder_text(handle : Handle, text : UInt8*)
    fun qt6cr_line_edit_echo_mode = qt6cr_line_edit_echo_mode(handle : Handle) : LibC::Int
    fun qt6cr_line_edit_set_echo_mode = qt6cr_line_edit_set_echo_mode(handle : Handle, value : LibC::Int)
    fun qt6cr_line_edit_input_mask = qt6cr_line_edit_input_mask(handle : Handle) : UInt8*
    fun qt6cr_line_edit_set_input_mask = qt6cr_line_edit_set_input_mask(handle : Handle, value : UInt8*)
    fun qt6cr_line_edit_alignment = qt6cr_line_edit_alignment(handle : Handle) : LibC::Int
    fun qt6cr_line_edit_set_alignment = qt6cr_line_edit_set_alignment(handle : Handle, value : LibC::Int)
    fun qt6cr_line_edit_cursor_position = qt6cr_line_edit_cursor_position(handle : Handle) : LibC::Int
    fun qt6cr_line_edit_set_cursor_position = qt6cr_line_edit_set_cursor_position(handle : Handle, value : LibC::Int)
    fun qt6cr_line_edit_selected_text = qt6cr_line_edit_selected_text(handle : Handle) : UInt8*
    fun qt6cr_line_edit_has_selected_text = qt6cr_line_edit_has_selected_text(handle : Handle) : Bool
    fun qt6cr_line_edit_selection_start = qt6cr_line_edit_selection_start(handle : Handle) : LibC::Int
    fun qt6cr_line_edit_select_all = qt6cr_line_edit_select_all(handle : Handle)
    fun qt6cr_line_edit_clear_selection = qt6cr_line_edit_clear_selection(handle : Handle)
    fun qt6cr_line_edit_set_selection = qt6cr_line_edit_set_selection(handle : Handle, start : LibC::Int, length : LibC::Int)
    fun qt6cr_line_edit_clear = qt6cr_line_edit_clear(handle : Handle)
    fun qt6cr_line_edit_validator = qt6cr_line_edit_validator(handle : Handle) : Handle
    fun qt6cr_line_edit_set_validator = qt6cr_line_edit_set_validator(handle : Handle, validator : Handle)
    fun qt6cr_line_edit_completer = qt6cr_line_edit_completer(handle : Handle) : Handle
    fun qt6cr_line_edit_set_completer = qt6cr_line_edit_set_completer(handle : Handle, completer : Handle)
    fun qt6cr_line_edit_on_text_changed = qt6cr_line_edit_on_text_changed(handle : Handle, callback : (Handle, UInt8* ->), userdata : Handle)

    fun qt6cr_validator_validate = qt6cr_validator_validate(handle : Handle, input : UInt8*) : LibC::Int
    fun qt6cr_int_validator_create = qt6cr_int_validator_create(parent : Handle, bottom : LibC::Int, top : LibC::Int) : Handle
    fun qt6cr_int_validator_bottom = qt6cr_int_validator_bottom(handle : Handle) : LibC::Int
    fun qt6cr_int_validator_set_bottom = qt6cr_int_validator_set_bottom(handle : Handle, value : LibC::Int)
    fun qt6cr_int_validator_top = qt6cr_int_validator_top(handle : Handle) : LibC::Int
    fun qt6cr_int_validator_set_top = qt6cr_int_validator_set_top(handle : Handle, value : LibC::Int)
    fun qt6cr_int_validator_set_range = qt6cr_int_validator_set_range(handle : Handle, bottom : LibC::Int, top : LibC::Int)
    fun qt6cr_double_validator_create = qt6cr_double_validator_create(parent : Handle, bottom : Float64, top : Float64, decimals : LibC::Int) : Handle
    fun qt6cr_double_validator_bottom = qt6cr_double_validator_bottom(handle : Handle) : Float64
    fun qt6cr_double_validator_set_bottom = qt6cr_double_validator_set_bottom(handle : Handle, value : Float64)
    fun qt6cr_double_validator_top = qt6cr_double_validator_top(handle : Handle) : Float64
    fun qt6cr_double_validator_set_top = qt6cr_double_validator_set_top(handle : Handle, value : Float64)
    fun qt6cr_double_validator_decimals = qt6cr_double_validator_decimals(handle : Handle) : LibC::Int
    fun qt6cr_double_validator_set_decimals = qt6cr_double_validator_set_decimals(handle : Handle, value : LibC::Int)
    fun qt6cr_double_validator_set_range = qt6cr_double_validator_set_range(handle : Handle, bottom : Float64, top : Float64, decimals : LibC::Int)
    fun qt6cr_regex_validator_create = qt6cr_regex_validator_create(parent : Handle, pattern : UInt8*) : Handle
    fun qt6cr_regex_validator_pattern = qt6cr_regex_validator_pattern(handle : Handle) : UInt8*
    fun qt6cr_regex_validator_set_pattern = qt6cr_regex_validator_set_pattern(handle : Handle, pattern : UInt8*)
    fun qt6cr_completer_create = qt6cr_completer_create(parent : Handle) : Handle
    fun qt6cr_completer_set_items = qt6cr_completer_set_items(handle : Handle, items : UInt8**, count : LibC::Int)
    fun qt6cr_completer_completion_prefix = qt6cr_completer_completion_prefix(handle : Handle) : UInt8*
    fun qt6cr_completer_set_completion_prefix = qt6cr_completer_set_completion_prefix(handle : Handle, value : UInt8*)
    fun qt6cr_completer_current_completion = qt6cr_completer_current_completion(handle : Handle) : UInt8*
    fun qt6cr_completer_case_sensitivity = qt6cr_completer_case_sensitivity(handle : Handle) : LibC::Int
    fun qt6cr_completer_set_case_sensitivity = qt6cr_completer_set_case_sensitivity(handle : Handle, value : LibC::Int)
    fun qt6cr_completer_completion_mode = qt6cr_completer_completion_mode(handle : Handle) : LibC::Int
    fun qt6cr_completer_set_completion_mode = qt6cr_completer_set_completion_mode(handle : Handle, value : LibC::Int)

    fun qt6cr_check_box_create = qt6cr_check_box_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_check_box_set_text = qt6cr_check_box_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_check_box_text = qt6cr_check_box_text(handle : Handle) : UInt8*
    fun qt6cr_check_box_set_checked = qt6cr_check_box_set_checked(handle : Handle, value : Bool)
    fun qt6cr_check_box_is_checked = qt6cr_check_box_is_checked(handle : Handle) : Bool
    fun qt6cr_check_box_on_toggled = qt6cr_check_box_on_toggled(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)

    fun qt6cr_radio_button_create = qt6cr_radio_button_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_radio_button_set_text = qt6cr_radio_button_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_radio_button_text = qt6cr_radio_button_text(handle : Handle) : UInt8*
    fun qt6cr_radio_button_set_checked = qt6cr_radio_button_set_checked(handle : Handle, value : Bool)
    fun qt6cr_radio_button_is_checked = qt6cr_radio_button_is_checked(handle : Handle) : Bool
    fun qt6cr_radio_button_on_toggled = qt6cr_radio_button_on_toggled(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)

    fun qt6cr_tool_button_create = qt6cr_tool_button_create(parent : Handle) : Handle
    fun qt6cr_tool_button_style = qt6cr_tool_button_style(handle : Handle) : LibC::Int
    fun qt6cr_tool_button_set_style = qt6cr_tool_button_set_style(handle : Handle, style : LibC::Int)

    fun qt6cr_combo_box_create = qt6cr_combo_box_create(parent : Handle) : Handle
    fun qt6cr_combo_box_add_item = qt6cr_combo_box_add_item(handle : Handle, text : UInt8*)
    fun qt6cr_combo_box_count = qt6cr_combo_box_count(handle : Handle) : LibC::Int
    fun qt6cr_combo_box_current_index = qt6cr_combo_box_current_index(handle : Handle) : LibC::Int
    fun qt6cr_combo_box_set_current_index = qt6cr_combo_box_set_current_index(handle : Handle, index : LibC::Int)
    fun qt6cr_combo_box_current_text = qt6cr_combo_box_current_text(handle : Handle) : UInt8*
    fun qt6cr_combo_box_on_current_index_changed = qt6cr_combo_box_on_current_index_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)
    fun qt6cr_font_combo_box_create = qt6cr_font_combo_box_create(parent : Handle) : Handle
    fun qt6cr_font_combo_box_current_font = qt6cr_font_combo_box_current_font(handle : Handle) : Handle
    fun qt6cr_font_combo_box_set_current_font = qt6cr_font_combo_box_set_current_font(handle : Handle, font : Handle)
    fun qt6cr_font_combo_box_on_current_font_changed = qt6cr_font_combo_box_on_current_font_changed(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)

    fun qt6cr_list_widget_item_create = qt6cr_list_widget_item_create(text : UInt8*) : Handle
    fun qt6cr_list_widget_item_create_with_icon = qt6cr_list_widget_item_create_with_icon(icon : Handle, text : UInt8*) : Handle
    fun qt6cr_list_widget_item_destroy = qt6cr_list_widget_item_destroy(handle : Handle)
    fun qt6cr_list_widget_item_set_text = qt6cr_list_widget_item_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_list_widget_item_text = qt6cr_list_widget_item_text(handle : Handle) : UInt8*
    fun qt6cr_list_widget_item_flags = qt6cr_list_widget_item_flags(handle : Handle) : LibC::Int
    fun qt6cr_list_widget_item_set_flags = qt6cr_list_widget_item_set_flags(handle : Handle, flags : LibC::Int)
    fun qt6cr_list_widget_item_check_state = qt6cr_list_widget_item_check_state(handle : Handle) : LibC::Int
    fun qt6cr_list_widget_item_set_check_state = qt6cr_list_widget_item_set_check_state(handle : Handle, state : LibC::Int)
    fun qt6cr_list_widget_item_data = qt6cr_list_widget_item_data(handle : Handle, role : LibC::Int) : VariantValue
    fun qt6cr_list_widget_item_set_data = qt6cr_list_widget_item_set_data(handle : Handle, role : LibC::Int, value : VariantValue)
    fun qt6cr_list_widget_item_foreground = qt6cr_list_widget_item_foreground(handle : Handle) : ColorValue
    fun qt6cr_list_widget_item_set_foreground = qt6cr_list_widget_item_set_foreground(handle : Handle, color : ColorValue)

    fun qt6cr_list_widget_create = qt6cr_list_widget_create(parent : Handle) : Handle
    fun qt6cr_list_widget_add_item = qt6cr_list_widget_add_item(handle : Handle, item : Handle)
    fun qt6cr_list_widget_add_item_text = qt6cr_list_widget_add_item_text(handle : Handle, text : UInt8*) : Handle
    fun qt6cr_list_widget_count = qt6cr_list_widget_count(handle : Handle) : LibC::Int
    fun qt6cr_list_widget_item = qt6cr_list_widget_item(handle : Handle, index : LibC::Int) : Handle
    fun qt6cr_list_widget_item_text_at = qt6cr_list_widget_item_text_at(handle : Handle, index : LibC::Int) : UInt8*
    fun qt6cr_list_widget_current_row = qt6cr_list_widget_current_row(handle : Handle) : LibC::Int
    fun qt6cr_list_widget_set_current_row = qt6cr_list_widget_set_current_row(handle : Handle, row : LibC::Int)
    fun qt6cr_list_widget_current_item = qt6cr_list_widget_current_item(handle : Handle) : Handle
    fun qt6cr_list_widget_current_text = qt6cr_list_widget_current_text(handle : Handle) : UInt8*
    fun qt6cr_list_widget_clear = qt6cr_list_widget_clear(handle : Handle)
    fun qt6cr_list_widget_spacing = qt6cr_list_widget_spacing(handle : Handle) : LibC::Int
    fun qt6cr_list_widget_set_spacing = qt6cr_list_widget_set_spacing(handle : Handle, value : LibC::Int)
    fun qt6cr_list_widget_drag_drop_mode = qt6cr_list_widget_drag_drop_mode(handle : Handle) : LibC::Int
    fun qt6cr_list_widget_set_drag_drop_mode = qt6cr_list_widget_set_drag_drop_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_list_widget_selection_mode = qt6cr_list_widget_selection_mode(handle : Handle) : LibC::Int
    fun qt6cr_list_widget_set_selection_mode = qt6cr_list_widget_set_selection_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_list_widget_default_drop_action = qt6cr_list_widget_default_drop_action(handle : Handle) : LibC::Int
    fun qt6cr_list_widget_set_default_drop_action = qt6cr_list_widget_set_default_drop_action(handle : Handle, action : LibC::Int)
    fun qt6cr_list_widget_move_item = qt6cr_list_widget_move_item(handle : Handle, from : LibC::Int, to : LibC::Int) : Bool
    fun qt6cr_list_widget_emit_item_double_clicked = qt6cr_list_widget_emit_item_double_clicked(handle : Handle, index : LibC::Int)
    fun qt6cr_list_widget_on_current_row_changed = qt6cr_list_widget_on_current_row_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)
    fun qt6cr_list_widget_on_item_changed = qt6cr_list_widget_on_item_changed(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)
    fun qt6cr_list_widget_on_item_double_clicked = qt6cr_list_widget_on_item_double_clicked(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)
    fun qt6cr_list_widget_on_rows_moved = qt6cr_list_widget_on_rows_moved(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_tree_widget_item_create = qt6cr_tree_widget_item_create(text : UInt8*) : Handle
    fun qt6cr_tree_widget_item_destroy = qt6cr_tree_widget_item_destroy(handle : Handle)
    fun qt6cr_tree_widget_item_set_text = qt6cr_tree_widget_item_set_text(handle : Handle, column : LibC::Int, text : UInt8*)
    fun qt6cr_tree_widget_item_text = qt6cr_tree_widget_item_text(handle : Handle, column : LibC::Int) : UInt8*
    fun qt6cr_tree_widget_item_flags = qt6cr_tree_widget_item_flags(handle : Handle) : LibC::Int
    fun qt6cr_tree_widget_item_set_flags = qt6cr_tree_widget_item_set_flags(handle : Handle, flags : LibC::Int)
    fun qt6cr_tree_widget_item_font = qt6cr_tree_widget_item_font(handle : Handle, column : LibC::Int) : Handle
    fun qt6cr_tree_widget_item_set_font = qt6cr_tree_widget_item_set_font(handle : Handle, column : LibC::Int, font : Handle)
    fun qt6cr_tree_widget_item_foreground = qt6cr_tree_widget_item_foreground(handle : Handle, column : LibC::Int) : ColorValue
    fun qt6cr_tree_widget_item_set_foreground = qt6cr_tree_widget_item_set_foreground(handle : Handle, column : LibC::Int, color : ColorValue)
    fun qt6cr_tree_widget_item_add_child = qt6cr_tree_widget_item_add_child(handle : Handle, child : Handle)
    fun qt6cr_tree_widget_item_child_count = qt6cr_tree_widget_item_child_count(handle : Handle) : LibC::Int
    fun qt6cr_tree_widget_item_child = qt6cr_tree_widget_item_child(handle : Handle, index : LibC::Int) : Handle

    fun qt6cr_tree_widget_create = qt6cr_tree_widget_create(parent : Handle) : Handle
    fun qt6cr_tree_widget_column_count = qt6cr_tree_widget_column_count(handle : Handle) : LibC::Int
    fun qt6cr_tree_widget_set_column_count = qt6cr_tree_widget_set_column_count(handle : Handle, count : LibC::Int)
    fun qt6cr_tree_widget_header_label = qt6cr_tree_widget_header_label(handle : Handle, column : LibC::Int) : UInt8*
    fun qt6cr_tree_widget_set_header_label = qt6cr_tree_widget_set_header_label(handle : Handle, column : LibC::Int, text : UInt8*)
    fun qt6cr_tree_widget_header_hidden = qt6cr_tree_widget_header_hidden(handle : Handle) : Bool
    fun qt6cr_tree_widget_set_header_hidden = qt6cr_tree_widget_set_header_hidden(handle : Handle, value : Bool)
    fun qt6cr_tree_widget_add_top_level_item = qt6cr_tree_widget_add_top_level_item(handle : Handle, item : Handle)
    fun qt6cr_tree_widget_add_top_level_item_text = qt6cr_tree_widget_add_top_level_item_text(handle : Handle, text : UInt8*) : Handle
    fun qt6cr_tree_widget_top_level_item_count = qt6cr_tree_widget_top_level_item_count(handle : Handle) : LibC::Int
    fun qt6cr_tree_widget_top_level_item = qt6cr_tree_widget_top_level_item(handle : Handle, index : LibC::Int) : Handle
    fun qt6cr_tree_widget_current_item = qt6cr_tree_widget_current_item(handle : Handle) : Handle
    fun qt6cr_tree_widget_set_current_item = qt6cr_tree_widget_set_current_item(handle : Handle, item : Handle)
    fun qt6cr_tree_widget_current_item_text = qt6cr_tree_widget_current_item_text(handle : Handle, column : LibC::Int) : UInt8*
    fun qt6cr_tree_widget_expand_all = qt6cr_tree_widget_expand_all(handle : Handle)
    fun qt6cr_tree_widget_collapse_all = qt6cr_tree_widget_collapse_all(handle : Handle)
    fun qt6cr_tree_widget_clear = qt6cr_tree_widget_clear(handle : Handle)
    fun qt6cr_tree_widget_on_current_item_changed = qt6cr_tree_widget_on_current_item_changed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_table_widget_item_create = qt6cr_table_widget_item_create(text : UInt8*) : Handle
    fun qt6cr_table_widget_item_destroy = qt6cr_table_widget_item_destroy(handle : Handle)
    fun qt6cr_table_widget_item_set_text = qt6cr_table_widget_item_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_table_widget_item_text = qt6cr_table_widget_item_text(handle : Handle) : UInt8*
    fun qt6cr_table_widget_item_icon = qt6cr_table_widget_item_icon(handle : Handle) : Handle
    fun qt6cr_table_widget_item_set_icon = qt6cr_table_widget_item_set_icon(handle : Handle, icon : Handle)
    fun qt6cr_table_widget_item_flags = qt6cr_table_widget_item_flags(handle : Handle) : LibC::Int
    fun qt6cr_table_widget_item_set_flags = qt6cr_table_widget_item_set_flags(handle : Handle, flags : LibC::Int)
    fun qt6cr_table_widget_item_check_state = qt6cr_table_widget_item_check_state(handle : Handle) : LibC::Int
    fun qt6cr_table_widget_item_set_check_state = qt6cr_table_widget_item_set_check_state(handle : Handle, state : LibC::Int)
    fun qt6cr_table_widget_item_data = qt6cr_table_widget_item_data(handle : Handle, role : LibC::Int) : VariantValue
    fun qt6cr_table_widget_item_set_data = qt6cr_table_widget_item_set_data(handle : Handle, role : LibC::Int, value : VariantValue)
    fun qt6cr_table_widget_item_foreground = qt6cr_table_widget_item_foreground(handle : Handle) : ColorValue
    fun qt6cr_table_widget_item_set_foreground = qt6cr_table_widget_item_set_foreground(handle : Handle, color : ColorValue)

    fun qt6cr_table_widget_create = qt6cr_table_widget_create(parent : Handle) : Handle
    fun qt6cr_table_widget_row_count = qt6cr_table_widget_row_count(handle : Handle) : LibC::Int
    fun qt6cr_table_widget_set_row_count = qt6cr_table_widget_set_row_count(handle : Handle, count : LibC::Int)
    fun qt6cr_table_widget_column_count = qt6cr_table_widget_column_count(handle : Handle) : LibC::Int
    fun qt6cr_table_widget_set_column_count = qt6cr_table_widget_set_column_count(handle : Handle, count : LibC::Int)
    fun qt6cr_table_widget_set_horizontal_header_label = qt6cr_table_widget_set_horizontal_header_label(handle : Handle, column : LibC::Int, text : UInt8*)
    fun qt6cr_table_widget_horizontal_header_label = qt6cr_table_widget_horizontal_header_label(handle : Handle, column : LibC::Int) : UInt8*
    fun qt6cr_table_widget_set_vertical_header_label = qt6cr_table_widget_set_vertical_header_label(handle : Handle, row : LibC::Int, text : UInt8*)
    fun qt6cr_table_widget_vertical_header_label = qt6cr_table_widget_vertical_header_label(handle : Handle, row : LibC::Int) : UInt8*
    fun qt6cr_table_widget_set_item = qt6cr_table_widget_set_item(handle : Handle, row : LibC::Int, column : LibC::Int, item : Handle)
    fun qt6cr_table_widget_item = qt6cr_table_widget_item(handle : Handle, row : LibC::Int, column : LibC::Int) : Handle
    fun qt6cr_table_widget_current_item = qt6cr_table_widget_current_item(handle : Handle) : Handle
    fun qt6cr_table_widget_set_current_item = qt6cr_table_widget_set_current_item(handle : Handle, item : Handle)
    fun qt6cr_table_widget_current_row = qt6cr_table_widget_current_row(handle : Handle) : LibC::Int
    fun qt6cr_table_widget_current_column = qt6cr_table_widget_current_column(handle : Handle) : LibC::Int
    fun qt6cr_table_widget_set_current_cell = qt6cr_table_widget_set_current_cell(handle : Handle, row : LibC::Int, column : LibC::Int)
    fun qt6cr_table_widget_clear = qt6cr_table_widget_clear(handle : Handle)
    fun qt6cr_table_widget_clear_contents = qt6cr_table_widget_clear_contents(handle : Handle)
    fun qt6cr_table_widget_selection_mode = qt6cr_table_widget_selection_mode(handle : Handle) : LibC::Int
    fun qt6cr_table_widget_set_selection_mode = qt6cr_table_widget_set_selection_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_table_widget_edit_triggers = qt6cr_table_widget_edit_triggers(handle : Handle) : LibC::Int
    fun qt6cr_table_widget_set_edit_triggers = qt6cr_table_widget_set_edit_triggers(handle : Handle, triggers : LibC::Int)
    fun qt6cr_table_widget_selection_behavior = qt6cr_table_widget_selection_behavior(handle : Handle) : LibC::Int
    fun qt6cr_table_widget_set_selection_behavior = qt6cr_table_widget_set_selection_behavior(handle : Handle, behavior : LibC::Int)
    fun qt6cr_table_widget_alternating_row_colors = qt6cr_table_widget_alternating_row_colors(handle : Handle) : Bool
    fun qt6cr_table_widget_set_alternating_row_colors = qt6cr_table_widget_set_alternating_row_colors(handle : Handle, value : Bool)
    fun qt6cr_table_widget_show_grid = qt6cr_table_widget_show_grid(handle : Handle) : Bool
    fun qt6cr_table_widget_set_show_grid = qt6cr_table_widget_set_show_grid(handle : Handle, value : Bool)
    fun qt6cr_table_widget_horizontal_header = qt6cr_table_widget_horizontal_header(handle : Handle) : Handle
    fun qt6cr_table_widget_vertical_header = qt6cr_table_widget_vertical_header(handle : Handle) : Handle
    fun qt6cr_table_widget_set_span = qt6cr_table_widget_set_span(handle : Handle, row : LibC::Int, column : LibC::Int, row_span : LibC::Int, column_span : LibC::Int)
    fun qt6cr_table_widget_row_span = qt6cr_table_widget_row_span(handle : Handle, row : LibC::Int, column : LibC::Int) : LibC::Int
    fun qt6cr_table_widget_column_span = qt6cr_table_widget_column_span(handle : Handle, row : LibC::Int, column : LibC::Int) : LibC::Int
    fun qt6cr_table_widget_open_persistent_editor = qt6cr_table_widget_open_persistent_editor(handle : Handle, item : Handle)
    fun qt6cr_table_widget_close_persistent_editor = qt6cr_table_widget_close_persistent_editor(handle : Handle, item : Handle)
    fun qt6cr_table_widget_is_persistent_editor_open = qt6cr_table_widget_is_persistent_editor_open(handle : Handle, item : Handle) : Bool
    fun qt6cr_table_widget_emit_item_double_clicked = qt6cr_table_widget_emit_item_double_clicked(handle : Handle, row : LibC::Int, column : LibC::Int)
    fun qt6cr_table_widget_on_current_cell_changed = qt6cr_table_widget_on_current_cell_changed(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_table_widget_on_item_changed = qt6cr_table_widget_on_item_changed(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)
    fun qt6cr_table_widget_on_item_double_clicked = qt6cr_table_widget_on_item_double_clicked(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)
    fun qt6cr_table_widget_sort_by_column = qt6cr_table_widget_sort_by_column(handle : Handle, column : LibC::Int, order : LibC::Int)
    fun qt6cr_table_widget_resize_columns_to_contents = qt6cr_table_widget_resize_columns_to_contents(handle : Handle)
    fun qt6cr_table_widget_resize_rows_to_contents = qt6cr_table_widget_resize_rows_to_contents(handle : Handle)

    fun qt6cr_slider_create = qt6cr_slider_create(parent : Handle, orientation : LibC::Int) : Handle
    fun qt6cr_slider_set_minimum = qt6cr_slider_set_minimum(handle : Handle, value : LibC::Int)
    fun qt6cr_slider_minimum = qt6cr_slider_minimum(handle : Handle) : LibC::Int
    fun qt6cr_slider_set_maximum = qt6cr_slider_set_maximum(handle : Handle, value : LibC::Int)
    fun qt6cr_slider_maximum = qt6cr_slider_maximum(handle : Handle) : LibC::Int
    fun qt6cr_slider_set_range = qt6cr_slider_set_range(handle : Handle, minimum : LibC::Int, maximum : LibC::Int)
    fun qt6cr_slider_set_value = qt6cr_slider_set_value(handle : Handle, value : LibC::Int)
    fun qt6cr_slider_value = qt6cr_slider_value(handle : Handle) : LibC::Int
    fun qt6cr_slider_orientation = qt6cr_slider_orientation(handle : Handle) : LibC::Int
    fun qt6cr_slider_click_to_position = qt6cr_slider_click_to_position(handle : Handle) : Bool
    fun qt6cr_slider_set_click_to_position = qt6cr_slider_set_click_to_position(handle : Handle, value : Bool)
    fun qt6cr_slider_emit_pressed = qt6cr_slider_emit_pressed(handle : Handle)
    fun qt6cr_slider_emit_released = qt6cr_slider_emit_released(handle : Handle)
    fun qt6cr_slider_on_value_changed = qt6cr_slider_on_value_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)
    fun qt6cr_slider_on_pressed = qt6cr_slider_on_pressed(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_slider_on_released = qt6cr_slider_on_released(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_scroll_bar_create = qt6cr_scroll_bar_create(parent : Handle, orientation : LibC::Int) : Handle
    fun qt6cr_scroll_bar_set_minimum = qt6cr_scroll_bar_set_minimum(handle : Handle, value : LibC::Int)
    fun qt6cr_scroll_bar_minimum = qt6cr_scroll_bar_minimum(handle : Handle) : LibC::Int
    fun qt6cr_scroll_bar_set_maximum = qt6cr_scroll_bar_set_maximum(handle : Handle, value : LibC::Int)
    fun qt6cr_scroll_bar_maximum = qt6cr_scroll_bar_maximum(handle : Handle) : LibC::Int
    fun qt6cr_scroll_bar_set_range = qt6cr_scroll_bar_set_range(handle : Handle, minimum : LibC::Int, maximum : LibC::Int)
    fun qt6cr_scroll_bar_set_value = qt6cr_scroll_bar_set_value(handle : Handle, value : LibC::Int)
    fun qt6cr_scroll_bar_value = qt6cr_scroll_bar_value(handle : Handle) : LibC::Int
    fun qt6cr_scroll_bar_set_single_step = qt6cr_scroll_bar_set_single_step(handle : Handle, value : LibC::Int)
    fun qt6cr_scroll_bar_single_step = qt6cr_scroll_bar_single_step(handle : Handle) : LibC::Int
    fun qt6cr_scroll_bar_set_page_step = qt6cr_scroll_bar_set_page_step(handle : Handle, value : LibC::Int)
    fun qt6cr_scroll_bar_page_step = qt6cr_scroll_bar_page_step(handle : Handle) : LibC::Int
    fun qt6cr_scroll_bar_orientation = qt6cr_scroll_bar_orientation(handle : Handle) : LibC::Int
    fun qt6cr_scroll_bar_on_value_changed = qt6cr_scroll_bar_on_value_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

    fun qt6cr_dial_create = qt6cr_dial_create(parent : Handle) : Handle
    fun qt6cr_dial_set_minimum = qt6cr_dial_set_minimum(handle : Handle, value : LibC::Int)
    fun qt6cr_dial_minimum = qt6cr_dial_minimum(handle : Handle) : LibC::Int
    fun qt6cr_dial_set_maximum = qt6cr_dial_set_maximum(handle : Handle, value : LibC::Int)
    fun qt6cr_dial_maximum = qt6cr_dial_maximum(handle : Handle) : LibC::Int
    fun qt6cr_dial_set_range = qt6cr_dial_set_range(handle : Handle, minimum : LibC::Int, maximum : LibC::Int)
    fun qt6cr_dial_set_value = qt6cr_dial_set_value(handle : Handle, value : LibC::Int)
    fun qt6cr_dial_value = qt6cr_dial_value(handle : Handle) : LibC::Int
    fun qt6cr_dial_wrapping = qt6cr_dial_wrapping(handle : Handle) : Bool
    fun qt6cr_dial_set_wrapping = qt6cr_dial_set_wrapping(handle : Handle, value : Bool)
    fun qt6cr_dial_notches_visible = qt6cr_dial_notches_visible(handle : Handle) : Bool
    fun qt6cr_dial_set_notches_visible = qt6cr_dial_set_notches_visible(handle : Handle, value : Bool)
    fun qt6cr_dial_on_value_changed = qt6cr_dial_on_value_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

    fun qt6cr_abstract_spin_box_button_symbols = qt6cr_abstract_spin_box_button_symbols(handle : Handle) : LibC::Int
    fun qt6cr_abstract_spin_box_set_button_symbols = qt6cr_abstract_spin_box_set_button_symbols(handle : Handle, value : LibC::Int)
    fun qt6cr_abstract_spin_box_is_read_only = qt6cr_abstract_spin_box_is_read_only(handle : Handle) : Bool
    fun qt6cr_abstract_spin_box_set_read_only = qt6cr_abstract_spin_box_set_read_only(handle : Handle, value : Bool)
    fun qt6cr_abstract_spin_box_wrapping = qt6cr_abstract_spin_box_wrapping(handle : Handle) : Bool
    fun qt6cr_abstract_spin_box_set_wrapping = qt6cr_abstract_spin_box_set_wrapping(handle : Handle, value : Bool)
    fun qt6cr_abstract_spin_box_is_accelerated = qt6cr_abstract_spin_box_is_accelerated(handle : Handle) : Bool
    fun qt6cr_abstract_spin_box_set_accelerated = qt6cr_abstract_spin_box_set_accelerated(handle : Handle, value : Bool)

    fun qt6cr_abstract_item_view_model = qt6cr_abstract_item_view_model(handle : Handle) : Handle
    fun qt6cr_abstract_item_view_set_item_delegate = qt6cr_abstract_item_view_set_item_delegate(handle : Handle, delegate : Handle)
    fun qt6cr_abstract_item_view_selection_model = qt6cr_abstract_item_view_selection_model(handle : Handle) : Handle
    fun qt6cr_abstract_item_view_set_selection_model = qt6cr_abstract_item_view_set_selection_model(handle : Handle, selection_model : Handle)
    fun qt6cr_abstract_item_view_current_index = qt6cr_abstract_item_view_current_index(handle : Handle) : Handle
    fun qt6cr_abstract_item_view_set_current_index = qt6cr_abstract_item_view_set_current_index(handle : Handle, index : Handle)
    fun qt6cr_abstract_item_view_selection_mode = qt6cr_abstract_item_view_selection_mode(handle : Handle) : LibC::Int
    fun qt6cr_abstract_item_view_set_selection_mode = qt6cr_abstract_item_view_set_selection_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_abstract_item_view_edit_triggers = qt6cr_abstract_item_view_edit_triggers(handle : Handle) : LibC::Int
    fun qt6cr_abstract_item_view_set_edit_triggers = qt6cr_abstract_item_view_set_edit_triggers(handle : Handle, triggers : LibC::Int)
    fun qt6cr_abstract_item_view_selection_behavior = qt6cr_abstract_item_view_selection_behavior(handle : Handle) : LibC::Int
    fun qt6cr_abstract_item_view_set_selection_behavior = qt6cr_abstract_item_view_set_selection_behavior(handle : Handle, behavior : LibC::Int)
    fun qt6cr_abstract_item_view_alternating_row_colors = qt6cr_abstract_item_view_alternating_row_colors(handle : Handle) : Bool
    fun qt6cr_abstract_item_view_set_alternating_row_colors = qt6cr_abstract_item_view_set_alternating_row_colors(handle : Handle, value : Bool)
    fun qt6cr_abstract_item_view_drag_enabled = qt6cr_abstract_item_view_drag_enabled(handle : Handle) : Bool
    fun qt6cr_abstract_item_view_set_drag_enabled = qt6cr_abstract_item_view_set_drag_enabled(handle : Handle, value : Bool)
    fun qt6cr_abstract_item_view_drag_drop_mode = qt6cr_abstract_item_view_drag_drop_mode(handle : Handle) : LibC::Int
    fun qt6cr_abstract_item_view_set_drag_drop_mode = qt6cr_abstract_item_view_set_drag_drop_mode(handle : Handle, mode : LibC::Int)
    fun qt6cr_abstract_item_view_drag_drop_overwrite_mode = qt6cr_abstract_item_view_drag_drop_overwrite_mode(handle : Handle) : Bool
    fun qt6cr_abstract_item_view_set_drag_drop_overwrite_mode = qt6cr_abstract_item_view_set_drag_drop_overwrite_mode(handle : Handle, value : Bool)
    fun qt6cr_abstract_item_view_default_drop_action = qt6cr_abstract_item_view_default_drop_action(handle : Handle) : LibC::Int
    fun qt6cr_abstract_item_view_set_default_drop_action = qt6cr_abstract_item_view_set_default_drop_action(handle : Handle, action : LibC::Int)
    fun qt6cr_abstract_item_view_drop_indicator_shown = qt6cr_abstract_item_view_drop_indicator_shown(handle : Handle) : Bool
    fun qt6cr_abstract_item_view_set_drop_indicator_shown = qt6cr_abstract_item_view_set_drop_indicator_shown(handle : Handle, value : Bool)
    fun qt6cr_abstract_item_view_viewport = qt6cr_abstract_item_view_viewport(handle : Handle) : Handle
    fun qt6cr_abstract_item_view_index_at = qt6cr_abstract_item_view_index_at(handle : Handle, point : PointFValue) : Handle
    fun qt6cr_abstract_item_view_visual_rect = qt6cr_abstract_item_view_visual_rect(handle : Handle, index : Handle) : RectFValue
    fun qt6cr_abstract_item_view_open_persistent_editor = qt6cr_abstract_item_view_open_persistent_editor(handle : Handle, index : Handle)
    fun qt6cr_abstract_item_view_close_persistent_editor = qt6cr_abstract_item_view_close_persistent_editor(handle : Handle, index : Handle)
    fun qt6cr_abstract_item_view_is_persistent_editor_open = qt6cr_abstract_item_view_is_persistent_editor_open(handle : Handle, index : Handle) : Bool

    fun qt6cr_spin_box_create = qt6cr_spin_box_create(parent : Handle) : Handle
    fun qt6cr_spin_box_set_minimum = qt6cr_spin_box_set_minimum(handle : Handle, value : LibC::Int)
    fun qt6cr_spin_box_minimum = qt6cr_spin_box_minimum(handle : Handle) : LibC::Int
    fun qt6cr_spin_box_set_maximum = qt6cr_spin_box_set_maximum(handle : Handle, value : LibC::Int)
    fun qt6cr_spin_box_maximum = qt6cr_spin_box_maximum(handle : Handle) : LibC::Int
    fun qt6cr_spin_box_set_range = qt6cr_spin_box_set_range(handle : Handle, minimum : LibC::Int, maximum : LibC::Int)
    fun qt6cr_spin_box_set_value = qt6cr_spin_box_set_value(handle : Handle, value : LibC::Int)
    fun qt6cr_spin_box_value = qt6cr_spin_box_value(handle : Handle) : LibC::Int
    fun qt6cr_spin_box_set_single_step = qt6cr_spin_box_set_single_step(handle : Handle, value : LibC::Int)
    fun qt6cr_spin_box_single_step = qt6cr_spin_box_single_step(handle : Handle) : LibC::Int
    fun qt6cr_spin_box_prefix = qt6cr_spin_box_prefix(handle : Handle) : UInt8*
    fun qt6cr_spin_box_set_prefix = qt6cr_spin_box_set_prefix(handle : Handle, value : UInt8*)
    fun qt6cr_spin_box_suffix = qt6cr_spin_box_suffix(handle : Handle) : UInt8*
    fun qt6cr_spin_box_set_suffix = qt6cr_spin_box_set_suffix(handle : Handle, value : UInt8*)
    fun qt6cr_spin_box_special_value_text = qt6cr_spin_box_special_value_text(handle : Handle) : UInt8*
    fun qt6cr_spin_box_set_special_value_text = qt6cr_spin_box_set_special_value_text(handle : Handle, value : UInt8*)
    fun qt6cr_spin_box_clean_text = qt6cr_spin_box_clean_text(handle : Handle) : UInt8*
    fun qt6cr_spin_box_on_value_changed = qt6cr_spin_box_on_value_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

    fun qt6cr_double_spin_box_create = qt6cr_double_spin_box_create(parent : Handle) : Handle
    fun qt6cr_double_spin_box_set_minimum = qt6cr_double_spin_box_set_minimum(handle : Handle, value : Float64)
    fun qt6cr_double_spin_box_minimum = qt6cr_double_spin_box_minimum(handle : Handle) : Float64
    fun qt6cr_double_spin_box_set_maximum = qt6cr_double_spin_box_set_maximum(handle : Handle, value : Float64)
    fun qt6cr_double_spin_box_maximum = qt6cr_double_spin_box_maximum(handle : Handle) : Float64
    fun qt6cr_double_spin_box_set_range = qt6cr_double_spin_box_set_range(handle : Handle, minimum : Float64, maximum : Float64)
    fun qt6cr_double_spin_box_set_value = qt6cr_double_spin_box_set_value(handle : Handle, value : Float64)
    fun qt6cr_double_spin_box_value = qt6cr_double_spin_box_value(handle : Handle) : Float64
    fun qt6cr_double_spin_box_set_single_step = qt6cr_double_spin_box_set_single_step(handle : Handle, value : Float64)
    fun qt6cr_double_spin_box_single_step = qt6cr_double_spin_box_single_step(handle : Handle) : Float64
    fun qt6cr_double_spin_box_decimals = qt6cr_double_spin_box_decimals(handle : Handle) : LibC::Int
    fun qt6cr_double_spin_box_set_decimals = qt6cr_double_spin_box_set_decimals(handle : Handle, value : LibC::Int)
    fun qt6cr_double_spin_box_prefix = qt6cr_double_spin_box_prefix(handle : Handle) : UInt8*
    fun qt6cr_double_spin_box_set_prefix = qt6cr_double_spin_box_set_prefix(handle : Handle, value : UInt8*)
    fun qt6cr_double_spin_box_suffix = qt6cr_double_spin_box_suffix(handle : Handle) : UInt8*
    fun qt6cr_double_spin_box_set_suffix = qt6cr_double_spin_box_set_suffix(handle : Handle, value : UInt8*)
    fun qt6cr_double_spin_box_special_value_text = qt6cr_double_spin_box_special_value_text(handle : Handle) : UInt8*
    fun qt6cr_double_spin_box_set_special_value_text = qt6cr_double_spin_box_set_special_value_text(handle : Handle, value : UInt8*)
    fun qt6cr_double_spin_box_clean_text = qt6cr_double_spin_box_clean_text(handle : Handle) : UInt8*
    fun qt6cr_double_spin_box_on_value_changed = qt6cr_double_spin_box_on_value_changed(handle : Handle, callback : (Handle, Float64 ->), userdata : Handle)

    fun qt6cr_group_box_create = qt6cr_group_box_create(parent : Handle, title : UInt8*) : Handle
    fun qt6cr_group_box_set_title = qt6cr_group_box_set_title(handle : Handle, title : UInt8*)
    fun qt6cr_group_box_title = qt6cr_group_box_title(handle : Handle) : UInt8*
    fun qt6cr_group_box_set_checkable = qt6cr_group_box_set_checkable(handle : Handle, value : Bool)
    fun qt6cr_group_box_is_checkable = qt6cr_group_box_is_checkable(handle : Handle) : Bool
    fun qt6cr_group_box_set_checked = qt6cr_group_box_set_checked(handle : Handle, value : Bool)
    fun qt6cr_group_box_is_checked = qt6cr_group_box_is_checked(handle : Handle) : Bool
    fun qt6cr_group_box_on_toggled = qt6cr_group_box_on_toggled(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)

    fun qt6cr_frame_create = qt6cr_frame_create(parent : Handle) : Handle
    fun qt6cr_frame_shape = qt6cr_frame_shape(handle : Handle) : LibC::Int
    fun qt6cr_frame_set_shape = qt6cr_frame_set_shape(handle : Handle, shape : LibC::Int)
    fun qt6cr_frame_shadow = qt6cr_frame_shadow(handle : Handle) : LibC::Int
    fun qt6cr_frame_set_shadow = qt6cr_frame_set_shadow(handle : Handle, shadow : LibC::Int)

    fun qt6cr_progress_bar_create = qt6cr_progress_bar_create(parent : Handle) : Handle
    fun qt6cr_progress_bar_minimum = qt6cr_progress_bar_minimum(handle : Handle) : LibC::Int
    fun qt6cr_progress_bar_set_minimum = qt6cr_progress_bar_set_minimum(handle : Handle, value : LibC::Int)
    fun qt6cr_progress_bar_maximum = qt6cr_progress_bar_maximum(handle : Handle) : LibC::Int
    fun qt6cr_progress_bar_set_maximum = qt6cr_progress_bar_set_maximum(handle : Handle, value : LibC::Int)
    fun qt6cr_progress_bar_set_range = qt6cr_progress_bar_set_range(handle : Handle, minimum : LibC::Int, maximum : LibC::Int)
    fun qt6cr_progress_bar_value = qt6cr_progress_bar_value(handle : Handle) : LibC::Int
    fun qt6cr_progress_bar_set_value = qt6cr_progress_bar_set_value(handle : Handle, value : LibC::Int)
    fun qt6cr_progress_bar_text_visible = qt6cr_progress_bar_text_visible(handle : Handle) : Bool
    fun qt6cr_progress_bar_set_text_visible = qt6cr_progress_bar_set_text_visible(handle : Handle, value : Bool)
    fun qt6cr_progress_bar_format = qt6cr_progress_bar_format(handle : Handle) : UInt8*
    fun qt6cr_progress_bar_set_format = qt6cr_progress_bar_set_format(handle : Handle, value : UInt8*)
    fun qt6cr_progress_bar_orientation = qt6cr_progress_bar_orientation(handle : Handle) : LibC::Int
    fun qt6cr_progress_bar_set_orientation = qt6cr_progress_bar_set_orientation(handle : Handle, value : LibC::Int)

    fun qt6cr_date_time_edit_create = qt6cr_date_time_edit_create(parent : Handle) : Handle
    fun qt6cr_date_time_edit_display_format = qt6cr_date_time_edit_display_format(handle : Handle) : UInt8*
    fun qt6cr_date_time_edit_set_display_format = qt6cr_date_time_edit_set_display_format(handle : Handle, value : UInt8*)
    fun qt6cr_date_time_edit_calendar_popup = qt6cr_date_time_edit_calendar_popup(handle : Handle) : Bool
    fun qt6cr_date_time_edit_set_calendar_popup = qt6cr_date_time_edit_set_calendar_popup(handle : Handle, value : Bool)
    fun qt6cr_date_time_edit_date = qt6cr_date_time_edit_date(handle : Handle) : Handle
    fun qt6cr_date_time_edit_set_date = qt6cr_date_time_edit_set_date(handle : Handle, value : Handle)
    fun qt6cr_date_time_edit_time = qt6cr_date_time_edit_time(handle : Handle) : Handle
    fun qt6cr_date_time_edit_set_time = qt6cr_date_time_edit_set_time(handle : Handle, value : Handle)
    fun qt6cr_date_time_edit_date_time = qt6cr_date_time_edit_date_time(handle : Handle) : Handle
    fun qt6cr_date_time_edit_set_date_time = qt6cr_date_time_edit_set_date_time(handle : Handle, value : Handle)
    fun qt6cr_date_time_edit_on_date_time_changed = qt6cr_date_time_edit_on_date_time_changed(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)

    fun qt6cr_date_edit_create = qt6cr_date_edit_create(parent : Handle) : Handle
    fun qt6cr_date_edit_on_date_changed = qt6cr_date_edit_on_date_changed(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)

    fun qt6cr_time_edit_create = qt6cr_time_edit_create(parent : Handle) : Handle
    fun qt6cr_time_edit_on_time_changed = qt6cr_time_edit_on_time_changed(handle : Handle, callback : (Handle, Handle ->), userdata : Handle)

    fun qt6cr_calendar_widget_create = qt6cr_calendar_widget_create(parent : Handle) : Handle
    fun qt6cr_calendar_widget_selected_date = qt6cr_calendar_widget_selected_date(handle : Handle) : Handle
    fun qt6cr_calendar_widget_set_selected_date = qt6cr_calendar_widget_set_selected_date(handle : Handle, value : Handle)
    fun qt6cr_calendar_widget_minimum_date = qt6cr_calendar_widget_minimum_date(handle : Handle) : Handle
    fun qt6cr_calendar_widget_set_minimum_date = qt6cr_calendar_widget_set_minimum_date(handle : Handle, value : Handle)
    fun qt6cr_calendar_widget_maximum_date = qt6cr_calendar_widget_maximum_date(handle : Handle) : Handle
    fun qt6cr_calendar_widget_set_maximum_date = qt6cr_calendar_widget_set_maximum_date(handle : Handle, value : Handle)
    fun qt6cr_calendar_widget_grid_visible = qt6cr_calendar_widget_grid_visible(handle : Handle) : Bool
    fun qt6cr_calendar_widget_set_grid_visible = qt6cr_calendar_widget_set_grid_visible(handle : Handle, value : Bool)
    fun qt6cr_calendar_widget_on_selection_changed = qt6cr_calendar_widget_on_selection_changed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_lcd_number_create = qt6cr_lcd_number_create(parent : Handle) : Handle
    fun qt6cr_lcd_number_digit_count = qt6cr_lcd_number_digit_count(handle : Handle) : LibC::Int
    fun qt6cr_lcd_number_set_digit_count = qt6cr_lcd_number_set_digit_count(handle : Handle, value : LibC::Int)
    fun qt6cr_lcd_number_mode = qt6cr_lcd_number_mode(handle : Handle) : LibC::Int
    fun qt6cr_lcd_number_set_mode = qt6cr_lcd_number_set_mode(handle : Handle, value : LibC::Int)
    fun qt6cr_lcd_number_segment_style = qt6cr_lcd_number_segment_style(handle : Handle) : LibC::Int
    fun qt6cr_lcd_number_set_segment_style = qt6cr_lcd_number_set_segment_style(handle : Handle, value : LibC::Int)
    fun qt6cr_lcd_number_value = qt6cr_lcd_number_value(handle : Handle) : Float64
    fun qt6cr_lcd_number_int_value = qt6cr_lcd_number_int_value(handle : Handle) : LibC::Int
    fun qt6cr_lcd_number_display_int = qt6cr_lcd_number_display_int(handle : Handle, value : LibC::Int)
    fun qt6cr_lcd_number_display_double = qt6cr_lcd_number_display_double(handle : Handle, value : Float64)
    fun qt6cr_lcd_number_display_string = qt6cr_lcd_number_display_string(handle : Handle, value : UInt8*)

    fun qt6cr_command_link_button_create = qt6cr_command_link_button_create(parent : Handle, text : UInt8*, description : UInt8*) : Handle
    fun qt6cr_command_link_button_description = qt6cr_command_link_button_description(handle : Handle) : UInt8*
    fun qt6cr_command_link_button_set_description = qt6cr_command_link_button_set_description(handle : Handle, value : UInt8*)

    fun qt6cr_text_document_create = qt6cr_text_document_create(parent : Handle) : Handle
    fun qt6cr_text_document_plain_text = qt6cr_text_document_plain_text(handle : Handle) : UInt8*
    fun qt6cr_text_document_set_plain_text = qt6cr_text_document_set_plain_text(handle : Handle, text : UInt8*)
    fun qt6cr_text_document_html = qt6cr_text_document_html(handle : Handle) : UInt8*
    fun qt6cr_text_document_set_html = qt6cr_text_document_set_html(handle : Handle, html : UInt8*)
    fun qt6cr_text_document_default_style_sheet = qt6cr_text_document_default_style_sheet(handle : Handle) : UInt8*
    fun qt6cr_text_document_set_default_style_sheet = qt6cr_text_document_set_default_style_sheet(handle : Handle, css : UInt8*)
    fun qt6cr_text_document_title = qt6cr_text_document_title(handle : Handle) : UInt8*
    fun qt6cr_text_document_set_title = qt6cr_text_document_set_title(handle : Handle, title : UInt8*)
    fun qt6cr_text_document_is_modified = qt6cr_text_document_is_modified(handle : Handle) : Bool
    fun qt6cr_text_document_set_modified = qt6cr_text_document_set_modified(handle : Handle, value : Bool)
    fun qt6cr_text_document_undo_redo_enabled = qt6cr_text_document_undo_redo_enabled(handle : Handle) : Bool
    fun qt6cr_text_document_set_undo_redo_enabled = qt6cr_text_document_set_undo_redo_enabled(handle : Handle, value : Bool)
    fun qt6cr_text_document_is_empty = qt6cr_text_document_is_empty(handle : Handle) : Bool
    fun qt6cr_text_document_block_count = qt6cr_text_document_block_count(handle : Handle) : LibC::Int
    fun qt6cr_text_document_character_count = qt6cr_text_document_character_count(handle : Handle) : LibC::Int
    fun qt6cr_text_document_find = qt6cr_text_document_find(handle : Handle, text : UInt8*, from_cursor : Handle) : Handle

    fun qt6cr_text_cursor_create = qt6cr_text_cursor_create(document : Handle) : Handle
    fun qt6cr_text_cursor_destroy = qt6cr_text_cursor_destroy(handle : Handle)
    fun qt6cr_text_cursor_is_null = qt6cr_text_cursor_is_null(handle : Handle) : Bool
    fun qt6cr_text_cursor_position = qt6cr_text_cursor_position(handle : Handle) : LibC::Int
    fun qt6cr_text_cursor_set_position = qt6cr_text_cursor_set_position(handle : Handle, position : LibC::Int, keep_anchor : Bool)
    fun qt6cr_text_cursor_move_position = qt6cr_text_cursor_move_position(handle : Handle, operation : LibC::Int, mode : LibC::Int, count : LibC::Int) : Bool
    fun qt6cr_text_cursor_insert_text = qt6cr_text_cursor_insert_text(handle : Handle, text : UInt8*)
    fun qt6cr_text_cursor_selected_text = qt6cr_text_cursor_selected_text(handle : Handle) : UInt8*
    fun qt6cr_text_cursor_has_selection = qt6cr_text_cursor_has_selection(handle : Handle) : Bool
    fun qt6cr_text_cursor_selection_start = qt6cr_text_cursor_selection_start(handle : Handle) : LibC::Int
    fun qt6cr_text_cursor_selection_end = qt6cr_text_cursor_selection_end(handle : Handle) : LibC::Int
    fun qt6cr_text_cursor_clear_selection = qt6cr_text_cursor_clear_selection(handle : Handle)
    fun qt6cr_text_cursor_remove_selected_text = qt6cr_text_cursor_remove_selected_text(handle : Handle)
    fun qt6cr_text_cursor_delete_char = qt6cr_text_cursor_delete_char(handle : Handle)
    fun qt6cr_text_cursor_delete_previous_char = qt6cr_text_cursor_delete_previous_char(handle : Handle)
    fun qt6cr_text_cursor_at_start = qt6cr_text_cursor_at_start(handle : Handle) : Bool
    fun qt6cr_text_cursor_at_end = qt6cr_text_cursor_at_end(handle : Handle) : Bool

    fun qt6cr_text_edit_create = qt6cr_text_edit_create(parent : Handle) : Handle
    fun qt6cr_text_edit_html = qt6cr_text_edit_html(handle : Handle) : UInt8*
    fun qt6cr_text_edit_set_html = qt6cr_text_edit_set_html(handle : Handle, html : UInt8*)
    fun qt6cr_text_edit_plain_text = qt6cr_text_edit_plain_text(handle : Handle) : UInt8*
    fun qt6cr_text_edit_set_plain_text = qt6cr_text_edit_set_plain_text(handle : Handle, text : UInt8*)
    fun qt6cr_text_edit_append = qt6cr_text_edit_append(handle : Handle, text : UInt8*)
    fun qt6cr_text_edit_append_html = qt6cr_text_edit_append_html(handle : Handle, html : UInt8*)
    fun qt6cr_text_edit_insert_plain_text = qt6cr_text_edit_insert_plain_text(handle : Handle, text : UInt8*)
    fun qt6cr_text_edit_insert_html = qt6cr_text_edit_insert_html(handle : Handle, html : UInt8*)
    fun qt6cr_text_edit_is_read_only = qt6cr_text_edit_is_read_only(handle : Handle) : Bool
    fun qt6cr_text_edit_set_read_only = qt6cr_text_edit_set_read_only(handle : Handle, value : Bool)
    fun qt6cr_text_edit_accept_rich_text = qt6cr_text_edit_accept_rich_text(handle : Handle) : Bool
    fun qt6cr_text_edit_set_accept_rich_text = qt6cr_text_edit_set_accept_rich_text(handle : Handle, value : Bool)
    fun qt6cr_text_edit_undo_redo_enabled = qt6cr_text_edit_undo_redo_enabled(handle : Handle) : Bool
    fun qt6cr_text_edit_set_undo_redo_enabled = qt6cr_text_edit_set_undo_redo_enabled(handle : Handle, value : Bool)
    fun qt6cr_text_edit_placeholder_text = qt6cr_text_edit_placeholder_text(handle : Handle) : UInt8*
    fun qt6cr_text_edit_set_placeholder_text = qt6cr_text_edit_set_placeholder_text(handle : Handle, text : UInt8*)
    fun qt6cr_text_edit_document = qt6cr_text_edit_document(handle : Handle) : Handle
    fun qt6cr_text_edit_set_document = qt6cr_text_edit_set_document(handle : Handle, document : Handle)
    fun qt6cr_text_edit_text_cursor = qt6cr_text_edit_text_cursor(handle : Handle) : Handle
    fun qt6cr_text_edit_set_text_cursor = qt6cr_text_edit_set_text_cursor(handle : Handle, cursor : Handle)
    fun qt6cr_text_edit_clear = qt6cr_text_edit_clear(handle : Handle)
    fun qt6cr_text_edit_can_undo = qt6cr_text_edit_can_undo(handle : Handle) : Bool
    fun qt6cr_text_edit_can_redo = qt6cr_text_edit_can_redo(handle : Handle) : Bool
    fun qt6cr_text_edit_undo = qt6cr_text_edit_undo(handle : Handle)
    fun qt6cr_text_edit_redo = qt6cr_text_edit_redo(handle : Handle)
    fun qt6cr_text_edit_select_all = qt6cr_text_edit_select_all(handle : Handle)
    fun qt6cr_text_edit_copy = qt6cr_text_edit_copy(handle : Handle)
    fun qt6cr_text_edit_cut = qt6cr_text_edit_cut(handle : Handle)
    fun qt6cr_text_edit_paste = qt6cr_text_edit_paste(handle : Handle)
    fun qt6cr_text_edit_on_text_changed = qt6cr_text_edit_on_text_changed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_plain_text_edit_create = qt6cr_plain_text_edit_create(parent : Handle) : Handle
    fun qt6cr_plain_text_edit_plain_text = qt6cr_plain_text_edit_plain_text(handle : Handle) : UInt8*
    fun qt6cr_plain_text_edit_set_plain_text = qt6cr_plain_text_edit_set_plain_text(handle : Handle, text : UInt8*)
    fun qt6cr_plain_text_edit_append_plain_text = qt6cr_plain_text_edit_append_plain_text(handle : Handle, text : UInt8*)
    fun qt6cr_plain_text_edit_insert_plain_text = qt6cr_plain_text_edit_insert_plain_text(handle : Handle, text : UInt8*)
    fun qt6cr_plain_text_edit_is_read_only = qt6cr_plain_text_edit_is_read_only(handle : Handle) : Bool
    fun qt6cr_plain_text_edit_set_read_only = qt6cr_plain_text_edit_set_read_only(handle : Handle, value : Bool)
    fun qt6cr_plain_text_edit_undo_redo_enabled = qt6cr_plain_text_edit_undo_redo_enabled(handle : Handle) : Bool
    fun qt6cr_plain_text_edit_set_undo_redo_enabled = qt6cr_plain_text_edit_set_undo_redo_enabled(handle : Handle, value : Bool)
    fun qt6cr_plain_text_edit_placeholder_text = qt6cr_plain_text_edit_placeholder_text(handle : Handle) : UInt8*
    fun qt6cr_plain_text_edit_set_placeholder_text = qt6cr_plain_text_edit_set_placeholder_text(handle : Handle, text : UInt8*)
    fun qt6cr_plain_text_edit_document = qt6cr_plain_text_edit_document(handle : Handle) : Handle
    fun qt6cr_plain_text_edit_set_document = qt6cr_plain_text_edit_set_document(handle : Handle, document : Handle)
    fun qt6cr_plain_text_edit_text_cursor = qt6cr_plain_text_edit_text_cursor(handle : Handle) : Handle
    fun qt6cr_plain_text_edit_set_text_cursor = qt6cr_plain_text_edit_set_text_cursor(handle : Handle, cursor : Handle)
    fun qt6cr_plain_text_edit_clear = qt6cr_plain_text_edit_clear(handle : Handle)
    fun qt6cr_plain_text_edit_can_undo = qt6cr_plain_text_edit_can_undo(handle : Handle) : Bool
    fun qt6cr_plain_text_edit_can_redo = qt6cr_plain_text_edit_can_redo(handle : Handle) : Bool
    fun qt6cr_plain_text_edit_undo = qt6cr_plain_text_edit_undo(handle : Handle)
    fun qt6cr_plain_text_edit_redo = qt6cr_plain_text_edit_redo(handle : Handle)
    fun qt6cr_plain_text_edit_select_all = qt6cr_plain_text_edit_select_all(handle : Handle)
    fun qt6cr_plain_text_edit_copy = qt6cr_plain_text_edit_copy(handle : Handle)
    fun qt6cr_plain_text_edit_cut = qt6cr_plain_text_edit_cut(handle : Handle)
    fun qt6cr_plain_text_edit_paste = qt6cr_plain_text_edit_paste(handle : Handle)
    fun qt6cr_plain_text_edit_on_text_changed = qt6cr_plain_text_edit_on_text_changed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_text_browser_create = qt6cr_text_browser_create(parent : Handle) : Handle
    fun qt6cr_text_browser_html = qt6cr_text_browser_html(handle : Handle) : UInt8*
    fun qt6cr_text_browser_set_html = qt6cr_text_browser_set_html(handle : Handle, html : UInt8*)
    fun qt6cr_text_browser_plain_text = qt6cr_text_browser_plain_text(handle : Handle) : UInt8*
    fun qt6cr_text_browser_open_external_links = qt6cr_text_browser_open_external_links(handle : Handle) : Bool
    fun qt6cr_text_browser_set_open_external_links = qt6cr_text_browser_set_open_external_links(handle : Handle, value : Bool)
    fun qt6cr_text_browser_default_style_sheet = qt6cr_text_browser_default_style_sheet(handle : Handle) : UInt8*
    fun qt6cr_text_browser_set_default_style_sheet = qt6cr_text_browser_set_default_style_sheet(handle : Handle, css : UInt8*)
    fun qt6cr_text_browser_vertical_scroll_value = qt6cr_text_browser_vertical_scroll_value(handle : Handle) : LibC::Int
    fun qt6cr_text_browser_set_vertical_scroll_value = qt6cr_text_browser_set_vertical_scroll_value(handle : Handle, value : LibC::Int)
    fun qt6cr_text_browser_on_anchor_clicked = qt6cr_text_browser_on_anchor_clicked(handle : Handle, callback : (Handle, UInt8* ->), userdata : Handle)

    fun qt6cr_tab_widget_create = qt6cr_tab_widget_create(parent : Handle) : Handle
    fun qt6cr_tab_widget_add_tab = qt6cr_tab_widget_add_tab(handle : Handle, widget : Handle, label : UInt8*) : LibC::Int
    fun qt6cr_tab_widget_count = qt6cr_tab_widget_count(handle : Handle) : LibC::Int
    fun qt6cr_tab_widget_current_index = qt6cr_tab_widget_current_index(handle : Handle) : LibC::Int
    fun qt6cr_tab_widget_set_current_index = qt6cr_tab_widget_set_current_index(handle : Handle, index : LibC::Int)
    fun qt6cr_tab_widget_on_current_index_changed = qt6cr_tab_widget_on_current_index_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

    fun qt6cr_tab_bar_create = qt6cr_tab_bar_create(parent : Handle) : Handle
    fun qt6cr_tab_bar_add_tab = qt6cr_tab_bar_add_tab(handle : Handle, label : UInt8*) : LibC::Int
    fun qt6cr_tab_bar_count = qt6cr_tab_bar_count(handle : Handle) : LibC::Int
    fun qt6cr_tab_bar_current_index = qt6cr_tab_bar_current_index(handle : Handle) : LibC::Int
    fun qt6cr_tab_bar_set_current_index = qt6cr_tab_bar_set_current_index(handle : Handle, index : LibC::Int)
    fun qt6cr_tab_bar_tab_text = qt6cr_tab_bar_tab_text(handle : Handle, index : LibC::Int) : UInt8*
    fun qt6cr_tab_bar_set_tab_text = qt6cr_tab_bar_set_tab_text(handle : Handle, index : LibC::Int, value : UInt8*)
    fun qt6cr_tab_bar_draw_base = qt6cr_tab_bar_draw_base(handle : Handle) : Bool
    fun qt6cr_tab_bar_set_draw_base = qt6cr_tab_bar_set_draw_base(handle : Handle, value : Bool)
    fun qt6cr_tab_bar_on_current_index_changed = qt6cr_tab_bar_on_current_index_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

    fun qt6cr_stacked_widget_create = qt6cr_stacked_widget_create(parent : Handle) : Handle
    fun qt6cr_stacked_widget_add_widget = qt6cr_stacked_widget_add_widget(handle : Handle, widget : Handle) : LibC::Int
    fun qt6cr_stacked_widget_count = qt6cr_stacked_widget_count(handle : Handle) : LibC::Int
    fun qt6cr_stacked_widget_current_index = qt6cr_stacked_widget_current_index(handle : Handle) : LibC::Int
    fun qt6cr_stacked_widget_set_current_index = qt6cr_stacked_widget_set_current_index(handle : Handle, index : LibC::Int)

    fun qt6cr_stacked_layout_create = qt6cr_stacked_layout_create(parent : Handle) : Handle
    fun qt6cr_stacked_layout_add_widget = qt6cr_stacked_layout_add_widget(handle : Handle, widget : Handle) : LibC::Int
    fun qt6cr_stacked_layout_count = qt6cr_stacked_layout_count(handle : Handle) : LibC::Int
    fun qt6cr_stacked_layout_current_index = qt6cr_stacked_layout_current_index(handle : Handle) : LibC::Int
    fun qt6cr_stacked_layout_set_current_index = qt6cr_stacked_layout_set_current_index(handle : Handle, index : LibC::Int)
    fun qt6cr_stacked_layout_on_current_index_changed = qt6cr_stacked_layout_on_current_index_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

    fun qt6cr_scroll_area_create = qt6cr_scroll_area_create(parent : Handle) : Handle
    fun qt6cr_scroll_area_set_widget = qt6cr_scroll_area_set_widget(handle : Handle, widget : Handle)
    fun qt6cr_scroll_area_set_widget_resizable = qt6cr_scroll_area_set_widget_resizable(handle : Handle, value : Bool)
    fun qt6cr_scroll_area_widget_resizable = qt6cr_scroll_area_widget_resizable(handle : Handle) : Bool
    fun qt6cr_scroll_area_vertical_scroll_bar_policy = qt6cr_scroll_area_vertical_scroll_bar_policy(handle : Handle) : LibC::Int
    fun qt6cr_scroll_area_set_vertical_scroll_bar_policy = qt6cr_scroll_area_set_vertical_scroll_bar_policy(handle : Handle, policy : LibC::Int)
    fun qt6cr_scroll_area_horizontal_scroll_bar_policy = qt6cr_scroll_area_horizontal_scroll_bar_policy(handle : Handle) : LibC::Int
    fun qt6cr_scroll_area_set_horizontal_scroll_bar_policy = qt6cr_scroll_area_set_horizontal_scroll_bar_policy(handle : Handle, policy : LibC::Int)
    fun qt6cr_abstract_scroll_area_vertical_scroll_bar_policy = qt6cr_abstract_scroll_area_vertical_scroll_bar_policy(handle : Handle) : LibC::Int
    fun qt6cr_abstract_scroll_area_set_vertical_scroll_bar_policy = qt6cr_abstract_scroll_area_set_vertical_scroll_bar_policy(handle : Handle, policy : LibC::Int)
    fun qt6cr_abstract_scroll_area_horizontal_scroll_bar_policy = qt6cr_abstract_scroll_area_horizontal_scroll_bar_policy(handle : Handle) : LibC::Int
    fun qt6cr_abstract_scroll_area_set_horizontal_scroll_bar_policy = qt6cr_abstract_scroll_area_set_horizontal_scroll_bar_policy(handle : Handle, policy : LibC::Int)
    fun qt6cr_abstract_scroll_area_vertical_scroll_bar = qt6cr_abstract_scroll_area_vertical_scroll_bar(handle : Handle) : Handle
    fun qt6cr_abstract_scroll_area_horizontal_scroll_bar = qt6cr_abstract_scroll_area_horizontal_scroll_bar(handle : Handle) : Handle

    fun qt6cr_splitter_create = qt6cr_splitter_create(parent : Handle, orientation : LibC::Int) : Handle
    fun qt6cr_splitter_add_widget = qt6cr_splitter_add_widget(handle : Handle, widget : Handle)
    fun qt6cr_splitter_count = qt6cr_splitter_count(handle : Handle) : LibC::Int
    fun qt6cr_splitter_orientation = qt6cr_splitter_orientation(handle : Handle) : LibC::Int
    fun qt6cr_splitter_set_orientation = qt6cr_splitter_set_orientation(handle : Handle, orientation : LibC::Int)

    fun qt6cr_dialog_button_box_create = qt6cr_dialog_button_box_create(parent : Handle, buttons : LibC::Int) : Handle
    fun qt6cr_dialog_button_box_button = qt6cr_dialog_button_box_button(handle : Handle, button : LibC::Int) : Handle
    fun qt6cr_dialog_button_box_on_accepted = qt6cr_dialog_button_box_on_accepted(handle : Handle, callback : (Handle ->), userdata : Handle)
    fun qt6cr_dialog_button_box_on_rejected = qt6cr_dialog_button_box_on_rejected(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_button_group_create = qt6cr_button_group_create(parent : Handle) : Handle
    fun qt6cr_button_group_is_exclusive = qt6cr_button_group_is_exclusive(handle : Handle) : Bool
    fun qt6cr_button_group_set_exclusive = qt6cr_button_group_set_exclusive(handle : Handle, value : Bool)
    fun qt6cr_button_group_add_button = qt6cr_button_group_add_button(handle : Handle, button : Handle, id : LibC::Int)
    fun qt6cr_button_group_button = qt6cr_button_group_button(handle : Handle, id : LibC::Int) : Handle
    fun qt6cr_button_group_checked_id = qt6cr_button_group_checked_id(handle : Handle) : LibC::Int

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
    fun qt6cr_v_box_layout_add_stretch = qt6cr_v_box_layout_add_stretch(handle : Handle, stretch : LibC::Int)
    fun qt6cr_v_box_layout_insert_widget = qt6cr_v_box_layout_insert_widget(handle : Handle, index : LibC::Int, widget : Handle)

    fun qt6cr_h_box_layout_create = qt6cr_h_box_layout_create(parent_widget : Handle) : Handle
    fun qt6cr_h_box_layout_add_widget = qt6cr_h_box_layout_add_widget(handle : Handle, widget : Handle)
    fun qt6cr_h_box_layout_add_stretch = qt6cr_h_box_layout_add_stretch(handle : Handle, stretch : LibC::Int)

    fun qt6cr_grid_layout_create = qt6cr_grid_layout_create(parent_widget : Handle) : Handle
    fun qt6cr_grid_layout_add_widget = qt6cr_grid_layout_add_widget(handle : Handle, widget : Handle, row : LibC::Int, column : LibC::Int, row_span : LibC::Int, column_span : LibC::Int)

    fun qt6cr_form_layout_create = qt6cr_form_layout_create(parent_widget : Handle) : Handle
    fun qt6cr_form_layout_add_row_label_widget = qt6cr_form_layout_add_row_label_widget(handle : Handle, label : UInt8*, field_widget : Handle)
    fun qt6cr_form_layout_add_row_widget_widget = qt6cr_form_layout_add_row_widget_widget(handle : Handle, label_widget : Handle, field_widget : Handle)
    fun qt6cr_form_layout_add_row_widget = qt6cr_form_layout_add_row_widget(handle : Handle, widget : Handle)
    fun qt6cr_layout_spacing = qt6cr_layout_spacing(handle : Handle) : LibC::Int
    fun qt6cr_layout_set_spacing = qt6cr_layout_set_spacing(handle : Handle, value : LibC::Int)
    fun qt6cr_layout_set_contents_margins = qt6cr_layout_set_contents_margins(handle : Handle, left : Float64, top : Float64, right : Float64, bottom : Float64)
    fun qt6cr_layout_remove_widget = qt6cr_layout_remove_widget(handle : Handle, widget : Handle)

    fun qt6cr_string_free = qt6cr_string_free(value : UInt8*)
    fun qt6cr_string_array_free = qt6cr_string_array_free(value : StringArrayValue)
  end
end
