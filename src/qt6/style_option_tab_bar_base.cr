module Qt6
  # Wraps `QStyleOptionTabBarBase` for tab-bar base paint geometry.
  class StyleOptionTabBarBase < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_tab_bar_base_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def shape : TabBarShape
      TabBarShape.from_value(LibQt6.qt6cr_style_option_tab_bar_base_shape(to_unsafe))
    end

    def shape=(value : TabBarShape) : TabBarShape
      LibQt6.qt6cr_style_option_tab_bar_base_set_shape(to_unsafe, value.value)
      value
    end

    def tab_bar_rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_tab_bar_base_tab_bar_rect(to_unsafe))
    end

    def tab_bar_rect=(value : Rect) : Rect
      LibQt6.qt6cr_style_option_tab_bar_base_set_tab_bar_rect(to_unsafe, value.to_native)
      value
    end

    def tab_bar_rect=(value : RectF) : RectF
      LibQt6.qt6cr_style_option_tab_bar_base_set_tab_bar_rect(to_unsafe, value.to_rect.to_native)
      value
    end

    def selected_tab_rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_tab_bar_base_selected_tab_rect(to_unsafe))
    end

    def selected_tab_rect=(value : Rect) : Rect
      LibQt6.qt6cr_style_option_tab_bar_base_set_selected_tab_rect(to_unsafe, value.to_native)
      value
    end

    def selected_tab_rect=(value : RectF) : RectF
      LibQt6.qt6cr_style_option_tab_bar_base_set_selected_tab_rect(to_unsafe, value.to_rect.to_native)
      value
    end

    def document_mode? : Bool
      LibQt6.qt6cr_style_option_tab_bar_base_document_mode(to_unsafe)
    end

    def document_mode=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_tab_bar_base_set_document_mode(to_unsafe, value)
      value
    end

    def init_from(tab_bar : TabBar) : self
      init_from(tab_bar, tab_bar.current_index)
    end

    def init_from(tab_bar : TabBar, selected_index : Int) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, tab_bar.to_unsafe)
      LibQt6.qt6cr_tab_bar_init_style_option_base(tab_bar.to_unsafe, selected_index.to_i32, to_unsafe)
      self
    end

    def set_shape(value : TabBarShape) : self
      self.shape = value
      self
    end

    def set_tab_bar_rect(value : Rect | RectF) : self
      self.tab_bar_rect = value
      self
    end

    def set_selected_tab_rect(value : Rect | RectF) : self
      self.selected_tab_rect = value
      self
    end

    def set_document_mode(value : Bool) : self
      self.document_mode = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_tab_bar_base_destroy(to_unsafe)
    end
  end
end
