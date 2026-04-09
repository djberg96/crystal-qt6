# crystal-qt6 Roadmap

This document describes a practical path for growing `crystal-qt6` from a small Qt6 binding foundation into a library capable of supporting large desktop applications.

The current motivating example is `WargameMapTool`, a substantial Python/PySide6 application, but the roadmap is intentionally broader than a single downstream project.

## Conclusion First

Large PySide6-style desktop applications should not be ported directly today.

The current `crystal-qt6` surface is sufficient for simple widget demos, but larger editor-style applications typically need:

- a `QMainWindow` shell with menus, toolbars, dialogs, dock widgets, status bars, and shortcuts
- custom canvas widgets with paint and input event handling
- heavy use of `QPainter`, `QImage`, `QPixmap`, `QPainterPath`, `QTransform`, fonts, pens, brushes, and geometry types
- export paths for formats such as PDF and SVG
- image processing or other high-throughput data operations outside simple UI code

The right strategy is to grow `crystal-qt6` in layers until one substantial subsystem can be ported safely and validated in isolation.

## Current Gap

Today, `crystal-qt6` exposes only a very small public surface:

- `Application`
- `Widget`
- `Label`
- `PushButton`
- `VBoxLayout`

That is a good foundation, but it is still far below the threshold required for complex Qt applications.

Applications in the target class usually depend on at least these Qt areas:

- `QtCore`: object model, signals, timers, event loops, geometry/value types, buffers, byte arrays, and event metadata
- `QtGui`: actions, colors, fonts, images, pixmaps, painting, paths, pens, brushes, transforms, painter events, keyboard and mouse events
- `QtWidgets`: main windows, dialogs, dock widgets, toolbars, menus, status bars, standard dialogs, forms, scrolling containers, and custom widgets
- `QtSvg` or related modules for vector export in some applications

## Architectural Recommendation

Do not keep expanding the bindings one widget at a time in an ad hoc way.

To support serious application ports, the library needs a deliberate architecture with these properties:

1. A stable C-compatible shim layer over Qt.
2. A reusable object model for `QObject`-based classes and signal connections.
3. Explicit ownership and deterministic teardown rules for GUI-thread objects.
4. A path for custom widget subclassing and event callbacks from Crystal.
5. A rendering API that does not force all drawing logic back into C++.

The existing button callback pattern is useful, but it is not enough by itself. The next stage needs generalized callback and event bridging.

## Porting Strategy

Port the platform first, then port one vertical slice of a real application, then expand.

The readiness test should be something like:

"Can `crystal-qt6` host a simplified but real desktop editor window with docks, a custom canvas widget, painting, zoom/pan interaction, and PNG export?"

If the answer is no, the binding layer is still not ready for a serious application rewrite.

## Phase 1: Core Runtime And Object Model

Goal: make Crystal capable of expressing real Qt object graphs.

### Deliverables

- `QObject` wrapper
- generalized signal connection support
- `QTimer`
- `QEventLoop`
- basic event callback registration
- geometry and utility value types:
  - `QPointF`
  - `QRectF`
  - `QSize`
  - `QMarginsF`
- application-level features:
  - application name
  - window icon
  - stylesheet support

### Acceptance Criteria

- A Crystal widget can subscribe to arbitrary Qt signals, not just button clicks.
- A Crystal timer can invoke a Crystal callback repeatedly.
- A Crystal app can set app metadata, icon, and stylesheet.

## Phase 2: Main Window And Shell Widgets

Goal: support real desktop application shells.

### Deliverables

- `QMainWindow`
- `QDialog`
- `QDockWidget`
- `QStatusBar`
- `QToolBar`
- `QMenuBar`, `QMenu`, `QAction`, `QActionGroup`
- keyboard shortcuts and `QKeySequence`
- standard dialogs:
  - `QMessageBox`
  - `QFileDialog`
  - `QColorDialog`
  - `QInputDialog`
  - `QProgressDialog`
  - `QSplashScreen`

### Acceptance Criteria

- Rebuild a reduced application shell with file menu, edit menu, toolbar, two docks, and a status bar.
- All actions can trigger Crystal callbacks.

## Phase 3: Custom Widgets And Event Handling

Goal: make custom editor widgets possible from Crystal.

### Deliverables

- subclassable `QWidget` support from Crystal
- callbacks for:
  - `paintEvent`
  - `mousePressEvent`
  - `mouseMoveEvent`
  - `mouseReleaseEvent`
  - `wheelEvent`
  - `keyPressEvent`
  - `resizeEvent`
