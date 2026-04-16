#include "qt6cr.h"

#if defined(__aarch64__) || defined(__arm64__)
#include <arm_acle.h>
#endif

#include <QApplication>
#include <QAction>
#include <QActionGroup>
#include <QAbstractButton>
#include <QAbstractItemModel>
#include <QAbstractListModel>
#include <QBuffer>
#include <QButtonGroup>
#include <QCheckBox>
#include <QClipboard>
#include <QColor>
#include <QColorDialog>
#include <QComboBox>
#include <QCompleter>
#include <QCoreApplication>
#include <QCalendarWidget>
#include <QCommandLinkButton>
#include <QCursor>
#include <QDate>
#include <QDateEdit>
#include <QDateTime>
#include <QDateTimeEdit>
#include <QDial>
#include <QDir>
#include <QDialog>
#include <QDialogButtonBox>
#include <QDockWidget>
#include <QDragEnterEvent>
#include <QDragMoveEvent>
#include <QEnterEvent>
#include <QEvent>
#include <QEventLoop>
#include <QFile>
#include <QFileDialog>
#include <QFileInfo>
#include <QFontComboBox>
#include <QFontDialog>
#include <QFrame>
#include <QFont>
#include <QFontMetrics>
#include <QFocusEvent>
#include <QFormLayout>
#include <QGridLayout>
#include <QHeaderView>
#include <QHBoxLayout>
#include <QIcon>
#include <QInputDialog>
#include <QItemSelectionModel>
#include <QIODevice>
#include <QKeyEvent>
#include <QLabel>
#include <QLinearGradient>
#include <QListView>
#include <QListWidget>
#include <QListWidgetItem>
#include <QLineEdit>
#include <QLCDNumber>
#include <QMainWindow>
#include <QMenu>
#include <QBrush>
#include <QMenuBar>
#include <QMessageBox>
#include <QMetaObject>
#include <QMimeData>
#include <QMouseEvent>
#include <QImage>
#include <QImageReader>
#include <QObject>
#include <QPaintEvent>
#include <QPainter>
#include <QPainterPath>
#include <QPainterPathStroker>
#include <QDesktopServices>
#include <QRegularExpression>
#include <QRegularExpressionValidator>
#include <QPageLayout>
#include <QPageSize>
#include <QPen>
#include <QPdfWriter>
#include <QPixmap>
#include <QProgressBar>
#include <QPolygonF>
#include <QProgressDialog>
#include <QPushButton>
#include <QSettings>
#include <QSortFilterProxyModel>
#include <QStandardPaths>
#include <QKeySequence>
#include <QRadioButton>
#include <QRadialGradient>
#include <QResizeEvent>
#include <QScrollArea>
#include <QScrollBar>
#include <QSlider>
#include <QStyle>
#include <QSpinBox>
#include <QDoubleSpinBox>
#include <QSizePolicy>
#include <QStyle>
#include <QStackedWidget>
#include <QStackedLayout>
#include <QStatusBar>
#include <QStandardItem>
#include <QStandardItemModel>
#include <QStyledItemDelegate>
#include <QTabBar>
#include <QTextCursor>
#include <QTextBrowser>
#include <QTextDocument>
#include <QTextEdit>
#include <QPlainTextEdit>
#include <QTime>
#include <QTimeEdit>
#include <QGroupBox>
#include <QtGlobal>
#include <QSplashScreen>
#include <QSvgGenerator>
#include <QSvgRenderer>
#include <QSvgWidget>
#include <QTabWidget>
#include <QTableView>
#include <QTableWidget>
#include <QTableWidgetItem>
#include <QTimer>
#include <QTransform>
#include <QToolBar>
#include <QToolButton>
#include <QValidator>
#include <QIntValidator>
#include <QDoubleValidator>
#include <QTreeView>
#include <QTreeWidget>
#include <QTreeWidgetItem>
#include <QUndoCommand>
#include <QUndoGroup>
#include <QUndoStack>
#include <QUrl>
#include <QVBoxLayout>
#include <QWheelEvent>
#include <QWidget>
#include <QSplitter>
#include <QVariant>
#include <QMetaType>
#include <QLocale>
#include <QDropEvent>
#include <QStringListModel>

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
QWidget *as_widget(qt6cr_handle_t handle);
qt6cr_byte_array_t to_byte_array_value(const QByteArray &value);
qt6cr_string_array_t to_string_array_value(const QStringList &values);
QMimeData *as_mime_data(qt6cr_handle_t handle);
QMimeData *clone_mime_data(const QMimeData *source);

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
  qt6cr_mouse_callback_t mouse_double_click_callback = nullptr;
  void *mouse_double_click_userdata = nullptr;
  qt6cr_wheel_callback_t wheel_callback = nullptr;
  void *wheel_userdata = nullptr;
  qt6cr_key_callback_t key_press_callback = nullptr;
  void *key_press_userdata = nullptr;
  qt6cr_key_callback_t key_release_callback = nullptr;
  void *key_release_userdata = nullptr;
  qt6cr_void_callback_t enter_callback = nullptr;
  void *enter_userdata = nullptr;
  qt6cr_void_callback_t leave_callback = nullptr;
  void *leave_userdata = nullptr;
  qt6cr_void_callback_t focus_in_callback = nullptr;
  void *focus_in_userdata = nullptr;
  qt6cr_void_callback_t focus_out_callback = nullptr;
  void *focus_out_userdata = nullptr;
  qt6cr_drop_event_callback_t drag_enter_callback = nullptr;
  void *drag_enter_userdata = nullptr;
  qt6cr_drop_event_callback_t drag_move_callback = nullptr;
  void *drag_move_userdata = nullptr;
  qt6cr_drop_event_callback_t drop_callback = nullptr;
  void *drop_userdata = nullptr;

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

  void mouseDoubleClickEvent(QMouseEvent *event) override {
    if (mouse_double_click_callback != nullptr) {
      mouse_double_click_callback(mouse_double_click_userdata, to_mouse_event(event));
    }

    event->accept();
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

  void keyReleaseEvent(QKeyEvent *event) override {
    if (key_release_callback != nullptr) {
      key_release_callback(key_release_userdata, to_key_event(event));
    }

    QWidget::keyReleaseEvent(event);
  }

  void enterEvent(QEnterEvent *event) override {
    if (enter_callback != nullptr) {
      enter_callback(enter_userdata);
    }

    QWidget::enterEvent(event);
  }

  void leaveEvent(QEvent *event) override {
    if (leave_callback != nullptr) {
      leave_callback(leave_userdata);
    }

    QWidget::leaveEvent(event);
  }

  void focusInEvent(QFocusEvent *event) override {
    if (focus_in_callback != nullptr) {
      focus_in_callback(focus_in_userdata);
    }

    QWidget::focusInEvent(event);
  }

  void focusOutEvent(QFocusEvent *event) override {
    if (focus_out_callback != nullptr) {
      focus_out_callback(focus_out_userdata);
    }

    QWidget::focusOutEvent(event);
  }

  void dragEnterEvent(QDragEnterEvent *event) override {
    if (drag_enter_callback != nullptr) {
      drag_enter_callback(drag_enter_userdata, event);
    }

    QWidget::dragEnterEvent(event);
  }

  void dragMoveEvent(QDragMoveEvent *event) override {
    if (drag_move_callback != nullptr) {
      drag_move_callback(drag_move_userdata, event);
    }

    QWidget::dragMoveEvent(event);
  }

  void dropEvent(QDropEvent *event) override {
    if (drop_callback != nullptr) {
      drop_callback(drop_userdata, event);
    }

    QWidget::dropEvent(event);
  }

 private:
  static qt6cr_rectf_t to_rectf(const QRect &rect) {
    return qt6cr_rectf_t{static_cast<double>(rect.x()), static_cast<double>(rect.y()), static_cast<double>(rect.width()), static_cast<double>(rect.height())};
  }
};

class CrystalUndoCommand final : public QUndoCommand {
 public:
  explicit CrystalUndoCommand(const QString &text = QString()) : QUndoCommand(text) {}

  ~CrystalUndoCommand() override {
    if (destroy_callback != nullptr) {
      destroy_callback(destroy_userdata);
    }
  }

  qt6cr_void_callback_t redo_callback = nullptr;
  void *redo_userdata = nullptr;
  qt6cr_void_callback_t undo_callback = nullptr;
  void *undo_userdata = nullptr;
  qt6cr_void_callback_t destroy_callback = nullptr;
  void *destroy_userdata = nullptr;

  void redo() override {
    if (redo_callback != nullptr) {
      redo_callback(redo_userdata);
    }
  }

  void undo() override {
    if (undo_callback != nullptr) {
      undo_callback(undo_userdata);
    }
  }
};

class CrystalListWidget final : public QListWidget {
 public:
  using QListWidget::QListWidget;

  void emitItemDoubleClickedBridge(QListWidgetItem *item) {
    emit itemDoubleClicked(item);
  }
};

class CrystalTableWidget final : public QTableWidget {
 public:
  using QTableWidget::QTableWidget;

  void emitItemDoubleClickedBridge(QTableWidgetItem *item) {
    emit itemDoubleClicked(item);
  }
};

class CrystalSlider final : public QSlider {
 public:
  using QSlider::QSlider;

  bool click_to_position = false;

 protected:
  void mousePressEvent(QMouseEvent *event) override {
    if (click_to_position && event != nullptr && event->button() == Qt::LeftButton) {
      const int pos = orientation() == Qt::Horizontal ? static_cast<int>(event->position().x()) : static_cast<int>(height() - event->position().y());
      const int span = orientation() == Qt::Horizontal ? width() : height();

      if (span > 0) {
        const int value = QStyle::sliderValueFromPosition(minimum(), maximum(), pos, span, invertedAppearance());
        setValue(value);
      }
    }

    QSlider::mousePressEvent(event);
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

  void setSelectionModel(QItemSelectionModel *selection_model) override {
    if (current_changed_connection) {
      QObject::disconnect(current_changed_connection);
    }

    QListView::setSelectionModel(selection_model);
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

  void setSelectionModel(QItemSelectionModel *selection_model) override {
    if (current_changed_connection) {
      QObject::disconnect(current_changed_connection);
    }

    QTreeView::setSelectionModel(selection_model);
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

class ModelTableView final : public QTableView {
 public:
  explicit ModelTableView(QWidget *parent = nullptr) : QTableView(parent) {}

  qt6cr_void_callback_t current_index_changed_callback = nullptr;
  void *current_index_changed_userdata = nullptr;

  void setModel(QAbstractItemModel *model) override {
    if (current_changed_connection) {
      QObject::disconnect(current_changed_connection);
    }

    QTableView::setModel(model);
    reconnect_current_changed();
  }

  void setSelectionModel(QItemSelectionModel *selection_model) override {
    if (current_changed_connection) {
      QObject::disconnect(current_changed_connection);
    }

    QTableView::setSelectionModel(selection_model);
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

class CrystalEventFilter final : public QObject {
 public:
  explicit CrystalEventFilter(QObject *parent = nullptr) : QObject(parent) {}

  qt6cr_event_filter_callback_t event_callback = nullptr;
  void *event_userdata = nullptr;

 protected:
  bool eventFilter(QObject *watched, QEvent *event) override {
    if (event_callback == nullptr) {
      return QObject::eventFilter(watched, event);
    }

    return event_callback(event_userdata, dynamic_cast<QWidget *>(watched), event);
  }
};

class CrystalAbstractListModel final : public QAbstractListModel {
 public:
  explicit CrystalAbstractListModel(QObject *parent = nullptr) : QAbstractListModel(parent) {}

  qt6cr_model_count_callback_t row_count_callback = nullptr;
  void *row_count_userdata = nullptr;
  qt6cr_model_count_callback_t column_count_callback = nullptr;
  void *column_count_userdata = nullptr;
  qt6cr_model_data_callback_t data_callback = nullptr;
  void *data_userdata = nullptr;
  qt6cr_model_set_data_callback_t set_data_callback = nullptr;
  void *set_data_userdata = nullptr;
  qt6cr_model_header_data_callback_t header_data_callback = nullptr;
  void *header_data_userdata = nullptr;
  qt6cr_model_flags_callback_t flags_callback = nullptr;
  void *flags_userdata = nullptr;
  qt6cr_model_mime_type_count_callback_t mime_type_count_callback = nullptr;
  void *mime_type_count_userdata = nullptr;
  qt6cr_indexed_string_callback_t mime_type_callback = nullptr;
  void *mime_type_userdata = nullptr;
  qt6cr_model_mime_data_callback_t mime_data_callback = nullptr;
  void *mime_data_userdata = nullptr;
  qt6cr_model_drop_mime_data_callback_t drop_mime_data_callback = nullptr;
  void *drop_mime_data_userdata = nullptr;
  qt6cr_model_actions_callback_t supported_drag_actions_callback = nullptr;
  void *supported_drag_actions_userdata = nullptr;
  qt6cr_model_actions_callback_t supported_drop_actions_callback = nullptr;
  void *supported_drop_actions_userdata = nullptr;

  int rowCount(const QModelIndex &parent = QModelIndex()) const override {
    if (parent.isValid()) {
      return 0;
    }

    return row_count_callback == nullptr ? 0 : row_count_callback(row_count_userdata);
  }

  int columnCount(const QModelIndex &parent = QModelIndex()) const override {
    if (parent.isValid()) {
      return 0;
    }

    return column_count_callback == nullptr ? 1 : column_count_callback(column_count_userdata);
  }

  QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override {
    if (data_callback == nullptr || !index.isValid()) {
      return QVariant();
    }

    QModelIndex index_copy(index);
    return from_variant_value(data_callback(data_userdata, &index_copy, role));
  }

  bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override {
    if (set_data_callback == nullptr || !index.isValid()) {
      return false;
    }

    QModelIndex index_copy(index);
    return set_data_callback(set_data_userdata, &index_copy, to_variant_value(value), role);
  }

  QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override {
    if (header_data_callback == nullptr) {
      return QAbstractListModel::headerData(section, orientation, role);
    }

    return from_variant_value(header_data_callback(header_data_userdata, section, static_cast<int>(orientation), role));
  }

  Qt::ItemFlags flags(const QModelIndex &index) const override {
    if (flags_callback == nullptr || !index.isValid()) {
      return QAbstractListModel::flags(index);
    }

    QModelIndex index_copy(index);
    return static_cast<Qt::ItemFlags>(flags_callback(flags_userdata, &index_copy));
  }

  QStringList mimeTypes() const override {
    if (mime_type_count_callback == nullptr || mime_type_callback == nullptr) {
      return QAbstractListModel::mimeTypes();
    }

    QStringList values;
    const auto count = mime_type_count_callback(mime_type_count_userdata);

    for (int index = 0; index < count; ++index) {
      char *text = mime_type_callback(mime_type_userdata, index);

      if (text == nullptr) {
        values << QString();
        continue;
      }

      values << QString::fromUtf8(text);
      std::free(text);
    }

    return values;
  }

  QMimeData *mimeData(const QModelIndexList &indexes) const override {
    if (mime_data_callback == nullptr) {
      return QAbstractListModel::mimeData(indexes);
    }

    std::vector<QModelIndex> index_storage;
    index_storage.reserve(static_cast<size_t>(indexes.size()));
    std::vector<qt6cr_handle_t> index_handles;
    index_handles.reserve(static_cast<size_t>(indexes.size()));

    for (const auto &index : indexes) {
      index_storage.emplace_back(index);
      index_handles.push_back(&index_storage.back());
    }

    return clone_mime_data(as_mime_data(mime_data_callback(
        mime_data_userdata,
        index_handles.empty() ? nullptr : index_handles.data(),
        static_cast<int>(index_handles.size()))));
  }

  bool dropMimeData(const QMimeData *data, Qt::DropAction action, int row, int column, const QModelIndex &parent) override {
    if (drop_mime_data_callback == nullptr) {
      return QAbstractListModel::dropMimeData(data, action, row, column, parent);
    }

    QModelIndex parent_copy(parent);
    return drop_mime_data_callback(drop_mime_data_userdata, const_cast<QMimeData *>(data), static_cast<int>(action), row, column, &parent_copy);
  }

  Qt::DropActions supportedDragActions() const override {
    return supported_drag_actions_callback == nullptr ? QAbstractListModel::supportedDragActions()
                                                      : static_cast<Qt::DropActions>(supported_drag_actions_callback(supported_drag_actions_userdata));
  }

  Qt::DropActions supportedDropActions() const override {
    return supported_drop_actions_callback == nullptr ? QAbstractListModel::supportedDropActions()
                                                      : static_cast<Qt::DropActions>(supported_drop_actions_callback(supported_drop_actions_userdata));
  }

  void beginResetModelBridge() {
    beginResetModel();
  }

  void endResetModelBridge() {
    endResetModel();
  }

  void beginInsertRowsBridge(int first, int last, const QModelIndex &parent = QModelIndex()) {
    beginInsertRows(parent, first, last);
  }

  void endInsertRowsBridge() {
    endInsertRows();
  }

  void beginRemoveRowsBridge(int first, int last, const QModelIndex &parent = QModelIndex()) {
    beginRemoveRows(parent, first, last);
  }

  void endRemoveRowsBridge() {
    endRemoveRows();
  }

  bool beginMoveRowsBridge(int source_first, int source_last, const QModelIndex &source_parent, int destination_child, const QModelIndex &destination_parent) {
    return beginMoveRows(source_parent, source_first, source_last, destination_parent, destination_child);
  }

  void endMoveRowsBridge() {
    endMoveRows();
  }

  void emitDataChangedBridge(const QModelIndex &top_left, const QModelIndex &bottom_right) {
    emit dataChanged(top_left, bottom_right);
  }
};

class CrystalAbstractTreeModel final : public QAbstractItemModel {
 public:
  explicit CrystalAbstractTreeModel(QObject *parent = nullptr) : QAbstractItemModel(parent) {}

  qt6cr_model_count_with_parent_callback_t row_count_callback = nullptr;
  void *row_count_userdata = nullptr;
  qt6cr_model_count_with_parent_callback_t column_count_callback = nullptr;
  void *column_count_userdata = nullptr;
  qt6cr_model_index_id_callback_t index_id_callback = nullptr;
  void *index_id_userdata = nullptr;
  qt6cr_model_parent_callback_t parent_callback = nullptr;
  void *parent_userdata = nullptr;
  qt6cr_model_data_callback_t data_callback = nullptr;
  void *data_userdata = nullptr;
  qt6cr_model_set_data_callback_t set_data_callback = nullptr;
  void *set_data_userdata = nullptr;
  qt6cr_model_header_data_callback_t header_data_callback = nullptr;
  void *header_data_userdata = nullptr;
  qt6cr_model_flags_callback_t flags_callback = nullptr;
  void *flags_userdata = nullptr;
  qt6cr_model_mime_type_count_callback_t mime_type_count_callback = nullptr;
  void *mime_type_count_userdata = nullptr;
  qt6cr_indexed_string_callback_t mime_type_callback = nullptr;
  void *mime_type_userdata = nullptr;
  qt6cr_model_mime_data_callback_t mime_data_callback = nullptr;
  void *mime_data_userdata = nullptr;
  qt6cr_model_drop_mime_data_callback_t drop_mime_data_callback = nullptr;
  void *drop_mime_data_userdata = nullptr;
  qt6cr_model_actions_callback_t supported_drag_actions_callback = nullptr;
  void *supported_drag_actions_userdata = nullptr;
  qt6cr_model_actions_callback_t supported_drop_actions_callback = nullptr;
  void *supported_drop_actions_userdata = nullptr;

  int rowCount(const QModelIndex &parent = QModelIndex()) const override {
    QModelIndex parent_copy(parent);
    return row_count_callback == nullptr ? 0 : row_count_callback(row_count_userdata, &parent_copy);
  }

  int columnCount(const QModelIndex &parent = QModelIndex()) const override {
    QModelIndex parent_copy(parent);
    return column_count_callback == nullptr ? 1 : column_count_callback(column_count_userdata, &parent_copy);
  }

  QModelIndex index(int row, int column, const QModelIndex &parent = QModelIndex()) const override {
    if (index_id_callback == nullptr) {
      return QModelIndex();
    }

    QModelIndex parent_copy(parent);
    const auto internal_id = index_id_callback(index_id_userdata, row, column, &parent_copy);
    return internal_id == 0 ? QModelIndex() : createIndex(row, column, static_cast<quintptr>(internal_id));
  }

  QModelIndex parent(const QModelIndex &index) const override {
    if (parent_callback == nullptr || !index.isValid()) {
      return QModelIndex();
    }

    QModelIndex index_copy(index);
    const auto spec = parent_callback(parent_userdata, &index_copy);

    if (!spec.valid || spec.internal_id == 0) {
      return QModelIndex();
    }

    return createIndex(spec.row, spec.column, static_cast<quintptr>(spec.internal_id));
  }

  QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override {
    if (data_callback == nullptr || !index.isValid()) {
      return QVariant();
    }

    QModelIndex index_copy(index);
    return from_variant_value(data_callback(data_userdata, &index_copy, role));
  }

  bool setData(const QModelIndex &index, const QVariant &value, int role = Qt::EditRole) override {
    if (set_data_callback == nullptr || !index.isValid()) {
      return false;
    }

    QModelIndex index_copy(index);
    return set_data_callback(set_data_userdata, &index_copy, to_variant_value(value), role);
  }

  QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override {
    if (header_data_callback == nullptr) {
      return QAbstractItemModel::headerData(section, orientation, role);
    }

    return from_variant_value(header_data_callback(header_data_userdata, section, static_cast<int>(orientation), role));
  }

  Qt::ItemFlags flags(const QModelIndex &index) const override {
    if (flags_callback == nullptr || !index.isValid()) {
      return QAbstractItemModel::flags(index);
    }

    QModelIndex index_copy(index);
    return static_cast<Qt::ItemFlags>(flags_callback(flags_userdata, &index_copy));
  }

  QStringList mimeTypes() const override {
    if (mime_type_count_callback == nullptr || mime_type_callback == nullptr) {
      return QAbstractItemModel::mimeTypes();
    }

    QStringList values;
    const auto count = mime_type_count_callback(mime_type_count_userdata);

    for (int index = 0; index < count; ++index) {
      char *text = mime_type_callback(mime_type_userdata, index);

      if (text == nullptr) {
        values << QString();
        continue;
      }

      values << QString::fromUtf8(text);
      std::free(text);
    }

    return values;
  }

  QMimeData *mimeData(const QModelIndexList &indexes) const override {
    if (mime_data_callback == nullptr) {
      return QAbstractItemModel::mimeData(indexes);
    }

    std::vector<QModelIndex> index_storage;
    index_storage.reserve(static_cast<size_t>(indexes.size()));
    std::vector<qt6cr_handle_t> index_handles;
    index_handles.reserve(static_cast<size_t>(indexes.size()));

    for (const auto &index : indexes) {
      index_storage.emplace_back(index);
      index_handles.push_back(&index_storage.back());
    }

    return clone_mime_data(as_mime_data(mime_data_callback(
        mime_data_userdata,
        index_handles.empty() ? nullptr : index_handles.data(),
        static_cast<int>(index_handles.size()))));
  }

  bool dropMimeData(const QMimeData *data, Qt::DropAction action, int row, int column, const QModelIndex &parent) override {
    if (drop_mime_data_callback == nullptr) {
      return QAbstractItemModel::dropMimeData(data, action, row, column, parent);
    }

    QModelIndex parent_copy(parent);
    return drop_mime_data_callback(drop_mime_data_userdata, const_cast<QMimeData *>(data), static_cast<int>(action), row, column, &parent_copy);
  }

  Qt::DropActions supportedDragActions() const override {
    return supported_drag_actions_callback == nullptr ? QAbstractItemModel::supportedDragActions()
                                                      : static_cast<Qt::DropActions>(supported_drag_actions_callback(supported_drag_actions_userdata));
  }

  Qt::DropActions supportedDropActions() const override {
    return supported_drop_actions_callback == nullptr ? QAbstractItemModel::supportedDropActions()
                                                      : static_cast<Qt::DropActions>(supported_drop_actions_callback(supported_drop_actions_userdata));
  }

  void beginResetModelBridge() {
    beginResetModel();
  }

  void endResetModelBridge() {
    endResetModel();
  }

  void beginInsertRowsBridge(int first, int last, const QModelIndex &parent = QModelIndex()) {
    beginInsertRows(parent, first, last);
  }

  void endInsertRowsBridge() {
    endInsertRows();
  }

  void beginRemoveRowsBridge(int first, int last, const QModelIndex &parent = QModelIndex()) {
    beginRemoveRows(parent, first, last);
  }

  void endRemoveRowsBridge() {
    endRemoveRows();
  }

  bool beginMoveRowsBridge(int source_first, int source_last, const QModelIndex &source_parent, int destination_child, const QModelIndex &destination_parent) {
    return beginMoveRows(source_parent, source_first, source_last, destination_parent, destination_child);
  }

  void endMoveRowsBridge() {
    endMoveRows();
  }

  void emitDataChangedBridge(const QModelIndex &top_left, const QModelIndex &bottom_right) {
    emit dataChanged(top_left, bottom_right);
  }
};

class CrystalStyledItemDelegate final : public QStyledItemDelegate {
 public:
  explicit CrystalStyledItemDelegate(QObject *parent = nullptr) : QStyledItemDelegate(parent) {}

  qt6cr_string_transform_callback_t display_text_callback = nullptr;
  void *display_text_userdata = nullptr;
  qt6cr_delegate_create_editor_callback_t create_editor_callback = nullptr;
  void *create_editor_userdata = nullptr;
  qt6cr_delegate_set_editor_data_callback_t set_editor_data_callback = nullptr;
  void *set_editor_data_userdata = nullptr;
  qt6cr_delegate_set_model_data_callback_t set_model_data_callback = nullptr;
  void *set_model_data_userdata = nullptr;

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

  QWidget *createEditor(QWidget *parent, const QStyleOptionViewItem &option, const QModelIndex &index) const override {
    if (create_editor_callback == nullptr) {
      return QStyledItemDelegate::createEditor(parent, option, index);
    }

    QModelIndex index_copy(index);
    auto *editor = as_widget(create_editor_callback(create_editor_userdata, parent, &index_copy));
    return editor == nullptr ? QStyledItemDelegate::createEditor(parent, option, index) : editor;
  }

  void setEditorData(QWidget *editor, const QModelIndex &index) const override {
    if (set_editor_data_callback == nullptr) {
      QStyledItemDelegate::setEditorData(editor, index);
      return;
    }

    QModelIndex index_copy(index);
    set_editor_data_callback(set_editor_data_userdata, editor, to_variant_value(index.data(Qt::EditRole)), &index_copy);
  }

  void setModelData(QWidget *editor, QAbstractItemModel *model, const QModelIndex &index) const override {
    if (set_model_data_callback == nullptr) {
      QStyledItemDelegate::setModelData(editor, model, index);
      return;
    }

    QModelIndex index_copy(index);
    set_model_data_callback(set_model_data_userdata, editor, model, &index_copy);
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

qt6cr_byte_array_t to_byte_array_value(const QByteArray &value) {
  const auto size = static_cast<int>(value.size());

  if (size <= 0) {
    return qt6cr_byte_array_t{nullptr, 0};
  }

  auto *copy = static_cast<unsigned char *>(std::malloc(static_cast<size_t>(size)));
  std::memcpy(copy, value.constData(), static_cast<size_t>(size));
  return qt6cr_byte_array_t{copy, size};
}

qt6cr_string_array_t to_string_array_value(const QStringList &values) {
  const auto size = static_cast<int>(values.size());

  if (size <= 0) {
    return qt6cr_string_array_t{nullptr, 0};
  }

  auto **copy = new char *[static_cast<size_t>(size)];

  for (int index = 0; index < size; ++index) {
    copy[index] = duplicate_string(values.at(index));
  }

  return qt6cr_string_array_t{copy, size};
}

QMimeData *clone_mime_data(const QMimeData *source) {
  if (source == nullptr) {
    return nullptr;
  }

  auto *copy = new QMimeData();

  if (source->hasText()) {
    copy->setText(source->text());
  }

  for (const auto &format : source->formats()) {
    copy->setData(format, source->data(format));
  }

  return copy;
}

QWidget *as_widget(qt6cr_handle_t handle) {
  return static_cast<QWidget *>(handle);
}

QMimeData *as_mime_data(qt6cr_handle_t handle) {
  return static_cast<QMimeData *>(handle);
}

QDropEvent *as_drop_event(qt6cr_handle_t handle) {
  return static_cast<QDropEvent *>(handle);
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

QProgressDialog *as_progress_dialog(qt6cr_handle_t handle) {
  return static_cast<QProgressDialog *>(handle);
}

QFontDialog *as_font_dialog(qt6cr_handle_t handle) {
  return static_cast<QFontDialog *>(handle);
}

QImage *as_qimage(qt6cr_handle_t handle) {
  return static_cast<QImage *>(handle);
}

QImageReader *as_qimage_reader(qt6cr_handle_t handle) {
  return static_cast<QImageReader *>(handle);
}

QIcon *as_qicon(qt6cr_handle_t handle) {
  return static_cast<QIcon *>(handle);
}

QSplashScreen *as_splash_screen(qt6cr_handle_t handle) {
  return static_cast<QSplashScreen *>(handle);
}

QAbstractItemModel *as_abstract_item_model(qt6cr_handle_t handle) {
  return static_cast<QAbstractItemModel *>(handle);
}

CrystalAbstractTreeModel *as_abstract_tree_model(qt6cr_handle_t handle) {
  return static_cast<CrystalAbstractTreeModel *>(handle);
}

CrystalAbstractListModel *as_abstract_list_model(qt6cr_handle_t handle) {
  return static_cast<CrystalAbstractListModel *>(handle);
}

QItemSelectionModel *as_item_selection_model(qt6cr_handle_t handle) {
  return static_cast<QItemSelectionModel *>(handle);
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

QByteArray *as_qbyte_array(qt6cr_handle_t handle) {
  return static_cast<QByteArray *>(handle);
}

QBuffer *as_qbuffer(qt6cr_handle_t handle) {
  return static_cast<QBuffer *>(handle);
}

QIODevice *as_qio_device(qt6cr_handle_t handle) {
  return static_cast<QIODevice *>(handle);
}

QPen *as_qpen(qt6cr_handle_t handle) {
  return static_cast<QPen *>(handle);
}

QLinearGradient *as_qlinear_gradient(qt6cr_handle_t handle) {
  return static_cast<QLinearGradient *>(handle);
}

QRadialGradient *as_qradial_gradient(qt6cr_handle_t handle) {
  return static_cast<QRadialGradient *>(handle);
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

QPolygonF *as_qpolygonf(qt6cr_handle_t handle) {
  return static_cast<QPolygonF *>(handle);
}

QPainterPath *as_qpainter_path(qt6cr_handle_t handle) {
  return static_cast<QPainterPath *>(handle);
}

QPainterPathStroker *as_qpainter_path_stroker(qt6cr_handle_t handle) {
  return static_cast<QPainterPathStroker *>(handle);
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

QAbstractButton *as_abstract_button(qt6cr_handle_t handle) {
  return dynamic_cast<QAbstractButton *>(as_widget(handle));
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

QDialogButtonBox *as_dialog_button_box(qt6cr_handle_t handle) {
  return static_cast<QDialogButtonBox *>(handle);
}

QButtonGroup *as_button_group(qt6cr_handle_t handle) {
  return static_cast<QButtonGroup *>(handle);
}

QLabel *as_label(qt6cr_handle_t handle) {
  return static_cast<QLabel *>(handle);
}

QPushButton *as_push_button(qt6cr_handle_t handle) {
  return static_cast<QPushButton *>(handle);
}

QToolButton *as_tool_button(qt6cr_handle_t handle) {
  return static_cast<QToolButton *>(handle);
}

QLineEdit *as_line_edit(qt6cr_handle_t handle) {
  return static_cast<QLineEdit *>(handle);
}

QValidator *as_validator(qt6cr_handle_t handle) {
  return static_cast<QValidator *>(handle);
}

QIntValidator *as_int_validator(qt6cr_handle_t handle) {
  return static_cast<QIntValidator *>(handle);
}

QDoubleValidator *as_double_validator(qt6cr_handle_t handle) {
  return static_cast<QDoubleValidator *>(handle);
}

QRegularExpressionValidator *as_regex_validator(qt6cr_handle_t handle) {
  return static_cast<QRegularExpressionValidator *>(handle);
}

QCompleter *as_completer(qt6cr_handle_t handle) {
  return static_cast<QCompleter *>(handle);
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

QFontComboBox *as_font_combo_box(qt6cr_handle_t handle) {
  return static_cast<QFontComboBox *>(handle);
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

QScrollBar *as_scroll_bar(qt6cr_handle_t handle) {
  return static_cast<QScrollBar *>(handle);
}

QDial *as_dial(qt6cr_handle_t handle) {
  return static_cast<QDial *>(handle);
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

QFrame *as_frame(qt6cr_handle_t handle) {
  return static_cast<QFrame *>(handle);
}

QProgressBar *as_progress_bar(qt6cr_handle_t handle) {
  return static_cast<QProgressBar *>(handle);
}

QDate *as_qdate(qt6cr_handle_t handle) {
  return static_cast<QDate *>(handle);
}

QUrl *as_qurl(qt6cr_handle_t handle) {
  return static_cast<QUrl *>(handle);
}

QDir *as_qdir(qt6cr_handle_t handle) {
  return static_cast<QDir *>(handle);
}

QFile *as_qfile(qt6cr_handle_t handle) {
  return static_cast<QFile *>(handle);
}

QSettings *as_qsettings(qt6cr_handle_t handle) {
  return static_cast<QSettings *>(handle);
}

QFileInfo *as_qfile_info(qt6cr_handle_t handle) {
  return static_cast<QFileInfo *>(handle);
}

QTime *as_qtime(qt6cr_handle_t handle) {
  return static_cast<QTime *>(handle);
}

QDateTime *as_qdatetime(qt6cr_handle_t handle) {
  return static_cast<QDateTime *>(handle);
}

QDateTimeEdit *as_date_time_edit(qt6cr_handle_t handle) {
  return static_cast<QDateTimeEdit *>(handle);
}

QDateEdit *as_date_edit(qt6cr_handle_t handle) {
  return static_cast<QDateEdit *>(handle);
}

QTimeEdit *as_time_edit(qt6cr_handle_t handle) {
  return static_cast<QTimeEdit *>(handle);
}

QCalendarWidget *as_calendar_widget(qt6cr_handle_t handle) {
  return static_cast<QCalendarWidget *>(handle);
}

QLCDNumber *as_lcd_number(qt6cr_handle_t handle) {
  return static_cast<QLCDNumber *>(handle);
}

QCommandLinkButton *as_command_link_button(qt6cr_handle_t handle) {
  return static_cast<QCommandLinkButton *>(handle);
}

QTextDocument *as_text_document(qt6cr_handle_t handle) {
  return static_cast<QTextDocument *>(handle);
}

QTextCursor *as_text_cursor(qt6cr_handle_t handle) {
  return static_cast<QTextCursor *>(handle);
}

QTextEdit *as_text_edit(qt6cr_handle_t handle) {
  return static_cast<QTextEdit *>(handle);
}

QPlainTextEdit *as_plain_text_edit(qt6cr_handle_t handle) {
  return static_cast<QPlainTextEdit *>(handle);
}

QTextBrowser *as_text_browser(qt6cr_handle_t handle) {
  return static_cast<QTextBrowser *>(handle);
}

QTabWidget *as_tab_widget(qt6cr_handle_t handle) {
  return static_cast<QTabWidget *>(handle);
}

QTabBar *as_tab_bar(qt6cr_handle_t handle) {
  return static_cast<QTabBar *>(handle);
}

QStackedWidget *as_stacked_widget(qt6cr_handle_t handle) {
  return static_cast<QStackedWidget *>(handle);
}

QStackedLayout *as_stacked_layout(qt6cr_handle_t handle) {
  return static_cast<QStackedLayout *>(handle);
}

QScrollArea *as_scroll_area(qt6cr_handle_t handle) {
  return static_cast<QScrollArea *>(handle);
}

QSplitter *as_splitter(qt6cr_handle_t handle) {
  return static_cast<QSplitter *>(handle);
}

QLayout *as_layout(qt6cr_handle_t handle) {
  return static_cast<QLayout *>(handle);
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

QHeaderView *as_header_view(qt6cr_handle_t handle) {
  return static_cast<QHeaderView *>(handle);
}

ModelTableView *as_table_view(qt6cr_handle_t handle) {
  return static_cast<ModelTableView *>(handle);
}

QTreeWidgetItem *as_tree_widget_item(qt6cr_handle_t handle) {
  return static_cast<QTreeWidgetItem *>(handle);
}

QTreeWidget *as_tree_widget(qt6cr_handle_t handle) {
  return static_cast<QTreeWidget *>(handle);
}

QTableWidgetItem *as_table_widget_item(qt6cr_handle_t handle) {
  return static_cast<QTableWidgetItem *>(handle);
}

QTableWidget *as_table_widget(qt6cr_handle_t handle) {
  return static_cast<QTableWidget *>(handle);
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

CrystalEventFilter *as_event_filter(qt6cr_handle_t handle) {
  return static_cast<CrystalEventFilter *>(handle);
}

EventWidget *as_event_widget(qt6cr_handle_t handle) {
  return static_cast<EventWidget *>(handle);
}

QAbstractSpinBox *as_abstract_spin_box(qt6cr_handle_t handle) {
  return static_cast<QAbstractSpinBox *>(handle);
}

QAbstractItemView *as_abstract_item_view(qt6cr_handle_t handle) {
  return static_cast<QAbstractItemView *>(handle);
}

QAbstractScrollArea *as_abstract_scroll_area(qt6cr_handle_t handle) {
  return static_cast<QAbstractScrollArea *>(handle);
}

QTimer *as_timer(qt6cr_handle_t handle) {
  return static_cast<QTimer *>(handle);
}

CrystalUndoCommand *as_undo_command(qt6cr_handle_t handle) {
  return static_cast<CrystalUndoCommand *>(handle);
}

QUndoStack *as_undo_stack(qt6cr_handle_t handle) {
  return static_cast<QUndoStack *>(handle);
}

QUndoGroup *as_undo_group(qt6cr_handle_t handle) {
  return static_cast<QUndoGroup *>(handle);
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

qt6cr_sizef_t to_sizef(const QSizeF &size) {
  return qt6cr_sizef_t{size.width(), size.height()};
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
    case 5:
      return QImage::Format_Alpha8;
    case 4:
      return QImage::Format_Grayscale8;
    case 3:
      return QImage::Format_RGB888;
    case 2:
      return QImage::Format_ARGB32_Premultiplied;
    case 1:
      return QImage::Format_RGB32;
    case 0:
    default:
      return QImage::Format_ARGB32;
  }
}

int image_format_to_int(QImage::Format format) {
  switch (format) {
    case QImage::Format_ARGB32:
      return 0;
    case QImage::Format_RGB32:
      return 1;
    case QImage::Format_ARGB32_Premultiplied:
      return 2;
    case QImage::Format_RGB888:
      return 3;
    case QImage::Format_Grayscale8:
      return 4;
    case QImage::Format_Alpha8:
      return 5;
    default:
      return -1;
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

void send_wheel_event(QWidget *widget, qt6cr_pointf_t position, qt6cr_pointf_t pixel_delta, qt6cr_pointf_t angle_delta, int buttons, int modifiers) {
  if (widget == nullptr) {
    return;
  }

  const QPointF local_pos(position.x, position.y);
  QWheelEvent event(
      local_pos,
      local_pos,
      QPoint(static_cast<int>(pixel_delta.x), static_cast<int>(pixel_delta.y)),
      QPoint(static_cast<int>(angle_delta.x), static_cast<int>(angle_delta.y)),
      Qt::MouseButtons(buttons),
      Qt::KeyboardModifiers(modifiers),
      Qt::NoScrollPhase,
      false);
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

bool qt6cr_object_block_signals(qt6cr_handle_t handle, bool block) {
  auto *object = as_object(handle);
  return object != nullptr && object->blockSignals(block);
}

bool qt6cr_object_signals_blocked(qt6cr_handle_t handle) {
  auto *object = as_object(handle);
  return object != nullptr && object->signalsBlocked();
}

void qt6cr_object_install_event_filter(qt6cr_handle_t handle, qt6cr_handle_t filter) {
  auto *object = as_object(handle);
  auto *event_filter = as_event_filter(filter);

  if (object != nullptr && event_filter != nullptr) {
    object->installEventFilter(event_filter);
  }
}

void qt6cr_object_remove_event_filter(qt6cr_handle_t handle, qt6cr_handle_t filter) {
  auto *object = as_object(handle);
  auto *event_filter = as_event_filter(filter);

  if (object != nullptr && event_filter != nullptr) {
    object->removeEventFilter(event_filter);
  }
}

qt6cr_handle_t qt6cr_event_filter_create(qt6cr_handle_t parent) {
  return new CrystalEventFilter(as_object(parent));
}

void qt6cr_event_filter_on_event(qt6cr_handle_t handle, qt6cr_event_filter_callback_t callback, void *userdata) {
  auto *event_filter = as_event_filter(handle);

  if (event_filter == nullptr) {
    return;
  }

  event_filter->event_callback = callback;
  event_filter->event_userdata = userdata;
}

int qt6cr_event_type(qt6cr_handle_t handle) {
  auto *event = static_cast<QEvent *>(handle);
  return event == nullptr ? 0 : static_cast<int>(event->type());
}

void qt6cr_event_accept(qt6cr_handle_t handle) {
  auto *event = static_cast<QEvent *>(handle);

  if (event != nullptr) {
    event->accept();
  }
}

void qt6cr_event_ignore(qt6cr_handle_t handle) {
  auto *event = static_cast<QEvent *>(handle);

  if (event != nullptr) {
    event->ignore();
  }
}

bool qt6cr_event_is_accepted(qt6cr_handle_t handle) {
  auto *event = static_cast<QEvent *>(handle);
  return event != nullptr && event->isAccepted();
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

bool qt6cr_application_invoke_later(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *state = as_application_state(handle);

  if (state == nullptr || state->application == nullptr || callback == nullptr) {
    return false;
  }

  return QMetaObject::invokeMethod(state->application, [callback, userdata]() {
    callback(userdata);
  }, Qt::QueuedConnection);
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

char *qt6cr_application_name(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);
  return state == nullptr || state->application == nullptr ? duplicate_string("") : duplicate_string(state->application->applicationName());
}

void qt6cr_application_set_name(qt6cr_handle_t handle, const char *name) {
  auto *state = as_application_state(handle);

  if (state != nullptr && state->application != nullptr) {
    state->application->setApplicationName(QString::fromUtf8(name == nullptr ? "" : name));
  }
}

char *qt6cr_application_organization_name(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);
  return state == nullptr || state->application == nullptr ? duplicate_string("") : duplicate_string(state->application->organizationName());
}

void qt6cr_application_set_organization_name(qt6cr_handle_t handle, const char *name) {
  auto *state = as_application_state(handle);

  if (state != nullptr && state->application != nullptr) {
    state->application->setOrganizationName(QString::fromUtf8(name == nullptr ? "" : name));
  }
}

char *qt6cr_application_organization_domain(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);
  return state == nullptr || state->application == nullptr ? duplicate_string("") : duplicate_string(state->application->organizationDomain());
}

void qt6cr_application_set_organization_domain(qt6cr_handle_t handle, const char *domain) {
  auto *state = as_application_state(handle);

  if (state != nullptr && state->application != nullptr) {
    state->application->setOrganizationDomain(QString::fromUtf8(domain == nullptr ? "" : domain));
  }
}

char *qt6cr_application_style_sheet(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);
  return state == nullptr || state->application == nullptr ? duplicate_string("") : duplicate_string(state->application->styleSheet());
}

void qt6cr_application_set_style_sheet(qt6cr_handle_t handle, const char *style_sheet) {
  auto *state = as_application_state(handle);

  if (state != nullptr && state->application != nullptr) {
    state->application->setStyleSheet(QString::fromUtf8(style_sheet == nullptr ? "" : style_sheet));
  }
}

qt6cr_handle_t qt6cr_application_window_icon(qt6cr_handle_t handle) {
  auto *state = as_application_state(handle);
  return state == nullptr || state->application == nullptr ? new QIcon() : new QIcon(state->application->windowIcon());
}

void qt6cr_application_set_window_icon(qt6cr_handle_t handle, qt6cr_handle_t icon) {
  auto *state = as_application_state(handle);
  auto *window_icon = as_qicon(icon);

  if (state != nullptr && state->application != nullptr && window_icon != nullptr) {
    state->application->setWindowIcon(*window_icon);
  }
}

qt6cr_handle_t qt6cr_event_loop_create(qt6cr_handle_t parent) {
  return new QEventLoop(as_object(parent));
}

int qt6cr_event_loop_exec(qt6cr_handle_t handle) {
  auto *event_loop = static_cast<QEventLoop *>(handle);
  return event_loop == nullptr ? -1 : event_loop->exec();
}

void qt6cr_event_loop_quit(qt6cr_handle_t handle) {
  auto *event_loop = static_cast<QEventLoop *>(handle);

  if (event_loop != nullptr) {
    event_loop->quit();
  }
}

void qt6cr_event_loop_exit(qt6cr_handle_t handle, int return_code) {
  auto *event_loop = static_cast<QEventLoop *>(handle);

  if (event_loop != nullptr) {
    event_loop->exit(return_code);
  }
}

void qt6cr_event_loop_process_events(qt6cr_handle_t handle) {
  auto *event_loop = static_cast<QEventLoop *>(handle);

  if (event_loop != nullptr) {
    event_loop->processEvents();
  }
}

bool qt6cr_event_loop_is_running(qt6cr_handle_t handle) {
  auto *event_loop = static_cast<QEventLoop *>(handle);
  return event_loop != nullptr && event_loop->isRunning();
}

static QByteArray encoded_png_data(const QImage &image) {
  QByteArray bytes;
  QBuffer buffer(&bytes);
  if (buffer.open(QIODevice::WriteOnly)) {
    image.save(&buffer, "PNG");
  }
  return bytes;
}

static void set_mime_image_data(QMimeData *mime_data, const QImage &image) {
  if (mime_data == nullptr) {
    return;
  }

  mime_data->setImageData(image);

  const auto png_data = encoded_png_data(image);
  if (!png_data.isEmpty()) {
    mime_data->setData("image/png", png_data);
  }
}

static bool mime_data_has_image_data(const QMimeData *mime_data) {
  return mime_data != nullptr && (mime_data->hasImage() || mime_data->hasFormat("image/png"));
}

static QImage image_from_mime_data(const QMimeData *mime_data) {
  if (mime_data == nullptr) {
    return QImage();
  }

  if (mime_data->hasImage()) {
    const auto image_data = mime_data->imageData();
    if (image_data.canConvert<QImage>()) {
      return qvariant_cast<QImage>(image_data);
    }
    if (image_data.canConvert<QPixmap>()) {
      return qvariant_cast<QPixmap>(image_data).toImage();
    }
  }

  if (mime_data->hasFormat("image/png")) {
    return QImage::fromData(mime_data->data("image/png"), "PNG");
  }

  return QImage();
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

bool qt6cr_clipboard_has_text(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);
  return clipboard != nullptr && clipboard->mimeData() != nullptr && clipboard->mimeData()->hasText();
}

qt6cr_handle_t qt6cr_clipboard_image(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);

  if (clipboard == nullptr) {
    return new QImage();
  }

  auto mime_image = image_from_mime_data(clipboard->mimeData());
  if (!mime_image.isNull()) {
    return new QImage(mime_image);
  }

  auto image = clipboard->image();
  if (!image.isNull()) {
    return new QImage(image);
  }

  const auto pixmap = clipboard->pixmap();
  return pixmap.isNull() ? new QImage() : new QImage(pixmap.toImage());
}

void qt6cr_clipboard_set_image(qt6cr_handle_t handle, qt6cr_handle_t image) {
  auto *clipboard = as_clipboard(handle);
  auto *source = as_qimage(image);

  if (clipboard != nullptr && source != nullptr) {
    auto *mime_data = new QMimeData();
    set_mime_image_data(mime_data, *source);
    clipboard->setMimeData(mime_data);
  }
}

bool qt6cr_clipboard_has_image(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);
  return clipboard != nullptr && mime_data_has_image_data(clipboard->mimeData());
}

qt6cr_handle_t qt6cr_clipboard_pixmap(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);

  if (clipboard == nullptr) {
    return new QPixmap();
  }

  auto mime_image = image_from_mime_data(clipboard->mimeData());
  if (!mime_image.isNull()) {
    return new QPixmap(QPixmap::fromImage(mime_image));
  }

  auto pixmap = clipboard->pixmap();
  if (!pixmap.isNull()) {
    return new QPixmap(pixmap);
  }

  const auto image = clipboard->image();
  return image.isNull() ? new QPixmap() : new QPixmap(QPixmap::fromImage(image));
}

void qt6cr_clipboard_set_pixmap(qt6cr_handle_t handle, qt6cr_handle_t pixmap) {
  auto *clipboard = as_clipboard(handle);
  auto *source = as_qpixmap(pixmap);

  if (clipboard != nullptr && source != nullptr) {
    auto *mime_data = new QMimeData();
    set_mime_image_data(mime_data, source->toImage());
    clipboard->setMimeData(mime_data);
  }
}

bool qt6cr_clipboard_has_pixmap(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);
  return clipboard != nullptr && mime_data_has_image_data(clipboard->mimeData());
}

qt6cr_handle_t qt6cr_clipboard_mime_data(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);
  return clipboard == nullptr ? nullptr : const_cast<QMimeData *>(clipboard->mimeData());
}

void qt6cr_clipboard_set_mime_data(qt6cr_handle_t handle, qt6cr_handle_t mime_data) {
  auto *clipboard = as_clipboard(handle);
  auto *source = as_mime_data(mime_data);

  if (clipboard == nullptr || source == nullptr) {
    return;
  }

  auto *copy = new QMimeData();

  if (source->hasText()) {
    copy->setText(source->text());
  }

  if (source->hasHtml()) {
    copy->setHtml(source->html());
  }

  if (source->hasImage()) {
    copy->setImageData(source->imageData());
  }

  const auto formats = source->formats();
  for (const auto &format : formats) {
    copy->setData(format, source->data(format));
  }

  clipboard->setMimeData(copy);
}

void qt6cr_clipboard_clear(qt6cr_handle_t handle) {
  auto *clipboard = as_clipboard(handle);

  if (clipboard != nullptr) {
    clipboard->clear();
  }
}

qt6cr_handle_t qt6cr_mime_data_create(void) {
  return new QMimeData();
}

bool qt6cr_mime_data_has_text(qt6cr_handle_t handle) {
  auto *mime_data = as_mime_data(handle);
  return mime_data != nullptr && mime_data->hasText();
}

char *qt6cr_mime_data_text(qt6cr_handle_t handle) {
  auto *mime_data = as_mime_data(handle);
  return mime_data == nullptr ? duplicate_string("") : duplicate_string(mime_data->text());
}

void qt6cr_mime_data_set_text(qt6cr_handle_t handle, const char *text) {
  auto *mime_data = as_mime_data(handle);

  if (mime_data != nullptr) {
    mime_data->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

bool qt6cr_mime_data_has_html(qt6cr_handle_t handle) {
  auto *mime_data = as_mime_data(handle);
  return mime_data != nullptr && mime_data->hasHtml();
}

char *qt6cr_mime_data_html(qt6cr_handle_t handle) {
  auto *mime_data = as_mime_data(handle);
  return mime_data == nullptr ? duplicate_string("") : duplicate_string(mime_data->html());
}

void qt6cr_mime_data_set_html(qt6cr_handle_t handle, const char *html) {
  auto *mime_data = as_mime_data(handle);

  if (mime_data != nullptr) {
    mime_data->setHtml(QString::fromUtf8(html == nullptr ? "" : html));
  }
}

bool qt6cr_mime_data_has_image(qt6cr_handle_t handle) {
  auto *mime_data = as_mime_data(handle);
  return mime_data_has_image_data(mime_data);
}

qt6cr_handle_t qt6cr_mime_data_image(qt6cr_handle_t handle) {
  auto *mime_data = as_mime_data(handle);
  return new QImage(image_from_mime_data(mime_data));
}

void qt6cr_mime_data_set_image(qt6cr_handle_t handle, qt6cr_handle_t image) {
  auto *mime_data = as_mime_data(handle);
  auto *source = as_qimage(image);

  if (mime_data != nullptr && source != nullptr) {
    set_mime_image_data(mime_data, *source);
  }
}

qt6cr_string_array_t qt6cr_mime_data_formats(qt6cr_handle_t handle) {
  auto *mime_data = as_mime_data(handle);
  return mime_data == nullptr ? qt6cr_string_array_t{nullptr, 0} : to_string_array_value(mime_data->formats());
}

bool qt6cr_mime_data_has_format(qt6cr_handle_t handle, const char *format) {
  auto *mime_data = as_mime_data(handle);
  return mime_data != nullptr && mime_data->hasFormat(format == nullptr ? "" : format);
}

qt6cr_byte_array_t qt6cr_mime_data_data(qt6cr_handle_t handle, const char *format) {
  auto *mime_data = as_mime_data(handle);
  return mime_data == nullptr ? qt6cr_byte_array_t{nullptr, 0} : to_byte_array_value(mime_data->data(format == nullptr ? "" : format));
}

void qt6cr_mime_data_set_data(qt6cr_handle_t handle, const char *format, const unsigned char *data, int size) {
  auto *mime_data = as_mime_data(handle);

  if (mime_data != nullptr && format != nullptr) {
    mime_data->setData(format, QByteArray(reinterpret_cast<const char *>(data), size));
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

void qt6cr_widget_hide(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->hide();
  }
}

void qt6cr_widget_set_visible(qt6cr_handle_t handle, bool value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setVisible(value);
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

char *qt6cr_widget_style_sheet(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? duplicate_string("") : duplicate_string(widget->styleSheet());
}

void qt6cr_widget_set_style_sheet(qt6cr_handle_t handle, const char *style_sheet) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setStyleSheet(QString::fromUtf8(style_sheet == nullptr ? "" : style_sheet));
  }
}

char *qt6cr_widget_tool_tip(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? duplicate_string("") : duplicate_string(widget->toolTip());
}

void qt6cr_widget_set_tool_tip(qt6cr_handle_t handle, const char *tool_tip) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setToolTip(QString::fromUtf8(tool_tip == nullptr ? "" : tool_tip));
  }
}

qt6cr_handle_t qt6cr_widget_window_icon(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? new QIcon() : new QIcon(widget->windowIcon());
}

void qt6cr_widget_set_window_icon(qt6cr_handle_t handle, qt6cr_handle_t icon) {
  auto *widget = as_widget(handle);
  auto *window_icon = as_qicon(icon);

  if (widget != nullptr && window_icon != nullptr) {
    widget->setWindowIcon(*window_icon);
  }
}

bool qt6cr_widget_is_enabled(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget != nullptr && widget->isEnabled();
}

void qt6cr_widget_set_enabled(qt6cr_handle_t handle, bool value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setEnabled(value);
  }
}

bool qt6cr_widget_has_focus(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget != nullptr && widget->hasFocus();
}

int qt6cr_widget_focus_policy(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? static_cast<int>(Qt::NoFocus) : static_cast<int>(widget->focusPolicy());
}

void qt6cr_widget_set_focus_policy(qt6cr_handle_t handle, int value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setFocusPolicy(static_cast<Qt::FocusPolicy>(value));
  }
}

void qt6cr_widget_set_focus(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setFocus();
  }
}

void qt6cr_widget_clear_focus(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->clearFocus();
  }
}

void qt6cr_widget_move(qt6cr_handle_t handle, int x, int y) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->move(x, y);
  }
}

void qt6cr_widget_adjust_size(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->adjustSize();
  }
}

void qt6cr_widget_raise_to_front(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->raise();
  }
}

void qt6cr_widget_set_fixed_width(qt6cr_handle_t handle, int value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setFixedWidth(value);
  }
}

void qt6cr_widget_set_fixed_height(qt6cr_handle_t handle, int value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setFixedHeight(value);
  }
}

void qt6cr_widget_set_fixed_size(qt6cr_handle_t handle, int width, int height) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setFixedSize(width, height);
  }
}

qt6cr_size_t qt6cr_widget_minimum_size(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? qt6cr_size_t{0, 0} : to_size(widget->minimumSize());
}

void qt6cr_widget_set_minimum_size(qt6cr_handle_t handle, int width, int height) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setMinimumSize(width, height);
  }
}

