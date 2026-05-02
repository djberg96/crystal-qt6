module Qt6
  # Minimal wrapper for `QGraphicsItem` handles.
  class GraphicsItem < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` when the item is visible.
    def visible? : Bool
      LibQt6.qt6cr_graphics_item_is_visible(to_unsafe)
    end

    # Shows or hides the item.
    def visible=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_item_set_visible(to_unsafe, value)
      value
    end

    # Shows the item and returns `self`.
    def show : self
      self.visible = true
      self
    end

    # Hides the item and returns `self`.
    def hide : self
      self.visible = false
      self
    end

    # Returns `true` when the item is enabled.
    def enabled? : Bool
      LibQt6.qt6cr_graphics_item_is_enabled(to_unsafe)
    end

    # Enables or disables the item.
    def enabled=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_item_set_enabled(to_unsafe, value)
      value
    end

    # Returns the item opacity.
    def opacity : Float64
      LibQt6.qt6cr_graphics_item_opacity(to_unsafe)
    end

    # Sets the item opacity and returns it.
    def opacity=(value : Number) : Float64
      opacity = value.to_f64
      LibQt6.qt6cr_graphics_item_set_opacity(to_unsafe, opacity)
      opacity
    end

    # Returns the parent graphics item, if present.
    def parent_item : GraphicsItem?
      handle = LibQt6.qt6cr_graphics_item_parent_item(to_unsafe)
      handle.null? ? nil : GraphicsItem.wrap(handle)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_item_destroy(to_unsafe)
    end
  end
end