- wrappers for event objects:
  - `QMouseEvent`
  - `QWheelEvent`
  - `QKeyEvent`
  - `QPaintEvent`

### Acceptance Criteria

- Build a `CanvasWidget` prototype in Crystal with panning, zooming, hover tracking, and repaint scheduling.
- Draw a test grid and overlays in a custom widget.

## Phase 4: Rendering And Imaging Stack

Goal: support the heavy `QtGui` drawing usage common to editor-style applications.

### Deliverables

- `QPainter`
- `QPen`
- `QBrush`
- `QColor`
- `QFont`
- `QFontMetrics` and `QFontMetricsF`
- `QPainterPath`
- `QPainterPathStroker`
- `QPolygonF`
- `QTransform`
- `QImage`
- `QPixmap`
- `QImageReader`
- gradients and composition features as needed

### Acceptance Criteria

- Render grids, text labels, paths, fills, and image assets from Crystal.
- Export a rendered image buffer to PNG.

## Phase 5: Forms And Editor Controls

Goal: support panel-heavy control surfaces and editor tooling.

### Deliverables

- common controls and containers such as:
  - line edits
  - checkboxes
  - radio buttons
  - combo boxes
  - list widgets
  - tree widgets or model/view alternatives
  - sliders
  - spin boxes and double spin boxes
  - tab widgets
  - group boxes
  - scroll areas
  - splitters
  - form, grid, horizontal, and vertical layouts
- drag and drop support where required
- font selection widgets if text tools remain Qt-native

### Acceptance Criteria

- Port one options sidebar and one manager dialog end to end.
- Validate live updates between controls and a custom canvas.

## Phase 6: Export And Document Features

Goal: close the feature gap for external outputs.

### Deliverables

- PDF export support through `QPdfWriter` or an equivalent native path
- SVG export support through `QSvgGenerator`
- clipboard access where applications need it
- print-related bindings only if still needed

### Acceptance Criteria

- Reproduce current PNG, PDF, and SVG export behavior for a representative sample document.

## Phase 7: High-Throughput Data And Image Processing

Goal: handle workflows that depend on Python-side numerical or image-processing helpers.

### Options

1. Re-implement the operations directly in Crystal.
2. Move the operations into the native C++ shim and expose them through a C ABI.
3. Keep some operations in a helper process temporarily during migration.

### Recommendation

Prefer Crystal or native C++ implementations, but do not block the entire platform on immediate replacement of every advanced processing feature.

## Suggested Vertical Slice Order

Once phases 1 through 4 are partially complete, port applications in this order:

1. Main window shell with menu, toolbar, status bar, and placeholder docks.
2. Basic document model and editing state.
3. Canvas widget with pan, zoom, and repaint.
4. Core grid or scene rendering.
5. One or two primary editable layers or tools.
6. PNG export.
7. Remaining panels, tools, and advanced export features.
8. Advanced processing and niche features.

This order gives visible progress early and avoids starting with the most complex editor features before the platform is ready.

## What Not To Do

- Do not try to port large Qt applications directly to Crystal right now.
- Do not bind widgets in random order based only on immediate convenience.
- Do not start with advanced dialogs before custom canvas rendering works.
- Do not assume the existing button callback mechanism scales to general Qt event routing.

## Minimum Readiness Bar For Serious Ports

Before serious application rewrite work begins, `crystal-qt6` should be able to demonstrate all of the following in one sample app:

- `QMainWindow` with menu, toolbar, status bar, and dock widgets
- custom central canvas widget written in Crystal
- paint, mouse, wheel, and key event handling
- zoom and pan behavior
- image loading and drawing
- path and text rendering
- PNG export
- stable shutdown and passing automated tests on macOS and Linux

If that sample app exists and is reliable, then application ports become realistic engineering projects rather than speculative rewrites.

## Immediate Next Steps For This Repository

Recommended order for the next development cycle in `crystal-qt6`:

1. Add `QObject`, generic signal bridging, and `QTimer`.
2. Add `QMainWindow`, `QDialog`, `QDockWidget`, `QMenuBar`, `QMenu`, and `QAction`.
3. Add custom `QWidget` event callbacks for paint, mouse, wheel, and key events.
4. Add `QPainter`, `QImage`, `QPixmap`, `QPen`, `QBrush`, and `QPainterPath`.
5. Build a `map_canvas_demo` sample app that proves those layers together.

That would create the first legitimate platform milestone for future ports.
