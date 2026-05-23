module Qt6
  # Wraps shared `QStyleOption` state used by styles and delegates.
  class StyleOption < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : StyleOption
      case LibQt6.qt6cr_style_option_type(handle)
      when StyleOptionType::Button.value
        StyleOptionButton.wrap(handle, owned)
      when StyleOptionType::MenuItem.value
        if LibQt6.qt6cr_style_option_version(handle) >= 2
          StyleOptionMenuItemV2.wrap(handle, owned)
        else
          StyleOptionMenuItem.wrap(handle, owned)
        end
      when StyleOptionType::ProgressBar.value
        StyleOptionProgressBar.wrap(handle, owned)
      when StyleOptionType::RubberBand.value
        StyleOptionRubberBand.wrap(handle, owned)
      when StyleOptionType::SizeGrip.value
        StyleOptionSizeGrip.wrap(handle, owned)
      when StyleOptionType::DockWidget.value
        StyleOptionDockWidget.wrap(handle, owned)
      when StyleOptionType::Frame.value
        StyleOptionFrame.wrap(handle, owned)
      when StyleOptionType::FocusRect.value
        StyleOptionFocusRect.wrap(handle, owned)
      when StyleOptionType::GraphicsItem.value
        StyleOptionGraphicsItem.wrap(handle, owned)
      when StyleOptionType::GroupBox.value
        StyleOptionGroupBox.wrap(handle, owned)
      when StyleOptionType::Header.value
        if LibQt6.qt6cr_style_option_version(handle) >= 2
          StyleOptionHeaderV2.wrap(handle, owned)
        else
          StyleOptionHeader.wrap(handle, owned)
        end
      when StyleOptionType::Complex.value
        StyleOptionComplex.wrap(handle, owned)
      when StyleOptionType::ComboBox.value
        StyleOptionComboBox.wrap(handle, owned)
      when StyleOptionType::ViewItem.value
        StyleOptionViewItem.wrap(handle, owned)
      else
        new(handle, owned)
      end
    end

    def initialize
      super(LibQt6.qt6cr_style_option_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def version : Int32
      LibQt6.qt6cr_style_option_version(to_unsafe)
    end

    def version=(value : Int) : Int32
      typed_value = value.to_i32
      LibQt6.qt6cr_style_option_set_version(to_unsafe, typed_value)
      typed_value
    end

    def type : StyleOptionType
      StyleOptionType.from_value(LibQt6.qt6cr_style_option_type(to_unsafe))
    end

    def type=(value : StyleOptionType) : StyleOptionType
      LibQt6.qt6cr_style_option_set_type(to_unsafe, value.value)
      value
    end

    def state : StyleStateFlag
      StyleStateFlag.from_value(LibQt6.qt6cr_style_option_state(to_unsafe))
    end

    def state=(value : StyleStateFlag) : StyleStateFlag
      LibQt6.qt6cr_style_option_set_state(to_unsafe, value.value)
      value
    end

    def direction : LayoutDirection
      LayoutDirection.from_value(LibQt6.qt6cr_style_option_direction(to_unsafe))
    end

    def direction=(value : LayoutDirection) : LayoutDirection
      LibQt6.qt6cr_style_option_set_direction(to_unsafe, value.value)
      value
    end

    def rect : RectF
      RectF.from_native(LibQt6.qt6cr_style_option_rect(to_unsafe))
    end

    def rect=(value : Rect) : Rect
      LibQt6.qt6cr_style_option_set_rect(to_unsafe, value.to_native)
      value
    end

    def rect=(value : RectF) : RectF
      LibQt6.qt6cr_style_option_set_rect(to_unsafe, value.to_rect.to_native)
      value
    end

    def font_metrics : QFontMetrics
      QFontMetrics.wrap(LibQt6.qt6cr_style_option_font_metrics(to_unsafe), true)
    end

    def set_font_metrics(value : QFontMetrics) : self
      LibQt6.qt6cr_style_option_set_font_metrics(to_unsafe, value.to_unsafe)
      self
    end

    def palette : QPalette
      QPalette.wrap(LibQt6.qt6cr_style_option_palette(to_unsafe), true)
    end

    def palette=(value : QPalette) : QPalette
      LibQt6.qt6cr_style_option_set_palette(to_unsafe, value.to_unsafe)
      value
    end

    def style_object : QObject?
      handle = LibQt6.qt6cr_style_option_style_object(to_unsafe)
      handle.null? ? nil : QObject.wrap(handle)
    end

    def style_object=(value : QObject?) : QObject?
      LibQt6.qt6cr_style_option_set_style_object(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    def init_from(widget : Widget) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, widget.to_unsafe)
      self
    end

    def set_version(value : Int) : self
      self.version = value
      self
    end

    def set_type(value : StyleOptionType) : self
      self.type = value
      self
    end

    def set_state(value : StyleStateFlag) : self
      self.state = value
      self
    end

    def set_direction(value : LayoutDirection) : self
      self.direction = value
      self
    end

    def set_rect(value : Rect | RectF) : self
      self.rect = value
      self
    end

    def set_palette(value : QPalette) : self
      self.palette = value
      self
    end

    def set_style_object(value : QObject?) : self
      self.style_object = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_destroy(to_unsafe)
    end
  end
end
