#include "qt6cr.h"

#if defined(__aarch64__) || defined(__arm64__)
#include <arm_acle.h>
#endif

#include <QApplication>
#include <QAction>
#include <QActionGroup>
#include <QAbstractItemModel>
#include <QCheckBox>
#include <QClipboard>
#include <QColor>
#include <QColorDialog>
#include <QComboBox>
#include <QCoreApplication>
#include <QDialog>
#include <QDockWidget>
#include <QFileDialog>
#include <QFont>
#include <QFontMetrics>
#include <QFormLayout>
#include <QGridLayout>
#include <QHBoxLayout>
#include <QInputDialog>
#include <QItemSelectionModel>
#include <QKeyEvent>
#include <QLabel>
#include <QListView>
#include <QListWidget>
#include <QListWidgetItem>
#include <QLineEdit>
#include <QMainWindow>
#include <QMenu>
#include <QBrush>
#include <QMenuBar>
#include <QMessageBox>
#include <QMouseEvent>
#include <QImage>
#include <QObject>
#include <QPaintEvent>
#include <QPainter>
#include <QPainterPath>
#include <QPageSize>
#include <QPen>
#include <QPdfWriter>
#include <QPixmap>
#include <QPushButton>
#include <QSortFilterProxyModel>
#include <QKeySequence>
#include <QRadioButton>
#include <QResizeEvent>
#include <QScrollArea>
#include <QSlider>
#include <QSpinBox>
#include <QDoubleSpinBox>
#include <QStatusBar>
#include <QStandardItem>
#include <QStandardItemModel>
#include <QStyledItemDelegate>
#include <QGroupBox>
#include <QSvgGenerator>
#include <QSvgRenderer>
#include <QSvgWidget>
#include <QTabWidget>
#include <QTimer>
#include <QTransform>
#include <QToolBar>
#include <QTreeView>
#include <QTreeWidget>
#include <QTreeWidgetItem>
#include <QVBoxLayout>
#include <QWheelEvent>
#include <QWidget>
#include <QSplitter>
#include <QVariant>
#include <QMetaType>
#include <QLocale>

#include <QPoint>

#include <cstdlib>
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
qt6cr_color_t to_color(const QColor &color);
qt6cr_variant_value_t to_variant_value(const QVariant &value);
QVariant from_variant_value(const qt6cr_variant_value_t &value);

class EventWidget final : public QWidget {
 public:
  explicit EventWidget(QWidget *parent = nullptr) : QWidget(parent) {
    setMouseTracking(true);
    setFocusPolicy(Qt::StrongFocus);
  }

  qt6cr_paint_callback_t paint_callback = nullptr;
  void *paint_userdata = nullptr;
  qt6cr_paint_with_painter_callback_t paint_with_painter_callback = nullptr;
  void *paint_with_painter_userdata = nullptr;
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
    const auto rect = to_rectf(event->rect());

    if (paint_callback != nullptr) {
      paint_callback(paint_userdata, rect);
    }

    QWidget::paintEvent(event);

    if (paint_with_painter_callback != nullptr) {
      QPainter painter(this);
      paint_with_painter_callback(paint_with_painter_userdata, &painter, rect);
    }
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

class ModelListView final : public QListView {
 public:
  explicit ModelListView(QWidget *parent = nullptr) : QListView(parent) {}

  qt6cr_void_callback_t current_index_changed_callback = nullptr;
  void *current_index_changed_userdata = nullptr;

  void setModel(QAbstractItemModel *model) override {
    if (current_changed_connection) {
      QObject::disconnect(current_changed_connection);
    }

    QListView::setModel(model);
    reconnect_current_changed();
  }

  void reconnect_current_changed() {
    auto *selection_model = selectionModel();

    if (selection_model == nullptr || current_index_changed_callback == nullptr) {
      return;
    }

    current_changed_connection = QObject::connect(selection_model, &QItemSelectionModel::currentChanged, this, [this](const QModelIndex &, const QModelIndex &) {
      if (current_index_changed_callback != nullptr) {
        current_index_changed_callback(current_index_changed_userdata);
      }
    });
  }

 private:
  QMetaObject::Connection current_changed_connection;
};

class ModelTreeView final : public QTreeView {
 public:
  explicit ModelTreeView(QWidget *parent = nullptr) : QTreeView(parent) {}

  qt6cr_void_callback_t current_index_changed_callback = nullptr;
  void *current_index_changed_userdata = nullptr;

  void setModel(QAbstractItemModel *model) override {
    if (current_changed_connection) {
      QObject::disconnect(current_changed_connection);
    }

    QTreeView::setModel(model);
    reconnect_current_changed();
  }

  void reconnect_current_changed() {
    auto *selection_model = selectionModel();

    if (selection_model == nullptr || current_index_changed_callback == nullptr) {
      return;
    }

    current_changed_connection = QObject::connect(selection_model, &QItemSelectionModel::currentChanged, this, [this](const QModelIndex &, const QModelIndex &) {
      if (current_index_changed_callback != nullptr) {
        current_index_changed_callback(current_index_changed_userdata);
      }
    });
  }

 private:
  QMetaObject::Connection current_changed_connection;
};

class CrystalStyledItemDelegate final : public QStyledItemDelegate {
 public:
  explicit CrystalStyledItemDelegate(QObject *parent = nullptr) : QStyledItemDelegate(parent) {}

  qt6cr_string_transform_callback_t display_text_callback = nullptr;
  void *display_text_userdata = nullptr;

