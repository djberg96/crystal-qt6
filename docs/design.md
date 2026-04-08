# Design Notes

`crystal-qt6` uses a thin C++ shim over Qt6 Widgets because Crystal can bind to C ABIs directly, but not to the C++ Qt ABI itself.

The repository is split into three layers:

1. `ext/qt6cr/src/qt6cr.cpp`: the native bridge that translates a focused C API into Qt calls.
2. `src/qt6/native.cr`: Crystal FFI declarations for the bridge.
3. `src/qt6.cr`: the programmer-facing API.

The first milestone keeps the surface area intentionally small:

- `Qt6.application`
- `Qt6.window`
- `Qt6::Widget`
- `Qt6::Label`
- `Qt6::PushButton`
- `Qt6::VBoxLayout`

That is enough to validate the architecture, support real examples, and keep the extension path obvious for additional widgets and signals.
