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

This is an initial, working foundation rather than a full binding of the entire Qt6 API. The current surface now covers the basics for custom widgets plus a reduced desktop application shell built around main windows, menus, actions, docks, toolbars, dialogs, and a few common controls.

## Requirements

- Crystal 1.11+
- Qt6 Widgets development package available through `pkg-config`
- macOS with Homebrew Qt6 works out of the box when `pkg-config` can resolve `Qt6Widgets`
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
make example-events
```

Direct Crystal commands also work without a separate native build step:

```sh
crystal run examples/hello_world.cr
crystal spec
```

Example highlights:

- `examples/hello_world.cr`: smallest possible window with a label and button
- `examples/counter.cr`: simple stateful widget wiring with button callbacks
- `examples/editor_shell.cr`: `QMainWindow`, menus, actions, action groups, shortcuts, toolbars, docks, standard dialogs, color dialogs, input dialogs, and common controls
- `examples/event_monitor.cr`: `QTimer` plus `EventWidget` resize, paint, mouse, wheel, and key hooks

## Continuous Integration

GitHub Actions runs the native build, spec suite, and example compilation on both macOS and Linux via `.github/workflows/ci.yml`.

The Linux job uses `xvfb` plus Qt's offscreen platform plugin for headless widget tests. The macOS job installs Homebrew Qt and runs the same specs with `QT_QPA_PLATFORM=offscreen`.

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
- `Qt6::QObject` as the common wrapper base for owned Qt objects
- `Qt6::Signal` for Crystal-side callback composition
- `Qt6::QTimer` for timeout-driven work on the Qt event loop
- `Qt6::Color`, `Qt6::PointF`, `Qt6::Size`, and `Qt6::RectF` for common value types
- `Qt6::Widget` for generic widgets and top-level windows
- `Qt6::MainWindow`, `Qt6::Dialog`, and `Qt6::DockWidget` for desktop application shells
- `Qt6::MessageBox`, `Qt6::FileDialog`, `Qt6::ColorDialog`, and `Qt6::InputDialog` for standard dialogs
- `Qt6::InputDialogInputMode` plus message-box and file-dialog enums for dialog configuration
- `Qt6::MenuBar`, `Qt6::Menu`, `Qt6::ToolBar`, `Qt6::StatusBar`, `Qt6::Action`, and `Qt6::ActionGroup` for shell composition
- `Qt6::KeySequence` and `QAction` shortcuts for keyboard-driven commands
- `Qt6::EventWidget` for custom widget event hooks
- `Qt6::Label` for text display
- `Qt6::PushButton` for push buttons and click callbacks
- `Qt6::LineEdit`, `Qt6::CheckBox`, and `Qt6::ComboBox` for common form controls
- `Qt6::VBoxLayout` for vertical layout composition

## Testing Strategy

The specs cover:

- process shutdown behavior on macOS so teardown stays free of the `QThreadStorage` exit warning
- standard dialog configuration for `QMessageBox`, `QFileDialog`, `QColorDialog`, and `QInputDialog`
- `QObject` destruction signals and `QTimer` timeout delivery
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
- `docs/crystal-qt6-roadmap.md`: phased roadmap for growing `crystal-qt6` toward larger application ports

## Extending The Bindings

The next logical additions are:

1. more layouts such as `HBoxLayout`, grid layouts, and form layouts
2. shell refinements such as shortcuts, action groups, and standard dialogs
3. additional common controls such as radio buttons, list widgets, trees, tabs, and splitters
4. rendering APIs such as `QPainter`, `QImage`, `QPixmap`, and `QPainterPath`
