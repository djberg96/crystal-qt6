module Qt6
  # Wraps `QStyleOptionButton` for push-button and command-link style state.
  class StyleOptionButton < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_button_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def features : StyleOptionButtonFeature
      StyleOptionButtonFeature.from_value(LibQt6.qt6cr_style_option_button_features(to_unsafe))
    end

    def features=(value : StyleOptionButtonFeature) : StyleOptionButtonFeature
      LibQt6.qt6cr_style_option_button_set_features(to_unsafe, value.value)
      value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_button_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_style_option_button_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_style_option_button_icon(to_unsafe), true)
    end

    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_style_option_button_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_style_option_button_icon_size(to_unsafe))
    end

    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_style_option_button_set_icon_size(
        to_unsafe,
        LibQt6::SizeValue.new(width: value.width, height: value.height)
      )
      value
    end

    def set_features(value : StyleOptionButtonFeature) : self
      self.features = value
      self
    end

    def set_text(value : String) : self
      self.text = value
      self
    end

    def set_icon(value : QIcon) : self
      self.icon = value
      self
    end

    def set_icon_size(value : Size) : self
      self.icon_size = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_button_destroy(to_unsafe)
    end
  end
end
