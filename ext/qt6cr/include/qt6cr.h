#pragma once

#include <stdbool.h>
#include <stdint.h>

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
	double width;
	double height;
} qt6cr_sizef_t;

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

typedef struct {
	unsigned char *data;
	int size;
} qt6cr_byte_array_t;

typedef struct {
	int type;
	bool bool_value;
	int int_value;
	double double_value;
	qt6cr_color_t color_value;
	const char *string_value;
} qt6cr_variant_value_t;

typedef struct {
	bool valid;
	int row;
	int column;
	uint64_t internal_id;
} qt6cr_model_index_spec_t;

typedef void (*qt6cr_void_callback_t)(void *userdata);
typedef void (*qt6cr_bool_callback_t)(void *userdata, bool value);
typedef void (*qt6cr_int_callback_t)(void *userdata, int value);
typedef void (*qt6cr_double_callback_t)(void *userdata, double value);
typedef void (*qt6cr_handle_callback_t)(void *userdata, qt6cr_handle_t handle);
typedef void (*qt6cr_string_callback_t)(void *userdata, const char *value);
typedef bool (*qt6cr_event_filter_callback_t)(void *userdata, qt6cr_handle_t watched, qt6cr_handle_t event);
typedef void (*qt6cr_paint_callback_t)(void *userdata, qt6cr_rectf_t rect);
typedef void (*qt6cr_paint_with_painter_callback_t)(void *userdata, qt6cr_handle_t painter, qt6cr_rectf_t rect);
typedef void (*qt6cr_resize_callback_t)(void *userdata, qt6cr_size_t old_size, qt6cr_size_t new_size);
typedef void (*qt6cr_mouse_callback_t)(void *userdata, qt6cr_mouse_event_t event_data);
typedef void (*qt6cr_wheel_callback_t)(void *userdata, qt6cr_wheel_event_t event_data);
typedef void (*qt6cr_key_callback_t)(void *userdata, qt6cr_key_event_t event_data);
typedef char *(*qt6cr_string_transform_callback_t)(void *userdata, const char *text);
typedef void (*qt6cr_drop_event_callback_t)(void *userdata, qt6cr_handle_t event);
typedef int (*qt6cr_model_count_callback_t)(void *userdata);
typedef qt6cr_variant_value_t (*qt6cr_model_data_callback_t)(void *userdata, qt6cr_handle_t index, int role);
typedef bool (*qt6cr_model_set_data_callback_t)(void *userdata, qt6cr_handle_t index, qt6cr_variant_value_t value, int role);
typedef qt6cr_variant_value_t (*qt6cr_model_header_data_callback_t)(void *userdata, int section, int orientation, int role);
typedef int (*qt6cr_model_flags_callback_t)(void *userdata, qt6cr_handle_t index);
typedef int (*qt6cr_model_mime_type_count_callback_t)(void *userdata);
typedef char *(*qt6cr_indexed_string_callback_t)(void *userdata, int index);
typedef qt6cr_handle_t (*qt6cr_model_mime_data_callback_t)(void *userdata, qt6cr_handle_t *indexes, int count);
typedef bool (*qt6cr_model_drop_mime_data_callback_t)(void *userdata, qt6cr_handle_t mime_data, int action, int row, int column, qt6cr_handle_t parent_index);
typedef int (*qt6cr_model_actions_callback_t)(void *userdata);
typedef int (*qt6cr_model_count_with_parent_callback_t)(void *userdata, qt6cr_handle_t parent_index);
typedef uint64_t (*qt6cr_model_index_id_callback_t)(void *userdata, int row, int column, qt6cr_handle_t parent_index);
typedef qt6cr_model_index_spec_t (*qt6cr_model_parent_callback_t)(void *userdata, qt6cr_handle_t index);
typedef qt6cr_handle_t (*qt6cr_delegate_create_editor_callback_t)(void *userdata, qt6cr_handle_t parent, qt6cr_handle_t index);
typedef void (*qt6cr_delegate_set_editor_data_callback_t)(void *userdata, qt6cr_handle_t editor, qt6cr_variant_value_t value, qt6cr_handle_t index);
typedef void (*qt6cr_delegate_set_model_data_callback_t)(void *userdata, qt6cr_handle_t editor, qt6cr_handle_t model, qt6cr_handle_t index);

void qt6cr_object_destroy(qt6cr_handle_t handle);
void qt6cr_object_on_destroyed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);
bool qt6cr_object_block_signals(qt6cr_handle_t handle, bool block);
bool qt6cr_object_signals_blocked(qt6cr_handle_t handle);
void qt6cr_object_install_event_filter(qt6cr_handle_t handle, qt6cr_handle_t filter);
void qt6cr_object_remove_event_filter(qt6cr_handle_t handle, qt6cr_handle_t filter);

