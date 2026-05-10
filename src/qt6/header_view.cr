module Qt6
  # Wraps `QHeaderView` for section sizing and visibility controls.
  class HeaderView < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the number of sections.
    def count : Int32
      LibQt6.qt6cr_header_view_count(to_unsafe)
    end

    # Returns the header orientation.
    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_header_view_orientation(to_unsafe))
    end

    # Returns the total length of all visible sections in pixels.
    def length : Int32
      LibQt6.qt6cr_header_view_length(to_unsafe)
    end

    # Returns the current viewport offset in pixels.
    def offset : Int32
      LibQt6.qt6cr_header_view_offset(to_unsafe)
    end

    # Returns the number of hidden sections.
    def hidden_section_count : Int32
      LibQt6.qt6cr_header_view_hidden_section_count(to_unsafe)
    end

    # Returns the default section size.
    def default_section_size : Int32
      LibQt6.qt6cr_header_view_default_section_size(to_unsafe)
    end

    # Sets the default section size.
    def default_section_size=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_header_view_set_default_section_size(to_unsafe, int_value)
      int_value
    end

    # Qt-style alias for `default_section_size=`.
    def set_default_section_size(value : Int) : self
      self.default_section_size = value
      self
    end

    # Returns the minimum section size.
    def minimum_section_size : Int32
      LibQt6.qt6cr_header_view_minimum_section_size(to_unsafe)
    end

    # Sets the minimum section size.
    def minimum_section_size=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_header_view_set_minimum_section_size(to_unsafe, int_value)
      int_value
    end

    # Qt-style alias for `minimum_section_size=`.
    def set_minimum_section_size(value : Int) : self
      self.minimum_section_size = value
      self
    end

    # Returns the maximum section size.
    def maximum_section_size : Int32
      LibQt6.qt6cr_header_view_maximum_section_size(to_unsafe)
    end

    # Sets the maximum section size.
    def maximum_section_size=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_header_view_set_maximum_section_size(to_unsafe, int_value)
      int_value
    end

    # Qt-style alias for `maximum_section_size=`.
    def set_maximum_section_size(value : Int) : self
      self.maximum_section_size = value
      self
    end

    # Returns the default section alignment.
    def default_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_header_view_default_alignment(to_unsafe))
    end

    # Sets the default section alignment.
    def default_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_header_view_set_default_alignment(to_unsafe, value.value)
      value
    end

    # Qt-style alias for `default_alignment=`.
    def set_default_alignment(value : AlignmentFlag) : self
      self.default_alignment = value
      self
    end

    # Returns whether the last section stretches to fill the available space.
    def stretch_last_section? : Bool
      LibQt6.qt6cr_header_view_stretch_last_section(to_unsafe)
    end

    # Enables or disables last-section stretching.
    def stretch_last_section=(value : Bool) : Bool
      LibQt6.qt6cr_header_view_set_stretch_last_section(to_unsafe, value)
      value
    end

    # Qt-style alias for `stretch_last_section=`.
    def set_stretch_last_section(value : Bool) : self
      self.stretch_last_section = value
      self
    end

    # Returns whether sections can be reordered by the user.
    def sections_movable? : Bool
      LibQt6.qt6cr_header_view_sections_movable(to_unsafe)
    end

    # Enables or disables interactive section reordering.
    def sections_movable=(value : Bool) : Bool
      LibQt6.qt6cr_header_view_set_sections_movable(to_unsafe, value)
      value
    end

    # Qt-style alias for `sections_movable=`.
    def set_sections_movable(value : Bool) : self
      self.sections_movable = value
      self
    end

    # Returns whether sections react to click interaction.
    def sections_clickable? : Bool
      LibQt6.qt6cr_header_view_sections_clickable(to_unsafe)
    end

    # Enables or disables clickable header sections.
    def sections_clickable=(value : Bool) : Bool
      LibQt6.qt6cr_header_view_set_sections_clickable(to_unsafe, value)
      value
    end

    # Qt-style alias for `sections_clickable=`.
    def set_sections_clickable(value : Bool) : self
      self.sections_clickable = value
      self
    end

    # Returns whether matching sections are highlighted with selections.
    def highlight_sections? : Bool
      LibQt6.qt6cr_header_view_highlight_sections(to_unsafe)
    end

    # Enables or disables section highlighting for selections.
    def highlight_sections=(value : Bool) : Bool
      LibQt6.qt6cr_header_view_set_highlight_sections(to_unsafe, value)
      value
    end

    # Qt-style alias for `highlight_sections=`.
    def set_highlight_sections(value : Bool) : self
      self.highlight_sections = value
      self
    end

    # Returns whether interactive section resizing cascades into neighbors.
    def cascading_section_resizes? : Bool
      LibQt6.qt6cr_header_view_cascading_section_resizes(to_unsafe)
    end

    # Enables or disables cascading interactive section resizing.
    def cascading_section_resizes=(value : Bool) : Bool
      LibQt6.qt6cr_header_view_set_cascading_section_resizes(to_unsafe, value)
      value
    end

    # Qt-style alias for `cascading_section_resizes=`.
    def set_cascading_section_resizes(value : Bool) : self
      self.cascading_section_resizes = value
      self
    end

    # Returns whether the given section is hidden.
    def section_hidden?(index : Int) : Bool
      LibQt6.qt6cr_header_view_section_hidden(to_unsafe, index.to_i32)
    end

    # Shows or hides the given section.
    def set_section_hidden(index : Int, value : Bool) : Bool
      LibQt6.qt6cr_header_view_set_section_hidden(to_unsafe, index.to_i32, value)
      value
    end

    # Hides the given section.
    def hide_section(index : Int) : self
      set_section_hidden(index, true)
      self
    end

    # Shows the given section.
    def show_section(index : Int) : self
      set_section_hidden(index, false)
      self
    end

    # Returns the resize mode for the given section.
    def section_resize_mode(index : Int) : HeaderResizeMode
      HeaderResizeMode.from_value(LibQt6.qt6cr_header_view_section_resize_mode(to_unsafe, index.to_i32))
    end

    # Sets the resize mode for the given section.
    def set_section_resize_mode(index : Int, value : HeaderResizeMode) : HeaderResizeMode
      LibQt6.qt6cr_header_view_set_section_resize_mode(to_unsafe, index.to_i32, value.value)
      value
    end

    # Resizes a section to the requested pixel size.
    def resize_section(index : Int, size : Int) : self
      LibQt6.qt6cr_header_view_resize_section(to_unsafe, index.to_i32, size.to_i32)
      self
    end

    # Returns the current pixel size of the given section.
    def section_size(index : Int) : Int32
      LibQt6.qt6cr_header_view_section_size(to_unsafe, index.to_i32)
    end

    # Returns the current visual index for the logical section.
    def visual_index(logical_index : Int) : Int32
      LibQt6.qt6cr_header_view_visual_index(to_unsafe, logical_index.to_i32)
    end

    # Returns the logical index for the visual section position.
    def logical_index(visual_index : Int) : Int32
      LibQt6.qt6cr_header_view_logical_index(to_unsafe, visual_index.to_i32)
    end

    # Moves a section from one visual position to another.
    def move_section(from : Int, to : Int) : self
      LibQt6.qt6cr_header_view_move_section(to_unsafe, from.to_i32, to.to_i32)
      self
    end
  end
end
