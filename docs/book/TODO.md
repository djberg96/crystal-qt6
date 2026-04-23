# Documentation TODOs

Deferred ideas for the LaTeX guide. These are useful, but not required before continuing to later chapters.

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