qt6cr_handle_t qt6cr_event_filter_create(qt6cr_handle_t parent);
void qt6cr_event_filter_on_event(qt6cr_handle_t handle, qt6cr_event_filter_callback_t callback, void *userdata);
int qt6cr_event_type(qt6cr_handle_t handle);
void qt6cr_event_accept(qt6cr_handle_t handle);
void qt6cr_event_ignore(qt6cr_handle_t handle);
bool qt6cr_event_is_accepted(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_application_create(int argc, const char *const *argv);
void qt6cr_application_destroy(qt6cr_handle_t handle);
int qt6cr_application_exec(qt6cr_handle_t handle);
void qt6cr_application_process_events(qt6cr_handle_t handle);
void qt6cr_application_quit(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_application_clipboard(qt6cr_handle_t handle);
char *qt6cr_application_name(qt6cr_handle_t handle);
void qt6cr_application_set_name(qt6cr_handle_t handle, const char *name);
char *qt6cr_application_organization_name(qt6cr_handle_t handle);
void qt6cr_application_set_organization_name(qt6cr_handle_t handle, const char *name);
char *qt6cr_application_organization_domain(qt6cr_handle_t handle);
void qt6cr_application_set_organization_domain(qt6cr_handle_t handle, const char *domain);
char *qt6cr_application_style_sheet(qt6cr_handle_t handle);
void qt6cr_application_set_style_sheet(qt6cr_handle_t handle, const char *style_sheet);
qt6cr_handle_t qt6cr_application_window_icon(qt6cr_handle_t handle);
void qt6cr_application_set_window_icon(qt6cr_handle_t handle, qt6cr_handle_t icon);

qt6cr_handle_t qt6cr_event_loop_create(qt6cr_handle_t parent);
int qt6cr_event_loop_exec(qt6cr_handle_t handle);
void qt6cr_event_loop_quit(qt6cr_handle_t handle);
void qt6cr_event_loop_exit(qt6cr_handle_t handle, int return_code);
void qt6cr_event_loop_process_events(qt6cr_handle_t handle);
bool qt6cr_event_loop_is_running(qt6cr_handle_t handle);

char *qt6cr_clipboard_text(qt6cr_handle_t handle);
void qt6cr_clipboard_set_text(qt6cr_handle_t handle, const char *text);
qt6cr_handle_t qt6cr_clipboard_image(qt6cr_handle_t handle);
void qt6cr_clipboard_set_image(qt6cr_handle_t handle, qt6cr_handle_t image);
qt6cr_handle_t qt6cr_clipboard_pixmap(qt6cr_handle_t handle);
void qt6cr_clipboard_set_pixmap(qt6cr_handle_t handle, qt6cr_handle_t pixmap);
qt6cr_handle_t qt6cr_clipboard_mime_data(qt6cr_handle_t handle);
void qt6cr_clipboard_set_mime_data(qt6cr_handle_t handle, qt6cr_handle_t mime_data);
void qt6cr_clipboard_clear(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_mime_data_create(void);
bool qt6cr_mime_data_has_text(qt6cr_handle_t handle);
char *qt6cr_mime_data_text(qt6cr_handle_t handle);
void qt6cr_mime_data_set_text(qt6cr_handle_t handle, const char *text);
bool qt6cr_mime_data_has_format(qt6cr_handle_t handle, const char *format);
qt6cr_byte_array_t qt6cr_mime_data_data(qt6cr_handle_t handle, const char *format);
void qt6cr_mime_data_set_data(qt6cr_handle_t handle, const char *format, const unsigned char *data, int size);

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
char *qt6cr_widget_style_sheet(qt6cr_handle_t handle);
void qt6cr_widget_set_style_sheet(qt6cr_handle_t handle, const char *style_sheet);
qt6cr_handle_t qt6cr_widget_window_icon(qt6cr_handle_t handle);
void qt6cr_widget_set_window_icon(qt6cr_handle_t handle, qt6cr_handle_t icon);
bool qt6cr_widget_is_enabled(qt6cr_handle_t handle);
void qt6cr_widget_set_enabled(qt6cr_handle_t handle, bool value);
bool qt6cr_widget_has_focus(qt6cr_handle_t handle);
int qt6cr_widget_focus_policy(qt6cr_handle_t handle);
void qt6cr_widget_set_focus_policy(qt6cr_handle_t handle, int value);
void qt6cr_widget_set_focus(qt6cr_handle_t handle);
void qt6cr_widget_clear_focus(qt6cr_handle_t handle);
void qt6cr_widget_set_fixed_size(qt6cr_handle_t handle, int width, int height);
void qt6cr_widget_simulate_wheel(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_pointf_t pixel_delta, qt6cr_pointf_t angle_delta, int buttons, int modifiers);
int qt6cr_widget_horizontal_size_policy(qt6cr_handle_t handle);
int qt6cr_widget_vertical_size_policy(qt6cr_handle_t handle);
void qt6cr_widget_set_size_policy(qt6cr_handle_t handle, int horizontal, int vertical);
int qt6cr_widget_minimum_width(qt6cr_handle_t handle);
void qt6cr_widget_set_minimum_width(qt6cr_handle_t handle, int value);
bool qt6cr_widget_accept_drops(qt6cr_handle_t handle);
void qt6cr_widget_set_accept_drops(qt6cr_handle_t handle, bool value);

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
void qt6cr_color_dialog_set_native_dialog(qt6cr_handle_t handle, bool value);
bool qt6cr_color_dialog_native_dialog(qt6cr_handle_t handle);
void qt6cr_color_dialog_set_show_alpha_channel(qt6cr_handle_t handle, bool value);
bool qt6cr_color_dialog_show_alpha_channel(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_progress_dialog_create(qt6cr_handle_t parent, const char *label_text, const char *cancel_button_text, int minimum, int maximum);
char *qt6cr_progress_dialog_label_text(qt6cr_handle_t handle);
void qt6cr_progress_dialog_set_label_text(qt6cr_handle_t handle, const char *label_text);
void qt6cr_progress_dialog_set_cancel_button_text(qt6cr_handle_t handle, const char *cancel_button_text);
int qt6cr_progress_dialog_minimum(qt6cr_handle_t handle);
void qt6cr_progress_dialog_set_minimum(qt6cr_handle_t handle, int value);
int qt6cr_progress_dialog_maximum(qt6cr_handle_t handle);
void qt6cr_progress_dialog_set_maximum(qt6cr_handle_t handle, int value);
void qt6cr_progress_dialog_set_range(qt6cr_handle_t handle, int minimum, int maximum);
int qt6cr_progress_dialog_value(qt6cr_handle_t handle);
void qt6cr_progress_dialog_set_value(qt6cr_handle_t handle, int value);
bool qt6cr_progress_dialog_auto_close(qt6cr_handle_t handle);
void qt6cr_progress_dialog_set_auto_close(qt6cr_handle_t handle, bool value);
bool qt6cr_progress_dialog_auto_reset(qt6cr_handle_t handle);
void qt6cr_progress_dialog_set_auto_reset(qt6cr_handle_t handle, bool value);
int qt6cr_progress_dialog_minimum_duration(qt6cr_handle_t handle);
void qt6cr_progress_dialog_set_minimum_duration(qt6cr_handle_t handle, int value);
bool qt6cr_progress_dialog_was_canceled(qt6cr_handle_t handle);
void qt6cr_progress_dialog_cancel(qt6cr_handle_t handle);
void qt6cr_progress_dialog_reset(qt6cr_handle_t handle);
void qt6cr_progress_dialog_on_canceled(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_qimage_create(int width, int height, int format);
qt6cr_handle_t qt6cr_qimage_create_from_file(const char *path);
qt6cr_handle_t qt6cr_qimage_create_from_raw_data(const unsigned char *data, int size, int width, int height, int bytes_per_line, int format);
void qt6cr_qimage_destroy(qt6cr_handle_t handle);
int qt6cr_qimage_width(qt6cr_handle_t handle);
int qt6cr_qimage_height(qt6cr_handle_t handle);
bool qt6cr_qimage_is_null(qt6cr_handle_t handle);
void qt6cr_qimage_fill(qt6cr_handle_t handle, qt6cr_color_t color);
bool qt6cr_qimage_load(qt6cr_handle_t handle, const char *path);
bool qt6cr_qimage_load_from_data(qt6cr_handle_t handle, const unsigned char *data, int size, const char *format);
bool qt6cr_qimage_save(qt6cr_handle_t handle, const char *path);
qt6cr_byte_array_t qt6cr_qimage_save_to_data(qt6cr_handle_t handle, const char *format);
bool qt6cr_qimage_save_to_buffer(qt6cr_handle_t handle, qt6cr_handle_t buffer, const char *format);
qt6cr_color_t qt6cr_qimage_pixel_color(qt6cr_handle_t handle, int x, int y);
void qt6cr_qimage_set_pixel_color(qt6cr_handle_t handle, int x, int y, qt6cr_color_t color);

qt6cr_handle_t qt6cr_qimage_reader_create(const char *file_name, const char *format);
void qt6cr_qimage_reader_destroy(qt6cr_handle_t handle);
char *qt6cr_qimage_reader_file_name(qt6cr_handle_t handle);
void qt6cr_qimage_reader_set_file_name(qt6cr_handle_t handle, const char *file_name);
char *qt6cr_qimage_reader_format(qt6cr_handle_t handle);
void qt6cr_qimage_reader_set_format(qt6cr_handle_t handle, const char *format);
qt6cr_size_t qt6cr_qimage_reader_size(qt6cr_handle_t handle);
bool qt6cr_qimage_reader_can_read(qt6cr_handle_t handle);
bool qt6cr_qimage_reader_auto_transform(qt6cr_handle_t handle);
void qt6cr_qimage_reader_set_auto_transform(qt6cr_handle_t handle, bool value);
char *qt6cr_qimage_reader_error_string(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_qimage_reader_read(qt6cr_handle_t handle);
bool qt6cr_qimage_reader_read_into(qt6cr_handle_t handle, qt6cr_handle_t image);

qt6cr_handle_t qt6cr_qpixmap_create(int width, int height);
qt6cr_handle_t qt6cr_qpixmap_create_from_file(const char *path);
void qt6cr_qpixmap_destroy(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_qpixmap_from_image(qt6cr_handle_t image);
qt6cr_handle_t qt6cr_qpixmap_to_image(qt6cr_handle_t handle);
int qt6cr_qpixmap_width(qt6cr_handle_t handle);
int qt6cr_qpixmap_height(qt6cr_handle_t handle);
bool qt6cr_qpixmap_is_null(qt6cr_handle_t handle);
void qt6cr_qpixmap_fill(qt6cr_handle_t handle, qt6cr_color_t color);
bool qt6cr_qpixmap_load(qt6cr_handle_t handle, const char *path);
bool qt6cr_qpixmap_load_from_data(qt6cr_handle_t handle, const unsigned char *data, int size, const char *format);
bool qt6cr_qpixmap_save(qt6cr_handle_t handle, const char *path);
qt6cr_byte_array_t qt6cr_qpixmap_save_to_data(qt6cr_handle_t handle, const char *format);

qt6cr_handle_t qt6cr_qicon_create(void);
qt6cr_handle_t qt6cr_qicon_create_from_file(const char *path);
void qt6cr_qicon_destroy(qt6cr_handle_t handle);
bool qt6cr_qicon_is_null(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_splash_screen_create(qt6cr_handle_t pixmap);
qt6cr_handle_t qt6cr_splash_screen_pixmap(qt6cr_handle_t handle);
void qt6cr_splash_screen_set_pixmap(qt6cr_handle_t handle, qt6cr_handle_t pixmap);
char *qt6cr_splash_screen_message(qt6cr_handle_t handle);
void qt6cr_splash_screen_show_message(qt6cr_handle_t handle, const char *message, qt6cr_color_t color);
void qt6cr_splash_screen_clear_message(qt6cr_handle_t handle);
void qt6cr_splash_screen_finish(qt6cr_handle_t handle, qt6cr_handle_t widget);

qt6cr_handle_t qt6cr_model_index_create(void);
void qt6cr_model_index_destroy(qt6cr_handle_t handle);
bool qt6cr_model_index_is_valid(qt6cr_handle_t handle);
int qt6cr_model_index_row(qt6cr_handle_t handle);
int qt6cr_model_index_column(qt6cr_handle_t handle);
uint64_t qt6cr_model_index_internal_id(qt6cr_handle_t handle);

int qt6cr_abstract_item_model_row_count(qt6cr_handle_t handle, qt6cr_handle_t parent_index);
int qt6cr_abstract_item_model_column_count(qt6cr_handle_t handle, qt6cr_handle_t parent_index);
qt6cr_handle_t qt6cr_abstract_item_model_index(qt6cr_handle_t handle, int row, int column, qt6cr_handle_t parent_index);
qt6cr_handle_t qt6cr_abstract_item_model_parent(qt6cr_handle_t handle, qt6cr_handle_t index);
qt6cr_variant_value_t qt6cr_abstract_item_model_data(qt6cr_handle_t handle, qt6cr_handle_t index, int role);
bool qt6cr_abstract_item_model_set_data(qt6cr_handle_t handle, qt6cr_handle_t index, qt6cr_variant_value_t value, int role);
qt6cr_variant_value_t qt6cr_abstract_item_model_header_data(qt6cr_handle_t handle, int section, int orientation, int role);
bool qt6cr_abstract_item_model_set_header_data(qt6cr_handle_t handle, int section, int orientation, qt6cr_variant_value_t value, int role);
int qt6cr_abstract_item_model_flags(qt6cr_handle_t handle, qt6cr_handle_t index);
int qt6cr_abstract_item_model_mime_type_count(qt6cr_handle_t handle);
char *qt6cr_abstract_item_model_mime_type(qt6cr_handle_t handle, int index);
qt6cr_handle_t qt6cr_abstract_item_model_mime_data_for_indexes(qt6cr_handle_t handle, qt6cr_handle_t *indexes, int count);
bool qt6cr_abstract_item_model_drop_mime_data(qt6cr_handle_t handle, qt6cr_handle_t mime_data, int action, int row, int column, qt6cr_handle_t parent_index);
int qt6cr_abstract_item_model_supported_drag_actions(qt6cr_handle_t handle);
int qt6cr_abstract_item_model_supported_drop_actions(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_abstract_list_model_create(qt6cr_handle_t parent);
void qt6cr_abstract_list_model_on_row_count(qt6cr_handle_t handle, qt6cr_model_count_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_column_count(qt6cr_handle_t handle, qt6cr_model_count_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_data(qt6cr_handle_t handle, qt6cr_model_data_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_set_data(qt6cr_handle_t handle, qt6cr_model_set_data_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_header_data(qt6cr_handle_t handle, qt6cr_model_header_data_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_flags(qt6cr_handle_t handle, qt6cr_model_flags_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_mime_type_count(qt6cr_handle_t handle, qt6cr_model_mime_type_count_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_mime_type(qt6cr_handle_t handle, qt6cr_indexed_string_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_mime_data(qt6cr_handle_t handle, qt6cr_model_mime_data_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_drop_mime_data(qt6cr_handle_t handle, qt6cr_model_drop_mime_data_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_supported_drag_actions(qt6cr_handle_t handle, qt6cr_model_actions_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_on_supported_drop_actions(qt6cr_handle_t handle, qt6cr_model_actions_callback_t callback, void *userdata);
void qt6cr_abstract_list_model_begin_reset_model(qt6cr_handle_t handle);
void qt6cr_abstract_list_model_end_reset_model(qt6cr_handle_t handle);
void qt6cr_abstract_list_model_begin_insert_rows(qt6cr_handle_t handle, int first, int last, qt6cr_handle_t parent_index);
void qt6cr_abstract_list_model_end_insert_rows(qt6cr_handle_t handle);
void qt6cr_abstract_list_model_begin_remove_rows(qt6cr_handle_t handle, int first, int last, qt6cr_handle_t parent_index);
void qt6cr_abstract_list_model_end_remove_rows(qt6cr_handle_t handle);
void qt6cr_abstract_list_model_data_changed(qt6cr_handle_t handle, qt6cr_handle_t top_left, qt6cr_handle_t bottom_right);

qt6cr_handle_t qt6cr_abstract_tree_model_create(qt6cr_handle_t parent);
void qt6cr_abstract_tree_model_on_row_count(qt6cr_handle_t handle, qt6cr_model_count_with_parent_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_column_count(qt6cr_handle_t handle, qt6cr_model_count_with_parent_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_index_id(qt6cr_handle_t handle, qt6cr_model_index_id_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_parent(qt6cr_handle_t handle, qt6cr_model_parent_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_data(qt6cr_handle_t handle, qt6cr_model_data_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_set_data(qt6cr_handle_t handle, qt6cr_model_set_data_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_header_data(qt6cr_handle_t handle, qt6cr_model_header_data_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_flags(qt6cr_handle_t handle, qt6cr_model_flags_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_mime_type_count(qt6cr_handle_t handle, qt6cr_model_mime_type_count_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_mime_type(qt6cr_handle_t handle, qt6cr_indexed_string_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_mime_data(qt6cr_handle_t handle, qt6cr_model_mime_data_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_drop_mime_data(qt6cr_handle_t handle, qt6cr_model_drop_mime_data_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_supported_drag_actions(qt6cr_handle_t handle, qt6cr_model_actions_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_on_supported_drop_actions(qt6cr_handle_t handle, qt6cr_model_actions_callback_t callback, void *userdata);
void qt6cr_abstract_tree_model_begin_reset_model(qt6cr_handle_t handle);
void qt6cr_abstract_tree_model_end_reset_model(qt6cr_handle_t handle);
void qt6cr_abstract_tree_model_begin_insert_rows(qt6cr_handle_t handle, int first, int last, qt6cr_handle_t parent_index);
void qt6cr_abstract_tree_model_end_insert_rows(qt6cr_handle_t handle);
void qt6cr_abstract_tree_model_begin_remove_rows(qt6cr_handle_t handle, int first, int last, qt6cr_handle_t parent_index);
void qt6cr_abstract_tree_model_end_remove_rows(qt6cr_handle_t handle);
void qt6cr_abstract_tree_model_data_changed(qt6cr_handle_t handle, qt6cr_handle_t top_left, qt6cr_handle_t bottom_right);

qt6cr_handle_t qt6cr_item_selection_model_create(qt6cr_handle_t model, qt6cr_handle_t parent);
qt6cr_handle_t qt6cr_item_selection_model_model(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_item_selection_model_current_index(qt6cr_handle_t handle);
void qt6cr_item_selection_model_on_current_index_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_standard_item_create(const char *text);
void qt6cr_standard_item_destroy(qt6cr_handle_t handle);
char *qt6cr_standard_item_text(qt6cr_handle_t handle);
void qt6cr_standard_item_set_text(qt6cr_handle_t handle, const char *text);
qt6cr_variant_value_t qt6cr_standard_item_data(qt6cr_handle_t handle, int role);
bool qt6cr_standard_item_set_data(qt6cr_handle_t handle, qt6cr_variant_value_t value, int role);
void qt6cr_standard_item_append_row(qt6cr_handle_t handle, qt6cr_handle_t item);
void qt6cr_standard_item_set_child(qt6cr_handle_t handle, int row, int column, qt6cr_handle_t item);
qt6cr_handle_t qt6cr_standard_item_child(qt6cr_handle_t handle, int row, int column);
int qt6cr_standard_item_row_count(qt6cr_handle_t handle);
int qt6cr_standard_item_column_count(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_standard_item_model_create(qt6cr_handle_t parent);
void qt6cr_standard_item_model_clear(qt6cr_handle_t handle);
int qt6cr_standard_item_model_row_count(qt6cr_handle_t handle, qt6cr_handle_t parent_index);
int qt6cr_standard_item_model_column_count(qt6cr_handle_t handle, qt6cr_handle_t parent_index);
void qt6cr_standard_item_model_append_row(qt6cr_handle_t handle, qt6cr_handle_t item);
void qt6cr_standard_item_model_set_item(qt6cr_handle_t handle, int row, int column, qt6cr_handle_t item);
qt6cr_handle_t qt6cr_standard_item_model_item(qt6cr_handle_t handle, int row, int column);
void qt6cr_standard_item_model_set_horizontal_header_label(qt6cr_handle_t handle, int column, const char *text);
char *qt6cr_standard_item_model_horizontal_header_label(qt6cr_handle_t handle, int column);
qt6cr_handle_t qt6cr_standard_item_model_index(qt6cr_handle_t handle, int row, int column, qt6cr_handle_t parent_index);
qt6cr_handle_t qt6cr_standard_item_model_item_from_index(qt6cr_handle_t handle, qt6cr_handle_t index);
qt6cr_handle_t qt6cr_standard_item_model_index_from_item(qt6cr_handle_t handle, qt6cr_handle_t item);

qt6cr_handle_t qt6cr_sort_filter_proxy_model_create(qt6cr_handle_t parent);
void qt6cr_sort_filter_proxy_model_set_source_model(qt6cr_handle_t handle, qt6cr_handle_t model);
qt6cr_handle_t qt6cr_sort_filter_proxy_model_source_model(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_sort_filter_proxy_model_map_to_source(qt6cr_handle_t handle, qt6cr_handle_t proxy_index);
qt6cr_handle_t qt6cr_sort_filter_proxy_model_map_from_source(qt6cr_handle_t handle, qt6cr_handle_t source_index);
void qt6cr_sort_filter_proxy_model_sort(qt6cr_handle_t handle, int column, int order);
void qt6cr_sort_filter_proxy_model_set_filter_fixed_string(qt6cr_handle_t handle, const char *value);
void qt6cr_sort_filter_proxy_model_set_filter_wildcard(qt6cr_handle_t handle, const char *value);
void qt6cr_sort_filter_proxy_model_set_filter_key_column(qt6cr_handle_t handle, int column);
int qt6cr_sort_filter_proxy_model_filter_key_column(qt6cr_handle_t handle);
void qt6cr_sort_filter_proxy_model_set_filter_role(qt6cr_handle_t handle, int role);
int qt6cr_sort_filter_proxy_model_filter_role(qt6cr_handle_t handle);
void qt6cr_sort_filter_proxy_model_set_sort_role(qt6cr_handle_t handle, int role);
int qt6cr_sort_filter_proxy_model_sort_role(qt6cr_handle_t handle);
void qt6cr_sort_filter_proxy_model_set_filter_case_sensitivity(qt6cr_handle_t handle, int sensitivity);
int qt6cr_sort_filter_proxy_model_filter_case_sensitivity(qt6cr_handle_t handle);
void qt6cr_sort_filter_proxy_model_set_dynamic_sort_filter(qt6cr_handle_t handle, bool value);
bool qt6cr_sort_filter_proxy_model_dynamic_sort_filter(qt6cr_handle_t handle);
void qt6cr_sort_filter_proxy_model_set_recursive_filtering_enabled(qt6cr_handle_t handle, bool value);
bool qt6cr_sort_filter_proxy_model_recursive_filtering_enabled(qt6cr_handle_t handle);
void qt6cr_sort_filter_proxy_model_invalidate(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_styled_item_delegate_create(qt6cr_handle_t parent);
void qt6cr_styled_item_delegate_on_display_text(qt6cr_handle_t handle, qt6cr_string_transform_callback_t callback, void *userdata);
void qt6cr_styled_item_delegate_on_create_editor(qt6cr_handle_t handle, qt6cr_delegate_create_editor_callback_t callback, void *userdata);
void qt6cr_styled_item_delegate_on_set_editor_data(qt6cr_handle_t handle, qt6cr_delegate_set_editor_data_callback_t callback, void *userdata);
void qt6cr_styled_item_delegate_on_set_model_data(qt6cr_handle_t handle, qt6cr_delegate_set_model_data_callback_t callback, void *userdata);
char *qt6cr_styled_item_delegate_display_text(qt6cr_handle_t handle, qt6cr_variant_value_t value);
qt6cr_handle_t qt6cr_styled_item_delegate_create_editor(qt6cr_handle_t handle, qt6cr_handle_t parent, qt6cr_handle_t index);
void qt6cr_styled_item_delegate_set_editor_data(qt6cr_handle_t handle, qt6cr_handle_t editor, qt6cr_handle_t index);
void qt6cr_styled_item_delegate_set_model_data(qt6cr_handle_t handle, qt6cr_handle_t editor, qt6cr_handle_t model, qt6cr_handle_t index);

qt6cr_handle_t qt6cr_list_view_create(qt6cr_handle_t parent);
void qt6cr_list_view_set_model(qt6cr_handle_t handle, qt6cr_handle_t model);
void qt6cr_list_view_set_item_delegate(qt6cr_handle_t handle, qt6cr_handle_t delegate);
qt6cr_handle_t qt6cr_list_view_selection_model(qt6cr_handle_t handle);
void qt6cr_list_view_set_selection_model(qt6cr_handle_t handle, qt6cr_handle_t selection_model);
qt6cr_handle_t qt6cr_list_view_current_index(qt6cr_handle_t handle);
void qt6cr_list_view_set_current_index(qt6cr_handle_t handle, qt6cr_handle_t index);
int qt6cr_list_view_selection_mode(qt6cr_handle_t handle);
void qt6cr_list_view_set_selection_mode(qt6cr_handle_t handle, int mode);
bool qt6cr_list_view_alternating_row_colors(qt6cr_handle_t handle);
void qt6cr_list_view_set_alternating_row_colors(qt6cr_handle_t handle, bool value);
bool qt6cr_list_view_drag_enabled(qt6cr_handle_t handle);
void qt6cr_list_view_set_drag_enabled(qt6cr_handle_t handle, bool value);
int qt6cr_list_view_drag_drop_mode(qt6cr_handle_t handle);
void qt6cr_list_view_set_drag_drop_mode(qt6cr_handle_t handle, int mode);
int qt6cr_list_view_default_drop_action(qt6cr_handle_t handle);
void qt6cr_list_view_set_default_drop_action(qt6cr_handle_t handle, int action);
bool qt6cr_list_view_drop_indicator_shown(qt6cr_handle_t handle);
void qt6cr_list_view_set_drop_indicator_shown(qt6cr_handle_t handle, bool value);
void qt6cr_list_view_on_current_index_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_tree_view_create(qt6cr_handle_t parent);
void qt6cr_tree_view_set_model(qt6cr_handle_t handle, qt6cr_handle_t model);
void qt6cr_tree_view_set_item_delegate(qt6cr_handle_t handle, qt6cr_handle_t delegate);
qt6cr_handle_t qt6cr_tree_view_selection_model(qt6cr_handle_t handle);
void qt6cr_tree_view_set_selection_model(qt6cr_handle_t handle, qt6cr_handle_t selection_model);
qt6cr_handle_t qt6cr_tree_view_current_index(qt6cr_handle_t handle);
void qt6cr_tree_view_set_current_index(qt6cr_handle_t handle, qt6cr_handle_t index);
int qt6cr_tree_view_selection_mode(qt6cr_handle_t handle);
void qt6cr_tree_view_set_selection_mode(qt6cr_handle_t handle, int mode);
bool qt6cr_tree_view_alternating_row_colors(qt6cr_handle_t handle);
void qt6cr_tree_view_set_alternating_row_colors(qt6cr_handle_t handle, bool value);
bool qt6cr_tree_view_header_hidden(qt6cr_handle_t handle);
void qt6cr_tree_view_set_header_hidden(qt6cr_handle_t handle, bool value);
bool qt6cr_tree_view_root_is_decorated(qt6cr_handle_t handle);
void qt6cr_tree_view_set_root_is_decorated(qt6cr_handle_t handle, bool value);
bool qt6cr_tree_view_uniform_row_heights(qt6cr_handle_t handle);
void qt6cr_tree_view_set_uniform_row_heights(qt6cr_handle_t handle, bool value);
int qt6cr_tree_view_indentation(qt6cr_handle_t handle);
void qt6cr_tree_view_set_indentation(qt6cr_handle_t handle, int value);
bool qt6cr_tree_view_drag_enabled(qt6cr_handle_t handle);
void qt6cr_tree_view_set_drag_enabled(qt6cr_handle_t handle, bool value);
int qt6cr_tree_view_drag_drop_mode(qt6cr_handle_t handle);
void qt6cr_tree_view_set_drag_drop_mode(qt6cr_handle_t handle, int mode);
int qt6cr_tree_view_default_drop_action(qt6cr_handle_t handle);
void qt6cr_tree_view_set_default_drop_action(qt6cr_handle_t handle, int action);
bool qt6cr_tree_view_drop_indicator_shown(qt6cr_handle_t handle);
void qt6cr_tree_view_set_drop_indicator_shown(qt6cr_handle_t handle, bool value);
void qt6cr_tree_view_expand_all(qt6cr_handle_t handle);
void qt6cr_tree_view_collapse_all(qt6cr_handle_t handle);
void qt6cr_tree_view_on_current_index_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_qsvg_generator_create(void);
void qt6cr_qsvg_generator_destroy(qt6cr_handle_t handle);
char *qt6cr_qsvg_generator_file_name(qt6cr_handle_t handle);
void qt6cr_qsvg_generator_set_file_name(qt6cr_handle_t handle, const char *file_name);
qt6cr_size_t qt6cr_qsvg_generator_size(qt6cr_handle_t handle);
void qt6cr_qsvg_generator_set_size(qt6cr_handle_t handle, qt6cr_size_t size);
qt6cr_rectf_t qt6cr_qsvg_generator_view_box(qt6cr_handle_t handle);
void qt6cr_qsvg_generator_set_view_box(qt6cr_handle_t handle, qt6cr_rectf_t rect);
char *qt6cr_qsvg_generator_title(qt6cr_handle_t handle);
void qt6cr_qsvg_generator_set_title(qt6cr_handle_t handle, const char *title);
char *qt6cr_qsvg_generator_description(qt6cr_handle_t handle);
void qt6cr_qsvg_generator_set_description(qt6cr_handle_t handle, const char *description);
int qt6cr_qsvg_generator_resolution(qt6cr_handle_t handle);
void qt6cr_qsvg_generator_set_resolution(qt6cr_handle_t handle, int resolution);

qt6cr_handle_t qt6cr_qsvg_renderer_create(const char *file_name);
qt6cr_handle_t qt6cr_qsvg_renderer_create_from_data(const unsigned char *data, int size);
void qt6cr_qsvg_renderer_destroy(qt6cr_handle_t handle);
bool qt6cr_qsvg_renderer_is_valid(qt6cr_handle_t handle);
bool qt6cr_qsvg_renderer_load(qt6cr_handle_t handle, const char *file_name);
bool qt6cr_qsvg_renderer_load_data(qt6cr_handle_t handle, const unsigned char *data, int size);
qt6cr_size_t qt6cr_qsvg_renderer_default_size(qt6cr_handle_t handle);
qt6cr_rectf_t qt6cr_qsvg_renderer_view_box(qt6cr_handle_t handle);
void qt6cr_qsvg_renderer_set_view_box(qt6cr_handle_t handle, qt6cr_rectf_t rect);
bool qt6cr_qsvg_renderer_element_exists(qt6cr_handle_t handle, const char *element_id);
qt6cr_rectf_t qt6cr_qsvg_renderer_bounds_on_element(qt6cr_handle_t handle, const char *element_id);
void qt6cr_qsvg_renderer_render(qt6cr_handle_t handle, qt6cr_handle_t painter);
void qt6cr_qsvg_renderer_render_with_bounds(qt6cr_handle_t handle, qt6cr_handle_t painter, qt6cr_rectf_t bounds);
void qt6cr_qsvg_renderer_render_element(qt6cr_handle_t handle, qt6cr_handle_t painter, const char *element_id);
void qt6cr_qsvg_renderer_render_element_with_bounds(qt6cr_handle_t handle, qt6cr_handle_t painter, const char *element_id, qt6cr_rectf_t bounds);

qt6cr_handle_t qt6cr_qsvg_widget_create(qt6cr_handle_t parent, const char *file_name);
void qt6cr_qsvg_widget_load(qt6cr_handle_t handle, const char *file_name);
void qt6cr_qsvg_widget_load_data(qt6cr_handle_t handle, const unsigned char *data, int size);
qt6cr_handle_t qt6cr_qsvg_widget_renderer(qt6cr_handle_t handle);
qt6cr_size_t qt6cr_qsvg_widget_size_hint(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_qpdf_writer_create(const char *file_name);
void qt6cr_qpdf_writer_destroy(qt6cr_handle_t handle);
void qt6cr_qpdf_writer_set_title(qt6cr_handle_t handle, const char *title);
void qt6cr_qpdf_writer_set_creator(qt6cr_handle_t handle, const char *creator);
int qt6cr_qpdf_writer_resolution(qt6cr_handle_t handle);
void qt6cr_qpdf_writer_set_resolution(qt6cr_handle_t handle, int resolution);
void qt6cr_qpdf_writer_set_page_size_points(qt6cr_handle_t handle, int width, int height);
void qt6cr_qpdf_writer_set_page_size_millimeters(qt6cr_handle_t handle, double width, double height, int orientation);
void qt6cr_qpdf_writer_set_page_layout(qt6cr_handle_t handle, double width, double height, int unit, int orientation, double left, double top, double right, double bottom);
qt6cr_rectf_t qt6cr_qpdf_writer_page_layout_full_rect_points(qt6cr_handle_t handle);
qt6cr_rectf_t qt6cr_qpdf_writer_page_layout_paint_rect_points(qt6cr_handle_t handle);
bool qt6cr_qpdf_writer_new_page(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_qbyte_array_create(void);
qt6cr_handle_t qt6cr_qbyte_array_create_from_data(const unsigned char *data, int size);
void qt6cr_qbyte_array_destroy(qt6cr_handle_t handle);
int qt6cr_qbyte_array_size(qt6cr_handle_t handle);
qt6cr_byte_array_t qt6cr_qbyte_array_data(qt6cr_handle_t handle);
void qt6cr_qbyte_array_clear(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_qbuffer_create(qt6cr_handle_t byte_array);
void qt6cr_qbuffer_destroy(qt6cr_handle_t handle);
bool qt6cr_qbuffer_open(qt6cr_handle_t handle, int open_mode);
void qt6cr_qbuffer_close(qt6cr_handle_t handle);
bool qt6cr_qbuffer_is_open(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_qbuffer_data(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_qpen_create(qt6cr_color_t color, double width);
void qt6cr_qpen_destroy(qt6cr_handle_t handle);
qt6cr_color_t qt6cr_qpen_color(qt6cr_handle_t handle);
void qt6cr_qpen_set_color(qt6cr_handle_t handle, qt6cr_color_t color);
double qt6cr_qpen_width(qt6cr_handle_t handle);
void qt6cr_qpen_set_width(qt6cr_handle_t handle, double width);
int qt6cr_qpen_style(qt6cr_handle_t handle);
void qt6cr_qpen_set_style(qt6cr_handle_t handle, int style);
int qt6cr_qpen_cap_style(qt6cr_handle_t handle);
void qt6cr_qpen_set_cap_style(qt6cr_handle_t handle, int style);
int qt6cr_qpen_join_style(qt6cr_handle_t handle);
void qt6cr_qpen_set_join_style(qt6cr_handle_t handle, int style);
double qt6cr_qpen_dash_offset(qt6cr_handle_t handle);
void qt6cr_qpen_set_dash_offset(qt6cr_handle_t handle, double offset);
void qt6cr_qpen_set_dash_pattern(qt6cr_handle_t handle, const double *values, int size);

qt6cr_handle_t qt6cr_qlinear_gradient_create(double x1, double y1, double x2, double y2);
void qt6cr_qlinear_gradient_destroy(qt6cr_handle_t handle);
void qt6cr_qlinear_gradient_set_color_at(qt6cr_handle_t handle, double position, qt6cr_color_t color);
qt6cr_pointf_t qt6cr_qlinear_gradient_start(qt6cr_handle_t handle);
qt6cr_pointf_t qt6cr_qlinear_gradient_final_stop(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_qradial_gradient_create(double center_x, double center_y, double radius);
void qt6cr_qradial_gradient_destroy(qt6cr_handle_t handle);
void qt6cr_qradial_gradient_set_color_at(qt6cr_handle_t handle, double position, qt6cr_color_t color);
qt6cr_pointf_t qt6cr_qradial_gradient_center(qt6cr_handle_t handle);
double qt6cr_qradial_gradient_radius(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_qbrush_create(qt6cr_color_t color);
qt6cr_handle_t qt6cr_qbrush_create_from_pixmap(qt6cr_handle_t pixmap);
qt6cr_handle_t qt6cr_qbrush_create_from_image(qt6cr_handle_t image);
qt6cr_handle_t qt6cr_qbrush_create_from_linear_gradient(qt6cr_handle_t gradient);
qt6cr_handle_t qt6cr_qbrush_create_from_radial_gradient(qt6cr_handle_t gradient);
void qt6cr_qbrush_destroy(qt6cr_handle_t handle);
qt6cr_color_t qt6cr_qbrush_color(qt6cr_handle_t handle);
void qt6cr_qbrush_set_color(qt6cr_handle_t handle, qt6cr_color_t color);
qt6cr_handle_t qt6cr_qbrush_transform(qt6cr_handle_t handle);
void qt6cr_qbrush_set_transform(qt6cr_handle_t handle, qt6cr_handle_t transform);

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

qt6cr_handle_t qt6cr_qfont_metrics_create(qt6cr_handle_t font);
void qt6cr_qfont_metrics_destroy(qt6cr_handle_t handle);
int qt6cr_qfont_metrics_height(qt6cr_handle_t handle);
int qt6cr_qfont_metrics_ascent(qt6cr_handle_t handle);
int qt6cr_qfont_metrics_descent(qt6cr_handle_t handle);
int qt6cr_qfont_metrics_horizontal_advance(qt6cr_handle_t handle, const char *text);
qt6cr_rectf_t qt6cr_qfont_metrics_bounding_rect(qt6cr_handle_t handle, const char *text);

qt6cr_handle_t qt6cr_qfont_metrics_f_create(qt6cr_handle_t font);
void qt6cr_qfont_metrics_f_destroy(qt6cr_handle_t handle);
double qt6cr_qfont_metrics_f_height(qt6cr_handle_t handle);
double qt6cr_qfont_metrics_f_ascent(qt6cr_handle_t handle);
double qt6cr_qfont_metrics_f_descent(qt6cr_handle_t handle);
double qt6cr_qfont_metrics_f_horizontal_advance(qt6cr_handle_t handle, const char *text);
qt6cr_rectf_t qt6cr_qfont_metrics_f_bounding_rect(qt6cr_handle_t handle, const char *text);

qt6cr_handle_t qt6cr_qtransform_create(void);
void qt6cr_qtransform_destroy(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_qtransform_copy(qt6cr_handle_t handle);
void qt6cr_qtransform_reset(qt6cr_handle_t handle);
void qt6cr_qtransform_translate(qt6cr_handle_t handle, double dx, double dy);
void qt6cr_qtransform_scale(qt6cr_handle_t handle, double sx, double sy);
void qt6cr_qtransform_rotate(qt6cr_handle_t handle, double angle);
qt6cr_pointf_t qt6cr_qtransform_map_point(qt6cr_handle_t handle, qt6cr_pointf_t point);
qt6cr_rectf_t qt6cr_qtransform_map_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect);
qt6cr_handle_t qt6cr_qtransform_map_path(qt6cr_handle_t handle, qt6cr_handle_t path);

qt6cr_handle_t qt6cr_qpolygonf_create(void);
void qt6cr_qpolygonf_destroy(qt6cr_handle_t handle);
void qt6cr_qpolygonf_append(qt6cr_handle_t handle, qt6cr_pointf_t point);
int qt6cr_qpolygonf_size(qt6cr_handle_t handle);
qt6cr_pointf_t qt6cr_qpolygonf_at(qt6cr_handle_t handle, int index);
qt6cr_rectf_t qt6cr_qpolygonf_bounding_rect(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_qpainter_path_create(void);
void qt6cr_qpainter_path_destroy(qt6cr_handle_t handle);
void qt6cr_qpainter_path_move_to(qt6cr_handle_t handle, qt6cr_pointf_t point);
void qt6cr_qpainter_path_line_to(qt6cr_handle_t handle, qt6cr_pointf_t point);
void qt6cr_qpainter_path_quad_to(qt6cr_handle_t handle, qt6cr_pointf_t control_point, qt6cr_pointf_t end_point);
void qt6cr_qpainter_path_cubic_to(qt6cr_handle_t handle, qt6cr_pointf_t control_point1, qt6cr_pointf_t control_point2, qt6cr_pointf_t end_point);
void qt6cr_qpainter_path_add_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect);
void qt6cr_qpainter_path_add_ellipse(qt6cr_handle_t handle, qt6cr_rectf_t rect);
void qt6cr_qpainter_path_add_polygon(qt6cr_handle_t handle, qt6cr_handle_t polygon);
void qt6cr_qpainter_path_close_subpath(qt6cr_handle_t handle);
qt6cr_rectf_t qt6cr_qpainter_path_bounding_rect(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_qpainter_path_transformed(qt6cr_handle_t handle, qt6cr_handle_t transform);
bool qt6cr_qpainter_path_contains(qt6cr_handle_t handle, qt6cr_pointf_t point);
bool qt6cr_qpainter_path_is_empty(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_qpainter_path_stroker_create(void);
void qt6cr_qpainter_path_stroker_destroy(qt6cr_handle_t handle);
double qt6cr_qpainter_path_stroker_width(qt6cr_handle_t handle);
void qt6cr_qpainter_path_stroker_set_width(qt6cr_handle_t handle, double width);
qt6cr_handle_t qt6cr_qpainter_path_stroker_create_stroke(qt6cr_handle_t handle, qt6cr_handle_t path);

qt6cr_handle_t qt6cr_qpainter_create_for_image(qt6cr_handle_t image);
qt6cr_handle_t qt6cr_qpainter_create_for_pixmap(qt6cr_handle_t pixmap);
qt6cr_handle_t qt6cr_qpainter_create_for_svg_generator(qt6cr_handle_t svg_generator);
qt6cr_handle_t qt6cr_qpainter_create_for_pdf_writer(qt6cr_handle_t pdf_writer);
void qt6cr_qpainter_destroy(qt6cr_handle_t handle);
bool qt6cr_qpainter_is_active(qt6cr_handle_t handle);
void qt6cr_qpainter_set_antialiasing(qt6cr_handle_t handle, bool value);
void qt6cr_qpainter_set_smooth_pixmap_transform(qt6cr_handle_t handle, bool value);
void qt6cr_qpainter_set_pen_color(qt6cr_handle_t handle, qt6cr_color_t color);
void qt6cr_qpainter_set_pen(qt6cr_handle_t handle, qt6cr_handle_t pen);
void qt6cr_qpainter_set_brush_color(qt6cr_handle_t handle, qt6cr_color_t color);
void qt6cr_qpainter_set_brush(qt6cr_handle_t handle, qt6cr_handle_t brush);
void qt6cr_qpainter_set_font(qt6cr_handle_t handle, qt6cr_handle_t font);
void qt6cr_qpainter_set_transform(qt6cr_handle_t handle, qt6cr_handle_t transform);
void qt6cr_qpainter_reset_transform(qt6cr_handle_t handle);
void qt6cr_qpainter_translate(qt6cr_handle_t handle, double dx, double dy);
void qt6cr_qpainter_scale(qt6cr_handle_t handle, double sx, double sy);
void qt6cr_qpainter_save(qt6cr_handle_t handle);
void qt6cr_qpainter_restore(qt6cr_handle_t handle);
double qt6cr_qpainter_opacity(qt6cr_handle_t handle);
void qt6cr_qpainter_set_opacity(qt6cr_handle_t handle, double value);
int qt6cr_qpainter_composition_mode(qt6cr_handle_t handle);
void qt6cr_qpainter_set_composition_mode(qt6cr_handle_t handle, int mode);
void qt6cr_qpainter_set_clipping(qt6cr_handle_t handle, bool value);
void qt6cr_qpainter_set_clip_path(qt6cr_handle_t handle, qt6cr_handle_t path);
void qt6cr_qpainter_draw_line(qt6cr_handle_t handle, qt6cr_pointf_t from_point, qt6cr_pointf_t to_point);
void qt6cr_qpainter_draw_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect);
void qt6cr_qpainter_fill_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect, qt6cr_color_t color);
void qt6cr_qpainter_draw_ellipse(qt6cr_handle_t handle, qt6cr_rectf_t rect);
void qt6cr_qpainter_draw_ellipse_center(qt6cr_handle_t handle, qt6cr_pointf_t center, double rx, double ry);
void qt6cr_qpainter_draw_path(qt6cr_handle_t handle, qt6cr_handle_t path);
void qt6cr_qpainter_draw_polygon(qt6cr_handle_t handle, qt6cr_handle_t polygon);
void qt6cr_qpainter_draw_image(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_handle_t image);
void qt6cr_qpainter_draw_image_xy(qt6cr_handle_t handle, double x, double y, qt6cr_handle_t image);
void qt6cr_qpainter_draw_image_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect, qt6cr_handle_t image);
void qt6cr_qpainter_draw_pixmap(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_handle_t pixmap);
void qt6cr_qpainter_draw_pixmap_xy(qt6cr_handle_t handle, double x, double y, qt6cr_handle_t pixmap);
void qt6cr_qpainter_draw_point(qt6cr_handle_t handle, qt6cr_pointf_t point);
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
void qt6cr_input_dialog_set_combo_box_items(qt6cr_handle_t handle, const char *const *items, int count);
int qt6cr_input_dialog_combo_box_item_count(qt6cr_handle_t handle);
char *qt6cr_input_dialog_combo_box_item_text(qt6cr_handle_t handle, int index);
void qt6cr_input_dialog_set_combo_box_editable(qt6cr_handle_t handle, bool editable);
bool qt6cr_input_dialog_combo_box_editable(qt6cr_handle_t handle);
char *qt6cr_input_dialog_get_item(qt6cr_handle_t parent, const char *title, const char *label, const char *const *items, int count, int current, bool editable);

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
void qt6cr_event_widget_on_drag_enter(qt6cr_handle_t handle, qt6cr_drop_event_callback_t callback, void *userdata);
void qt6cr_event_widget_on_drag_move(qt6cr_handle_t handle, qt6cr_drop_event_callback_t callback, void *userdata);
void qt6cr_event_widget_on_drop(qt6cr_handle_t handle, qt6cr_drop_event_callback_t callback, void *userdata);
void qt6cr_event_widget_repaint(qt6cr_handle_t handle);
void qt6cr_event_widget_send_mouse_press(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers);
void qt6cr_event_widget_send_mouse_move(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers);
void qt6cr_event_widget_send_mouse_release(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers);
void qt6cr_event_widget_send_wheel(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_pointf_t pixel_delta, qt6cr_pointf_t angle_delta, int buttons, int modifiers);
void qt6cr_event_widget_send_key_press(qt6cr_handle_t handle, int key, int modifiers, bool auto_repeat, int count);
void qt6cr_event_widget_send_drag_enter_text(qt6cr_handle_t handle, qt6cr_pointf_t position, const char *text, int buttons, int modifiers);
void qt6cr_event_widget_send_drag_move_text(qt6cr_handle_t handle, qt6cr_pointf_t position, const char *text, int buttons, int modifiers);
void qt6cr_event_widget_send_drop_text(qt6cr_handle_t handle, qt6cr_pointf_t position, const char *text, int buttons, int modifiers);

qt6cr_pointf_t qt6cr_drop_event_position(qt6cr_handle_t handle);
int qt6cr_drop_event_buttons(qt6cr_handle_t handle);
int qt6cr_drop_event_modifiers(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_drop_event_mime_data(qt6cr_handle_t handle);
void qt6cr_drop_event_accept(qt6cr_handle_t handle);
void qt6cr_drop_event_accept_proposed_action(qt6cr_handle_t handle);
void qt6cr_drop_event_ignore(qt6cr_handle_t handle);
bool qt6cr_drop_event_is_accepted(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_label_create(qt6cr_handle_t parent, const char *text);
void qt6cr_label_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_label_text(qt6cr_handle_t handle);

char *qt6cr_abstract_button_text(qt6cr_handle_t handle);
void qt6cr_abstract_button_set_text(qt6cr_handle_t handle, const char *text);
bool qt6cr_abstract_button_is_checkable(qt6cr_handle_t handle);
void qt6cr_abstract_button_set_checkable(qt6cr_handle_t handle, bool value);
bool qt6cr_abstract_button_is_checked(qt6cr_handle_t handle);
void qt6cr_abstract_button_set_checked(qt6cr_handle_t handle, bool value);
void qt6cr_abstract_button_on_clicked(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);
void qt6cr_abstract_button_on_toggled(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata);
void qt6cr_abstract_button_click(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_abstract_button_icon(qt6cr_handle_t handle);
void qt6cr_abstract_button_set_icon(qt6cr_handle_t handle, qt6cr_handle_t icon);
qt6cr_size_t qt6cr_abstract_button_icon_size(qt6cr_handle_t handle);
void qt6cr_abstract_button_set_icon_size(qt6cr_handle_t handle, qt6cr_size_t size);

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

qt6cr_handle_t qt6cr_radio_button_create(qt6cr_handle_t parent, const char *text);
void qt6cr_radio_button_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_radio_button_text(qt6cr_handle_t handle);
void qt6cr_radio_button_set_checked(qt6cr_handle_t handle, bool value);
bool qt6cr_radio_button_is_checked(qt6cr_handle_t handle);
void qt6cr_radio_button_on_toggled(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_tool_button_create(qt6cr_handle_t parent);
int qt6cr_tool_button_style(qt6cr_handle_t handle);
void qt6cr_tool_button_set_style(qt6cr_handle_t handle, int style);

qt6cr_handle_t qt6cr_combo_box_create(qt6cr_handle_t parent);
void qt6cr_combo_box_add_item(qt6cr_handle_t handle, const char *text);
int qt6cr_combo_box_count(qt6cr_handle_t handle);
int qt6cr_combo_box_current_index(qt6cr_handle_t handle);
void qt6cr_combo_box_set_current_index(qt6cr_handle_t handle, int index);
char *qt6cr_combo_box_current_text(qt6cr_handle_t handle);
void qt6cr_combo_box_on_current_index_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_font_combo_box_create(qt6cr_handle_t parent);
qt6cr_handle_t qt6cr_font_combo_box_current_font(qt6cr_handle_t handle);
void qt6cr_font_combo_box_set_current_font(qt6cr_handle_t handle, qt6cr_handle_t font);
void qt6cr_font_combo_box_on_current_font_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_list_widget_item_create(const char *text);
qt6cr_handle_t qt6cr_list_widget_item_create_with_icon(qt6cr_handle_t icon, const char *text);
void qt6cr_list_widget_item_destroy(qt6cr_handle_t handle);
void qt6cr_list_widget_item_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_list_widget_item_text(qt6cr_handle_t handle);
int qt6cr_list_widget_item_flags(qt6cr_handle_t handle);
void qt6cr_list_widget_item_set_flags(qt6cr_handle_t handle, int flags);
int qt6cr_list_widget_item_check_state(qt6cr_handle_t handle);
void qt6cr_list_widget_item_set_check_state(qt6cr_handle_t handle, int state);
qt6cr_variant_value_t qt6cr_list_widget_item_data(qt6cr_handle_t handle, int role);
void qt6cr_list_widget_item_set_data(qt6cr_handle_t handle, int role, qt6cr_variant_value_t value);
qt6cr_color_t qt6cr_list_widget_item_foreground(qt6cr_handle_t handle);
void qt6cr_list_widget_item_set_foreground(qt6cr_handle_t handle, qt6cr_color_t color);

qt6cr_handle_t qt6cr_list_widget_create(qt6cr_handle_t parent);
void qt6cr_list_widget_add_item(qt6cr_handle_t handle, qt6cr_handle_t item);
qt6cr_handle_t qt6cr_list_widget_add_item_text(qt6cr_handle_t handle, const char *text);
int qt6cr_list_widget_count(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_list_widget_item(qt6cr_handle_t handle, int index);
char *qt6cr_list_widget_item_text_at(qt6cr_handle_t handle, int index);
int qt6cr_list_widget_current_row(qt6cr_handle_t handle);
void qt6cr_list_widget_set_current_row(qt6cr_handle_t handle, int row);
qt6cr_handle_t qt6cr_list_widget_current_item(qt6cr_handle_t handle);
char *qt6cr_list_widget_current_text(qt6cr_handle_t handle);
void qt6cr_list_widget_clear(qt6cr_handle_t handle);
int qt6cr_list_widget_spacing(qt6cr_handle_t handle);
void qt6cr_list_widget_set_spacing(qt6cr_handle_t handle, int value);
int qt6cr_list_widget_drag_drop_mode(qt6cr_handle_t handle);
void qt6cr_list_widget_set_drag_drop_mode(qt6cr_handle_t handle, int mode);
int qt6cr_list_widget_selection_mode(qt6cr_handle_t handle);
void qt6cr_list_widget_set_selection_mode(qt6cr_handle_t handle, int mode);
int qt6cr_list_widget_default_drop_action(qt6cr_handle_t handle);
void qt6cr_list_widget_set_default_drop_action(qt6cr_handle_t handle, int action);
bool qt6cr_list_widget_move_item(qt6cr_handle_t handle, int from, int to);
void qt6cr_list_widget_emit_item_double_clicked(qt6cr_handle_t handle, int index);
void qt6cr_list_widget_on_current_row_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata);
void qt6cr_list_widget_on_item_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata);
void qt6cr_list_widget_on_item_double_clicked(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata);
void qt6cr_list_widget_on_rows_moved(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_tree_widget_item_create(const char *text);
void qt6cr_tree_widget_item_destroy(qt6cr_handle_t handle);
void qt6cr_tree_widget_item_set_text(qt6cr_handle_t handle, int column, const char *text);
char *qt6cr_tree_widget_item_text(qt6cr_handle_t handle, int column);
int qt6cr_tree_widget_item_flags(qt6cr_handle_t handle);
void qt6cr_tree_widget_item_set_flags(qt6cr_handle_t handle, int flags);
qt6cr_handle_t qt6cr_tree_widget_item_font(qt6cr_handle_t handle, int column);
void qt6cr_tree_widget_item_set_font(qt6cr_handle_t handle, int column, qt6cr_handle_t font);
qt6cr_color_t qt6cr_tree_widget_item_foreground(qt6cr_handle_t handle, int column);
void qt6cr_tree_widget_item_set_foreground(qt6cr_handle_t handle, int column, qt6cr_color_t color);
void qt6cr_tree_widget_item_add_child(qt6cr_handle_t handle, qt6cr_handle_t child);
int qt6cr_tree_widget_item_child_count(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_tree_widget_item_child(qt6cr_handle_t handle, int index);

qt6cr_handle_t qt6cr_tree_widget_create(qt6cr_handle_t parent);
int qt6cr_tree_widget_column_count(qt6cr_handle_t handle);
void qt6cr_tree_widget_set_column_count(qt6cr_handle_t handle, int count);
char *qt6cr_tree_widget_header_label(qt6cr_handle_t handle, int column);
void qt6cr_tree_widget_set_header_label(qt6cr_handle_t handle, int column, const char *text);
bool qt6cr_tree_widget_header_hidden(qt6cr_handle_t handle);
void qt6cr_tree_widget_set_header_hidden(qt6cr_handle_t handle, bool value);
void qt6cr_tree_widget_add_top_level_item(qt6cr_handle_t handle, qt6cr_handle_t item);
qt6cr_handle_t qt6cr_tree_widget_add_top_level_item_text(qt6cr_handle_t handle, const char *text);
int qt6cr_tree_widget_top_level_item_count(qt6cr_handle_t handle);
qt6cr_handle_t qt6cr_tree_widget_top_level_item(qt6cr_handle_t handle, int index);
qt6cr_handle_t qt6cr_tree_widget_current_item(qt6cr_handle_t handle);
void qt6cr_tree_widget_set_current_item(qt6cr_handle_t handle, qt6cr_handle_t item);
char *qt6cr_tree_widget_current_item_text(qt6cr_handle_t handle, int column);
void qt6cr_tree_widget_expand_all(qt6cr_handle_t handle);
void qt6cr_tree_widget_collapse_all(qt6cr_handle_t handle);
void qt6cr_tree_widget_clear(qt6cr_handle_t handle);
void qt6cr_tree_widget_on_current_item_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_slider_create(qt6cr_handle_t parent, int orientation);
void qt6cr_slider_set_minimum(qt6cr_handle_t handle, int value);
int qt6cr_slider_minimum(qt6cr_handle_t handle);
void qt6cr_slider_set_maximum(qt6cr_handle_t handle, int value);
int qt6cr_slider_maximum(qt6cr_handle_t handle);
void qt6cr_slider_set_range(qt6cr_handle_t handle, int minimum, int maximum);
void qt6cr_slider_set_value(qt6cr_handle_t handle, int value);
int qt6cr_slider_value(qt6cr_handle_t handle);
int qt6cr_slider_orientation(qt6cr_handle_t handle);
void qt6cr_slider_on_value_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata);

int qt6cr_abstract_spin_box_button_symbols(qt6cr_handle_t handle);
void qt6cr_abstract_spin_box_set_button_symbols(qt6cr_handle_t handle, int value);
bool qt6cr_abstract_spin_box_is_read_only(qt6cr_handle_t handle);
void qt6cr_abstract_spin_box_set_read_only(qt6cr_handle_t handle, bool value);

qt6cr_handle_t qt6cr_spin_box_create(qt6cr_handle_t parent);
void qt6cr_spin_box_set_minimum(qt6cr_handle_t handle, int value);
int qt6cr_spin_box_minimum(qt6cr_handle_t handle);
void qt6cr_spin_box_set_maximum(qt6cr_handle_t handle, int value);
int qt6cr_spin_box_maximum(qt6cr_handle_t handle);
void qt6cr_spin_box_set_range(qt6cr_handle_t handle, int minimum, int maximum);
void qt6cr_spin_box_set_value(qt6cr_handle_t handle, int value);
int qt6cr_spin_box_value(qt6cr_handle_t handle);
void qt6cr_spin_box_set_single_step(qt6cr_handle_t handle, int value);
int qt6cr_spin_box_single_step(qt6cr_handle_t handle);
void qt6cr_spin_box_on_value_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_double_spin_box_create(qt6cr_handle_t parent);
void qt6cr_double_spin_box_set_minimum(qt6cr_handle_t handle, double value);
double qt6cr_double_spin_box_minimum(qt6cr_handle_t handle);
void qt6cr_double_spin_box_set_maximum(qt6cr_handle_t handle, double value);
double qt6cr_double_spin_box_maximum(qt6cr_handle_t handle);
void qt6cr_double_spin_box_set_range(qt6cr_handle_t handle, double minimum, double maximum);
void qt6cr_double_spin_box_set_value(qt6cr_handle_t handle, double value);
double qt6cr_double_spin_box_value(qt6cr_handle_t handle);
void qt6cr_double_spin_box_set_single_step(qt6cr_handle_t handle, double value);
double qt6cr_double_spin_box_single_step(qt6cr_handle_t handle);
void qt6cr_double_spin_box_on_value_changed(qt6cr_handle_t handle, qt6cr_double_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_group_box_create(qt6cr_handle_t parent, const char *title);
void qt6cr_group_box_set_title(qt6cr_handle_t handle, const char *title);
char *qt6cr_group_box_title(qt6cr_handle_t handle);
void qt6cr_group_box_set_checkable(qt6cr_handle_t handle, bool value);
bool qt6cr_group_box_is_checkable(qt6cr_handle_t handle);
void qt6cr_group_box_set_checked(qt6cr_handle_t handle, bool value);
bool qt6cr_group_box_is_checked(qt6cr_handle_t handle);
void qt6cr_group_box_on_toggled(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_frame_create(qt6cr_handle_t parent);
int qt6cr_frame_shape(qt6cr_handle_t handle);
void qt6cr_frame_set_shape(qt6cr_handle_t handle, int shape);
int qt6cr_frame_shadow(qt6cr_handle_t handle);
void qt6cr_frame_set_shadow(qt6cr_handle_t handle, int shadow);

qt6cr_handle_t qt6cr_text_browser_create(qt6cr_handle_t parent);
char *qt6cr_text_browser_html(qt6cr_handle_t handle);
void qt6cr_text_browser_set_html(qt6cr_handle_t handle, const char *html);
char *qt6cr_text_browser_plain_text(qt6cr_handle_t handle);
bool qt6cr_text_browser_open_external_links(qt6cr_handle_t handle);
void qt6cr_text_browser_set_open_external_links(qt6cr_handle_t handle, bool value);
char *qt6cr_text_browser_default_style_sheet(qt6cr_handle_t handle);
void qt6cr_text_browser_set_default_style_sheet(qt6cr_handle_t handle, const char *css);
int qt6cr_text_browser_vertical_scroll_value(qt6cr_handle_t handle);
void qt6cr_text_browser_set_vertical_scroll_value(qt6cr_handle_t handle, int value);
void qt6cr_text_browser_on_anchor_clicked(qt6cr_handle_t handle, qt6cr_string_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_tab_widget_create(qt6cr_handle_t parent);
int qt6cr_tab_widget_add_tab(qt6cr_handle_t handle, qt6cr_handle_t widget, const char *label);
int qt6cr_tab_widget_count(qt6cr_handle_t handle);
int qt6cr_tab_widget_current_index(qt6cr_handle_t handle);
void qt6cr_tab_widget_set_current_index(qt6cr_handle_t handle, int index);
void qt6cr_tab_widget_on_current_index_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_stacked_widget_create(qt6cr_handle_t parent);
int qt6cr_stacked_widget_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);
int qt6cr_stacked_widget_count(qt6cr_handle_t handle);
int qt6cr_stacked_widget_current_index(qt6cr_handle_t handle);
void qt6cr_stacked_widget_set_current_index(qt6cr_handle_t handle, int index);

qt6cr_handle_t qt6cr_scroll_area_create(qt6cr_handle_t parent);
void qt6cr_scroll_area_set_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);
void qt6cr_scroll_area_set_widget_resizable(qt6cr_handle_t handle, bool value);
bool qt6cr_scroll_area_widget_resizable(qt6cr_handle_t handle);
int qt6cr_scroll_area_vertical_scroll_bar_policy(qt6cr_handle_t handle);
void qt6cr_scroll_area_set_vertical_scroll_bar_policy(qt6cr_handle_t handle, int policy);
int qt6cr_scroll_area_horizontal_scroll_bar_policy(qt6cr_handle_t handle);
void qt6cr_scroll_area_set_horizontal_scroll_bar_policy(qt6cr_handle_t handle, int policy);

qt6cr_handle_t qt6cr_splitter_create(qt6cr_handle_t parent, int orientation);
void qt6cr_splitter_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);
int qt6cr_splitter_count(qt6cr_handle_t handle);
int qt6cr_splitter_orientation(qt6cr_handle_t handle);
void qt6cr_splitter_set_orientation(qt6cr_handle_t handle, int orientation);

qt6cr_handle_t qt6cr_dialog_button_box_create(qt6cr_handle_t parent, int buttons);
qt6cr_handle_t qt6cr_dialog_button_box_button(qt6cr_handle_t handle, int button);
void qt6cr_dialog_button_box_on_accepted(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);
void qt6cr_dialog_button_box_on_rejected(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata);

qt6cr_handle_t qt6cr_button_group_create(qt6cr_handle_t parent);
bool qt6cr_button_group_is_exclusive(qt6cr_handle_t handle);
void qt6cr_button_group_set_exclusive(qt6cr_handle_t handle, bool value);
void qt6cr_button_group_add_button(qt6cr_handle_t handle, qt6cr_handle_t button, int id);
qt6cr_handle_t qt6cr_button_group_button(qt6cr_handle_t handle, int id);
int qt6cr_button_group_checked_id(qt6cr_handle_t handle);

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
void qt6cr_v_box_layout_insert_widget(qt6cr_handle_t handle, int index, qt6cr_handle_t widget);

qt6cr_handle_t qt6cr_h_box_layout_create(qt6cr_handle_t parent_widget);
void qt6cr_h_box_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);

qt6cr_handle_t qt6cr_grid_layout_create(qt6cr_handle_t parent_widget);
void qt6cr_grid_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget, int row, int column, int row_span, int column_span);

qt6cr_handle_t qt6cr_form_layout_create(qt6cr_handle_t parent_widget);
void qt6cr_form_layout_add_row_label_widget(qt6cr_handle_t handle, const char *label, qt6cr_handle_t field_widget);
void qt6cr_form_layout_add_row_widget_widget(qt6cr_handle_t handle, qt6cr_handle_t label_widget, qt6cr_handle_t field_widget);
void qt6cr_form_layout_add_row_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);
int qt6cr_layout_spacing(qt6cr_handle_t handle);
void qt6cr_layout_set_spacing(qt6cr_handle_t handle, int value);
void qt6cr_layout_set_contents_margins(qt6cr_handle_t handle, double left, double top, double right, double bottom);
void qt6cr_layout_remove_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);

void qt6cr_string_free(char *value);

#ifdef __cplusplus
}
#endif
