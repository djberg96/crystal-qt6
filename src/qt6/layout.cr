module Qt6
  # Shared base class for layout wrappers.
  abstract class Layout < QObject
    protected def initialize(handle : LibQt6::Handle)
      super(handle, false)
    end

    # Returns the spacing used between layout items.
    def spacing : Int32
      LibQt6.qt6cr_layout_spacing(@to_unsafe)
    end

    # Sets the spacing used between layout items.
    def spacing=(value : Int) : Int32
      LibQt6.qt6cr_layout_set_spacing(@to_unsafe, value)
      value.to_i
    end

    # Sets layout margins in pixels.
    def set_contents_margins(left : Number, top : Number, right : Number, bottom : Number) : self
      LibQt6.qt6cr_layout_set_contents_margins(@to_unsafe, left.to_f64, top.to_f64, right.to_f64, bottom.to_f64)
      self
    end

    # Removes a widget from the layout and returns it.
    def remove(widget : Widget) : Widget
      LibQt6.qt6cr_layout_remove_widget(@to_unsafe, widget.to_unsafe)
      widget
    end

    protected def adopt(widget : Widget) : Widget
      widget.adopt_by_parent!
      widget
    end
  end
end
