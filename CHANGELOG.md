# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project follows Semantic Versioning.

## [Unreleased]

### Added

- Added `Application#invoke_later` for scheduling Crystal callbacks on the Qt event loop.
- Added `TableWidget#on_item_double_clicked` for item double-click callbacks.
- Added `Slider#on_pressed` and `Slider#on_released` for handle press/release callbacks.

### Changed

- Renamed the shard from `crystal-qt6` to `qt6` so dependency naming matches `require "qt6"`.
- Expanded small widget/view surface coverage with layout stretch helpers, themed icon lookup, label alignment/pixmap settings, table-item icons, and item-view viewport/hit-test/drop-overwrite helpers.
- Expanded `EventType` coverage for Qt event values from `None = 0` through `Drop = 63`.
- Expanded the editor vertical-slice example with undo/redo commands, dirty-state tracking, persisted view/export settings, and a clipboard snapshot payload.
- Strengthened the vertical-slice GUI spec so the maintained editor path now verifies undo/redo, clean-state transitions, persisted settings, clipboard MIME/image payloads, pan/zoom interaction, and PNG export together.
- Added a shared `make gui-spec` path and GUI spec runner script so macOS and Linux CI use the same platform-selection logic as local verification.
- Filtered known Qt platform/font GUI-spec chatter without hiding other output or changing spec exit status.

### Fixed

- Preserved existing label text when clearing a `Label` pixmap with `label.pixmap = nil`.

## [0.6.0] - 2026-04-21

### Added

- Deepened `QPainterPath` editing and inspection with element access, current position, control-point bounds, path clearing, path composition, rectangle hit testing, translation, and simplification helpers.
- Added generic `QWidget` attribute helpers with a `WidgetAttribute` enum for toggling and testing Qt widget-level flags.
- Added `QUndoStack` and Crystal-backed `QUndoCommand` wrappers for application-level undo/redo history, clean-state tracking, stack signals, macros, and undo/redo actions.
- Expanded `QImage` and `QPixmap` processing helpers with bit-depth/alpha/grayscale metadata, scaling, mirrored image copies, RGB channel swapping, transform copies, pixel inversion, and additional image formats.
- Added `QFontDialog` bindings with option flags, native-dialog control, current/selected font access, font selection signals, and modal convenience helpers.
- Added a dialog gallery example that exercises message, file, color, font, input, and progress dialogs from buttons, menus, and a toolbar.
- Added a LaTeX guide scaffold under `docs/book/` for longer-form documentation with build-safe screenshot placeholders.

### Changed

- Updated CI to skip Markdown/LaTeX-only documentation changes and compile the maintained example applications.
- Preserved compatibility across Qt versions where image mirroring APIs differ between older mirrored naming and newer flipped naming.

### Fixed

- Improved cross-platform clipboard image detection so `MimeData#has_image?` behaves consistently across supported platforms.

## [0.5.0] - 2026-04-19

### Added

- Deeper `QPainter` coverage for explicit paint-device shutdown, rotation transforms, clip rectangles, brush-backed rectangle fills, point drawing, and target/source rectangle overloads for image and pixmap blits.
- Expanded `EventWidget` callbacks with mouse double-click, key release, pointer enter/leave, and focus in/out hooks plus matching synthetic event helpers for tests.
- Added raw `QImage` data operations for copied byte-buffer construction, raw byte readback, row/byte-size metadata, image copying, rectangular copies, and format conversion.
- Added widget convenience APIs for visibility toggling, paired min/max sizing, mouse tracking, cursor shape, and transparent-for-mouse-events behavior.

## [0.4.0] - 2026-04-14

### Added

- Broader widget and editor coverage including abstract/button infrastructure, tool buttons, button groups, dialog button boxes, frames, font combo boxes, stacked widgets, stacked layouts, text browsers, progress bars, scroll bars, dials, date/time editors, calendar widgets, LCD numbers, command-link buttons, tab bars, and richer widget sizing and tooltip helpers.
- Deeper text and editor tooling through `QTextEdit`, `QPlainTextEdit`, `QTextDocument`, `QTextCursor`, validators, completers, richer line-edit APIs, `QAbstractSpinBox`, expanded spin-box editor behavior, and additional item-view edit-trigger, persistent-editor, selection-model, and model-index convenience layers.
- Expanded model/view and item-widget support with table views, table widgets, header resize modes, selection behavior, spans, callback-backed tree-model paths, event filters, and shared item-view polish for list/tree/table workflows.
- Broader application-service and desktop-integration coverage through `QUrl`, `QDir`, `QFileInfo`, `QFile`, `QSettings`, standard paths, desktop services, and a shared `QIODevice` layer.
- Stronger clipboard, MIME/data-transfer, document, and image-loading helpers, including device-backed image load/save paths and richer clipboard HTML/image/custom-format support.
- A maintained `desktop_editor_showcase` example that combines main-window shell, docks, model/view, text editing, clipboard flows, drag/drop, image IO, and custom preview rendering in one integration path.

### Changed

- Refreshed the roadmap and README to reflect the project’s broader Qt6 feature/widget parity goals and the newer maintained integration-example focus.

### Fixed

- Stabilized object-lifecycle tracking for parent-owned `QObject` wrappers so Qt `destroyed` callbacks stay valid through parent teardown, addressing Linux CI shutdown crashes.
- Hardened calendar-widget specs against platform-specific default date selection so macOS CI no longer flakes on `selection_changed` assertions.

## [0.3.0] - 2026-04-12

### Added

