module Qt6
  # Read-only wrapper for `QStyleOptionViewItem` values passed to item delegates.
  class StyleOptionViewItem < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_view_item_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def text_rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_view_item_text_rect(to_unsafe))
    end

    def font : QFont
      QFont.wrap(LibQt6.qt6cr_style_option_view_item_font(to_unsafe), true)
    end

    def selected? : Bool
      LibQt6.qt6cr_style_option_view_item_selected(to_unsafe)
    end

    def enabled? : Bool
      LibQt6.qt6cr_style_option_view_item_enabled(to_unsafe)
    end

    def draw_background(painter : QPainter) : self
      LibQt6.qt6cr_style_option_view_item_draw_background(to_unsafe, painter.to_unsafe)
      self
    end

    def draw_decoration(painter : QPainter) : self
      LibQt6.qt6cr_style_option_view_item_draw_decoration(to_unsafe, painter.to_unsafe)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_view_item_destroy(to_unsafe)
    end
  end
end