  QString displayText(const QVariant &value, const QLocale &locale) const override {
    const auto default_text = QStyledItemDelegate::displayText(value, locale);

    if (display_text_callback == nullptr) {
      return default_text;
    }

    const auto utf8 = default_text.toUtf8();
    char *transformed = display_text_callback(display_text_userdata, utf8.constData());

    if (transformed == nullptr) {
      return default_text;
    }

    const auto result = QString::fromUtf8(transformed);
    std::free(transformed);
    return result;
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

QMainWindow *as_main_window(qt6cr_handle_t handle) {
  return static_cast<QMainWindow *>(handle);
}

QDialog *as_dialog(qt6cr_handle_t handle) {
  return static_cast<QDialog *>(handle);
}

QMessageBox *as_message_box(qt6cr_handle_t handle) {
  return static_cast<QMessageBox *>(handle);
}

QFileDialog *as_file_dialog(qt6cr_handle_t handle) {
  return static_cast<QFileDialog *>(handle);
}

QColorDialog *as_color_dialog(qt6cr_handle_t handle) {
  return static_cast<QColorDialog *>(handle);
}

QImage *as_qimage(qt6cr_handle_t handle) {
  return static_cast<QImage *>(handle);
}

QAbstractItemModel *as_abstract_item_model(qt6cr_handle_t handle) {
  return static_cast<QAbstractItemModel *>(handle);
}

QPixmap *as_qpixmap(qt6cr_handle_t handle) {
  return static_cast<QPixmap *>(handle);
}

QSortFilterProxyModel *as_sort_filter_proxy_model(qt6cr_handle_t handle) {
  return static_cast<QSortFilterProxyModel *>(handle);
}

CrystalStyledItemDelegate *as_styled_item_delegate(qt6cr_handle_t handle) {
  return static_cast<CrystalStyledItemDelegate *>(handle);
}

QSvgGenerator *as_qsvg_generator(qt6cr_handle_t handle) {
  return static_cast<QSvgGenerator *>(handle);
}

QSvgRenderer *as_qsvg_renderer(qt6cr_handle_t handle) {
  return static_cast<QSvgRenderer *>(handle);
}

QSvgWidget *as_qsvg_widget(qt6cr_handle_t handle) {
  return static_cast<QSvgWidget *>(handle);
}

QPdfWriter *as_qpdf_writer(qt6cr_handle_t handle) {
  return static_cast<QPdfWriter *>(handle);
}

QPen *as_qpen(qt6cr_handle_t handle) {
  return static_cast<QPen *>(handle);
}

QBrush *as_qbrush(qt6cr_handle_t handle) {
  return static_cast<QBrush *>(handle);
}

QFont *as_qfont(qt6cr_handle_t handle) {
  return static_cast<QFont *>(handle);
}

QFontMetrics *as_qfont_metrics(qt6cr_handle_t handle) {
  return static_cast<QFontMetrics *>(handle);
}

QFontMetricsF *as_qfont_metrics_f(qt6cr_handle_t handle) {
  return static_cast<QFontMetricsF *>(handle);
}

QTransform *as_qtransform(qt6cr_handle_t handle) {
  return static_cast<QTransform *>(handle);
}

QPainterPath *as_qpainter_path(qt6cr_handle_t handle) {
  return static_cast<QPainterPath *>(handle);
}

QPainter *as_qpainter(qt6cr_handle_t handle) {
  return static_cast<QPainter *>(handle);
}

QInputDialog *as_input_dialog(qt6cr_handle_t handle) {
  return static_cast<QInputDialog *>(handle);
}

QDockWidget *as_dock_widget(qt6cr_handle_t handle) {
  return static_cast<QDockWidget *>(handle);
}

QAction *as_action(qt6cr_handle_t handle) {
  return static_cast<QAction *>(handle);
}

QActionGroup *as_action_group(qt6cr_handle_t handle) {
  return static_cast<QActionGroup *>(handle);
}

QMenuBar *as_menu_bar(qt6cr_handle_t handle) {
  return static_cast<QMenuBar *>(handle);
}

QMenu *as_menu(qt6cr_handle_t handle) {
  return static_cast<QMenu *>(handle);
}

QToolBar *as_tool_bar(qt6cr_handle_t handle) {
  return static_cast<QToolBar *>(handle);
}

QStatusBar *as_status_bar(qt6cr_handle_t handle) {
  return static_cast<QStatusBar *>(handle);
}

QLabel *as_label(qt6cr_handle_t handle) {
  return static_cast<QLabel *>(handle);
}

QPushButton *as_push_button(qt6cr_handle_t handle) {
  return static_cast<QPushButton *>(handle);
}

QLineEdit *as_line_edit(qt6cr_handle_t handle) {
  return static_cast<QLineEdit *>(handle);
}

QCheckBox *as_check_box(qt6cr_handle_t handle) {
  return static_cast<QCheckBox *>(handle);
}

QRadioButton *as_radio_button(qt6cr_handle_t handle) {
  return static_cast<QRadioButton *>(handle);
}

QComboBox *as_combo_box(qt6cr_handle_t handle) {
  return static_cast<QComboBox *>(handle);
}

QListWidgetItem *as_list_widget_item(qt6cr_handle_t handle) {
  return static_cast<QListWidgetItem *>(handle);
}

QListWidget *as_list_widget(qt6cr_handle_t handle) {
  return static_cast<QListWidget *>(handle);
}

ModelListView *as_list_view(qt6cr_handle_t handle) {
  return static_cast<ModelListView *>(handle);
}

QModelIndex *as_model_index(qt6cr_handle_t handle) {
  return static_cast<QModelIndex *>(handle);
}

QSlider *as_slider(qt6cr_handle_t handle) {
  return static_cast<QSlider *>(handle);
}

QSpinBox *as_spin_box(qt6cr_handle_t handle) {
  return static_cast<QSpinBox *>(handle);
}

QDoubleSpinBox *as_double_spin_box(qt6cr_handle_t handle) {
  return static_cast<QDoubleSpinBox *>(handle);
}

QGroupBox *as_group_box(qt6cr_handle_t handle) {
  return static_cast<QGroupBox *>(handle);
}

QTabWidget *as_tab_widget(qt6cr_handle_t handle) {
  return static_cast<QTabWidget *>(handle);
}

QScrollArea *as_scroll_area(qt6cr_handle_t handle) {
  return static_cast<QScrollArea *>(handle);
}

QSplitter *as_splitter(qt6cr_handle_t handle) {
  return static_cast<QSplitter *>(handle);
}

QStandardItem *as_standard_item(qt6cr_handle_t handle) {
  return static_cast<QStandardItem *>(handle);
}

QStandardItemModel *as_standard_item_model(qt6cr_handle_t handle) {
  return static_cast<QStandardItemModel *>(handle);
}

ModelTreeView *as_tree_view(qt6cr_handle_t handle) {
  return static_cast<ModelTreeView *>(handle);
}

QTreeWidgetItem *as_tree_widget_item(qt6cr_handle_t handle) {
  return static_cast<QTreeWidgetItem *>(handle);
}

QTreeWidget *as_tree_widget(qt6cr_handle_t handle) {
  return static_cast<QTreeWidget *>(handle);
}

QHBoxLayout *as_h_box_layout(qt6cr_handle_t handle) {
  return static_cast<QHBoxLayout *>(handle);
}

QGridLayout *as_grid_layout(qt6cr_handle_t handle) {
  return static_cast<QGridLayout *>(handle);
}

QFormLayout *as_form_layout(qt6cr_handle_t handle) {
  return static_cast<QFormLayout *>(handle);
}

QVBoxLayout *as_v_box_layout(qt6cr_handle_t handle) {
  return static_cast<QVBoxLayout *>(handle);
}

ApplicationState *as_application_state(qt6cr_handle_t handle) {
  return static_cast<ApplicationState *>(handle);
}

QClipboard *as_clipboard(qt6cr_handle_t handle) {
  return static_cast<QClipboard *>(handle);
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

qt6cr_rectf_t to_rectf(const QRect &rect) {
  return qt6cr_rectf_t{static_cast<double>(rect.x()), static_cast<double>(rect.y()), static_cast<double>(rect.width()), static_cast<double>(rect.height())};
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

qt6cr_color_t to_color(const QColor &color) {
  return qt6cr_color_t{color.red(), color.green(), color.blue(), color.alpha()};
}

qt6cr_variant_value_t to_variant_value(const QVariant &value) {
  qt6cr_variant_value_t native{};
  native.type = 0;
  native.bool_value = false;
  native.int_value = 0;
  native.double_value = 0.0;
  native.color_value = qt6cr_color_t{0, 0, 0, 0};
  native.string_value = nullptr;

  if (!value.isValid() || value.isNull()) {
    return native;
  }

  switch (value.metaType().id()) {
    case QMetaType::Bool:
      native.type = 2;
      native.bool_value = value.toBool();
      return native;
    case QMetaType::Int:
      native.type = 3;
      native.int_value = value.toInt();
      return native;
    case QMetaType::Double:
      native.type = 4;
      native.double_value = value.toDouble();
      return native;
    case QMetaType::QColor:
      native.type = 5;
      native.color_value = to_color(value.value<QColor>());
      return native;
    case QMetaType::QString:
    default:
      native.type = 1;
      native.string_value = duplicate_string(value.toString());
      return native;
  }
}

QVariant from_variant_value(const qt6cr_variant_value_t &value) {
  switch (value.type) {
    case 1:
      return QVariant(QString::fromUtf8(value.string_value == nullptr ? "" : value.string_value));
    case 2:
      return QVariant(value.bool_value);
    case 3:
      return QVariant(value.int_value);
    case 4:
      return QVariant(value.double_value);
    case 5:
      return QVariant(QColor(value.color_value.red, value.color_value.green, value.color_value.blue, value.color_value.alpha));
    default:
      return QVariant();
  }
}

QPointF from_pointf(qt6cr_pointf_t point) {
  return QPointF(point.x, point.y);
}

QRectF from_rectf(qt6cr_rectf_t rect) {
  return QRectF(rect.x, rect.y, rect.width, rect.height);
}

QRect from_rect(qt6cr_rectf_t rect) {
  return QRect(static_cast<int>(rect.x), static_cast<int>(rect.y), static_cast<int>(rect.width), static_cast<int>(rect.height));
}

QColor from_color(qt6cr_color_t color) {
  return QColor(color.red, color.green, color.blue, color.alpha);
}

QByteArray byte_array_from_data(const unsigned char *data, int size) {
  if (data == nullptr || size <= 0) {
    return QByteArray();
  }

  return QByteArray(reinterpret_cast<const char *>(data), size);
}

QImage::Format image_format_from_int(int format) {
  switch (format) {
    case 1:
      return QImage::Format_RGB32;
    case 0:
    default:
      return QImage::Format_ARGB32;
  }
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

qt6cr_handle_t qt6cr_application_clipboard(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);
  return state == nullptr || state->application == nullptr ? nullptr : state->application->clipboard();
}

char *qt6cr_clipboard_text(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);
  return clipboard == nullptr ? duplicate_string("") : duplicate_string(clipboard->text());
}

void qt6cr_clipboard_set_text(qt6cr_handle_t handle, const char *text) {
  auto *clipboard = as_clipboard(handle);

  if (clipboard != nullptr) {
    clipboard->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

qt6cr_handle_t qt6cr_clipboard_image(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);
  return clipboard == nullptr ? new QImage() : new QImage(clipboard->image());
}

void qt6cr_clipboard_set_image(qt6cr_handle_t handle, qt6cr_handle_t image) {
  auto *clipboard = as_clipboard(handle);
  auto *source = as_qimage(image);

  if (clipboard != nullptr && source != nullptr) {
    clipboard->setImage(*source);
  }
}

qt6cr_handle_t qt6cr_clipboard_pixmap(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);
  return clipboard == nullptr ? new QPixmap() : new QPixmap(clipboard->pixmap());
}

void qt6cr_clipboard_set_pixmap(qt6cr_handle_t handle, qt6cr_handle_t pixmap) {
  auto *clipboard = as_clipboard(handle);
  auto *source = as_qpixmap(pixmap);

  if (clipboard != nullptr && source != nullptr) {
    clipboard->setPixmap(*source);
  }
}

void qt6cr_clipboard_clear(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);

  if (clipboard != nullptr) {
    clipboard->clear();
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

qt6cr_handle_t qt6cr_widget_grab(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? nullptr : new QPixmap(widget->grab());
}

qt6cr_handle_t qt6cr_main_window_create(qt6cr_handle_t parent) {
  return new QMainWindow(as_widget(parent));
}

void qt6cr_main_window_set_central_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *window = as_main_window(handle);
  auto *central_widget = as_widget(widget);

  if (window != nullptr && central_widget != nullptr) {
    window->setCentralWidget(central_widget);
  }
}

qt6cr_handle_t qt6cr_main_window_menu_bar(qt6cr_handle_t handle) {
  auto *window = as_main_window(handle);
  return window == nullptr ? nullptr : window->menuBar();
}

qt6cr_handle_t qt6cr_main_window_status_bar(qt6cr_handle_t handle) {
  auto *window = as_main_window(handle);
  return window == nullptr ? nullptr : window->statusBar();
}

void qt6cr_main_window_add_tool_bar(qt6cr_handle_t handle, qt6cr_handle_t toolbar) {
  auto *window = as_main_window(handle);
  auto *tool_bar = as_tool_bar(toolbar);

  if (window != nullptr && tool_bar != nullptr) {
    window->addToolBar(tool_bar);
  }
}

void qt6cr_main_window_add_dock_widget(qt6cr_handle_t handle, int area, qt6cr_handle_t dock_widget) {
  auto *window = as_main_window(handle);
  auto *dock = as_dock_widget(dock_widget);

  if (window != nullptr && dock != nullptr) {
    window->addDockWidget(static_cast<Qt::DockWidgetArea>(area), dock);
  }
}

qt6cr_handle_t qt6cr_dialog_create(qt6cr_handle_t parent) {
  return new QDialog(as_widget(parent));
}

int qt6cr_dialog_exec(qt6cr_handle_t handle) {
  auto *dialog = as_dialog(handle);
  return dialog == nullptr ? 0 : dialog->exec();
}

void qt6cr_dialog_accept(qt6cr_handle_t handle) {
  auto *dialog = as_dialog(handle);

  if (dialog != nullptr) {
    dialog->accept();
  }
}

void qt6cr_dialog_reject(qt6cr_handle_t handle) {
  auto *dialog = as_dialog(handle);

  if (dialog != nullptr) {
    dialog->reject();
  }
}

int qt6cr_dialog_result(qt6cr_handle_t handle) {
  auto *dialog = as_dialog(handle);
  return dialog == nullptr ? 0 : dialog->result();
}

void qt6cr_dialog_on_accepted(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *dialog = as_dialog(handle);

  if (dialog == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(dialog, &QDialog::accepted, dialog, [callback, userdata]() {
    callback(userdata);
  });
}

void qt6cr_dialog_on_rejected(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *dialog = as_dialog(handle);

  if (dialog == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(dialog, &QDialog::rejected, dialog, [callback, userdata]() {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_message_box_create(qt6cr_handle_t parent) {
  return new QMessageBox(as_widget(parent));
}

int qt6cr_message_box_exec(qt6cr_handle_t handle) {
  auto *message_box = as_message_box(handle);
  return message_box == nullptr ? 0 : static_cast<int>(message_box->exec());
}

void qt6cr_message_box_set_icon(qt6cr_handle_t handle, int icon) {
  auto *message_box = as_message_box(handle);

  if (message_box != nullptr) {
    message_box->setIcon(static_cast<QMessageBox::Icon>(icon));
  }
}

int qt6cr_message_box_icon(qt6cr_handle_t handle) {
  auto *message_box = as_message_box(handle);
  return message_box == nullptr ? 0 : static_cast<int>(message_box->icon());
}

void qt6cr_message_box_set_text(qt6cr_handle_t handle, const char *text) {
  auto *message_box = as_message_box(handle);

  if (message_box != nullptr) {
    message_box->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_message_box_text(qt6cr_handle_t handle) {
  auto *message_box = as_message_box(handle);
  return message_box == nullptr ? duplicate_string("") : duplicate_string(message_box->text());
}

void qt6cr_message_box_set_informative_text(qt6cr_handle_t handle, const char *text) {
  auto *message_box = as_message_box(handle);

  if (message_box != nullptr) {
    message_box->setInformativeText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_message_box_informative_text(qt6cr_handle_t handle) {
  auto *message_box = as_message_box(handle);
  return message_box == nullptr ? duplicate_string("") : duplicate_string(message_box->informativeText());
}

void qt6cr_message_box_set_standard_buttons(qt6cr_handle_t handle, int buttons) {
  auto *message_box = as_message_box(handle);

  if (message_box != nullptr) {
    message_box->setStandardButtons(static_cast<QMessageBox::StandardButtons>(buttons));
  }
}

int qt6cr_message_box_standard_buttons(qt6cr_handle_t handle) {
  auto *message_box = as_message_box(handle);
  return message_box == nullptr ? 0 : static_cast<int>(message_box->standardButtons());
}

qt6cr_handle_t qt6cr_file_dialog_create(qt6cr_handle_t parent, const char *directory, const char *filter) {
  return new QFileDialog(as_widget(parent), QString(), QString::fromUtf8(directory == nullptr ? "" : directory), QString::fromUtf8(filter == nullptr ? "" : filter));
}

void qt6cr_file_dialog_set_accept_mode(qt6cr_handle_t handle, int accept_mode) {
  auto *file_dialog = as_file_dialog(handle);

  if (file_dialog != nullptr) {
    file_dialog->setAcceptMode(static_cast<QFileDialog::AcceptMode>(accept_mode));
  }
}

int qt6cr_file_dialog_accept_mode(qt6cr_handle_t handle) {
  auto *file_dialog = as_file_dialog(handle);
  return file_dialog == nullptr ? 0 : static_cast<int>(file_dialog->acceptMode());
}

void qt6cr_file_dialog_set_file_mode(qt6cr_handle_t handle, int file_mode) {
  auto *file_dialog = as_file_dialog(handle);

  if (file_dialog != nullptr) {
    file_dialog->setFileMode(static_cast<QFileDialog::FileMode>(file_mode));
  }
}

int qt6cr_file_dialog_file_mode(qt6cr_handle_t handle) {
  auto *file_dialog = as_file_dialog(handle);
  return file_dialog == nullptr ? 0 : static_cast<int>(file_dialog->fileMode());
}

void qt6cr_file_dialog_set_directory(qt6cr_handle_t handle, const char *directory) {
  auto *file_dialog = as_file_dialog(handle);

  if (file_dialog != nullptr) {
    file_dialog->setDirectory(QString::fromUtf8(directory == nullptr ? "" : directory));
  }
}

char *qt6cr_file_dialog_directory(qt6cr_handle_t handle) {
  auto *file_dialog = as_file_dialog(handle);
  return file_dialog == nullptr ? duplicate_string("") : duplicate_string(file_dialog->directory().absolutePath());
}

void qt6cr_file_dialog_set_name_filter(qt6cr_handle_t handle, const char *filter) {
  auto *file_dialog = as_file_dialog(handle);

  if (file_dialog != nullptr) {
    file_dialog->setNameFilter(QString::fromUtf8(filter == nullptr ? "" : filter));
  }
}

char *qt6cr_file_dialog_name_filter(qt6cr_handle_t handle) {
  auto *file_dialog = as_file_dialog(handle);
  return file_dialog == nullptr ? duplicate_string("") : duplicate_string(file_dialog->nameFilters().join(QStringLiteral(";;")));
}

void qt6cr_file_dialog_select_file(qt6cr_handle_t handle, const char *path) {
  auto *file_dialog = as_file_dialog(handle);

  if (file_dialog != nullptr) {
    file_dialog->selectFile(QString::fromUtf8(path == nullptr ? "" : path));
  }
}

char *qt6cr_file_dialog_selected_file(qt6cr_handle_t handle) {
  auto *file_dialog = as_file_dialog(handle);
  return file_dialog == nullptr ? duplicate_string("") : duplicate_string(file_dialog->selectedFiles().value(0));
}

qt6cr_handle_t qt6cr_color_dialog_create(qt6cr_handle_t parent) {
  return new QColorDialog(as_widget(parent));
}

void qt6cr_color_dialog_set_current_color(qt6cr_handle_t handle, qt6cr_color_t color) {
  auto *color_dialog = as_color_dialog(handle);

  if (color_dialog != nullptr) {
    color_dialog->setCurrentColor(QColor(color.red, color.green, color.blue, color.alpha));
  }
}

qt6cr_color_t qt6cr_color_dialog_current_color(qt6cr_handle_t handle) {
  auto *color_dialog = as_color_dialog(handle);
  return color_dialog == nullptr ? qt6cr_color_t{0, 0, 0, 255} : to_color(color_dialog->currentColor());
}

void qt6cr_color_dialog_set_native_dialog(qt6cr_handle_t handle, bool value) {
  auto *color_dialog = as_color_dialog(handle);

  if (color_dialog != nullptr) {
    color_dialog->setOption(QColorDialog::DontUseNativeDialog, !value);
  }
}

bool qt6cr_color_dialog_native_dialog(qt6cr_handle_t handle) {
  auto *color_dialog = as_color_dialog(handle);
  return color_dialog != nullptr && !color_dialog->testOption(QColorDialog::DontUseNativeDialog);
}

void qt6cr_color_dialog_set_show_alpha_channel(qt6cr_handle_t handle, bool value) {
  auto *color_dialog = as_color_dialog(handle);

  if (color_dialog != nullptr) {
    color_dialog->setOption(QColorDialog::ShowAlphaChannel, value);
  }
}

bool qt6cr_color_dialog_show_alpha_channel(qt6cr_handle_t handle) {
  auto *color_dialog = as_color_dialog(handle);
  return color_dialog != nullptr && color_dialog->testOption(QColorDialog::ShowAlphaChannel);
}

qt6cr_handle_t qt6cr_qimage_create(int width, int height, int format) {
  return new QImage(width, height, image_format_from_int(format));
}

qt6cr_handle_t qt6cr_qimage_create_from_file(const char *path) {
  return new QImage(QString::fromUtf8(path == nullptr ? "" : path));
}

void qt6cr_qimage_destroy(qt6cr_handle_t handle) {
  delete as_qimage(handle);
}

int qt6cr_qimage_width(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image == nullptr ? 0 : image->width();
}

int qt6cr_qimage_height(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image == nullptr ? 0 : image->height();
}

bool qt6cr_qimage_is_null(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image == nullptr || image->isNull();
}

void qt6cr_qimage_fill(qt6cr_handle_t handle, qt6cr_color_t color) {
  auto *image = as_qimage(handle);

  if (image != nullptr) {
    image->fill(from_color(color));
  }
}

bool qt6cr_qimage_load(qt6cr_handle_t handle, const char *path) {
  auto *image = as_qimage(handle);
  return image != nullptr && image->load(QString::fromUtf8(path == nullptr ? "" : path));
}

bool qt6cr_qimage_save(qt6cr_handle_t handle, const char *path) {
  auto *image = as_qimage(handle);
  return image != nullptr && image->save(QString::fromUtf8(path == nullptr ? "" : path));
}

qt6cr_color_t qt6cr_qimage_pixel_color(qt6cr_handle_t handle, int x, int y) {
  auto *image = as_qimage(handle);
  return image == nullptr ? qt6cr_color_t{0, 0, 0, 0} : to_color(image->pixelColor(x, y));
}

void qt6cr_qimage_set_pixel_color(qt6cr_handle_t handle, int x, int y, qt6cr_color_t color) {
  auto *image = as_qimage(handle);

  if (image != nullptr) {
    image->setPixelColor(x, y, from_color(color));
  }
}

qt6cr_handle_t qt6cr_qpixmap_create(int width, int height) {
  return new QPixmap(width, height);
}

qt6cr_handle_t qt6cr_qpixmap_create_from_file(const char *path) {
  return new QPixmap(QString::fromUtf8(path == nullptr ? "" : path));
}

void qt6cr_qpixmap_destroy(qt6cr_handle_t handle) {
  delete as_qpixmap(handle);
}

qt6cr_handle_t qt6cr_qpixmap_from_image(qt6cr_handle_t image) {
  auto *source = as_qimage(image);
  return source == nullptr ? nullptr : new QPixmap(QPixmap::fromImage(*source));
}

qt6cr_handle_t qt6cr_qpixmap_to_image(qt6cr_handle_t handle) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr ? nullptr : new QImage(pixmap->toImage());
}

int qt6cr_qpixmap_width(qt6cr_handle_t handle) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr ? 0 : pixmap->width();
}

int qt6cr_qpixmap_height(qt6cr_handle_t handle) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr ? 0 : pixmap->height();
}

bool qt6cr_qpixmap_is_null(qt6cr_handle_t handle) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr || pixmap->isNull();
}

void qt6cr_qpixmap_fill(qt6cr_handle_t handle, qt6cr_color_t color) {
  auto *pixmap = as_qpixmap(handle);

  if (pixmap != nullptr) {
    pixmap->fill(from_color(color));
  }
}

bool qt6cr_qpixmap_load(qt6cr_handle_t handle, const char *path) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap != nullptr && pixmap->load(QString::fromUtf8(path == nullptr ? "" : path));
}

bool qt6cr_qpixmap_save(qt6cr_handle_t handle, const char *path) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap != nullptr && pixmap->save(QString::fromUtf8(path == nullptr ? "" : path));
}

qt6cr_handle_t qt6cr_model_index_create(void) {
  return new QModelIndex();
}

void qt6cr_model_index_destroy(qt6cr_handle_t handle) {
  delete as_model_index(handle);
}

bool qt6cr_model_index_is_valid(qt6cr_handle_t handle) {
  auto *index = as_model_index(handle);
  return index != nullptr && index->isValid();
}

int qt6cr_model_index_row(qt6cr_handle_t handle) {
  auto *index = as_model_index(handle);
  return index == nullptr ? -1 : index->row();
}

int qt6cr_model_index_column(qt6cr_handle_t handle) {
  auto *index = as_model_index(handle);
  return index == nullptr ? -1 : index->column();
}

int qt6cr_abstract_item_model_row_count(qt6cr_handle_t handle, qt6cr_handle_t parent_index) {
  auto *model = as_abstract_item_model(handle);
  auto *parent = as_model_index(parent_index);
  return model == nullptr ? 0 : model->rowCount(parent == nullptr ? QModelIndex() : *parent);
}

int qt6cr_abstract_item_model_column_count(qt6cr_handle_t handle, qt6cr_handle_t parent_index) {
  auto *model = as_abstract_item_model(handle);
  auto *parent = as_model_index(parent_index);
  return model == nullptr ? 0 : model->columnCount(parent == nullptr ? QModelIndex() : *parent);
}

qt6cr_handle_t qt6cr_abstract_item_model_index(qt6cr_handle_t handle, int row, int column, qt6cr_handle_t parent_index) {
  auto *model = as_abstract_item_model(handle);
  auto *parent = as_model_index(parent_index);

  if (model == nullptr) {
    return new QModelIndex();
  }

  return new QModelIndex(model->index(row, column, parent == nullptr ? QModelIndex() : *parent));
}

qt6cr_variant_value_t qt6cr_abstract_item_model_data(qt6cr_handle_t handle, qt6cr_handle_t index, int role) {
  auto *model = as_abstract_item_model(handle);
  auto *model_index = as_model_index(index);

  if (model == nullptr || model_index == nullptr) {
    return to_variant_value(QVariant());
  }

  return to_variant_value(model->data(*model_index, role));
}

bool qt6cr_abstract_item_model_set_data(qt6cr_handle_t handle, qt6cr_handle_t index, qt6cr_variant_value_t value, int role) {
  auto *model = as_abstract_item_model(handle);
  auto *model_index = as_model_index(index);
  return model != nullptr && model_index != nullptr ? model->setData(*model_index, from_variant_value(value), role) : false;
}

qt6cr_handle_t qt6cr_standard_item_create(const char *text) {
  return new QStandardItem(QString::fromUtf8(text == nullptr ? "" : text));
}

void qt6cr_standard_item_destroy(qt6cr_handle_t handle) {
  delete as_standard_item(handle);
}

char *qt6cr_standard_item_text(qt6cr_handle_t handle) {
  auto *item = as_standard_item(handle);
  return item == nullptr ? duplicate_string("") : duplicate_string(item->text());
}

void qt6cr_standard_item_set_text(qt6cr_handle_t handle, const char *text) {
  auto *item = as_standard_item(handle);

  if (item != nullptr) {
    item->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

qt6cr_variant_value_t qt6cr_standard_item_data(qt6cr_handle_t handle, int role) {
  auto *item = as_standard_item(handle);
  return item == nullptr ? to_variant_value(QVariant()) : to_variant_value(item->data(role));
}

bool qt6cr_standard_item_set_data(qt6cr_handle_t handle, qt6cr_variant_value_t value, int role) {
  auto *item = as_standard_item(handle);

  if (item == nullptr) {
    return false;
  }

  item->setData(from_variant_value(value), role);
  return true;
}

void qt6cr_standard_item_append_row(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *parent_item = as_standard_item(handle);
  auto *child_item = as_standard_item(item);

  if (parent_item != nullptr && child_item != nullptr) {
    parent_item->appendRow(child_item);
  }
}

void qt6cr_standard_item_set_child(qt6cr_handle_t handle, int row, int column, qt6cr_handle_t item) {
  auto *parent_item = as_standard_item(handle);
  auto *child_item = as_standard_item(item);

  if (parent_item != nullptr && child_item != nullptr && row >= 0 && column >= 0) {
    parent_item->setChild(row, column, child_item);
  }
}

qt6cr_handle_t qt6cr_standard_item_child(qt6cr_handle_t handle, int row, int column) {
  auto *item = as_standard_item(handle);
  return item == nullptr ? nullptr : item->child(row, column);
}

int qt6cr_standard_item_row_count(qt6cr_handle_t handle) {
  auto *item = as_standard_item(handle);
  return item == nullptr ? 0 : item->rowCount();
}

int qt6cr_standard_item_column_count(qt6cr_handle_t handle) {
  auto *item = as_standard_item(handle);
  return item == nullptr ? 0 : item->columnCount();
}

qt6cr_handle_t qt6cr_standard_item_model_create(qt6cr_handle_t parent) {
  return new QStandardItemModel(as_object(parent));
}

void qt6cr_standard_item_model_clear(qt6cr_handle_t handle) {
  auto *model = as_standard_item_model(handle);

  if (model != nullptr) {
    model->clear();
  }
}

int qt6cr_standard_item_model_row_count(qt6cr_handle_t handle, qt6cr_handle_t parent_index) {
  auto *model = as_standard_item_model(handle);
  auto *parent = as_model_index(parent_index);
  return model == nullptr ? 0 : model->rowCount(parent == nullptr ? QModelIndex() : *parent);
}

int qt6cr_standard_item_model_column_count(qt6cr_handle_t handle, qt6cr_handle_t parent_index) {
  auto *model = as_standard_item_model(handle);
  auto *parent = as_model_index(parent_index);
  return model == nullptr ? 0 : model->columnCount(parent == nullptr ? QModelIndex() : *parent);
}

void qt6cr_standard_item_model_append_row(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *model = as_standard_item_model(handle);
  auto *standard_item = as_standard_item(item);

  if (model != nullptr && standard_item != nullptr) {
    model->appendRow(standard_item);
  }
}

void qt6cr_standard_item_model_set_item(qt6cr_handle_t handle, int row, int column, qt6cr_handle_t item) {
  auto *model = as_standard_item_model(handle);
  auto *standard_item = as_standard_item(item);

  if (model != nullptr && standard_item != nullptr && row >= 0 && column >= 0) {
    model->setItem(row, column, standard_item);
  }
}

qt6cr_handle_t qt6cr_standard_item_model_item(qt6cr_handle_t handle, int row, int column) {
  auto *model = as_standard_item_model(handle);
  return model == nullptr ? nullptr : model->item(row, column);
}

void qt6cr_standard_item_model_set_horizontal_header_label(qt6cr_handle_t handle, int column, const char *text) {
  auto *model = as_standard_item_model(handle);

  if (model == nullptr || column < 0) {
    return;
  }

  if (model->columnCount() <= column) {
    model->setColumnCount(column + 1);
  }

  model->setHeaderData(column, Qt::Horizontal, QString::fromUtf8(text == nullptr ? "" : text));
}

char *qt6cr_standard_item_model_horizontal_header_label(qt6cr_handle_t handle, int column) {
  auto *model = as_standard_item_model(handle);

  if (model == nullptr || column < 0) {
    return duplicate_string("");
  }

  return duplicate_string(model->headerData(column, Qt::Horizontal).toString());
}

qt6cr_handle_t qt6cr_standard_item_model_index(qt6cr_handle_t handle, int row, int column, qt6cr_handle_t parent_index) {
  return qt6cr_abstract_item_model_index(handle, row, column, parent_index);
}

qt6cr_handle_t qt6cr_standard_item_model_item_from_index(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *model = as_standard_item_model(handle);
  auto *model_index = as_model_index(index);
  return model == nullptr || model_index == nullptr ? nullptr : model->itemFromIndex(*model_index);
}

qt6cr_handle_t qt6cr_standard_item_model_index_from_item(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *model = as_standard_item_model(handle);
  auto *standard_item = as_standard_item(item);

  if (model == nullptr || standard_item == nullptr) {
    return new QModelIndex();
  }

  return new QModelIndex(model->indexFromItem(standard_item));
}

qt6cr_handle_t qt6cr_sort_filter_proxy_model_create(qt6cr_handle_t parent) {
  return new QSortFilterProxyModel(as_object(parent));
}

void qt6cr_sort_filter_proxy_model_set_source_model(qt6cr_handle_t handle, qt6cr_handle_t model) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setSourceModel(as_abstract_item_model(model));
  }
}

qt6cr_handle_t qt6cr_sort_filter_proxy_model_source_model(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? nullptr : proxy->sourceModel();
}

qt6cr_handle_t qt6cr_sort_filter_proxy_model_map_to_source(qt6cr_handle_t handle, qt6cr_handle_t proxy_index) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  auto *index = as_model_index(proxy_index);

  if (proxy == nullptr || index == nullptr) {
    return new QModelIndex();
  }

  return new QModelIndex(proxy->mapToSource(*index));
}

qt6cr_handle_t qt6cr_sort_filter_proxy_model_map_from_source(qt6cr_handle_t handle, qt6cr_handle_t source_index) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  auto *index = as_model_index(source_index);

  if (proxy == nullptr || index == nullptr) {
    return new QModelIndex();
  }

  return new QModelIndex(proxy->mapFromSource(*index));
}

void qt6cr_sort_filter_proxy_model_sort(qt6cr_handle_t handle, int column, int order) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->sort(column, static_cast<Qt::SortOrder>(order));
  }
}

void qt6cr_sort_filter_proxy_model_set_filter_fixed_string(qt6cr_handle_t handle, const char *value) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setFilterFixedString(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

void qt6cr_sort_filter_proxy_model_set_filter_wildcard(qt6cr_handle_t handle, const char *value) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setFilterWildcard(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

void qt6cr_sort_filter_proxy_model_set_filter_key_column(qt6cr_handle_t handle, int column) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setFilterKeyColumn(column);
  }
}

int qt6cr_sort_filter_proxy_model_filter_key_column(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? 0 : proxy->filterKeyColumn();
}

void qt6cr_sort_filter_proxy_model_set_filter_role(qt6cr_handle_t handle, int role) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setFilterRole(role);
  }
}

int qt6cr_sort_filter_proxy_model_filter_role(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? 0 : proxy->filterRole();
}

void qt6cr_sort_filter_proxy_model_set_sort_role(qt6cr_handle_t handle, int role) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setSortRole(role);
  }
}

