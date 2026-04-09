module Qt6
  abstract class Layout < QObject
    protected def initialize(handle : LibQt6::Handle)
      super(handle, false)
    end

    protected def adopt(widget : Widget) : Widget
      widget.adopt_by_parent!
      widget
    end
  end
end