# Changelog

All notable changes to this project will be documented in this file.

The format is based on Keep a Changelog, and this project follows Semantic Versioning.

## [Unreleased]

### Added

- Added `QGraphicsWidget`, `QGraphicsAnchorLayout`, and `QGraphicsAnchor` bindings with anchor spacing, size-policy, and layout-installation helpers for graphics-view layout composition.
- Expanded `QGraphicsWidget` with font, palette, auto-fill background, geometry, and size-policy/min-max sizing helpers for richer graphics-view widget composition.
- Added `QGraphicsView` bindings with brush, alignment, viewport-behavior, and transform helpers for scene viewport configuration.
- Added `QGraphicsEllipseItem` bindings with rect, angle, bounding-rect, and hit-testing helpers for ellipse and pie graphics items.
- Added `QGraphicsObject` bindings with QObject-style property-change callbacks, parent-object lookup, graphics-effect access, signal blocking, and gesture helpers on graphics items.
- Added `QGraphicsLineItem` bindings with line geometry, pen, bounding-rect, hit-testing, and opaque-area helpers for stroked scene primitives.
- Added `QGraphicsPathItem` bindings with painter-path, bounding-rect, hit-testing, and inherited pen/brush helpers for filled and stroked vector scene items.
- Added `QGraphicsPixmapItem` bindings with pixmap, transform-mode, offset, shape-mode, bounding-rect, and hit-testing helpers for scene-image items.
- Added `QGraphicsPolygonItem` bindings with polygon, fill-rule, bounding-rect, hit-testing, and inherited pen/brush helpers for scene polygon items.
- Added `QGraphicsProxyWidget` bindings with embedded-widget access, sub-widget rect lookup, and child-proxy creation helpers for scene-hosted widgets.
- Added `QGraphicsRectItem` bindings with rect geometry, bounding-rect, hit-testing, and inherited pen/brush helpers for scene rectangle items.
- Added `QGraphicsScene` bindings with scene-rect, indexing, brush/font/palette, focus, rendering, item-query, item-creation, and view-association helpers for graphics-view scene composition.
- Added `QGraphicsSceneEvent` bindings with shared widget/timestamp access and live `QEvent` reinterpretation helpers for graphics-scene event handling.
- Added `QGraphicsSceneContextMenuEvent` bindings with widget/timestamp, position, modifier, reason, and live `QEvent` reinterpretation helpers for graphics-scene context-menu handling.
- Added `QGraphicsSceneDragDropEvent` bindings with widget/timestamp, position, buttons/modifiers, action, source, MIME payload, and live `QEvent` reinterpretation helpers for graphics-scene drag/drop handling.
- Added `QGraphicsSceneHelpEvent` bindings with scene/screen position helpers plus shared graphics-scene event state for help-tooltip handling.
- Added `QGraphicsSceneHoverEvent` bindings with current/previous position, modifier, and shared graphics-scene event helpers for hover-tracking workflows.
- Added `QGraphicsSceneMouseEvent` bindings with current, previous, and button-down positions plus button, modifier, source, and flag helpers for graphics-scene mouse workflows.
- Added `QGraphicsSceneMoveEvent` bindings with old/new position helpers plus shared graphics-scene event state for graphics-widget move handling.
- Added `QGraphicsSceneWheelEvent` bindings with position, delta, orientation, scroll-phase, pixel-delta, and inversion helpers for graphics-scene wheel handling.
- Added `QGraphicsLinearLayout` bindings with orientation, nested layout insertion, stretch, spacing, alignment, and layout-item lookup helpers for ordered graphics-view composition.
- Added `QGraphicsGridLayout` bindings with row and column placement, spacing, stretch, sizing, alignment, and shared graphics-layout helpers.
- Expanded `QGraphicsItem` bindings with shared state, flags, cache-mode, geometry, transform, opacity, and stacking helpers, with matching safe inherited support on `QGraphicsWidget`.
- Added `QGraphicsTransform` and `QGraphicsRotation` bindings with 3D origin/axis/angle helpers, change callbacks, and shared graphics-item transformation-list support.
- Added `QGraphicsScale` bindings with origin and per-axis scale helpers plus change callbacks for 3D scale transforms in graphics-view scenes.
- Added `QGraphicsItemGroup` bindings with grouping, ungrouping, bounding-rect, and opaque-area helpers, plus shared `QGraphicsItem#group` accessors.
- Expanded `QGraphicsLayout` bindings with contents-margins readback, `update_geometry`, and the shared instant-invalidate propagation toggle.
- Expanded `QGraphicsLayoutItem` coverage across graphics layouts and graphics widgets with size-policy, size-hint, contents-rect, parent-layout-item, and ownership helpers.
- Expanded `QGraphicsEffect` with `bounding_rect_for` and a Qt-style `set_enabled` alias for shared effect geometry helpers.
- Expanded `QGraphicsBlurEffect` with blur-hint flags and Qt-style setter aliases for fuller graphics-effect configuration.
- Expanded `QGraphicsColorizeEffect` with color/strength change callbacks and Qt-style setter aliases for richer live effect updates.
- Expanded `QGraphicsDropShadowEffect` with blur/color/offset change callbacks and Qt-style setter aliases for richer shadow effect control.
- Expanded `QGraphicsOpacityEffect` with opacity-mask support, change callbacks, and Qt-style setter aliases for richer live effect updates.

