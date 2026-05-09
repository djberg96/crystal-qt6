module Qt6
  # Shared wrapper for `QGraphicsTransform` handles.
  abstract class GraphicsTransform < QObject
    private ROTATION_KIND = 1
    private SCALE_KIND = 2

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : GraphicsTransform
      case LibQt6.qt6cr_graphics_transform_kind(handle)
      when ROTATION_KIND
        GraphicsRotation.wrap(LibQt6.qt6cr_graphics_transform_to_rotation(handle), owned)
      when SCALE_KIND
        GraphicsScale.wrap(LibQt6.qt6cr_graphics_transform_to_scale(handle), owned)
      else
        raise Error.new("Unsupported QGraphicsTransform handle")
      end
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Applies this transform to the provided 4x4 matrix and returns the result.
    def apply_to(matrix : Matrix4x4) : Matrix4x4
      Matrix4x4.from_native(LibQt6.qt6cr_graphics_transform_apply_to(to_unsafe, matrix.to_native))
    end

    # Triggers Qt's internal geometry update propagation for this transform.
    def update : self
      LibQt6.qt6cr_graphics_transform_update(to_unsafe)
      self
    end
  end
end
