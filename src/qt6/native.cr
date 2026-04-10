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

    struct VariantValue
      type : LibC::Int
      bool_value : Bool
      int_value : LibC::Int
      double_value : Float64
      color_value : ColorValue
      string_value : UInt8*
    end

    fun qt6cr_object_destroy = qt6cr_object_destroy(handle : Handle)
    fun qt6cr_object_on_destroyed = qt6cr_object_on_destroyed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_application_create = qt6cr_application_create(argc : LibC::Int, argv : UInt8**) : Handle
    fun qt6cr_application_destroy = qt6cr_application_destroy(handle : Handle)
    fun qt6cr_application_exec = qt6cr_application_exec(handle : Handle) : LibC::Int
    fun qt6cr_application_process_events = qt6cr_application_process_events(handle : Handle)
    fun qt6cr_application_quit = qt6cr_application_quit(handle : Handle)
    fun qt6cr_application_clipboard = qt6cr_application_clipboard(handle : Handle) : Handle

    fun qt6cr_clipboard_text = qt6cr_clipboard_text(handle : Handle) : UInt8*
    fun qt6cr_clipboard_set_text = qt6cr_clipboard_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_clipboard_image = qt6cr_clipboard_image(handle : Handle) : Handle
    fun qt6cr_clipboard_set_image = qt6cr_clipboard_set_image(handle : Handle, image : Handle)
    fun qt6cr_clipboard_pixmap = qt6cr_clipboard_pixmap(handle : Handle) : Handle
    fun qt6cr_clipboard_set_pixmap = qt6cr_clipboard_set_pixmap(handle : Handle, pixmap : Handle)
    fun qt6cr_clipboard_clear = qt6cr_clipboard_clear(handle : Handle)

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
    fun qt6cr_color_dialog_set_native_dialog = qt6cr_color_dialog_set_native_dialog(handle : Handle, value : Bool)
    fun qt6cr_color_dialog_native_dialog = qt6cr_color_dialog_native_dialog(handle : Handle) : Bool
    fun qt6cr_color_dialog_set_show_alpha_channel = qt6cr_color_dialog_set_show_alpha_channel(handle : Handle, value : Bool)
    fun qt6cr_color_dialog_show_alpha_channel = qt6cr_color_dialog_show_alpha_channel(handle : Handle) : Bool

    fun qt6cr_qimage_create = qt6cr_qimage_create(width : LibC::Int, height : LibC::Int, format : LibC::Int) : Handle
    fun qt6cr_qimage_create_from_file = qt6cr_qimage_create_from_file(path : UInt8*) : Handle
    fun qt6cr_qimage_destroy = qt6cr_qimage_destroy(handle : Handle)
    fun qt6cr_qimage_width = qt6cr_qimage_width(handle : Handle) : LibC::Int
    fun qt6cr_qimage_height = qt6cr_qimage_height(handle : Handle) : LibC::Int
    fun qt6cr_qimage_is_null = qt6cr_qimage_is_null(handle : Handle) : Bool
    fun qt6cr_qimage_fill = qt6cr_qimage_fill(handle : Handle, color : ColorValue)
    fun qt6cr_qimage_load = qt6cr_qimage_load(handle : Handle, path : UInt8*) : Bool
    fun qt6cr_qimage_save = qt6cr_qimage_save(handle : Handle, path : UInt8*) : Bool
    fun qt6cr_qimage_pixel_color = qt6cr_qimage_pixel_color(handle : Handle, x : LibC::Int, y : LibC::Int) : ColorValue
    fun qt6cr_qimage_set_pixel_color = qt6cr_qimage_set_pixel_color(handle : Handle, x : LibC::Int, y : LibC::Int, color : ColorValue)

    fun qt6cr_qpixmap_create = qt6cr_qpixmap_create(width : LibC::Int, height : LibC::Int) : Handle
    fun qt6cr_qpixmap_create_from_file = qt6cr_qpixmap_create_from_file(path : UInt8*) : Handle
    fun qt6cr_qpixmap_destroy = qt6cr_qpixmap_destroy(handle : Handle)
    fun qt6cr_qpixmap_from_image = qt6cr_qpixmap_from_image(image : Handle) : Handle
    fun qt6cr_qpixmap_to_image = qt6cr_qpixmap_to_image(handle : Handle) : Handle
    fun qt6cr_qpixmap_width = qt6cr_qpixmap_width(handle : Handle) : LibC::Int
    fun qt6cr_qpixmap_height = qt6cr_qpixmap_height(handle : Handle) : LibC::Int
    fun qt6cr_qpixmap_is_null = qt6cr_qpixmap_is_null(handle : Handle) : Bool
    fun qt6cr_qpixmap_fill = qt6cr_qpixmap_fill(handle : Handle, color : ColorValue)
    fun qt6cr_qpixmap_load = qt6cr_qpixmap_load(handle : Handle, path : UInt8*) : Bool
    fun qt6cr_qpixmap_save = qt6cr_qpixmap_save(handle : Handle, path : UInt8*) : Bool

    fun qt6cr_model_index_create = qt6cr_model_index_create : Handle
    fun qt6cr_model_index_destroy = qt6cr_model_index_destroy(handle : Handle)
    fun qt6cr_model_index_is_valid = qt6cr_model_index_is_valid(handle : Handle) : Bool
    fun qt6cr_model_index_row = qt6cr_model_index_row(handle : Handle) : LibC::Int
    fun qt6cr_model_index_column = qt6cr_model_index_column(handle : Handle) : LibC::Int

    fun qt6cr_abstract_item_model_row_count = qt6cr_abstract_item_model_row_count(handle : Handle, parent_index : Handle) : LibC::Int
    fun qt6cr_abstract_item_model_column_count = qt6cr_abstract_item_model_column_count(handle : Handle, parent_index : Handle) : LibC::Int
    fun qt6cr_abstract_item_model_index = qt6cr_abstract_item_model_index(handle : Handle, row : LibC::Int, column : LibC::Int, parent_index : Handle) : Handle
    fun qt6cr_abstract_item_model_data = qt6cr_abstract_item_model_data(handle : Handle, index : Handle, role : LibC::Int) : VariantValue
    fun qt6cr_abstract_item_model_set_data = qt6cr_abstract_item_model_set_data(handle : Handle, index : Handle, value : VariantValue, role : LibC::Int) : Bool

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
    fun qt6cr_sort_filter_proxy_model_set_filter_fixed_string = qt6cr_sort_filter_proxy_model_set_filter_fixed_string(handle : Handle, value : UInt8*)
    fun qt6cr_sort_filter_proxy_model_set_filter_wildcard = qt6cr_sort_filter_proxy_model_set_filter_wildcard(handle : Handle, value : UInt8*)
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

    fun qt6cr_styled_item_delegate_create = qt6cr_styled_item_delegate_create(parent : Handle) : Handle
    fun qt6cr_styled_item_delegate_on_display_text = qt6cr_styled_item_delegate_on_display_text(handle : Handle, callback : (Handle, UInt8* -> UInt8*), userdata : Handle)
    fun qt6cr_styled_item_delegate_display_text = qt6cr_styled_item_delegate_display_text(handle : Handle, value : VariantValue) : UInt8*

    fun qt6cr_list_view_create = qt6cr_list_view_create(parent : Handle) : Handle
    fun qt6cr_list_view_set_model = qt6cr_list_view_set_model(handle : Handle, model : Handle)
    fun qt6cr_list_view_set_item_delegate = qt6cr_list_view_set_item_delegate(handle : Handle, delegate : Handle)
    fun qt6cr_list_view_current_index = qt6cr_list_view_current_index(handle : Handle) : Handle
    fun qt6cr_list_view_set_current_index = qt6cr_list_view_set_current_index(handle : Handle, index : Handle)
    fun qt6cr_list_view_on_current_index_changed = qt6cr_list_view_on_current_index_changed(handle : Handle, callback : (Handle ->), userdata : Handle)

    fun qt6cr_tree_view_create = qt6cr_tree_view_create(parent : Handle) : Handle
    fun qt6cr_tree_view_set_model = qt6cr_tree_view_set_model(handle : Handle, model : Handle)
    fun qt6cr_tree_view_set_item_delegate = qt6cr_tree_view_set_item_delegate(handle : Handle, delegate : Handle)
    fun qt6cr_tree_view_current_index = qt6cr_tree_view_current_index(handle : Handle) : Handle
    fun qt6cr_tree_view_set_current_index = qt6cr_tree_view_set_current_index(handle : Handle, index : Handle)
    fun qt6cr_tree_view_expand_all = qt6cr_tree_view_expand_all(handle : Handle)
    fun qt6cr_tree_view_collapse_all = qt6cr_tree_view_collapse_all(handle : Handle)
    fun qt6cr_tree_view_on_current_index_changed = qt6cr_tree_view_on_current_index_changed(handle : Handle, callback : (Handle ->), userdata : Handle)

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
    fun qt6cr_qpdf_writer_new_page = qt6cr_qpdf_writer_new_page(handle : Handle) : Bool

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
    fun qt6cr_qpainter_create_for_svg_generator = qt6cr_qpainter_create_for_svg_generator(svg_generator : Handle) : Handle
    fun qt6cr_qpainter_create_for_pdf_writer = qt6cr_qpainter_create_for_pdf_writer(pdf_writer : Handle) : Handle
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

    fun qt6cr_radio_button_create = qt6cr_radio_button_create(parent : Handle, text : UInt8*) : Handle
    fun qt6cr_radio_button_set_text = qt6cr_radio_button_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_radio_button_text = qt6cr_radio_button_text(handle : Handle) : UInt8*
    fun qt6cr_radio_button_set_checked = qt6cr_radio_button_set_checked(handle : Handle, value : Bool)
    fun qt6cr_radio_button_is_checked = qt6cr_radio_button_is_checked(handle : Handle) : Bool
    fun qt6cr_radio_button_on_toggled = qt6cr_radio_button_on_toggled(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)

    fun qt6cr_combo_box_create = qt6cr_combo_box_create(parent : Handle) : Handle
    fun qt6cr_combo_box_add_item = qt6cr_combo_box_add_item(handle : Handle, text : UInt8*)
    fun qt6cr_combo_box_count = qt6cr_combo_box_count(handle : Handle) : LibC::Int
    fun qt6cr_combo_box_current_index = qt6cr_combo_box_current_index(handle : Handle) : LibC::Int
    fun qt6cr_combo_box_set_current_index = qt6cr_combo_box_set_current_index(handle : Handle, index : LibC::Int)
    fun qt6cr_combo_box_current_text = qt6cr_combo_box_current_text(handle : Handle) : UInt8*
    fun qt6cr_combo_box_on_current_index_changed = qt6cr_combo_box_on_current_index_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

    fun qt6cr_list_widget_item_create = qt6cr_list_widget_item_create(text : UInt8*) : Handle
    fun qt6cr_list_widget_item_destroy = qt6cr_list_widget_item_destroy(handle : Handle)
    fun qt6cr_list_widget_item_set_text = qt6cr_list_widget_item_set_text(handle : Handle, text : UInt8*)
    fun qt6cr_list_widget_item_text = qt6cr_list_widget_item_text(handle : Handle) : UInt8*

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
    fun qt6cr_list_widget_on_current_row_changed = qt6cr_list_widget_on_current_row_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

    fun qt6cr_tree_widget_item_create = qt6cr_tree_widget_item_create(text : UInt8*) : Handle
    fun qt6cr_tree_widget_item_destroy = qt6cr_tree_widget_item_destroy(handle : Handle)
    fun qt6cr_tree_widget_item_set_text = qt6cr_tree_widget_item_set_text(handle : Handle, column : LibC::Int, text : UInt8*)
    fun qt6cr_tree_widget_item_text = qt6cr_tree_widget_item_text(handle : Handle, column : LibC::Int) : UInt8*
    fun qt6cr_tree_widget_item_add_child = qt6cr_tree_widget_item_add_child(handle : Handle, child : Handle)
    fun qt6cr_tree_widget_item_child_count = qt6cr_tree_widget_item_child_count(handle : Handle) : LibC::Int
    fun qt6cr_tree_widget_item_child = qt6cr_tree_widget_item_child(handle : Handle, index : LibC::Int) : Handle

    fun qt6cr_tree_widget_create = qt6cr_tree_widget_create(parent : Handle) : Handle
    fun qt6cr_tree_widget_column_count = qt6cr_tree_widget_column_count(handle : Handle) : LibC::Int
    fun qt6cr_tree_widget_set_column_count = qt6cr_tree_widget_set_column_count(handle : Handle, count : LibC::Int)
    fun qt6cr_tree_widget_header_label = qt6cr_tree_widget_header_label(handle : Handle, column : LibC::Int) : UInt8*
    fun qt6cr_tree_widget_set_header_label = qt6cr_tree_widget_set_header_label(handle : Handle, column : LibC::Int, text : UInt8*)
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

    fun qt6cr_slider_create = qt6cr_slider_create(parent : Handle, orientation : LibC::Int) : Handle
    fun qt6cr_slider_set_minimum = qt6cr_slider_set_minimum(handle : Handle, value : LibC::Int)
    fun qt6cr_slider_minimum = qt6cr_slider_minimum(handle : Handle) : LibC::Int
    fun qt6cr_slider_set_maximum = qt6cr_slider_set_maximum(handle : Handle, value : LibC::Int)
    fun qt6cr_slider_maximum = qt6cr_slider_maximum(handle : Handle) : LibC::Int
    fun qt6cr_slider_set_range = qt6cr_slider_set_range(handle : Handle, minimum : LibC::Int, maximum : LibC::Int)
    fun qt6cr_slider_set_value = qt6cr_slider_set_value(handle : Handle, value : LibC::Int)
    fun qt6cr_slider_value = qt6cr_slider_value(handle : Handle) : LibC::Int
    fun qt6cr_slider_orientation = qt6cr_slider_orientation(handle : Handle) : LibC::Int
    fun qt6cr_slider_on_value_changed = qt6cr_slider_on_value_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

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
    fun qt6cr_double_spin_box_on_value_changed = qt6cr_double_spin_box_on_value_changed(handle : Handle, callback : (Handle, Float64 ->), userdata : Handle)

    fun qt6cr_group_box_create = qt6cr_group_box_create(parent : Handle, title : UInt8*) : Handle
    fun qt6cr_group_box_set_title = qt6cr_group_box_set_title(handle : Handle, title : UInt8*)
    fun qt6cr_group_box_title = qt6cr_group_box_title(handle : Handle) : UInt8*
    fun qt6cr_group_box_set_checkable = qt6cr_group_box_set_checkable(handle : Handle, value : Bool)
    fun qt6cr_group_box_is_checkable = qt6cr_group_box_is_checkable(handle : Handle) : Bool
    fun qt6cr_group_box_set_checked = qt6cr_group_box_set_checked(handle : Handle, value : Bool)
    fun qt6cr_group_box_is_checked = qt6cr_group_box_is_checked(handle : Handle) : Bool
    fun qt6cr_group_box_on_toggled = qt6cr_group_box_on_toggled(handle : Handle, callback : (Handle, Bool ->), userdata : Handle)

    fun qt6cr_tab_widget_create = qt6cr_tab_widget_create(parent : Handle) : Handle
    fun qt6cr_tab_widget_add_tab = qt6cr_tab_widget_add_tab(handle : Handle, widget : Handle, label : UInt8*) : LibC::Int
    fun qt6cr_tab_widget_count = qt6cr_tab_widget_count(handle : Handle) : LibC::Int
    fun qt6cr_tab_widget_current_index = qt6cr_tab_widget_current_index(handle : Handle) : LibC::Int
    fun qt6cr_tab_widget_set_current_index = qt6cr_tab_widget_set_current_index(handle : Handle, index : LibC::Int)
    fun qt6cr_tab_widget_on_current_index_changed = qt6cr_tab_widget_on_current_index_changed(handle : Handle, callback : (Handle, LibC::Int ->), userdata : Handle)

    fun qt6cr_scroll_area_create = qt6cr_scroll_area_create(parent : Handle) : Handle
    fun qt6cr_scroll_area_set_widget = qt6cr_scroll_area_set_widget(handle : Handle, widget : Handle)
    fun qt6cr_scroll_area_set_widget_resizable = qt6cr_scroll_area_set_widget_resizable(handle : Handle, value : Bool)
    fun qt6cr_scroll_area_widget_resizable = qt6cr_scroll_area_widget_resizable(handle : Handle) : Bool

    fun qt6cr_splitter_create = qt6cr_splitter_create(parent : Handle, orientation : LibC::Int) : Handle
    fun qt6cr_splitter_add_widget = qt6cr_splitter_add_widget(handle : Handle, widget : Handle)
    fun qt6cr_splitter_count = qt6cr_splitter_count(handle : Handle) : LibC::Int
    fun qt6cr_splitter_orientation = qt6cr_splitter_orientation(handle : Handle) : LibC::Int
    fun qt6cr_splitter_set_orientation = qt6cr_splitter_set_orientation(handle : Handle, orientation : LibC::Int)

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
