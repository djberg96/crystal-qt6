#pragma once

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void *qt6cr_handle_t;
typedef struct {
	double x;
	double y;
} qt6cr_pointf_t;

typedef struct {
	int width;
	int height;
} qt6cr_size_t;

typedef struct {
	double x;
	double y;
	double width;
	double height;
} qt6cr_rectf_t;

typedef struct {
	qt6cr_pointf_t position;
	int button;
	int buttons;
	int modifiers;
} qt6cr_mouse_event_t;

typedef struct {
	qt6cr_pointf_t position;
	qt6cr_pointf_t pixel_delta;
	qt6cr_pointf_t angle_delta;
	int buttons;
	int modifiers;
} qt6cr_wheel_event_t;

typedef struct {
	int key;
	int modifiers;
	bool auto_repeat;
	int count;
} qt6cr_key_event_t;

typedef struct {
	int red;
	int green;
	int blue;
	int alpha;
} qt6cr_color_t;

typedef void (*qt6cr_void_callback_t)(void *userdata);
typedef void (*qt6cr_bool_callback_t)(void *userdata, bool value);
typedef void (*qt6cr_int_callback_t)(void *userdata, int value);
typedef void (*qt6cr_paint_callback_t)(void *userdata, qt6cr_rectf_t rect);
typedef void (*qt6cr_paint_with_painter_callback_t)(void *userdata, qt6cr_handle_t painter, qt6cr_rectf_t rect);
typedef void (*qt6cr_resize_callback_t)(void *userdata, qt6cr_size_t old_size, qt6cr_size_t new_size);
typedef void (*qt6cr_mouse_callback_t)(void *userdata, qt6cr_mouse_event_t event_data);
typedef void (*qt6cr_wheel_callback_t)(void *userdata, qt6cr_wheel_event_t event_data);
typedef void (*qt6cr_key_callback_t)(void *userdata, qt6cr_key_event_t event_data);