- Clipboard bindings plus `Qt6.clipboard` and `Application#clipboard` helpers for text, image, pixmap, and `QMimeData` clipboard access.
- File-backed raster loading helpers for `QImage` and `QPixmap` through `new(path)`, `from_file`, and `load` APIs.
- `QImageReader` bindings for file-backed image probing and decode, including size, format, auto-transform, and read-into-image helpers.
- Expanded model/view support with `ModelIndex`, `QStandardItem`, `QStandardItemModel`, `QListView`, `QTreeView`, role-based data access, `SortFilterProxyModel`, shared `ItemSelectionModel`, proxy index mapping, header data access, and delegate assignment on list and tree views.
- `StyledItemDelegate` display formatting plus custom editor creation, editor population, and commit hooks.
- `AbstractListModel` and generic item-flag support for callback-backed editable list models implemented in Crystal.
- Drag-and-drop receive support through `MimeData`, `DropEvent`, widget drop acceptance, `EventWidget` drag-enter / drag-move / drop callbacks, and synthetic text-drop helpers for tests.
- `QIcon` bindings plus application and widget helpers for app metadata, style sheets, and window icons.
- `QEventLoop` bindings for nested local event loops.
- `QProgressDialog` and `QSplashScreen` bindings for shell-polish workflows.
- New maintained examples covering the real editor vertical slice, model/view workbench flows, and application-service workflows.

### Changed

- Refreshed the roadmap and README to reflect the broader desktop-shell, model/view, drag-and-drop, image-loading, and runtime-polish coverage now shipped in the shard.

## [0.2.0] - 2026-04-09

### Added

- `QObject` as a shared base for wrapped Qt objects with deterministic release and a `destroyed` signal.
- A reusable Crystal `Signal` type for zero-argument and value-carrying callbacks.
- `QTimer` bindings with timeout callbacks, interval control, single-shot mode, and active-state queries.
- Geometry and event value types including `PointF`, `Size`, `RectF`, `PaintEvent`, `ResizeEvent`, `MouseEvent`, `WheelEvent`, and `KeyEvent`.
- `EventWidget`, a custom `QWidget` bridge with paint, resize, mouse, wheel, and key event hooks.
- Main-window shell bindings for `QMainWindow`, `QDialog`, `QDockWidget`, `QAction`, `QMenuBar`, `QMenu`, `QToolBar`, and `QStatusBar`.
- `QActionGroup` and `QKeySequence` support, including `QAction` shortcuts and checkable action state.
- Standard dialog bindings for `QMessageBox` and `QFileDialog`, including Crystal enums for dialog configuration.
- Standard dialog bindings for `QColorDialog` and `QInputDialog`, plus Crystal value and enum types for colors and input modes.
- Convenience helpers for common dialog flows, including `MessageBox.information` / `question`, `ColorDialog.get_color`, and `InputDialog.get_text` / `get_int` / `get_double`.
- Layout bindings for `QHBoxLayout`, `QFormLayout`, and `QGridLayout`, plus widget DSL helpers for horizontal, form, and grid composition.
- Common control bindings for `QLineEdit`, `QCheckBox`, and `QComboBox`.
- Editor-control bindings for `QRadioButton`, `QSlider`, `QSpinBox`, `QDoubleSpinBox`, and `QGroupBox`.
- Container bindings for `QTabWidget`, `QScrollArea`, `QSplitter`, and the shared `Orientation` enum used by panel-oriented widgets.
- Item-view bindings for `QListWidget`, `QListWidgetItem`, `QTreeWidget`, and `QTreeWidgetItem`, including current-selection callbacks and hierarchical item text access.
- Rendering bindings for `QImage`, `QPixmap`, `QPainter`, `QPainterPath`, `QTransform`, `QPen`, `QBrush`, and `QFont`, including direct widget paint callbacks.
- `QSvgGenerator` bindings so `QPainter` scenes can be exported as SVG with size, view box, metadata, and DPI settings.
- `QSvgRenderer` bindings so SVG files can be loaded, inspected, and rasterized through the existing `QPainter` API.
- Element-specific `QSvgRenderer#render` overloads and `QSvgWidget` bindings for embedded SVG display inside widget layouts.
- In-memory SVG loading for `QSvgRenderer` and `QSvgWidget` through `from_data` and `load_data` APIs.
- `QSvgWidget#renderer` for borrowed access to the widget's internal SVG renderer.
- `QPdfWriter` bindings so `QPainter` scenes can be exported as PDF with metadata, custom page sizes, DPI settings, and page breaks.
- `QFontMetrics` bindings for text measurement, including line metrics, horizontal advance, and bounding rectangles.
- `QFontMetricsF` bindings for subpixel text measurement and floating-point bounding rectangles.
- `ColorDialog#native_dialog?` and `#native_dialog=` so automated tests can disable the platform-native color picker.
- Refreshed and expanded example applications, including a new SVG widget and renderer demo plus deeper rendering-stack coverage.
- Added an inspector-style workbench example that wires the editor-control widgets into a live custom canvas.
- Expanded specs covering timers, geometry accessors, and custom widget event delivery.
- Expanded integration specs covering reduced application shells with menus, toolbars, docks, dialogs, and control callbacks.

## [0.1.0] - 2026-04-08

### Added

- Initial public release of `crystal-qt6`.
- A native Qt6 C++ shim with a Crystal FFI layer for widgets-based bindings.
- A programmer-friendly Crystal API for `Application`, `Widget`, `Label`, `PushButton`, and `VBoxLayout`.
- A small helper DSL for building windows and vertical layouts.
- Example applications for a hello-world window and a counter UI.
- End-to-end specs covering widget lifecycle, text round-trips, layout composition, button callbacks, and shutdown behavior.
- GitHub Actions CI for macOS and Linux.
- Project documentation covering build flow, lifecycle notes, and binding architecture.