## [0.9.0] - 2026-05-07

### Added

- Added `QFocusFrame` bindings with tracked-widget get/set helpers for shell polish and focus highlighting.
- Added `QToolBox` bindings with page insertion, selection, and current-index callback support, plus a `QSizeGrip` wrapper with `size_hint`.
- Added `QKeySequenceEdit`, `QRubberBand`, and `QErrorMessage` bindings for shortcut capture, marquee selection overlays, and queued error-dialog workflows.
- Expanded `QErrorMessage` with access to Qt's shared `qtHandler()` dialog for process-wide queued error reporting.
- Added `QWizard` and `QWizardPage` bindings for page-based setup flows, including style and option controls, button and pixmap customization, visited-page tracking, and mandatory-field completion wiring.
- Expanded `QWizard` and `QWizardPage` with wizard field access/setters, page-to-wizard lookup, and direct current-page validation helpers for richer multi-page workflows.
- Expanded `QWizard` signal coverage with custom-button, help-requested, and page add/remove callbacks for richer interactive wizard flows.
- Added `QDataWidgetMapper` bindings with model/delegate/root-index plumbing, manual or auto submit policies, widget/property mappings, and row navigation for form-style model editing.
- Added `QMdiArea` and `QMdiSubWindow` wrappers with document-area options, tabbed-view controls, activation callbacks, and subwindow helpers for desktop multi-document shells.
- Added `QColumnView`, `QFileIconProvider`, and `QFileSystemModel` wrappers for Finder-style model browsing, stock file icons, and live directory-tree models with filtering, name filters, and root-path callbacks.
- Expanded `QFileSystemModel` and `QFileInfo` with file icons, permission flags, and last-modified metadata for richer filesystem browsers.
- Expanded `QFileSystemModel` with a rename helper and `fileRenamed` callback support for editable filesystem-browser flows.
- Expanded `QColumnView` with preview-update callbacks, and added shared `AbstractItemView#scroll_to` / `#select_all` helpers for model-view navigation.
- Expanded `QAbstractItemView` with shared root-index, auto-scroll, Tab-navigation, selection-clearing, top/bottom scroll helpers, and corrected `QAbstractScrollArea` inheritance for list/tree/table-style views.
- Expanded `QAbstractScrollArea` with shared viewport, corner-widget, maximum-viewport, and size-adjust-policy helpers across scroll areas, editors, and item views.
- Added `QAbstractSlider` as a shared base for sliders, scroll bars, and dials, including shared range/value/step/orientation helpers, slider actions, and inherited press/release and range/action callbacks.
- Expanded `QAbstractSpinBox` with shared text/editor, correction/alignment/frame, keyboard-tracking, group-separator, line-edit access, step/select/clear helpers, and finish/return callbacks across spin boxes and date/time editors.
- Expanded `QWidget` with status-tip, What's This, and accessibility name/description/identifier helpers to expose the metadata consumed by accessible widget interfaces.
- Expanded `QApplication` with input-timing, wheel-scroll, drag-threshold, auto-SIP, active-window, focus-widget, and close-all-windows helpers.
- Expanded `QBoxLayout` with optional unparented construction for nested layouts, stretch-aware widget insertion, child-layout insertion, stretch-factor lookup/setters, and `add_strut`.
- Added `QStyle` and `QCommonStyle` wrappers with style-name and standard-palette access plus application/widget style get/set helpers.
- Expanded `QCompleter` with model-sorting, completion-column/role, completion-count/current-row, bound-widget, and explicit `complete` helpers.
- Expanded `QDataWidgetMapper` with a slot-style `set_current_index` alias and deeper navigation, auto-submit, and mapping-cleanup coverage.
- Expanded `QDateEdit` through shared `QDateTimeEdit` range, section, and popup-calendar helpers, and added initial-date construction support.
- Expanded `QDial` with notch-target and computed notch-size helpers to round out the dial-specific API.
- Expanded `QDialog` with modal and size-grip properties, explicit open/done/result controls, and `finished` callback support.
- Expanded `QDialogButtonBox` with richer constructors, dynamic button add/remove/clear helpers, button-role and standard-button lookup, button enumeration, and clicked/help callbacks.
- Expanded `QDockWidget` with features, allowed-areas checks, and dock lifecycle callbacks for richer shell docking behavior.
- Expanded `QDoubleSpinBox` with shared step-type control and text-changed callback support.
- Expanded `QFileDialog` with options, view mode, directory filters, wildcard filter lists, default suffix, history, label text, supported schemes, selected-files inspection, and existing-directory helpers.
- Expanded `QFileIconProvider` with inherited type-description lookup and option flags for fuller standalone file-system icon customization.
- Added `QGesture` bindings with gesture type/state inspection, cancel-policy control, and hot-spot helpers as a base for gesture-aware widget flows.
- Added `QGestureEvent` bindings with gesture enumeration, per-gesture and per-type acceptance control, associated-widget access, live `QEvent#gesture_event` wrapping, and `QWidget#grab_gesture` helpers.
- Added callback-backed `QGestureRecognizer` bindings with direct create/recognize/reset helpers, dynamic custom-type registration, and raw gesture-type support for recognizer-driven widget flows.
- Expanded `QFocusFrame` with a Qt-style `set_widget` alias and stronger tracked-widget coverage for focus-highlight helpers.
- Expanded `QFrame` with combined frame-style masks, frame-rect access, and Qt-style setter aliases for fuller shared frame polish across framed widgets.
- Expanded `QFontComboBox` with writing-system and font-filter controls, preferred-size access, and sample/display-font customization hooks.
- Expanded `QFontDialog` with a Qt-style `set_current_font` alias and stronger selected-font coverage in dialog specs.
- Expanded `QFormLayout` with growth/wrap/alignment controls, nested layout rows, row insertion/removal/visibility helpers, label lookup, `TakeRowResult` modeling, and optional unparented construction.
- Added deeper `QPainter` coverage with rounded rectangles, polylines, arc/pie/chord primitives, and rect-aligned text drawing helpers.
- Added `QRegion` and `RegionType` bindings for painter clip regions, widget masks, and region set operations.
- Added `QConicalGradient` bindings, including `QBrush` support and rendering-spec coverage for angular gradient fills.
- Added `LineF` as a geometry value type with native round-trip support, length/angle queries, interpolation, and translation helpers.
- Added shared gradient spread and coordinate-mode controls across linear, conical, and radial gradient wrappers.
- Added `QRadialGradient` focal-point construction and accessors for offset radial highlights.
- Added shared gradient stop inspection across linear, conical, and radial gradient wrappers.
- Added `QBitmap` bindings with image, pixmap, data, transform, and file round-trip support, plus bitmap-backed `QRegion` construction for mask workflows.
- Added mutable `QRegion` set-operation helpers and `Widget#update` overloads for rect- and region-scoped repaint scheduling.
- Added `QPalette`, `ColorGroup`, and `ColorRole` bindings with application- and widget-level palette access for theme-aware colors.
- Added `Point`, `FillRule`, `QPolygon`, and polygon-backed `QRegion` construction for integer-coordinate masks and custom clip shapes.
- Added direct `QPolygon` support in `QPainterPath#add_polygon`, `QPainter#draw_polygon`, and `QPainter#draw_polyline`.
- Added `QPainter#draw_convex_polygon` support for both `QPolygon` and `QPolygonF`.
- Added `BrushStyle` plus deeper `QBrush` style, texture, texture-image, and opacity helpers.
- Added `QPainterPath#fill_rule` support for odd-even and winding interior control.
- Added minimal `GraphicsItem` and `AbstractGraphicsShapeItem` wrappers with visibility, enablement, opacity, parent-item lookup, pen/brush access, obscured checks, and opaque-area access.
- Added `QGraphicsEffect` plus blur, colorize, drop-shadow, and opacity effect wrappers with widget attachment helpers and enabled-state callbacks.
- Added `QShortcut` bindings with key-sequence, context, auto-repeat, enablement, parent-widget access, and activation callbacks.
- Added `QBoxLayout` bindings with direction control plus shared widget, spacing, and stretch helpers under `VBoxLayout` and `HBoxLayout`.
- Expanded `QAbstractButton` coverage with shortcut, down-state, auto-repeat, auto-exclusive, button-group, press/release, checked-click, and animate/toggle helpers shared by button widgets.

