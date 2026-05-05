module Qt6
  # Shared wrapper for `QAbstractItemView` descendants.
  abstract class AbstractItemView < AbstractScrollArea
    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the underlying model used by the view, if any.
    def model : AbstractItemModel?
      handle = LibQt6.qt6cr_abstract_item_view_model(to_unsafe)
      handle.null? ? nil : AbstractItemModel.wrap(handle)
    end

    # Returns the current Crystal-backed item delegate, if one is installed.
    def item_delegate : StyledItemDelegate?
      handle = LibQt6.qt6cr_abstract_item_view_item_delegate(to_unsafe)
      handle.null? ? nil : StyledItemDelegate.wrap(handle)
    end

    # Assigns the item delegate used for display/edit behavior.
    def item_delegate=(delegate : StyledItemDelegate) : StyledItemDelegate
      LibQt6.qt6cr_abstract_item_view_set_item_delegate(to_unsafe, delegate.to_unsafe)
      delegate
    end

    # Returns the icon size used for item decorations.
    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_abstract_item_view_icon_size(to_unsafe))
    end

    # Sets the icon size used for item decorations.
    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_abstract_item_view_set_icon_size(to_unsafe, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    # Returns the active selection model, if one is installed.
    def selection_model : ItemSelectionModel?
      handle = LibQt6.qt6cr_abstract_item_view_selection_model(to_unsafe)
      handle.null? ? nil : ItemSelectionModel.wrap(handle)
    end

    # Assigns the selection model used by the view and returns it.
    def selection_model=(selection_model : ItemSelectionModel) : ItemSelectionModel
      LibQt6.qt6cr_abstract_item_view_set_selection_model(to_unsafe, selection_model.to_unsafe)
      selection_model
    end

    # Returns the current root model index.
    def root_index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_abstract_item_view_root_index(to_unsafe), true)
    end

    # Changes the root model index and returns it.
    def root_index=(index : ModelIndex) : ModelIndex
      LibQt6.qt6cr_abstract_item_view_set_root_index(to_unsafe, index.to_unsafe)
      index
    end

    # Returns the current model index.
    def current_index : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_abstract_item_view_current_index(to_unsafe), true)
    end

    # Changes the current model index and returns it.
    def current_index=(index : ModelIndex) : ModelIndex
      LibQt6.qt6cr_abstract_item_view_set_current_index(to_unsafe, index.to_unsafe)
      index
    end

    # Returns the current selection mode.
    def selection_mode : ItemSelectionMode
      ItemSelectionMode.from_value(LibQt6.qt6cr_abstract_item_view_selection_mode(to_unsafe))
    end

    # Sets the current selection mode.
    def selection_mode=(value : ItemSelectionMode) : ItemSelectionMode
      LibQt6.qt6cr_abstract_item_view_set_selection_mode(to_unsafe, value.value)
      value
    end

    # Returns the edit triggers currently enabled for the view.
    def edit_triggers : EditTrigger
      EditTrigger.from_value(LibQt6.qt6cr_abstract_item_view_edit_triggers(to_unsafe))
    end

    # Sets the edit triggers enabled for the view.
    def edit_triggers=(value : EditTrigger) : EditTrigger
      LibQt6.qt6cr_abstract_item_view_set_edit_triggers(to_unsafe, value.value)
      value
    end

    # Returns how selections expand within the view.
    def selection_behavior : ItemSelectionBehavior
      ItemSelectionBehavior.from_value(LibQt6.qt6cr_abstract_item_view_selection_behavior(to_unsafe))
    end

    # Sets how selections expand within the view.
    def selection_behavior=(value : ItemSelectionBehavior) : ItemSelectionBehavior
      LibQt6.qt6cr_abstract_item_view_set_selection_behavior(to_unsafe, value.value)
      value
    end

    # Returns whether edge-triggered auto-scrolling is enabled during drags.
    def auto_scroll? : Bool
      LibQt6.qt6cr_abstract_item_view_auto_scroll(to_unsafe)
    end

    # Enables or disables edge-triggered auto-scrolling during drags.
    def auto_scroll=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_item_view_set_auto_scroll(to_unsafe, value)
      value
    end

    # Returns the auto-scroll trigger margin in pixels.
    def auto_scroll_margin : Int32
      LibQt6.qt6cr_abstract_item_view_auto_scroll_margin(to_unsafe)
    end

    # Sets the auto-scroll trigger margin in pixels.
    def auto_scroll_margin=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_abstract_item_view_set_auto_scroll_margin(to_unsafe, int_value)
      int_value
    end

    # Returns whether Tab moves focus within the item view.
    def tab_key_navigation? : Bool
      LibQt6.qt6cr_abstract_item_view_tab_key_navigation(to_unsafe)
    end

    # Enables or disables Tab key navigation within the item view.
    def tab_key_navigation=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_item_view_set_tab_key_navigation(to_unsafe, value)
      value
    end

    # Returns whether alternating row colors are enabled.
    def alternating_row_colors? : Bool
      LibQt6.qt6cr_abstract_item_view_alternating_row_colors(to_unsafe)
    end

    # Enables or disables alternating row colors.
    def alternating_row_colors=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_item_view_set_alternating_row_colors(to_unsafe, value)
      value
    end

    # Returns whether the view can start drag operations.
    def drag_enabled? : Bool
      LibQt6.qt6cr_abstract_item_view_drag_enabled(to_unsafe)
    end

    # Enables or disables drag initiation from the view.
    def drag_enabled=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_item_view_set_drag_enabled(to_unsafe, value)
      value
    end

    # Returns the current model/view drag/drop mode.
    def drag_drop_mode : ItemViewDragDropMode
      ItemViewDragDropMode.from_value(LibQt6.qt6cr_abstract_item_view_drag_drop_mode(to_unsafe))
    end

    # Sets the current model/view drag/drop mode.
    def drag_drop_mode=(value : ItemViewDragDropMode) : ItemViewDragDropMode
      LibQt6.qt6cr_abstract_item_view_set_drag_drop_mode(to_unsafe, value.value)
      value
    end

    # Returns whether drops overwrite existing items instead of inserting between them.
    def drag_drop_overwrite_mode? : Bool
      LibQt6.qt6cr_abstract_item_view_drag_drop_overwrite_mode(to_unsafe)
    end

    # Enables or disables overwrite-style dropping for the view.
    def drag_drop_overwrite_mode=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_item_view_set_drag_drop_overwrite_mode(to_unsafe, value)
      value
    end

    # Returns the default drop action used by the view.
    def default_drop_action : DropAction
      DropAction.from_value(LibQt6.qt6cr_abstract_item_view_default_drop_action(to_unsafe))
    end

    # Sets the default drop action used by the view.
    def default_drop_action=(value : DropAction) : DropAction
      LibQt6.qt6cr_abstract_item_view_set_default_drop_action(to_unsafe, value.value)
      value
    end

    # Returns whether the drop indicator is shown while dragging.
    def drop_indicator_shown? : Bool
      LibQt6.qt6cr_abstract_item_view_drop_indicator_shown(to_unsafe)
    end

    # Shows or hides the drop indicator while dragging.
    def drop_indicator_shown=(value : Bool) : Bool
      LibQt6.qt6cr_abstract_item_view_set_drop_indicator_shown(to_unsafe, value)
      value
    end

    # Returns the view's borrowed viewport widget.
    def viewport : Widget
      Widget.wrap(LibQt6.qt6cr_abstract_item_view_viewport(to_unsafe))
    end

    # Returns the model index under the given viewport-local position.
    def index_at(position : PointF) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_abstract_item_view_index_at(to_unsafe, position.to_native), true)
    end

    # Returns the viewport-local rectangle for the given model index.
    def visual_rect(index : ModelIndex) : RectF
      RectF.from_native(LibQt6.qt6cr_abstract_item_view_visual_rect(to_unsafe, index.to_unsafe))
    end

    # Scrolls the view so the given index is visible with the requested hint.
    def scroll_to(index : ModelIndex, hint : ScrollHint = ScrollHint::EnsureVisible) : self
      LibQt6.qt6cr_abstract_item_view_scroll_to(to_unsafe, index.to_unsafe, hint.value)
      self
    end

    # Scrolls the view to its first visible item.
    def scroll_to_top : self
      LibQt6.qt6cr_abstract_item_view_scroll_to_top(to_unsafe)
      self
    end

    # Scrolls the view to its last visible item.
    def scroll_to_bottom : self
      LibQt6.qt6cr_abstract_item_view_scroll_to_bottom(to_unsafe)
      self
    end

    # Selects all items according to the current selection behavior.
    def select_all : self
      LibQt6.qt6cr_abstract_item_view_select_all(to_unsafe)
      self
    end

    # Clears the current selection without changing the model or delegate.
    def clear_selection : self
      LibQt6.qt6cr_abstract_item_view_clear_selection(to_unsafe)
      self
    end

    # Opens a persistent editor for the given index.
    def open_persistent_editor(index : ModelIndex) : self
      LibQt6.qt6cr_abstract_item_view_open_persistent_editor(to_unsafe, index.to_unsafe)
      self
    end

    # Closes a persistent editor for the given index.
    def close_persistent_editor(index : ModelIndex) : self
      LibQt6.qt6cr_abstract_item_view_close_persistent_editor(to_unsafe, index.to_unsafe)
      self
    end

    # Returns whether a persistent editor is open for the given index.
    def persistent_editor_open?(index : ModelIndex) : Bool
      LibQt6.qt6cr_abstract_item_view_is_persistent_editor_open(to_unsafe, index.to_unsafe)
    end
  end
end
