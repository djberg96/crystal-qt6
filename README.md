# crystal-qt6

`crystal-qt6` is a Qt6 bindings project for Crystal with a small, explicit first API focused on desktop widgets.

This repository currently provides:

- a native Qt6 bridge compiled from C++
- an idiomatic Crystal wrapper for common widget tasks
- runnable examples
- a spec suite that exercises the wrapper end to end

## Status

This is an initial, working foundation rather than a full binding of the entire Qt6 API. The current surface targets a pragmatic first milestone for building and validating desktop UI bindings on macOS with Homebrew Qt6.

## Requirements

- Crystal 1.11+
- Qt6 Widgets development package available through `pkg-config`
- macOS with Homebrew Qt6 works out of the box when `pkg-config` can resolve `Qt6Widgets`

## Build

Build the native shim:

```sh
make native
```

Run the full test suite:

```sh
make spec
```

Run the examples:

```sh
make example-hello
make example-counter
```

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
- `Qt6::Widget` for generic widgets and top-level windows
- `Qt6::Label` for text display
- `Qt6::PushButton` for push buttons and click callbacks
- `Qt6::VBoxLayout` for vertical layout composition

## Testing Strategy

The specs cover:

- widget lifecycle and visibility state
- title and text round trips through the native bridge
- layout composition
- button click callbacks routed from Qt into Crystal blocks

That gives the project an executable contract for both the C++ shim and the Crystal wrapper.

## Project Layout

- `src/qt6.cr`: public Crystal API
- `src/qt6/native.cr`: FFI declarations
- `ext/qt6cr/include/qt6cr.h`: C ABI for the shim
- `ext/qt6cr/src/qt6cr.cpp`: Qt6 bridge implementation
- `spec/qt6_spec.cr`: end-to-end specs
- `examples/`: sample applications
- `docs/design.md`: architecture notes

## Extending The Bindings

The next logical additions are:

1. more layouts such as `HBoxLayout` and grid layouts
2. richer widgets such as line edits, checkboxes, and menus
3. more signal coverage using the same callback pattern as `PushButton#on_clicked`
4. packaging improvements so the native shim builds automatically as part of the shard workflow
