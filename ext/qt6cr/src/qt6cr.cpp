#include "qt6cr.h"

#if defined(__aarch64__) || defined(__arm64__)
#include <arm_acle.h>
#endif

#include <QApplication>
#include <QCoreApplication>
#include <QKeyEvent>
#include <QLabel>
#include <QMouseEvent>
#include <QObject>
#include <QPaintEvent>
#include <QPushButton>
#include <QResizeEvent>
#include <QTimer>
#include <QVBoxLayout>
#include <QWheelEvent>
#include <QWidget>

#include <QPoint>

#include <cstring>
#include <memory>
#include <string>
#include <vector>

namespace {

struct ApplicationState {
  int argc;
  std::vector<std::unique_ptr<char[]>> storage;
  std::vector<char *> argv;
  QApplication *application;
  bool owns_application;
};

qt6cr_pointf_t to_pointf(const QPointF &point);
qt6cr_pointf_t to_pointf(const QPoint &point);
qt6cr_size_t to_size(const QSize &size);
qt6cr_rectf_t to_rectf(const QRectF &rect);
qt6cr_mouse_event_t to_mouse_event(QMouseEvent *event);
qt6cr_wheel_event_t to_wheel_event(QWheelEvent *event);
qt6cr_key_event_t to_key_event(QKeyEvent *event);

class EventWidget final : public QWidget {
 public:
  explicit EventWidget(QWidget *parent = nullptr) : QWidget(parent) {
    setMouseTracking(true);
    setFocusPolicy(Qt::StrongFocus);
  }

  qt6cr_paint_callback_t paint_callback = nullptr;
  void *paint_userdata = nullptr;
  qt6cr_resize_callback_t resize_callback = nullptr;
  void *resize_userdata = nullptr;
  qt6cr_mouse_callback_t mouse_press_callback = nullptr;
  void *mouse_press_userdata = nullptr;
  qt6cr_mouse_callback_t mouse_move_callback = nullptr;
  void *mouse_move_userdata = nullptr;
  qt6cr_mouse_callback_t mouse_release_callback = nullptr;
  void *mouse_release_userdata = nullptr;
  qt6cr_wheel_callback_t wheel_callback = nullptr;
  void *wheel_userdata = nullptr;
  qt6cr_key_callback_t key_press_callback = nullptr;
  void *key_press_userdata = nullptr;

 protected:
  void paintEvent(QPaintEvent *event) override {
    if (paint_callback != nullptr) {
      paint_callback(paint_userdata, to_rectf(event->rect()));
    }

    QWidget::paintEvent(event);
  }

  void resizeEvent(QResizeEvent *event) override {
    if (resize_callback != nullptr) {
      resize_callback(resize_userdata, to_size(event->oldSize()), to_size(event->size()));
    }

    QWidget::resizeEvent(event);
  }

  void mousePressEvent(QMouseEvent *event) override {
    if (mouse_press_callback != nullptr) {
      mouse_press_callback(mouse_press_userdata, to_mouse_event(event));
    }

    QWidget::mousePressEvent(event);
  }

  void mouseMoveEvent(QMouseEvent *event) override {
    if (mouse_move_callback != nullptr) {
      mouse_move_callback(mouse_move_userdata, to_mouse_event(event));
    }

    QWidget::mouseMoveEvent(event);
  }

  void mouseReleaseEvent(QMouseEvent *event) override {
    if (mouse_release_callback != nullptr) {
      mouse_release_callback(mouse_release_userdata, to_mouse_event(event));
    }

    QWidget::mouseReleaseEvent(event);
  }

  void wheelEvent(QWheelEvent *event) override {
    if (wheel_callback != nullptr) {
      wheel_callback(wheel_userdata, to_wheel_event(event));
    }

    QWidget::wheelEvent(event);
  }

  void keyPressEvent(QKeyEvent *event) override {
    if (key_press_callback != nullptr) {
      key_press_callback(key_press_userdata, to_key_event(event));
    }

    QWidget::keyPressEvent(event);
  }

