# crystal-qt6 Guide

This directory contains the source for a longer-form LaTeX guide that can grow into publishable documentation for the shard.

Build the PDF from this directory:

```sh
make
```

or from the repository root:

```sh
make docs-book
```

The guide is intentionally written with screenshot placeholders so it can compile before every image has been captured. Store dialog and example screenshots in `docs/book/images/` using the filenames named by the placeholders in `chapters/05-dialogs.tex`.

Recommended first screenshot set:

- `dialogs-main-window.png`
- `dialogs-message-question.png`
- `dialogs-message-warning.png`
- `dialogs-file-open.png`
- `dialogs-file-save.png`
- `dialogs-color-dialog.png`
- `dialogs-color-alpha.png`
- `dialogs-font-dialog.png`
- `dialogs-font-monospaced.png`
- `dialogs-input-text.png`
- `dialogs-input-int.png`
- `dialogs-input-choice.png`
- `dialogs-progress-dialog.png`
- `dialogs-progress-canceled.png`
- `dialogs-custom-settings.png`

Use `make example-dialogs` to launch the dialog gallery that these screenshots should document.

Deferred chapter ideas are tracked in `TODO.md`.