qt6cr_size_t qt6cr_widget_maximum_size(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? qt6cr_size_t{QWIDGETSIZE_MAX, QWIDGETSIZE_MAX} : to_size(widget->maximumSize());
}

void qt6cr_widget_set_maximum_size(qt6cr_handle_t handle, int width, int height) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setMaximumSize(width, height);
  }
}

int qt6cr_widget_maximum_width(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? QWIDGETSIZE_MAX : widget->maximumWidth();
}

void qt6cr_widget_set_maximum_width(qt6cr_handle_t handle, int value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setMaximumWidth(value);
  }
}

int qt6cr_widget_maximum_height(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? QWIDGETSIZE_MAX : widget->maximumHeight();
}

void qt6cr_widget_set_maximum_height(qt6cr_handle_t handle, int value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setMaximumHeight(value);
  }
}

void qt6cr_widget_simulate_wheel(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_pointf_t pixel_delta, qt6cr_pointf_t angle_delta, int buttons, int modifiers) {
  send_wheel_event(as_widget(handle), position, pixel_delta, angle_delta, buttons, modifiers);
}

int qt6cr_widget_horizontal_size_policy(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? static_cast<int>(QSizePolicy::Preferred) : static_cast<int>(widget->sizePolicy().horizontalPolicy());
}

int qt6cr_widget_vertical_size_policy(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? static_cast<int>(QSizePolicy::Preferred) : static_cast<int>(widget->sizePolicy().verticalPolicy());
}

void qt6cr_widget_set_size_policy(qt6cr_handle_t handle, int horizontal, int vertical) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setSizePolicy(static_cast<QSizePolicy::Policy>(horizontal), static_cast<QSizePolicy::Policy>(vertical));
  }
}

int qt6cr_widget_minimum_width(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? 0 : widget->minimumWidth();
}

void qt6cr_widget_set_minimum_width(qt6cr_handle_t handle, int value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setMinimumWidth(value);
  }
}

int qt6cr_widget_minimum_height(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? 0 : widget->minimumHeight();
}

void qt6cr_widget_set_minimum_height(qt6cr_handle_t handle, int value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setMinimumHeight(value);
  }
}

bool qt6cr_widget_accept_drops(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget != nullptr && widget->acceptDrops();
}

void qt6cr_widget_set_accept_drops(qt6cr_handle_t handle, bool value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setAcceptDrops(value);
  }
}

bool qt6cr_widget_mouse_tracking(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget != nullptr && widget->hasMouseTracking();
}

void qt6cr_widget_set_mouse_tracking(qt6cr_handle_t handle, bool value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setMouseTracking(value);
  }
}

int qt6cr_widget_cursor_shape(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget == nullptr ? static_cast<int>(Qt::ArrowCursor) : static_cast<int>(widget->cursor().shape());
}

void qt6cr_widget_set_cursor_shape(qt6cr_handle_t handle, int value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setCursor(static_cast<Qt::CursorShape>(value));
  }
}

bool qt6cr_widget_transparent_for_mouse_events(qt6cr_handle_t handle) {
  auto *widget = as_widget(handle);
  return widget != nullptr && widget->testAttribute(Qt::WA_TransparentForMouseEvents);
}

void qt6cr_widget_set_transparent_for_mouse_events(qt6cr_handle_t handle, bool value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setAttribute(Qt::WA_TransparentForMouseEvents, value);
  }
}

bool qt6cr_widget_test_attribute(qt6cr_handle_t handle, int attribute) {
  auto *widget = as_widget(handle);
  return widget != nullptr && widget->testAttribute(static_cast<Qt::WidgetAttribute>(attribute));
}

void qt6cr_widget_set_attribute(qt6cr_handle_t handle, int attribute, bool value) {
  auto *widget = as_widget(handle);

  if (widget != nullptr) {
    widget->setAttribute(static_cast<Qt::WidgetAttribute>(attribute), value);
  }
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

void qt6cr_main_window_remove_tool_bar(qt6cr_handle_t handle, qt6cr_handle_t toolbar) {
  auto *window = as_main_window(handle);
  auto *tool_bar = as_tool_bar(toolbar);

  if (window != nullptr && tool_bar != nullptr) {
    window->removeToolBar(tool_bar);
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

qt6cr_string_array_t qt6cr_file_dialog_selected_files(qt6cr_handle_t handle) {
  auto *file_dialog = as_file_dialog(handle);
  return file_dialog == nullptr ? qt6cr_string_array_t{nullptr, 0} : to_string_array_value(file_dialog->selectedFiles());
}

char *qt6cr_file_dialog_get_open_file_name(qt6cr_handle_t parent, const char *title, const char *directory, const char *filter) {
  const auto result = QFileDialog::getOpenFileName(
      as_widget(parent),
      QString::fromUtf8(title == nullptr ? "" : title),
      QString::fromUtf8(directory == nullptr ? "" : directory),
      QString::fromUtf8(filter == nullptr ? "" : filter));
  return result.isEmpty() ? nullptr : duplicate_string(result);
}

qt6cr_string_array_t qt6cr_file_dialog_get_open_file_names(qt6cr_handle_t parent, const char *title, const char *directory, const char *filter) {
  const auto result = QFileDialog::getOpenFileNames(
      as_widget(parent),
      QString::fromUtf8(title == nullptr ? "" : title),
      QString::fromUtf8(directory == nullptr ? "" : directory),
      QString::fromUtf8(filter == nullptr ? "" : filter));
  return to_string_array_value(result);
}

char *qt6cr_file_dialog_get_save_file_name(qt6cr_handle_t parent, const char *title, const char *directory, const char *filter) {
  const auto result = QFileDialog::getSaveFileName(
      as_widget(parent),
      QString::fromUtf8(title == nullptr ? "" : title),
      QString::fromUtf8(directory == nullptr ? "" : directory),
      QString::fromUtf8(filter == nullptr ? "" : filter));
  return result.isEmpty() ? nullptr : duplicate_string(result);
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

qt6cr_handle_t qt6cr_font_dialog_create(qt6cr_handle_t parent, qt6cr_handle_t initial_font) {
  auto *font = as_qfont(initial_font);
  return font == nullptr ? new QFontDialog(as_widget(parent)) : new QFontDialog(*font, as_widget(parent));
}

void qt6cr_font_dialog_set_current_font(qt6cr_handle_t handle, qt6cr_handle_t font) {
  auto *dialog = as_font_dialog(handle);
  auto *value = as_qfont(font);

  if (dialog != nullptr && value != nullptr) {
    dialog->setCurrentFont(*value);
  }
}

qt6cr_handle_t qt6cr_font_dialog_current_font(qt6cr_handle_t handle) {
  auto *dialog = as_font_dialog(handle);
  return dialog == nullptr ? new QFont() : new QFont(dialog->currentFont());
}

qt6cr_handle_t qt6cr_font_dialog_selected_font(qt6cr_handle_t handle) {
  auto *dialog = as_font_dialog(handle);
  return dialog == nullptr ? new QFont() : new QFont(dialog->selectedFont());
}

void qt6cr_font_dialog_set_options(qt6cr_handle_t handle, int options) {
  auto *dialog = as_font_dialog(handle);

  if (dialog != nullptr) {
    dialog->setOptions(static_cast<QFontDialog::FontDialogOptions>(options));
  }
}

int qt6cr_font_dialog_options(qt6cr_handle_t handle) {
  auto *dialog = as_font_dialog(handle);
  return dialog == nullptr ? 0 : static_cast<int>(dialog->options());
}

void qt6cr_font_dialog_set_option(qt6cr_handle_t handle, int option, bool value) {
  auto *dialog = as_font_dialog(handle);

  if (dialog != nullptr) {
    dialog->setOption(static_cast<QFontDialog::FontDialogOption>(option), value);
  }
}

bool qt6cr_font_dialog_test_option(qt6cr_handle_t handle, int option) {
  auto *dialog = as_font_dialog(handle);
  return dialog != nullptr && dialog->testOption(static_cast<QFontDialog::FontDialogOption>(option));
}

void qt6cr_font_dialog_set_native_dialog(qt6cr_handle_t handle, bool value) {
  auto *dialog = as_font_dialog(handle);

  if (dialog != nullptr) {
    dialog->setOption(QFontDialog::DontUseNativeDialog, !value);
  }
}

bool qt6cr_font_dialog_native_dialog(qt6cr_handle_t handle) {
  auto *dialog = as_font_dialog(handle);
  return dialog != nullptr && !dialog->testOption(QFontDialog::DontUseNativeDialog);
}

void qt6cr_font_dialog_on_current_font_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *dialog = as_font_dialog(handle);

  if (dialog == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(dialog, &QFontDialog::currentFontChanged, dialog, [callback, userdata](const QFont &font) {
    callback(userdata, new QFont(font));
  });
}

void qt6cr_font_dialog_on_font_selected(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *dialog = as_font_dialog(handle);

  if (dialog == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(dialog, &QFontDialog::fontSelected, dialog, [callback, userdata](const QFont &font) {
    callback(userdata, new QFont(font));
  });
}

qt6cr_handle_t qt6cr_progress_dialog_create(qt6cr_handle_t parent, const char *label_text, const char *cancel_button_text, int minimum, int maximum) {
  return new QProgressDialog(
      QString::fromUtf8(label_text == nullptr ? "" : label_text),
      QString::fromUtf8(cancel_button_text == nullptr ? "" : cancel_button_text),
      minimum,
      maximum,
      as_widget(parent));
}

char *qt6cr_progress_dialog_label_text(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);
  return dialog == nullptr ? duplicate_string("") : duplicate_string(dialog->labelText());
}

void qt6cr_progress_dialog_set_label_text(qt6cr_handle_t handle, const char *label_text) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->setLabelText(QString::fromUtf8(label_text == nullptr ? "" : label_text));
  }
}

void qt6cr_progress_dialog_set_cancel_button_text(qt6cr_handle_t handle, const char *cancel_button_text) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->setCancelButtonText(QString::fromUtf8(cancel_button_text == nullptr ? "" : cancel_button_text));
  }
}

int qt6cr_progress_dialog_minimum(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);
  return dialog == nullptr ? 0 : dialog->minimum();
}

void qt6cr_progress_dialog_set_minimum(qt6cr_handle_t handle, int value) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->setMinimum(value);
  }
}

int qt6cr_progress_dialog_maximum(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);
  return dialog == nullptr ? 0 : dialog->maximum();
}

void qt6cr_progress_dialog_set_maximum(qt6cr_handle_t handle, int value) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->setMaximum(value);
  }
}

void qt6cr_progress_dialog_set_range(qt6cr_handle_t handle, int minimum, int maximum) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->setRange(minimum, maximum);
  }
}

int qt6cr_progress_dialog_value(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);
  return dialog == nullptr ? 0 : dialog->value();
}

void qt6cr_progress_dialog_set_value(qt6cr_handle_t handle, int value) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->setValue(value);
  }
}

bool qt6cr_progress_dialog_auto_close(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);
  return dialog != nullptr && dialog->autoClose();
}

void qt6cr_progress_dialog_set_auto_close(qt6cr_handle_t handle, bool value) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->setAutoClose(value);
  }
}

bool qt6cr_progress_dialog_auto_reset(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);
  return dialog != nullptr && dialog->autoReset();
}

void qt6cr_progress_dialog_set_auto_reset(qt6cr_handle_t handle, bool value) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->setAutoReset(value);
  }
}

int qt6cr_progress_dialog_minimum_duration(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);
  return dialog == nullptr ? 0 : dialog->minimumDuration();
}

void qt6cr_progress_dialog_set_minimum_duration(qt6cr_handle_t handle, int value) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->setMinimumDuration(value);
  }
}

bool qt6cr_progress_dialog_was_canceled(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);
  return dialog != nullptr && dialog->wasCanceled();
}

void qt6cr_progress_dialog_cancel(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->cancel();
  }
}

void qt6cr_progress_dialog_reset(qt6cr_handle_t handle) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog != nullptr) {
    dialog->reset();
  }
}

