# crystal-qt6 Roadmap

This document describes a practical path for growing `crystal-qt6` from its current `0.2.0` state into a library capable of supporting large desktop applications.

The current motivating example is `WargameMapTool`, a substantial Python/PySide6 application, but the roadmap is intentionally broader than a single downstream project.

## Conclusion First

Large PySide6-style desktop applications should still not be ported directly today.

`crystal-qt6` is now well beyond simple widget demos: it can host a reduced desktop shell, custom event-driven widgets, a usable raster/SVG/PDF rendering stack, and deterministic teardown. That is enough to prototype real editor subsystems, but not yet enough to replace a large application wholesale.

Larger editor-style applications still typically need:

- a `QMainWindow` shell with menus, toolbars, dialogs, dock widgets, status bars, and shortcuts
- custom canvas widgets with paint and input event handling
- heavy use of `QPainter`, `QImage`, `QPixmap`, `QPainterPath`, `QTransform`, fonts, pens, brushes, and geometry types
- export paths for formats such as PDF and SVG
- richer editor controls, containers, and list/tree surfaces
- richer clipboard/data-transfer features, advanced image-loading helpers, and a few remaining document-oriented APIs
- image processing or other high-throughput data operations outside simple UI code

The right strategy is to grow `crystal-qt6` in layers until one substantial subsystem can be ported safely and validated in isolation.

## Current State At 0.2.0

Today, `crystal-qt6` already exposes a meaningful slice of Qt6 across the core areas needed for editor-style applications:

- `QtCore`-style foundations through `QObject`, Crystal-side `Signal`, `QTimer`, and geometry/event value types
- `QtGui` rendering through `QPainter`, `QImage`, `QPixmap`, `QPainterPath`, `QTransform`, `QPen`, `QBrush`, `QFont`, `QFontMetrics`, and `QFontMetricsF`
- `QtSvg` support through `QSvgGenerator`, `QSvgRenderer`, and `QSvgWidget`, including file-backed and in-memory loading plus named-element rendering
- `QtPrintSupport`-style export through `QPdfWriter`
- `QtWidgets` shell support through `QMainWindow`, `QDialog`, `QDockWidget`, `QStatusBar`, `QToolBar`, `QMenuBar`, `QMenu`, `QAction`, `QActionGroup`, and standard dialogs
- common form/layout support through line edits, checkboxes, combo boxes, list widgets, tree widgets, an initial `QStandardItemModel`-based model/view layer, and vertical, horizontal, form, and grid layouts
- custom widget/event bridging through `EventWidget` paint, resize, mouse, wheel, and key callbacks

That moves the project well past the initial foundation stage. The main gap is no longer the lack of a shell or rendering system. The main gap is the remaining editor-control and application-services layer that sits between the shell and the canvas.

Applications in the target class still usually depend on at least these Qt areas:

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

That generalized callback and event bridging now exists. The next stage is filling in the higher-level control and container surface that real editor sidebars and manager panels require.

## Porting Strategy

Port the platform first, then port one vertical slice of a real application, then expand.

The readiness test should be something like:

"Can `crystal-qt6` host a simplified but real desktop editor window with docks, a custom canvas widget, painting, zoom/pan interaction, and PNG export?"

If the answer is no, the binding layer is still not ready for a serious application rewrite.

## Phase 1: Core Runtime And Object Model

Status: largely complete

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
- Remaining gaps in this phase are application polish features such as app metadata, window icon, stylesheet support, and `QEventLoop`.

## Phase 2: Main Window And Shell Widgets

Status: mostly complete

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
- Remaining gaps in this phase are mostly optional polish widgets such as `QProgressDialog` and `QSplashScreen`.

## Phase 3: Custom Widgets And Event Handling

Status: complete for the current roadmap target

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
- The event bridge is in place; the remaining work is to use it in richer examples and downstream ports.

## Phase 4: Rendering And Imaging Stack

Status: mostly complete

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
- Remaining gaps in this phase are helper and polish APIs such as `QPainterPathStroker`, `QPolygonF`, `QImageReader`, and gradient/composition features.

## Phase 5: Forms And Editor Controls

Status: substantially complete for widget-based editor panels

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

Most of the widget-level work in this phase is now in place, including list and tree panels plus an initial `QStandardItemModel`-based model/view path. The remaining priorities are drag and drop, richer model/view alternatives or abstract-model bridges where needed, and a few application-service APIs beyond the new basic clipboard and file-loading helpers.

## Phase 6: Export And Document Features

Status: partially complete

Goal: close the feature gap for external outputs.

### Deliverables

- PDF export support through `QPdfWriter` or an equivalent native path
- SVG export support through `QSvgGenerator`
- clipboard access where applications need richer transfer support than text/image/pixmap basics
- print-related bindings only if still needed

### Acceptance Criteria

- Reproduce current PNG, PDF, and SVG export behavior for a representative sample document.
- PDF and SVG export are already in place; the remaining work here is mostly richer clipboard/data-transfer support, `QImageReader`-class helpers if needed, and any truly needed print-related APIs.

## Phase 7: High-Throughput Data And Image Processing

Goal: handle workflows that depend on Python-side numerical or image-processing helpers.

### Options

1. Re-implement the operations directly in Crystal.
2. Move the operations into the native C++ shim and expose them through a C ABI.
3. Keep some operations in a helper process temporarily during migration.

### Recommendation

Prefer Crystal or native C++ implementations, but do not block the entire platform on immediate replacement of every advanced processing feature.

## Suggested Vertical Slice Order

With phases 1 through 4 now mostly complete, port applications in this order:

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

`crystal-qt6` now satisfies most of this bar except for the editor-control layer, image-loading helpers, and some richer container widgets. That is why the next tranche should focus on controls and panels rather than more shell or export work.

If that sample app exists and is reliable, then application ports become realistic engineering projects rather than speculative rewrites.

## Immediate Next Steps For This Repository

Recommended order for the next development cycle in `crystal-qt6`:

1. Add `QObject`, generic signal bridging, and `QTimer`.
2. Add `QMainWindow`, `QDialog`, `QDockWidget`, `QMenuBar`, `QMenu`, and `QAction`.
3. Add custom `QWidget` event callbacks for paint, mouse, wheel, and key events.
4. Add `QPainter`, `QImage`, `QPixmap`, `QPen`, `QBrush`, and `QPainterPath`.
5. Build a `map_canvas_demo` sample app that proves those layers together.

That would create the first legitimate platform milestone for future ports.
