# crystal-qt6 Guide

This directory contains the source for a longer-form LaTeX guide that can grow into publishable documentation for the shard.

The current guide text is aligned with the `0.11.0` release surface.

Build the PDF from this directory:

```sh
make
```

or from the repository root:

```sh
make docs-book
```

The guide is intentionally written with screenshot placeholders so it can compile before every image has been captured. Store screenshots in `docs/book/images/` using the filenames named by the chapter figures and placeholders.

The guide now includes dedicated Graphics View and Styles chapters alongside the existing widgets/layouts, dialog, model/view, painting, and worked-example material.

Recommended screenshot refresh set:

- `styles-workbench.png`
- `styles-style-painter.png`
- `graphics-view-overview.png`
- `graphics-view-floating-panel.png`
- `graphics-view-transforms.png`

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

Refresh the graphics-view captures with:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/capture_graphics_view_screenshots.cr
```

Refresh the styles captures with:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/capture_style_screenshots.cr
```

Refresh the dialog gallery captures with:

```sh
make example-dialogs
```

When replacing placeholders with real screenshots, keep the theme and window size consistent across a chapter. The book Makefile tracks `docs/book/images/*.png`, so replacing a screenshot and rerunning `make docs-book` rebuilds the PDF. If you add a new image format or store generated screenshots elsewhere, update `docs/book/Makefile` so image changes remain visible to the build.

Deferred chapter ideas are tracked in `TODO.md`.