void qt6cr_progress_dialog_on_canceled(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *dialog = as_progress_dialog(handle);

  if (dialog == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(dialog, &QProgressDialog::canceled, dialog, [callback, userdata]() {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_qimage_create(int width, int height, int format) {
  return new QImage(width, height, image_format_from_int(format));
}

qt6cr_handle_t qt6cr_qimage_create_from_file(const char *path) {
  return new QImage(QString::fromUtf8(path == nullptr ? "" : path));
}

qt6cr_handle_t qt6cr_qimage_create_from_raw_data(const unsigned char *data, int size, int width, int height, int bytes_per_line, int format) {
  if (data == nullptr || size <= 0 || width <= 0 || height <= 0 || bytes_per_line <= 0) {
    return new QImage();
  }

  const auto required_size = static_cast<long long>(bytes_per_line) * static_cast<long long>(height);
  if (required_size <= 0 || required_size > size) {
    return new QImage();
  }

  const QImage image(reinterpret_cast<const uchar *>(data), width, height, bytes_per_line, image_format_from_int(format));
  return new QImage(image.copy());
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

int qt6cr_qimage_format(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image == nullptr ? -1 : image_format_to_int(image->format());
}

int qt6cr_qimage_depth(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image == nullptr ? 0 : image->depth();
}

int qt6cr_qimage_bytes_per_line(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image == nullptr ? 0 : image->bytesPerLine();
}

int qt6cr_qimage_size_in_bytes(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image == nullptr ? 0 : static_cast<int>(image->sizeInBytes());
}

qt6cr_byte_array_t qt6cr_qimage_const_bits(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);

  if (image == nullptr || image->constBits() == nullptr || image->sizeInBytes() <= 0) {
    return qt6cr_byte_array_t{nullptr, 0};
  }

  return to_byte_array_value(QByteArray(reinterpret_cast<const char *>(image->constBits()), static_cast<int>(image->sizeInBytes())));
}

bool qt6cr_qimage_has_alpha_channel(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image != nullptr && image->hasAlphaChannel();
}

bool qt6cr_qimage_all_gray(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image != nullptr && image->allGray();
}

bool qt6cr_qimage_is_grayscale(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image != nullptr && image->isGrayscale();
}

qt6cr_handle_t qt6cr_qimage_copy(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image == nullptr ? new QImage() : new QImage(image->copy());
}

qt6cr_handle_t qt6cr_qimage_copy_rect(qt6cr_handle_t handle, int x, int y, int width, int height) {
  auto *image = as_qimage(handle);
  return image == nullptr ? new QImage() : new QImage(image->copy(x, y, width, height));
}

qt6cr_handle_t qt6cr_qimage_convert_to_format(qt6cr_handle_t handle, int format) {
  auto *image = as_qimage(handle);
  return image == nullptr ? new QImage() : new QImage(image->convertToFormat(image_format_from_int(format)));
}

qt6cr_handle_t qt6cr_qimage_scaled(qt6cr_handle_t handle, int width, int height, int aspect_ratio_mode, int transformation_mode) {
  auto *image = as_qimage(handle);
  return image == nullptr ? new QImage() : new QImage(image->scaled(width, height, static_cast<Qt::AspectRatioMode>(aspect_ratio_mode), static_cast<Qt::TransformationMode>(transformation_mode)));
}

qt6cr_handle_t qt6cr_qimage_scaled_to_width(qt6cr_handle_t handle, int width, int transformation_mode) {
  auto *image = as_qimage(handle);
  return image == nullptr ? new QImage() : new QImage(image->scaledToWidth(width, static_cast<Qt::TransformationMode>(transformation_mode)));
}

qt6cr_handle_t qt6cr_qimage_scaled_to_height(qt6cr_handle_t handle, int height, int transformation_mode) {
  auto *image = as_qimage(handle);
  return image == nullptr ? new QImage() : new QImage(image->scaledToHeight(height, static_cast<Qt::TransformationMode>(transformation_mode)));
}

qt6cr_handle_t qt6cr_qimage_mirrored(qt6cr_handle_t handle, bool horizontal, bool vertical) {
  auto *image = as_qimage(handle);

  if (image == nullptr) {
    return new QImage();
  }

#if QT_VERSION >= QT_VERSION_CHECK(6, 9, 0)
  Qt::Orientations orientations;
  if (horizontal) {
    orientations |= Qt::Horizontal;
  }
  if (vertical) {
    orientations |= Qt::Vertical;
  }
  return new QImage(image->flipped(orientations));
#else
  return new QImage(image->mirrored(horizontal, vertical));
#endif
}

qt6cr_handle_t qt6cr_qimage_rgb_swapped(qt6cr_handle_t handle) {
  auto *image = as_qimage(handle);
  return image == nullptr ? new QImage() : new QImage(image->rgbSwapped());
}

qt6cr_handle_t qt6cr_qimage_transformed(qt6cr_handle_t handle, qt6cr_handle_t transform, int transformation_mode) {
  auto *image = as_qimage(handle);
  auto *matrix = as_qtransform(transform);

  if (image == nullptr || matrix == nullptr) {
    return new QImage();
  }

  return new QImage(image->transformed(*matrix, static_cast<Qt::TransformationMode>(transformation_mode)));
}

void qt6cr_qimage_invert_pixels(qt6cr_handle_t handle, int mode) {
  auto *image = as_qimage(handle);

  if (image != nullptr) {
    image->invertPixels(static_cast<QImage::InvertMode>(mode));
  }
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

bool qt6cr_qimage_load_from_data(qt6cr_handle_t handle, const unsigned char *data, int size, const char *format) {
  auto *image = as_qimage(handle);
  return image != nullptr && image->loadFromData(data, size, format == nullptr ? nullptr : format);
}

bool qt6cr_qimage_load_from_device(qt6cr_handle_t handle, qt6cr_handle_t device, const char *format) {
  auto *image = as_qimage(handle);
  auto *source = as_qio_device(device);
  return image != nullptr && source != nullptr && image->load(source, format == nullptr ? nullptr : format);
}

bool qt6cr_qimage_save(qt6cr_handle_t handle, const char *path) {
  auto *image = as_qimage(handle);
  return image != nullptr && image->save(QString::fromUtf8(path == nullptr ? "" : path));
}

qt6cr_byte_array_t qt6cr_qimage_save_to_data(qt6cr_handle_t handle, const char *format) {
  auto *image = as_qimage(handle);
  if (image == nullptr) {
    return qt6cr_byte_array_t{nullptr, 0};
  }

  QByteArray output;
  QBuffer buffer(&output);
  if (!buffer.open(QIODevice::WriteOnly) || !image->save(&buffer, format == nullptr ? nullptr : format)) {
    return qt6cr_byte_array_t{nullptr, 0};
  }

  return to_byte_array_value(output);
}

bool qt6cr_qimage_save_to_device(qt6cr_handle_t handle, qt6cr_handle_t buffer, const char *format) {
  auto *image = as_qimage(handle);
  auto *target = as_qio_device(buffer);
  return image != nullptr && target != nullptr && image->save(target, format == nullptr ? nullptr : format);
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

qt6cr_handle_t qt6cr_qimage_reader_create(const char *file_name, const char *format) {
  return new QImageReader(
      QString::fromUtf8(file_name == nullptr ? "" : file_name),
      QByteArray(format == nullptr ? "" : format));
}

qt6cr_handle_t qt6cr_qimage_reader_create_from_device(qt6cr_handle_t device, const char *format) {
  auto *source = as_qio_device(device);
  return source == nullptr ? static_cast<qt6cr_handle_t>(new QImageReader()) : static_cast<qt6cr_handle_t>(new QImageReader(source, QByteArray(format == nullptr ? "" : format)));
}

void qt6cr_qimage_reader_destroy(qt6cr_handle_t handle) {
  delete as_qimage_reader(handle);
}

char *qt6cr_qimage_reader_file_name(qt6cr_handle_t handle) {
  auto *reader = as_qimage_reader(handle);
  return reader == nullptr ? duplicate_string("") : duplicate_string(reader->fileName());
}

void qt6cr_qimage_reader_set_file_name(qt6cr_handle_t handle, const char *file_name) {
  auto *reader = as_qimage_reader(handle);

  if (reader != nullptr) {
    reader->setFileName(QString::fromUtf8(file_name == nullptr ? "" : file_name));
  }
}

char *qt6cr_qimage_reader_format(qt6cr_handle_t handle) {
  auto *reader = as_qimage_reader(handle);
  return reader == nullptr ? duplicate_string("") : duplicate_string(QString::fromLatin1(reader->format()));
}

void qt6cr_qimage_reader_set_format(qt6cr_handle_t handle, const char *format) {
  auto *reader = as_qimage_reader(handle);

  if (reader != nullptr) {
    reader->setFormat(QByteArray(format == nullptr ? "" : format));
  }
}

qt6cr_size_t qt6cr_qimage_reader_size(qt6cr_handle_t handle) {
  auto *reader = as_qimage_reader(handle);
  return reader == nullptr ? qt6cr_size_t{0, 0} : to_size(reader->size());
}

bool qt6cr_qimage_reader_can_read(qt6cr_handle_t handle) {
  auto *reader = as_qimage_reader(handle);
  return reader != nullptr && reader->canRead();
}

bool qt6cr_qimage_reader_auto_transform(qt6cr_handle_t handle) {
  auto *reader = as_qimage_reader(handle);
  return reader != nullptr && reader->autoTransform();
}

void qt6cr_qimage_reader_set_auto_transform(qt6cr_handle_t handle, bool value) {
  auto *reader = as_qimage_reader(handle);

  if (reader != nullptr) {
    reader->setAutoTransform(value);
  }
}

char *qt6cr_qimage_reader_error_string(qt6cr_handle_t handle) {
  auto *reader = as_qimage_reader(handle);
  return reader == nullptr ? duplicate_string("") : duplicate_string(reader->errorString());
}

qt6cr_handle_t qt6cr_qimage_reader_read(qt6cr_handle_t handle) {
  auto *reader = as_qimage_reader(handle);
  return reader == nullptr ? new QImage() : new QImage(reader->read());
}

bool qt6cr_qimage_reader_read_into(qt6cr_handle_t handle, qt6cr_handle_t image) {
  auto *reader = as_qimage_reader(handle);
  auto *target = as_qimage(image);
  return reader != nullptr && target != nullptr && reader->read(target);
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

qt6cr_handle_t qt6cr_qpixmap_scaled(qt6cr_handle_t handle, int width, int height, bool keep_aspect_ratio, bool smooth) {
  auto *pixmap = as_qpixmap(handle);
  if (pixmap == nullptr) {
    return nullptr;
  }

  auto aspect_mode = keep_aspect_ratio ? Qt::KeepAspectRatio : Qt::IgnoreAspectRatio;
  auto transform_mode = smooth ? Qt::SmoothTransformation : Qt::FastTransformation;
  return new QPixmap(pixmap->scaled(width, height, aspect_mode, transform_mode));
}

int qt6cr_qpixmap_width(qt6cr_handle_t handle) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr ? 0 : pixmap->width();
}

int qt6cr_qpixmap_height(qt6cr_handle_t handle) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr ? 0 : pixmap->height();
}

int qt6cr_qpixmap_depth(qt6cr_handle_t handle) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr ? 0 : pixmap->depth();
}

bool qt6cr_qpixmap_is_null(qt6cr_handle_t handle) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr || pixmap->isNull();
}

bool qt6cr_qpixmap_has_alpha_channel(qt6cr_handle_t handle) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap != nullptr && pixmap->hasAlphaChannel();
}

qt6cr_handle_t qt6cr_qpixmap_scaled(qt6cr_handle_t handle, int width, int height, int aspect_ratio_mode, int transformation_mode) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr ? new QPixmap() : new QPixmap(pixmap->scaled(width, height, static_cast<Qt::AspectRatioMode>(aspect_ratio_mode), static_cast<Qt::TransformationMode>(transformation_mode)));
}

qt6cr_handle_t qt6cr_qpixmap_scaled_to_width(qt6cr_handle_t handle, int width, int transformation_mode) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr ? new QPixmap() : new QPixmap(pixmap->scaledToWidth(width, static_cast<Qt::TransformationMode>(transformation_mode)));
}

qt6cr_handle_t qt6cr_qpixmap_scaled_to_height(qt6cr_handle_t handle, int height, int transformation_mode) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap == nullptr ? new QPixmap() : new QPixmap(pixmap->scaledToHeight(height, static_cast<Qt::TransformationMode>(transformation_mode)));
}

qt6cr_handle_t qt6cr_qpixmap_transformed(qt6cr_handle_t handle, qt6cr_handle_t transform, int transformation_mode) {
  auto *pixmap = as_qpixmap(handle);
  auto *matrix = as_qtransform(transform);

  if (pixmap == nullptr || matrix == nullptr) {
    return new QPixmap();
  }

  return new QPixmap(pixmap->transformed(*matrix, static_cast<Qt::TransformationMode>(transformation_mode)));
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

bool qt6cr_qpixmap_load_from_data(qt6cr_handle_t handle, const unsigned char *data, int size, const char *format) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap != nullptr && pixmap->loadFromData(data, size, format == nullptr ? nullptr : format);
}

bool qt6cr_qpixmap_save(qt6cr_handle_t handle, const char *path) {
  auto *pixmap = as_qpixmap(handle);
  return pixmap != nullptr && pixmap->save(QString::fromUtf8(path == nullptr ? "" : path));
}

qt6cr_byte_array_t qt6cr_qpixmap_save_to_data(qt6cr_handle_t handle, const char *format) {
  auto *pixmap = as_qpixmap(handle);
  if (pixmap == nullptr) {
    return qt6cr_byte_array_t{nullptr, 0};
  }

  QByteArray output;
  QBuffer buffer(&output);
  if (!buffer.open(QIODevice::WriteOnly) || !pixmap->save(&buffer, format == nullptr ? nullptr : format)) {
    return qt6cr_byte_array_t{nullptr, 0};
  }

  return to_byte_array_value(output);
}

qt6cr_handle_t qt6cr_qicon_create(void) {
  return new QIcon();
}

qt6cr_handle_t qt6cr_qicon_create_from_file(const char *path) {
  return new QIcon(QString::fromUtf8(path == nullptr ? "" : path));
}

qt6cr_handle_t qt6cr_qicon_create_from_theme(const char *name) {
  return new QIcon(QIcon::fromTheme(QString::fromUtf8(name == nullptr ? "" : name)));
}

void qt6cr_qicon_destroy(qt6cr_handle_t handle) {
  delete as_qicon(handle);
}

bool qt6cr_qicon_is_null(qt6cr_handle_t handle) {
  auto *icon = as_qicon(handle);
  return icon == nullptr || icon->isNull();
}

qt6cr_handle_t qt6cr_splash_screen_create(qt6cr_handle_t pixmap) {
  auto *image = as_qpixmap(pixmap);
  return image == nullptr ? new QSplashScreen() : new QSplashScreen(*image);
}

qt6cr_handle_t qt6cr_splash_screen_pixmap(qt6cr_handle_t handle) {
  auto *splash = as_splash_screen(handle);
  return splash == nullptr ? new QPixmap() : new QPixmap(splash->pixmap());
}

void qt6cr_splash_screen_set_pixmap(qt6cr_handle_t handle, qt6cr_handle_t pixmap) {
  auto *splash = as_splash_screen(handle);
  auto *image = as_qpixmap(pixmap);

  if (splash != nullptr && image != nullptr) {
    splash->setPixmap(*image);
  }
}

char *qt6cr_splash_screen_message(qt6cr_handle_t handle) {
  auto *splash = as_splash_screen(handle);
  return splash == nullptr ? duplicate_string("") : duplicate_string(splash->message());
}

void qt6cr_splash_screen_show_message(qt6cr_handle_t handle, const char *message, qt6cr_color_t color) {
  auto *splash = as_splash_screen(handle);

  if (splash != nullptr) {
    splash->showMessage(QString::fromUtf8(message == nullptr ? "" : message), Qt::AlignLeft, from_color(color));
  }
}

void qt6cr_splash_screen_clear_message(qt6cr_handle_t handle) {
  auto *splash = as_splash_screen(handle);

  if (splash != nullptr) {
    splash->clearMessage();
  }
}

void qt6cr_splash_screen_finish(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *splash = as_splash_screen(handle);
  auto *target = as_widget(widget);

  if (splash != nullptr && target != nullptr) {
    splash->finish(target);
  }
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

uint64_t qt6cr_model_index_internal_id(qt6cr_handle_t handle) {
  auto *index = as_model_index(handle);
  return index == nullptr ? 0 : static_cast<uint64_t>(index->internalId());
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

qt6cr_handle_t qt6cr_abstract_item_model_parent(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *model = as_abstract_item_model(handle);
  auto *model_index = as_model_index(index);

  if (model == nullptr || model_index == nullptr) {
    return new QModelIndex();
  }

  return new QModelIndex(model->parent(*model_index));
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

qt6cr_variant_value_t qt6cr_abstract_item_model_header_data(qt6cr_handle_t handle, int section, int orientation, int role) {
  auto *model = as_abstract_item_model(handle);
  return model == nullptr ? to_variant_value(QVariant()) : to_variant_value(model->headerData(section, static_cast<Qt::Orientation>(orientation), role));
}

bool qt6cr_abstract_item_model_set_header_data(qt6cr_handle_t handle, int section, int orientation, qt6cr_variant_value_t value, int role) {
  auto *model = as_abstract_item_model(handle);
  return model != nullptr ? model->setHeaderData(section, static_cast<Qt::Orientation>(orientation), from_variant_value(value), role) : false;
}

int qt6cr_abstract_item_model_flags(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *model = as_abstract_item_model(handle);
  auto *model_index = as_model_index(index);
  return model != nullptr && model_index != nullptr ? static_cast<int>(model->flags(*model_index)) : 0;
}

int qt6cr_abstract_item_model_mime_type_count(qt6cr_handle_t handle) {
  auto *model = as_abstract_item_model(handle);
  return model == nullptr ? 0 : model->mimeTypes().size();
}

char *qt6cr_abstract_item_model_mime_type(qt6cr_handle_t handle, int index) {
  auto *model = as_abstract_item_model(handle);
  return model == nullptr ? duplicate_string("") : duplicate_string(model->mimeTypes().value(index));
}

qt6cr_handle_t qt6cr_abstract_item_model_mime_data_for_indexes(qt6cr_handle_t handle, qt6cr_handle_t *indexes, int count) {
  auto *model = as_abstract_item_model(handle);

  if (model == nullptr) {
    return nullptr;
  }

  QModelIndexList values;
  for (int index = 0; index < count; ++index) {
    auto *model_index = as_model_index(indexes[index]);

    if (model_index != nullptr && model_index->isValid()) {
      values << *model_index;
    }
  }

  return clone_mime_data(model->mimeData(values));
}

bool qt6cr_abstract_item_model_drop_mime_data(qt6cr_handle_t handle, qt6cr_handle_t mime_data, int action, int row, int column, qt6cr_handle_t parent_index) {
  auto *model = as_abstract_item_model(handle);
  auto *payload = as_mime_data(mime_data);
  auto *parent = as_model_index(parent_index);

  return model != nullptr && payload != nullptr
             ? model->dropMimeData(payload, static_cast<Qt::DropAction>(action), row, column, parent == nullptr ? QModelIndex() : *parent)
             : false;
}

int qt6cr_abstract_item_model_supported_drag_actions(qt6cr_handle_t handle) {
  auto *model = as_abstract_item_model(handle);
  return model == nullptr ? 0 : static_cast<int>(model->supportedDragActions());
}

int qt6cr_abstract_item_model_supported_drop_actions(qt6cr_handle_t handle) {
  auto *model = as_abstract_item_model(handle);
  return model == nullptr ? 0 : static_cast<int>(model->supportedDropActions());
}

qt6cr_handle_t qt6cr_abstract_list_model_create(qt6cr_handle_t parent) {
  return new CrystalAbstractListModel(as_object(parent));
}

void qt6cr_abstract_list_model_on_row_count(qt6cr_handle_t handle, qt6cr_model_count_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->row_count_callback = callback;
  model->row_count_userdata = userdata;
}

void qt6cr_abstract_list_model_on_column_count(qt6cr_handle_t handle, qt6cr_model_count_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->column_count_callback = callback;
  model->column_count_userdata = userdata;
}

void qt6cr_abstract_list_model_on_data(qt6cr_handle_t handle, qt6cr_model_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->data_callback = callback;
  model->data_userdata = userdata;
}

void qt6cr_abstract_list_model_on_set_data(qt6cr_handle_t handle, qt6cr_model_set_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->set_data_callback = callback;
  model->set_data_userdata = userdata;
}

void qt6cr_abstract_list_model_on_header_data(qt6cr_handle_t handle, qt6cr_model_header_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->header_data_callback = callback;
  model->header_data_userdata = userdata;
}

void qt6cr_abstract_list_model_on_flags(qt6cr_handle_t handle, qt6cr_model_flags_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->flags_callback = callback;
  model->flags_userdata = userdata;
}

void qt6cr_abstract_list_model_on_mime_type_count(qt6cr_handle_t handle, qt6cr_model_mime_type_count_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->mime_type_count_callback = callback;
  model->mime_type_count_userdata = userdata;
}

void qt6cr_abstract_list_model_on_mime_type(qt6cr_handle_t handle, qt6cr_indexed_string_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->mime_type_callback = callback;
  model->mime_type_userdata = userdata;
}

void qt6cr_abstract_list_model_on_mime_data(qt6cr_handle_t handle, qt6cr_model_mime_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->mime_data_callback = callback;
  model->mime_data_userdata = userdata;
}

void qt6cr_abstract_list_model_on_drop_mime_data(qt6cr_handle_t handle, qt6cr_model_drop_mime_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->drop_mime_data_callback = callback;
  model->drop_mime_data_userdata = userdata;
}

void qt6cr_abstract_list_model_on_supported_drag_actions(qt6cr_handle_t handle, qt6cr_model_actions_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->supported_drag_actions_callback = callback;
  model->supported_drag_actions_userdata = userdata;
}

void qt6cr_abstract_list_model_on_supported_drop_actions(qt6cr_handle_t handle, qt6cr_model_actions_callback_t callback, void *userdata) {
  auto *model = as_abstract_list_model(handle);

  if (model == nullptr) {
    return;
  }

  model->supported_drop_actions_callback = callback;
  model->supported_drop_actions_userdata = userdata;
}

void qt6cr_abstract_list_model_begin_reset_model(qt6cr_handle_t handle) {
  auto *model = as_abstract_list_model(handle);

  if (model != nullptr) {
    model->beginResetModelBridge();
  }
}

void qt6cr_abstract_list_model_end_reset_model(qt6cr_handle_t handle) {
  auto *model = as_abstract_list_model(handle);

  if (model != nullptr) {
    model->endResetModelBridge();
  }
}

void qt6cr_abstract_list_model_begin_insert_rows(qt6cr_handle_t handle, int first, int last, qt6cr_handle_t parent_index) {
  auto *model = as_abstract_list_model(handle);
  auto *parent = as_model_index(parent_index);

  if (model != nullptr) {
    model->beginInsertRowsBridge(first, last, parent == nullptr ? QModelIndex() : *parent);
  }
}

void qt6cr_abstract_list_model_end_insert_rows(qt6cr_handle_t handle) {
  auto *model = as_abstract_list_model(handle);

  if (model != nullptr) {
    model->endInsertRowsBridge();
  }
}

void qt6cr_abstract_list_model_begin_remove_rows(qt6cr_handle_t handle, int first, int last, qt6cr_handle_t parent_index) {
  auto *model = as_abstract_list_model(handle);
  auto *parent = as_model_index(parent_index);

  if (model != nullptr) {
    model->beginRemoveRowsBridge(first, last, parent == nullptr ? QModelIndex() : *parent);
  }
}

void qt6cr_abstract_list_model_end_remove_rows(qt6cr_handle_t handle) {
  auto *model = as_abstract_list_model(handle);

  if (model != nullptr) {
    model->endRemoveRowsBridge();
  }
}

bool qt6cr_abstract_list_model_begin_move_rows(qt6cr_handle_t handle, int source_first, int source_last, qt6cr_handle_t source_parent_index, int destination_child, qt6cr_handle_t destination_parent_index) {
  auto *model = as_abstract_list_model(handle);
  auto *source_parent = as_model_index(source_parent_index);
  auto *destination_parent = as_model_index(destination_parent_index);

  if (model == nullptr) {
    return false;
  }

  return model->beginMoveRowsBridge(
      source_first,
      source_last,
      source_parent == nullptr ? QModelIndex() : *source_parent,
      destination_child,
      destination_parent == nullptr ? QModelIndex() : *destination_parent);
}

void qt6cr_abstract_list_model_end_move_rows(qt6cr_handle_t handle) {
  auto *model = as_abstract_list_model(handle);

  if (model != nullptr) {
    model->endMoveRowsBridge();
  }
}

void qt6cr_abstract_list_model_data_changed(qt6cr_handle_t handle, qt6cr_handle_t top_left, qt6cr_handle_t bottom_right) {
  auto *model = as_abstract_list_model(handle);
  auto *top_left_index = as_model_index(top_left);
  auto *bottom_right_index = as_model_index(bottom_right);

  if (model == nullptr || top_left_index == nullptr || bottom_right_index == nullptr) {
    return;
  }

  model->emitDataChangedBridge(*top_left_index, *bottom_right_index);
}

qt6cr_handle_t qt6cr_abstract_tree_model_create(qt6cr_handle_t parent) {
  return new CrystalAbstractTreeModel(as_object(parent));
}

void qt6cr_abstract_tree_model_on_row_count(qt6cr_handle_t handle, qt6cr_model_count_with_parent_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->row_count_callback = callback;
  model->row_count_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_column_count(qt6cr_handle_t handle, qt6cr_model_count_with_parent_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->column_count_callback = callback;
  model->column_count_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_index_id(qt6cr_handle_t handle, qt6cr_model_index_id_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->index_id_callback = callback;
  model->index_id_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_parent(qt6cr_handle_t handle, qt6cr_model_parent_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->parent_callback = callback;
  model->parent_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_data(qt6cr_handle_t handle, qt6cr_model_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->data_callback = callback;
  model->data_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_set_data(qt6cr_handle_t handle, qt6cr_model_set_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->set_data_callback = callback;
  model->set_data_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_header_data(qt6cr_handle_t handle, qt6cr_model_header_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->header_data_callback = callback;
  model->header_data_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_flags(qt6cr_handle_t handle, qt6cr_model_flags_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->flags_callback = callback;
  model->flags_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_mime_type_count(qt6cr_handle_t handle, qt6cr_model_mime_type_count_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->mime_type_count_callback = callback;
  model->mime_type_count_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_mime_type(qt6cr_handle_t handle, qt6cr_indexed_string_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->mime_type_callback = callback;
  model->mime_type_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_mime_data(qt6cr_handle_t handle, qt6cr_model_mime_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->mime_data_callback = callback;
  model->mime_data_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_drop_mime_data(qt6cr_handle_t handle, qt6cr_model_drop_mime_data_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->drop_mime_data_callback = callback;
  model->drop_mime_data_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_supported_drag_actions(qt6cr_handle_t handle, qt6cr_model_actions_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->supported_drag_actions_callback = callback;
  model->supported_drag_actions_userdata = userdata;
}

void qt6cr_abstract_tree_model_on_supported_drop_actions(qt6cr_handle_t handle, qt6cr_model_actions_callback_t callback, void *userdata) {
  auto *model = as_abstract_tree_model(handle);

  if (model == nullptr) {
    return;
  }

  model->supported_drop_actions_callback = callback;
  model->supported_drop_actions_userdata = userdata;
}

void qt6cr_abstract_tree_model_begin_reset_model(qt6cr_handle_t handle) {
  auto *model = as_abstract_tree_model(handle);

  if (model != nullptr) {
    model->beginResetModelBridge();
  }
}

void qt6cr_abstract_tree_model_end_reset_model(qt6cr_handle_t handle) {
  auto *model = as_abstract_tree_model(handle);

  if (model != nullptr) {
    model->endResetModelBridge();
  }
}

void qt6cr_abstract_tree_model_begin_insert_rows(qt6cr_handle_t handle, int first, int last, qt6cr_handle_t parent_index) {
  auto *model = as_abstract_tree_model(handle);
  auto *parent = as_model_index(parent_index);

  if (model != nullptr) {
    model->beginInsertRowsBridge(first, last, parent == nullptr ? QModelIndex() : *parent);
  }
}

void qt6cr_abstract_tree_model_end_insert_rows(qt6cr_handle_t handle) {
  auto *model = as_abstract_tree_model(handle);

  if (model != nullptr) {
    model->endInsertRowsBridge();
  }
}

void qt6cr_abstract_tree_model_begin_remove_rows(qt6cr_handle_t handle, int first, int last, qt6cr_handle_t parent_index) {
  auto *model = as_abstract_tree_model(handle);
  auto *parent = as_model_index(parent_index);

  if (model != nullptr) {
    model->beginRemoveRowsBridge(first, last, parent == nullptr ? QModelIndex() : *parent);
  }
}

void qt6cr_abstract_tree_model_end_remove_rows(qt6cr_handle_t handle) {
  auto *model = as_abstract_tree_model(handle);

  if (model != nullptr) {
    model->endRemoveRowsBridge();
  }
}

bool qt6cr_abstract_tree_model_begin_move_rows(qt6cr_handle_t handle, int source_first, int source_last, qt6cr_handle_t source_parent_index, int destination_child, qt6cr_handle_t destination_parent_index) {
  auto *model = as_abstract_tree_model(handle);
  auto *source_parent = as_model_index(source_parent_index);
  auto *destination_parent = as_model_index(destination_parent_index);

  if (model == nullptr) {
    return false;
  }

  return model->beginMoveRowsBridge(
      source_first,
      source_last,
      source_parent == nullptr ? QModelIndex() : *source_parent,
      destination_child,
      destination_parent == nullptr ? QModelIndex() : *destination_parent);
}

void qt6cr_abstract_tree_model_end_move_rows(qt6cr_handle_t handle) {
  auto *model = as_abstract_tree_model(handle);

  if (model != nullptr) {
    model->endMoveRowsBridge();
  }
}

void qt6cr_abstract_tree_model_data_changed(qt6cr_handle_t handle, qt6cr_handle_t top_left, qt6cr_handle_t bottom_right) {
  auto *model = as_abstract_tree_model(handle);
  auto *top_left_index = as_model_index(top_left);
  auto *bottom_right_index = as_model_index(bottom_right);

  if (model == nullptr || top_left_index == nullptr || bottom_right_index == nullptr) {
    return;
  }

  model->emitDataChangedBridge(*top_left_index, *bottom_right_index);
}

qt6cr_handle_t qt6cr_item_selection_model_create(qt6cr_handle_t model, qt6cr_handle_t parent) {
  return new QItemSelectionModel(as_abstract_item_model(model), as_object(parent));
}

qt6cr_handle_t qt6cr_item_selection_model_model(qt6cr_handle_t handle) {
  auto *selection_model = as_item_selection_model(handle);
  return selection_model == nullptr ? nullptr : selection_model->model();
}

qt6cr_handle_t qt6cr_item_selection_model_current_index(qt6cr_handle_t handle) {
  auto *selection_model = as_item_selection_model(handle);
  return selection_model == nullptr ? new QModelIndex() : new QModelIndex(selection_model->currentIndex());
}

void qt6cr_item_selection_model_set_current_index(qt6cr_handle_t handle, qt6cr_handle_t index, int command) {
  auto *selection_model = as_item_selection_model(handle);
  auto *model_index = as_model_index(index);

  if (selection_model == nullptr || model_index == nullptr) {
    return;
  }

  selection_model->setCurrentIndex(*model_index, static_cast<QItemSelectionModel::SelectionFlags>(command));
}

void qt6cr_item_selection_model_select_index(qt6cr_handle_t handle, qt6cr_handle_t index, int command) {
  auto *selection_model = as_item_selection_model(handle);
  auto *model_index = as_model_index(index);

  if (selection_model == nullptr || model_index == nullptr) {
    return;
  }

  selection_model->select(*model_index, static_cast<QItemSelectionModel::SelectionFlags>(command));
}

void qt6cr_item_selection_model_clear(qt6cr_handle_t handle) {
  auto *selection_model = as_item_selection_model(handle);

  if (selection_model != nullptr) {
    selection_model->clear();
  }
}

void qt6cr_item_selection_model_clear_selection(qt6cr_handle_t handle) {
  auto *selection_model = as_item_selection_model(handle);

  if (selection_model != nullptr) {
    selection_model->clearSelection();
  }
}

bool qt6cr_item_selection_model_has_selection(qt6cr_handle_t handle) {
  auto *selection_model = as_item_selection_model(handle);
  return selection_model == nullptr ? false : selection_model->hasSelection();
}

bool qt6cr_item_selection_model_is_selected(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *selection_model = as_item_selection_model(handle);
  auto *model_index = as_model_index(index);

  if (selection_model == nullptr || model_index == nullptr) {
    return false;
  }

  return selection_model->isSelected(*model_index);
}

void qt6cr_item_selection_model_on_current_index_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *selection_model = as_item_selection_model(handle);

  if (selection_model == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(selection_model, &QItemSelectionModel::currentChanged, selection_model, [callback, userdata](const QModelIndex &, const QModelIndex &) {
    callback(userdata);
  });
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

int qt6cr_sort_filter_proxy_model_sort_column(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? 0 : proxy->sortColumn();
}

int qt6cr_sort_filter_proxy_model_sort_order(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? static_cast<int>(Qt::AscendingOrder) : static_cast<int>(proxy->sortOrder());
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

void qt6cr_sort_filter_proxy_model_set_filter_regular_expression(qt6cr_handle_t handle, const char *value) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setFilterRegularExpression(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

char *qt6cr_sort_filter_proxy_model_filter_pattern(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);
  return proxy == nullptr ? duplicate_string("") : duplicate_string(proxy->filterRegularExpression().pattern());
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

void qt6cr_sort_filter_proxy_model_clear_filter(qt6cr_handle_t handle) {
  auto *proxy = as_sort_filter_proxy_model(handle);

  if (proxy != nullptr) {
    proxy->setFilterRegularExpression(QRegularExpression());
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

void qt6cr_styled_item_delegate_on_create_editor(qt6cr_handle_t handle, qt6cr_delegate_create_editor_callback_t callback, void *userdata) {
  auto *delegate = as_styled_item_delegate(handle);

  if (delegate == nullptr) {
    return;
  }

  delegate->create_editor_callback = callback;
  delegate->create_editor_userdata = userdata;
}

void qt6cr_styled_item_delegate_on_set_editor_data(qt6cr_handle_t handle, qt6cr_delegate_set_editor_data_callback_t callback, void *userdata) {
  auto *delegate = as_styled_item_delegate(handle);

  if (delegate == nullptr) {
    return;
  }

  delegate->set_editor_data_callback = callback;
  delegate->set_editor_data_userdata = userdata;
}

void qt6cr_styled_item_delegate_on_set_model_data(qt6cr_handle_t handle, qt6cr_delegate_set_model_data_callback_t callback, void *userdata) {
  auto *delegate = as_styled_item_delegate(handle);

  if (delegate == nullptr) {
    return;
  }

  delegate->set_model_data_callback = callback;
  delegate->set_model_data_userdata = userdata;
}

char *qt6cr_styled_item_delegate_display_text(qt6cr_handle_t handle, qt6cr_variant_value_t value) {
  auto *delegate = as_styled_item_delegate(handle);
  return delegate == nullptr ? duplicate_string("") : duplicate_string(delegate->displayText(from_variant_value(value), QLocale()));
}

qt6cr_handle_t qt6cr_styled_item_delegate_create_editor(qt6cr_handle_t handle, qt6cr_handle_t parent, qt6cr_handle_t index) {
  auto *delegate = as_styled_item_delegate(handle);
  auto *editor_parent = as_widget(parent);
  auto *model_index = as_model_index(index);

  if (delegate == nullptr || editor_parent == nullptr || model_index == nullptr) {
    return nullptr;
  }

  QStyleOptionViewItem option;
  return delegate->createEditor(editor_parent, option, *model_index);
}

void qt6cr_styled_item_delegate_set_editor_data(qt6cr_handle_t handle, qt6cr_handle_t editor, qt6cr_handle_t index) {
  auto *delegate = as_styled_item_delegate(handle);
  auto *editor_widget = as_widget(editor);
  auto *model_index = as_model_index(index);

  if (delegate == nullptr || editor_widget == nullptr || model_index == nullptr) {
    return;
  }

  delegate->setEditorData(editor_widget, *model_index);
}

void qt6cr_styled_item_delegate_set_model_data(qt6cr_handle_t handle, qt6cr_handle_t editor, qt6cr_handle_t model, qt6cr_handle_t index) {
  auto *delegate = as_styled_item_delegate(handle);
  auto *editor_widget = as_widget(editor);
  auto *abstract_item_model = as_abstract_item_model(model);
  auto *model_index = as_model_index(index);

  if (delegate == nullptr || editor_widget == nullptr || abstract_item_model == nullptr || model_index == nullptr) {
    return;
  }

  delegate->setModelData(editor_widget, abstract_item_model, *model_index);
}

qt6cr_handle_t qt6cr_abstract_item_view_model(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view == nullptr ? nullptr : view->model();
}

void qt6cr_abstract_item_view_set_item_delegate(qt6cr_handle_t handle, qt6cr_handle_t delegate) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setItemDelegate(as_styled_item_delegate(delegate));
  }
}

qt6cr_handle_t qt6cr_abstract_item_view_selection_model(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view == nullptr ? nullptr : view->selectionModel();
}

void qt6cr_abstract_item_view_set_selection_model(qt6cr_handle_t handle, qt6cr_handle_t selection_model) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setSelectionModel(as_item_selection_model(selection_model));
  }
}

qt6cr_handle_t qt6cr_abstract_item_view_current_index(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view == nullptr ? new QModelIndex() : new QModelIndex(view->currentIndex());
}

void qt6cr_abstract_item_view_set_current_index(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_abstract_item_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr) {
    view->setCurrentIndex(model_index == nullptr ? QModelIndex() : *model_index);
  }
}

int qt6cr_abstract_item_view_selection_mode(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->selectionMode());
}

void qt6cr_abstract_item_view_set_selection_mode(qt6cr_handle_t handle, int mode) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setSelectionMode(static_cast<QAbstractItemView::SelectionMode>(mode));
  }
}

int qt6cr_abstract_item_view_edit_triggers(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view == nullptr ? static_cast<int>(QAbstractItemView::DoubleClicked | QAbstractItemView::EditKeyPressed) : static_cast<int>(view->editTriggers());
}

void qt6cr_abstract_item_view_set_edit_triggers(qt6cr_handle_t handle, int triggers) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setEditTriggers(static_cast<QAbstractItemView::EditTriggers>(triggers));
  }
}

int qt6cr_abstract_item_view_selection_behavior(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view == nullptr ? static_cast<int>(QAbstractItemView::SelectItems) : static_cast<int>(view->selectionBehavior());
}

void qt6cr_abstract_item_view_set_selection_behavior(qt6cr_handle_t handle, int behavior) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setSelectionBehavior(static_cast<QAbstractItemView::SelectionBehavior>(behavior));
  }
}

bool qt6cr_abstract_item_view_alternating_row_colors(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view != nullptr && view->alternatingRowColors();
}

void qt6cr_abstract_item_view_set_alternating_row_colors(qt6cr_handle_t handle, bool value) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setAlternatingRowColors(value);
  }
}

bool qt6cr_abstract_item_view_drag_enabled(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view != nullptr && view->dragEnabled();
}

void qt6cr_abstract_item_view_set_drag_enabled(qt6cr_handle_t handle, bool value) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setDragEnabled(value);
  }
}

int qt6cr_abstract_item_view_drag_drop_mode(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->dragDropMode());
}

void qt6cr_abstract_item_view_set_drag_drop_mode(qt6cr_handle_t handle, int mode) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setDragDropMode(static_cast<QAbstractItemView::DragDropMode>(mode));
  }
}

bool qt6cr_abstract_item_view_drag_drop_overwrite_mode(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view != nullptr && view->dragDropOverwriteMode();
}

void qt6cr_abstract_item_view_set_drag_drop_overwrite_mode(qt6cr_handle_t handle, bool value) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setDragDropOverwriteMode(value);
  }
}

