# crystal-qt6 Roadmap

This document describes a practical path for growing `crystal-qt6` from its current `0.3.0` state into a library capable of supporting large desktop applications.

The current motivating example is `WargameMapTool`, a substantial Python/PySide6 application, but the roadmap is intentionally broader than a single downstream project. The goal is not API or naming compatibility with PySide6. The goal is practical Qt6 feature and widget parity, expressed in idiomatic Crystal wrappers.

## Conclusion First

Large PySide6-style desktop applications should still not be ported directly today.

`crystal-qt6` is now well beyond simple widget demos: it can host a reduced desktop shell, custom event-driven widgets, a usable raster/SVG/PDF rendering stack, and deterministic teardown. That is enough to prototype real editor subsystems, and the project is now moving from "can this be done at all?" to "which Qt6 surface areas should reach general-purpose parity next?"

Larger editor-style applications still typically need:

- a `QMainWindow` shell with menus, toolbars, dialogs, dock widgets, status bars, and shortcuts
- custom canvas widgets with paint and input event handling
- heavy use of `QPainter`, `QImage`, `QPixmap`, `QPainterPath`, `QTransform`, fonts, pens, brushes, and geometry types
- export paths for formats such as PDF and SVG
- richer editor controls, containers, and list/tree surfaces
- richer clipboard/data-transfer features beyond the new MIME and drop-receive basics, a few higher-end image-loading helpers beyond the new `QImageReader` basics, and a few remaining document-oriented APIs
- image processing or other high-throughput data operations outside simple UI code

The right strategy is to grow `crystal-qt6` in layers until one substantial subsystem can be ported safely and validated in isolation.

## Current State At 0.3.0

Today, `crystal-qt6` already exposes a meaningful slice of Qt6 across the core areas needed for editor-style applications:

- `QtCore`-style foundations through `QObject`, Crystal-side `Signal`, `QTimer`, and geometry/event value types
- `QtGui` rendering through `QPainter`, `QImage`, `QImageReader`, `QPixmap`, `QPainterPath`, `QTransform`, `QPen`, `QBrush`, `QFont`, `QFontMetrics`, and `QFontMetricsF`
- `QtSvg` support through `QSvgGenerator`, `QSvgRenderer`, and `QSvgWidget`, including file-backed and in-memory loading plus named-element rendering
- `QtPrintSupport`-style export through `QPdfWriter`
- `QtWidgets` shell support through `QMainWindow`, `QDialog`, `QDockWidget`, `QStatusBar`, `QToolBar`, `QMenuBar`, `QMenu`, `QAction`, `QActionGroup`, and standard dialogs
- common form/layout and model/view support through line edits, checkboxes, combo boxes, font combo boxes, stacked widgets, text browsers, button groups, dialog button boxes, list widgets, tree widgets, table views, table widgets, `QStandardItemModel`, callback-backed tree models, `QSortFilterProxyModel`, delegates, selection models, header data, and vertical, horizontal, form, and grid layouts
- basic clipboard and MIME/data-transfer support through text, image, pixmap, `QMimeData`, model/view drag-drop payload helpers, and widget-side drop hooks
- custom widget/event bridging through `EventWidget` paint, resize, mouse, wheel, key, and drop callbacks, plus installable event filters and scroll-guard hooks

That moves the project well past the initial foundation stage. The main gap is no longer the lack of a shell or rendering system. The main gap is the remaining editor-control and application-services layer that sits between the shell and the canvas.

Applications in the target class still usually depend on at least these Qt areas:

- `QtCore`: object model, signals, timers, event loops, geometry/value types, buffers, byte arrays, and event metadata
- `QtGui`: actions, colors, fonts, images, pixmaps, painting, paths, pens, brushes, transforms, painter events, keyboard and mouse events
- `QtWidgets`: main windows, dialogs, dock widgets, toolbars, menus, status bars, standard dialogs, forms, scrolling containers, and custom widgets
- `QtSvg` or related modules for vector export in some applications

## Qt6 Parity Goals

The next stage of the roadmap should be driven by broad Qt6 usefulness, not by one downstream application's private checklist.

Recommended parity targets for the next development cycles:

1. Reach strong coverage for the common `QtWidgets` subset used by desktop editors, data tools, and internal application shells.
2. Prefer binding reusable base classes and shared infrastructure before adding one-off convenience widgets.
3. Keep Crystal naming and ownership conventions even when PySide6 uses different method names.
4. Validate each new surface with focused specs and at least one maintained in-repo example path.

The highest-value parity areas still missing are:

- richer table support beyond the initial `QTableView` and `QTableWidget` layer
- the text-edit stack: `QTextEdit`, `QPlainTextEdit`, `QTextDocument`, `QTextCursor`, and related rich-text helpers
- validators, completers, and editor helper APIs such as `QValidator`, `QIntValidator`, `QDoubleValidator`, regex validation, and `QCompleter`
- additional common widgets such as `QProgressBar`, `QScrollBar`, `QDateEdit`, `QTimeEdit`, `QDateTimeEdit`, `QCalendarWidget`, `QDial`, and `QCommandLinkButton`
- broader application-service and utility coverage such as `QSettings`, `QUrl`, `QFile`, `QDir`, `QFileInfo`, and desktop-integration helpers
- deeper action, menu, toolbar, and window-polish APIs

