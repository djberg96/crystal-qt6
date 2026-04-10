# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project follows Semantic Versioning.

## [Unreleased]

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
