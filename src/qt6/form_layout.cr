module Qt6
  # Wraps `QFormLayout`.
  class FormLayout < Layout
    # Creates a form layout attached to the given parent widget.
    def initialize(parent : Widget)
      super(LibQt6.qt6cr_form_layout_create(parent.to_unsafe))
    end

    # Adds a row with a text label and a field widget.
    def add_row(label : String, field : Widget) : Widget
      LibQt6.qt6cr_form_layout_add_row_label_widget(@to_unsafe, label.to_unsafe, field.to_unsafe)
      adopt(field)
    end

    # Adds a row with a widget label and a field widget.
    def add_row(label : Widget, field : Widget) : Tuple(Widget, Widget)
      LibQt6.qt6cr_form_layout_add_row_widget_widget(@to_unsafe, label.to_unsafe, field.to_unsafe)
      adopt(label)
      adopt(field)
      {label, field}
    end

    # Adds a full-width row containing a single widget.
    def add_row(widget : Widget) : Widget
      LibQt6.qt6cr_form_layout_add_row_widget(@to_unsafe, widget.to_unsafe)
      adopt(widget)
    end
  end
end