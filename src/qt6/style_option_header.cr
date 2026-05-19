module Qt6
  # Wraps `QStyleOptionHeader` for header paint and section state.
  class StyleOptionHeader < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_header_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def section : Int32
      LibQt6.qt6cr_style_option_header_section(to_unsafe)
    end

    def section=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_header_set_section(to_unsafe, int_value)
      int_value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_header_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_style_option_header_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def text_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_style_option_header_text_alignment(to_unsafe))
    end

    def text_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_style_option_header_set_text_alignment(to_unsafe, value.value)
      value
    end

    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_style_option_header_icon(to_unsafe), true)
    end

    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_style_option_header_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    def icon_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_style_option_header_icon_alignment(to_unsafe))
    end

    def icon_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_style_option_header_set_icon_alignment(to_unsafe, value.value)
      value
    end

    def position : StyleOptionHeaderSectionPosition
      StyleOptionHeaderSectionPosition.from_value(LibQt6.qt6cr_style_option_header_position(to_unsafe))
    end

    def position=(value : StyleOptionHeaderSectionPosition) : StyleOptionHeaderSectionPosition
      LibQt6.qt6cr_style_option_header_set_position(to_unsafe, value.value)
      value
    end

    def selected_position : StyleOptionHeaderSelectedPosition
      StyleOptionHeaderSelectedPosition.from_value(LibQt6.qt6cr_style_option_header_selected_position(to_unsafe))
    end

    def selected_position=(value : StyleOptionHeaderSelectedPosition) : StyleOptionHeaderSelectedPosition
      LibQt6.qt6cr_style_option_header_set_selected_position(to_unsafe, value.value)
      value
    end

    def sort_indicator : StyleOptionHeaderSortIndicator
      StyleOptionHeaderSortIndicator.from_value(LibQt6.qt6cr_style_option_header_sort_indicator(to_unsafe))
    end

    def sort_indicator=(value : StyleOptionHeaderSortIndicator) : StyleOptionHeaderSortIndicator
      LibQt6.qt6cr_style_option_header_set_sort_indicator(to_unsafe, value.value)
      value
    end

    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_style_option_header_orientation(to_unsafe))
    end

    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_style_option_header_set_orientation(to_unsafe, value.value)
      value
    end

    def init_from(header : HeaderView) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, header.to_unsafe)
      LibQt6.qt6cr_header_view_init_style_option(header.to_unsafe, to_unsafe)
      self
    end

    def init_from_index(header : HeaderView, logical_index : Int) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, header.to_unsafe)
      LibQt6.qt6cr_header_view_init_style_option_for_index(header.to_unsafe, logical_index.to_i32, to_unsafe)
      self
    end

    def set_section(value : Int) : self
      self.section = value
      self
    end

    def set_text(value : String) : self
      self.text = value
      self
    end

    def set_text_alignment(value : AlignmentFlag) : self
      self.text_alignment = value
      self
    end

    def set_icon(value : QIcon) : self
      self.icon = value
      self
    end

    def set_icon_alignment(value : AlignmentFlag) : self
      self.icon_alignment = value
      self
    end

    def set_position(value : StyleOptionHeaderSectionPosition) : self
      self.position = value
      self
    end

    def set_selected_position(value : StyleOptionHeaderSelectedPosition) : self
      self.selected_position = value
      self
    end

    def set_sort_indicator(value : StyleOptionHeaderSortIndicator) : self
      self.sort_indicator = value
      self
    end

    def set_orientation(value : Orientation) : self
      self.orientation = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_header_destroy(to_unsafe)
    end
  end
end
