module Qt6
  # Wraps `QFormLayout`.
  class FormLayout < Layout
    def self.wrap(handle : LibQt6::Handle) : self
      new(handle)
    end

    # Creates a form layout attached to the given parent widget.
    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_form_layout_create(parent.try(&.to_unsafe) || Pointer(Void).null))
    end

    protected def initialize(handle : LibQt6::Handle)
      super(handle)
    end

    # Returns the current field-growth policy.
    def field_growth_policy : FormLayoutFieldGrowthPolicy
      FormLayoutFieldGrowthPolicy.from_value(LibQt6.qt6cr_form_layout_field_growth_policy(@to_unsafe))
    end

    # Sets the field-growth policy and returns it.
    def field_growth_policy=(value : FormLayoutFieldGrowthPolicy) : FormLayoutFieldGrowthPolicy
      LibQt6.qt6cr_form_layout_set_field_growth_policy(@to_unsafe, value.value)
      value
    end

    # Returns the current row-wrap policy.
    def row_wrap_policy : FormLayoutRowWrapPolicy
      FormLayoutRowWrapPolicy.from_value(LibQt6.qt6cr_form_layout_row_wrap_policy(@to_unsafe))
    end

    # Sets the row-wrap policy and returns it.
    def row_wrap_policy=(value : FormLayoutRowWrapPolicy) : FormLayoutRowWrapPolicy
      LibQt6.qt6cr_form_layout_set_row_wrap_policy(@to_unsafe, value.value)
      value
    end

    # Returns the alignment used for row labels.
    def label_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_form_layout_label_alignment(@to_unsafe))
    end

    # Sets the alignment used for row labels and returns it.
    def label_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_form_layout_set_label_alignment(@to_unsafe, value.value)
      value
    end

    # Returns the overall form alignment.
    def form_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_form_layout_form_alignment(@to_unsafe))
    end

    # Sets the overall form alignment and returns it.
    def form_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_form_layout_set_form_alignment(@to_unsafe, value.value)
      value
    end

    # Returns the spacing between label and field columns.
    def horizontal_spacing : Int32
      LibQt6.qt6cr_form_layout_horizontal_spacing(@to_unsafe)
    end

    # Sets the spacing between label and field columns.
    def horizontal_spacing=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_form_layout_set_horizontal_spacing(@to_unsafe, int_value)
      int_value
    end

    # Returns the spacing between form rows.
    def vertical_spacing : Int32
      LibQt6.qt6cr_form_layout_vertical_spacing(@to_unsafe)
    end

    # Sets the spacing between form rows.
    def vertical_spacing=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_form_layout_set_vertical_spacing(@to_unsafe, int_value)
      int_value
    end

    # Returns the number of logical rows in the form.
    def row_count : Int32
      LibQt6.qt6cr_form_layout_row_count(@to_unsafe)
    end

    # Adds a row with a text label and a field widget.
    def add_row(label : String, field : Widget) : Widget
      LibQt6.qt6cr_form_layout_add_row_label_widget(@to_unsafe, label.to_unsafe, field.to_unsafe)
      adopt(field)
    end

    # Adds a row with a text label and a child layout.
    def add_row(label : String, field : Layout) : Layout
      LibQt6.qt6cr_form_layout_add_row_label_layout(@to_unsafe, label.to_unsafe, field.to_unsafe)
      field.adopt_by_parent!
      field
    end

    # Adds a row with a widget label and a field widget.
    def add_row(label : Widget, field : Widget) : Tuple(Widget, Widget)
      LibQt6.qt6cr_form_layout_add_row_widget_widget(@to_unsafe, label.to_unsafe, field.to_unsafe)
      adopt(label)
      adopt(field)
      {label, field}
    end

    # Adds a row with a widget label and a child layout field.
    def add_row(label : Widget, field : Layout) : Tuple(Widget, Layout)
      LibQt6.qt6cr_form_layout_add_row_widget_layout(@to_unsafe, label.to_unsafe, field.to_unsafe)
      adopt(label)
      field.adopt_by_parent!
      {label, field}
    end

    # Adds a full-width row containing a single widget.
    def add_row(widget : Widget) : Widget
      LibQt6.qt6cr_form_layout_add_row_widget(@to_unsafe, widget.to_unsafe)
      adopt(widget)
    end

    # Adds a full-width row containing a single child layout.
    def add_row(layout : Layout) : Layout
      LibQt6.qt6cr_form_layout_add_row_layout(@to_unsafe, layout.to_unsafe)
      layout.adopt_by_parent!
      layout
    end

    # Inserts a row with a text label and a field widget.
    def insert_row(row : Int, label : String, field : Widget) : Widget
      LibQt6.qt6cr_form_layout_insert_row_label_widget(@to_unsafe, row.to_i32, label.to_unsafe, field.to_unsafe)
      adopt(field)
    end

    # Inserts a row with a text label and a child layout field.
    def insert_row(row : Int, label : String, field : Layout) : Layout
      LibQt6.qt6cr_form_layout_insert_row_label_layout(@to_unsafe, row.to_i32, label.to_unsafe, field.to_unsafe)
      field.adopt_by_parent!
      field
    end

    # Inserts a row with a widget label and a field widget.
    def insert_row(row : Int, label : Widget, field : Widget) : Tuple(Widget, Widget)
      LibQt6.qt6cr_form_layout_insert_row_widget_widget(@to_unsafe, row.to_i32, label.to_unsafe, field.to_unsafe)
      adopt(label)
      adopt(field)
      {label, field}
    end

    # Inserts a row with a widget label and a child layout field.
    def insert_row(row : Int, label : Widget, field : Layout) : Tuple(Widget, Layout)
      LibQt6.qt6cr_form_layout_insert_row_widget_layout(@to_unsafe, row.to_i32, label.to_unsafe, field.to_unsafe)
      adopt(label)
      field.adopt_by_parent!
      {label, field}
    end

    # Inserts a full-width row containing a single widget.
    def insert_row(row : Int, widget : Widget) : Widget
      LibQt6.qt6cr_form_layout_insert_row_widget(@to_unsafe, row.to_i32, widget.to_unsafe)
      adopt(widget)
    end

    # Inserts a full-width row containing a single child layout.
    def insert_row(row : Int, layout : Layout) : Layout
      LibQt6.qt6cr_form_layout_insert_row_layout(@to_unsafe, row.to_i32, layout.to_unsafe)
      layout.adopt_by_parent!
      layout
    end

    # Removes the row at the given index.
    def remove_row(row : Int) : self
      LibQt6.qt6cr_form_layout_remove_row(@to_unsafe, row.to_i32)
      self
    end

    # Removes the row containing the given widget.
    def remove_row(widget : Widget) : Widget
      LibQt6.qt6cr_form_layout_remove_row_widget(@to_unsafe, widget.to_unsafe)
      widget
    end

    # Removes the row containing the given child layout.
    def remove_row(layout : Layout) : Layout
      LibQt6.qt6cr_form_layout_remove_row_layout(@to_unsafe, layout.to_unsafe)
      layout
    end

    # Replaces a specific row role with a widget.
    def set_widget(row : Int, role : FormLayoutItemRole, widget : Widget) : Widget
      LibQt6.qt6cr_form_layout_set_widget(@to_unsafe, row.to_i32, role.value, widget.to_unsafe)
      adopt(widget)
    end

    # Replaces a specific row role with a child layout.
    def set_layout(row : Int, role : FormLayoutItemRole, layout : Layout) : Layout
      LibQt6.qt6cr_form_layout_set_layout(@to_unsafe, row.to_i32, role.value, layout.to_unsafe)
      layout.adopt_by_parent!
      layout
    end

    # Shows or hides the row at the given index.
    def set_row_visible(row : Int, value : Bool) : Bool
      LibQt6.qt6cr_form_layout_set_row_visible(@to_unsafe, row.to_i32, value)
      value
    end

    # Shows or hides the row containing the given widget.
    def set_row_visible(widget : Widget, value : Bool) : Bool
      LibQt6.qt6cr_form_layout_set_row_visible_widget(@to_unsafe, widget.to_unsafe, value)
      value
    end

    # Shows or hides the row containing the given child layout.
    def set_row_visible(layout : Layout, value : Bool) : Bool
      LibQt6.qt6cr_form_layout_set_row_visible_layout(@to_unsafe, layout.to_unsafe, value)
      value
    end

    # Returns `true` when the row at the given index is visible.
    def row_visible?(row : Int) : Bool
      LibQt6.qt6cr_form_layout_is_row_visible(@to_unsafe, row.to_i32)
    end

    # Returns `true` when the row containing the given widget is visible.
    def row_visible?(widget : Widget) : Bool
      LibQt6.qt6cr_form_layout_is_row_visible_widget(@to_unsafe, widget.to_unsafe)
    end

    # Returns `true` when the row containing the given child layout is visible.
    def row_visible?(layout : Layout) : Bool
      LibQt6.qt6cr_form_layout_is_row_visible_layout(@to_unsafe, layout.to_unsafe)
    end

    # Returns the label widget associated with the field widget, if any.
    def label_for_field(field : Widget) : Widget?
      handle = LibQt6.qt6cr_form_layout_label_for_field_widget(@to_unsafe, field.to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Returns the label widget associated with the field layout, if any.
    def label_for_field(field : Layout) : Widget?
      handle = LibQt6.qt6cr_form_layout_label_for_field_layout(@to_unsafe, field.to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    # Extracts and returns the row at the given index.
    def take_row(row : Int) : FormLayoutTakeRowResult
      take_row_result_from_native(LibQt6.qt6cr_form_layout_take_row(@to_unsafe, row.to_i32))
    end

    # Extracts and returns the row containing the given widget.
    def take_row(widget : Widget) : FormLayoutTakeRowResult
      take_row_result_from_native(LibQt6.qt6cr_form_layout_take_row_widget(@to_unsafe, widget.to_unsafe))
    end

    # Extracts and returns the row containing the given child layout.
    def take_row(layout : Layout) : FormLayoutTakeRowResult
      take_row_result_from_native(LibQt6.qt6cr_form_layout_take_row_layout(@to_unsafe, layout.to_unsafe))
    end

    private def take_row_result_from_native(value : LibQt6::FormLayoutTakeRowResultValue) : FormLayoutTakeRowResult
      FormLayoutTakeRowResult.new(
        value.label_item.null? ? nil : LayoutItem.wrap(value.label_item, true),
        value.field_item.null? ? nil : LayoutItem.wrap(value.field_item, true)
      )
    end
  end
end