void qt6cr_object_destroy(qt6cr_handle_t handle);
void qt6cr_object_on_destroyed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_application_create(int argc, const char *const *argv);
void qt6cr_application_destroy(qt6cr_handle_t handle);
int qt6cr_application_exec(qt6cr_handle_t handle);
void qt6cr_application_process_events(qt6cr_handle_t handle);
void qt6cr_application_quit(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_widget_create(qt6cr_handle_t parent);
void qt6cr_widget_destroy(qt6cr_handle_t handle);
void qt6cr_widget_show(qt6cr_handle_t handle);
void qt6cr_widget_close(qt6cr_handle_t handle);
void qt6cr_widget_resize(qt6cr_handle_t handle, int width, int height);
void qt6cr_widget_set_window_title(qt6cr_handle_t handle, const char *title);
char *qt6cr_widget_window_title(qt6cr_handle_t handle);
bool qt6cr_widget_is_visible(qt6cr_handle_t handle);
qt6cr_size_t qt6cr_widget_size(qt6cr_handle_t handle);
qt6cr_rectf_t qt6cr_widget_rect(qt6cr_handle_t handle);
void qt6cr_widget_update(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_widget_grab(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_main_window_create(qt6cr_handle_t parent);
void qt6cr_main_window_set_central_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);
qt6cr_handle_t qt6cr_main_window_menu_bar(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_main_window_status_bar(qt6cr_handle_t handle);
void qt6cr_main_window_add_tool_bar(qt6cr_handle_t handle, qt6cr_handle_t toolbar);
void qt6cr_main_window_add_dock_widget(qt6cr_handle_t handle, int area, qt6cr_handle_t dock_widget);

qt6cr_handle_t qt6cr_dialog_create(qt6cr_handle_t parent);
int qt6cr_dialog_exec(qt6cr_handle_t handle);
void qt6cr_dialog_accept(qt6cr_handle_t handle);
void qt6cr_dialog_reject(qt6cr_handle_t handle);
int qt6cr_dialog_result(qt6cr_handle_t handle);
void qt6cr_dialog_on_accepted(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);
void qt6cr_dialog_on_rejected(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_message_box_create(qt6cr_handle_t parent);
int qt6cr_message_box_exec(qt6cr_handle_t handle);
void qt6cr_message_box_set_icon(qt6cr_handle_t handle, int icon);
int qt6cr_message_box_icon(qt6cr_handle_t handle);
void qt6cr_message_box_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_message_box_text(qt6cr_handle_t handle);
void qt6cr_message_box_set_informative_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_message_box_informative_text(qt6cr_handle_t handle);
void qt6cr_message_box_set_standard_buttons(qt6cr_handle_t handle, int buttons);
int qt6cr_message_box_standard_buttons(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_file_dialog_create(qt6cr_handle_t parent, const char *directory, const char *filter);
void qt6cr_file_dialog_set_accept_mode(qt6cr_handle_t handle, int accept_mode);
int qt6cr_file_dialog_accept_mode(qt6cr_handle_t handle);
void qt6cr_file_dialog_set_file_mode(qt6cr_handle_t handle, int file_mode);
int qt6cr_file_dialog_file_mode(qt6cr_handle_t handle);
void qt6cr_file_dialog_set_directory(qt6cr_handle_t handle, const char *directory);
char *qt6cr_file_dialog_directory(qt6cr_handle_t handle);
void qt6cr_file_dialog_set_name_filter(qt6cr_handle_t handle, const char *filter);
char *qt6cr_file_dialog_name_filter(qt6cr_handle_t handle);
void qt6cr_file_dialog_select_file(qt6cr_handle_t handle, const char *path);
char *qt6cr_file_dialog_selected_file(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_color_dialog_create(qt6cr_handle_t parent);
void qt6cr_color_dialog_set_current_color(qt6cr_handle_t handle, qt6cr_color_t color);
qt6cr_color_t qt6cr_color_dialog_current_color(qt6cr_handle_t handle);
void qt6cr_color_dialog_set_show_alpha_channel(qt6cr_handle_t handle, bool value);
bool qt6cr_color_dialog_show_alpha_channel(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_qimage_create(int width, int height, int format);
void qt6cr_qimage_destroy(qt6cr_handle_t handle);
int qt6cr_qimage_width(qt6cr_handle_t handle);
int qt6cr_qimage_height(qt6cr_handle_t handle);
bool qt6cr_qimage_is_null(qt6cr_handle_t handle);
void qt6cr_qimage_fill(qt6cr_handle_t handle, qt6cr_color_t color);
bool qt6cr_qimage_save(qt6cr_handle_t handle, const char *path);
qt6cr_color_t qt6cr_qimage_pixel_color(qt6cr_handle_t handle, int x, int y);
void qt6cr_qimage_set_pixel_color(qt6cr_handle_t handle, int x, int y, qt6cr_color_t color);

qt6cr_handle_t qt6cr_qpixmap_create(int width, int height);
void qt6cr_qpixmap_destroy(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_qpixmap_from_image(qt6cr_handle_t image);
qt6cr_handle_t qt6cr_qpixmap_to_image(qt6cr_handle_t handle);
int qt6cr_qpixmap_width(qt6cr_handle_t handle);
int qt6cr_qpixmap_height(qt6cr_handle_t handle);
bool qt6cr_qpixmap_is_null(qt6cr_handle_t handle);
void qt6cr_qpixmap_fill(qt6cr_handle_t handle, qt6cr_color_t color);
bool qt6cr_qpixmap_save(qt6cr_handle_t handle, const char *path);

qt6cr_handle_t qt6cr_qpen_create(qt6cr_color_t color, double width);
void qt6cr_qpen_destroy(qt6cr_handle_t handle);
qt6cr_color_t qt6cr_qpen_color(qt6cr_handle_t handle);
void qt6cr_qpen_set_color(qt6cr_handle_t handle, qt6cr_color_t color);
double qt6cr_qpen_width(qt6cr_handle_t handle);
void qt6cr_qpen_set_width(qt6cr_handle_t handle, double width);

qt6cr_handle_t qt6cr_qbrush_create(qt6cr_color_t color);
void qt6cr_qbrush_destroy(qt6cr_handle_t handle);
qt6cr_color_t qt6cr_qbrush_color(qt6cr_handle_t handle);
void qt6cr_qbrush_set_color(qt6cr_handle_t handle, qt6cr_color_t color);

qt6cr_handle_t qt6cr_qfont_create(const char *family, int point_size, bool bold, bool italic);
void qt6cr_qfont_destroy(qt6cr_handle_t handle);
char *qt6cr_qfont_family(qt6cr_handle_t handle);
void qt6cr_qfont_set_family(qt6cr_handle_t handle, const char *family);
int qt6cr_qfont_point_size(qt6cr_handle_t handle);
void qt6cr_qfont_set_point_size(qt6cr_handle_t handle, int point_size);
bool qt6cr_qfont_bold(qt6cr_handle_t handle);
void qt6cr_qfont_set_bold(qt6cr_handle_t handle, bool value);
bool qt6cr_qfont_italic(qt6cr_handle_t handle);
void qt6cr_qfont_set_italic(qt6cr_handle_t handle, bool value);

qt6cr_handle_t qt6cr_qtransform_create(void);
void qt6cr_qtransform_destroy(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_qtransform_copy(qt6cr_handle_t handle);
void qt6cr_qtransform_reset(qt6cr_handle_t handle);
void qt6cr_qtransform_translate(qt6cr_handle_t handle, double dx, double dy);
void qt6cr_qtransform_scale(qt6cr_handle_t handle, double sx, double sy);
void qt6cr_qtransform_rotate(qt6cr_handle_t handle, double angle);
qt6cr_pointf_t qt6cr_qtransform_map_point(qt6cr_handle_t handle, qt6cr_pointf_t point);
qt6cr_rectf_t qt6cr_qtransform_map_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect);

qt6cr_handle_t qt6cr_qpainter_path_create(void);
void qt6cr_qpainter_path_destroy(qt6cr_handle_t handle);
void qt6cr_qpainter_path_move_to(qt6cr_handle_t handle, qt6cr_pointf_t point);
void qt6cr_qpainter_path_line_to(qt6cr_handle_t handle, qt6cr_pointf_t point);
void qt6cr_qpainter_path_quad_to(qt6cr_handle_t handle, qt6cr_pointf_t control_point, qt6cr_pointf_t end_point);
void qt6cr_qpainter_path_cubic_to(qt6cr_handle_t handle, qt6cr_pointf_t control_point1, qt6cr_pointf_t control_point2, qt6cr_pointf_t end_point);
void qt6cr_qpainter_path_add_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect);
void qt6cr_qpainter_path_add_ellipse(qt6cr_handle_t handle, qt6cr_rectf_t rect);
void qt6cr_qpainter_path_close_subpath(qt6cr_handle_t handle);
qt6cr_rectf_t qt6cr_qpainter_path_bounding_rect(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_qpainter_path_transformed(qt6cr_handle_t handle, qt6cr_handle_t transform);

qt6cr_handle_t qt6cr_qpainter_create_for_image(qt6cr_handle_t image);
qt6cr_handle_t qt6cr_qpainter_create_for_pixmap(qt6cr_handle_t pixmap);
void qt6cr_qpainter_destroy(qt6cr_handle_t handle);
bool qt6cr_qpainter_is_active(qt6cr_handle_t handle);
void qt6cr_qpainter_set_antialiasing(qt6cr_handle_t handle, bool value);
void qt6cr_qpainter_set_pen_color(qt6cr_handle_t handle, qt6cr_color_t color);
void qt6cr_qpainter_set_pen(qt6cr_handle_t handle, qt6cr_handle_t pen);
void qt6cr_qpainter_set_brush_color(qt6cr_handle_t handle, qt6cr_color_t color);
void qt6cr_qpainter_set_brush(qt6cr_handle_t handle, qt6cr_handle_t brush);
void qt6cr_qpainter_set_font(qt6cr_handle_t handle, qt6cr_handle_t font);
void qt6cr_qpainter_set_transform(qt6cr_handle_t handle, qt6cr_handle_t transform);
void qt6cr_qpainter_reset_transform(qt6cr_handle_t handle);
void qt6cr_qpainter_draw_line(qt6cr_handle_t handle, qt6cr_pointf_t from_point, qt6cr_pointf_t to_point);
void qt6cr_qpainter_draw_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect);
void qt6cr_qpainter_fill_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect, qt6cr_color_t color);
void qt6cr_qpainter_draw_ellipse(qt6cr_handle_t handle, qt6cr_rectf_t rect);
void qt6cr_qpainter_draw_path(qt6cr_handle_t handle, qt6cr_handle_t path);
void qt6cr_qpainter_draw_image(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_handle_t image);
void qt6cr_qpainter_draw_pixmap(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_handle_t pixmap);
void qt6cr_qpainter_draw_text(qt6cr_handle_t handle, qt6cr_pointf_t position, const char *text);

qt6cr_handle_t qt6cr_input_dialog_create(qt6cr_handle_t parent);
void qt6cr_input_dialog_set_input_mode(qt6cr_handle_t handle, int input_mode);
int qt6cr_input_dialog_input_mode(qt6cr_handle_t handle);
void qt6cr_input_dialog_set_label_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_input_dialog_label_text(qt6cr_handle_t handle);
void qt6cr_input_dialog_set_text_value(qt6cr_handle_t handle, const char *text);
char *qt6cr_input_dialog_text_value(qt6cr_handle_t handle);
void qt6cr_input_dialog_set_int_value(qt6cr_handle_t handle, int value);
int qt6cr_input_dialog_int_value(qt6cr_handle_t handle);
void qt6cr_input_dialog_set_int_range(qt6cr_handle_t handle, int minimum, int maximum);
int qt6cr_input_dialog_int_minimum(qt6cr_handle_t handle);
int qt6cr_input_dialog_int_maximum(qt6cr_handle_t handle);
void qt6cr_input_dialog_set_double_value(qt6cr_handle_t handle, double value);
double qt6cr_input_dialog_double_value(qt6cr_handle_t handle);
void qt6cr_input_dialog_set_double_range(qt6cr_handle_t handle, double minimum, double maximum);
double qt6cr_input_dialog_double_minimum(qt6cr_handle_t handle);
double qt6cr_input_dialog_double_maximum(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_dock_widget_create(qt6cr_handle_t parent, const char *title);
void qt6cr_dock_widget_set_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);

qt6cr_handle_t qt6cr_action_create(qt6cr_handle_t parent, const char *text);
void qt6cr_action_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_action_text(qt6cr_handle_t handle);
void qt6cr_action_set_shortcut(qt6cr_handle_t handle, const char *shortcut);
char *qt6cr_action_shortcut(qt6cr_handle_t handle);
void qt6cr_action_set_checkable(qt6cr_handle_t handle, bool value);
bool qt6cr_action_is_checkable(qt6cr_handle_t handle);
void qt6cr_action_set_checked(qt6cr_handle_t handle, bool value);
bool qt6cr_action_is_checked(qt6cr_handle_t handle);
void qt6cr_action_on_triggered(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);
void qt6cr_action_trigger(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_action_group_create(qt6cr_handle_t parent);
void qt6cr_action_group_add_action(qt6cr_handle_t handle, qt6cr_handle_t action);
void qt6cr_action_group_set_exclusive(qt6cr_handle_t handle, bool value);
bool qt6cr_action_group_is_exclusive(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_menu_bar_add_menu(qt6cr_handle_t handle, const char *title);

qt6cr_handle_t qt6cr_menu_add_menu(qt6cr_handle_t handle, const char *title);
void qt6cr_menu_add_action(qt6cr_handle_t handle, qt6cr_handle_t action);
void qt6cr_menu_add_separator(qt6cr_handle_t handle);
void qt6cr_menu_set_title(qt6cr_handle_t handle, const char *title);
char *qt6cr_menu_title(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_tool_bar_create(qt6cr_handle_t parent, const char *title);
void qt6cr_tool_bar_add_action(qt6cr_handle_t handle, qt6cr_handle_t action);

qt6cr_handle_t qt6cr_status_bar_create(qt6cr_handle_t parent);
void qt6cr_status_bar_show_message(qt6cr_handle_t handle, const char *message, int timeout_ms);
char *qt6cr_status_bar_current_message(qt6cr_handle_t handle);
void qt6cr_status_bar_clear_message(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_event_widget_create(qt6cr_handle_t parent);
void qt6cr_event_widget_on_paint(qt6cr_handle_t handle, qt6cr_paint_callback_t callback, void *userdata);
void qt6cr_event_widget_on_paint_with_painter(qt6cr_handle_t handle, qt6cr_paint_with_painter_callback_t callback, void *userdata);
void qt6cr_event_widget_on_resize(qt6cr_handle_t handle, qt6cr_resize_callback_t callback, void *userdata);
void qt6cr_event_widget_on_mouse_press(qt6cr_handle_t handle, qt6cr_mouse_callback_t callback, void *userdata);
void qt6cr_event_widget_on_mouse_move(qt6cr_handle_t handle, qt6cr_mouse_callback_t callback, void *userdata);
void qt6cr_event_widget_on_mouse_release(qt6cr_handle_t handle, qt6cr_mouse_callback_t callback, void *userdata);
void qt6cr_event_widget_on_wheel(qt6cr_handle_t handle, qt6cr_wheel_callback_t callback, void *userdata);
void qt6cr_event_widget_on_key_press(qt6cr_handle_t handle, qt6cr_key_callback_t callback, void *userdata);
void qt6cr_event_widget_repaint(qt6cr_handle_t handle);
void qt6cr_event_widget_send_mouse_press(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers);
void qt6cr_event_widget_send_mouse_move(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers);
void qt6cr_event_widget_send_mouse_release(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers);
void qt6cr_event_widget_send_wheel(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_pointf_t pixel_delta, qt6cr_pointf_t angle_delta, int buttons, int modifiers);
void qt6cr_event_widget_send_key_press(qt6cr_handle_t handle, int key, int modifiers, bool auto_repeat, int count);

qt6cr_handle_t qt6cr_label_create(qt6cr_handle_t parent, const char *text);
void qt6cr_label_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_label_text(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_push_button_create(qt6cr_handle_t parent, const char *text);
void qt6cr_push_button_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_push_button_text(qt6cr_handle_t handle);
void qt6cr_push_button_on_clicked(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);
void qt6cr_push_button_click(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_line_edit_create(qt6cr_handle_t parent, const char *text);
void qt6cr_line_edit_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_line_edit_text(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_check_box_create(qt6cr_handle_t parent, const char *text);
void qt6cr_check_box_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_check_box_text(qt6cr_handle_t handle);
void qt6cr_check_box_set_checked(qt6cr_handle_t handle, bool value);
bool qt6cr_check_box_is_checked(qt6cr_handle_t handle);
void qt6cr_check_box_on_toggled(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_combo_box_create(qt6cr_handle_t parent);
void qt6cr_combo_box_add_item(qt6cr_handle_t handle, const char *text);
int qt6cr_combo_box_count(qt6cr_handle_t handle);
int qt6cr_combo_box_current_index(qt6cr_handle_t handle);
void qt6cr_combo_box_set_current_index(qt6cr_handle_t handle, int index);
char *qt6cr_combo_box_current_text(qt6cr_handle_t handle);
void qt6cr_combo_box_on_current_index_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_timer_create(qt6cr_handle_t parent);
void qt6cr_timer_set_interval(qt6cr_handle_t handle, int interval);
int qt6cr_timer_interval(qt6cr_handle_t handle);
void qt6cr_timer_set_single_shot(qt6cr_handle_t handle, bool value);
bool qt6cr_timer_is_single_shot(qt6cr_handle_t handle);
bool qt6cr_timer_is_active(qt6cr_handle_t handle);
void qt6cr_timer_start(qt6cr_handle_t handle);
void qt6cr_timer_stop(qt6cr_handle_t handle);
void qt6cr_timer_on_timeout(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_v_box_layout_create(qt6cr_handle_t parent_widget);
void qt6cr_v_box_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);

qt6cr_handle_t qt6cr_h_box_layout_create(qt6cr_handle_t parent_widget);
void qt6cr_h_box_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);

qt6cr_handle_t qt6cr_grid_layout_create(qt6cr_handle_t parent_widget);
void qt6cr_grid_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget, int row, int column, int row_span, int column_span);

qt6cr_handle_t qt6cr_form_layout_create(qt6cr_handle_t parent_widget);
void qt6cr_form_layout_add_row_label_widget(qt6cr_handle_t handle, const char *label, qt6cr_handle_t field_widget);
void qt6cr_form_layout_add_row_widget_widget(qt6cr_handle_t handle, qt6cr_handle_t label_widget, qt6cr_handle_t field_widget);
void qt6cr_form_layout_add_row_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);

void qt6cr_string_free(char *value);

#ifdef __cplusplus
}
#endif
