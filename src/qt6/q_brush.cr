module Qt6
  # Wraps `QBrush` for fill styling.
  class QBrush < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
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

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
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

    # Returns the brush transform.
    def transform : QTransform
      QTransform.wrap(LibQt6.qt6cr_qbrush_transform(to_unsafe), true)
    end

    # Sets the brush transform.
    def transform=(value : QTransform) : QTransform
      LibQt6.qt6cr_qbrush_set_transform(to_unsafe, value.to_unsafe)
      value
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qbrush_destroy(to_unsafe)
    end
  end
end
