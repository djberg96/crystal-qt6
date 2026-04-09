module Qt6
  class VBoxLayout < QObject
    def initialize(parent : Widget)
      super(LibQt6.qt6cr_v_box_layout_create(parent.to_unsafe), false)
    end

    def add(widget : Widget) : Widget
      LibQt6.qt6cr_v_box_layout_add_widget(@to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    def <<(widget : Widget) : self
      add(widget)
      self
    end
  end
end