int qt6cr_sort_filter_proxy_model_sort_role(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? 0 : proxy->sortRole();
}

void qt6cr_sort_filter_proxy_model_set_filter_case_sensitivity(qt6cr_handle_t handle, int sensitivity) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setFilterCaseSensitivity(static_cast<Qt::CaseSensitivity>(sensitivity));
  }
}

int qt6cr_sort_filter_proxy_model_filter_case_sensitivity(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? 0 : static_cast<int>(proxy->filterCaseSensitivity());
}

void qt6cr_sort_filter_proxy_model_set_dynamic_sort_filter(qt6cr_handle_t handle, bool value) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setDynamicSortFilter(value);
  }
}

bool qt6cr_sort_filter_proxy_model_dynamic_sort_filter(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? false : proxy->dynamicSortFilter();
}

void qt6cr_sort_filter_proxy_model_set_recursive_filtering_enabled(qt6cr_handle_t handle, bool value) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setRecursiveFilteringEnabled(value);
  }
}

bool qt6cr_sort_filter_proxy_model_recursive_filtering_enabled(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? false : proxy->isRecursiveFilteringEnabled();
}

void qt6cr_sort_filter_proxy_model_invalidate(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->invalidate();
  }
}

qt6cr_handle_t qt6cr_styled_item_delegate_create(qt6cr_handle_t parent) {
  return new CrystalStyledItemDelegate(as_object(parent));
}

