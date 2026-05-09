module Qt6
  # Wraps `QGraphicsSceneMoveEvent` for synthetic or live graphics-scene move-event inspection.
  #
  # When obtained from `QEvent#graphics_scene_move_event`, the underlying handle is only
  # valid while the surrounding callback is running.
  class GraphicsSceneMoveEvent < GraphicsSceneEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a graphics-scene move event.
    def initialize
      super(LibQt6.qt6cr_graphics_scene_move_event_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def old_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_move_event_old_pos(to_unsafe))
    end

    def old_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_move_event_set_old_pos(to_unsafe, value.to_native)
      value
    end

    def new_pos : PointF
      PointF.from_native(LibQt6.qt6cr_graphics_scene_move_event_new_pos(to_unsafe))
    end

    def new_pos=(value : PointF) : PointF
      LibQt6.qt6cr_graphics_scene_move_event_set_new_pos(to_unsafe, value.to_native)
      value
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_graphics_scene_move_event_destroy(to_unsafe)
    end
  end
end
