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
