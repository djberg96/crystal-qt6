# Documentation TODOs

Deferred ideas for the LaTeX guide. These are useful, but not required before continuing to later chapters.

## Chapter 1: Getting Started

- Add a short "What this binding is not yet" note that sets expectations: `crystal-qt6` is a growing Qt Widgets binding, not full PySide6 parity.
- Add a quick project layout tour for readers who want to understand `src/qt6`, `ext/qt6cr`, `examples`, `spec`, and `docs`.
- Add a first-build troubleshooting section covering missing `pkg-config`, missing Qt SVG packages, macOS Qt path issues, and Crystal compiler cache permissions.
- Add a brief note about running GUI tests or examples in headless environments, possibly pointing to CI or an appendix.
- Add a "Next steps" paragraph once Chapters 2 and 3 are fuller, pointing readers toward ownership, widgets/layouts, and dialogs.

## Chapter 2: Object Ownership

- Add a compact ownership table for common wrapper types, such as `Widget`, `Action`, `QTimer`, `QImage`, `QPainter`, `Clipboard`, and status bars.
- Add a short checklist for when to call `release` and when to prefer parent ownership or automatic shutdown.
- Add a note about painter/device lifetime, especially ending or releasing a `QPainter` before reading or saving its target device. This may belong in the painting chapter instead.
- Add a dedicated GUI-thread section if later chapters do not cover threading expectations clearly enough.
- Consider an internal design sidebar about tracked resources being released in reverse creation order. Keep it contributor-oriented so the user-facing lifecycle advice stays simple.

## Chapter 3: Widgets And Layouts

- Add a skim-friendly widget/control reference table, such as `LineEdit` for short text, `ComboBox` for choices, `SpinBox` for bounded integers, and `PlainTextEdit` for multiline text.
- Add a screenshot-backed panel example once screenshots are being captured for the guide.
- Add a short container-widget section covering `TabWidget`, `ScrollArea`, `Splitter`, `GroupBox`, and possibly `StackedWidget`.
- Add a "layout pitfalls" note about avoiding excessive fixed sizes, avoiding manual positioning inside layouts, and letting layout/parent ownership do its job.
- Add a small exercise, such as building a preferences panel or layer inspector, if the book becomes more tutorial-oriented.

## Chapter 4: Application Shells

- Add an action reference table covering text, shortcut, tooltip, status tip, enabled, visible, checkable, checked, and `data`.
- Add menu and toolbar design guidance, including what usually belongs in File/Edit/View/Tools/Help and when a command should not be promoted to a toolbar.
- Add `ToolBar#toggle_view_action` coverage and dock visibility patterns if fuller dock visibility APIs are exposed later.
- Add a shell screenshot once screenshot capture is set up, using either the small shell example or `examples/editor_shell.cr`.
- Add a more complete document-dirty pattern, including modified title state, save enabled state, and status messages. This may fit better near undo/document chapters.
- Add platform-convention notes for macOS vs Linux command naming and placement, such as quit/menu behavior.
