# Screenshot Assets

Store PNG screenshots for the LaTeX guide in this directory.

The current guide uses build-safe placeholders, so missing images do not block compilation. Replace placeholders with `\includegraphics` calls as screenshots become stable enough for release documentation.

Chapter 5 expects a first screenshot pass for:

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

Chapters 7, 8, and 10 use generated painter figures. Refresh them with:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/generate_painting_figures.cr
```

- `painting-painter-state.png`
- `painting-paths.png`
- `painting-export-targets.png`
- `images-pipeline.png`
- `images-io-clipboard.png`
- `model-view-architecture.png`
- `model-view-choices.png`
- `model-view-proxy-selection.png`

Chapter 10 also uses live widget grabs. Refresh them with:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/capture_model_view_widget_screenshots.cr
```

- `model-view-list-widget.png`
- `model-view-tree-widget.png`
- `model-view-table-view.png`
- `model-view-tree-view-headers.png`
- `model-view-table-headers.png`

Chapter 11 uses live widget grabs from the worked example. Refresh them with:

```sh
CRYSTAL_CACHE_DIR=/tmp/crystal-cache crystal run scripts/capture_worked_example_screenshots.cr
```

The script uses ImageMagick's `magick` command to flatten transparent widget grabs for PDF output.

- `putting-together-editor-shell.png`
- `putting-together-canvas.png`
- `putting-together-layers-dock.png`
- `putting-together-inspector-dock.png`
