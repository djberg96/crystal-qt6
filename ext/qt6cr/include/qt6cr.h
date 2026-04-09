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

typedef void (*qt6cr_void_callback_t)(void *userdata);
typedef void (*qt6cr_paint_callback_t)(void *userdata, qt6cr_rectf_t rect);
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

qt6cr_handle_t qt6cr_event_widget_create(qt6cr_handle_t parent);
void qt6cr_event_widget_on_paint(qt6cr_handle_t handle, qt6cr_paint_callback_t callback, void *userdata);
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

void qt6cr_string_free(char *value);

#ifdef __cplusplus
}
#endif