 private:
  static qt6cr_rectf_t to_rectf(const QRect &rect) {
    return qt6cr_rectf_t{static_cast<double>(rect.x()), static_cast<double>(rect.y()), static_cast<double>(rect.width()), static_cast<double>(rect.height())};
  }
};

char *duplicate_string(const QString &value) {
  const QByteArray utf8 = value.toUtf8();
  auto *copy = new char[static_cast<size_t>(utf8.size()) + 1];
  std::memcpy(copy, utf8.constData(), static_cast<size_t>(utf8.size()));
  copy[utf8.size()] = '\0';
  return copy;
}

char *duplicate_string(const char *value) {
  const auto length = std::strlen(value);
  auto *copy = new char[length + 1];
  std::memcpy(copy, value, length + 1);
  return copy;
}

QWidget *as_widget(qt6cr_handle_t handle) {
  return static_cast<QWidget *>(handle);
}

QLabel *as_label(qt6cr_handle_t handle) {
  return static_cast<QLabel *>(handle);
}

QPushButton *as_push_button(qt6cr_handle_t handle) {
  return static_cast<QPushButton *>(handle);
}

QVBoxLayout *as_v_box_layout(qt6cr_handle_t handle) {
  return static_cast<QVBoxLayout *>(handle);
}

ApplicationState *as_application_state(qt6cr_handle_t handle) {
  return static_cast<ApplicationState *>(handle);
}

QObject *as_object(qt6cr_handle_t handle) {
  return static_cast<QObject *>(handle);
}

EventWidget *as_event_widget(qt6cr_handle_t handle) {
  return static_cast<EventWidget *>(handle);
}

QTimer *as_timer(qt6cr_handle_t handle) {
  return static_cast<QTimer *>(handle);
}

qt6cr_pointf_t to_pointf(const QPointF &point) {
  return qt6cr_pointf_t{point.x(), point.y()};
}

qt6cr_pointf_t to_pointf(const QPoint &point) {
  return qt6cr_pointf_t{static_cast<double>(point.x()), static_cast<double>(point.y())};
}

qt6cr_size_t to_size(const QSize &size) {
  return qt6cr_size_t{size.width(), size.height()};
}

qt6cr_rectf_t to_rectf(const QRectF &rect) {
  return qt6cr_rectf_t{rect.x(), rect.y(), rect.width(), rect.height()};
}

qt6cr_mouse_event_t to_mouse_event(QMouseEvent *event) {
  return qt6cr_mouse_event_t{to_pointf(event->position()), static_cast<int>(event->button()), static_cast<int>(event->buttons()), static_cast<int>(event->modifiers())};
}

qt6cr_wheel_event_t to_wheel_event(QWheelEvent *event) {
  return qt6cr_wheel_event_t{to_pointf(event->position()), to_pointf(event->pixelDelta()), to_pointf(event->angleDelta()), static_cast<int>(event->buttons()), static_cast<int>(event->modifiers())};
}

qt6cr_key_event_t to_key_event(QKeyEvent *event) {
  return qt6cr_key_event_t{event->key(), static_cast<int>(event->modifiers()), event->isAutoRepeat(), event->count()};
}

void send_mouse_event(QWidget *widget, QEvent::Type type, qt6cr_pointf_t position, int button, int buttons, int modifiers) {
  if (widget == nullptr) {
    return;
  }

  const QPointF local_pos(position.x, position.y);
  QMouseEvent event(type, local_pos, local_pos, static_cast<Qt::MouseButton>(button), Qt::MouseButtons(buttons), Qt::KeyboardModifiers(modifiers));
  QApplication::sendEvent(widget, &event);
}

}  // namespace

extern "C" {

void qt6cr_object_destroy(qt6cr_handle_t handle) {
  delete as_object(handle);
}

void qt6cr_object_on_destroyed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *object = as_object(handle);

  if (object == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(object, &QObject::destroyed, object, [callback, userdata]() {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_application_create(int argc, const char *const *argv) {
  auto *state = new ApplicationState{};
  state->application = qobject_cast<QApplication *>(QCoreApplication::instance());
  state->owns_application = state->application == nullptr;

  if (!state->owns_application) {
    return state;
  }

  state->argc = argc;
  state->storage.reserve(static_cast<size_t>(argc));
  state->argv.reserve(static_cast<size_t>(argc) + 1);

  for (int index = 0; index < argc; ++index) {
    state->storage.emplace_back(duplicate_string(argv[index] == nullptr ? "" : argv[index]));
    state->argv.push_back(state->storage.back().get());
  }

  state->argv.push_back(nullptr);
  state->application = new QApplication(state->argc, state->argv.data());
  return state;
}

void qt6cr_application_destroy(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);

  if (state == nullptr) {
    return;
  }

  if (state->owns_application) {
    delete state->application;
  }

  delete state;
}

int qt6cr_application_exec(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);
  return state == nullptr || state->application == nullptr ? -1 : state->application->exec();
}

void qt6cr_application_process_events(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);

  if (state != nullptr && state->application != nullptr) {
    state->application->processEvents();
  }
}

void qt6cr_application_quit(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);

  if (state != nullptr && state->application != nullptr) {
    state->application->quit();
  }
}

