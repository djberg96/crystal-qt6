module Qt6
  # Wraps `QUndoView` for browsing and activating undo history.
  class UndoView < ListView
    @stack : UndoStack?
    @group : UndoGroup?

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates an undo view with an optional parent widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_undo_view_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?, false)
    end

    # Creates an undo view bound to a specific undo stack.
    def initialize(stack : UndoStack, parent : Widget? = nil)
      @stack = stack
      @group = nil
      super(LibQt6.qt6cr_undo_view_create_with_stack(stack.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?, false)
    end

    # Creates an undo view bound to a shared undo group.
    def initialize(group : UndoGroup, parent : Widget? = nil)
      @stack = nil
      @group = group
      super(LibQt6.qt6cr_undo_view_create_with_group(group.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?, false)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned, false)
    end

    # Returns the undo stack currently displayed by the view, if any.
    def stack : UndoStack?
      handle = LibQt6.qt6cr_undo_view_stack(to_unsafe)
      return @stack = nil if handle.null?

      @stack = UndoStack.wrap(handle) if @stack.nil? || @stack.not_nil!.to_unsafe != handle
      @stack
    end

    # Returns the undo group currently displayed by the view, if any.
    def group : UndoGroup?
      handle = LibQt6.qt6cr_undo_view_group(to_unsafe)
      return @group = nil if handle.null?

      @group = UndoGroup.wrap(handle) if @group.nil? || @group.not_nil!.to_unsafe != handle
      @group
    end

    # Returns the placeholder label shown when the history is empty.
    def empty_label : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_undo_view_empty_label(to_unsafe))
    end

    # Sets the placeholder label shown when the history is empty.
    def empty_label=(value : String) : String
      LibQt6.qt6cr_undo_view_set_empty_label(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the icon used to mark the clean state in the history view.
    def clean_icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_undo_view_clean_icon(to_unsafe), true)
    end

    # Sets the icon used to mark the clean state in the history view.
    def clean_icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_undo_view_set_clean_icon(to_unsafe, value.to_unsafe)
      value
    end

    # Retargets the view to a specific undo stack.
    def stack=(value : UndoStack?) : UndoStack?
      LibQt6.qt6cr_undo_view_set_stack(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      @stack = value
      @group = nil
      value
    end

    # Retargets the view to a shared undo group.
    def group=(value : UndoGroup?) : UndoGroup?
      LibQt6.qt6cr_undo_view_set_group(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      @group = value
      @stack = nil
      value
    end

    # Qt-style alias for `stack=`.
    def set_stack(value : UndoStack?) : self
      self.stack = value
      self
    end

    # Qt-style alias for `group=`.
    def set_group(value : UndoGroup?) : self
      self.group = value
      self
    end

    # Qt-style alias for `empty_label=`.
    def set_empty_label(value : String) : self
      self.empty_label = value
      self
    end

    # Qt-style alias for `clean_icon=`.
    def set_clean_icon(value : QIcon) : self
      self.clean_icon = value
      self
    end
  end
end
