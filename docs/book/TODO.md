# Documentation TODOs

Deferred ideas for the LaTeX guide. These are useful, but not required before continuing to later chapters.

## Chapter 5: Dialogs

- Revisit the full chapter layout after the first screenshot pass. Tune float placement, code/example ordering, figure sizes, page breaks, and whether related screenshots should be grouped into shared figure blocks.
- Expand the dialog gallery application beyond the current first-pass screenshots. Candidates include information and critical message boxes, multi-file open dialogs, directory selection, double input dialogs, editable item input dialogs, splash screens, and richer custom dialogs.
- Improve screenshot automation for native modal dialogs. The current capture workflow works, but native dialogs may need foreground launches or manual recapture on macOS.
- Consider refreshing the dialog screenshots with a consistent light/dark theme decision, window scale, and crop style before publication.

## Chapter 6: Signals And Events

- Add a compact note on `block_signals=` and `signals_blocked?` for bulk UI updates where intermediate value changes should not emit callbacks.
- Add a more visible event-object lifetime callout, especially for live wrappers such as `DropEvent` and `QEvent`.
- Consider a small combined example that uses an `Action`, `QTimer`, and `EventWidget` together; this might fit better in the worked example chapter.
- Add GUI-thread and background-work guidance if the binding grows thread helpers later.

## Chapter 7: Painting And Vector Geometry

- Add a compact "common mistakes" box: storing the paint-callback painter, forgetting `save`/`restore`, saving a target before the painter is released, and painting from input callbacks instead of calling `update`.
- Add a target-choice table comparing `QImage`, `QPixmap`, `QSvgGenerator`, and `QPdfWriter`.
- Add coordinate-system and high-DPI guidance if the binding exposes more device-pixel-ratio APIs later.
- Consider expanding the PNG/SVG/PDF export section into a full runnable listing.

## Chapter 8: Images And Pixmaps

- Add a compact "common mistakes" note: wrong raw byte order, forgetting to check `null?`, stretching thumbnails with `AspectRatioMode::Ignore`, and converting to `QPixmap` too early when pixel access is still needed.
- Add a fuller image import/export mini-example, possibly based on `examples/desktop_editor_showcase.cr`.
- Add a short format-support note that exact readable formats depend on Qt plugins and platform installation, so `QImageReader#can_read?` is the source of truth.
- Add writer quality, compression, and metadata coverage if later APIs expose image writer options.

## Chapter 9: Undo And Redo

- Add a small stack-history figure showing commands, the current index, the clean index, and where redo history is discarded after a new command is pushed.
- Add a runnable mini-example, such as a small layer list or property editor, that demonstrates command labels, dirty state, menu actions, and grouped changes in one place.
- Add a macro helper pattern that guarantees `end_macro` runs, possibly with an `ensure` block or a small wrapper method.
- Add command compression/merge guidance if the binding later exposes `QUndoCommand#id`, `mergeWith`, or equivalent Crystal APIs.
- Add multi-document undo guidance if an `UndoGroup`/`QUndoGroup` wrapper is added later.

## Chapter 10: Model/View

- Consider a delegate-editing screenshot that shows a cell editor open inside a view, if persistent editor behavior becomes worth emphasizing visually.
- Consider a drag/drop or row-reordering screenshot pair if the chapter later expands that section beyond the current overview.
- Consider one full `examples/model_view_workbench.cr` screenshot near the end if the chapter needs a larger "all pieces together" visual.

## Chapter 11: Putting It All Together

- Add a compact "reader exercise" at the end that asks readers to add one new layer property, wire it into the inspector, repaint the canvas, and export the result.
- Consider a second-pass section showing drag/drop, editable layer rows, and object movement commands after the current undo/settings/clipboard pass has settled.
- Add a short "from example to app" checklist covering document state, dirty tracking, command enablement, save/export paths, and teardown/release checks.
- Consider one annotated architecture figure that maps the running screenshot to source regions in `examples/editor_vertical_slice.cr`.
- If the example grows, add a small screenshot or note for the export/save-file flow so the `Widget#grab` path is visible as a complete user workflow.
