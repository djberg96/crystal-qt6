# Guide Image Assets

This directory contains the PNG assets used by the LaTeX guide. These files are
part of the documentation source: `docs/book/Makefile` tracks `images/*.png`,
so changing a screenshot or generated figure should trigger a PDF rebuild.

Most assets should be reproducible from scripts. Prefer updating the capture or
generation script over hand-editing PNGs, then refresh the image from the script
and review the resulting PDF.

## Naming

Use a chapter-oriented prefix when adding images:

- `widgets-*` for Chapter 3 widget and layout examples.
- `application-shell-*` for Chapter 4 main window examples.
- `dialogs-*` for Chapter 5 dialog screenshots.
- `painting-*` for Chapter 7 generated painting figures.
- `images-*` for Chapter 8 image workflow figures.
- `model-view-*` for Chapter 10 model/view figures and screenshots.
- `putting-together-*` for Chapter 11 worked-example screenshots.

Keep names descriptive and stable, since the `.tex` files reference them
directly.

## Generated Figures

Refresh the generated diagram-style figures with:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/generate_painting_figures.cr
```

This script currently maintains:

- `painting-painter-state.png`
- `painting-paths.png`
- `painting-export-targets.png`
- `images-pipeline.png`
- `images-io-clipboard.png`
- `model-view-architecture.png`
- `model-view-choices.png`
- `model-view-proxy-selection.png`

## Live Widget Captures

The widget screenshots are captured from small Qt examples. Use
`CRYSTAL_CACHE_DIR=/tmp/crystal-cache` when you want Crystal build artifacts to
stay out of the repository tree.

Chapter 3:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/capture_widgets_layouts_screenshots.cr
```

- `widgets-layer-inspector-panel.png`

Chapter 4:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/capture_application_shell_screenshots.cr
```

- `application-shell-main-window.png`

Chapter 10:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/capture_model_view_widget_screenshots.cr
```

- `model-view-delegate-editor.png`
- `model-view-list-widget.png`
- `model-view-row-reorder-after.png`
- `model-view-row-reorder-before.png`
- `model-view-table-headers.png`
- `model-view-table-view.png`
- `model-view-tree-view-headers.png`
- `model-view-tree-widget.png`
- `model-view-workbench.png`

Chapter 11:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/capture_worked_example_screenshots.cr
```

- `putting-together-architecture-map.png`
- `putting-together-canvas.png`
- `putting-together-editor-shell.png`
- `putting-together-inspector-dock.png`
- `putting-together-layers-dock.png`

Some captures use ImageMagick's `magick` command to flatten transparent output.
Install ImageMagick if a script reports that dependency.

## Native Dialog Captures

Chapter 5 uses native macOS dialog screenshots. Refresh them with:

```sh
./scripts/capture_dialog_screenshots.sh
```

The script builds and runs the dialog gallery, then captures windows with
`screencapture`. macOS must grant Screen Recording permission to the terminal or
editor process running the script. When the optional Quartz/Python helper is
available, the script captures the target window directly; otherwise it falls
back to the configured `SCREENSHOT_REGION`.

The dialog capture set currently includes:

- `dialogs-color-alpha.png`
- `dialogs-color-dialog.png`
- `dialogs-custom-settings.png`
- `dialogs-file-open.png`
- `dialogs-file-save.png`
- `dialogs-font-dialog.png`
- `dialogs-font-monospaced.png`
- `dialogs-input-choice.png`
- `dialogs-input-int.png`
- `dialogs-input-text.png`
- `dialogs-main-window.png`
- `dialogs-message-question.png`
- `dialogs-message-warning.png`
- `dialogs-progress-canceled.png`
- `dialogs-progress-dialog.png`

## After Refreshing Images

After changing any image, rebuild the guide and inspect the affected pages:

```sh
make -C docs/book -B
```

If an image is added, renamed, or removed, update both the relevant chapter file
and this README so the asset list stays accurate.
