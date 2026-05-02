module Qt6
  # Wraps `QColumnView` for Finder-style hierarchical browsing.
  class ColumnView < AbstractItemView
    @current_index_changed : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_index_changed : Signal()

    # Creates a column view with an optional parent.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_column_view_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_column_view_on_current_index_changed(to_unsafe, CURRENT_INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    # Assigns the backing model and returns it.
    def model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_column_view_set_model(to_unsafe, model.to_unsafe)
      model
    end

    # Returns the current root index.
    def root_index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_column_view_root_index(to_unsafe), true)
    end

    # Changes the root index and returns it.
    def root_index=(index : ModelIndex) : ModelIndex
      LibQt6.qt6cr_column_view_set_root_index(to_unsafe, index.to_unsafe)
      index
    end

    # Returns `true` when resize grips are shown between columns.
    def resize_grips_visible? : Bool
      LibQt6.qt6cr_column_view_resize_grips_visible(to_unsafe)
    end

    # Shows or hides the resize grips.
    def resize_grips_visible=(value : Bool) : Bool
      LibQt6.qt6cr_column_view_set_resize_grips_visible(to_unsafe, value)
      value
    end

    # Returns `true` when the preview column is visible.
    def preview_column_visible? : Bool
      LibQt6.qt6cr_column_view_preview_column_visible(to_unsafe)
    end

    # Shows or hides the preview column.
    def preview_column_visible=(value : Bool) : Bool
      LibQt6.qt6cr_column_view_set_preview_column_visible(to_unsafe, value)
      value
    end

    # Returns the preview widget, if present.
    def preview_widget : Widget?
      handle = LibQt6.qt6cr_column_view_preview_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Sets or clears the preview widget.
    def preview_widget=(widget : Widget?) : Widget?
      LibQt6.qt6cr_column_view_set_preview_widget(to_unsafe, widget.try(&.to_unsafe) || Pointer(Void).null)
      widget.try(&.adopt_by_parent!)
      widget
    end

    # Returns the configured per-column widths.
    def column_widths : Array(Int32)
      Qt6.copy_and_release_ints(LibQt6.qt6cr_column_view_column_widths(to_unsafe))
    end

    # Replaces the configured per-column widths and returns them.
    def column_widths=(values : Enumerable(Int)) : Array(Int32)
      widths = values.map(&.to_i32).to_a
      LibQt6.qt6cr_column_view_set_column_widths(
        to_unsafe,
        widths.empty? ? Pointer(Int32).null : widths.to_unsafe,
        widths.size
      )
      widths
    end

    # Registers a block to run when the current index changes.
    def on_current_index_changed(&block : ->) : self
      @current_index_changed.connect { block.call }
      self
    end

    protected def emit_current_index_changed : Nil
      @current_index_changed.emit
    end

    private CURRENT_INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(ColumnView).unbox(userdata).emit_current_index_changed
    end
  end
end