int qt6cr_abstract_item_view_default_drop_action(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->defaultDropAction());
}

void qt6cr_abstract_item_view_set_default_drop_action(qt6cr_handle_t handle, int action) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setDefaultDropAction(static_cast<Qt::DropAction>(action));
  }
}

bool qt6cr_abstract_item_view_drop_indicator_shown(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view != nullptr && view->showDropIndicator();
}

void qt6cr_abstract_item_view_set_drop_indicator_shown(qt6cr_handle_t handle, bool value) {
  auto *view = as_abstract_item_view(handle);

  if (view != nullptr) {
    view->setDropIndicatorShown(value);
  }
}

qt6cr_handle_t qt6cr_abstract_item_view_viewport(qt6cr_handle_t handle) {
  auto *view = as_abstract_item_view(handle);
  return view == nullptr ? nullptr : view->viewport();
}

qt6cr_handle_t qt6cr_abstract_item_view_index_at(qt6cr_handle_t handle, qt6cr_pointf_t point) {
  auto *view = as_abstract_item_view(handle);
  if (view == nullptr) {
    return new QModelIndex();
  }

  const QPoint qpoint{static_cast<int>(point.x), static_cast<int>(point.y)};
  return new QModelIndex(view->indexAt(qpoint));
}

qt6cr_rectf_t qt6cr_abstract_item_view_visual_rect(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_abstract_item_view(handle);
  auto *model_index = as_model_index(index);

  if (view == nullptr || model_index == nullptr) {
    return qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0};
  }

  return to_rectf(view->visualRect(*model_index));
}

void qt6cr_abstract_item_view_open_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_abstract_item_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr && model_index != nullptr) {
    view->openPersistentEditor(*model_index);
  }
}

void qt6cr_abstract_item_view_close_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_abstract_item_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr && model_index != nullptr) {
    view->closePersistentEditor(*model_index);
  }
}

bool qt6cr_abstract_item_view_is_persistent_editor_open(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_abstract_item_view(handle);
  auto *model_index = as_model_index(index);
  return view != nullptr && model_index != nullptr && view->isPersistentEditorOpen(*model_index);
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

qt6cr_handle_t qt6cr_list_view_selection_model(qt6cr_handle_t handle) {
  auto *view = as_list_view(handle);
  return view == nullptr ? nullptr : view->selectionModel();
}

void qt6cr_list_view_set_selection_model(qt6cr_handle_t handle, qt6cr_handle_t selection_model) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setSelectionModel(as_item_selection_model(selection_model));
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

int qt6cr_list_view_selection_mode(qt6cr_handle_t handle) {
  auto *view = as_list_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->selectionMode());
}

void qt6cr_list_view_set_selection_mode(qt6cr_handle_t handle, int mode) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setSelectionMode(static_cast<QAbstractItemView::SelectionMode>(mode));
  }
}

int qt6cr_list_view_edit_triggers(qt6cr_handle_t handle) {
  auto *view = as_list_view(handle);
  return view == nullptr ? static_cast<int>(QAbstractItemView::DoubleClicked | QAbstractItemView::EditKeyPressed) : static_cast<int>(view->editTriggers());
}

void qt6cr_list_view_set_edit_triggers(qt6cr_handle_t handle, int triggers) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setEditTriggers(static_cast<QAbstractItemView::EditTriggers>(triggers));
  }
}

bool qt6cr_list_view_alternating_row_colors(qt6cr_handle_t handle) {
  auto *view = as_list_view(handle);
  return view != nullptr && view->alternatingRowColors();
}

void qt6cr_list_view_set_alternating_row_colors(qt6cr_handle_t handle, bool value) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setAlternatingRowColors(value);
  }
}

bool qt6cr_list_view_drag_enabled(qt6cr_handle_t handle) {
  auto *view = as_list_view(handle);
  return view != nullptr && view->dragEnabled();
}

void qt6cr_list_view_set_drag_enabled(qt6cr_handle_t handle, bool value) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setDragEnabled(value);
  }
}

int qt6cr_list_view_drag_drop_mode(qt6cr_handle_t handle) {
  auto *view = as_list_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->dragDropMode());
}

void qt6cr_list_view_set_drag_drop_mode(qt6cr_handle_t handle, int mode) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setDragDropMode(static_cast<QAbstractItemView::DragDropMode>(mode));
  }
}

int qt6cr_list_view_default_drop_action(qt6cr_handle_t handle) {
  auto *view = as_list_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->defaultDropAction());
}

void qt6cr_list_view_set_default_drop_action(qt6cr_handle_t handle, int action) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setDefaultDropAction(static_cast<Qt::DropAction>(action));
  }
}

bool qt6cr_list_view_drop_indicator_shown(qt6cr_handle_t handle) {
  auto *view = as_list_view(handle);
  return view != nullptr && view->showDropIndicator();
}

void qt6cr_list_view_set_drop_indicator_shown(qt6cr_handle_t handle, bool value) {
  auto *view = as_list_view(handle);

  if (view != nullptr) {
    view->setDropIndicatorShown(value);
  }
}

void qt6cr_list_view_open_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_list_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr && model_index != nullptr) {
    view->openPersistentEditor(*model_index);
  }
}

void qt6cr_list_view_close_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_list_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr && model_index != nullptr) {
    view->closePersistentEditor(*model_index);
  }
}

bool qt6cr_list_view_is_persistent_editor_open(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_list_view(handle);
  auto *model_index = as_model_index(index);
  return view != nullptr && model_index != nullptr && view->isPersistentEditorOpen(*model_index);
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

qt6cr_handle_t qt6cr_tree_view_selection_model(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view == nullptr ? nullptr : view->selectionModel();
}

void qt6cr_tree_view_set_selection_model(qt6cr_handle_t handle, qt6cr_handle_t selection_model) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setSelectionModel(as_item_selection_model(selection_model));
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

int qt6cr_tree_view_selection_mode(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->selectionMode());
}

void qt6cr_tree_view_set_selection_mode(qt6cr_handle_t handle, int mode) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setSelectionMode(static_cast<QAbstractItemView::SelectionMode>(mode));
  }
}

int qt6cr_tree_view_edit_triggers(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view == nullptr ? static_cast<int>(QAbstractItemView::DoubleClicked | QAbstractItemView::EditKeyPressed) : static_cast<int>(view->editTriggers());
}

void qt6cr_tree_view_set_edit_triggers(qt6cr_handle_t handle, int triggers) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setEditTriggers(static_cast<QAbstractItemView::EditTriggers>(triggers));
  }
}

bool qt6cr_tree_view_alternating_row_colors(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view != nullptr && view->alternatingRowColors();
}

void qt6cr_tree_view_set_alternating_row_colors(qt6cr_handle_t handle, bool value) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setAlternatingRowColors(value);
  }
}

bool qt6cr_tree_view_header_hidden(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view != nullptr && view->isHeaderHidden();
}

void qt6cr_tree_view_set_header_hidden(qt6cr_handle_t handle, bool value) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setHeaderHidden(value);
  }
}

bool qt6cr_tree_view_root_is_decorated(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view != nullptr && view->rootIsDecorated();
}

void qt6cr_tree_view_set_root_is_decorated(qt6cr_handle_t handle, bool value) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setRootIsDecorated(value);
  }
}

bool qt6cr_tree_view_uniform_row_heights(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view != nullptr && view->uniformRowHeights();
}

void qt6cr_tree_view_set_uniform_row_heights(qt6cr_handle_t handle, bool value) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setUniformRowHeights(value);
  }
}

int qt6cr_tree_view_indentation(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view == nullptr ? 0 : view->indentation();
}

void qt6cr_tree_view_set_indentation(qt6cr_handle_t handle, int value) {
  auto *view = as_tree_view(handle);

  if (view != nullptr && value >= 0) {
    view->setIndentation(value);
  }
}

bool qt6cr_tree_view_drag_enabled(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view != nullptr && view->dragEnabled();
}

void qt6cr_tree_view_set_drag_enabled(qt6cr_handle_t handle, bool value) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setDragEnabled(value);
  }
}

int qt6cr_tree_view_drag_drop_mode(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->dragDropMode());
}

void qt6cr_tree_view_set_drag_drop_mode(qt6cr_handle_t handle, int mode) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setDragDropMode(static_cast<QAbstractItemView::DragDropMode>(mode));
  }
}

int qt6cr_tree_view_default_drop_action(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->defaultDropAction());
}

void qt6cr_tree_view_set_default_drop_action(qt6cr_handle_t handle, int action) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setDefaultDropAction(static_cast<Qt::DropAction>(action));
  }
}

bool qt6cr_tree_view_drop_indicator_shown(qt6cr_handle_t handle) {
  auto *view = as_tree_view(handle);
  return view != nullptr && view->showDropIndicator();
}

void qt6cr_tree_view_set_drop_indicator_shown(qt6cr_handle_t handle, bool value) {
  auto *view = as_tree_view(handle);

  if (view != nullptr) {
    view->setDropIndicatorShown(value);
  }
}

void qt6cr_tree_view_open_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_tree_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr && model_index != nullptr) {
    view->openPersistentEditor(*model_index);
  }
}

void qt6cr_tree_view_close_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_tree_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr && model_index != nullptr) {
    view->closePersistentEditor(*model_index);
  }
}

bool qt6cr_tree_view_is_persistent_editor_open(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_tree_view(handle);
  auto *model_index = as_model_index(index);
  return view != nullptr && model_index != nullptr && view->isPersistentEditorOpen(*model_index);
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

int qt6cr_header_view_count(qt6cr_handle_t handle) {
  auto *header = as_header_view(handle);
  return header == nullptr ? 0 : header->count();
}

int qt6cr_header_view_default_section_size(qt6cr_handle_t handle) {
  auto *header = as_header_view(handle);
  return header == nullptr ? 0 : header->defaultSectionSize();
}

void qt6cr_header_view_set_default_section_size(qt6cr_handle_t handle, int value) {
  auto *header = as_header_view(handle);

  if (header != nullptr && value >= 0) {
    header->setDefaultSectionSize(value);
  }
}

bool qt6cr_header_view_stretch_last_section(qt6cr_handle_t handle) {
  auto *header = as_header_view(handle);
  return header != nullptr && header->stretchLastSection();
}

void qt6cr_header_view_set_stretch_last_section(qt6cr_handle_t handle, bool value) {
  auto *header = as_header_view(handle);

  if (header != nullptr) {
    header->setStretchLastSection(value);
  }
}

bool qt6cr_header_view_section_hidden(qt6cr_handle_t handle, int index) {
  auto *header = as_header_view(handle);
  return header != nullptr && index >= 0 && header->isSectionHidden(index);
}

void qt6cr_header_view_set_section_hidden(qt6cr_handle_t handle, int index, bool value) {
  auto *header = as_header_view(handle);

  if (header != nullptr && index >= 0) {
    header->setSectionHidden(index, value);
  }
}

int qt6cr_header_view_section_resize_mode(qt6cr_handle_t handle, int index) {
  auto *header = as_header_view(handle);
  return header == nullptr || index < 0 ? static_cast<int>(QHeaderView::Interactive) : static_cast<int>(header->sectionResizeMode(index));
}

void qt6cr_header_view_set_section_resize_mode(qt6cr_handle_t handle, int index, int value) {
  auto *header = as_header_view(handle);

  if (header != nullptr && index >= 0) {
    header->setSectionResizeMode(index, static_cast<QHeaderView::ResizeMode>(value));
  }
}

void qt6cr_header_view_resize_section(qt6cr_handle_t handle, int index, int size) {
  auto *header = as_header_view(handle);

  if (header != nullptr && index >= 0 && size >= 0) {
    header->resizeSection(index, size);
  }
}

int qt6cr_header_view_section_size(qt6cr_handle_t handle, int index) {
  auto *header = as_header_view(handle);
  return header == nullptr || index < 0 ? 0 : header->sectionSize(index);
}

qt6cr_handle_t qt6cr_table_view_create(qt6cr_handle_t parent) {
  return new ModelTableView(as_widget(parent));
}

void qt6cr_table_view_set_model(qt6cr_handle_t handle, qt6cr_handle_t model) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setModel(as_abstract_item_model(model));
  }
}

void qt6cr_table_view_set_item_delegate(qt6cr_handle_t handle, qt6cr_handle_t delegate) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setItemDelegate(as_styled_item_delegate(delegate));
  }
}

qt6cr_handle_t qt6cr_table_view_selection_model(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view == nullptr ? nullptr : view->selectionModel();
}

void qt6cr_table_view_set_selection_model(qt6cr_handle_t handle, qt6cr_handle_t selection_model) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setSelectionModel(as_item_selection_model(selection_model));
  }
}

qt6cr_handle_t qt6cr_table_view_current_index(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view == nullptr ? new QModelIndex() : new QModelIndex(view->currentIndex());
}

void qt6cr_table_view_set_current_index(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_table_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr) {
    view->setCurrentIndex(model_index == nullptr ? QModelIndex() : *model_index);
  }
}

int qt6cr_table_view_selection_mode(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->selectionMode());
}

void qt6cr_table_view_set_selection_mode(qt6cr_handle_t handle, int mode) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setSelectionMode(static_cast<QAbstractItemView::SelectionMode>(mode));
  }
}

int qt6cr_table_view_edit_triggers(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view == nullptr ? static_cast<int>(QAbstractItemView::DoubleClicked | QAbstractItemView::EditKeyPressed) : static_cast<int>(view->editTriggers());
}

void qt6cr_table_view_set_edit_triggers(qt6cr_handle_t handle, int triggers) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setEditTriggers(static_cast<QAbstractItemView::EditTriggers>(triggers));
  }
}

int qt6cr_table_view_selection_behavior(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view == nullptr ? static_cast<int>(QAbstractItemView::SelectItems) : static_cast<int>(view->selectionBehavior());
}

void qt6cr_table_view_set_selection_behavior(qt6cr_handle_t handle, int behavior) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setSelectionBehavior(static_cast<QAbstractItemView::SelectionBehavior>(behavior));
  }
}

bool qt6cr_table_view_alternating_row_colors(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view != nullptr && view->alternatingRowColors();
}

void qt6cr_table_view_set_alternating_row_colors(qt6cr_handle_t handle, bool value) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setAlternatingRowColors(value);
  }
}

bool qt6cr_table_view_drag_enabled(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view != nullptr && view->dragEnabled();
}

void qt6cr_table_view_set_drag_enabled(qt6cr_handle_t handle, bool value) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setDragEnabled(value);
  }
}

int qt6cr_table_view_drag_drop_mode(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->dragDropMode());
}

void qt6cr_table_view_set_drag_drop_mode(qt6cr_handle_t handle, int mode) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setDragDropMode(static_cast<QAbstractItemView::DragDropMode>(mode));
  }
}

int qt6cr_table_view_default_drop_action(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view == nullptr ? 0 : static_cast<int>(view->defaultDropAction());
}

void qt6cr_table_view_set_default_drop_action(qt6cr_handle_t handle, int action) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setDefaultDropAction(static_cast<Qt::DropAction>(action));
  }
}

bool qt6cr_table_view_drop_indicator_shown(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view != nullptr && view->showDropIndicator();
}

void qt6cr_table_view_set_drop_indicator_shown(qt6cr_handle_t handle, bool value) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setDropIndicatorShown(value);
  }
}

bool qt6cr_table_view_show_grid(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view != nullptr && view->showGrid();
}

void qt6cr_table_view_set_show_grid(qt6cr_handle_t handle, bool value) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setShowGrid(value);
  }
}

bool qt6cr_table_view_word_wrap(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view != nullptr && view->wordWrap();
}

void qt6cr_table_view_set_word_wrap(qt6cr_handle_t handle, bool value) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setWordWrap(value);
  }
}

bool qt6cr_table_view_sorting_enabled(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view != nullptr && view->isSortingEnabled();
}

void qt6cr_table_view_set_sorting_enabled(qt6cr_handle_t handle, bool value) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->setSortingEnabled(value);
  }
}

qt6cr_handle_t qt6cr_table_view_horizontal_header(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view == nullptr ? nullptr : view->horizontalHeader();
}

qt6cr_handle_t qt6cr_table_view_vertical_header(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);
  return view == nullptr ? nullptr : view->verticalHeader();
}

void qt6cr_table_view_set_span(qt6cr_handle_t handle, int row, int column, int row_span, int column_span) {
  auto *view = as_table_view(handle);

  if (view != nullptr && row >= 0 && column >= 0 && row_span >= 1 && column_span >= 1) {
    view->setSpan(row, column, row_span, column_span);
  }
}

int qt6cr_table_view_row_span(qt6cr_handle_t handle, int row, int column) {
  auto *view = as_table_view(handle);
  return view == nullptr ? 1 : view->rowSpan(row, column);
}

int qt6cr_table_view_column_span(qt6cr_handle_t handle, int row, int column) {
  auto *view = as_table_view(handle);
  return view == nullptr ? 1 : view->columnSpan(row, column);
}

void qt6cr_table_view_open_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_table_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr && model_index != nullptr) {
    view->openPersistentEditor(*model_index);
  }
}

void qt6cr_table_view_close_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_table_view(handle);
  auto *model_index = as_model_index(index);

  if (view != nullptr && model_index != nullptr) {
    view->closePersistentEditor(*model_index);
  }
}

bool qt6cr_table_view_is_persistent_editor_open(qt6cr_handle_t handle, qt6cr_handle_t index) {
  auto *view = as_table_view(handle);
  auto *model_index = as_model_index(index);
  return view != nullptr && model_index != nullptr && view->isPersistentEditorOpen(*model_index);
}

void qt6cr_table_view_sort_by_column(qt6cr_handle_t handle, int column, int order) {
  auto *view = as_table_view(handle);

  if (view != nullptr && column >= 0) {
    view->sortByColumn(column, static_cast<Qt::SortOrder>(order));
  }
}

void qt6cr_table_view_resize_columns_to_contents(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->resizeColumnsToContents();
  }
}

void qt6cr_table_view_resize_rows_to_contents(qt6cr_handle_t handle) {
  auto *view = as_table_view(handle);

  if (view != nullptr) {
    view->resizeRowsToContents();
  }
}

void qt6cr_table_view_on_current_index_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *view = as_table_view(handle);

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

void qt6cr_qpdf_writer_set_page_size_millimeters(qt6cr_handle_t handle, double width, double height, int orientation) {
  auto *writer = as_qpdf_writer(handle);

  if (writer != nullptr && width > 0.0 && height > 0.0) {
    writer->setPageLayout(QPageLayout(
        QPageSize(QSizeF(width, height), QPageSize::Millimeter),
        static_cast<QPageLayout::Orientation>(orientation),
        QMarginsF(0, 0, 0, 0)));
  }
}

void qt6cr_qpdf_writer_set_page_layout(qt6cr_handle_t handle, double width, double height, int unit, int orientation, double left, double top, double right, double bottom) {
  auto *writer = as_qpdf_writer(handle);

  if (writer == nullptr || width <= 0.0 || height <= 0.0) {
    return;
  }

  const auto page_unit = unit == 1 ? QPageSize::Point : QPageSize::Millimeter;
  writer->setPageLayout(QPageLayout(
      QPageSize(QSizeF(width, height), page_unit),
      static_cast<QPageLayout::Orientation>(orientation),
      QMarginsF(left, top, right, bottom)));
}

qt6cr_rectf_t qt6cr_qpdf_writer_page_layout_full_rect_points(qt6cr_handle_t handle) {
  auto *writer = as_qpdf_writer(handle);
  return writer == nullptr ? to_rectf(QRectF()) : to_rectf(writer->pageLayout().fullRect(QPageLayout::Point));
}

qt6cr_rectf_t qt6cr_qpdf_writer_page_layout_paint_rect_points(qt6cr_handle_t handle) {
  auto *writer = as_qpdf_writer(handle);
  return writer == nullptr ? to_rectf(QRectF()) : to_rectf(writer->pageLayout().paintRect(QPageLayout::Point));
}

bool qt6cr_qpdf_writer_new_page(qt6cr_handle_t handle) {
  auto *writer = as_qpdf_writer(handle);
  return writer != nullptr && writer->newPage();
}

qt6cr_handle_t qt6cr_qbyte_array_create(void) {
  return new QByteArray();
}

qt6cr_handle_t qt6cr_qbyte_array_create_from_data(const unsigned char *data, int size) {
  return new QByteArray(byte_array_from_data(data, size));
}

void qt6cr_qbyte_array_destroy(qt6cr_handle_t handle) {
  delete as_qbyte_array(handle);
}

int qt6cr_qbyte_array_size(qt6cr_handle_t handle) {
  auto *value = as_qbyte_array(handle);
  return value == nullptr ? 0 : value->size();
}

qt6cr_byte_array_t qt6cr_qbyte_array_data(qt6cr_handle_t handle) {
  auto *value = as_qbyte_array(handle);
  return value == nullptr ? qt6cr_byte_array_t{nullptr, 0} : to_byte_array_value(*value);
}

void qt6cr_qbyte_array_clear(qt6cr_handle_t handle) {
  auto *value = as_qbyte_array(handle);

  if (value != nullptr) {
    value->clear();
  }
}

bool qt6cr_io_device_open(qt6cr_handle_t handle, int open_mode) {
  auto *device = as_qio_device(handle);
  return device != nullptr && device->open(QIODevice::OpenMode(open_mode));
}

void qt6cr_io_device_close(qt6cr_handle_t handle) {
  auto *device = as_qio_device(handle);

  if (device != nullptr) {
    device->close();
  }
}

bool qt6cr_io_device_is_open(qt6cr_handle_t handle) {
  auto *device = as_qio_device(handle);
  return device != nullptr && device->isOpen();
}

int64_t qt6cr_io_device_size(qt6cr_handle_t handle) {
  auto *device = as_qio_device(handle);
  return device == nullptr ? 0 : static_cast<int64_t>(device->size());
}

int64_t qt6cr_io_device_position(qt6cr_handle_t handle) {
  auto *device = as_qio_device(handle);
  return device == nullptr ? 0 : static_cast<int64_t>(device->pos());
}

bool qt6cr_io_device_seek(qt6cr_handle_t handle, int64_t position) {
  auto *device = as_qio_device(handle);
  return device != nullptr && device->seek(position);
}

bool qt6cr_io_device_at_end(qt6cr_handle_t handle) {
  auto *device = as_qio_device(handle);
  return device != nullptr && device->atEnd();
}

int64_t qt6cr_io_device_bytes_available(qt6cr_handle_t handle) {
  auto *device = as_qio_device(handle);
  return device == nullptr ? 0 : static_cast<int64_t>(device->bytesAvailable());
}

qt6cr_byte_array_t qt6cr_io_device_read(qt6cr_handle_t handle, int size) {
  auto *device = as_qio_device(handle);
  return device == nullptr || size <= 0 ? qt6cr_byte_array_t{nullptr, 0} : to_byte_array_value(device->read(size));
}

qt6cr_byte_array_t qt6cr_io_device_peek(qt6cr_handle_t handle, int size) {
  auto *device = as_qio_device(handle);
  return device == nullptr || size <= 0 ? qt6cr_byte_array_t{nullptr, 0} : to_byte_array_value(device->peek(size));
}

qt6cr_byte_array_t qt6cr_io_device_read_all(qt6cr_handle_t handle) {
  auto *device = as_qio_device(handle);
  return device == nullptr ? qt6cr_byte_array_t{nullptr, 0} : to_byte_array_value(device->readAll());
}

int64_t qt6cr_io_device_write(qt6cr_handle_t handle, const unsigned char *data, int size) {
  auto *device = as_qio_device(handle);

  if (device == nullptr || data == nullptr || size <= 0) {
    return 0;
  }

  return static_cast<int64_t>(device->write(reinterpret_cast<const char *>(data), size));
}

qt6cr_handle_t qt6cr_qbuffer_create(qt6cr_handle_t byte_array) {
  auto *data = as_qbyte_array(byte_array);
  return data == nullptr ? new QBuffer() : new QBuffer(data);
}

void qt6cr_qbuffer_destroy(qt6cr_handle_t handle) {
  delete as_qbuffer(handle);
}

bool qt6cr_qbuffer_open(qt6cr_handle_t handle, int open_mode) {
  auto *buffer = as_qbuffer(handle);
  return buffer != nullptr && buffer->open(QIODevice::OpenMode(open_mode));
}

void qt6cr_qbuffer_close(qt6cr_handle_t handle) {
  auto *buffer = as_qbuffer(handle);

  if (buffer != nullptr) {
    buffer->close();
  }
}

bool qt6cr_qbuffer_is_open(qt6cr_handle_t handle) {
  auto *buffer = as_qbuffer(handle);
  return buffer != nullptr && buffer->isOpen();
}

