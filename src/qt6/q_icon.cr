module Qt6
  # Wraps `QIcon` for application and window icon configuration.
  class QIcon < NativeResource
    # Creates an empty icon.
    def initialize
      super(LibQt6.qt6cr_qicon_create)
    end

    # Loads an icon from disk.
    def initialize(path : String)
      super(LibQt6.qt6cr_qicon_create_from_file(path.to_unsafe))
    end

    # Wraps an existing native icon handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Loads an icon from disk.
    def self.from_file(path : String) : self
      new(path)
    end

    # Loads an icon from the active desktop theme.
    def self.from_theme(name : String) : self
      new(LibQt6.qt6cr_qicon_create_from_theme(name.to_unsafe), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` if the icon contains no usable pixmaps.
    def null? : Bool
      LibQt6.qt6cr_qicon_is_null(to_unsafe)
    end

    # Paints the icon into the given rectangle using Qt's native icon rendering.
    def paint(
      painter : QPainter,
      rect : RectF,
      alignment : AlignmentFlag = AlignmentFlag::Center,
      mode : IconMode = IconMode::Normal,
      state : IconState = IconState::Off,
    ) : self
      LibQt6.qt6cr_qicon_paint_rect(to_unsafe, painter.to_unsafe, rect.to_native, alignment.value, mode.value, state.value)
      self
    end

    # Paints the icon into the given bounds using Qt's native icon rendering.
    def paint(
      painter : QPainter,
      x : Int32,
      y : Int32,
      width : Int32,
      height : Int32,
      alignment : AlignmentFlag = AlignmentFlag::Center,
      mode : IconMode = IconMode::Normal,
      state : IconState = IconState::Off,
    ) : self
      LibQt6.qt6cr_qicon_paint_bounds(to_unsafe, painter.to_unsafe, x, y, width, height, alignment.value, mode.value, state.value)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qicon_destroy(to_unsafe)
    end
  end
end
