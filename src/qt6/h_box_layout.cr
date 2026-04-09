module Qt6
  class HBoxLayout < Layout
    def initialize(parent : Widget)
      super(LibQt6.qt6cr_h_box_layout_create(parent.to_unsafe))
    end

    def add(widget : Widget) : Widget
      LibQt6.qt6cr_h_box_layout_add_widget(@to_unsafe, widget.to_unsafe)
      adopt(widget)
    end

    def <<(widget : Widget) : self
      add(widget)
      self
    end
  end
end