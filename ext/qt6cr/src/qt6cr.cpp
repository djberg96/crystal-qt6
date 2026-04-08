#include "qt6cr.h"

#if defined(__aarch64__) || defined(__arm64__)
#include <arm_acle.h>
#endif

#include <QApplication>
#include <QCoreApplication>
#include <QLabel>
#include <QPushButton>
#include <QVBoxLayout>
#include <QWidget>

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

}  // namespace

extern "C" {

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
  delete as_widget(handle);
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

void qt6cr_push_button_on_clicked(qt6cr_handle_t handle, qt6cr_button_callback_t callback, void *userdata) {
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
