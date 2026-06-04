module Qt6
  class MoveEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(pos : Point, old_pos : Point)
      super(LibQt6.qt6cr_move_event_create(pos.to_native, old_pos.to_native), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def pos : Point
      Point.from_native(LibQt6.qt6cr_move_event_pos(to_unsafe))
    end

    def old_pos : Point
      Point.from_native(LibQt6.qt6cr_move_event_old_pos(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_move_event_destroy(to_unsafe)
    end
  end
end
