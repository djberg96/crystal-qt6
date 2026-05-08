module Qt6
  # Wraps `QGraphicsLayout` handles shared by concrete graphics layouts.
  abstract class GraphicsLayout < NativeResource
    private ANCHOR_KIND = 1
    private GRID_KIND   = 2

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : GraphicsLayout
      case LibQt6.qt6cr_graphics_layout_kind(handle)
      when ANCHOR_KIND
        GraphicsAnchorLayout.wrap(handle, owned)
      when GRID_KIND
        GraphicsGridLayout.wrap(handle, owned)
      else
        raise Error.new("Unsupported QGraphicsLayout handle")
      end
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the number of layout items currently tracked by the layout.
    def count : Int32
      LibQt6.qt6cr_graphics_layout_count(to_unsafe)
    end

    # Activates the layout and returns `self`.
    def activate : self
      LibQt6.qt6cr_graphics_layout_activate(to_unsafe)
      self
    end

    # Returns `true` when the layout has been activated.
    def activated? : Bool
      LibQt6.qt6cr_graphics_layout_is_activated(to_unsafe)
    end

    # Invalidates cached layout geometry.
    def invalidate : self
      LibQt6.qt6cr_graphics_layout_invalidate(to_unsafe)
      self
    end

    # Notifies the parent widget that this layout's geometry hints changed.
    def update_geometry : self
      LibQt6.qt6cr_graphics_layout_update_geometry(to_unsafe)
      self
    end

    # Removes the layout item at the given linear index.
    def remove_at(index : Int) : self
      LibQt6.qt6cr_graphics_layout_remove_at(to_unsafe, index.to_i)
      self
    end

    # Sets the contents margins and returns `self`.
    def set_contents_margins(left : Number, top : Number, right : Number, bottom : Number) : self
      LibQt6.qt6cr_graphics_layout_set_contents_margins(
        to_unsafe,
        left.to_f64,
        top.to_f64,
        right.to_f64,
        bottom.to_f64
      )
      self
    end

    # Returns the current contents margins.
    def contents_margins : MarginsF
      value = LibQt6.qt6cr_graphics_layout_contents_margins(to_unsafe)
      MarginsF.new(value.left, value.top, value.right, value.bottom)
    end

    # Enables or disables Qt's instant invalidate propagation globally.
    def self.instant_invalidate_propagation=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_layout_set_instant_invalidate_propagation(value)
      value
    end

    # Returns `true` when instant invalidate propagation is enabled globally.
    def self.instant_invalidate_propagation? : Bool
      LibQt6.qt6cr_graphics_layout_instant_invalidate_propagation
    end
  end
end
