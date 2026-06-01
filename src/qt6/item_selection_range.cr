module Qt6
  # Wraps `QItemSelectionRange`, one rectangular range inside a `QItemSelection`.
  class ItemSelectionRange < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the top row of the range.
    def top : Int32
      LibQt6.qt6cr_item_selection_range_top(to_unsafe)
    end

    # Returns the bottom row of the range.
    def bottom : Int32
      LibQt6.qt6cr_item_selection_range_bottom(to_unsafe)
    end

    # Returns the left column of the range.
    def left : Int32
      LibQt6.qt6cr_item_selection_range_left(to_unsafe)
    end

    # Returns the right column of the range.
    def right : Int32
      LibQt6.qt6cr_item_selection_range_right(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_item_selection_range_destroy(to_unsafe)
    end
  end
end