qt6cr_handle_t qt6cr_widget_create(qt6cr_handle_t parent) {
  return new QWidget(as_widget(parent));
}

void qt6cr_widget_destroy(qt6cr_handle_t handle) {
  qt6cr_object_destroy(handle);
}

void qt6cr_widget_show(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->show();
  }
}

void qt6cr_widget_close(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->close();
  }
}

void qt6cr_widget_resize(qt6cr_handle_t handle, int width, int height) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->resize(width, height);
  }
}

void qt6cr_widget_set_window_title(qt6cr_handle_t handle, const char *title) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setWindowTitle(QString::fromUtf8(title == nullptr ? "" : title));
  }
}

char *qt6cr_widget_window_title(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? duplicate_string("") : duplicate_string(widget->windowTitle());
}

bool qt6cr_widget_is_visible(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget != nullptr && widget->isVisible();
}

qt6cr_size_t qt6cr_widget_size(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? qt6cr_size_t{0, 0} : to_size(widget->size());
}

qt6cr_rectf_t qt6cr_widget_rect(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(widget->rect());
}

void qt6cr_widget_update(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->update();
  }
}

qt6cr_handle_t qt6cr_event_widget_create(qt6cr_handle_t parent) {
  return new EventWidget(as_widget(parent));
}

void qt6cr_event_widget_on_paint(qt6cr_handle_t handle, qt6cr_paint_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->paint_callback = callback;
    widget->paint_userdata = userdata;
  }
}

void qt6cr_event_widget_on_resize(qt6cr_handle_t handle, qt6cr_resize_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->resize_callback = callback;
    widget->resize_userdata = userdata;
  }
}

void qt6cr_event_widget_on_mouse_press(qt6cr_handle_t handle, qt6cr_mouse_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->mouse_press_callback = callback;
    widget->mouse_press_userdata = userdata;
  }
}

void qt6cr_event_widget_on_mouse_move(qt6cr_handle_t handle, qt6cr_mouse_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->mouse_move_callback = callback;
    widget->mouse_move_userdata = userdata;
  }
}

void qt6cr_event_widget_on_mouse_release(qt6cr_handle_t handle, qt6cr_mouse_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->mouse_release_callback = callback;
    widget->mouse_release_userdata = userdata;
  }
}

void qt6cr_event_widget_on_wheel(qt6cr_handle_t handle, qt6cr_wheel_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->wheel_callback = callback;
    widget->wheel_userdata = userdata;
  }
}

void qt6cr_event_widget_on_key_press(qt6cr_handle_t handle, qt6cr_key_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->key_press_callback = callback;
    widget->key_press_userdata = userdata;
  }
}

void qt6cr_event_widget_repaint(qt6cr_handle_t handle) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->repaint();
  }
}

void qt6cr_event_widget_send_mouse_press(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers) {
  send_mouse_event(as_event_widget(handle), QEvent::MouseButtonPress, position, button, buttons, modifiers);
}

void qt6cr_event_widget_send_mouse_move(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers) {
  send_mouse_event(as_event_widget(handle), QEvent::MouseMove, position, button, buttons, modifiers);
}

void qt6cr_event_widget_send_mouse_release(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers) {
  send_mouse_event(as_event_widget(handle), QEvent::MouseButtonRelease, position, button, buttons, modifiers);
}