void qt6cr_styled_item_delegate_on_display_text(qt6cr_handle_t handle, qt6cr_string_transform_callback_t callback, void *userdata) {
  auto *delegate = as_styled_item_delegate(handle);

  if (delegate == nullptr) {
    return;
  }

  delegate->display_text_callback = callback;
  delegate->display_text_userdata = userdata;
}

char *qt6cr_styled_item_delegate_display_text(qt6cr_handle_t handle, qt6cr_variant_value_t value) {
  auto *delegate = as_styled_item_delegate(handle);
  return delegate == nullptr ? duplicate_string("") : duplicate_string(delegate->displayText(from_variant_value(value), QLocale()));
}

qt6cr_handle_t qt6cr_list_view_create(qt6cr_handle_t parent) {
  return new ModelListView(as_widget(parent));
}

void qt6cr_list_view_set_model(qt6cr_handle_t handle, qt6cr_handle_t model) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setModel(as_abstract_item_model(model));
  }
}

void qt6cr_list_view_set_item_delegate(qt6cr_handle_t handle, qt6cr_handle_t delegate) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setItemDelegate(as_styled_item_delegate(delegate));
  }
}

qt6cr_handle_t qt6cr_list_view_current_index(qt6cr_handle_t handle) {
  auto *view = as_list_view(handle);
  return view == nullptr ? new QModelIndex() : new QModelIndex(view->currentIndex());
}

void qt6cr_list_view_set_current_index(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_list_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr) {
    view->setCurrentIndex(model_index == nullptr ? QModelIndex() : *model_index);
  }
}

void qt6cr_list_view_on_current_index_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *view = as_list_view(handle);

  if (view == nullptr) {
    return;
  }

  view->current_index_changed_callback = callback;
  view->current_index_changed_userdata = userdata;
  view->reconnect_current_changed();
}

qt6cr_handle_t qt6cr_tree_view_create(qt6cr_handle_t parent) {
  return new ModelTreeView(as_widget(parent));
}

void qt6cr_tree_view_set_model(qt6cr_handle_t handle, qt6cr_handle_t model) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setModel(as_abstract_item_model(model));
  }
}

void qt6cr_tree_view_set_item_delegate(qt6cr_handle_t handle, qt6cr_handle_t delegate) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setItemDelegate(as_styled_item_delegate(delegate));
  }
}

qt6cr_handle_t qt6cr_tree_view_current_index(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view == nullptr ? new QModelIndex() : new QModelIndex(view->currentIndex());
}

void qt6cr_tree_view_set_current_index(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_tree_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr) {
    view->setCurrentIndex(model_index == nullptr ? QModelIndex() : *model_index);
  }
}

void qt6cr_tree_view_expand_all(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->expandAll();
  }
}

void qt6cr_tree_view_collapse_all(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->collapseAll();
  }
}

void qt6cr_tree_view_on_current_index_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *view = as_tree_view(handle);

  if (view == nullptr) {
    return;
  }

  view->current_index_changed_callback = callback;
  view->current_index_changed_userdata = userdata;
  view->reconnect_current_changed();
}

qt6cr_handle_t qt6cr_qsvg_generator_create(void) {
  return new QSvgGenerator();
}

void qt6cr_qsvg_generator_destroy(qt6cr_handle_t handle) {
  delete as_qsvg_generator(handle);
}

char *qt6cr_qsvg_generator_file_name(qt6cr_handle_t handle) {
  auto *generator = as_qsvg_generator(handle);
  return generator == nullptr ? duplicate_string("") : duplicate_string(generator->fileName());
}

void qt6cr_qsvg_generator_set_file_name(qt6cr_handle_t handle, const char *file_name) {
  auto *generator = as_qsvg_generator(handle);

  if (generator != nullptr) {
    generator->setFileName(QString::fromUtf8(file_name == nullptr ? "" : file_name));
  }
}

qt6cr_size_t qt6cr_qsvg_generator_size(qt6cr_handle_t handle) {
  auto *generator = as_qsvg_generator(handle);
  return generator == nullptr ? qt6cr_size_t{0, 0} : to_size(generator->size());
}

void qt6cr_qsvg_generator_set_size(qt6cr_handle_t handle, qt6cr_size_t size) {
  auto *generator = as_qsvg_generator(handle);

  if (generator != nullptr) {
    generator->setSize(QSize(size.width, size.height));
  }
}

qt6cr_rectf_t qt6cr_qsvg_generator_view_box(qt6cr_handle_t handle) {
  auto *generator = as_qsvg_generator(handle);
  return generator == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(generator->viewBox());
}

void qt6cr_qsvg_generator_set_view_box(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *generator = as_qsvg_generator(handle);

  if (generator != nullptr) {
    generator->setViewBox(from_rect(rect));
  }
}

char *qt6cr_qsvg_generator_title(qt6cr_handle_t handle) {
  auto *generator = as_qsvg_generator(handle);
  return generator == nullptr ? duplicate_string("") : duplicate_string(generator->title());
}

void qt6cr_qsvg_generator_set_title(qt6cr_handle_t handle, const char *title) {
  auto *generator = as_qsvg_generator(handle);

  if (generator != nullptr) {
    generator->setTitle(QString::fromUtf8(title == nullptr ? "" : title));
  }
}

char *qt6cr_qsvg_generator_description(qt6cr_handle_t handle) {
  auto *generator = as_qsvg_generator(handle);
  return generator == nullptr ? duplicate_string("") : duplicate_string(generator->description());
}

void qt6cr_qsvg_generator_set_description(qt6cr_handle_t handle, const char *description) {
  auto *generator = as_qsvg_generator(handle);

  if (generator != nullptr) {
    generator->setDescription(QString::fromUtf8(description == nullptr ? "" : description));
  }
}

int qt6cr_qsvg_generator_resolution(qt6cr_handle_t handle) {
  auto *generator = as_qsvg_generator(handle);
  return generator == nullptr ? 0 : generator->resolution();
}

void qt6cr_qsvg_generator_set_resolution(qt6cr_handle_t handle, int resolution) {
  auto *generator = as_qsvg_generator(handle);

  if (generator != nullptr) {
    generator->setResolution(resolution);
  }
}

qt6cr_handle_t qt6cr_qsvg_renderer_create(const char *file_name) {
  if (file_name == nullptr || file_name[0] == '\0') {
    return new QSvgRenderer();
  }

  return new QSvgRenderer(QString::fromUtf8(file_name));
}

qt6cr_handle_t qt6cr_qsvg_renderer_create_from_data(const unsigned char *data, int size) {
  const auto bytes = byte_array_from_data(data, size);

  if (bytes.isEmpty()) {
    return new QSvgRenderer();
  }

  return new QSvgRenderer(bytes);
}

void qt6cr_qsvg_renderer_destroy(qt6cr_handle_t handle) {
  delete as_qsvg_renderer(handle);
}

bool qt6cr_qsvg_renderer_is_valid(qt6cr_handle_t handle) {
  auto *renderer = as_qsvg_renderer(handle);
  return renderer != nullptr && renderer->isValid();
}

bool qt6cr_qsvg_renderer_load(qt6cr_handle_t handle, const char *file_name) {
  auto *renderer = as_qsvg_renderer(handle);
  return renderer != nullptr && renderer->load(QString::fromUtf8(file_name == nullptr ? "" : file_name));
}

bool qt6cr_qsvg_renderer_load_data(qt6cr_handle_t handle, const unsigned char *data, int size) {
  auto *renderer = as_qsvg_renderer(handle);
  return renderer != nullptr && renderer->load(byte_array_from_data(data, size));
}

qt6cr_size_t qt6cr_qsvg_renderer_default_size(qt6cr_handle_t handle) {
  auto *renderer = as_qsvg_renderer(handle);
  return renderer == nullptr ? qt6cr_size_t{0, 0} : to_size(renderer->defaultSize());
}

qt6cr_rectf_t qt6cr_qsvg_renderer_view_box(qt6cr_handle_t handle) {
  auto *renderer = as_qsvg_renderer(handle);
  return renderer == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(renderer->viewBoxF());
}

void qt6cr_qsvg_renderer_set_view_box(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *renderer = as_qsvg_renderer(handle);

  if (renderer != nullptr) {
    renderer->setViewBox(from_rectf(rect));
  }
}

bool qt6cr_qsvg_renderer_element_exists(qt6cr_handle_t handle, const char *element_id) {
  auto *renderer = as_qsvg_renderer(handle);
  return renderer != nullptr && renderer->elementExists(QString::fromUtf8(element_id == nullptr ? "" : element_id));
}

qt6cr_rectf_t qt6cr_qsvg_renderer_bounds_on_element(qt6cr_handle_t handle, const char *element_id) {
  auto *renderer = as_qsvg_renderer(handle);
  return renderer == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(renderer->boundsOnElement(QString::fromUtf8(element_id == nullptr ? "" : element_id)));
}

void qt6cr_qsvg_renderer_render(qt6cr_handle_t handle, qt6cr_handle_t painter) {
  auto *renderer = as_qsvg_renderer(handle);
  auto *target = as_qpainter(painter);

  if (renderer != nullptr && target != nullptr) {
    renderer->render(target);
  }
}

void qt6cr_qsvg_renderer_render_with_bounds(qt6cr_handle_t handle, qt6cr_handle_t painter, qt6cr_rectf_t bounds) {
  auto *renderer = as_qsvg_renderer(handle);
  auto *target = as_qpainter(painter);

  if (renderer != nullptr && target != nullptr) {
    renderer->render(target, from_rectf(bounds));
  }
}

void qt6cr_qsvg_renderer_render_element(qt6cr_handle_t handle, qt6cr_handle_t painter, const char *element_id) {
  auto *renderer = as_qsvg_renderer(handle);
  auto *target = as_qpainter(painter);

  if (renderer != nullptr && target != nullptr) {
    renderer->render(target, QString::fromUtf8(element_id == nullptr ? "" : element_id));
  }
}

void qt6cr_qsvg_renderer_render_element_with_bounds(qt6cr_handle_t handle, qt6cr_handle_t painter, const char *element_id, qt6cr_rectf_t bounds) {
  auto *renderer = as_qsvg_renderer(handle);
  auto *target = as_qpainter(painter);

  if (renderer != nullptr && target != nullptr) {
    renderer->render(target, QString::fromUtf8(element_id == nullptr ? "" : element_id), from_rectf(bounds));
  }
}

qt6cr_handle_t qt6cr_qsvg_widget_create(qt6cr_handle_t parent, const char *file_name) {
  auto *widget_parent = as_widget(parent);

  if (file_name == nullptr || file_name[0] == '\0') {
    return new QSvgWidget(widget_parent);
  }

  return new QSvgWidget(QString::fromUtf8(file_name), widget_parent);
}

