# crystal-qt6

[![CI](https://github.com/djberg96/crystal-qt6/actions/workflows/ci.yml/badge.svg)](https://github.com/djberg96/crystal-qt6/actions/workflows/ci.yml)

`crystal-qt6` is a Qt6 bindings project for Crystal with an explicit, incrementally growing API for desktop applications.

This repository currently provides:

- a native Qt6 bridge compiled from C++
- an idiomatic Crystal wrapper for common widget tasks
- reusable object, timer, signal, and event-hook primitives for richer bindings
- runnable examples
- a spec suite that exercises the wrapper end to end

## Status

This is still a focused subset of Qt6 rather than a full binding, but it is no longer just an initial foundation. The `0.5.0` surface covers custom widgets, a reduced desktop application shell, application metadata and stylesheet polish, deeper raster/SVG/PDF rendering and export, raw `QImage` byte-buffer workflows, richer `EventWidget` input hooks, clipboard access, `QMimeData`, richer text/document editing, broader model/view and table support, validators and completers, application-service utilities, common desktop controls, maintained integration examples, and the lifecycle fixes needed to run that surface more reliably across macOS and Linux.

## Requirements

- Crystal 1.11+
- Qt6 Widgets, Qt6 Svg, and Qt6 Svg Widgets development packages available through `pkg-config`
- macOS with Homebrew Qt6 works out of the box when `pkg-config` can resolve `Qt6Widgets`, `Qt6Svg`, and `Qt6SvgWidgets`
- Linux distributions using GCC's standard C++ runtime, such as Fedora with `qt6-qtbase-devel`, are supported

The Crystal FFI layer links against the platform's default C++ runtime:

- macOS: `libc++`
- Linux: `libstdc++`

## Build

The native Qt shim builds automatically the first time you compile, run, or spec the shard. You can still build it explicitly:

```sh
make native
```

If you need to disable the automatic build, set `QT6CR_SKIP_BUILD=1` before invoking Crystal and build the shim yourself with `make native`.

Run the full test suite:

```sh
make spec
```

Run the examples:

```sh
make example-hello
make example-counter
make example-shell
make example-slice
make example-events
make example-render
make example-svg
make example-inspector
make example-modelview
make example-services
make example-dialogs
```

Direct Crystal commands also work without a separate native build step:

```sh
crystal run examples/hello_world.cr
crystal spec
```

Example highlights:

- `examples/hello_world.cr`: smallest possible window with a label and button
- `examples/counter.cr`: simple stateful widget wiring with button callbacks
- `examples/editor_shell.cr`: `QMainWindow`, menus, actions, action groups, shortcuts, toolbars, docks, convenience dialog helpers, and form/grid layout composition
- `examples/editor_vertical_slice.cr`: one maintained “real editor slice” with a `QMainWindow` shell, two docks, a live `EventWidget` canvas, pan/zoom input, model/view layer management, and PNG export
- `examples/desktop_editor_showcase.cr`: broader integration showcase with docks, model/view layer browsing, text/document editing, clipboard `QMimeData`, device-backed image loading, drag/drop notes, custom preview rendering, and PNG export
- `examples/event_monitor.cr`: `QTimer` plus `EventWidget` resize, paint, mouse, wheel, and key hooks
- `examples/rendering_stack.cr`: offscreen rendering plus file-backed and in-memory SVG import/export, named-element SVG rasterization, and PDF export with `QImage`, `QPixmap`, `QSvgGenerator`, `QSvgRenderer`, `QPdfWriter`, `QPainter`, `QPainterPath`, and `QTransform`
- `examples/svg_widget_renderer.cr`: embedded `QSvgWidget` display, in-memory `load_data`, borrowed `QSvgWidget#renderer` access, named-element preview rendering, and widget grab export
- `examples/inspector_workbench.cr`: inspector-style editor UI with `QScrollArea`, `QTabWidget`, `QSplitter`, `QGroupBox`, radio buttons, sliders, spin boxes, and a live `EventWidget` canvas
- `examples/model_view_workbench.cr`: custom `AbstractListModel`, proxy sorting/filtering with regex filters, shared selection models, proxy headers, and delegate-backed editor commit hooks
- `examples/application_services_showcase.cr`: application metadata, stylesheets, window icons, `QImageReader`, clipboard `QMimeData`, drop receiving, `QEventLoop`, `QProgressDialog`, and `QSplashScreen`
- `examples/dialog_gallery.cr`: standard dialog gallery for `QMessageBox`, `QFileDialog`, `QColorDialog`, `QFontDialog`, `QInputDialog`, and `QProgressDialog`

Build the long-form LaTeX guide:

```sh
make docs-book
```

The guide source lives under `docs/book/` and includes screenshot placeholders for publishable dialog and example documentation.

## Continuous Integration

GitHub Actions runs the native build, spec suite, and example compilation on both macOS and Linux via `.github/workflows/ci.yml`.

The Linux job uses `xvfb` with Qt's `xcb` platform plugin for headless widget tests so CI behaves like a normal X11 desktop session without the offscreen plugin warnings. The macOS job installs Homebrew Qt and runs the same specs with `QT_QPA_PLATFORM=offscreen`.

## API Overview

```crystal
require "qt6"

app = Qt6.application
count = 0

window = Qt6.window("Counter", 320, 140) do |widget|
  widget.vbox do |column|
    value = Qt6::Label.new(count.to_s)
    button = Qt6::PushButton.new("Increment")

    button.on_clicked do
      count += 1
      value.text = count.to_s
    end

    column << value
    column << button
  end
end

window.show
app.run
```

## Current Binding Surface

- `Qt6.application` for creating or reusing a single `QApplication`
- `Qt6.window` for quick top-level window setup
- `Qt6::QIcon` plus application and widget window-icon/style-sheet helpers for desktop polish
- `Qt6::QObject` as the common wrapper base for owned Qt objects
- `Qt6::Signal` for Crystal-side callback composition
- `Qt6::QTimer` and `Qt6::QEventLoop` for timeout-driven work and nested local event loops
- `Qt6.clipboard` and `Qt6::Clipboard` for process-wide clipboard text, image, and pixmap access
- `Qt6::Color`, `Qt6::PointF`, `Qt6::Size`, and `Qt6::RectF` for common value types
- `Qt6::QImage`, `Qt6::QImageReader`, `Qt6::QPixmap`, `Qt6::QSvgGenerator`, `Qt6::QSvgRenderer`, `Qt6::QSvgWidget`, `Qt6::QPdfWriter`, `Qt6::QPainter`, `Qt6::QPainterPath`, `Qt6::QTransform`, `Qt6::QPen`, `Qt6::QBrush`, `Qt6::QFont`, `Qt6::QFontMetrics`, `Qt6::QFontMetricsF`, and `Qt6::ImageFormat` for raster, SVG, and PDF rendering, including file-backed raster loading, probed image-reader metadata, file-backed and in-memory SVG loading, and `QSvgWidget#renderer`
- `Qt6::Widget` for generic widgets and top-level windows
- `Qt6::MainWindow`, `Qt6::Dialog`, and `Qt6::DockWidget` for desktop application shells
- `Qt6::MessageBox`, `Qt6::FileDialog`, `Qt6::ColorDialog`, `Qt6::InputDialog`, `Qt6::ProgressDialog`, and `Qt6::SplashScreen` for standard dialogs and shell polish widgets
- convenience helpers such as `MessageBox.information`, `MessageBox.question`, `ColorDialog.get_color`, and `InputDialog.get_text` / `get_int` / `get_double` / `get_item`
- `Qt6::InputDialogInputMode` plus message-box and file-dialog enums for dialog configuration
- `Qt6::MenuBar`, `Qt6::Menu`, `Qt6::ToolBar`, `Qt6::StatusBar`, `Qt6::Action`, and `Qt6::ActionGroup` for shell composition
- `Qt6::KeySequence` and `QAction` shortcuts for keyboard-driven commands
- `Qt6::EventWidget` for custom widget event hooks
- `Qt6::Label` for text display
- `Qt6::PushButton` for push buttons and click callbacks
- `Qt6::LineEdit`, `Qt6::CheckBox`, `Qt6::RadioButton`, `Qt6::ComboBox`, `Qt6::Slider`, `Qt6::SpinBox`, `Qt6::DoubleSpinBox`, and `Qt6::GroupBox` for common form controls
- `Qt6::ListWidget`, `Qt6::ListWidgetItem`, `Qt6::TreeWidget`, and `Qt6::TreeWidgetItem` for item-based list and tree panels, including item flags, check state, role data, reorder support, and list item change hooks
- `Qt6::ModelIndex`, `Qt6::AbstractItemModel`, `Qt6::AbstractListModel`, `Qt6::AbstractTreeModel`, `Qt6::StandardItem`, `Qt6::StandardItemModel`, `Qt6::SortFilterProxyModel`, `Qt6::StyledItemDelegate`, `Qt6::ListView`, and `Qt6::TreeView` for a broader model/view layer with roles, mutable callback-backed list/tree models, row insert/remove/move notifications, proxy sorting/filtering with regex and recursive tree filtering, delegate-based display formatting, drag/drop MIME payloads, and view-side drag/drop configuration
- richer text and table polish through `QTextDocument#find`, `QTextCursor` null/replace helpers, editor-side plain-text/HTML insertion helpers, header section-size access, and table sort/resize-to-contents helpers
- `Qt6::AbstractItemView` and `Qt6::AbstractScrollArea` for shared item-view and scroll-surface infrastructure across list/tree/table widgets, model views, text editors, and scroll areas
- `Qt6::TabWidget`, `Qt6::ScrollArea`, `Qt6::Splitter`, and `Qt6::Orientation` for editor-style panel and container composition
- `Qt6::VBoxLayout`, `Qt6::HBoxLayout`, `Qt6::FormLayout`, and `Qt6::GridLayout` for layout composition

## Testing Strategy

The specs cover:

- process shutdown behavior on macOS so teardown stays free of the `QThreadStorage` exit warning
- standard dialog configuration for `QMessageBox`, `QFileDialog`, `QColorDialog`, and `QInputDialog`
- convenience helper flows for message, color, and input dialogs
- layout composition through vertical, horizontal, form, and grid layouts
- raster, SVG, and PDF rendering with images, pixmaps, painter paths, transforms, SVG generators, SVG renderers, SVG widgets, and PDF writers
- `QObject` destruction signals, `QTimer` timeout delivery, and `QEventLoop` nested-loop behavior
- geometry accessors and custom widget paint, resize, mouse, wheel, and key event hooks
- reduced application-shell wiring for actions, menus, toolbars, dialogs, docks, status bars, and common controls
- widget lifecycle and visibility state
- title and text round trips through the native bridge
- layout composition
- button click callbacks routed from Qt into Crystal blocks

That gives the project an executable contract for both the C++ shim and the Crystal wrapper.

## Lifecycle Notes

Qt objects must be created and destroyed on the GUI thread. The bindings therefore avoid GC finalizers for Qt teardown and instead perform deterministic cleanup during process exit through `Qt6.shutdown`.

You can call `Qt6.shutdown` yourself if you want an explicit shutdown point, but ordinary applications can rely on the built-in exit hook.

## Project Layout

- `src/qt6.cr`: public Crystal API
- `src/qt6/native.cr`: FFI declarations
- `ext/qt6cr/include/qt6cr.h`: C ABI for the shim
- `ext/qt6cr/src/qt6cr.cpp`: Qt6 bridge implementation
- `spec/qt6_spec.cr`: end-to-end specs
- `examples/`: sample applications
- `docs/design.md`: architecture notes
- `docs/book/`: LaTeX guide source for longer-form, screenshot-oriented documentation
- `docs/crystal-qt6-roadmap.md`: phased roadmap for growing `crystal-qt6` toward larger application ports

## Extending The Bindings

The next logical additions are:

1. broader abstract-model bridges beyond flat list models, especially for custom tree models
2. any remaining higher-level drag/drop polish the maintained editor slice exposes, such as richer proxy-model workflows or explicit drag objects if needed
3. remaining rendering/document helpers driven by real downstream needs
4. any additional image-reader, clipboard, or print helpers that the maintained editor slice exposes as real needs
5. a roadmap refresh whenever a major phase closes so the documented plan stays aligned with the shipped surface