qt6cr_handle_t qt6cr_qbuffer_data(qt6cr_handle_t handle) {
  auto *buffer = as_qbuffer(handle);
  return buffer == nullptr ? nullptr : new QByteArray(buffer->data());
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

int qt6cr_qpen_style(qt6cr_handle_t handle) {
  auto *pen = as_qpen(handle);
  return pen == nullptr ? static_cast<int>(Qt::SolidLine) : static_cast<int>(pen->style());
}

void qt6cr_qpen_set_style(qt6cr_handle_t handle, int style) {
  auto *pen = as_qpen(handle);

  if (pen != nullptr) {
    pen->setStyle(static_cast<Qt::PenStyle>(style));
  }
}

int qt6cr_qpen_cap_style(qt6cr_handle_t handle) {
  auto *pen = as_qpen(handle);
  return pen == nullptr ? static_cast<int>(Qt::SquareCap) : static_cast<int>(pen->capStyle());
}

void qt6cr_qpen_set_cap_style(qt6cr_handle_t handle, int style) {
  auto *pen = as_qpen(handle);

  if (pen != nullptr) {
    pen->setCapStyle(static_cast<Qt::PenCapStyle>(style));
  }
}

int qt6cr_qpen_join_style(qt6cr_handle_t handle) {
  auto *pen = as_qpen(handle);
  return pen == nullptr ? static_cast<int>(Qt::BevelJoin) : static_cast<int>(pen->joinStyle());
}

void qt6cr_qpen_set_join_style(qt6cr_handle_t handle, int style) {
  auto *pen = as_qpen(handle);

  if (pen != nullptr) {
    pen->setJoinStyle(static_cast<Qt::PenJoinStyle>(style));
  }
}

double qt6cr_qpen_dash_offset(qt6cr_handle_t handle) {
  auto *pen = as_qpen(handle);
  return pen == nullptr ? 0.0 : pen->dashOffset();
}

void qt6cr_qpen_set_dash_offset(qt6cr_handle_t handle, double offset) {
  auto *pen = as_qpen(handle);

  if (pen != nullptr) {
    pen->setDashOffset(offset);
  }
}

void qt6cr_qpen_set_dash_pattern(qt6cr_handle_t handle, const double *values, int size) {
  auto *pen = as_qpen(handle);

  if (pen == nullptr || values == nullptr || size <= 0) {
    return;
  }

  QList<qreal> pattern;
  pattern.reserve(size);
  for (int index = 0; index < size; ++index) {
    pattern.append(values[index]);
  }
  pen->setDashPattern(pattern);
}

qt6cr_handle_t qt6cr_qlinear_gradient_create(double x1, double y1, double x2, double y2) {
  return new QLinearGradient(x1, y1, x2, y2);
}

void qt6cr_qlinear_gradient_destroy(qt6cr_handle_t handle) {
  delete as_qlinear_gradient(handle);
}

void qt6cr_qlinear_gradient_set_color_at(qt6cr_handle_t handle, double position, qt6cr_color_t color) {
  auto *gradient = as_qlinear_gradient(handle);

  if (gradient != nullptr) {
    gradient->setColorAt(position, from_color(color));
  }
}

qt6cr_pointf_t qt6cr_qlinear_gradient_start(qt6cr_handle_t handle) {
  auto *gradient = as_qlinear_gradient(handle);
  return gradient == nullptr ? qt6cr_pointf_t{0.0, 0.0} : to_pointf(gradient->start());
}

qt6cr_pointf_t qt6cr_qlinear_gradient_final_stop(qt6cr_handle_t handle) {
  auto *gradient = as_qlinear_gradient(handle);
  return gradient == nullptr ? qt6cr_pointf_t{0.0, 0.0} : to_pointf(gradient->finalStop());
}

qt6cr_handle_t qt6cr_qradial_gradient_create(double center_x, double center_y, double radius) {
  return new QRadialGradient(center_x, center_y, radius);
}

void qt6cr_qradial_gradient_destroy(qt6cr_handle_t handle) {
  delete as_qradial_gradient(handle);
}

void qt6cr_qradial_gradient_set_color_at(qt6cr_handle_t handle, double position, qt6cr_color_t color) {
  auto *gradient = as_qradial_gradient(handle);

  if (gradient != nullptr) {
    gradient->setColorAt(position, from_color(color));
  }
}

qt6cr_pointf_t qt6cr_qradial_gradient_center(qt6cr_handle_t handle) {
  auto *gradient = as_qradial_gradient(handle);
  return gradient == nullptr ? qt6cr_pointf_t{0.0, 0.0} : to_pointf(gradient->center());
}

double qt6cr_qradial_gradient_radius(qt6cr_handle_t handle) {
  auto *gradient = as_qradial_gradient(handle);
  return gradient == nullptr ? 0.0 : gradient->radius();
}

qt6cr_handle_t qt6cr_qbrush_create(qt6cr_color_t color) {
  return new QBrush(from_color(color));
}

qt6cr_handle_t qt6cr_qbrush_create_from_pixmap(qt6cr_handle_t pixmap) {
  auto *source = as_qpixmap(pixmap);
  return source == nullptr ? nullptr : new QBrush(*source);
}

qt6cr_handle_t qt6cr_qbrush_create_from_image(qt6cr_handle_t image) {
  auto *source = as_qimage(image);
  return source == nullptr ? nullptr : new QBrush(QPixmap::fromImage(*source));
}

qt6cr_handle_t qt6cr_qbrush_create_from_linear_gradient(qt6cr_handle_t gradient) {
  auto *source = as_qlinear_gradient(gradient);
  return source == nullptr ? nullptr : new QBrush(*source);
}

qt6cr_handle_t qt6cr_qbrush_create_from_radial_gradient(qt6cr_handle_t gradient) {
  auto *source = as_qradial_gradient(gradient);
  return source == nullptr ? nullptr : new QBrush(*source);
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

qt6cr_handle_t qt6cr_qbrush_transform(qt6cr_handle_t handle) {
  auto *brush = as_qbrush(handle);
  return brush == nullptr ? nullptr : new QTransform(brush->transform());
}

void qt6cr_qbrush_set_transform(qt6cr_handle_t handle, qt6cr_handle_t transform) {
  auto *brush = as_qbrush(handle);
  auto *matrix = as_qtransform(transform);

  if (brush != nullptr && matrix != nullptr) {
    brush->setTransform(*matrix);
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

qt6cr_handle_t qt6cr_qurl_create(const char *value) {
  return new QUrl(QString::fromUtf8(value == nullptr ? "" : value));
}

qt6cr_handle_t qt6cr_qurl_create_from_local_file(const char *path) {
  return new QUrl(QUrl::fromLocalFile(QString::fromUtf8(path == nullptr ? "" : path)));
}

void qt6cr_qurl_destroy(qt6cr_handle_t handle) {
  delete as_qurl(handle);
}

bool qt6cr_qurl_is_valid(qt6cr_handle_t handle) {
  auto *url = as_qurl(handle);
  return url == nullptr ? false : url->isValid();
}

bool qt6cr_qurl_is_local_file(qt6cr_handle_t handle) {
  auto *url = as_qurl(handle);
  return url == nullptr ? false : url->isLocalFile();
}

char *qt6cr_qurl_scheme(qt6cr_handle_t handle) {
  auto *url = as_qurl(handle);
  return url == nullptr ? duplicate_string("") : duplicate_string(url->scheme());
}

char *qt6cr_qurl_path(qt6cr_handle_t handle) {
  auto *url = as_qurl(handle);
  return url == nullptr ? duplicate_string("") : duplicate_string(url->path());
}

char *qt6cr_qurl_to_string(qt6cr_handle_t handle) {
  auto *url = as_qurl(handle);
  return url == nullptr ? duplicate_string("") : duplicate_string(url->toString());
}

char *qt6cr_qurl_to_local_file(qt6cr_handle_t handle) {
  auto *url = as_qurl(handle);
  return url == nullptr ? duplicate_string("") : duplicate_string(url->toLocalFile());
}

qt6cr_handle_t qt6cr_qdir_create(const char *path) {
  return new QDir(QString::fromUtf8(path == nullptr ? "" : path));
}

void qt6cr_qdir_destroy(qt6cr_handle_t handle) {
  delete as_qdir(handle);
}

char *qt6cr_qdir_path(qt6cr_handle_t handle) {
  auto *dir = as_qdir(handle);
  return dir == nullptr ? duplicate_string("") : duplicate_string(dir->path());
}

char *qt6cr_qdir_absolute_path(qt6cr_handle_t handle) {
  auto *dir = as_qdir(handle);
  return dir == nullptr ? duplicate_string("") : duplicate_string(dir->absolutePath());
}

bool qt6cr_qdir_exists(qt6cr_handle_t handle) {
  auto *dir = as_qdir(handle);
  return dir == nullptr ? false : dir->exists();
}

char *qt6cr_qdir_file_path(qt6cr_handle_t handle, const char *name) {
  auto *dir = as_qdir(handle);
  return dir == nullptr ? duplicate_string("") : duplicate_string(dir->filePath(QString::fromUtf8(name == nullptr ? "" : name)));
}

char *qt6cr_qdir_absolute_file_path(qt6cr_handle_t handle, const char *name) {
  auto *dir = as_qdir(handle);
  return dir == nullptr ? duplicate_string("") : duplicate_string(dir->absoluteFilePath(QString::fromUtf8(name == nullptr ? "" : name)));
}

bool qt6cr_qdir_mkpath(qt6cr_handle_t handle, const char *path) {
  auto *dir = as_qdir(handle);
  return dir == nullptr ? false : dir->mkpath(QString::fromUtf8(path == nullptr ? "" : path));
}

char *qt6cr_qdir_current_path(void) {
  return duplicate_string(QDir::currentPath());
}

char *qt6cr_qdir_home_path(void) {
  return duplicate_string(QDir::homePath());
}

char *qt6cr_qdir_clean_path(const char *path) {
  return duplicate_string(QDir::cleanPath(QString::fromUtf8(path == nullptr ? "" : path)));
}

qt6cr_handle_t qt6cr_qfile_create(const char *file_name) {
  return new QFile(QString::fromUtf8(file_name == nullptr ? "" : file_name));
}

void qt6cr_qfile_destroy(qt6cr_handle_t handle) {
  delete as_qfile(handle);
}

char *qt6cr_qfile_file_name(qt6cr_handle_t handle) {
  auto *file = as_qfile(handle);
  return file == nullptr ? duplicate_string("") : duplicate_string(file->fileName());
}

void qt6cr_qfile_set_file_name(qt6cr_handle_t handle, const char *file_name) {
  auto *file = as_qfile(handle);

  if (file != nullptr) {
    file->setFileName(QString::fromUtf8(file_name == nullptr ? "" : file_name));
  }
}

bool qt6cr_qfile_exists(qt6cr_handle_t handle) {
  auto *file = as_qfile(handle);
  return file == nullptr ? false : file->exists();
}

bool qt6cr_qfile_exists_at_path(const char *file_name) {
  return QFile::exists(QString::fromUtf8(file_name == nullptr ? "" : file_name));
}

bool qt6cr_qfile_open(qt6cr_handle_t handle, int open_mode) {
  auto *file = as_qfile(handle);
  return file != nullptr && file->open(QIODevice::OpenMode(open_mode));
}

void qt6cr_qfile_close(qt6cr_handle_t handle) {
  auto *file = as_qfile(handle);

  if (file != nullptr) {
    file->close();
  }
}

bool qt6cr_qfile_is_open(qt6cr_handle_t handle) {
  auto *file = as_qfile(handle);
  return file != nullptr && file->isOpen();
}

int64_t qt6cr_qfile_size(qt6cr_handle_t handle) {
  auto *file = as_qfile(handle);
  return file == nullptr ? 0 : static_cast<int64_t>(file->size());
}

qt6cr_byte_array_t qt6cr_qfile_read_all(qt6cr_handle_t handle) {
  auto *file = as_qfile(handle);
  return file == nullptr ? qt6cr_byte_array_t{nullptr, 0} : to_byte_array_value(file->readAll());
}

int64_t qt6cr_qfile_write(qt6cr_handle_t handle, const unsigned char *data, int size) {
  auto *file = as_qfile(handle);

  if (file == nullptr || data == nullptr || size <= 0) {
    return 0;
  }

  return static_cast<int64_t>(file->write(reinterpret_cast<const char *>(data), size));
}

bool qt6cr_qfile_flush(qt6cr_handle_t handle) {
  auto *file = as_qfile(handle);
  return file != nullptr && file->flush();
}

bool qt6cr_qfile_remove(qt6cr_handle_t handle) {
  auto *file = as_qfile(handle);
  return file != nullptr && file->remove();
}

qt6cr_handle_t qt6cr_qsettings_create_from_file(const char *file_name, int format) {
  return new QSettings(QString::fromUtf8(file_name == nullptr ? "" : file_name), static_cast<QSettings::Format>(format));
}

qt6cr_handle_t qt6cr_qsettings_create_for_application(const char *organization, const char *application, int format) {
  return new QSettings(
    static_cast<QSettings::Format>(format),
    QSettings::UserScope,
    QString::fromUtf8(organization == nullptr ? "" : organization),
    QString::fromUtf8(application == nullptr ? "" : application)
  );
}

void qt6cr_qsettings_destroy(qt6cr_handle_t handle) {
  delete as_qsettings(handle);
}

char *qt6cr_qsettings_file_name(qt6cr_handle_t handle) {
  auto *settings = as_qsettings(handle);
  return settings == nullptr ? duplicate_string("") : duplicate_string(settings->fileName());
}

bool qt6cr_qsettings_contains(qt6cr_handle_t handle, const char *key) {
  auto *settings = as_qsettings(handle);
  return settings == nullptr ? false : settings->contains(QString::fromUtf8(key == nullptr ? "" : key));
}

qt6cr_variant_value_t qt6cr_qsettings_value(qt6cr_handle_t handle, const char *key, qt6cr_variant_value_t default_value) {
  auto *settings = as_qsettings(handle);

  if (settings == nullptr) {
    return qt6cr_variant_value_t{0, false, 0, 0.0, qt6cr_color_t{0, 0, 0, 0}, nullptr};
  }

  return to_variant_value(settings->value(
    QString::fromUtf8(key == nullptr ? "" : key),
    from_variant_value(default_value)
  ));
}

void qt6cr_qsettings_set_value(qt6cr_handle_t handle, const char *key, qt6cr_variant_value_t value) {
  auto *settings = as_qsettings(handle);

  if (settings != nullptr) {
    settings->setValue(QString::fromUtf8(key == nullptr ? "" : key), from_variant_value(value));
  }
}

void qt6cr_qsettings_remove(qt6cr_handle_t handle, const char *key) {
  auto *settings = as_qsettings(handle);

  if (settings != nullptr) {
    settings->remove(QString::fromUtf8(key == nullptr ? "" : key));
  }
}

void qt6cr_qsettings_clear(qt6cr_handle_t handle) {
  auto *settings = as_qsettings(handle);

  if (settings != nullptr) {
    settings->clear();
  }
}

void qt6cr_qsettings_sync(qt6cr_handle_t handle) {
  auto *settings = as_qsettings(handle);

  if (settings != nullptr) {
    settings->sync();
  }
}

qt6cr_string_array_t qt6cr_qsettings_all_keys(qt6cr_handle_t handle) {
  auto *settings = as_qsettings(handle);
  return settings == nullptr ? qt6cr_string_array_t{nullptr, 0} : to_string_array_value(settings->allKeys());
}

char *qt6cr_standard_paths_writable_location(int location) {
  return duplicate_string(QStandardPaths::writableLocation(static_cast<QStandardPaths::StandardLocation>(location)));
}

qt6cr_string_array_t qt6cr_standard_paths_standard_locations(int location) {
  return to_string_array_value(QStandardPaths::standardLocations(static_cast<QStandardPaths::StandardLocation>(location)));
}

char *qt6cr_standard_paths_display_name(int location) {
  return duplicate_string(QStandardPaths::displayName(static_cast<QStandardPaths::StandardLocation>(location)));
}

bool qt6cr_desktop_services_open_url(qt6cr_handle_t url) {
  auto *target = as_qurl(url);
  return target != nullptr && QDesktopServices::openUrl(*target);
}

qt6cr_handle_t qt6cr_qfile_info_create(const char *path) {
  return new QFileInfo(QString::fromUtf8(path == nullptr ? "" : path));
}

void qt6cr_qfile_info_destroy(qt6cr_handle_t handle) {
  delete as_qfile_info(handle);
}

char *qt6cr_qfile_info_file_name(qt6cr_handle_t handle) {
  auto *info = as_qfile_info(handle);
  return info == nullptr ? duplicate_string("") : duplicate_string(info->fileName());
}

char *qt6cr_qfile_info_base_name(qt6cr_handle_t handle) {
  auto *info = as_qfile_info(handle);
  return info == nullptr ? duplicate_string("") : duplicate_string(info->baseName());
}

char *qt6cr_qfile_info_suffix(qt6cr_handle_t handle) {
  auto *info = as_qfile_info(handle);
  return info == nullptr ? duplicate_string("") : duplicate_string(info->suffix());
}

char *qt6cr_qfile_info_absolute_file_path(qt6cr_handle_t handle) {
  auto *info = as_qfile_info(handle);
  return info == nullptr ? duplicate_string("") : duplicate_string(info->absoluteFilePath());
}

char *qt6cr_qfile_info_absolute_path(qt6cr_handle_t handle) {
  auto *info = as_qfile_info(handle);
  return info == nullptr ? duplicate_string("") : duplicate_string(info->absolutePath());
}

bool qt6cr_qfile_info_exists(qt6cr_handle_t handle) {
  auto *info = as_qfile_info(handle);
  return info == nullptr ? false : info->exists();
}

bool qt6cr_qfile_info_is_file(qt6cr_handle_t handle) {
  auto *info = as_qfile_info(handle);
  return info == nullptr ? false : info->isFile();
}

bool qt6cr_qfile_info_is_dir(qt6cr_handle_t handle) {
  auto *info = as_qfile_info(handle);
  return info == nullptr ? false : info->isDir();
}

int64_t qt6cr_qfile_info_size(qt6cr_handle_t handle) {
  auto *info = as_qfile_info(handle);
  return info == nullptr ? 0 : static_cast<int64_t>(info->size());
}

qt6cr_handle_t qt6cr_qdate_create(int year, int month, int day) {
  return new QDate(year, month, day);
}

void qt6cr_qdate_destroy(qt6cr_handle_t handle) {
  delete as_qdate(handle);
}

int qt6cr_qdate_year(qt6cr_handle_t handle) {
  auto *date = as_qdate(handle);
  return date == nullptr ? 0 : date->year();
}

int qt6cr_qdate_month(qt6cr_handle_t handle) {
  auto *date = as_qdate(handle);
  return date == nullptr ? 0 : date->month();
}

int qt6cr_qdate_day(qt6cr_handle_t handle) {
  auto *date = as_qdate(handle);
  return date == nullptr ? 0 : date->day();
}

bool qt6cr_qdate_is_valid(qt6cr_handle_t handle) {
  auto *date = as_qdate(handle);
  return date != nullptr && date->isValid();
}

char *qt6cr_qdate_to_string(qt6cr_handle_t handle, const char *format) {
  auto *date = as_qdate(handle);
  return date == nullptr ? duplicate_string("") : duplicate_string(date->toString(QString::fromUtf8(format == nullptr ? "" : format)));
}

qt6cr_handle_t qt6cr_qtime_create(int hour, int minute, int second) {
  return new QTime(hour, minute, second);
}

void qt6cr_qtime_destroy(qt6cr_handle_t handle) {
  delete as_qtime(handle);
}

int qt6cr_qtime_hour(qt6cr_handle_t handle) {
  auto *time = as_qtime(handle);
  return time == nullptr ? 0 : time->hour();
}

int qt6cr_qtime_minute(qt6cr_handle_t handle) {
  auto *time = as_qtime(handle);
  return time == nullptr ? 0 : time->minute();
}

int qt6cr_qtime_second(qt6cr_handle_t handle) {
  auto *time = as_qtime(handle);
  return time == nullptr ? 0 : time->second();
}

bool qt6cr_qtime_is_valid(qt6cr_handle_t handle) {
  auto *time = as_qtime(handle);
  return time != nullptr && time->isValid();
}

char *qt6cr_qtime_to_string(qt6cr_handle_t handle, const char *format) {
  auto *time = as_qtime(handle);
  return time == nullptr ? duplicate_string("") : duplicate_string(time->toString(QString::fromUtf8(format == nullptr ? "" : format)));
}

qt6cr_handle_t qt6cr_qdatetime_create(int year, int month, int day, int hour, int minute, int second) {
  return new QDateTime(QDate(year, month, day), QTime(hour, minute, second));
}

void qt6cr_qdatetime_destroy(qt6cr_handle_t handle) {
  delete as_qdatetime(handle);
}

qt6cr_handle_t qt6cr_qdatetime_date(qt6cr_handle_t handle) {
  auto *datetime = as_qdatetime(handle);
  return datetime == nullptr ? nullptr : new QDate(datetime->date());
}

qt6cr_handle_t qt6cr_qdatetime_time(qt6cr_handle_t handle) {
  auto *datetime = as_qdatetime(handle);
  return datetime == nullptr ? nullptr : new QTime(datetime->time());
}

bool qt6cr_qdatetime_is_valid(qt6cr_handle_t handle) {
  auto *datetime = as_qdatetime(handle);
  return datetime != nullptr && datetime->isValid();
}

char *qt6cr_qdatetime_to_string(qt6cr_handle_t handle, const char *format) {
  auto *datetime = as_qdatetime(handle);
  return datetime == nullptr ? duplicate_string("") : duplicate_string(datetime->toString(QString::fromUtf8(format == nullptr ? "" : format)));
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

qt6cr_handle_t qt6cr_qtransform_map_path(qt6cr_handle_t handle, qt6cr_handle_t path) {
  auto *transform = as_qtransform(handle);
  auto *source = as_qpainter_path(path);
  return (transform == nullptr || source == nullptr) ? nullptr : new QPainterPath(transform->map(*source));
}

qt6cr_handle_t qt6cr_qpolygonf_create(void) {
  return new QPolygonF();
}

void qt6cr_qpolygonf_destroy(qt6cr_handle_t handle) {
  delete as_qpolygonf(handle);
}

void qt6cr_qpolygonf_append(qt6cr_handle_t handle, qt6cr_pointf_t point) {
  auto *polygon = as_qpolygonf(handle);

  if (polygon != nullptr) {
    polygon->append(from_pointf(point));
  }
}

int qt6cr_qpolygonf_size(qt6cr_handle_t handle) {
  auto *polygon = as_qpolygonf(handle);
  return polygon == nullptr ? 0 : polygon->size();
}

qt6cr_pointf_t qt6cr_qpolygonf_at(qt6cr_handle_t handle, int index) {
  auto *polygon = as_qpolygonf(handle);
  if (polygon == nullptr || index < 0 || index >= polygon->size()) {
    return qt6cr_pointf_t{0.0, 0.0};
  }

  return to_pointf(polygon->at(index));
}

qt6cr_rectf_t qt6cr_qpolygonf_bounding_rect(qt6cr_handle_t handle) {
  auto *polygon = as_qpolygonf(handle);
  return polygon == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(polygon->boundingRect());
}

qt6cr_handle_t qt6cr_qpainter_path_create(void) {
  return new QPainterPath();
}

void qt6cr_qpainter_path_destroy(qt6cr_handle_t handle) {
  delete as_qpainter_path(handle);
}

void qt6cr_qpainter_path_clear(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);

  if (path != nullptr) {
    path->clear();
  }
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

void qt6cr_qpainter_path_add_polygon(qt6cr_handle_t handle, qt6cr_handle_t polygon) {
  auto *path = as_qpainter_path(handle);
  auto *shape = as_qpolygonf(polygon);

  if (path != nullptr && shape != nullptr) {
    path->addPolygon(*shape);
  }
}

void qt6cr_qpainter_path_add_path(qt6cr_handle_t handle, qt6cr_handle_t other) {
  auto *path = as_qpainter_path(handle);
  auto *source = as_qpainter_path(other);

  if (path != nullptr && source != nullptr) {
    path->addPath(*source);
  }
}

void qt6cr_qpainter_path_connect_path(qt6cr_handle_t handle, qt6cr_handle_t other) {
  auto *path = as_qpainter_path(handle);
  auto *source = as_qpainter_path(other);

  if (path != nullptr && source != nullptr) {
    path->connectPath(*source);
  }
}

void qt6cr_qpainter_path_close_subpath(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);

  if (path != nullptr) {
    path->closeSubpath();
  }
}

qt6cr_pointf_t qt6cr_qpainter_path_current_position(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);
  return path == nullptr ? qt6cr_pointf_t{0.0, 0.0} : to_pointf(path->currentPosition());
}

int qt6cr_qpainter_path_element_count(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);
  return path == nullptr ? 0 : path->elementCount();
}

qt6cr_painter_path_element_t qt6cr_qpainter_path_element_at(qt6cr_handle_t handle, int index) {
  auto *path = as_qpainter_path(handle);

  if (path == nullptr || index < 0 || index >= path->elementCount()) {
    return qt6cr_painter_path_element_t{0.0, 0.0, -1};
  }

  const auto element = path->elementAt(index);
  return qt6cr_painter_path_element_t{element.x, element.y, static_cast<int>(element.type)};
}

qt6cr_rectf_t qt6cr_qpainter_path_bounding_rect(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);
  return path == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(path->boundingRect());
}

qt6cr_rectf_t qt6cr_qpainter_path_control_point_rect(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);
  return path == nullptr ? qt6cr_rectf_t{0.0, 0.0, 0.0, 0.0} : to_rectf(path->controlPointRect());
}

qt6cr_handle_t qt6cr_qpainter_path_transformed(qt6cr_handle_t handle, qt6cr_handle_t transform) {
  auto *path = as_qpainter_path(handle);
  auto *matrix = as_qtransform(transform);
  return (path == nullptr || matrix == nullptr) ? nullptr : new QPainterPath(matrix->map(*path));
}

qt6cr_handle_t qt6cr_qpainter_path_translated(qt6cr_handle_t handle, double dx, double dy) {
  auto *path = as_qpainter_path(handle);
  return path == nullptr ? nullptr : new QPainterPath(path->translated(dx, dy));
}

qt6cr_handle_t qt6cr_qpainter_path_simplified(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);
  return path == nullptr ? nullptr : new QPainterPath(path->simplified());
}

bool qt6cr_qpainter_path_contains(qt6cr_handle_t handle, qt6cr_pointf_t point) {
  auto *path = as_qpainter_path(handle);
  return path != nullptr && path->contains(from_pointf(point));
}

bool qt6cr_qpainter_path_contains_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *path = as_qpainter_path(handle);
  return path != nullptr && path->contains(from_rectf(rect));
}

bool qt6cr_qpainter_path_intersects_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *path = as_qpainter_path(handle);
  return path != nullptr && path->intersects(from_rectf(rect));
}

bool qt6cr_qpainter_path_is_empty(qt6cr_handle_t handle) {
  auto *path = as_qpainter_path(handle);
  return path == nullptr || path->isEmpty();
}

qt6cr_handle_t qt6cr_qpainter_path_stroker_create(void) {
  return new QPainterPathStroker();
}

void qt6cr_qpainter_path_stroker_destroy(qt6cr_handle_t handle) {
  delete as_qpainter_path_stroker(handle);
}

double qt6cr_qpainter_path_stroker_width(qt6cr_handle_t handle) {
  auto *stroker = as_qpainter_path_stroker(handle);
  return stroker == nullptr ? 0.0 : stroker->width();
}

void qt6cr_qpainter_path_stroker_set_width(qt6cr_handle_t handle, double width) {
  auto *stroker = as_qpainter_path_stroker(handle);

  if (stroker != nullptr) {
    stroker->setWidth(width);
  }
}

qt6cr_handle_t qt6cr_qpainter_path_stroker_create_stroke(qt6cr_handle_t handle, qt6cr_handle_t path) {
  auto *stroker = as_qpainter_path_stroker(handle);
  auto *source = as_qpainter_path(path);
  return (stroker == nullptr || source == nullptr) ? nullptr : new QPainterPath(stroker->createStroke(*source));
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

bool qt6cr_qpainter_end(qt6cr_handle_t handle) {
  auto *painter = as_qpainter(handle);
  return painter != nullptr && painter->end();
}

void qt6cr_qpainter_set_antialiasing(qt6cr_handle_t handle, bool value) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->setRenderHint(QPainter::Antialiasing, value);
  }
}

void qt6cr_qpainter_set_smooth_pixmap_transform(qt6cr_handle_t handle, bool value) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->setRenderHint(QPainter::SmoothPixmapTransform, value);
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

void qt6cr_qpainter_translate(qt6cr_handle_t handle, double dx, double dy) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->translate(dx, dy);
  }
}

void qt6cr_qpainter_scale(qt6cr_handle_t handle, double sx, double sy) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->scale(sx, sy);
  }
}

void qt6cr_qpainter_rotate(qt6cr_handle_t handle, double angle) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->rotate(angle);
  }
}

void qt6cr_qpainter_save(qt6cr_handle_t handle) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->save();
  }
}

void qt6cr_qpainter_restore(qt6cr_handle_t handle) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->restore();
  }
}

double qt6cr_qpainter_opacity(qt6cr_handle_t handle) {
  auto *painter = as_qpainter(handle);
  return painter == nullptr ? 1.0 : painter->opacity();
}

void qt6cr_qpainter_set_opacity(qt6cr_handle_t handle, double value) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->setOpacity(value);
  }
}

int qt6cr_qpainter_composition_mode(qt6cr_handle_t handle) {
  auto *painter = as_qpainter(handle);
  return painter == nullptr ? static_cast<int>(QPainter::CompositionMode_SourceOver) : static_cast<int>(painter->compositionMode());
}

void qt6cr_qpainter_set_composition_mode(qt6cr_handle_t handle, int mode) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->setCompositionMode(static_cast<QPainter::CompositionMode>(mode));
  }
}

void qt6cr_qpainter_set_clipping(qt6cr_handle_t handle, bool value) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->setClipping(value);
  }
}

void qt6cr_qpainter_set_clip_path(qt6cr_handle_t handle, qt6cr_handle_t path) {
  auto *painter = as_qpainter(handle);
  auto *shape = as_qpainter_path(path);

  if (painter != nullptr && shape != nullptr) {
    painter->setClipPath(*shape);
  }
}

void qt6cr_qpainter_set_clip_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->setClipRect(from_rectf(rect));
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

void qt6cr_qpainter_fill_rect_brush(qt6cr_handle_t handle, qt6cr_rectf_t rect, qt6cr_handle_t brush) {
  auto *painter = as_qpainter(handle);
  auto *value = as_qbrush(brush);

  if (painter != nullptr && value != nullptr) {
    painter->fillRect(from_rectf(rect), *value);
  }
}

void qt6cr_qpainter_draw_ellipse(qt6cr_handle_t handle, qt6cr_rectf_t rect) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->drawEllipse(from_rectf(rect));
  }
}

void qt6cr_qpainter_draw_ellipse_center(qt6cr_handle_t handle, qt6cr_pointf_t center, double rx, double ry) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->drawEllipse(from_pointf(center), rx, ry);
  }
}

void qt6cr_qpainter_draw_path(qt6cr_handle_t handle, qt6cr_handle_t path) {
  auto *painter = as_qpainter(handle);
  auto *shape = as_qpainter_path(path);

  if (painter != nullptr && shape != nullptr) {
    painter->drawPath(*shape);
  }
}

void qt6cr_qpainter_draw_polygon(qt6cr_handle_t handle, qt6cr_handle_t polygon) {
  auto *painter = as_qpainter(handle);
  auto *shape = as_qpolygonf(polygon);

  if (painter != nullptr && shape != nullptr) {
    painter->drawPolygon(*shape);
  }
}

void qt6cr_qpainter_draw_image(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_handle_t image) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qimage(image);

  if (painter != nullptr && source != nullptr) {
    painter->drawImage(from_pointf(position), *source);
  }
}

void qt6cr_qpainter_draw_image_xy(qt6cr_handle_t handle, double x, double y, qt6cr_handle_t image) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qimage(image);

  if (painter != nullptr && source != nullptr) {
    painter->drawImage(QPointF(x, y), *source);
  }
}

void qt6cr_qpainter_draw_image_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect, qt6cr_handle_t image) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qimage(image);

  if (painter != nullptr && source != nullptr) {
    painter->drawImage(from_rectf(rect), *source);
  }
}

void qt6cr_qpainter_draw_image_rect_source(qt6cr_handle_t handle, qt6cr_rectf_t target, qt6cr_handle_t image, qt6cr_rectf_t source_rect) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qimage(image);

  if (painter != nullptr && source != nullptr) {
    painter->drawImage(from_rectf(target), *source, from_rectf(source_rect));
  }
}

void qt6cr_qpainter_draw_pixmap(qt6cr_handle_t handle, qt6cr_pointf_t position, qt6cr_handle_t pixmap) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qpixmap(pixmap);

  if (painter != nullptr && source != nullptr) {
    painter->drawPixmap(from_pointf(position), *source);
  }
}

void qt6cr_qpainter_draw_pixmap_xy(qt6cr_handle_t handle, double x, double y, qt6cr_handle_t pixmap) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qpixmap(pixmap);

  if (painter != nullptr && source != nullptr) {
    painter->drawPixmap(QPointF(x, y), *source);
  }
}

void qt6cr_qpainter_draw_pixmap_rect(qt6cr_handle_t handle, qt6cr_rectf_t rect, qt6cr_handle_t pixmap) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qpixmap(pixmap);

  if (painter != nullptr && source != nullptr) {
    painter->drawPixmap(from_rectf(rect), *source, source->rect());
  }
}

void qt6cr_qpainter_draw_pixmap_rect_source(qt6cr_handle_t handle, qt6cr_rectf_t target, qt6cr_handle_t pixmap, qt6cr_rectf_t source_rect) {
  auto *painter = as_qpainter(handle);
  auto *source = as_qpixmap(pixmap);

  if (painter != nullptr && source != nullptr) {
    painter->drawPixmap(from_rectf(target), *source, from_rectf(source_rect));
  }
}

void qt6cr_qpainter_draw_point(qt6cr_handle_t handle, qt6cr_pointf_t point) {
  auto *painter = as_qpainter(handle);

  if (painter != nullptr) {
    painter->drawPoint(QPointF(point.x, point.y));
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

void qt6cr_input_dialog_set_combo_box_items(qt6cr_handle_t handle, const char *const *items, int count) {
  auto *input_dialog = as_input_dialog(handle);

  if (input_dialog == nullptr) {
    return;
  }

  QStringList values;
  for (int index = 0; index < count; ++index) {
    values << QString::fromUtf8(items[index] == nullptr ? "" : items[index]);
  }

  input_dialog->setComboBoxItems(values);
}

int qt6cr_input_dialog_combo_box_item_count(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? 0 : input_dialog->comboBoxItems().size();
}

char *qt6cr_input_dialog_combo_box_item_text(qt6cr_handle_t handle, int index) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog == nullptr ? duplicate_string("") : duplicate_string(input_dialog->comboBoxItems().value(index));
}

void qt6cr_input_dialog_set_combo_box_editable(qt6cr_handle_t handle, bool editable) {
  auto *input_dialog = as_input_dialog(handle);

  if (input_dialog != nullptr) {
    input_dialog->setComboBoxEditable(editable);
  }
}

bool qt6cr_input_dialog_combo_box_editable(qt6cr_handle_t handle) {
  auto *input_dialog = as_input_dialog(handle);
  return input_dialog != nullptr ? input_dialog->isComboBoxEditable() : false;
}

char *qt6cr_input_dialog_get_item(qt6cr_handle_t parent, const char *title, const char *label, const char *const *items, int count, int current, bool editable) {
  QStringList values;
  for (int index = 0; index < count; ++index) {
    values << QString::fromUtf8(items[index] == nullptr ? "" : items[index]);
  }

  bool ok = false;
  const auto result = QInputDialog::getItem(
      as_widget(parent),
      QString::fromUtf8(title == nullptr ? "" : title),
      QString::fromUtf8(label == nullptr ? "" : label),
      values,
      current,
      editable,
      &ok);
  return ok ? duplicate_string(result) : nullptr;
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

qt6cr_handle_t qt6cr_dock_widget_toggle_view_action(qt6cr_handle_t handle) {
  auto *dock = as_dock_widget(handle);
  return dock == nullptr ? nullptr : static_cast<qt6cr_handle_t>(dock->toggleViewAction());
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

void qt6cr_action_set_enabled(qt6cr_handle_t handle, bool value) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setEnabled(value);
  }
}

bool qt6cr_action_is_enabled(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action != nullptr && action->isEnabled();
}

void qt6cr_action_set_tool_tip(qt6cr_handle_t handle, const char *tool_tip) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setToolTip(QString::fromUtf8(tool_tip == nullptr ? "" : tool_tip));
  }
}

char *qt6cr_action_tool_tip(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action == nullptr ? duplicate_string("") : duplicate_string(action->toolTip());
}

void qt6cr_action_set_status_tip(qt6cr_handle_t handle, const char *status_tip) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setStatusTip(QString::fromUtf8(status_tip == nullptr ? "" : status_tip));
  }
}

char *qt6cr_action_status_tip(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action == nullptr ? duplicate_string("") : duplicate_string(action->statusTip());
}

void qt6cr_action_set_visible(qt6cr_handle_t handle, bool value) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setVisible(value);
  }
}

bool qt6cr_action_is_visible(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action != nullptr && action->isVisible();
}

void qt6cr_action_set_separator(qt6cr_handle_t handle, bool value) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setSeparator(value);
  }
}

bool qt6cr_action_is_separator(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action != nullptr && action->isSeparator();
}

void qt6cr_action_set_data(qt6cr_handle_t handle, qt6cr_variant_value_t value) {
  auto *action = as_action(handle);

  if (action != nullptr) {
    action->setData(from_variant_value(value));
  }
}

