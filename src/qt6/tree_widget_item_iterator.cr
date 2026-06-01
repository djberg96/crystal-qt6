module Qt6
  # Wraps `QTreeWidgetItemIterator` for hierarchical item traversal.
  class TreeWidgetItemIterator < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an iterator over a tree widget.
    def initialize(widget : TreeWidget, flags : TreeWidgetItemIteratorFlag = TreeWidgetItemIteratorFlag::All)
      super(LibQt6.qt6cr_tree_widget_item_iterator_create_for_widget(widget.to_unsafe, normalize_flags(flags)))
    end

    # Creates an iterator rooted at the given item.
    def initialize(item : TreeWidgetItem, flags : TreeWidgetItemIteratorFlag = TreeWidgetItemIteratorFlag::All)
      super(LibQt6.qt6cr_tree_widget_item_iterator_create_for_item(item.to_unsafe, normalize_flags(flags)))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current item, or `nil` when traversal is exhausted.
    def item : TreeWidgetItem?
      handle = LibQt6.qt6cr_tree_widget_item_iterator_value(to_unsafe)
      handle.null? ? nil : TreeWidgetItem.wrap(handle)
    end

    # Returns `true` when there is no current item.
    def ended? : Bool
      item.nil?
    end

    # Advances the iterator by one step.
    def next : self
      LibQt6.qt6cr_tree_widget_item_iterator_next(to_unsafe)
      self
    end

    # Moves the iterator back by one step.
    def previous : self
      LibQt6.qt6cr_tree_widget_item_iterator_previous(to_unsafe)
      self
    end

    # Advances the iterator by the given number of steps.
    def advance(count : Int) : self
      LibQt6.qt6cr_tree_widget_item_iterator_advance(to_unsafe, count.to_i32)
      self
    end

    # Rewinds the iterator by the given number of steps.
    def rewind(count : Int) : self
      LibQt6.qt6cr_tree_widget_item_iterator_rewind(to_unsafe, count.to_i32)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_tree_widget_item_iterator_destroy(to_unsafe)
    end

    # Qt uses `0` for "all items", but Crystal's auto-generated flags `All`
    # means "every bit set". Normalize that back to Qt's meaning here.
    private def normalize_flags(flags : TreeWidgetItemIteratorFlag) : Int32
      flags == TreeWidgetItemIteratorFlag::All ? TreeWidgetItemIteratorFlag::None.value : flags.value
    end
  end
end