void qt6cr_event_widget_send_wheel(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_pointf_t pixel_delta, qt6cr_pointf_t angle_delta, int buttons, int modifiers) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  const QPointF pos(position.x, position.y);
  const QPoint pixel(static_cast<int>(pixel_delta.x), static_cast<int>(pixel_delta.y));
  const QPoint angle(static_cast<int>(angle_delta.x), static_cast<int>(angle_delta.y));
  QWheelEvent event(pos, pos, pixel, angle, Qt::MouseButtons(buttons), Qt::KeyboardModifiers(modifiers), Qt::NoScrollPhase, false);
  QApplication::sendEvent(widget, &event);
}

void qt6cr_event_widget_send_key_press(qt6cr_handle_t handle, int key, int modifiers, bool auto_repeat, int count) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  QKeyEvent event(QEvent::KeyPress, key, Qt::KeyboardModifiers(modifiers), QString(), auto_repeat, static_cast<quint16>(count));
  QApplication::sendEvent(widget, &event);
}

qt6cr_handle_t qt6cr_label_create(qt6cr_handle_t parent, const char *text) {
  return new QLabel(QString::fromUtf8(text == nullptr ? "" : text), as_widget(parent));
}

void qt6cr_label_set_text(qt6cr_handle_t handle, const char *text) {
  auto *label = as_label(handle);

  if (label != nullptr) {
    label->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_label_text(qt6cr_handle_t handle) {
  auto *label = as_label(handle);
  return label == nullptr ? duplicate_string("") : duplicate_string(label->text());
}

qt6cr_handle_t qt6cr_push_button_create(qt6cr_handle_t parent, const char *text) {
  return new QPushButton(QString::fromUtf8(text == nullptr ? "" : text), as_widget(parent));
}

void qt6cr_push_button_set_text(qt6cr_handle_t handle, const char *text) {
  auto *button = as_push_button(handle);

  if (button != nullptr) {
    button->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_push_button_text(qt6cr_handle_t handle) {
  auto *button = as_push_button(handle);
  return button == nullptr ? duplicate_string("") : duplicate_string(button->text());
}

void qt6cr_push_button_on_clicked(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *button = as_push_button(handle);

  if (button == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(button, &QPushButton::clicked, button, [callback, userdata]() {
    callback(userdata);
  });
}

void qt6cr_push_button_click(qt6cr_handle_t handle) {
  auto *button = as_push_button(handle);

  if (button != nullptr) {
    button->click();
  }
}

qt6cr_handle_t qt6cr_timer_create(qt6cr_handle_t parent) {
  return new QTimer(as_object(parent));
}

void qt6cr_timer_set_interval(qt6cr_handle_t handle, int interval) {
  auto *timer = as_timer(handle);

  if (timer != nullptr) {
    timer->setInterval(interval);
  }
}

int qt6cr_timer_interval(qt6cr_handle_t handle) {
  auto *timer = as_timer(handle);
  return timer == nullptr ? 0 : timer->interval();
}

void qt6cr_timer_set_single_shot(qt6cr_handle_t handle, bool value) {
  auto *timer = as_timer(handle);

  if (timer != nullptr) {
    timer->setSingleShot(value);
  }
}

bool qt6cr_timer_is_single_shot(qt6cr_handle_t handle) {
  auto *timer = as_timer(handle);
  return timer != nullptr && timer->isSingleShot();
}

bool qt6cr_timer_is_active(qt6cr_handle_t handle) {
  auto *timer = as_timer(handle);
  return timer != nullptr && timer->isActive();
}

void qt6cr_timer_start(qt6cr_handle_t handle) {
  auto *timer = as_timer(handle);

  if (timer != nullptr) {
    timer->start();
  }
}

void qt6cr_timer_stop(qt6cr_handle_t handle) {
  auto *timer = as_timer(handle);

  if (timer != nullptr) {
    timer->stop();
  }
}

void qt6cr_timer_on_timeout(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *timer = as_timer(handle);

  if (timer == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(timer, &QTimer::timeout, timer, [callback, userdata]() {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_v_box_layout_create(qt6cr_handle_t parent_widget) {
  return new QVBoxLayout(as_widget(parent_widget));
}

void qt6cr_v_box_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *layout = as_v_box_layout(handle);
  auto *child = as_widget(widget);

  if (layout != nullptr && child != nullptr) {
    layout->addWidget(child);
  }
}

void qt6cr_string_free(char *value) {
  delete[] value;
}

}  // extern "C"
