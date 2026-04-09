# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project follows Semantic Versioning.

## [Unreleased]

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
- Rendering bindings for `QImage`, `QPixmap`, `QPainter`, `QPainterPath`, `QTransform`, `QPen`, `QBrush`, and `QFont`, including direct widget paint callbacks.
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