void qt6cr_qsvg_widget_load(qt6cr_handle_t handle, const char *file_name) {
  auto *widget = as_qsvg_widget(handle);

  if (widget != nullptr) {
    widget->load(QString::fromUtf8(file_name == nullptr ? "" : file_name));
  }
}

void qt6cr_qsvg_widget_load_data(qt6cr_handle_t handle, const unsigned char *data, int size) {
  auto *widget = as_qsvg_widget(handle);

  if (widget != nullptr) {
    widget->load(byte_array_from_data(data, size));
  }
}

qt6cr_handle_t qt6cr_qsvg_widget_renderer(qt6cr_handle_t handle) {
  auto *widget = as_qsvg_widget(handle);
  return widget == nullptr ? nullptr : widget->renderer();
}

qt6cr_size_t qt6cr_qsvg_widget_size_hint(qt6cr_handle_t handle) {
  auto *widget = as_qsvg_widget(handle);
  return widget == nullptr ? qt6cr_size_t{0, 0} : to_size(widget->sizeHint());
}

qt6cr_handle_t qt6cr_qpdf_writer_create(const char *file_name) {
  return new QPdfWriter(QString::fromUtf8(file_name == nullptr ? "" : file_name));
}

void qt6cr_qpdf_writer_destroy(qt6cr_handle_t handle) {
  delete as_qpdf_writer(handle);
}

void qt6cr_qpdf_writer_set_title(qt6cr_handle_t handle, const char *title) {
  auto *writer = as_qpdf_writer(handle);

  if (writer != nullptr) {
    writer->setTitle(QString::fromUtf8(title == nullptr ? "" : title));
  }
}

void qt6cr_qpdf_writer_set_creator(qt6cr_handle_t handle, const char *creator) {
  auto *writer = as_qpdf_writer(handle);

  if (writer != nullptr) {
    writer->setCreator(QString::fromUtf8(creator == nullptr ? "" : creator));
  }
}

int qt6cr_qpdf_writer_resolution(qt6cr_handle_t handle) {
  auto *writer = as_qpdf_writer(handle);
  return writer == nullptr ? 0 : writer->resolution();
}

void qt6cr_qpdf_writer_set_resolution(qt6cr_handle_t handle, int resolution) {
  auto *writer = as_qpdf_writer(handle);

  if (writer != nullptr) {
    writer->setResolution(resolution);
  }
}

void qt6cr_qpdf_writer_set_page_size_points(qt6cr_handle_t handle, int width, int height) {
  auto *writer = as_qpdf_writer(handle);

  if (writer != nullptr && width > 0 && height > 0) {
    writer->setPageSize(QPageSize(QSizeF(width, height), QPageSize::Point, QString(), QPageSize::ExactMatch));
  }
}

bool qt6cr_qpdf_writer_new_page(qt6cr_handle_t handle) {
  auto *writer = as_qpdf_writer(handle);
  return writer != nullptr && writer->newPage();
}

qt6cr_handle_t qt6cr_qpen_create(qt6cr_color_t color, double width) {
  auto pen = QPen(from_color(color));
  pen.setWidthF(width);
  return new QPen(pen);
}

void qt6cr_qpen_destroy(qt6cr_handle_t handle) {
  delete as_qpen(handle);
}

qt6cr_color_t qt6cr_qpen_color(qt6cr_handle_t handle) {
  auto *pen = as_qpen(handle);
  return pen == nullptr ? qt6cr_color_t{0, 0, 0, 255} : to_color(pen->color());
}

void qt6cr_qpen_set_color(qt6cr_handle_t handle, qt6cr_color_t color) {
  auto *pen = as_qpen(handle);

  if (pen != nullptr) {
    pen->setColor(from_color(color));
  }
}

double qt6cr_qpen_width(qt6cr_handle_t handle) {
  auto *pen = as_qpen(handle);
  return pen == nullptr ? 0.0 : pen->widthF();
}

void qt6cr_qpen_set_width(qt6cr_handle_t handle, double width) {
  auto *pen = as_qpen(handle);

  if (pen != nullptr) {
    pen->setWidthF(width);
  }
}

qt6cr_handle_t qt6cr_qbrush_create(qt6cr_color_t color) {
  return new QBrush(from_color(color));
}

void qt6cr_qbrush_destroy(qt6cr_handle_t handle) {
  delete as_qbrush(handle);
}

qt6cr_color_t qt6cr_qbrush_color(qt6cr_handle_t handle) {
  auto *brush = as_qbrush(handle);
  return brush == nullptr ? qt6cr_color_t{0, 0, 0, 255} : to_color(brush->color());
}

void qt6cr_qbrush_set_color(qt6cr_handle_t handle, qt6cr_color_t color) {
  auto *brush = as_qbrush(handle);

  if (brush != nullptr) {
    brush->setColor(from_color(color));
  }
}

qt6cr_handle_t qt6cr_qfont_create(const char *family, int point_size, bool bold, bool italic) {
  auto font = QFont(QString::fromUtf8(family == nullptr ? "" : family), point_size);
  font.setBold(bold);
  font.setItalic(italic);
  return new QFont(font);
}

void qt6cr_qfont_destroy(qt6cr_handle_t handle) {
  delete as_qfont(handle);
}

char *qt6cr_qfont_family(qt6cr_handle_t handle) {
  auto *font = as_qfont(handle);
  return font == nullptr ? duplicate_string("") : duplicate_string(font->family());
}

void qt6cr_qfont_set_family(qt6cr_handle_t handle, const char *family) {
  auto *font = as_qfont(handle);

  if (font != nullptr) {
    font->setFamily(QString::fromUtf8(family == nullptr ? "" : family));
  }
}

int qt6cr_qfont_point_size(qt6cr_handle_t handle) {
  auto *font = as_qfont(handle);
  return font == nullptr ? -1 : font->pointSize();
}

void qt6cr_qfont_set_point_size(qt6cr_handle_t handle, int point_size) {
  auto *font = as_qfont(handle);

  if (font != nullptr) {
    font->setPointSize(point_size);
  }
}

bool qt6cr_qfont_bold(qt6cr_handle_t handle) {
  auto *font = as_qfont(handle);
  return font != nullptr && font->bold();
}

void qt6cr_qfont_set_bold(qt6cr_handle_t handle, bool value) {
  auto *font = as_qfont(handle);

  if (font != nullptr) {
    font->setBold(value);
  }
}

bool qt6cr_qfont_italic(qt6cr_handle_t handle) {
  auto *font = as_qfont(handle);
  return font != nullptr && font->italic();
}

void qt6cr_qfont_set_italic(qt6cr_handle_t handle, bool value) {
  auto *font = as_qfont(handle);

  if (font != nullptr) {
    font->setItalic(value);
  }
}

qt6cr_handle_t qt6cr_qfont_metrics_create(qt6cr_handle_t font) {
  auto *value = as_qfont(font);
  return value == nullptr ? nullptr : new QFontMetrics(*value);
}

void qt6cr_qfont_metrics_destroy(qt6cr_handle_t handle) {
  delete as_qfont_metrics(handle);
}

int qt6cr_qfont_metrics_height(qt6cr_handle_t handle) {
  auto *metrics = as_qfont_metrics(handle);
  return metrics == nullptr ? 0 : metrics->height();
}

int qt6cr_qfont_metrics_ascent(qt6cr_handle_t handle) {
  auto *metrics = as_qfont_metrics(handle);
  return metrics == nullptr ? 0 : metrics->ascent();
}

int qt6cr_qfont_metrics_descent(qt6cr_handle_t handle) {
  auto *metrics = as_qfont_metrics(handle);
  return metrics == nullptr ? 0 : metrics->descent();
}

int qt6cr_qfont_metrics_horizontal_advance(qt6cr_handle_t handle, const char *text) {
  auto *metrics = as_qfont_metrics(handle);
  return metrics == nullptr ? 0 : metrics->horizontalAdvance(QString::fromUtf8(text == nullptr ? "" : text));
}

qt6cr_rectf_t qt6cr_qfont_metrics_bounding_rect(qt6cr_handle_t handle, const char *text) {
  auto *metrics = as_qfont_metrics(handle);
  return metrics == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(QRectF(metrics->boundingRect(QString::fromUtf8(text == nullptr ? "" : text))));
}

qt6cr_handle_t qt6cr_qfont_metrics_f_create(qt6cr_handle_t font) {
  auto *value = as_qfont(font);
  return value == nullptr ? nullptr : new QFontMetricsF(*value);
}

void qt6cr_qfont_metrics_f_destroy(qt6cr_handle_t handle) {
  delete as_qfont_metrics_f(handle);
}

double qt6cr_qfont_metrics_f_height(qt6cr_handle_t handle) {
  auto *metrics = as_qfont_metrics_f(handle);
  return metrics == nullptr ? 0.0 : metrics->height();
}

double qt6cr_qfont_metrics_f_ascent(qt6cr_handle_t handle) {
  auto *metrics = as_qfont_metrics_f(handle);
  return metrics == nullptr ? 0.0 : metrics->ascent();
}

double qt6cr_qfont_metrics_f_descent(qt6cr_handle_t handle) {
  auto *metrics = as_qfont_metrics_f(handle);
  return metrics == nullptr ? 0.0 : metrics->descent();
}

double qt6cr_qfont_metrics_f_horizontal_advance(qt6cr_handle_t handle, const char *text) {
  auto *metrics = as_qfont_metrics_f(handle);
  return metrics == nullptr ? 0.0 : metrics->horizontalAdvance(QString::fromUtf8(text == nullptr ? "" : text));
}

qt6cr_rectf_t qt6cr_qfont_metrics_f_bounding_rect(qt6cr_handle_t handle, const char *text) {
  auto *metrics = as_qfont_metrics_f(handle);
  return metrics == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(metrics->boundingRect(QString::fromUtf8(text == nullptr ? "" : text)));
}

qt6cr_handle_t qt6cr_qtransform_create(void) {
  return new QTransform();
}

void qt6cr_qtransform_destroy(qt6cr_handle_t handle) {
  delete as_qtransform(handle);
}

qt6cr_handle_t qt6cr_qtransform_copy(qt6cr_handle_t handle) {
  auto *transform = as_qtransform(handle);
  return transform == nullptr ? nullptr : new QTransform(*transform);
}

void qt6cr_qtransform_reset(qt6cr_handle_t handle) {
  auto *transform = as_qtransform(handle);

  if (transform != nullptr) {
    transform->reset();
  }
}

void qt6cr_qtransform_translate(qt6cr_handle_t handle, double dx, double dy) {
  auto *transform = as_qtransform(handle);

  if (transform != nullptr) {
    transform->translate(dx, dy);
  }
}

void qt6cr_qtransform_scale(qt6cr_handle_t handle, double sx, double sy) {
  auto *transform = as_qtransform(handle);

  if (transform != nullptr) {
    transform->scale(sx, sy);
  }
}

void qt6cr_qtransform_rotate(qt6cr_handle_t handle, double angle) {
  auto *transform = as_qtransform(handle);

  if (transform != nullptr) {
    transform->rotate(angle);
  }
}

qt6cr_pointf_t qt6cr_qtransform_map_point(qt6cr_handle_t handle, qt6cr_pointf_t point) {
  auto *transform = as_qtransform(handle);
  return transform == nullptr ? point : to_pointf(transform->map(from_pointf(point)));
}

qt6cr_rectf_t qt6cr_qtransform_map_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *transform = as_qtransform(handle);
  return transform == nullptr ? rect : to_rectf(transform->mapRect(from_rectf(rect)));
}

qt6cr_handle_t qt6cr_qpainter_path_create(void) {
  return new QPainterPath();
}

void qt6cr_qpainter_path_destroy(qt6cr_handle_t handle) {
  delete as_qpainter_path(handle);
}

void qt6cr_qpainter_path_move_to(qt6cr_handle_t handle, qt6cr_pointf_t point) {
  auto *path = as_qpainter_path(handle);

  if (path != nullptr) {
    path->moveTo(from_pointf(point));
  }
}

void qt6cr_qpainter_path_line_to(qt6cr_handle_t handle, qt6cr_pointf_t point) {
  auto *path = as_qpainter_path(handle);

  if (path != nullptr) {
    path->lineTo(from_pointf(point));
  }
}

void qt6cr_qpainter_path_quad_to(qt6cr_handle_t handle, qt6cr_pointf_t control_point, qt6cr_pointf_t end_point) {
  auto *path = as_qpainter_path(handle);

  if (path != nullptr) {
    path->quadTo(from_pointf(control_point), from_pointf(end_point));
  }
}

void qt6cr_qpainter_path_cubic_to(qt6cr_handle_t handle, qt6cr_pointf_t control_point1, qt6cr_pointf_t control_point2, qt6cr_pointf_t end_point) {
  auto *path = as_qpainter_path(handle);

  if (path != nullptr) {
    path->cubicTo(from_pointf(control_point1), from_pointf(control_point2), from_pointf(end_point));
  }
}

void qt6cr_qpainter_path_add_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *path = as_qpainter_path(handle);

  if (path != nullptr) {
    path->addRect(from_rectf(rect));
  }
}

void qt6cr_qpainter_path_add_ellipse(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *path = as_qpainter_path(handle);

  if (path != nullptr) {
    path->addEllipse(from_rectf(rect));
  }
}

