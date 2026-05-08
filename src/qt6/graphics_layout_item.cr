module Qt6
  # Dispatch wrapper for `QGraphicsLayoutItem` handles returned from shared APIs.
  abstract class GraphicsLayoutItem < NativeResource
    private ANCHOR_LAYOUT_KIND = 1
    private GRID_LAYOUT_KIND   = 2
    private WIDGET_KIND        = 3

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : GraphicsLayout | GraphicsWidget
      case LibQt6.qt6cr_graphics_layout_item_kind(handle)
      when ANCHOR_LAYOUT_KIND
        GraphicsAnchorLayout.wrap(LibQt6.qt6cr_graphics_layout_item_to_anchor_layout(handle), owned)
      when GRID_LAYOUT_KIND
        GraphicsGridLayout.wrap(LibQt6.qt6cr_graphics_layout_item_to_grid_layout(handle), owned)
      when WIDGET_KIND
        GraphicsWidget.wrap(LibQt6.qt6cr_graphics_layout_item_to_graphics_widget(handle), owned)
      else
        raise Error.new("Unsupported QGraphicsLayoutItem handle")
      end
    end
  end
end