## Architectural Recommendation

Do not keep expanding the bindings one widget at a time in an ad hoc way.

To support serious application ports, the library needs a deliberate architecture with these properties:

1. A stable C-compatible shim layer over Qt.
2. A reusable object model for `QObject`-based classes and signal connections.
3. Explicit ownership and deterministic teardown rules for GUI-thread objects.
4. A path for custom widget subclassing and event callbacks from Crystal.
5. A rendering API that does not force all drawing logic back into C++.

That generalized callback and event bridging now exists. The next stage is to keep one real in-repo editor slice healthy while filling in the remaining control, model/view, and application-service gaps it exposes.

## Porting Strategy

Port the platform first, then port one vertical slice of a real application, then expand.

The readiness test should be something like:

"Can `crystal-qt6` host a simplified but real desktop editor window with docks, a custom canvas widget, painting, zoom/pan interaction, and PNG export?"

If the answer is no, the binding layer is still not ready for a serious application rewrite.

That readiness checkpoint should now be maintained explicitly in-tree through a richer example application and a matching spec path, not just described abstractly in this document.

## Phase 1: Core Runtime And Object Model

Status: complete for the current roadmap target

Goal: make Crystal capable of expressing real Qt object graphs.

### Deliverables

- `QObject` wrapper
- generalized signal connection support
- `QTimer`
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
- Application-level polish now includes app metadata, application and widget stylesheet support, window icons, and `QEventLoop`.

## Phase 2: Main Window And Shell Widgets

Status: complete for the current roadmap target

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
- Reduced desktop shells can now cover the full roadmap target for this phase, including optional polish widgets such as `QProgressDialog` and `QSplashScreen`.

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
- gradients and composition features as needed

### Acceptance Criteria

- Render grids, text labels, paths, fills, and image assets from Crystal.
- Export a rendered image buffer to PNG.
- Remaining gaps in this phase are now mostly secondary helper APIs such as scaled or stream-backed image reading, plus any extra painter and page-layout polish the real editor slice exposes.

## Phase 5: Forms And Editor Controls

Status: substantially complete for widget-based editor panels

Goal: support panel-heavy control surfaces and editor tooling.

### Deliverables

- common controls and containers such as:
  - line edits
  - checkboxes
  - radio buttons
  - combo boxes
  - font combo boxes
  - list widgets
  - tree widgets or model/view alternatives
  - table views and table widgets
  - sliders
  - spin boxes and double spin boxes
  - tab widgets
  - stacked widgets
  - group boxes
  - scroll areas
  - splitters
  - form, grid, horizontal, and vertical layouts
- drag and drop support where required
- delegates, selection models, and header configuration for model/view editors
- event filters and related widget-level interaction hooks

### Acceptance Criteria

- Port one options sidebar and one manager dialog end to end.
- Validate live updates between controls and a custom canvas.

Most of the widget-level work in this phase is now in place, including list, tree, and initial table support; broader `QStandardItemModel`/`QSortFilterProxyModel`-based model/view paths with roles, header data, selection models, delegate formatting, delegate editor lifecycle hooks, and callback-backed tree models; richer item-widget state and reorder hooks; model-level MIME payload/drop hooks; model/view drag/drop configuration; widget drop acceptance; and installable event filters. The remaining priorities are deeper table behavior, the text-edit stack, validators and completers, and the long tail of common editor-widget polish.

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
- PDF and SVG export are already in place, including custom PDF page layout control. The remaining work here is mostly richer clipboard/data-transfer support beyond the new `QMimeData` basics, any additional image-reader capabilities the real editor slice exposes, and any truly needed print-related APIs.

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

The immediate next milestone is to keep one simplified editor vertical slice in the repository that combines these steps in a single maintained example and verification path.

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

`crystal-qt6` now satisfies most of this bar except for a few still-thin editor layers: richer table and text-edit support, validators and editor helpers, and some application-service utilities. That is why the next tranche should focus on parity within common `QtWidgets` and `QtCore` utility surfaces rather than more shell or export work.

If that sample app exists and is reliable, then application ports become realistic engineering projects rather than speculative rewrites.

## Immediate Next Steps For This Repository

Recommended order for the next development cycle in `crystal-qt6`:

1. Expand table parity with header resize modes, selection behavior, persistent editors, and the most common `QTableView` and `QTableWidget` conveniences.
2. Add the text-edit stack: `QTextEdit`, `QPlainTextEdit`, `QTextDocument`, `QTextCursor`, and closely related rich-text APIs.
3. Add validators, completers, and editor helpers so form controls can express real-world editing constraints.
4. Add the next wave of common widgets such as progress, calendar, date/time, scrollbar, and dial controls.
5. Add broader application-service and utility types such as `QSettings`, `QUrl`, `QFile`, `QDir`, and `QFileInfo`.
6. Keep a maintained example application and focused spec coverage aligned with each parity batch.

That would turn the library from "large editor subsystems are possible" into "common Qt6 desktop application patterns are routinely supported."
