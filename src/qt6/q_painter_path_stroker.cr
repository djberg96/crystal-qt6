module Qt6
  # Wraps `QPainterPathStroker` for stroke outline generation.
  class QPainterPathStroker < NativeResource
    def initialize
      super(LibQt6.qt6cr_qpainter_path_stroker_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def width : Float64
      LibQt6.qt6cr_qpainter_path_stroker_width(to_unsafe)
    end

    def width=(value : Number) : Float64
      width = value.to_f64
      LibQt6.qt6cr_qpainter_path_stroker_set_width(to_unsafe, width)
      width
    end

    def create_stroke(path : QPainterPath) : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_qpainter_path_stroker_create_stroke(to_unsafe, path.to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpainter_path_stroker_destroy(to_unsafe)
    end
  end
end
