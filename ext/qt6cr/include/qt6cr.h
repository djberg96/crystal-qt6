#pragma once

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef void *qt6cr_handle_t;
typedef void (*qt6cr_button_callback_t)(void *userdata);

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

qt6cr_handle_t qt6cr_label_create(qt6cr_handle_t parent, const char *text);
void qt6cr_label_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_label_text(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_push_button_create(qt6cr_handle_t parent, const char *text);
void qt6cr_push_button_set_text(qt6cr_handle_t handle, const char *text);
char *qt6cr_push_button_text(qt6cr_handle_t handle);
void qt6cr_push_button_on_clicked(qt6cr_handle_t handle, qt6cr_button_callback_t callback, void *userdata);
void qt6cr_push_button_click(qt6cr_handle_t handle);

qt6cr_handle_t qt6cr_v_box_layout_create(qt6cr_handle_t parent_widget);
void qt6cr_v_box_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget);

void qt6cr_string_free(char *value);

#ifdef __cplusplus
}
#endif