qt6cr_variant_value_t qt6cr_action_data(qt6cr_handle_t handle) {
  auto *action = as_action(handle);
  return action == nullptr ? to_variant_value(QVariant()) : to_variant_value(action->data());
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

void qt6cr_action_on_toggled(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *action = as_action(handle);

  if (action == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(action, &QAction::toggled, action, [callback, userdata](bool value) {
    callback(userdata, value);
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

qt6cr_handle_t qt6cr_undo_command_create(const char *text) {
  return new CrystalUndoCommand(QString::fromUtf8(text == nullptr ? "" : text));
}

void qt6cr_undo_command_destroy(qt6cr_handle_t handle) {
  delete as_undo_command(handle);
}

void qt6cr_undo_command_set_callbacks(qt6cr_handle_t handle, qt6cr_void_callback_t redo_callback, void *redo_userdata, qt6cr_void_callback_t undo_callback, void *undo_userdata, qt6cr_void_callback_t destroy_callback, void *destroy_userdata) {
  auto *command = as_undo_command(handle);

  if (command == nullptr) {
    return;
  }

  command->redo_callback = redo_callback;
  command->redo_userdata = redo_userdata;
  command->undo_callback = undo_callback;
  command->undo_userdata = undo_userdata;
  command->destroy_callback = destroy_callback;
  command->destroy_userdata = destroy_userdata;
}

char *qt6cr_undo_command_text(qt6cr_handle_t handle) {
  auto *command = as_undo_command(handle);
  return command == nullptr ? duplicate_string("") : duplicate_string(command->text());
}

void qt6cr_undo_command_set_text(qt6cr_handle_t handle, const char *text) {
  auto *command = as_undo_command(handle);

  if (command != nullptr) {
    command->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

qt6cr_handle_t qt6cr_undo_stack_create(qt6cr_handle_t parent) {
  return new QUndoStack(as_object(parent));
}

void qt6cr_undo_stack_push(qt6cr_handle_t handle, qt6cr_handle_t command) {
  auto *stack = as_undo_stack(handle);
  auto *undo_command = as_undo_command(command);

  if (stack != nullptr && undo_command != nullptr) {
    stack->push(undo_command);
  }
}

void qt6cr_undo_stack_clear(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);

  if (stack != nullptr) {
    stack->clear();
  }
}

void qt6cr_undo_stack_undo(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);

  if (stack != nullptr) {
    stack->undo();
  }
}

void qt6cr_undo_stack_redo(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);

  if (stack != nullptr) {
    stack->redo();
  }
}

bool qt6cr_undo_stack_can_undo(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack != nullptr && stack->canUndo();
}

bool qt6cr_undo_stack_can_redo(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack != nullptr && stack->canRedo();
}

bool qt6cr_undo_stack_is_clean(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack != nullptr && stack->isClean();
}

void qt6cr_undo_stack_set_clean(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);

  if (stack != nullptr) {
    stack->setClean();
  }
}

void qt6cr_undo_stack_reset_clean(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);

  if (stack != nullptr) {
    stack->resetClean();
  }
}

int qt6cr_undo_stack_count(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack == nullptr ? 0 : stack->count();
}

int qt6cr_undo_stack_index(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack == nullptr ? 0 : stack->index();
}

int qt6cr_undo_stack_clean_index(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack == nullptr ? -1 : stack->cleanIndex();
}

int qt6cr_undo_stack_undo_limit(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack == nullptr ? 0 : stack->undoLimit();
}

void qt6cr_undo_stack_set_undo_limit(qt6cr_handle_t handle, int value) {
  auto *stack = as_undo_stack(handle);

  if (stack != nullptr) {
    stack->setUndoLimit(value);
  }
}

bool qt6cr_undo_stack_is_active(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack != nullptr && stack->isActive();
}

void qt6cr_undo_stack_set_active(qt6cr_handle_t handle, bool value) {
  auto *stack = as_undo_stack(handle);

  if (stack != nullptr) {
    stack->setActive(value);
  }
}

char *qt6cr_undo_stack_undo_text(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack == nullptr ? duplicate_string("") : duplicate_string(stack->undoText());
}

char *qt6cr_undo_stack_redo_text(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);
  return stack == nullptr ? duplicate_string("") : duplicate_string(stack->redoText());
}

void qt6cr_undo_stack_begin_macro(qt6cr_handle_t handle, const char *text) {
  auto *stack = as_undo_stack(handle);

  if (stack != nullptr) {
    stack->beginMacro(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

void qt6cr_undo_stack_end_macro(qt6cr_handle_t handle) {
  auto *stack = as_undo_stack(handle);

  if (stack != nullptr) {
    stack->endMacro();
  }
}

qt6cr_handle_t qt6cr_undo_stack_create_undo_action(qt6cr_handle_t handle, qt6cr_handle_t parent, const char *prefix) {
  auto *stack = as_undo_stack(handle);
  return stack == nullptr ? nullptr : stack->createUndoAction(as_object(parent), QString::fromUtf8(prefix == nullptr ? "" : prefix));
}

qt6cr_handle_t qt6cr_undo_stack_create_redo_action(qt6cr_handle_t handle, qt6cr_handle_t parent, const char *prefix) {
  auto *stack = as_undo_stack(handle);
  return stack == nullptr ? nullptr : stack->createRedoAction(as_object(parent), QString::fromUtf8(prefix == nullptr ? "" : prefix));
}

void qt6cr_undo_stack_on_can_undo_changed(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *stack = as_undo_stack(handle);

  if (stack == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(stack, &QUndoStack::canUndoChanged, stack, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

void qt6cr_undo_stack_on_can_redo_changed(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *stack = as_undo_stack(handle);

  if (stack == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(stack, &QUndoStack::canRedoChanged, stack, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

void qt6cr_undo_stack_on_clean_changed(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *stack = as_undo_stack(handle);

  if (stack == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(stack, &QUndoStack::cleanChanged, stack, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

void qt6cr_undo_stack_on_index_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *stack = as_undo_stack(handle);

  if (stack == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(stack, &QUndoStack::indexChanged, stack, [callback, userdata](int value) {
    callback(userdata, value);
  });
}

void qt6cr_undo_stack_on_undo_text_changed(qt6cr_handle_t handle, qt6cr_string_callback_t callback, void *userdata) {
  auto *stack = as_undo_stack(handle);

  if (stack == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(stack, &QUndoStack::undoTextChanged, stack, [callback, userdata](const QString &value) {
    const auto bytes = value.toUtf8();
    callback(userdata, bytes.constData());
  });
}

void qt6cr_undo_stack_on_redo_text_changed(qt6cr_handle_t handle, qt6cr_string_callback_t callback, void *userdata) {
  auto *stack = as_undo_stack(handle);

  if (stack == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(stack, &QUndoStack::redoTextChanged, stack, [callback, userdata](const QString &value) {
    const auto bytes = value.toUtf8();
    callback(userdata, bytes.constData());
  });
}

qt6cr_handle_t qt6cr_undo_group_create(qt6cr_handle_t parent) {
  return new QUndoGroup(as_object(parent));
}

void qt6cr_undo_group_add_stack(qt6cr_handle_t handle, qt6cr_handle_t stack_handle) {
  auto *group = as_undo_group(handle);
  auto *stack = as_undo_stack(stack_handle);

  if (group != nullptr && stack != nullptr) {
    group->addStack(stack);
  }
}

void qt6cr_undo_group_remove_stack(qt6cr_handle_t handle, qt6cr_handle_t stack_handle) {
  auto *group = as_undo_group(handle);
  auto *stack = as_undo_stack(stack_handle);

  if (group != nullptr && stack != nullptr) {
    group->removeStack(stack);
  }
}

qt6cr_handle_t qt6cr_undo_group_active_stack(qt6cr_handle_t handle) {
  auto *group = as_undo_group(handle);
  return group == nullptr ? nullptr : group->activeStack();
}

void qt6cr_undo_group_set_active_stack(qt6cr_handle_t handle, qt6cr_handle_t stack_handle) {
  auto *group = as_undo_group(handle);

  if (group != nullptr) {
    group->setActiveStack(as_undo_stack(stack_handle));
  }
}

void qt6cr_undo_group_undo(qt6cr_handle_t handle) {
  auto *group = as_undo_group(handle);

  if (group != nullptr) {
    group->undo();
  }
}

void qt6cr_undo_group_redo(qt6cr_handle_t handle) {
  auto *group = as_undo_group(handle);

  if (group != nullptr) {
    group->redo();
  }
}

bool qt6cr_undo_group_can_undo(qt6cr_handle_t handle) {
  auto *group = as_undo_group(handle);
  return group != nullptr && group->canUndo();
}

bool qt6cr_undo_group_can_redo(qt6cr_handle_t handle) {
  auto *group = as_undo_group(handle);
  return group != nullptr && group->canRedo();
}

bool qt6cr_undo_group_is_clean(qt6cr_handle_t handle) {
  auto *group = as_undo_group(handle);
  return group != nullptr && group->isClean();
}

char *qt6cr_undo_group_undo_text(qt6cr_handle_t handle) {
  auto *group = as_undo_group(handle);
  return group == nullptr ? duplicate_string("") : duplicate_string(group->undoText());
}

char *qt6cr_undo_group_redo_text(qt6cr_handle_t handle) {
  auto *group = as_undo_group(handle);
  return group == nullptr ? duplicate_string("") : duplicate_string(group->redoText());
}

qt6cr_handle_t qt6cr_undo_group_create_undo_action(qt6cr_handle_t handle, qt6cr_handle_t parent, const char *prefix) {
  auto *group = as_undo_group(handle);
  return group == nullptr ? nullptr : group->createUndoAction(as_object(parent), QString::fromUtf8(prefix == nullptr ? "" : prefix));
}

qt6cr_handle_t qt6cr_undo_group_create_redo_action(qt6cr_handle_t handle, qt6cr_handle_t parent, const char *prefix) {
  auto *group = as_undo_group(handle);
  return group == nullptr ? nullptr : group->createRedoAction(as_object(parent), QString::fromUtf8(prefix == nullptr ? "" : prefix));
}

void qt6cr_undo_group_on_active_stack_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *group = as_undo_group(handle);

  if (group == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(group, &QUndoGroup::activeStackChanged, group, [callback, userdata](QUndoStack *stack) {
    callback(userdata, stack);
  });
}

void qt6cr_undo_group_on_can_undo_changed(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *group = as_undo_group(handle);

  if (group == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(group, &QUndoGroup::canUndoChanged, group, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

void qt6cr_undo_group_on_can_redo_changed(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *group = as_undo_group(handle);

  if (group == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(group, &QUndoGroup::canRedoChanged, group, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

void qt6cr_undo_group_on_clean_changed(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *group = as_undo_group(handle);

  if (group == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(group, &QUndoGroup::cleanChanged, group, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

void qt6cr_undo_group_on_index_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *group = as_undo_group(handle);

  if (group == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(group, &QUndoGroup::indexChanged, group, [callback, userdata](int value) {
    callback(userdata, value);
  });
}

void qt6cr_undo_group_on_undo_text_changed(qt6cr_handle_t handle, qt6cr_string_callback_t callback, void *userdata) {
  auto *group = as_undo_group(handle);

  if (group == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(group, &QUndoGroup::undoTextChanged, group, [callback, userdata](const QString &value) {
    const auto bytes = value.toUtf8();
    callback(userdata, bytes.constData());
  });
}

void qt6cr_undo_group_on_redo_text_changed(qt6cr_handle_t handle, qt6cr_string_callback_t callback, void *userdata) {
  auto *group = as_undo_group(handle);

  if (group == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(group, &QUndoGroup::redoTextChanged, group, [callback, userdata](const QString &value) {
    const auto bytes = value.toUtf8();
    callback(userdata, bytes.constData());
  });
}

qt6cr_handle_t qt6cr_menu_bar_add_menu(qt6cr_handle_t handle, const char *title) {
  auto *menu_bar = as_menu_bar(handle);
  return menu_bar == nullptr ? nullptr : menu_bar->addMenu(QString::fromUtf8(title == nullptr ? "" : title));
}

void qt6cr_menu_bar_clear(qt6cr_handle_t handle) {
  auto *menu_bar = as_menu_bar(handle);

  if (menu_bar != nullptr) {
    menu_bar->clear();
  }
}

qt6cr_handle_t qt6cr_menu_add_menu(qt6cr_handle_t handle, const char *title) {
  auto *menu = as_menu(handle);
  return menu == nullptr ? nullptr : menu->addMenu(QString::fromUtf8(title == nullptr ? "" : title));
}

qt6cr_handle_t qt6cr_menu_add_text_action(qt6cr_handle_t handle, const char *text) {
  auto *menu = as_menu(handle);
  return menu == nullptr ? nullptr : menu->addAction(QString::fromUtf8(text == nullptr ? "" : text));
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

void qt6cr_menu_clear(qt6cr_handle_t handle) {
  auto *menu = as_menu(handle);

  if (menu != nullptr) {
    menu->clear();
  }
}

qt6cr_handle_t qt6cr_menu_menu_action(qt6cr_handle_t handle) {
  auto *menu = as_menu(handle);
  return menu == nullptr ? nullptr : static_cast<qt6cr_handle_t>(menu->menuAction());
}

qt6cr_handle_t qt6cr_tool_bar_create(qt6cr_handle_t parent, const char *title) {
  return new QToolBar(QString::fromUtf8(title == nullptr ? "" : title), as_widget(parent));
}

qt6cr_handle_t qt6cr_tool_bar_add_text_action(qt6cr_handle_t handle, const char *text) {
  auto *tool_bar = as_tool_bar(handle);
  return tool_bar == nullptr ? nullptr : tool_bar->addAction(QString::fromUtf8(text == nullptr ? "" : text));
}

void qt6cr_tool_bar_add_action(qt6cr_handle_t handle, qt6cr_handle_t action) {
  auto *tool_bar = as_tool_bar(handle);
  auto *tool_bar_action = as_action(action);

  if (tool_bar != nullptr && tool_bar_action != nullptr) {
    tool_bar->addAction(tool_bar_action);
  }
}

void qt6cr_tool_bar_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *tool_bar = as_tool_bar(handle);
  auto *tool_widget = as_widget(widget);

  if (tool_bar != nullptr && tool_widget != nullptr) {
    tool_bar->addWidget(tool_widget);
  }
}

void qt6cr_tool_bar_add_separator(qt6cr_handle_t handle) {
  auto *tool_bar = as_tool_bar(handle);

  if (tool_bar != nullptr) {
    tool_bar->addSeparator();
  }
}

void qt6cr_tool_bar_clear(qt6cr_handle_t handle) {
  auto *tool_bar = as_tool_bar(handle);

  if (tool_bar != nullptr) {
    tool_bar->clear();
  }
}

void qt6cr_tool_bar_set_movable(qt6cr_handle_t handle, bool value) {
  auto *tool_bar = as_tool_bar(handle);

  if (tool_bar != nullptr) {
    tool_bar->setMovable(value);
  }
}

bool qt6cr_tool_bar_is_movable(qt6cr_handle_t handle) {
  auto *tool_bar = as_tool_bar(handle);
  return tool_bar != nullptr && tool_bar->isMovable();
}

qt6cr_handle_t qt6cr_tool_bar_toggle_view_action(qt6cr_handle_t handle) {
  auto *tool_bar = as_tool_bar(handle);
  return tool_bar == nullptr ? nullptr : static_cast<qt6cr_handle_t>(tool_bar->toggleViewAction());
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

void qt6cr_event_widget_on_mouse_double_click(qt6cr_handle_t handle, qt6cr_mouse_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->mouse_double_click_callback = callback;
    widget->mouse_double_click_userdata = userdata;
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

void qt6cr_event_widget_on_key_release(qt6cr_handle_t handle, qt6cr_key_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->key_release_callback = callback;
    widget->key_release_userdata = userdata;
  }
}

void qt6cr_event_widget_on_enter(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->enter_callback = callback;
    widget->enter_userdata = userdata;
  }
}

void qt6cr_event_widget_on_leave(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->leave_callback = callback;
    widget->leave_userdata = userdata;
  }
}

void qt6cr_event_widget_on_focus_in(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->focus_in_callback = callback;
    widget->focus_in_userdata = userdata;
  }
}

void qt6cr_event_widget_on_focus_out(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->focus_out_callback = callback;
    widget->focus_out_userdata = userdata;
  }
}

void qt6cr_event_widget_on_drag_enter(qt6cr_handle_t handle, qt6cr_drop_event_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->drag_enter_callback = callback;
    widget->drag_enter_userdata = userdata;
  }
}

void qt6cr_event_widget_on_drag_move(qt6cr_handle_t handle, qt6cr_drop_event_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->drag_move_callback = callback;
    widget->drag_move_userdata = userdata;
  }
}

void qt6cr_event_widget_on_drop(qt6cr_handle_t handle, qt6cr_drop_event_callback_t callback, void *userdata) {
  auto *widget = as_event_widget(handle);

  if (widget != nullptr) {
    widget->drop_callback = callback;
    widget->drop_userdata = userdata;
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

void qt6cr_event_widget_send_mouse_double_click(qt6cr_handle_t handle, qt6cr_pointf_t position, int button, int buttons, int modifiers) {
  send_mouse_event(as_event_widget(handle), QEvent::MouseButtonDblClick, position, button, buttons, modifiers);
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

void qt6cr_event_widget_send_key_release(qt6cr_handle_t handle, int key, int modifiers, bool auto_repeat, int count) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  QKeyEvent event(QEvent::KeyRelease, key, Qt::KeyboardModifiers(modifiers), QString(), auto_repeat, static_cast<quint16>(count));
  QApplication::sendEvent(widget, &event);
}

void qt6cr_event_widget_send_enter(qt6cr_handle_t handle, qt6cr_pointf_t position) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  const QPointF pos(position.x, position.y);
  QEnterEvent event(pos, pos, pos);
  QApplication::sendEvent(widget, &event);
}

void qt6cr_event_widget_send_leave(qt6cr_handle_t handle) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  QEvent event(QEvent::Leave);
  QApplication::sendEvent(widget, &event);
}

void qt6cr_event_widget_send_focus_in(qt6cr_handle_t handle) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  QFocusEvent event(QEvent::FocusIn);
  QApplication::sendEvent(widget, &event);
}

void qt6cr_event_widget_send_focus_out(qt6cr_handle_t handle) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  QFocusEvent event(QEvent::FocusOut);
  QApplication::sendEvent(widget, &event);
}

void qt6cr_event_widget_send_drag_enter_text(qt6cr_handle_t handle, qt6cr_pointf_t position, const char *text, int buttons, int modifiers) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  QMimeData mime_data;
  mime_data.setText(QString::fromUtf8(text == nullptr ? "" : text));
  QDragEnterEvent event(QPoint(static_cast<int>(position.x), static_cast<int>(position.y)), Qt::CopyAction, &mime_data, Qt::MouseButtons(buttons), Qt::KeyboardModifiers(modifiers));
  QApplication::sendEvent(widget, &event);
}

void qt6cr_event_widget_send_drag_move_text(qt6cr_handle_t handle, qt6cr_pointf_t position, const char *text, int buttons, int modifiers) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  QMimeData mime_data;
  mime_data.setText(QString::fromUtf8(text == nullptr ? "" : text));
  QDragMoveEvent event(QPoint(static_cast<int>(position.x), static_cast<int>(position.y)), Qt::CopyAction, &mime_data, Qt::MouseButtons(buttons), Qt::KeyboardModifiers(modifiers));
  QApplication::sendEvent(widget, &event);
}

void qt6cr_event_widget_send_drop_text(qt6cr_handle_t handle, qt6cr_pointf_t position, const char *text, int buttons, int modifiers) {
  auto *widget = as_event_widget(handle);

  if (widget == nullptr) {
    return;
  }

  QMimeData mime_data;
  mime_data.setText(QString::fromUtf8(text == nullptr ? "" : text));
  QDropEvent event(QPointF(position.x, position.y), Qt::CopyAction, &mime_data, Qt::MouseButtons(buttons), Qt::KeyboardModifiers(modifiers));
  QApplication::sendEvent(widget, &event);
}

qt6cr_pointf_t qt6cr_drop_event_position(qt6cr_handle_t handle) {
  auto *event = as_drop_event(handle);
  return event == nullptr ? qt6cr_pointf_t{0.0, 0.0} : to_pointf(event->position());
}

int qt6cr_drop_event_buttons(qt6cr_handle_t handle) {
  auto *event = as_drop_event(handle);
  return event == nullptr ? 0 : static_cast<int>(event->buttons());
}

int qt6cr_drop_event_modifiers(qt6cr_handle_t handle) {
  auto *event = as_drop_event(handle);
  return event == nullptr ? 0 : static_cast<int>(event->modifiers());
}

qt6cr_handle_t qt6cr_drop_event_mime_data(qt6cr_handle_t handle) {
  auto *event = as_drop_event(handle);
  return event == nullptr ? nullptr : const_cast<QMimeData *>(event->mimeData());
}

void qt6cr_drop_event_accept(qt6cr_handle_t handle) {
  auto *event = as_drop_event(handle);

  if (event != nullptr) {
    event->accept();
  }
}

void qt6cr_drop_event_accept_proposed_action(qt6cr_handle_t handle) {
  auto *event = as_drop_event(handle);

  if (event != nullptr) {
    event->acceptProposedAction();
  }
}

void qt6cr_drop_event_ignore(qt6cr_handle_t handle) {
  auto *event = as_drop_event(handle);

  if (event != nullptr) {
    event->ignore();
  }
}

bool qt6cr_drop_event_is_accepted(qt6cr_handle_t handle) {
  auto *event = as_drop_event(handle);
  return event != nullptr && event->isAccepted();
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

int qt6cr_label_alignment(qt6cr_handle_t handle) {
  auto *label = as_label(handle);
  return label == nullptr ? static_cast<int>(Qt::AlignCenter) : static_cast<int>(label->alignment());
}

void qt6cr_label_set_alignment(qt6cr_handle_t handle, int value) {
  auto *label = as_label(handle);

  if (label != nullptr) {
    label->setAlignment(static_cast<Qt::Alignment>(value));
  }
}

bool qt6cr_label_word_wrap(qt6cr_handle_t handle) {
  auto *label = as_label(handle);
  return label != nullptr && label->wordWrap();
}

void qt6cr_label_set_word_wrap(qt6cr_handle_t handle, bool value) {
  auto *label = as_label(handle);

  if (label != nullptr) {
    label->setWordWrap(value);
  }
}

void qt6cr_label_set_pixmap(qt6cr_handle_t handle, qt6cr_handle_t pixmap) {
  auto *label = as_label(handle);

  if (label == nullptr) {
    return;
  }

  if (pixmap == nullptr) {
    const QString text = label->text();
    label->setPixmap(QPixmap());
    label->setText(text);
    return;
  }

  auto *source = as_qpixmap(pixmap);
  if (source != nullptr) {
    label->setPixmap(*source);
  }
}

bool qt6cr_label_has_scaled_contents(qt6cr_handle_t handle) {
  auto *label = as_label(handle);
  return label != nullptr && label->hasScaledContents();
}

void qt6cr_label_set_scaled_contents(qt6cr_handle_t handle, bool value) {
  auto *label = as_label(handle);

  if (label != nullptr) {
    label->setScaledContents(value);
  }
}

char *qt6cr_abstract_button_text(qt6cr_handle_t handle) {
  auto *button = as_abstract_button(handle);
  return button == nullptr ? duplicate_string("") : duplicate_string(button->text());
}

void qt6cr_abstract_button_set_text(qt6cr_handle_t handle, const char *text) {
  auto *button = as_abstract_button(handle);

  if (button != nullptr) {
    button->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

bool qt6cr_abstract_button_is_checkable(qt6cr_handle_t handle) {
  auto *button = as_abstract_button(handle);
  return button != nullptr && button->isCheckable();
}

void qt6cr_abstract_button_set_checkable(qt6cr_handle_t handle, bool value) {
  auto *button = as_abstract_button(handle);

  if (button != nullptr) {
    button->setCheckable(value);
  }
}

bool qt6cr_abstract_button_is_checked(qt6cr_handle_t handle) {
  auto *button = as_abstract_button(handle);
  return button != nullptr && button->isChecked();
}

void qt6cr_abstract_button_set_checked(qt6cr_handle_t handle, bool value) {
  auto *button = as_abstract_button(handle);

  if (button != nullptr) {
    button->setChecked(value);
  }
}

void qt6cr_abstract_button_on_clicked(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *button = as_abstract_button(handle);

  if (button == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(button, &QAbstractButton::clicked, button, [callback, userdata](bool) {
    callback(userdata);
  });
}

void qt6cr_abstract_button_on_toggled(qt6cr_handle_t handle, qt6cr_bool_callback_t callback, void *userdata) {
  auto *button = as_abstract_button(handle);

  if (button == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(button, &QAbstractButton::toggled, button, [callback, userdata](bool value) {
    callback(userdata, value);
  });
}

void qt6cr_abstract_button_click(qt6cr_handle_t handle) {
  auto *button = as_abstract_button(handle);

  if (button != nullptr) {
    button->click();
  }
}

qt6cr_handle_t qt6cr_abstract_button_icon(qt6cr_handle_t handle) {
  auto *button = as_abstract_button(handle);
  return button == nullptr ? new QIcon() : new QIcon(button->icon());
}

void qt6cr_abstract_button_set_icon(qt6cr_handle_t handle, qt6cr_handle_t icon) {
  auto *button = as_abstract_button(handle);
  auto *button_icon = as_qicon(icon);

  if (button != nullptr && button_icon != nullptr) {
    button->setIcon(*button_icon);
  }
}

qt6cr_size_t qt6cr_abstract_button_icon_size(qt6cr_handle_t handle) {
  auto *button = as_abstract_button(handle);
  return button == nullptr ? qt6cr_size_t{0, 0} : to_size(button->iconSize());
}

void qt6cr_abstract_button_set_icon_size(qt6cr_handle_t handle, qt6cr_size_t size) {
  auto *button = as_abstract_button(handle);

  if (button != nullptr) {
    button->setIconSize(QSize(size.width, size.height));
  }
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

char *qt6cr_line_edit_placeholder_text(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? duplicate_string("") : duplicate_string(line_edit->placeholderText());
}

void qt6cr_line_edit_set_placeholder_text(qt6cr_handle_t handle, const char *text) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->setPlaceholderText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

int qt6cr_line_edit_echo_mode(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? static_cast<int>(QLineEdit::Normal) : static_cast<int>(line_edit->echoMode());
}

void qt6cr_line_edit_set_echo_mode(qt6cr_handle_t handle, int value) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->setEchoMode(static_cast<QLineEdit::EchoMode>(value));
  }
}

char *qt6cr_line_edit_input_mask(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? duplicate_string("") : duplicate_string(line_edit->inputMask());
}

void qt6cr_line_edit_set_input_mask(qt6cr_handle_t handle, const char *value) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->setInputMask(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

int qt6cr_line_edit_alignment(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? static_cast<int>(Qt::AlignLeft | Qt::AlignVCenter) : static_cast<int>(line_edit->alignment());
}

void qt6cr_line_edit_set_alignment(qt6cr_handle_t handle, int value) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->setAlignment(static_cast<Qt::Alignment>(value));
  }
}

int qt6cr_line_edit_cursor_position(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? 0 : line_edit->cursorPosition();
}

void qt6cr_line_edit_set_cursor_position(qt6cr_handle_t handle, int value) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->setCursorPosition(value);
  }
}

char *qt6cr_line_edit_selected_text(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? duplicate_string("") : duplicate_string(line_edit->selectedText());
}

bool qt6cr_line_edit_has_selected_text(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit != nullptr && line_edit->hasSelectedText();
}

int qt6cr_line_edit_selection_start(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? -1 : line_edit->selectionStart();
}

void qt6cr_line_edit_select_all(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->selectAll();
  }
}

void qt6cr_line_edit_clear_selection(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->deselect();
  }
}

void qt6cr_line_edit_set_selection(qt6cr_handle_t handle, int start, int length) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->setSelection(start, length);
  }
}

void qt6cr_line_edit_clear(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit != nullptr) {
    line_edit->clear();
  }
}

qt6cr_handle_t qt6cr_line_edit_validator(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? nullptr : const_cast<QValidator *>(line_edit->validator());
}

void qt6cr_line_edit_set_validator(qt6cr_handle_t handle, qt6cr_handle_t validator) {
  auto *line_edit = as_line_edit(handle);
  auto *value = as_validator(validator);

  if (line_edit != nullptr) {
    line_edit->setValidator(value);
  }
}

qt6cr_handle_t qt6cr_line_edit_completer(qt6cr_handle_t handle) {
  auto *line_edit = as_line_edit(handle);
  return line_edit == nullptr ? nullptr : line_edit->completer();
}

void qt6cr_line_edit_set_completer(qt6cr_handle_t handle, qt6cr_handle_t completer) {
  auto *line_edit = as_line_edit(handle);
  auto *value = as_completer(completer);

  if (line_edit != nullptr) {
    line_edit->setCompleter(value);
  }
}

void qt6cr_line_edit_on_text_changed(qt6cr_handle_t handle, qt6cr_string_callback_t callback, void *userdata) {
  auto *line_edit = as_line_edit(handle);

  if (line_edit == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(line_edit, &QLineEdit::textChanged, line_edit, [callback, userdata](const QString &text) {
    char *value = duplicate_string(text);
    callback(userdata, value);
    delete[] value;
  });
}

int qt6cr_validator_validate(qt6cr_handle_t handle, const char *input) {
  auto *validator = as_validator(handle);

  if (validator == nullptr) {
    return static_cast<int>(QValidator::Invalid);
  }

  QString text = QString::fromUtf8(input == nullptr ? "" : input);
  int position = 0;
  return static_cast<int>(validator->validate(text, position));
}

qt6cr_handle_t qt6cr_int_validator_create(qt6cr_handle_t parent, int bottom, int top) {
  return new QIntValidator(bottom, top, as_object(parent));
}

int qt6cr_int_validator_bottom(qt6cr_handle_t handle) {
  auto *validator = as_int_validator(handle);
  return validator == nullptr ? 0 : validator->bottom();
}

void qt6cr_int_validator_set_bottom(qt6cr_handle_t handle, int value) {
  auto *validator = as_int_validator(handle);

  if (validator != nullptr) {
    validator->setBottom(value);
  }
}

int qt6cr_int_validator_top(qt6cr_handle_t handle) {
  auto *validator = as_int_validator(handle);
  return validator == nullptr ? 0 : validator->top();
}

void qt6cr_int_validator_set_top(qt6cr_handle_t handle, int value) {
  auto *validator = as_int_validator(handle);

  if (validator != nullptr) {
    validator->setTop(value);
  }
}

void qt6cr_int_validator_set_range(qt6cr_handle_t handle, int bottom, int top) {
  auto *validator = as_int_validator(handle);

  if (validator != nullptr) {
    validator->setRange(bottom, top);
  }
}

qt6cr_handle_t qt6cr_double_validator_create(qt6cr_handle_t parent, double bottom, double top, int decimals) {
  return new QDoubleValidator(bottom, top, decimals, as_object(parent));
}

double qt6cr_double_validator_bottom(qt6cr_handle_t handle) {
  auto *validator = as_double_validator(handle);
  return validator == nullptr ? 0.0 : validator->bottom();
}

void qt6cr_double_validator_set_bottom(qt6cr_handle_t handle, double value) {
  auto *validator = as_double_validator(handle);

  if (validator != nullptr) {
    validator->setBottom(value);
  }
}

double qt6cr_double_validator_top(qt6cr_handle_t handle) {
  auto *validator = as_double_validator(handle);
  return validator == nullptr ? 0.0 : validator->top();
}

void qt6cr_double_validator_set_top(qt6cr_handle_t handle, double value) {
  auto *validator = as_double_validator(handle);

  if (validator != nullptr) {
    validator->setTop(value);
  }
}

int qt6cr_double_validator_decimals(qt6cr_handle_t handle) {
  auto *validator = as_double_validator(handle);
  return validator == nullptr ? 0 : validator->decimals();
}

void qt6cr_double_validator_set_decimals(qt6cr_handle_t handle, int value) {
  auto *validator = as_double_validator(handle);

  if (validator != nullptr) {
    validator->setDecimals(value);
  }
}

void qt6cr_double_validator_set_range(qt6cr_handle_t handle, double bottom, double top, int decimals) {
  auto *validator = as_double_validator(handle);

  if (validator != nullptr) {
    validator->setRange(bottom, top, decimals);
  }
}

qt6cr_handle_t qt6cr_regex_validator_create(qt6cr_handle_t parent, const char *pattern) {
  return new QRegularExpressionValidator(QRegularExpression(QString::fromUtf8(pattern == nullptr ? "" : pattern)), as_object(parent));
}

char *qt6cr_regex_validator_pattern(qt6cr_handle_t handle) {
  auto *validator = as_regex_validator(handle);
  return validator == nullptr ? duplicate_string("") : duplicate_string(validator->regularExpression().pattern());
}

void qt6cr_regex_validator_set_pattern(qt6cr_handle_t handle, const char *pattern) {
  auto *validator = as_regex_validator(handle);

  if (validator != nullptr) {
    validator->setRegularExpression(QRegularExpression(QString::fromUtf8(pattern == nullptr ? "" : pattern)));
  }
}

qt6cr_handle_t qt6cr_completer_create(qt6cr_handle_t parent) {
  return new QCompleter(as_object(parent));
}

void qt6cr_completer_set_items(qt6cr_handle_t handle, const char *const *items, int count) {
  auto *completer = as_completer(handle);

  if (completer == nullptr) {
    return;
  }

  QStringList values;
  for (int index = 0; index < count; ++index) {
    values << QString::fromUtf8(items[index] == nullptr ? "" : items[index]);
  }

  completer->setModel(new QStringListModel(values, completer));
}

char *qt6cr_completer_completion_prefix(qt6cr_handle_t handle) {
  auto *completer = as_completer(handle);
  return completer == nullptr ? duplicate_string("") : duplicate_string(completer->completionPrefix());
}

void qt6cr_completer_set_completion_prefix(qt6cr_handle_t handle, const char *value) {
  auto *completer = as_completer(handle);

  if (completer != nullptr) {
    completer->setCompletionPrefix(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

char *qt6cr_completer_current_completion(qt6cr_handle_t handle) {
  auto *completer = as_completer(handle);
  return completer == nullptr ? duplicate_string("") : duplicate_string(completer->currentCompletion());
}

int qt6cr_completer_case_sensitivity(qt6cr_handle_t handle) {
  auto *completer = as_completer(handle);
  return completer == nullptr ? static_cast<int>(Qt::CaseSensitive) : static_cast<int>(completer->caseSensitivity());
}

void qt6cr_completer_set_case_sensitivity(qt6cr_handle_t handle, int value) {
  auto *completer = as_completer(handle);

  if (completer != nullptr) {
    completer->setCaseSensitivity(static_cast<Qt::CaseSensitivity>(value));
  }
}

int qt6cr_completer_completion_mode(qt6cr_handle_t handle) {
  auto *completer = as_completer(handle);
  return completer == nullptr ? static_cast<int>(QCompleter::PopupCompletion) : static_cast<int>(completer->completionMode());
}

void qt6cr_completer_set_completion_mode(qt6cr_handle_t handle, int value) {
  auto *completer = as_completer(handle);

  if (completer != nullptr) {
    completer->setCompletionMode(static_cast<QCompleter::CompletionMode>(value));
  }
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

qt6cr_handle_t qt6cr_tool_button_create(qt6cr_handle_t parent) {
  return new QToolButton(as_widget(parent));
}

int qt6cr_tool_button_style(qt6cr_handle_t handle) {
  auto *tool_button = as_tool_button(handle);
  return tool_button == nullptr ? static_cast<int>(Qt::ToolButtonIconOnly) : static_cast<int>(tool_button->toolButtonStyle());
}

void qt6cr_tool_button_set_style(qt6cr_handle_t handle, int style) {
  auto *tool_button = as_tool_button(handle);

  if (tool_button != nullptr) {
    tool_button->setToolButtonStyle(static_cast<Qt::ToolButtonStyle>(style));
  }
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

qt6cr_handle_t qt6cr_font_combo_box_create(qt6cr_handle_t parent) {
  return new QFontComboBox(as_widget(parent));
}

qt6cr_handle_t qt6cr_font_combo_box_current_font(qt6cr_handle_t handle) {
  auto *font_combo_box = as_font_combo_box(handle);
  return font_combo_box == nullptr ? new QFont() : new QFont(font_combo_box->currentFont());
}

void qt6cr_font_combo_box_set_current_font(qt6cr_handle_t handle, qt6cr_handle_t font) {
  auto *font_combo_box = as_font_combo_box(handle);
  auto *value = as_qfont(font);

  if (font_combo_box != nullptr && value != nullptr) {
    font_combo_box->setCurrentFont(*value);
  }
}

void qt6cr_font_combo_box_on_current_font_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *font_combo_box = as_font_combo_box(handle);

  if (font_combo_box == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(font_combo_box, &QFontComboBox::currentFontChanged, font_combo_box, [callback, userdata](const QFont &font) {
    callback(userdata, new QFont(font));
  });
}

qt6cr_handle_t qt6cr_list_widget_item_create(const char *text) {
  return new QListWidgetItem(QString::fromUtf8(text == nullptr ? "" : text));
}

qt6cr_handle_t qt6cr_list_widget_item_create_with_icon(qt6cr_handle_t icon, const char *text) {
  auto *value = as_qicon(icon);
  return value == nullptr ? nullptr : new QListWidgetItem(*value, QString::fromUtf8(text == nullptr ? "" : text));
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

int qt6cr_list_widget_item_flags(qt6cr_handle_t handle) {
  auto *item = as_list_widget_item(handle);
  return item == nullptr ? 0 : static_cast<int>(item->flags());
}

void qt6cr_list_widget_item_set_flags(qt6cr_handle_t handle, int flags) {
  auto *item = as_list_widget_item(handle);

  if (item != nullptr) {
    item->setFlags(static_cast<Qt::ItemFlags>(flags));
  }
}

int qt6cr_list_widget_item_check_state(qt6cr_handle_t handle) {
  auto *item = as_list_widget_item(handle);
  return item == nullptr ? static_cast<int>(Qt::Unchecked) : static_cast<int>(item->checkState());
}

void qt6cr_list_widget_item_set_check_state(qt6cr_handle_t handle, int state) {
  auto *item = as_list_widget_item(handle);

  if (item != nullptr) {
    item->setCheckState(static_cast<Qt::CheckState>(state));
  }
}

qt6cr_variant_value_t qt6cr_list_widget_item_data(qt6cr_handle_t handle, int role) {
  auto *item = as_list_widget_item(handle);
  return item == nullptr ? qt6cr_variant_value_t{0, false, 0, 0.0, qt6cr_color_t{0, 0, 0, 0}, nullptr} : to_variant_value(item->data(role));
}

void qt6cr_list_widget_item_set_data(qt6cr_handle_t handle, int role, qt6cr_variant_value_t value) {
  auto *item = as_list_widget_item(handle);

  if (item != nullptr) {
    item->setData(role, from_variant_value(value));
  }
}

qt6cr_color_t qt6cr_list_widget_item_foreground(qt6cr_handle_t handle) {
  auto *item = as_list_widget_item(handle);
  return item == nullptr ? qt6cr_color_t{0, 0, 0, 255} : to_color(item->foreground().color());
}

void qt6cr_list_widget_item_set_foreground(qt6cr_handle_t handle, qt6cr_color_t color) {
  auto *item = as_list_widget_item(handle);

  if (item != nullptr) {
    item->setForeground(QBrush(from_color(color)));
  }
}

qt6cr_handle_t qt6cr_list_widget_create(qt6cr_handle_t parent) {
  return new CrystalListWidget(as_widget(parent));
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

int qt6cr_list_widget_spacing(qt6cr_handle_t handle) {
  auto *list_widget = as_list_widget(handle);
  return list_widget == nullptr ? 0 : list_widget->spacing();
}

void qt6cr_list_widget_set_spacing(qt6cr_handle_t handle, int value) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget != nullptr && value >= 0) {
    list_widget->setSpacing(value);
  }
}

int qt6cr_list_widget_drag_drop_mode(qt6cr_handle_t handle) {
  auto *list_widget = as_list_widget(handle);
  return list_widget == nullptr ? 0 : static_cast<int>(list_widget->dragDropMode());
}

void qt6cr_list_widget_set_drag_drop_mode(qt6cr_handle_t handle, int mode) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget != nullptr) {
    list_widget->setDragDropMode(static_cast<QAbstractItemView::DragDropMode>(mode));
  }
}

int qt6cr_list_widget_selection_mode(qt6cr_handle_t handle) {
  auto *list_widget = as_list_widget(handle);
  return list_widget == nullptr ? 0 : static_cast<int>(list_widget->selectionMode());
}

void qt6cr_list_widget_set_selection_mode(qt6cr_handle_t handle, int mode) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget != nullptr) {
    list_widget->setSelectionMode(static_cast<QAbstractItemView::SelectionMode>(mode));
  }
}

int qt6cr_list_widget_default_drop_action(qt6cr_handle_t handle) {
  auto *list_widget = as_list_widget(handle);
  return list_widget == nullptr ? 0 : static_cast<int>(list_widget->defaultDropAction());
}

void qt6cr_list_widget_set_default_drop_action(qt6cr_handle_t handle, int action) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget != nullptr) {
    list_widget->setDefaultDropAction(static_cast<Qt::DropAction>(action));
  }
}

bool qt6cr_list_widget_move_item(qt6cr_handle_t handle, int from, int to) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget == nullptr || from < 0 || to < 0 || from >= list_widget->count() || to >= list_widget->count()) {
    return false;
  }

  if (from == to) {
    return true;
  }

  auto *model = list_widget->model();
  if (model != nullptr && model->moveRow(QModelIndex(), from, QModelIndex(), to > from ? to + 1 : to)) {
    return true;
  }

  auto *item = list_widget->takeItem(from);

  if (item == nullptr) {
    return false;
  }

  list_widget->insertItem(to, item);
  return true;
}

void qt6cr_list_widget_emit_item_double_clicked(qt6cr_handle_t handle, int index) {
  auto *list_widget = static_cast<CrystalListWidget *>(as_list_widget(handle));
  auto *item = list_widget == nullptr ? nullptr : list_widget->item(index);

  if (list_widget != nullptr && item != nullptr) {
    list_widget->emitItemDoubleClickedBridge(item);
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

void qt6cr_list_widget_on_item_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(list_widget, &QListWidget::itemChanged, list_widget, [callback, userdata](QListWidgetItem *item) {
    callback(userdata, item);
  });
}

void qt6cr_list_widget_on_item_double_clicked(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(list_widget, &QListWidget::itemDoubleClicked, list_widget, [callback, userdata](QListWidgetItem *item) {
    callback(userdata, item);
  });
}

void qt6cr_list_widget_on_rows_moved(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *list_widget = as_list_widget(handle);

  if (list_widget == nullptr || callback == nullptr || list_widget->model() == nullptr) {
    return;
  }

  QObject::connect(list_widget->model(), &QAbstractItemModel::rowsMoved, list_widget, [callback, userdata](const QModelIndex &, int, int, const QModelIndex &, int) {
    callback(userdata);
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

int qt6cr_tree_widget_item_flags(qt6cr_handle_t handle) {
  auto *item = as_tree_widget_item(handle);
  return item == nullptr ? 0 : static_cast<int>(item->flags());
}

void qt6cr_tree_widget_item_set_flags(qt6cr_handle_t handle, int flags) {
  auto *item = as_tree_widget_item(handle);

  if (item != nullptr) {
    item->setFlags(static_cast<Qt::ItemFlags>(flags));
  }
}

qt6cr_handle_t qt6cr_tree_widget_item_font(qt6cr_handle_t handle, int column) {
  auto *item = as_tree_widget_item(handle);
  return item == nullptr || column < 0 ? new QFont() : new QFont(item->font(column));
}

void qt6cr_tree_widget_item_set_font(qt6cr_handle_t handle, int column, qt6cr_handle_t font) {
  auto *item = as_tree_widget_item(handle);
  auto *tree_font = as_qfont(font);

  if (item != nullptr && tree_font != nullptr && column >= 0) {
    item->setFont(column, *tree_font);
  }
}

qt6cr_color_t qt6cr_tree_widget_item_foreground(qt6cr_handle_t handle, int column) {
  auto *item = as_tree_widget_item(handle);
  return item == nullptr || column < 0 ? qt6cr_color_t{0, 0, 0, 255} : to_color(item->foreground(column).color());
}

void qt6cr_tree_widget_item_set_foreground(qt6cr_handle_t handle, int column, qt6cr_color_t color) {
  auto *item = as_tree_widget_item(handle);

  if (item != nullptr && column >= 0) {
    item->setForeground(column, QBrush(from_color(color)));
  }
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

bool qt6cr_tree_widget_header_hidden(qt6cr_handle_t handle) {
  auto *tree_widget = as_tree_widget(handle);
  return tree_widget != nullptr && tree_widget->isHeaderHidden();
}

void qt6cr_tree_widget_set_header_hidden(qt6cr_handle_t handle, bool value) {
  auto *tree_widget = as_tree_widget(handle);

  if (tree_widget != nullptr) {
    tree_widget->setHeaderHidden(value);
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

qt6cr_handle_t qt6cr_table_widget_item_create(const char *text) {
  return new QTableWidgetItem(QString::fromUtf8(text == nullptr ? "" : text));
}

void qt6cr_table_widget_item_destroy(qt6cr_handle_t handle) {
  delete as_table_widget_item(handle);
}

void qt6cr_table_widget_item_set_text(qt6cr_handle_t handle, const char *text) {
  auto *item = as_table_widget_item(handle);

  if (item != nullptr) {
    item->setText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_table_widget_item_text(qt6cr_handle_t handle) {
  auto *item = as_table_widget_item(handle);
  return item == nullptr ? duplicate_string("") : duplicate_string(item->text());
}

qt6cr_handle_t qt6cr_table_widget_item_icon(qt6cr_handle_t handle) {
  auto *item = as_table_widget_item(handle);
  return item == nullptr ? nullptr : new QIcon(item->icon());
}

void qt6cr_table_widget_item_set_icon(qt6cr_handle_t handle, qt6cr_handle_t icon) {
  auto *item = as_table_widget_item(handle);
  auto *value = as_qicon(icon);

  if (item != nullptr && value != nullptr) {
    item->setIcon(*value);
  }
}

int qt6cr_table_widget_item_flags(qt6cr_handle_t handle) {
  auto *item = as_table_widget_item(handle);
  return item == nullptr ? 0 : static_cast<int>(item->flags());
}

void qt6cr_table_widget_item_set_flags(qt6cr_handle_t handle, int flags) {
  auto *item = as_table_widget_item(handle);

  if (item != nullptr) {
    item->setFlags(static_cast<Qt::ItemFlags>(flags));
  }
}

int qt6cr_table_widget_item_check_state(qt6cr_handle_t handle) {
  auto *item = as_table_widget_item(handle);
  return item == nullptr ? static_cast<int>(Qt::Unchecked) : static_cast<int>(item->checkState());
}

void qt6cr_table_widget_item_set_check_state(qt6cr_handle_t handle, int state) {
  auto *item = as_table_widget_item(handle);

  if (item != nullptr) {
    item->setCheckState(static_cast<Qt::CheckState>(state));
  }
}

qt6cr_variant_value_t qt6cr_table_widget_item_data(qt6cr_handle_t handle, int role) {
  auto *item = as_table_widget_item(handle);
  return item == nullptr ? qt6cr_variant_value_t{0, false, 0, 0.0, qt6cr_color_t{0, 0, 0, 0}, nullptr} : to_variant_value(item->data(role));
}

void qt6cr_table_widget_item_set_data(qt6cr_handle_t handle, int role, qt6cr_variant_value_t value) {
  auto *item = as_table_widget_item(handle);

  if (item != nullptr) {
    item->setData(role, from_variant_value(value));
  }
}

qt6cr_color_t qt6cr_table_widget_item_foreground(qt6cr_handle_t handle) {
  auto *item = as_table_widget_item(handle);
  return item == nullptr ? qt6cr_color_t{0, 0, 0, 255} : to_color(item->foreground().color());
}

void qt6cr_table_widget_item_set_foreground(qt6cr_handle_t handle, qt6cr_color_t color) {
  auto *item = as_table_widget_item(handle);

  if (item != nullptr) {
    item->setForeground(QBrush(from_color(color)));
  }
}

qt6cr_handle_t qt6cr_table_widget_create(qt6cr_handle_t parent) {
  return new CrystalTableWidget(as_widget(parent));
}

int qt6cr_table_widget_row_count(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? 0 : table->rowCount();
}

void qt6cr_table_widget_set_row_count(qt6cr_handle_t handle, int count) {
  auto *table = as_table_widget(handle);

  if (table != nullptr && count >= 0) {
    table->setRowCount(count);
  }
}

int qt6cr_table_widget_column_count(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? 0 : table->columnCount();
}

void qt6cr_table_widget_set_column_count(qt6cr_handle_t handle, int count) {
  auto *table = as_table_widget(handle);

  if (table != nullptr && count >= 0) {
    table->setColumnCount(count);
  }
}

void qt6cr_table_widget_set_horizontal_header_label(qt6cr_handle_t handle, int column, const char *text) {
  auto *table = as_table_widget(handle);

  if (table == nullptr || column < 0) {
    return;
  }

  if (table->columnCount() <= column) {
    table->setColumnCount(column + 1);
  }

  auto *item = table->horizontalHeaderItem(column);

  if (item == nullptr) {
    item = new QTableWidgetItem();
    table->setHorizontalHeaderItem(column, item);
  }

  item->setText(QString::fromUtf8(text == nullptr ? "" : text));
}

char *qt6cr_table_widget_horizontal_header_label(qt6cr_handle_t handle, int column) {
  auto *table = as_table_widget(handle);
  auto *item = table == nullptr ? nullptr : table->horizontalHeaderItem(column);
  return item == nullptr ? duplicate_string("") : duplicate_string(item->text());
}

void qt6cr_table_widget_set_vertical_header_label(qt6cr_handle_t handle, int row, const char *text) {
  auto *table = as_table_widget(handle);

  if (table == nullptr || row < 0) {
    return;
  }

  if (table->rowCount() <= row) {
    table->setRowCount(row + 1);
  }

  auto *item = table->verticalHeaderItem(row);

  if (item == nullptr) {
    item = new QTableWidgetItem();
    table->setVerticalHeaderItem(row, item);
  }

  item->setText(QString::fromUtf8(text == nullptr ? "" : text));
}

char *qt6cr_table_widget_vertical_header_label(qt6cr_handle_t handle, int row) {
  auto *table = as_table_widget(handle);
  auto *item = table == nullptr ? nullptr : table->verticalHeaderItem(row);
  return item == nullptr ? duplicate_string("") : duplicate_string(item->text());
}

void qt6cr_table_widget_set_item(qt6cr_handle_t handle, int row, int column, qt6cr_handle_t item) {
  auto *table = as_table_widget(handle);
  auto *table_item = as_table_widget_item(item);

  if (table != nullptr && table_item != nullptr && row >= 0 && column >= 0) {
    table->setItem(row, column, table_item);
  }
}

qt6cr_handle_t qt6cr_table_widget_item(qt6cr_handle_t handle, int row, int column) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? nullptr : table->item(row, column);
}

qt6cr_handle_t qt6cr_table_widget_current_item(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? nullptr : table->currentItem();
}

void qt6cr_table_widget_set_current_item(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *table = as_table_widget(handle);
  auto *table_item = as_table_widget_item(item);

  if (table != nullptr) {
    table->setCurrentItem(table_item);
  }
}

int qt6cr_table_widget_current_row(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? -1 : table->currentRow();
}

int qt6cr_table_widget_current_column(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? -1 : table->currentColumn();
}

void qt6cr_table_widget_set_current_cell(qt6cr_handle_t handle, int row, int column) {
  auto *table = as_table_widget(handle);

  if (table != nullptr && row >= 0 && column >= 0) {
    table->setCurrentCell(row, column);
  }
}

void qt6cr_table_widget_clear(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);

  if (table != nullptr) {
    table->clear();
  }
}

void qt6cr_table_widget_clear_contents(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);

  if (table != nullptr) {
    table->clearContents();
  }
}

int qt6cr_table_widget_selection_mode(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? 0 : static_cast<int>(table->selectionMode());
}

void qt6cr_table_widget_set_selection_mode(qt6cr_handle_t handle, int mode) {
  auto *table = as_table_widget(handle);

  if (table != nullptr) {
    table->setSelectionMode(static_cast<QAbstractItemView::SelectionMode>(mode));
  }
}

int qt6cr_table_widget_edit_triggers(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? static_cast<int>(QAbstractItemView::DoubleClicked | QAbstractItemView::EditKeyPressed) : static_cast<int>(table->editTriggers());
}

void qt6cr_table_widget_set_edit_triggers(qt6cr_handle_t handle, int triggers) {
  auto *table = as_table_widget(handle);

  if (table != nullptr) {
    table->setEditTriggers(static_cast<QAbstractItemView::EditTriggers>(triggers));
  }
}

int qt6cr_table_widget_selection_behavior(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? static_cast<int>(QAbstractItemView::SelectItems) : static_cast<int>(table->selectionBehavior());
}

void qt6cr_table_widget_set_selection_behavior(qt6cr_handle_t handle, int behavior) {
  auto *table = as_table_widget(handle);

  if (table != nullptr) {
    table->setSelectionBehavior(static_cast<QAbstractItemView::SelectionBehavior>(behavior));
  }
}

bool qt6cr_table_widget_alternating_row_colors(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table != nullptr && table->alternatingRowColors();
}

void qt6cr_table_widget_set_alternating_row_colors(qt6cr_handle_t handle, bool value) {
  auto *table = as_table_widget(handle);

  if (table != nullptr) {
    table->setAlternatingRowColors(value);
  }
}

bool qt6cr_table_widget_show_grid(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table != nullptr && table->showGrid();
}

void qt6cr_table_widget_set_show_grid(qt6cr_handle_t handle, bool value) {
  auto *table = as_table_widget(handle);

  if (table != nullptr) {
    table->setShowGrid(value);
  }
}

qt6cr_handle_t qt6cr_table_widget_horizontal_header(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? nullptr : table->horizontalHeader();
}

qt6cr_handle_t qt6cr_table_widget_vertical_header(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? nullptr : table->verticalHeader();
}

void qt6cr_table_widget_set_span(qt6cr_handle_t handle, int row, int column, int row_span, int column_span) {
  auto *table = as_table_widget(handle);

  if (table != nullptr && row >= 0 && column >= 0 && row_span >= 1 && column_span >= 1) {
    table->setSpan(row, column, row_span, column_span);
  }
}

int qt6cr_table_widget_row_span(qt6cr_handle_t handle, int row, int column) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? 1 : table->rowSpan(row, column);
}

int qt6cr_table_widget_column_span(qt6cr_handle_t handle, int row, int column) {
  auto *table = as_table_widget(handle);
  return table == nullptr ? 1 : table->columnSpan(row, column);
}

void qt6cr_table_widget_open_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *table = as_table_widget(handle);
  auto *table_item = as_table_widget_item(item);

  if (table != nullptr && table_item != nullptr) {
    table->openPersistentEditor(table_item);
  }
}

void qt6cr_table_widget_close_persistent_editor(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *table = as_table_widget(handle);
  auto *table_item = as_table_widget_item(item);

  if (table != nullptr && table_item != nullptr) {
    table->closePersistentEditor(table_item);
  }
}

bool qt6cr_table_widget_is_persistent_editor_open(qt6cr_handle_t handle, qt6cr_handle_t item) {
  auto *table = as_table_widget(handle);
  auto *table_item = as_table_widget_item(item);
  return table != nullptr && table_item != nullptr && table->isPersistentEditorOpen(table_item);
}

void qt6cr_table_widget_emit_item_double_clicked(qt6cr_handle_t handle, int row, int column) {
  auto *table = static_cast<CrystalTableWidget *>(as_table_widget(handle));
  auto *item = table == nullptr ? nullptr : table->item(row, column);

  if (table != nullptr && item != nullptr) {
    table->emitItemDoubleClickedBridge(item);
  }
}

void qt6cr_table_widget_on_current_cell_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *table = as_table_widget(handle);

  if (table == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(table, &QTableWidget::currentCellChanged, table, [callback, userdata](int, int, int, int) {
    callback(userdata);
  });
}

void qt6cr_table_widget_on_item_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *table = as_table_widget(handle);

  if (table == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(table, &QTableWidget::itemChanged, table, [callback, userdata](QTableWidgetItem *item) {
    callback(userdata, item);
  });
}

void qt6cr_table_widget_on_item_double_clicked(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *table = as_table_widget(handle);

  if (table == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(table, &QTableWidget::itemDoubleClicked, table, [callback, userdata](QTableWidgetItem *item) {
    callback(userdata, item);
  });
}

void qt6cr_table_widget_sort_by_column(qt6cr_handle_t handle, int column, int order) {
  auto *table = as_table_widget(handle);

  if (table != nullptr && column >= 0) {
    table->sortItems(column, static_cast<Qt::SortOrder>(order));
  }
}

void qt6cr_table_widget_resize_columns_to_contents(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);

  if (table != nullptr) {
    table->resizeColumnsToContents();
  }
}

void qt6cr_table_widget_resize_rows_to_contents(qt6cr_handle_t handle) {
  auto *table = as_table_widget(handle);

  if (table != nullptr) {
    table->resizeRowsToContents();
  }
}

void qt6cr_table_widget_on_item_double_clicked(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *table = as_table_widget(handle);

  if (table == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(table, &QTableWidget::itemDoubleClicked, table, [callback, userdata](QTableWidgetItem *item) {
    callback(userdata, item);
  });
}

namespace {
class Qt6crSlider : public QSlider {
public:
  using QSlider::QSlider;

protected:
  void mousePressEvent(QMouseEvent *event) override {
    if (event != nullptr && event->button() == Qt::LeftButton) {
      const int pos = orientation() == Qt::Horizontal ? static_cast<int>(event->position().x()) : static_cast<int>(height() - event->position().y());
      const int span = orientation() == Qt::Horizontal ? width() : height();

      if (span > 0) {
        const int value = QStyle::sliderValueFromPosition(minimum(), maximum(), pos, span, invertedAppearance());
        setValue(value);
      }
    }

    QSlider::mousePressEvent(event);
  }
};
}

qt6cr_handle_t qt6cr_slider_create(qt6cr_handle_t parent, int orientation) {
  return new CrystalSlider(static_cast<Qt::Orientation>(orientation), as_widget(parent));
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

bool qt6cr_slider_click_to_position(qt6cr_handle_t handle) {
  auto *slider = static_cast<CrystalSlider *>(as_slider(handle));
  return slider != nullptr && slider->click_to_position;
}

void qt6cr_slider_set_click_to_position(qt6cr_handle_t handle, bool value) {
  auto *slider = static_cast<CrystalSlider *>(as_slider(handle));

  if (slider != nullptr) {
    slider->click_to_position = value;
  }
}

void qt6cr_slider_emit_pressed(qt6cr_handle_t handle) {
  auto *slider = as_slider(handle);

  if (slider != nullptr) {
    emit slider->sliderPressed();
  }
}

void qt6cr_slider_emit_released(qt6cr_handle_t handle) {
  auto *slider = as_slider(handle);

  if (slider != nullptr) {
    emit slider->sliderReleased();
  }
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

void qt6cr_slider_on_pressed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *slider = as_slider(handle);

  if (slider == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(slider, &QSlider::sliderPressed, slider, [callback, userdata]() {
    callback(userdata);
  });
}

void qt6cr_slider_on_released(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *slider = as_slider(handle);

  if (slider == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(slider, &QSlider::sliderReleased, slider, [callback, userdata]() {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_scroll_bar_create(qt6cr_handle_t parent, int orientation) {
  return new QScrollBar(static_cast<Qt::Orientation>(orientation), as_widget(parent));
}

void qt6cr_scroll_bar_set_minimum(qt6cr_handle_t handle, int value) {
  auto *scroll_bar = as_scroll_bar(handle);

  if (scroll_bar != nullptr) {
    scroll_bar->setMinimum(value);
  }
}

int qt6cr_scroll_bar_minimum(qt6cr_handle_t handle) {
  auto *scroll_bar = as_scroll_bar(handle);
  return scroll_bar == nullptr ? 0 : scroll_bar->minimum();
}

void qt6cr_scroll_bar_set_maximum(qt6cr_handle_t handle, int value) {
  auto *scroll_bar = as_scroll_bar(handle);

  if (scroll_bar != nullptr) {
    scroll_bar->setMaximum(value);
  }
}

int qt6cr_scroll_bar_maximum(qt6cr_handle_t handle) {
  auto *scroll_bar = as_scroll_bar(handle);
  return scroll_bar == nullptr ? 99 : scroll_bar->maximum();
}

void qt6cr_scroll_bar_set_range(qt6cr_handle_t handle, int minimum, int maximum) {
  auto *scroll_bar = as_scroll_bar(handle);

  if (scroll_bar != nullptr) {
    scroll_bar->setRange(minimum, maximum);
  }
}

void qt6cr_scroll_bar_set_value(qt6cr_handle_t handle, int value) {
  auto *scroll_bar = as_scroll_bar(handle);

  if (scroll_bar != nullptr) {
    scroll_bar->setValue(value);
  }
}

int qt6cr_scroll_bar_value(qt6cr_handle_t handle) {
  auto *scroll_bar = as_scroll_bar(handle);
  return scroll_bar == nullptr ? 0 : scroll_bar->value();
}

void qt6cr_scroll_bar_set_single_step(qt6cr_handle_t handle, int value) {
  auto *scroll_bar = as_scroll_bar(handle);

  if (scroll_bar != nullptr) {
    scroll_bar->setSingleStep(value);
  }
}

int qt6cr_scroll_bar_single_step(qt6cr_handle_t handle) {
  auto *scroll_bar = as_scroll_bar(handle);
  return scroll_bar == nullptr ? 1 : scroll_bar->singleStep();
}

void qt6cr_scroll_bar_set_page_step(qt6cr_handle_t handle, int value) {
  auto *scroll_bar = as_scroll_bar(handle);

  if (scroll_bar != nullptr) {
    scroll_bar->setPageStep(value);
  }
}

int qt6cr_scroll_bar_page_step(qt6cr_handle_t handle) {
  auto *scroll_bar = as_scroll_bar(handle);
  return scroll_bar == nullptr ? 10 : scroll_bar->pageStep();
}

int qt6cr_scroll_bar_orientation(qt6cr_handle_t handle) {
  auto *scroll_bar = as_scroll_bar(handle);
  return scroll_bar == nullptr ? static_cast<int>(Qt::Vertical) : static_cast<int>(scroll_bar->orientation());
}

void qt6cr_scroll_bar_on_value_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *scroll_bar = as_scroll_bar(handle);

  if (scroll_bar == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(scroll_bar, &QScrollBar::valueChanged, scroll_bar, [callback, userdata](int value) {
    callback(userdata, value);
  });
}

qt6cr_handle_t qt6cr_dial_create(qt6cr_handle_t parent) {
  return new QDial(as_widget(parent));
}

void qt6cr_dial_set_minimum(qt6cr_handle_t handle, int value) {
  auto *dial = as_dial(handle);

  if (dial != nullptr) {
    dial->setMinimum(value);
  }
}

int qt6cr_dial_minimum(qt6cr_handle_t handle) {
  auto *dial = as_dial(handle);
  return dial == nullptr ? 0 : dial->minimum();
}

void qt6cr_dial_set_maximum(qt6cr_handle_t handle, int value) {
  auto *dial = as_dial(handle);

  if (dial != nullptr) {
    dial->setMaximum(value);
  }
}

int qt6cr_dial_maximum(qt6cr_handle_t handle) {
  auto *dial = as_dial(handle);
  return dial == nullptr ? 99 : dial->maximum();
}

void qt6cr_dial_set_range(qt6cr_handle_t handle, int minimum, int maximum) {
  auto *dial = as_dial(handle);

  if (dial != nullptr) {
    dial->setRange(minimum, maximum);
  }
}

void qt6cr_dial_set_value(qt6cr_handle_t handle, int value) {
  auto *dial = as_dial(handle);

  if (dial != nullptr) {
    dial->setValue(value);
  }
}

int qt6cr_dial_value(qt6cr_handle_t handle) {
  auto *dial = as_dial(handle);
  return dial == nullptr ? 0 : dial->value();
}

bool qt6cr_dial_wrapping(qt6cr_handle_t handle) {
  auto *dial = as_dial(handle);
  return dial != nullptr && dial->wrapping();
}

void qt6cr_dial_set_wrapping(qt6cr_handle_t handle, bool value) {
  auto *dial = as_dial(handle);

  if (dial != nullptr) {
    dial->setWrapping(value);
  }
}

bool qt6cr_dial_notches_visible(qt6cr_handle_t handle) {
  auto *dial = as_dial(handle);
  return dial != nullptr && dial->notchesVisible();
}

void qt6cr_dial_set_notches_visible(qt6cr_handle_t handle, bool value) {
  auto *dial = as_dial(handle);

  if (dial != nullptr) {
    dial->setNotchesVisible(value);
  }
}

void qt6cr_dial_on_value_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *dial = as_dial(handle);

  if (dial == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(dial, &QDial::valueChanged, dial, [callback, userdata](int value) {
    callback(userdata, value);
  });
}

int qt6cr_abstract_spin_box_button_symbols(qt6cr_handle_t handle) {
  auto *spin_box = as_abstract_spin_box(handle);
  return spin_box == nullptr ? static_cast<int>(QAbstractSpinBox::UpDownArrows) : static_cast<int>(spin_box->buttonSymbols());
}

void qt6cr_abstract_spin_box_set_button_symbols(qt6cr_handle_t handle, int value) {
  auto *spin_box = as_abstract_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setButtonSymbols(static_cast<QAbstractSpinBox::ButtonSymbols>(value));
  }
}

bool qt6cr_abstract_spin_box_is_read_only(qt6cr_handle_t handle) {
  auto *spin_box = as_abstract_spin_box(handle);
  return spin_box != nullptr && spin_box->isReadOnly();
}

void qt6cr_abstract_spin_box_set_read_only(qt6cr_handle_t handle, bool value) {
  auto *spin_box = as_abstract_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setReadOnly(value);
  }
}

bool qt6cr_abstract_spin_box_wrapping(qt6cr_handle_t handle) {
  auto *spin_box = as_abstract_spin_box(handle);
  return spin_box != nullptr && spin_box->wrapping();
}

void qt6cr_abstract_spin_box_set_wrapping(qt6cr_handle_t handle, bool value) {
  auto *spin_box = as_abstract_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setWrapping(value);
  }
}

bool qt6cr_abstract_spin_box_is_accelerated(qt6cr_handle_t handle) {
  auto *spin_box = as_abstract_spin_box(handle);
  return spin_box != nullptr && spin_box->isAccelerated();
}

void qt6cr_abstract_spin_box_set_accelerated(qt6cr_handle_t handle, bool value) {
  auto *spin_box = as_abstract_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setAccelerated(value);
  }
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

char *qt6cr_spin_box_prefix(qt6cr_handle_t handle) {
  auto *spin_box = as_spin_box(handle);
  return spin_box == nullptr ? duplicate_string("") : duplicate_string(spin_box->prefix());
}

void qt6cr_spin_box_set_prefix(qt6cr_handle_t handle, const char *value) {
  auto *spin_box = as_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setPrefix(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

char *qt6cr_spin_box_suffix(qt6cr_handle_t handle) {
  auto *spin_box = as_spin_box(handle);
  return spin_box == nullptr ? duplicate_string("") : duplicate_string(spin_box->suffix());
}

void qt6cr_spin_box_set_suffix(qt6cr_handle_t handle, const char *value) {
  auto *spin_box = as_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setSuffix(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

char *qt6cr_spin_box_special_value_text(qt6cr_handle_t handle) {
  auto *spin_box = as_spin_box(handle);
  return spin_box == nullptr ? duplicate_string("") : duplicate_string(spin_box->specialValueText());
}

void qt6cr_spin_box_set_special_value_text(qt6cr_handle_t handle, const char *value) {
  auto *spin_box = as_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setSpecialValueText(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

char *qt6cr_spin_box_clean_text(qt6cr_handle_t handle) {
  auto *spin_box = as_spin_box(handle);
  return spin_box == nullptr ? duplicate_string("") : duplicate_string(spin_box->cleanText());
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

int qt6cr_double_spin_box_decimals(qt6cr_handle_t handle) {
  auto *spin_box = as_double_spin_box(handle);
  return spin_box == nullptr ? 2 : spin_box->decimals();
}

void qt6cr_double_spin_box_set_decimals(qt6cr_handle_t handle, int value) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setDecimals(value);
  }
}

char *qt6cr_double_spin_box_prefix(qt6cr_handle_t handle) {
  auto *spin_box = as_double_spin_box(handle);
  return spin_box == nullptr ? duplicate_string("") : duplicate_string(spin_box->prefix());
}

void qt6cr_double_spin_box_set_prefix(qt6cr_handle_t handle, const char *value) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setPrefix(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

char *qt6cr_double_spin_box_suffix(qt6cr_handle_t handle) {
  auto *spin_box = as_double_spin_box(handle);
  return spin_box == nullptr ? duplicate_string("") : duplicate_string(spin_box->suffix());
}

void qt6cr_double_spin_box_set_suffix(qt6cr_handle_t handle, const char *value) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setSuffix(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

char *qt6cr_double_spin_box_special_value_text(qt6cr_handle_t handle) {
  auto *spin_box = as_double_spin_box(handle);
  return spin_box == nullptr ? duplicate_string("") : duplicate_string(spin_box->specialValueText());
}

void qt6cr_double_spin_box_set_special_value_text(qt6cr_handle_t handle, const char *value) {
  auto *spin_box = as_double_spin_box(handle);

  if (spin_box != nullptr) {
    spin_box->setSpecialValueText(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

char *qt6cr_double_spin_box_clean_text(qt6cr_handle_t handle) {
  auto *spin_box = as_double_spin_box(handle);
  return spin_box == nullptr ? duplicate_string("") : duplicate_string(spin_box->cleanText());
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

qt6cr_handle_t qt6cr_frame_create(qt6cr_handle_t parent) {
  return new QFrame(as_widget(parent));
}

int qt6cr_frame_shape(qt6cr_handle_t handle) {
  auto *frame = as_frame(handle);
  return frame == nullptr ? static_cast<int>(QFrame::NoFrame) : static_cast<int>(frame->frameShape());
}

void qt6cr_frame_set_shape(qt6cr_handle_t handle, int shape) {
  auto *frame = as_frame(handle);

  if (frame != nullptr) {
    frame->setFrameShape(static_cast<QFrame::Shape>(shape));
  }
}

int qt6cr_frame_shadow(qt6cr_handle_t handle) {
  auto *frame = as_frame(handle);
  return frame == nullptr ? static_cast<int>(QFrame::Plain) : static_cast<int>(frame->frameShadow());
}

void qt6cr_frame_set_shadow(qt6cr_handle_t handle, int shadow) {
  auto *frame = as_frame(handle);

  if (frame != nullptr) {
    frame->setFrameShadow(static_cast<QFrame::Shadow>(shadow));
  }
}

qt6cr_handle_t qt6cr_progress_bar_create(qt6cr_handle_t parent) {
  return new QProgressBar(as_widget(parent));
}

int qt6cr_progress_bar_minimum(qt6cr_handle_t handle) {
  auto *progress_bar = as_progress_bar(handle);
  return progress_bar == nullptr ? 0 : progress_bar->minimum();
}

void qt6cr_progress_bar_set_minimum(qt6cr_handle_t handle, int value) {
  auto *progress_bar = as_progress_bar(handle);

  if (progress_bar != nullptr) {
    progress_bar->setMinimum(value);
  }
}

int qt6cr_progress_bar_maximum(qt6cr_handle_t handle) {
  auto *progress_bar = as_progress_bar(handle);
  return progress_bar == nullptr ? 100 : progress_bar->maximum();
}

void qt6cr_progress_bar_set_maximum(qt6cr_handle_t handle, int value) {
  auto *progress_bar = as_progress_bar(handle);

  if (progress_bar != nullptr) {
    progress_bar->setMaximum(value);
  }
}

void qt6cr_progress_bar_set_range(qt6cr_handle_t handle, int minimum, int maximum) {
  auto *progress_bar = as_progress_bar(handle);

  if (progress_bar != nullptr) {
    progress_bar->setRange(minimum, maximum);
  }
}

int qt6cr_progress_bar_value(qt6cr_handle_t handle) {
  auto *progress_bar = as_progress_bar(handle);
  return progress_bar == nullptr ? -1 : progress_bar->value();
}

void qt6cr_progress_bar_set_value(qt6cr_handle_t handle, int value) {
  auto *progress_bar = as_progress_bar(handle);

  if (progress_bar != nullptr) {
    progress_bar->setValue(value);
  }
}

bool qt6cr_progress_bar_text_visible(qt6cr_handle_t handle) {
  auto *progress_bar = as_progress_bar(handle);
  return progress_bar != nullptr && progress_bar->isTextVisible();
}

void qt6cr_progress_bar_set_text_visible(qt6cr_handle_t handle, bool value) {
  auto *progress_bar = as_progress_bar(handle);

  if (progress_bar != nullptr) {
    progress_bar->setTextVisible(value);
  }
}

char *qt6cr_progress_bar_format(qt6cr_handle_t handle) {
  auto *progress_bar = as_progress_bar(handle);
  return progress_bar == nullptr ? duplicate_string("") : duplicate_string(progress_bar->format());
}

void qt6cr_progress_bar_set_format(qt6cr_handle_t handle, const char *value) {
  auto *progress_bar = as_progress_bar(handle);

  if (progress_bar != nullptr) {
    progress_bar->setFormat(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

int qt6cr_progress_bar_orientation(qt6cr_handle_t handle) {
  auto *progress_bar = as_progress_bar(handle);
  return progress_bar == nullptr ? static_cast<int>(Qt::Horizontal) : static_cast<int>(progress_bar->orientation());
}

void qt6cr_progress_bar_set_orientation(qt6cr_handle_t handle, int value) {
  auto *progress_bar = as_progress_bar(handle);

  if (progress_bar != nullptr) {
    progress_bar->setOrientation(static_cast<Qt::Orientation>(value));
  }
}

qt6cr_handle_t qt6cr_date_time_edit_create(qt6cr_handle_t parent) {
  return new QDateTimeEdit(as_widget(parent));
}

char *qt6cr_date_time_edit_display_format(qt6cr_handle_t handle) {
  auto *editor = as_date_time_edit(handle);
  return editor == nullptr ? duplicate_string("") : duplicate_string(editor->displayFormat());
}

void qt6cr_date_time_edit_set_display_format(qt6cr_handle_t handle, const char *value) {
  auto *editor = as_date_time_edit(handle);

  if (editor != nullptr) {
    editor->setDisplayFormat(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

bool qt6cr_date_time_edit_calendar_popup(qt6cr_handle_t handle) {
  auto *editor = as_date_time_edit(handle);
  return editor != nullptr && editor->calendarPopup();
}

void qt6cr_date_time_edit_set_calendar_popup(qt6cr_handle_t handle, bool value) {
  auto *editor = as_date_time_edit(handle);

  if (editor != nullptr) {
    editor->setCalendarPopup(value);
  }
}

qt6cr_handle_t qt6cr_date_time_edit_date(qt6cr_handle_t handle) {
  auto *editor = as_date_time_edit(handle);
  return editor == nullptr ? nullptr : new QDate(editor->date());
}

void qt6cr_date_time_edit_set_date(qt6cr_handle_t handle, qt6cr_handle_t value) {
  auto *editor = as_date_time_edit(handle);
  auto *date = as_qdate(value);

  if (editor != nullptr && date != nullptr) {
    editor->setDate(*date);
  }
}

qt6cr_handle_t qt6cr_date_time_edit_time(qt6cr_handle_t handle) {
  auto *editor = as_date_time_edit(handle);
  return editor == nullptr ? nullptr : new QTime(editor->time());
}

void qt6cr_date_time_edit_set_time(qt6cr_handle_t handle, qt6cr_handle_t value) {
  auto *editor = as_date_time_edit(handle);
  auto *time = as_qtime(value);

  if (editor != nullptr && time != nullptr) {
    editor->setTime(*time);
  }
}

qt6cr_handle_t qt6cr_date_time_edit_date_time(qt6cr_handle_t handle) {
  auto *editor = as_date_time_edit(handle);
  return editor == nullptr ? nullptr : new QDateTime(editor->dateTime());
}

void qt6cr_date_time_edit_set_date_time(qt6cr_handle_t handle, qt6cr_handle_t value) {
  auto *editor = as_date_time_edit(handle);
  auto *date_time = as_qdatetime(value);

  if (editor != nullptr && date_time != nullptr) {
    editor->setDateTime(*date_time);
  }
}

void qt6cr_date_time_edit_on_date_time_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *editor = as_date_time_edit(handle);

  if (editor == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(editor, &QDateTimeEdit::dateTimeChanged, editor, [callback, userdata](const QDateTime &value) {
    callback(userdata, new QDateTime(value));
  });
}

qt6cr_handle_t qt6cr_date_edit_create(qt6cr_handle_t parent) {
  return new QDateEdit(as_widget(parent));
}

void qt6cr_date_edit_on_date_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *editor = as_date_edit(handle);

  if (editor == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(editor, &QDateEdit::dateChanged, editor, [callback, userdata](const QDate &value) {
    callback(userdata, new QDate(value));
  });
}

qt6cr_handle_t qt6cr_time_edit_create(qt6cr_handle_t parent) {
  return new QTimeEdit(as_widget(parent));
}

void qt6cr_time_edit_on_time_changed(qt6cr_handle_t handle, qt6cr_handle_callback_t callback, void *userdata) {
  auto *editor = as_time_edit(handle);

  if (editor == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(editor, &QTimeEdit::timeChanged, editor, [callback, userdata](const QTime &value) {
    callback(userdata, new QTime(value));
  });
}

qt6cr_handle_t qt6cr_calendar_widget_create(qt6cr_handle_t parent) {
  return new QCalendarWidget(as_widget(parent));
}

qt6cr_handle_t qt6cr_calendar_widget_selected_date(qt6cr_handle_t handle) {
  auto *calendar = as_calendar_widget(handle);
  return calendar == nullptr ? nullptr : new QDate(calendar->selectedDate());
}

void qt6cr_calendar_widget_set_selected_date(qt6cr_handle_t handle, qt6cr_handle_t value) {
  auto *calendar = as_calendar_widget(handle);
  auto *date = as_qdate(value);

  if (calendar != nullptr && date != nullptr) {
    calendar->setSelectedDate(*date);
  }
}

qt6cr_handle_t qt6cr_calendar_widget_minimum_date(qt6cr_handle_t handle) {
  auto *calendar = as_calendar_widget(handle);
  return calendar == nullptr ? nullptr : new QDate(calendar->minimumDate());
}

void qt6cr_calendar_widget_set_minimum_date(qt6cr_handle_t handle, qt6cr_handle_t value) {
  auto *calendar = as_calendar_widget(handle);
  auto *date = as_qdate(value);

  if (calendar != nullptr && date != nullptr) {
    calendar->setMinimumDate(*date);
  }
}

qt6cr_handle_t qt6cr_calendar_widget_maximum_date(qt6cr_handle_t handle) {
  auto *calendar = as_calendar_widget(handle);
  return calendar == nullptr ? nullptr : new QDate(calendar->maximumDate());
}

void qt6cr_calendar_widget_set_maximum_date(qt6cr_handle_t handle, qt6cr_handle_t value) {
  auto *calendar = as_calendar_widget(handle);
  auto *date = as_qdate(value);

  if (calendar != nullptr && date != nullptr) {
    calendar->setMaximumDate(*date);
  }
}

bool qt6cr_calendar_widget_grid_visible(qt6cr_handle_t handle) {
  auto *calendar = as_calendar_widget(handle);
  return calendar != nullptr && calendar->isGridVisible();
}

void qt6cr_calendar_widget_set_grid_visible(qt6cr_handle_t handle, bool value) {
  auto *calendar = as_calendar_widget(handle);

  if (calendar != nullptr) {
    calendar->setGridVisible(value);
  }
}

void qt6cr_calendar_widget_on_selection_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *calendar = as_calendar_widget(handle);

  if (calendar == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(calendar, &QCalendarWidget::selectionChanged, calendar, [callback, userdata]() {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_lcd_number_create(qt6cr_handle_t parent) {
  return new QLCDNumber(as_widget(parent));
}

int qt6cr_lcd_number_digit_count(qt6cr_handle_t handle) {
  auto *lcd = as_lcd_number(handle);
  return lcd == nullptr ? 0 : lcd->digitCount();
}

void qt6cr_lcd_number_set_digit_count(qt6cr_handle_t handle, int value) {
  auto *lcd = as_lcd_number(handle);

  if (lcd != nullptr) {
    lcd->setDigitCount(value);
  }
}

int qt6cr_lcd_number_mode(qt6cr_handle_t handle) {
  auto *lcd = as_lcd_number(handle);
  return lcd == nullptr ? static_cast<int>(QLCDNumber::Dec) : static_cast<int>(lcd->mode());
}

void qt6cr_lcd_number_set_mode(qt6cr_handle_t handle, int value) {
  auto *lcd = as_lcd_number(handle);

  if (lcd != nullptr) {
    lcd->setMode(static_cast<QLCDNumber::Mode>(value));
  }
}

int qt6cr_lcd_number_segment_style(qt6cr_handle_t handle) {
  auto *lcd = as_lcd_number(handle);
  return lcd == nullptr ? static_cast<int>(QLCDNumber::Outline) : static_cast<int>(lcd->segmentStyle());
}

void qt6cr_lcd_number_set_segment_style(qt6cr_handle_t handle, int value) {
  auto *lcd = as_lcd_number(handle);

  if (lcd != nullptr) {
    lcd->setSegmentStyle(static_cast<QLCDNumber::SegmentStyle>(value));
  }
}

double qt6cr_lcd_number_value(qt6cr_handle_t handle) {
  auto *lcd = as_lcd_number(handle);
  return lcd == nullptr ? 0.0 : lcd->value();
}

int qt6cr_lcd_number_int_value(qt6cr_handle_t handle) {
  auto *lcd = as_lcd_number(handle);
  return lcd == nullptr ? 0 : lcd->intValue();
}

void qt6cr_lcd_number_display_int(qt6cr_handle_t handle, int value) {
  auto *lcd = as_lcd_number(handle);

  if (lcd != nullptr) {
    lcd->display(value);
  }
}

void qt6cr_lcd_number_display_double(qt6cr_handle_t handle, double value) {
  auto *lcd = as_lcd_number(handle);

  if (lcd != nullptr) {
    lcd->display(value);
  }
}

void qt6cr_lcd_number_display_string(qt6cr_handle_t handle, const char *value) {
  auto *lcd = as_lcd_number(handle);

  if (lcd != nullptr) {
    lcd->display(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

qt6cr_handle_t qt6cr_command_link_button_create(qt6cr_handle_t parent, const char *text, const char *description) {
  return new QCommandLinkButton(
      QString::fromUtf8(text == nullptr ? "" : text),
      QString::fromUtf8(description == nullptr ? "" : description),
      as_widget(parent));
}

char *qt6cr_command_link_button_description(qt6cr_handle_t handle) {
  auto *button = as_command_link_button(handle);
  return button == nullptr ? duplicate_string("") : duplicate_string(button->description());
}

void qt6cr_command_link_button_set_description(qt6cr_handle_t handle, const char *value) {
  auto *button = as_command_link_button(handle);

  if (button != nullptr) {
    button->setDescription(QString::fromUtf8(value == nullptr ? "" : value));
  }
}

qt6cr_handle_t qt6cr_text_document_create(qt6cr_handle_t parent) {
  return new QTextDocument(as_object(parent));
}

char *qt6cr_text_document_plain_text(qt6cr_handle_t handle) {
  auto *document = as_text_document(handle);
  return document == nullptr ? duplicate_string("") : duplicate_string(document->toPlainText());
}

void qt6cr_text_document_set_plain_text(qt6cr_handle_t handle, const char *text) {
  auto *document = as_text_document(handle);

  if (document != nullptr) {
    document->setPlainText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_text_document_html(qt6cr_handle_t handle) {
  auto *document = as_text_document(handle);
  return document == nullptr ? duplicate_string("") : duplicate_string(document->toHtml());
}

void qt6cr_text_document_set_html(qt6cr_handle_t handle, const char *html) {
  auto *document = as_text_document(handle);

  if (document != nullptr) {
    document->setHtml(QString::fromUtf8(html == nullptr ? "" : html));
  }
}

char *qt6cr_text_document_default_style_sheet(qt6cr_handle_t handle) {
  auto *document = as_text_document(handle);
  return document == nullptr ? duplicate_string("") : duplicate_string(document->defaultStyleSheet());
}

void qt6cr_text_document_set_default_style_sheet(qt6cr_handle_t handle, const char *css) {
  auto *document = as_text_document(handle);

  if (document != nullptr) {
    document->setDefaultStyleSheet(QString::fromUtf8(css == nullptr ? "" : css));
  }
}

char *qt6cr_text_document_title(qt6cr_handle_t handle) {
  auto *document = as_text_document(handle);
  return document == nullptr ? duplicate_string("") : duplicate_string(document->metaInformation(QTextDocument::DocumentTitle));
}

void qt6cr_text_document_set_title(qt6cr_handle_t handle, const char *title) {
  auto *document = as_text_document(handle);

  if (document != nullptr) {
    document->setMetaInformation(QTextDocument::DocumentTitle, QString::fromUtf8(title == nullptr ? "" : title));
  }
}

bool qt6cr_text_document_is_modified(qt6cr_handle_t handle) {
  auto *document = as_text_document(handle);
  return document != nullptr && document->isModified();
}

void qt6cr_text_document_set_modified(qt6cr_handle_t handle, bool value) {
  auto *document = as_text_document(handle);

  if (document != nullptr) {
    document->setModified(value);
  }
}

bool qt6cr_text_document_undo_redo_enabled(qt6cr_handle_t handle) {
  auto *document = as_text_document(handle);
  return document != nullptr && document->isUndoRedoEnabled();
}

void qt6cr_text_document_set_undo_redo_enabled(qt6cr_handle_t handle, bool value) {
  auto *document = as_text_document(handle);

  if (document != nullptr) {
    document->setUndoRedoEnabled(value);
  }
}

bool qt6cr_text_document_is_empty(qt6cr_handle_t handle) {
  auto *document = as_text_document(handle);
  return document == nullptr || document->isEmpty();
}

int qt6cr_text_document_block_count(qt6cr_handle_t handle) {
  auto *document = as_text_document(handle);
  return document == nullptr ? 0 : document->blockCount();
}

int qt6cr_text_document_character_count(qt6cr_handle_t handle) {
  auto *document = as_text_document(handle);
  return document == nullptr ? 0 : document->characterCount();
}

qt6cr_handle_t qt6cr_text_document_find(qt6cr_handle_t handle, const char *text, qt6cr_handle_t from_cursor) {
  auto *document = as_text_document(handle);
  auto *cursor = as_text_cursor(from_cursor);

  if (document == nullptr) {
    return new QTextCursor();
  }

  const auto needle = QString::fromUtf8(text == nullptr ? "" : text);
  const auto found = cursor == nullptr ? document->find(needle) : document->find(needle, *cursor);
  return new QTextCursor(found);
}

qt6cr_handle_t qt6cr_text_cursor_create(qt6cr_handle_t document) {
  auto *text_document = as_text_document(document);
  return text_document == nullptr ? static_cast<qt6cr_handle_t>(new QTextCursor()) : static_cast<qt6cr_handle_t>(new QTextCursor(text_document));
}

void qt6cr_text_cursor_destroy(qt6cr_handle_t handle) {
  delete as_text_cursor(handle);
}

bool qt6cr_text_cursor_is_null(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);
  return cursor == nullptr || cursor->isNull();
}

int qt6cr_text_cursor_position(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);
  return cursor == nullptr ? 0 : cursor->position();
}

void qt6cr_text_cursor_set_position(qt6cr_handle_t handle, int position, bool keep_anchor) {
  auto *cursor = as_text_cursor(handle);

  if (cursor != nullptr) {
    cursor->setPosition(position, keep_anchor ? QTextCursor::KeepAnchor : QTextCursor::MoveAnchor);
  }
}

bool qt6cr_text_cursor_move_position(qt6cr_handle_t handle, int operation, int mode, int count) {
  auto *cursor = as_text_cursor(handle);

  if (cursor == nullptr) {
    return false;
  }

  return cursor->movePosition(static_cast<QTextCursor::MoveOperation>(operation), static_cast<QTextCursor::MoveMode>(mode), count);
}

void qt6cr_text_cursor_insert_text(qt6cr_handle_t handle, const char *text) {
  auto *cursor = as_text_cursor(handle);

  if (cursor != nullptr) {
    cursor->insertText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

char *qt6cr_text_cursor_selected_text(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);
  return cursor == nullptr ? duplicate_string("") : duplicate_string(cursor->selectedText());
}

bool qt6cr_text_cursor_has_selection(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);
  return cursor != nullptr && cursor->hasSelection();
}

int qt6cr_text_cursor_selection_start(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);
  return cursor == nullptr ? 0 : cursor->selectionStart();
}

int qt6cr_text_cursor_selection_end(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);
  return cursor == nullptr ? 0 : cursor->selectionEnd();
}

void qt6cr_text_cursor_clear_selection(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);

  if (cursor != nullptr) {
    cursor->clearSelection();
  }
}

void qt6cr_text_cursor_remove_selected_text(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);

  if (cursor != nullptr) {
    cursor->removeSelectedText();
  }
}

void qt6cr_text_cursor_delete_char(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);

  if (cursor != nullptr) {
    cursor->deleteChar();
  }
}

void qt6cr_text_cursor_delete_previous_char(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);

  if (cursor != nullptr) {
    cursor->deletePreviousChar();
  }
}

bool qt6cr_text_cursor_at_start(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);
  return cursor != nullptr && cursor->atStart();
}

bool qt6cr_text_cursor_at_end(qt6cr_handle_t handle) {
  auto *cursor = as_text_cursor(handle);
  return cursor != nullptr && cursor->atEnd();
}

qt6cr_handle_t qt6cr_text_edit_create(qt6cr_handle_t parent) {
  return new QTextEdit(as_widget(parent));
}

char *qt6cr_text_edit_html(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit == nullptr ? duplicate_string("") : duplicate_string(text_edit->toHtml());
}

void qt6cr_text_edit_set_html(qt6cr_handle_t handle, const char *html) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->setHtml(QString::fromUtf8(html == nullptr ? "" : html));
  }
}

char *qt6cr_text_edit_plain_text(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit == nullptr ? duplicate_string("") : duplicate_string(text_edit->toPlainText());
}

void qt6cr_text_edit_set_plain_text(qt6cr_handle_t handle, const char *text) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->setPlainText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

void qt6cr_text_edit_append(qt6cr_handle_t handle, const char *text) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->append(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

void qt6cr_text_edit_append_html(qt6cr_handle_t handle, const char *html) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->append(QString::fromUtf8(html == nullptr ? "" : html));
  }
}

void qt6cr_text_edit_insert_plain_text(qt6cr_handle_t handle, const char *text) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->insertPlainText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

void qt6cr_text_edit_insert_html(qt6cr_handle_t handle, const char *html) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->insertHtml(QString::fromUtf8(html == nullptr ? "" : html));
  }
}

bool qt6cr_text_edit_is_read_only(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit != nullptr && text_edit->isReadOnly();
}

void qt6cr_text_edit_set_read_only(qt6cr_handle_t handle, bool value) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->setReadOnly(value);
  }
}

bool qt6cr_text_edit_accept_rich_text(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit != nullptr && text_edit->acceptRichText();
}

void qt6cr_text_edit_set_accept_rich_text(qt6cr_handle_t handle, bool value) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->setAcceptRichText(value);
  }
}

bool qt6cr_text_edit_undo_redo_enabled(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit != nullptr && text_edit->isUndoRedoEnabled();
}

void qt6cr_text_edit_set_undo_redo_enabled(qt6cr_handle_t handle, bool value) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->setUndoRedoEnabled(value);
  }
}

char *qt6cr_text_edit_placeholder_text(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit == nullptr ? duplicate_string("") : duplicate_string(text_edit->placeholderText());
}

void qt6cr_text_edit_set_placeholder_text(qt6cr_handle_t handle, const char *text) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->setPlaceholderText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

qt6cr_handle_t qt6cr_text_edit_document(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit == nullptr ? nullptr : static_cast<qt6cr_handle_t>(text_edit->document());
}

void qt6cr_text_edit_set_document(qt6cr_handle_t handle, qt6cr_handle_t document) {
  auto *text_edit = as_text_edit(handle);
  auto *text_document = as_text_document(document);

  if (text_edit != nullptr && text_document != nullptr) {
    text_edit->setDocument(text_document);
  }
}

qt6cr_handle_t qt6cr_text_edit_text_cursor(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit == nullptr ? nullptr : static_cast<qt6cr_handle_t>(new QTextCursor(text_edit->textCursor()));
}

void qt6cr_text_edit_set_text_cursor(qt6cr_handle_t handle, qt6cr_handle_t cursor) {
  auto *text_edit = as_text_edit(handle);
  auto *text_cursor = as_text_cursor(cursor);

  if (text_edit != nullptr && text_cursor != nullptr) {
    text_edit->setTextCursor(*text_cursor);
  }
}

void qt6cr_text_edit_clear(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->clear();
  }
}

bool qt6cr_text_edit_can_undo(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit != nullptr && text_edit->document()->isUndoAvailable();
}

bool qt6cr_text_edit_can_redo(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);
  return text_edit != nullptr && text_edit->document()->isRedoAvailable();
}

void qt6cr_text_edit_undo(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->undo();
  }
}

void qt6cr_text_edit_redo(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->redo();
  }
}

void qt6cr_text_edit_select_all(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->selectAll();
  }
}

void qt6cr_text_edit_copy(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->copy();
  }
}

void qt6cr_text_edit_cut(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->cut();
  }
}

void qt6cr_text_edit_paste(qt6cr_handle_t handle) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit != nullptr) {
    text_edit->paste();
  }
}

void qt6cr_text_edit_on_text_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *text_edit = as_text_edit(handle);

  if (text_edit == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(text_edit, &QTextEdit::textChanged, text_edit, [callback, userdata]() {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_plain_text_edit_create(qt6cr_handle_t parent) {
  return new QPlainTextEdit(as_widget(parent));
}

char *qt6cr_plain_text_edit_plain_text(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  return plain_text_edit == nullptr ? duplicate_string("") : duplicate_string(plain_text_edit->toPlainText());
}

void qt6cr_plain_text_edit_set_plain_text(qt6cr_handle_t handle, const char *text) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->setPlainText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

void qt6cr_plain_text_edit_append_plain_text(qt6cr_handle_t handle, const char *text) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->appendPlainText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

void qt6cr_plain_text_edit_insert_plain_text(qt6cr_handle_t handle, const char *text) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->insertPlainText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

bool qt6cr_plain_text_edit_is_read_only(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  return plain_text_edit != nullptr && plain_text_edit->isReadOnly();
}

void qt6cr_plain_text_edit_set_read_only(qt6cr_handle_t handle, bool value) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->setReadOnly(value);
  }
}

bool qt6cr_plain_text_edit_undo_redo_enabled(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  return plain_text_edit != nullptr && plain_text_edit->isUndoRedoEnabled();
}

void qt6cr_plain_text_edit_set_undo_redo_enabled(qt6cr_handle_t handle, bool value) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->setUndoRedoEnabled(value);
  }
}

char *qt6cr_plain_text_edit_placeholder_text(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  return plain_text_edit == nullptr ? duplicate_string("") : duplicate_string(plain_text_edit->placeholderText());
}

void qt6cr_plain_text_edit_set_placeholder_text(qt6cr_handle_t handle, const char *text) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->setPlaceholderText(QString::fromUtf8(text == nullptr ? "" : text));
  }
}

qt6cr_handle_t qt6cr_plain_text_edit_document(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  return plain_text_edit == nullptr ? nullptr : static_cast<qt6cr_handle_t>(plain_text_edit->document());
}

void qt6cr_plain_text_edit_set_document(qt6cr_handle_t handle, qt6cr_handle_t document) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  auto *text_document = as_text_document(document);

  if (plain_text_edit != nullptr && text_document != nullptr) {
    plain_text_edit->setDocument(text_document);
  }
}

qt6cr_handle_t qt6cr_plain_text_edit_text_cursor(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  return plain_text_edit == nullptr ? nullptr : static_cast<qt6cr_handle_t>(new QTextCursor(plain_text_edit->textCursor()));
}

void qt6cr_plain_text_edit_set_text_cursor(qt6cr_handle_t handle, qt6cr_handle_t cursor) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  auto *text_cursor = as_text_cursor(cursor);

  if (plain_text_edit != nullptr && text_cursor != nullptr) {
    plain_text_edit->setTextCursor(*text_cursor);
  }
}

void qt6cr_plain_text_edit_clear(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->clear();
  }
}

bool qt6cr_plain_text_edit_can_undo(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  return plain_text_edit != nullptr && plain_text_edit->document()->isUndoAvailable();
}

bool qt6cr_plain_text_edit_can_redo(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);
  return plain_text_edit != nullptr && plain_text_edit->document()->isRedoAvailable();
}

void qt6cr_plain_text_edit_undo(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->undo();
  }
}

void qt6cr_plain_text_edit_redo(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->redo();
  }
}

void qt6cr_plain_text_edit_select_all(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->selectAll();
  }
}

void qt6cr_plain_text_edit_copy(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->copy();
  }
}

void qt6cr_plain_text_edit_cut(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->cut();
  }
}

void qt6cr_plain_text_edit_paste(qt6cr_handle_t handle) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit != nullptr) {
    plain_text_edit->paste();
  }
}

void qt6cr_plain_text_edit_on_text_changed(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *plain_text_edit = as_plain_text_edit(handle);

  if (plain_text_edit == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(plain_text_edit, &QPlainTextEdit::textChanged, plain_text_edit, [callback, userdata]() {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_text_browser_create(qt6cr_handle_t parent) {
  return new QTextBrowser(as_widget(parent));
}

char *qt6cr_text_browser_html(qt6cr_handle_t handle) {
  auto *text_browser = as_text_browser(handle);
  return text_browser == nullptr ? duplicate_string("") : duplicate_string(text_browser->toHtml());
}

void qt6cr_text_browser_set_html(qt6cr_handle_t handle, const char *html) {
  auto *text_browser = as_text_browser(handle);

  if (text_browser != nullptr) {
    text_browser->setHtml(QString::fromUtf8(html == nullptr ? "" : html));
  }
}

char *qt6cr_text_browser_plain_text(qt6cr_handle_t handle) {
  auto *text_browser = as_text_browser(handle);
  return text_browser == nullptr ? duplicate_string("") : duplicate_string(text_browser->toPlainText());
}

bool qt6cr_text_browser_open_external_links(qt6cr_handle_t handle) {
  auto *text_browser = as_text_browser(handle);
  return text_browser != nullptr && text_browser->openExternalLinks();
}

void qt6cr_text_browser_set_open_external_links(qt6cr_handle_t handle, bool value) {
  auto *text_browser = as_text_browser(handle);

  if (text_browser != nullptr) {
    text_browser->setOpenExternalLinks(value);
  }
}

char *qt6cr_text_browser_default_style_sheet(qt6cr_handle_t handle) {
  auto *text_browser = as_text_browser(handle);
  auto *document = text_browser == nullptr ? nullptr : text_browser->document();
  return document == nullptr ? duplicate_string("") : duplicate_string(document->defaultStyleSheet());
}

void qt6cr_text_browser_set_default_style_sheet(qt6cr_handle_t handle, const char *css) {
  auto *text_browser = as_text_browser(handle);
  auto *document = text_browser == nullptr ? nullptr : text_browser->document();

  if (document != nullptr) {
    document->setDefaultStyleSheet(QString::fromUtf8(css == nullptr ? "" : css));
  }
}

int qt6cr_text_browser_vertical_scroll_value(qt6cr_handle_t handle) {
  auto *text_browser = as_text_browser(handle);
  auto *scroll_bar = text_browser == nullptr ? nullptr : text_browser->verticalScrollBar();
  return scroll_bar == nullptr ? 0 : scroll_bar->value();
}

void qt6cr_text_browser_set_vertical_scroll_value(qt6cr_handle_t handle, int value) {
  auto *text_browser = as_text_browser(handle);
  auto *scroll_bar = text_browser == nullptr ? nullptr : text_browser->verticalScrollBar();

  if (scroll_bar != nullptr) {
    scroll_bar->setValue(value);
  }
}

void qt6cr_text_browser_on_anchor_clicked(qt6cr_handle_t handle, qt6cr_string_callback_t callback, void *userdata) {
  auto *text_browser = as_text_browser(handle);

  if (text_browser == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(text_browser, &QTextBrowser::anchorClicked, text_browser, [callback, userdata](const QUrl &url) {
    char *value = duplicate_string(url.toString());
    callback(userdata, value);
    delete[] value;
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

qt6cr_handle_t qt6cr_tab_bar_create(qt6cr_handle_t parent) {
  return new QTabBar(as_widget(parent));
}

int qt6cr_tab_bar_add_tab(qt6cr_handle_t handle, const char *label) {
  auto *tab_bar = as_tab_bar(handle);
  return tab_bar == nullptr ? -1 : tab_bar->addTab(QString::fromUtf8(label == nullptr ? "" : label));
}

int qt6cr_tab_bar_count(qt6cr_handle_t handle) {
  auto *tab_bar = as_tab_bar(handle);
  return tab_bar == nullptr ? 0 : tab_bar->count();
}

int qt6cr_tab_bar_current_index(qt6cr_handle_t handle) {
  auto *tab_bar = as_tab_bar(handle);
  return tab_bar == nullptr ? -1 : tab_bar->currentIndex();
}

void qt6cr_tab_bar_set_current_index(qt6cr_handle_t handle, int index) {
  auto *tab_bar = as_tab_bar(handle);

  if (tab_bar != nullptr) {
    tab_bar->setCurrentIndex(index);
  }
}

char *qt6cr_tab_bar_tab_text(qt6cr_handle_t handle, int index) {
  auto *tab_bar = as_tab_bar(handle);
  return tab_bar == nullptr ? duplicate_string("") : duplicate_string(tab_bar->tabText(index));
}

void qt6cr_tab_bar_set_tab_text(qt6cr_handle_t handle, int index, const char *value) {
  auto *tab_bar = as_tab_bar(handle);

  if (tab_bar != nullptr && index >= 0) {
    tab_bar->setTabText(index, QString::fromUtf8(value == nullptr ? "" : value));
  }
}

bool qt6cr_tab_bar_draw_base(qt6cr_handle_t handle) {
  auto *tab_bar = as_tab_bar(handle);
  return tab_bar == nullptr || tab_bar->drawBase();
}

void qt6cr_tab_bar_set_draw_base(qt6cr_handle_t handle, bool value) {
  auto *tab_bar = as_tab_bar(handle);

  if (tab_bar != nullptr) {
    tab_bar->setDrawBase(value);
  }
}

void qt6cr_tab_bar_on_current_index_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *tab_bar = as_tab_bar(handle);

  if (tab_bar == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(tab_bar, &QTabBar::currentChanged, tab_bar, [callback, userdata](int value) {
    callback(userdata, value);
  });
}

qt6cr_handle_t qt6cr_stacked_widget_create(qt6cr_handle_t parent) {
  return new QStackedWidget(as_widget(parent));
}

int qt6cr_stacked_widget_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *stacked_widget = as_stacked_widget(handle);
  auto *page = as_widget(widget);

  if (stacked_widget == nullptr || page == nullptr) {
    return -1;
  }

  return stacked_widget->addWidget(page);
}

int qt6cr_stacked_widget_count(qt6cr_handle_t handle) {
  auto *stacked_widget = as_stacked_widget(handle);
  return stacked_widget == nullptr ? 0 : stacked_widget->count();
}

int qt6cr_stacked_widget_current_index(qt6cr_handle_t handle) {
  auto *stacked_widget = as_stacked_widget(handle);
  return stacked_widget == nullptr ? -1 : stacked_widget->currentIndex();
}

void qt6cr_stacked_widget_set_current_index(qt6cr_handle_t handle, int index) {
  auto *stacked_widget = as_stacked_widget(handle);

  if (stacked_widget != nullptr) {
    stacked_widget->setCurrentIndex(index);
  }
}

qt6cr_handle_t qt6cr_stacked_layout_create(qt6cr_handle_t parent) {
  return new QStackedLayout(as_widget(parent));
}

int qt6cr_stacked_layout_add_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *stacked_layout = as_stacked_layout(handle);
  auto *page = as_widget(widget);

  if (stacked_layout == nullptr || page == nullptr) {
    return -1;
  }

  return stacked_layout->addWidget(page);
}

int qt6cr_stacked_layout_count(qt6cr_handle_t handle) {
  auto *stacked_layout = as_stacked_layout(handle);
  return stacked_layout == nullptr ? 0 : stacked_layout->count();
}

int qt6cr_stacked_layout_current_index(qt6cr_handle_t handle) {
  auto *stacked_layout = as_stacked_layout(handle);
  return stacked_layout == nullptr ? -1 : stacked_layout->currentIndex();
}

void qt6cr_stacked_layout_set_current_index(qt6cr_handle_t handle, int index) {
  auto *stacked_layout = as_stacked_layout(handle);

  if (stacked_layout != nullptr) {
    stacked_layout->setCurrentIndex(index);
  }
}

void qt6cr_stacked_layout_on_current_index_changed(qt6cr_handle_t handle, qt6cr_int_callback_t callback, void *userdata) {
  auto *stacked_layout = as_stacked_layout(handle);

  if (stacked_layout == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(stacked_layout, &QStackedLayout::currentChanged, stacked_layout, [callback, userdata](int value) {
    callback(userdata, value);
  });
}

int qt6cr_abstract_scroll_area_vertical_scroll_bar_policy(qt6cr_handle_t handle) {
  auto *scroll_area = as_abstract_scroll_area(handle);
  return scroll_area == nullptr ? static_cast<int>(Qt::ScrollBarAsNeeded) : static_cast<int>(scroll_area->verticalScrollBarPolicy());
}

void qt6cr_abstract_scroll_area_set_vertical_scroll_bar_policy(qt6cr_handle_t handle, int policy) {
  auto *scroll_area = as_abstract_scroll_area(handle);

  if (scroll_area != nullptr) {
    scroll_area->setVerticalScrollBarPolicy(static_cast<Qt::ScrollBarPolicy>(policy));
  }
}

int qt6cr_abstract_scroll_area_horizontal_scroll_bar_policy(qt6cr_handle_t handle) {
  auto *scroll_area = as_abstract_scroll_area(handle);
  return scroll_area == nullptr ? static_cast<int>(Qt::ScrollBarAsNeeded) : static_cast<int>(scroll_area->horizontalScrollBarPolicy());
}

void qt6cr_abstract_scroll_area_set_horizontal_scroll_bar_policy(qt6cr_handle_t handle, int policy) {
  auto *scroll_area = as_abstract_scroll_area(handle);

  if (scroll_area != nullptr) {
    scroll_area->setHorizontalScrollBarPolicy(static_cast<Qt::ScrollBarPolicy>(policy));
  }
}

qt6cr_handle_t qt6cr_abstract_scroll_area_vertical_scroll_bar(qt6cr_handle_t handle) {
  auto *scroll_area = as_abstract_scroll_area(handle);
  return scroll_area == nullptr ? nullptr : scroll_area->verticalScrollBar();
}

qt6cr_handle_t qt6cr_abstract_scroll_area_horizontal_scroll_bar(qt6cr_handle_t handle) {
  auto *scroll_area = as_abstract_scroll_area(handle);
  return scroll_area == nullptr ? nullptr : scroll_area->horizontalScrollBar();
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

int qt6cr_scroll_area_vertical_scroll_bar_policy(qt6cr_handle_t handle) {
  return qt6cr_abstract_scroll_area_vertical_scroll_bar_policy(handle);
}

void qt6cr_scroll_area_set_vertical_scroll_bar_policy(qt6cr_handle_t handle, int policy) {
  qt6cr_abstract_scroll_area_set_vertical_scroll_bar_policy(handle, policy);
}

int qt6cr_scroll_area_horizontal_scroll_bar_policy(qt6cr_handle_t handle) {
  return qt6cr_abstract_scroll_area_horizontal_scroll_bar_policy(handle);
}

void qt6cr_scroll_area_set_horizontal_scroll_bar_policy(qt6cr_handle_t handle, int policy) {
  qt6cr_abstract_scroll_area_set_horizontal_scroll_bar_policy(handle, policy);
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

qt6cr_handle_t qt6cr_dialog_button_box_create(qt6cr_handle_t parent, int buttons) {
  return new QDialogButtonBox(static_cast<QDialogButtonBox::StandardButtons>(buttons), as_widget(parent));
}

qt6cr_handle_t qt6cr_dialog_button_box_button(qt6cr_handle_t handle, int button) {
  auto *button_box = as_dialog_button_box(handle);
  return button_box == nullptr ? nullptr : button_box->button(static_cast<QDialogButtonBox::StandardButton>(button));
}

void qt6cr_dialog_button_box_on_accepted(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *button_box = as_dialog_button_box(handle);

  if (button_box == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(button_box, &QDialogButtonBox::accepted, button_box, [callback, userdata]() {
    callback(userdata);
  });
}

void qt6cr_dialog_button_box_on_rejected(qt6cr_handle_t handle, qt6cr_void_callback_t callback, void *userdata) {
  auto *button_box = as_dialog_button_box(handle);

  if (button_box == nullptr || callback == nullptr) {
    return;
  }

  QObject::connect(button_box, &QDialogButtonBox::rejected, button_box, [callback, userdata]() {
    callback(userdata);
  });
}

qt6cr_handle_t qt6cr_button_group_create(qt6cr_handle_t parent) {
  return new QButtonGroup(as_object(parent));
}

bool qt6cr_button_group_is_exclusive(qt6cr_handle_t handle) {
  auto *button_group = as_button_group(handle);
  return button_group != nullptr && button_group->exclusive();
}

void qt6cr_button_group_set_exclusive(qt6cr_handle_t handle, bool value) {
  auto *button_group = as_button_group(handle);

  if (button_group != nullptr) {
    button_group->setExclusive(value);
  }
}

void qt6cr_button_group_add_button(qt6cr_handle_t handle, qt6cr_handle_t button, int id) {
  auto *button_group = as_button_group(handle);
  auto *abstract_button = as_abstract_button(button);

  if (button_group != nullptr && abstract_button != nullptr) {
    button_group->addButton(abstract_button, id);
  }
}

qt6cr_handle_t qt6cr_button_group_button(qt6cr_handle_t handle, int id) {
  auto *button_group = as_button_group(handle);
  return button_group == nullptr ? nullptr : button_group->button(id);
}

int qt6cr_button_group_checked_id(qt6cr_handle_t handle) {
  auto *button_group = as_button_group(handle);
  return button_group == nullptr ? -1 : button_group->checkedId();
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

void qt6cr_v_box_layout_add_stretch(qt6cr_handle_t handle, int stretch) {
  auto *layout = as_v_box_layout(handle);

  if (layout != nullptr) {
    layout->addStretch(stretch);
  }
}

void qt6cr_v_box_layout_insert_widget(qt6cr_handle_t handle, int index, qt6cr_handle_t widget) {
  auto *layout = as_v_box_layout(handle);
  auto *child = as_widget(widget);

  if (layout != nullptr && child != nullptr) {
    layout->insertWidget(index, child);
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

void qt6cr_h_box_layout_add_stretch(qt6cr_handle_t handle, int stretch) {
  auto *layout = as_h_box_layout(handle);

  if (layout != nullptr) {
    layout->addStretch(stretch);
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

int qt6cr_layout_spacing(qt6cr_handle_t handle) {
  auto *layout = as_layout(handle);
  return layout == nullptr ? 0 : layout->spacing();
}

void qt6cr_layout_set_spacing(qt6cr_handle_t handle, int value) {
  auto *layout = as_layout(handle);

  if (layout != nullptr) {
    layout->setSpacing(value);
  }
}

void qt6cr_layout_set_contents_margins(qt6cr_handle_t handle, double left, double top, double right, double bottom) {
  auto *layout = as_layout(handle);

  if (layout != nullptr) {
    layout->setContentsMargins(static_cast<int>(left), static_cast<int>(top), static_cast<int>(right), static_cast<int>(bottom));
  }
}

void qt6cr_layout_remove_widget(qt6cr_handle_t handle, qt6cr_handle_t widget) {
  auto *layout = as_layout(handle);
  auto *child = as_widget(widget);

  if (layout != nullptr && child != nullptr) {
    layout->removeWidget(child);
  }
}

void qt6cr_string_free(char *value) {
  delete[] value;
}

void qt6cr_string_array_free(qt6cr_string_array_t value) {
  if (value.data == nullptr || value.size <= 0) {
    return;
  }

  for (int index = 0; index < value.size; ++index) {
    delete[] value.data[index];
  }

  delete[] value.data;
}

}  // extern "C"
