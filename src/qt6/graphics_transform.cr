module Qt6
  # Shared wrapper for `QGraphicsTransform` handles.
  abstract class GraphicsTransform < QObject
    private ROTATION_KIND = 1

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : GraphicsTransform
      case LibQt6.qt6cr_graphics_transform_kind(handle)
      when ROTATION_KIND
        GraphicsRotation.wrap(LibQt6.qt6cr_graphics_transform_to_rotation(handle), owned)
      else
        raise Error.new("Unsupported QGraphicsTransform handle")
      end
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end
  end
end
