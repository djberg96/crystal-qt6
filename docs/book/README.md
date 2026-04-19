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
- `dialogs-message-box.png`
- `dialogs-file-dialog.png`
- `dialogs-color-dialog.png`
- `dialogs-font-dialog.png`
- `dialogs-input-dialog.png`
- `dialogs-progress-dialog.png`

Use `make example-dialogs` to launch the dialog gallery that these screenshots should document.