void qt6cr_qpainter_path_close_subpath(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);

  if (path != nullptr) {
    path->closeSubpath();
  }
}

qt6cr_rectf_t qt6cr_qpainter_path_bounding_rect(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);
  return path == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(path->boundingRect());
}

qt6cr_handle_t qt6cr_qpainter_path_transformed(qt6cr_handle_t handle, qt6cr_handle_t transform) {
  auto *path = as_qpainter_path(handle);
  auto *matrix = as_qtransform(transform);
  return (path == nullptr || matrix == nullptr) ? nullptr : new QPainterPath(matrix->map(*path));
}

qt6cr_handle_t qt6cr_qpainter_create_for_image(qt6cr_handle_t image) {
  auto *target = as_qimage(image);
  return target == nullptr ? nullptr : new QPainter(target);
}

qt6cr_handle_t qt6cr_qpainter_create_for_pixmap(qt6cr_handle_t pixmap) {
  auto *target = as_qpixmap(pixmap);
  return target == nullptr ? nullptr : new QPainter(target);
}

qt6cr_handle_t qt6cr_qpainter_create_for_svg_generator(qt6cr_handle_t svg_generator) {
  auto *target = as_qsvg_generator(svg_generator);
  return target == nullptr ? nullptr : new QPainter(target);
}

qt6cr_handle_t qt6cr_qpainter_create_for_pdf_writer(qt6cr_handle_t pdf_writer) {
  auto *target = as_qpdf_writer(pdf_writer);
  return target == nullptr ? nullptr : new QPainter(target);
}

void qt6cr_qpainter_destroy(qt6cr_handle_t handle) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    if (painter->isActive()) {
      painter->end();
    }

    delete painter;
  }
}

bool qt6cr_qpainter_is_active(qt6cr_handle_t handle) {
  auto *painter = as_qpainter(handle);
  return painter != nullptr && painter->isActive();
}

void qt6cr_qpainter_set_antialiasing(qt6cr_handle_t handle, bool value) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->setRenderHint(QPainter::Antialiasing, value);
  }
}

void qt6cr_qpainter_set_pen_color(qt6cr_handle_t handle, qt6cr_color_t color) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->setPen(QPen(from_color(color)));
  }
}

void qt6cr_qpainter_set_pen(qt6cr_handle_t handle, qt6cr_handle_t pen) {
  auto *painter = as_qpainter(handle);
  auto *value = as_qpen(pen);

  if (painter != nullptr && value != nullptr) {
    painter->setPen(*value);
  }
}

void qt6cr_qpainter_set_brush_color(qt6cr_handle_t handle, qt6cr_color_t color) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->setBrush(QBrush(from_color(color)));
  }
}

void qt6cr_qpainter_set_brush(qt6cr_handle_t handle, qt6cr_handle_t brush) {
  auto *painter = as_qpainter(handle);
  auto *value = as_qbrush(brush);

  if (painter != nullptr && value != nullptr) {
    painter->setBrush(*value);
  }
}

void qt6cr_qpainter_set_font(qt6cr_handle_t handle, qt6cr_handle_t font) {
  auto *painter = as_qpainter(handle);
  auto *value = as_qfont(font);

  if (painter != nullptr && value != nullptr) {
    painter->setFont(*value);
  }
}

void qt6cr_qpainter_set_transform(qt6cr_handle_t handle, qt6cr_handle_t transform) {
  auto *painter = as_qpainter(handle);
  auto *matrix = as_qtransform(transform);

  if (painter != nullptr && matrix != nullptr) {
    painter->setTransform(*matrix);
  }
}

void qt6cr_qpainter_reset_transform(qt6cr_handle_t handle) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->resetTransform();
  }
}

void qt6cr_qpainter_draw_line(qt6cr_handle_t handle, qt6cr_pointf_t from_point, qt6cr_pointf_t to_point) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->drawLine(from_pointf(from_point), from_pointf(to_point));
  }
}

void qt6cr_qpainter_draw_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->drawRect(from_rectf(rect));
  }
}

void qt6cr_qpainter_fill_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect, qt6cr_color_t color) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->fillRect(from_rectf(rect), from_color(color));
  }
}

void qt6cr_qpainter_draw_ellipse(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->drawEllipse(from_rectf(rect));
  }
}

void qt6cr_qpainter_draw_path(qt6cr_handle_t handle, qt6cr_handle_t path) {
  auto *painter = as_qpainter(handle);
  auto *shape = as_qpainter_path(path);

  if (painter != nullptr && shape != nullptr) {
    painter->drawPath(*shape);
  }
}

void qt6cr_qpainter_draw_image(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_handle_t image) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qimage(image);

  if (painter != nullptr && source != nullptr) {
    painter->drawImage(from_pointf(position), *source);
  }
}

void qt6cr_qpainter_draw_pixmap(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_handle_t pixmap) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qpixmap(pixmap);

  if (painter != nullptr && source != nullptr) {
    painter->drawPixmap(from_pointf(position), *source);
  }
}

void qt6cr_qpainter_draw_text(qt6cr_handle_t handle, qt6cr_pointf_t position, const char *text) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->drawText(from_pointf(position), QString::fromUtf8(text == nullptr ? "" : text));
  }
}

qt6cr_handle_t qt6cr_input_dialog_create(qt6cr_handle_t parent) {
  return new QInputDialog(as_widget(parent));
}

void qt6cr_input_dialog_set_input_mode(qt6cr_handle_t handle, int input_mode) {
  auto *input_dialog = as_input_dialog(handle);

  if (input_dialog != nullptr) {
    input_dialog->setInputMode(static_cast<QInputDialog::InputMode>(input_mode));
  }
}

int qt6cr_input_dialog_input_mode(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? 0 : static_cast<int>(input_dialog->inputMode());
}

void qt6cr_input_dialog_set_label_text(qt6cr_handle_t handle, const char *text) {
  auto *input_dialog = as_input_dialog(handle);

  if (input_dialog != nullptr) {
    input_dialog->setLabelText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_input_dialog_label_text(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? duplicate_string("") : duplicate_string(input_dialog->labelText());
}

void qt6cr_input_dialog_set_text_value(qt6cr_handle_t handle, const char *text) {
  auto *input_dialog = as_input_dialog(handle);

  if (input_dialog != nullptr) {
    input_dialog->setTextValue(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_input_dialog_text_value(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? duplicate_string("") : duplicate_string(input_dialog->textValue());
}

void qt6cr_input_dialog_set_int_value(qt6cr_handle_t handle, int value) {
  auto *input_dialog = as_input_dialog(handle);

  if (input_dialog != nullptr) {
    input_dialog->setIntValue(value);
  }
}

int qt6cr_input_dialog_int_value(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? 0 : input_dialog->intValue();
}

void qt6cr_input_dialog_set_int_range(qt6cr_handle_t handle, int minimum, int maximum) {
  auto *input_dialog = as_input_dialog(handle);

  if (input_dialog != nullptr) {
    input_dialog->setIntRange(minimum, maximum);
  }
}

int qt6cr_input_dialog_int_minimum(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? 0 : input_dialog->intMinimum();
}

int qt6cr_input_dialog_int_maximum(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? 0 : input_dialog->intMaximum();
}

void qt6cr_input_dialog_set_double_value(qt6cr_handle_t handle, double value) {
  auto *input_dialog = as_input_dialog(handle);

  if (input_dialog != nullptr) {
    input_dialog->setDoubleValue(value);
  }
}

double qt6cr_input_dialog_double_value(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? 0.0 : input_dialog->doubleValue();
}

void qt6cr_input_dialog_set_double_range(qt6cr_handle_t handle, double minimum, double maximum) {
  auto *input_dialog = as_input_dialog(handle);

  if (input_dialog != nullptr) {
    input_dialog->setDoubleRange(minimum, maximum);
  }
}

double qt6cr_input_dialog_double_minimum(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? 0.0 : input_dialog->doubleMinimum();
}

double qt6cr_input_dialog_double_maximum(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? 0.0 : input_dialog->doubleMaximum();
}

qt6cr_handle_t qt6cr_dock_widget_create(qt6cr_handle_t parent, const char *title) {
  return new QDockWidget(QString::fromUtf8(title == nullptr ? "" : title), as_widget(parent));
}

void qt6cr_dock_widget_set_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *dock = as_dock_widget(handle);
  auto *child = as_widget(widget);

  if (dock != nullptr && child != nullptr) {
    dock->setWidget(child);
  }
}

qt6cr_handle_t qt6cr_action_create(qt6cr_handle_t parent, const char *text) {
  return new QAction(QString::fromUtf8(text == nullptr ? "" : text), as_object(parent));
}

void qt6cr_action_set_text(qt6cr_handle_t handle, const char *text) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_action_text(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action == nullptr ? duplicate_string("") : duplicate_string(action->text());
}

void qt6cr_action_set_shortcut(qt6cr_handle_t handle, const char *shortcut) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setShortcut(QKeySequence(QString::fromUtf8(shortcut == nullptr ? "" : shortcut)));
  }
}

char *qt6cr_action_shortcut(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action == nullptr ? duplicate_string("") : duplicate_string(action->shortcut().toString());
}

void qt6cr_action_set_checkable(qt6cr_handle_t handle, bool value) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setCheckable(value);
  }
}

bool qt6cr_action_is_checkable(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action != nullptr && action->isCheckable();
}

void qt6cr_action_set_checked(qt6cr_handle_t handle, bool value) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setChecked(value);
  }
}

bool qt6cr_action_is_checked(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action != nullptr && action->isChecked();
}

void qt6cr_action_on_triggered(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *action = as_action(handle);

  if (action == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(action, &QAction::triggered, action, [callback, userdata](bool) {
    callback(userdata);
  });
}

void qt6cr_action_trigger(qt6cr_handle_t handle) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->trigger();
  }
}

qt6cr_handle_t qt6cr_action_group_create(qt6cr_handle_t parent) {
  return new QActionGroup(as_object(parent));
}

void qt6cr_action_group_add_action(qt6cr_handle_t handle, qt6cr_handle_t action) {
  auto *action_group = as_action_group(handle);
  auto *group_action = as_action(action);

  if (action_group != nullptr && group_action != nullptr) {
    action_group->addAction(group_action);
  }
}

void qt6cr_action_group_set_exclusive(qt6cr_handle_t handle, bool value) {
  auto *action_group = as_action_group(handle);

  if (action_group != nullptr) {
    action_group->setExclusive(value);
  }
}

bool qt6cr_action_group_is_exclusive(qt6cr_handle_t handle) {
  auto *action_group = as_action_group(handle);
  return action_group != nullptr && action_group->isExclusive();
}

qt6cr_handle_t qt6cr_menu_bar_add_menu(qt6cr_handle_t handle, const char *title) {
  auto *menu_bar = as_menu_bar(handle);
  return menu_bar == nullptr ? nullptr : menu_bar->addMenu(QString::fromUtf8(title == nullptr ? "" : title));
}

qt6cr_handle_t qt6cr_menu_add_menu(qt6cr_handle_t handle, const char *title) {
  auto *menu = as_menu(handle);
  return menu == nullptr ? nullptr : menu->addMenu(QString::fromUtf8(title == nullptr ? "" : title));
}

void qt6cr_menu_add_action(qt6cr_handle_t handle, qt6cr_handle_t action) {
  auto *menu = as_menu(handle);
  auto *menu_action = as_action(action);

  if (menu != nullptr && menu_action != nullptr) {
    menu->addAction(menu_action);
  }
}

void qt6cr_menu_add_separator(qt6cr_handle_t handle) {
  auto *menu = as_menu(handle);

  if (menu != nullptr) {
    menu->addSeparator();
  }
}

void qt6cr_menu_set_title(qt6cr_handle_t handle, const char *title) {
  auto *menu = as_menu(handle);

  if (menu != nullptr) {
    menu->setTitle(QString::fromUtf8(title == nullptr ? "" : title));
  }
}

char *qt6cr_menu_title(qt6cr_handle_t handle) {
  auto *menu = as_menu(handle);
  return menu == nullptr ? duplicate_string("") : duplicate_string(menu->title());
}

qt6cr_handle_t qt6cr_tool_bar_create(qt6cr_handle_t parent, const char *title) {
  return new QToolBar(QString::fromUtf8(title == nullptr ? "" : title), as_widget(parent));
}

void qt6cr_tool_bar_add_action(qt6cr_handle_t handle, qt6cr_handle_t action) {
  auto *tool_bar = as_tool_bar(handle);
  auto *tool_bar_action = as_action(action);

  if (tool_bar != nullptr && tool_bar_action != nullptr) {
    tool_bar->addAction(tool_bar_action);
  }
}

qt6cr_handle_t qt6cr_status_bar_create(qt6cr_handle_t parent) {
  return new QStatusBar(as_widget(parent));
}

void qt6cr_status_bar_show_message(qt6cr_handle_t handle, const char *message, int timeout_ms) {
  auto *status_bar = as_status_bar(handle);

  if (status_bar != nullptr) {
    status_bar->showMessage(QString::fromUtf8(message == nullptr ? "" : message), timeout_ms);
  }
}

char *qt6cr_status_bar_current_message(qt6cr_handle_t handle) {
  auto *status_bar = as_status_bar(handle);
  return status_bar == nullptr ? duplicate_string("") : duplicate_string(status_bar->currentMessage());
}

