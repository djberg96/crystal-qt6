module Qt6
  # Wraps `QBitmap` for monochrome pixmap masks and 1-bit paint surfaces.
  class QBitmap < QPixmap
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(width : Int, height : Int)
      super(LibQt6.qt6cr_qbitmap_create(width.to_i32, height.to_i32), true)
    end

    def initialize(path : String)
      super(LibQt6.qt6cr_qbitmap_create_from_file(path.to_unsafe), true)
    end

    def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def self.from_file(path : String) : self
      new(path)
    end

    def self.from_image(image : QImage) : self
      new(LibQt6.qt6cr_qbitmap_from_image(image.to_unsafe), true)
    end

    def self.from_pixmap(pixmap : QPixmap) : self
      new(LibQt6.qt6cr_qbitmap_from_pixmap(pixmap.to_unsafe), true)
    end

    def self.from_data(size : Size, data : Bytes, format : BitmapDataFormat = BitmapDataFormat::MonoLSB) : self
      new(
        LibQt6.qt6cr_qbitmap_from_data(
          size.width,
          size.height,
          data.to_unsafe,
          data.size,
          format.value
        ),
        true
      )
    end

    def clear : self
      LibQt6.qt6cr_qbitmap_clear(to_unsafe)
      self
    end

    def transformed(transform : QTransform) : QBitmap
      QBitmap.wrap(LibQt6.qt6cr_qbitmap_transformed(to_unsafe, transform.to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qbitmap_destroy(to_unsafe)
    end
  end
end
