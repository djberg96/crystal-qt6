module Qt6
  # Wraps `QBrush` for fill styling.
  class QBrush < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a brush with the given style.
    def initialize(style : BrushStyle)
      super(LibQt6.qt6cr_qbrush_create_with_style(style.value))
    end

    # Creates a solid-color brush.
    def initialize(color : Color = Color.new(0, 0, 0))
      super(LibQt6.qt6cr_qbrush_create(color.to_native))
    end

    # Creates a textured brush from a pixmap.
    def initialize(pixmap : QPixmap)
      super(LibQt6.qt6cr_qbrush_create_from_pixmap(pixmap.to_unsafe))
    end

    # Creates a textured brush from an image.
    def initialize(image : QImage)
      super(LibQt6.qt6cr_qbrush_create_from_image(image.to_unsafe))
    end

    # Creates a brush from a linear gradient.
    def initialize(gradient : QLinearGradient)
      super(LibQt6.qt6cr_qbrush_create_from_linear_gradient(gradient.to_unsafe))
    end

    # Creates a brush from a conical gradient.
    def initialize(gradient : QConicalGradient)
      super(LibQt6.qt6cr_qbrush_create_from_conical_gradient(gradient.to_unsafe))
    end

    # Creates a brush from a radial gradient.
    def initialize(gradient : QRadialGradient)
      super(LibQt6.qt6cr_qbrush_create_from_radial_gradient(gradient.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the brush style.
    def style : BrushStyle
      BrushStyle.from_value(LibQt6.qt6cr_qbrush_style(to_unsafe))
    end

    # Sets the brush style.
    def style=(value : BrushStyle) : BrushStyle
      LibQt6.qt6cr_qbrush_set_style(to_unsafe, value.value)
      value
    end

    # Returns the brush color.
    def color : Color
      Color.from_native(LibQt6.qt6cr_qbrush_color(to_unsafe))
    end

    # Sets the brush color.
    def color=(value : Color) : Color
      LibQt6.qt6cr_qbrush_set_color(to_unsafe, value.to_native)
      value
    end

    # Returns the brush texture as a pixmap.
    def texture : QPixmap
      QPixmap.wrap(LibQt6.qt6cr_qbrush_texture(to_unsafe), true)
    end

    # Sets the brush texture from a pixmap.
    def texture=(value : QPixmap) : QPixmap
      LibQt6.qt6cr_qbrush_set_texture(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the brush texture as an image.
    def texture_image : QImage
      QImage.new(LibQt6.qt6cr_qbrush_texture_image(to_unsafe), true)
    end

    # Sets the brush texture from an image.
    def texture_image=(value : QImage) : QImage
      LibQt6.qt6cr_qbrush_set_texture_image(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the brush transform.
    def transform : QTransform
      QTransform.wrap(LibQt6.qt6cr_qbrush_transform(to_unsafe), true)
    end

    # Sets the brush transform.
    def transform=(value : QTransform) : QTransform
      LibQt6.qt6cr_qbrush_set_transform(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the brush paints fully opaque pixels.
    def opaque? : Bool
      LibQt6.qt6cr_qbrush_is_opaque(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qbrush_destroy(to_unsafe)
    end
  end
end