void qt6cr_status_bar_clear_message(qt6cr_handle_t handle) {
  auto *status_bar = as_status_bar(handle);

  if (status_bar != nullptr) {
    status_bar->clearMessage();
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

void qt6cr_event_widget_on_paint_with_painter(qt6cr_handle_t handle, qt6cr_paint_with_painter_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->paint_with_painter_callback = callback;
    widget->paint_with_painter_userdata = userdata;
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

qt6cr_handle_t qt6cr_line_edit_create(qt6cr_handle_t parent, const char *text) {
  auto *line_edit = new QLineEdit(as_widget(parent));
  line_edit->setText(QString::fromUtf8(text == nullptr ? "" : text));
  return line_edit;
}

void qt6cr_line_edit_set_text(qt6cr_handle_t handle, const char *text) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_line_edit_text(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? duplicate_string("") : duplicate_string(line_edit->text());
}

qt6cr_handle_t qt6cr_check_box_create(qt6cr_handle_t parent, const char *text) {
  return new QCheckBox(QString::fromUtf8(text == nullptr ? "" : text), as_widget(parent));
}

void qt6cr_check_box_set_text(qt6cr_handle_t handle, const char *text) {
  auto *check_box = as_check_box(handle);

  if (check_box != nullptr) {
    check_box->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_check_box_text(qt6cr_handle_t handle) {
  auto *check_box = as_check_box(handle);
  return check_box == nullptr ? duplicate_string("") : duplicate_string(check_box->text());
}

void qt6cr_check_box_set_checked(qt6cr_handle_t handle, bool value) {
  auto *check_box = as_check_box(handle);

  if (check_box != nullptr) {
    check_box->setChecked(value);
  }
}

bool qt6cr_check_box_is_checked(qt6cr_handle_t handle) {
  auto *check_box = as_check_box(handle);
  return check_box != nullptr && check_box->isChecked();
}

void qt6cr_check_box_on_toggled(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *check_box = as_check_box(handle);

  if (check_box == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(check_box, &QCheckBox::toggled, check_box, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

qt6cr_handle_t qt6cr_radio_button_create(qt6cr_handle_t parent, const char *text) {
  return new QRadioButton(QString::fromUtf8(text == nullptr ? "" : text), as_widget(parent));
}

void qt6cr_radio_button_set_text(qt6cr_handle_t handle, const char *text) {
  auto *radio_button = as_radio_button(handle);

  if (radio_button != nullptr) {
    radio_button->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_radio_button_text(qt6cr_handle_t handle) {
  auto *radio_button = as_radio_button(handle);
  return radio_button == nullptr ? duplicate_string("") : duplicate_string(radio_button->text());
}

void qt6cr_radio_button_set_checked(qt6cr_handle_t handle, bool value) {
  auto *radio_button = as_radio_button(handle);

  if (radio_button != nullptr) {
    radio_button->setChecked(value);
  }
}

bool qt6cr_radio_button_is_checked(qt6cr_handle_t handle) {
  auto *radio_button = as_radio_button(handle);
  return radio_button != nullptr && radio_button->isChecked();
}

void qt6cr_radio_button_on_toggled(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *radio_button = as_radio_button(handle);

  if (radio_button == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(radio_button, &QRadioButton::toggled, radio_button, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

qt6cr_handle_t qt6cr_combo_box_create(qt6cr_handle_t parent) {
  return new QComboBox(as_widget(parent));
}

void qt6cr_combo_box_add_item(qt6cr_handle_t handle, const char *text) {
  auto *combo_box = as_combo_box(handle);

  if (combo_box != nullptr) {
    combo_box->addItem(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

int qt6cr_combo_box_count(qt6cr_handle_t handle) {
  auto *combo_box = as_combo_box(handle);
  return combo_box == nullptr ? 0 : combo_box->count();
}

int qt6cr_combo_box_current_index(qt6cr_handle_t handle) {
  auto *combo_box = as_combo_box(handle);
  return combo_box == nullptr ? -1 : combo_box->currentIndex();
}

void qt6cr_combo_box_set_current_index(qt6cr_handle_t handle, int index) {
  auto *combo_box = as_combo_box(handle);

  if (combo_box != nullptr) {
    combo_box->setCurrentIndex(index);
  }
}

char *qt6cr_combo_box_current_text(qt6cr_handle_t handle) {
  auto *combo_box = as_combo_box(handle);
  return combo_box == nullptr ? duplicate_string("") : duplicate_string(combo_box->currentText());
}

void qt6cr_combo_box_on_current_index_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *combo_box = as_combo_box(handle);

  if (combo_box == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(combo_box, static_cast<void (QComboBox::*)(int)>(&QComboBox::currentIndexChanged), combo_box, [callback, userdata](int index) {
    callback(userdata, index);
  });
}

qt6cr_handle_t qt6cr_list_widget_item_create(const char *text) {
  return new QListWidgetItem(QString::fromUtf8(text == nullptr ? "" : text));
}

void qt6cr_list_widget_item_destroy(qt6cr_handle_t handle) {
  delete as_list_widget_item(handle);
}

void qt6cr_list_widget_item_set_text(qt6cr_handle_t handle, const char *text) {
  auto *item = as_list_widget_item(handle);

  if (item != nullptr) {
    item->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_list_widget_item_text(qt6cr_handle_t handle) {
  auto *item = as_list_widget_item(handle);
  return item == nullptr ? duplicate_string("") : duplicate_string(item->text());
}

qt6cr_handle_t qt6cr_list_widget_create(qt6cr_handle_t parent) {
  return new QListWidget(as_widget(parent));
}

void qt6cr_list_widget_add_item(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *list_widget = as_list_widget(handle);
  auto *list_item = as_list_widget_item(item);

  if (list_widget != nullptr && list_item != nullptr) {
    list_widget->addItem(list_item);
  }
}

qt6cr_handle_t qt6cr_list_widget_add_item_text(qt6cr_handle_t handle, const char *text) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget == nullptr) {
    return nullptr;
  }

  return new QListWidgetItem(QString::fromUtf8(text == nullptr ? "" : text), list_widget);
}

int qt6cr_list_widget_count(qt6cr_handle_t handle) {
  auto *list_widget = as_list_widget(handle);
  return list_widget == nullptr ? 0 : list_widget->count();
}

qt6cr_handle_t qt6cr_list_widget_item(qt6cr_handle_t handle, int index) {
  auto *list_widget = as_list_widget(handle);
  return list_widget == nullptr ? nullptr : list_widget->item(index);
}

char *qt6cr_list_widget_item_text_at(qt6cr_handle_t handle, int index) {
  auto *list_widget = as_list_widget(handle);
  auto *item = list_widget == nullptr ? nullptr : list_widget->item(index);
  return item == nullptr ? duplicate_string("") : duplicate_string(item->text());
}

int qt6cr_list_widget_current_row(qt6cr_handle_t handle) {
  auto *list_widget = as_list_widget(handle);
  return list_widget == nullptr ? -1 : list_widget->currentRow();
}

void qt6cr_list_widget_set_current_row(qt6cr_handle_t handle, int row) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget != nullptr) {
    list_widget->setCurrentRow(row);
  }
}

qt6cr_handle_t qt6cr_list_widget_current_item(qt6cr_handle_t handle) {
  auto *list_widget = as_list_widget(handle);
  return list_widget == nullptr ? nullptr : list_widget->currentItem();
}

char *qt6cr_list_widget_current_text(qt6cr_handle_t handle) {
  auto *list_widget = as_list_widget(handle);
  auto *item = list_widget == nullptr ? nullptr : list_widget->currentItem();
  return item == nullptr ? duplicate_string("") : duplicate_string(item->text());
}

void qt6cr_list_widget_clear(qt6cr_handle_t handle) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget != nullptr) {
    list_widget->clear();
  }
}

void qt6cr_list_widget_on_current_row_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(list_widget, &QListWidget::currentRowChanged, list_widget, [callback, userdata](int row) {
    callback(userdata, row);
  });
}

qt6cr_handle_t qt6cr_tree_widget_item_create(const char *text) {
  auto *item = new QTreeWidgetItem();
  item->setText(0, QString::fromUtf8(text == nullptr ? "" : text));
  return item;
}

void qt6cr_tree_widget_item_destroy(qt6cr_handle_t handle) {
  delete as_tree_widget_item(handle);
}

void qt6cr_tree_widget_item_set_text(qt6cr_handle_t handle, int column, const char *text) {
  auto *item = as_tree_widget_item(handle);

  if (item != nullptr && column >= 0) {
    item->setText(column, QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_tree_widget_item_text(qt6cr_handle_t handle, int column) {
  auto *item = as_tree_widget_item(handle);
  return item == nullptr || column < 0 ? duplicate_string("") : duplicate_string(item->text(column));
}

void qt6cr_tree_widget_item_add_child(qt6cr_handle_t handle, qt6cr_handle_t child) {
  auto *item = as_tree_widget_item(handle);
  auto *child_item = as_tree_widget_item(child);

  if (item != nullptr && child_item != nullptr) {
    item->addChild(child_item);
  }
}

int qt6cr_tree_widget_item_child_count(qt6cr_handle_t handle) {
  auto *item = as_tree_widget_item(handle);
  return item == nullptr ? 0 : item->childCount();
}

qt6cr_handle_t qt6cr_tree_widget_item_child(qt6cr_handle_t handle, int index) {
  auto *item = as_tree_widget_item(handle);
  return item == nullptr ? nullptr : item->child(index);
}

qt6cr_handle_t qt6cr_tree_widget_create(qt6cr_handle_t parent) {
  return new QTreeWidget(as_widget(parent));
}

int qt6cr_tree_widget_column_count(qt6cr_handle_t handle) {
  auto *tree_widget = as_tree_widget(handle);
  return tree_widget == nullptr ? 0 : tree_widget->columnCount();
}

void qt6cr_tree_widget_set_column_count(qt6cr_handle_t handle, int count) {
  auto *tree_widget = as_tree_widget(handle);

  if (tree_widget != nullptr && count >= 0) {
    tree_widget->setColumnCount(count);
  }
}

char *qt6cr_tree_widget_header_label(qt6cr_handle_t handle, int column) {
  auto *tree_widget = as_tree_widget(handle);
  auto *header_item = tree_widget == nullptr ? nullptr : tree_widget->headerItem();
  return header_item == nullptr || column < 0 ? duplicate_string("") : duplicate_string(header_item->text(column));
}

void qt6cr_tree_widget_set_header_label(qt6cr_handle_t handle, int column, const char *text) {
  auto *tree_widget = as_tree_widget(handle);

  if (tree_widget == nullptr || column < 0) {
    return;
  }

  if (tree_widget->columnCount() <= column) {
    tree_widget->setColumnCount(column + 1);
  }

  auto *header_item = tree_widget->headerItem();

  if (header_item != nullptr) {
    header_item->setText(column, QString::fromUtf8(text == nullptr ? "" : text));
  }
}

void qt6cr_tree_widget_add_top_level_item(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *tree_widget = as_tree_widget(handle);
  auto *tree_item = as_tree_widget_item(item);

  if (tree_widget != nullptr && tree_item != nullptr) {
    tree_widget->addTopLevelItem(tree_item);
  }
}

qt6cr_handle_t qt6cr_tree_widget_add_top_level_item_text(qt6cr_handle_t handle, const char *text) {
  auto *tree_widget = as_tree_widget(handle);

  if (tree_widget == nullptr) {
    return nullptr;
  }

  auto *item = new QTreeWidgetItem();
  item->setText(0, QString::fromUtf8(text == nullptr ? "" : text));
  tree_widget->addTopLevelItem(item);
  return item;
}

int qt6cr_tree_widget_top_level_item_count(qt6cr_handle_t handle) {
  auto *tree_widget = as_tree_widget(handle);
  return tree_widget == nullptr ? 0 : tree_widget->topLevelItemCount();
}

qt6cr_handle_t qt6cr_tree_widget_top_level_item(qt6cr_handle_t handle, int index) {
  auto *tree_widget = as_tree_widget(handle);
  return tree_widget == nullptr ? nullptr : tree_widget->topLevelItem(index);
}

qt6cr_handle_t qt6cr_tree_widget_current_item(qt6cr_handle_t handle) {
  auto *tree_widget = as_tree_widget(handle);
  return tree_widget == nullptr ? nullptr : tree_widget->currentItem();
}

void qt6cr_tree_widget_set_current_item(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *tree_widget = as_tree_widget(handle);
  auto *tree_item = as_tree_widget_item(item);

  if (tree_widget != nullptr) {
    tree_widget->setCurrentItem(tree_item);
  }
}

char *qt6cr_tree_widget_current_item_text(qt6cr_handle_t handle, int column) {
  auto *tree_widget = as_tree_widget(handle);
  auto *item = tree_widget == nullptr ? nullptr : tree_widget->currentItem();
  return item == nullptr || column < 0 ? duplicate_string("") : duplicate_string(item->text(column));
}

void qt6cr_tree_widget_expand_all(qt6cr_handle_t handle) {
  auto *tree_widget = as_tree_widget(handle);

  if (tree_widget != nullptr) {
    tree_widget->expandAll();
  }
}

void qt6cr_tree_widget_collapse_all(qt6cr_handle_t handle) {
  auto *tree_widget = as_tree_widget(handle);

  if (tree_widget != nullptr) {
    tree_widget->collapseAll();
  }
}

void qt6cr_tree_widget_clear(qt6cr_handle_t handle) {
  auto *tree_widget = as_tree_widget(handle);

  if (tree_widget != nullptr) {
    tree_widget->clear();
  }
}

void qt6cr_tree_widget_on_current_item_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *tree_widget = as_tree_widget(handle);

  if (tree_widget == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(tree_widget, &QTreeWidget::currentItemChanged, tree_widget, [callback, userdata](QTreeWidgetItem *, QTreeWidgetItem *) {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_slider_create(qt6cr_handle_t parent, int orientation) {
  return new QSlider(static_cast<Qt::Orientation>(orientation), as_widget(parent));
}

void qt6cr_slider_set_minimum(qt6cr_handle_t handle, int value) {
  auto *slider = as_slider(handle);

  if (slider != nullptr) {
    slider->setMinimum(value);
  }
}

int qt6cr_slider_minimum(qt6cr_handle_t handle) {
  auto *slider = as_slider(handle);
  return slider == nullptr ? 0 : slider->minimum();
}

void qt6cr_slider_set_maximum(qt6cr_handle_t handle, int value) {
  auto *slider = as_slider(handle);

  if (slider != nullptr) {
    slider->setMaximum(value);
  }
}

int qt6cr_slider_maximum(qt6cr_handle_t handle) {
  auto *slider = as_slider(handle);
  return slider == nullptr ? 99 : slider->maximum();
}

void qt6cr_slider_set_range(qt6cr_handle_t handle, int minimum, int maximum) {
  auto *slider = as_slider(handle);

  if (slider != nullptr) {
    slider->setRange(minimum, maximum);
  }
}

void qt6cr_slider_set_value(qt6cr_handle_t handle, int value) {
  auto *slider = as_slider(handle);

  if (slider != nullptr) {
    slider->setValue(value);
  }
}

int qt6cr_slider_value(qt6cr_handle_t handle) {
  auto *slider = as_slider(handle);
  return slider == nullptr ? 0 : slider->value();
}

int qt6cr_slider_orientation(qt6cr_handle_t handle) {
  auto *slider = as_slider(handle);
  return slider == nullptr ? static_cast<int>(Qt::Horizontal) : static_cast<int>(slider->orientation());
}

void qt6cr_slider_on_value_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *slider = as_slider(handle);

  if (slider == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(slider, &QSlider::valueChanged, slider, [callback, userdata](int value) {
    callback(userdata, value);
  });
}

qt6cr_handle_t qt6cr_spin_box_create(qt6cr_handle_t parent) {
  return new QSpinBox(as_widget(parent));
}

void qt6cr_spin_box_set_minimum(qt6cr_handle_t handle, int value) {
  auto *spin_box = as_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setMinimum(value);
  }
}

int qt6cr_spin_box_minimum(qt6cr_handle_t handle) {
  auto *spin_box = as_spin_box(handle);
  return spin_box == nullptr ? 0 : spin_box->minimum();
}

void qt6cr_spin_box_set_maximum(qt6cr_handle_t handle, int value) {
  auto *spin_box = as_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setMaximum(value);
  }
}

int qt6cr_spin_box_maximum(qt6cr_handle_t handle) {
  auto *spin_box = as_spin_box(handle);
  return spin_box == nullptr ? 99 : spin_box->maximum();
}

void qt6cr_spin_box_set_range(qt6cr_handle_t handle, int minimum, int maximum) {
  auto *spin_box = as_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setRange(minimum, maximum);
  }
}

void qt6cr_spin_box_set_value(qt6cr_handle_t handle, int value) {
  auto *spin_box = as_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setValue(value);
  }
}

int qt6cr_spin_box_value(qt6cr_handle_t handle) {
  auto *spin_box = as_spin_box(handle);
  return spin_box == nullptr ? 0 : spin_box->value();
}

void qt6cr_spin_box_set_single_step(qt6cr_handle_t handle, int value) {
  auto *spin_box = as_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setSingleStep(value);
  }
}

int qt6cr_spin_box_single_step(qt6cr_handle_t handle) {
  auto *spin_box = as_spin_box(handle);
  return spin_box == nullptr ? 1 : spin_box->singleStep();
}

void qt6cr_spin_box_on_value_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *spin_box = as_spin_box(handle);

  if (spin_box == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(spin_box, static_cast<void (QSpinBox::*)(int)>(&QSpinBox::valueChanged), spin_box, [callback, userdata](int value) {
    callback(userdata, value);
  });
}

qt6cr_handle_t qt6cr_double_spin_box_create(qt6cr_handle_t parent) {
  return new QDoubleSpinBox(as_widget(parent));
}

void qt6cr_double_spin_box_set_minimum(qt6cr_handle_t handle, double value) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setMinimum(value);
  }
}

double qt6cr_double_spin_box_minimum(qt6cr_handle_t handle) {
  auto *spin_box = as_double_spin_box(handle);
  return spin_box == nullptr ? 0.0 : spin_box->minimum();
}

void qt6cr_double_spin_box_set_maximum(qt6cr_handle_t handle, double value) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setMaximum(value);
  }
}

double qt6cr_double_spin_box_maximum(qt6cr_handle_t handle) {
  auto *spin_box = as_double_spin_box(handle);
  return spin_box == nullptr ? 99.99 : spin_box->maximum();
}

void qt6cr_double_spin_box_set_range(qt6cr_handle_t handle, double minimum, double maximum) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setRange(minimum, maximum);
  }
}

void qt6cr_double_spin_box_set_value(qt6cr_handle_t handle, double value) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setValue(value);
  }
}

double qt6cr_double_spin_box_value(qt6cr_handle_t handle) {
  auto *spin_box = as_double_spin_box(handle);
  return spin_box == nullptr ? 0.0 : spin_box->value();
}

void qt6cr_double_spin_box_set_single_step(qt6cr_handle_t handle, double value) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setSingleStep(value);
  }
}

double qt6cr_double_spin_box_single_step(qt6cr_handle_t handle) {
  auto *spin_box = as_double_spin_box(handle);
  return spin_box == nullptr ? 1.0 : spin_box->singleStep();
}

void qt6cr_double_spin_box_on_value_changed(qt6cr_handle_t handle, qt6cr_double_callback_t callback, void *userdata) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(spin_box, static_cast<void (QDoubleSpinBox::*)(double)>(&QDoubleSpinBox::valueChanged), spin_box, [callback, userdata](double value) {
    callback(userdata, value);
  });
}

qt6cr_handle_t qt6cr_group_box_create(qt6cr_handle_t parent, const char *title) {
  return new QGroupBox(QString::fromUtf8(title == nullptr ? "" : title), as_widget(parent));
}

void qt6cr_group_box_set_title(qt6cr_handle_t handle, const char *title) {
  auto *group_box = as_group_box(handle);

  if (group_box != nullptr) {
    group_box->setTitle(QString::fromUtf8(title == nullptr ? "" : title));
  }
}

char *qt6cr_group_box_title(qt6cr_handle_t handle) {
  auto *group_box = as_group_box(handle);
  return group_box == nullptr ? duplicate_string("") : duplicate_string(group_box->title());
}

void qt6cr_group_box_set_checkable(qt6cr_handle_t handle, bool value) {
  auto *group_box = as_group_box(handle);

  if (group_box != nullptr) {
    group_box->setCheckable(value);
  }
}

bool qt6cr_group_box_is_checkable(qt6cr_handle_t handle) {
  auto *group_box = as_group_box(handle);
  return group_box != nullptr && group_box->isCheckable();
}

void qt6cr_group_box_set_checked(qt6cr_handle_t handle, bool value) {
  auto *group_box = as_group_box(handle);

  if (group_box != nullptr) {
    group_box->setChecked(value);
  }
}

bool qt6cr_group_box_is_checked(qt6cr_handle_t handle) {
  auto *group_box = as_group_box(handle);
  return group_box != nullptr && group_box->isChecked();
}

void qt6cr_group_box_on_toggled(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *group_box = as_group_box(handle);

  if (group_box == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(group_box, &QGroupBox::toggled, group_box, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

qt6cr_handle_t qt6cr_tab_widget_create(qt6cr_handle_t parent) {
  return new QTabWidget(as_widget(parent));
}

int qt6cr_tab_widget_add_tab(qt6cr_handle_t handle, qt6cr_handle_t widget, const char *label) {
  auto *tab_widget = as_tab_widget(handle);
  auto *page = as_widget(widget);

  if (tab_widget == nullptr || page == nullptr) {
    return -1;
  }

  return tab_widget->addTab(page, QString::fromUtf8(label == nullptr ? "" : label));
}

int qt6cr_tab_widget_count(qt6cr_handle_t handle) {
  auto *tab_widget = as_tab_widget(handle);
  return tab_widget == nullptr ? 0 : tab_widget->count();
}

int qt6cr_tab_widget_current_index(qt6cr_handle_t handle) {
  auto *tab_widget = as_tab_widget(handle);
  return tab_widget == nullptr ? -1 : tab_widget->currentIndex();
}

void qt6cr_tab_widget_set_current_index(qt6cr_handle_t handle, int index) {
  auto *tab_widget = as_tab_widget(handle);

  if (tab_widget != nullptr) {
    tab_widget->setCurrentIndex(index);
  }
}

void qt6cr_tab_widget_on_current_index_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *tab_widget = as_tab_widget(handle);

  if (tab_widget == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(tab_widget, &QTabWidget::currentChanged, tab_widget, [callback, userdata](int value) {
    callback(userdata, value);
  });
}

qt6cr_handle_t qt6cr_scroll_area_create(qt6cr_handle_t parent) {
  return new QScrollArea(as_widget(parent));
}

void qt6cr_scroll_area_set_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *scroll_area = as_scroll_area(handle);
  auto *content = as_widget(widget);

  if (scroll_area != nullptr && content != nullptr) {
    scroll_area->setWidget(content);
  }
}

void qt6cr_scroll_area_set_widget_resizable(qt6cr_handle_t handle, bool value) {
  auto *scroll_area = as_scroll_area(handle);

  if (scroll_area != nullptr) {
    scroll_area->setWidgetResizable(value);
  }
}

bool qt6cr_scroll_area_widget_resizable(qt6cr_handle_t handle) {
  auto *scroll_area = as_scroll_area(handle);
  return scroll_area != nullptr && scroll_area->widgetResizable();
}

qt6cr_handle_t qt6cr_splitter_create(qt6cr_handle_t parent, int orientation) {
  return new QSplitter(static_cast<Qt::Orientation>(orientation), as_widget(parent));
}

void qt6cr_splitter_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *splitter = as_splitter(handle);
  auto *child = as_widget(widget);

  if (splitter != nullptr && child != nullptr) {
    splitter->addWidget(child);
  }
}

int qt6cr_splitter_count(qt6cr_handle_t handle) {
  auto *splitter = as_splitter(handle);
  return splitter == nullptr ? 0 : splitter->count();
}

int qt6cr_splitter_orientation(qt6cr_handle_t handle) {
  auto *splitter = as_splitter(handle);
  return splitter == nullptr ? static_cast<int>(Qt::Horizontal) : static_cast<int>(splitter->orientation());
}

void qt6cr_splitter_set_orientation(qt6cr_handle_t handle, int orientation) {
  auto *splitter = as_splitter(handle);

  if (splitter != nullptr) {
    splitter->setOrientation(static_cast<Qt::Orientation>(orientation));
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

qt6cr_handle_t qt6cr_h_box_layout_create(qt6cr_handle_t parent_widget) {
  return new QHBoxLayout(as_widget(parent_widget));
}

void qt6cr_h_box_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *layout = as_h_box_layout(handle);
  auto *child = as_widget(widget);

  if (layout != nullptr && child != nullptr) {
    layout->addWidget(child);
  }
}

qt6cr_handle_t qt6cr_grid_layout_create(qt6cr_handle_t parent_widget) {
  return new QGridLayout(as_widget(parent_widget));
}

void qt6cr_grid_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget, int row, int column, int row_span, int column_span) {
  auto *layout = as_grid_layout(handle);
  auto *child = as_widget(widget);

  if (layout != nullptr && child != nullptr) {
    layout->addWidget(child, row, column, row_span, column_span);
  }
}

qt6cr_handle_t qt6cr_form_layout_create(qt6cr_handle_t parent_widget) {
  return new QFormLayout(as_widget(parent_widget));
}

void qt6cr_form_layout_add_row_label_widget(qt6cr_handle_t handle, const char *label, qt6cr_handle_t field_widget) {
  auto *layout = as_form_layout(handle);
  auto *field = as_widget(field_widget);

  if (layout != nullptr && field != nullptr) {
    layout->addRow(QString::fromUtf8(label == nullptr ? "" : label), field);
  }
}

void qt6cr_form_layout_add_row_widget_widget(qt6cr_handle_t handle, qt6cr_handle_t label_widget, qt6cr_handle_t field_widget) {
  auto *layout = as_form_layout(handle);
  auto *label = as_widget(label_widget);
  auto *field = as_widget(field_widget);

  if (layout != nullptr && label != nullptr && field != nullptr) {
    layout->addRow(label, field);
  }
}

void qt6cr_form_layout_add_row_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *layout = as_form_layout(handle);
  auto *child = as_widget(widget);

  if (layout != nullptr && child != nullptr) {
    layout->addRow(child);
  }
}

void qt6cr_string_free(char *value) {
  delete[] value;
}

}  // extern "C"
