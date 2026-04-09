module Qt6
  class FormLayout < Layout
    def initialize(parent : Widget)
      super(LibQt6.qt6cr_form_layout_create(parent.to_unsafe))
    end

    def add_row(label : String, field : Widget) : Widget
      LibQt6.qt6cr_form_layout_add_row_label_widget(@to_unsafe, label.to_unsafe, field.to_unsafe)
      adopt(field)
    end

    def add_row(label : Widget, field : Widget) : Tuple(Widget, Widget)
      LibQt6.qt6cr_form_layout_add_row_widget_widget(@to_unsafe, label.to_unsafe, field.to_unsafe)
      adopt(label)
      adopt(field)
      {label, field}
    end

    def add_row(widget : Widget) : Widget
      LibQt6.qt6cr_form_layout_add_row_widget(@to_unsafe, widget.to_unsafe)
      adopt(widget)
    end
  end
end