### Fixed

- Added handle-based wrapping support to `StyledItemDelegate`, so delegate getters can safely round-trip existing Qt delegate instances.
- Documented `QErrorMessage.qt_handler` as a process-global Qt singleton that should be used sparingly compared with ordinary `ErrorMessage.new` dialogs.

## [0.8.0] - 2026-04-29

### Added

- Added multithreaded GUI-spec coverage for `Application#invoke_later` with `CRYSTAL_WORKERS=2` and Crystal's `preview_mt` runtime.
- Added `SystemTrayIcon` bindings with activation and message-click callbacks, tray availability/message support queries, tooltips, icons, context menus, and tray-message helpers.
- Added `Action#icon`, `StandardItem#icon`, and `WidgetAction#default_widget` support for richer shell and model/view presentation.
- Added broader shell/widget helpers across `ToolBar`, `StatusBar`, `DockWidget`, `ScrollArea`, and `ProgressBar`, including toolbar item/polish APIs, status-bar widget management and size-grip state, dock floating/widget access, scroll-area child visibility helpers, and progress-bar formatting/alignment/orientation controls.
- Added `Widget#show_maximized`, `QEvent#mouse_event`, and widget-local menu execution helpers.
- Added `ToolButton#menu`, `#default_action`, and `#auto_raise` helpers for toolbar- and palette-style command buttons.
- Added `PushButton#default`, `#auto_default`, and `#flat` helpers for dialog- and shell-style button presentation.
- Added `ButtonGroup#checked_button`, `#id`, `#set_id`, and `#remove` helpers for grouped tool and mode buttons.
- Added `GroupBox#alignment` and `#flat` helpers for inspector-style panel presentation.
- Added `TabBar#insert_tab`, `#remove_tab`, enabled-state helpers, and movable/closable presentation controls for lightweight shell and editor tab strips.
- Added `DialogButtonBox#standard_buttons`, `#center_buttons`, and `#orientation` helpers for dialog-shell layout polish.
- Added `CheckBox#tristate` and `#check_state` helpers for partially checked option flows.
- Added `RadioButton#auto_exclusive` and `#click` helpers for editor-style option groups.
- Added `ScrollArea#alignment` helpers for centered and preview-style content presentation.
- Added `Frame#line_width`, `#mid_line_width`, and `#frame_width` helpers for separator and panel polish.
- Added aligned `SplashScreen#show_message` support for launch-status polish.
- Added `DockWidget#title_bar_widget` helpers for custom dock headers.
- Added `Completer#wrap_around` and `#max_visible_items` helpers for richer line-edit completion behavior.
- Added `LcdNumber#small_decimal_point` and `#overflow?` helpers for compact numeric-display polish.
- Added `HeaderView#sections_movable` and `#sections_clickable` helpers for richer table header interaction.

### Changed

- Expanded common widget audit coverage with deeper `ComboBox`, `CheckBox`, `RadioButton`, `Completer`, `TabWidget`, `TabBar`, `ScrollArea`, `Splitter`, `StackedWidget`, `DialogButtonBox`, `DockWidget`, `Frame`, `SplashScreen`, `LcdNumber`, `HeaderView`, `ButtonGroup`, `GroupBox`, and button-widget APIs for editor-style shells and panels.

### Fixed

- Updated application quit handling to wait for open widgets to close before process exit.
- Restored backward-compatible `SplashScreen#show_message(message, color)` calls after adding aligned splash-message support.

## [0.7.0] - 2026-04-23

### Added

- Added `Application#invoke_later` for scheduling Crystal callbacks on the Qt event loop.
- Added `TableWidget#on_item_double_clicked` for item double-click callbacks.
- Added `Slider#on_pressed` and `Slider#on_released` for handle press/release callbacks.
- Added opt-in `Slider#click_to_position` track-click behavior.
- Added `UndoGroup` for coordinating shared undo/redo actions across multiple document stacks.
- Added `DockWidget#toggle_view_action` for dock-owned View menu visibility toggles.
- Added `QImageWriter` for configured file/device image encoding and supported-format queries.
- Added `Widget#add_action` for attaching `QAction` shortcuts directly to widgets.

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
