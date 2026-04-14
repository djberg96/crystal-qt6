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

    # Returns whether the last section stretches to fill the available space.
    def stretch_last_section? : Bool
      LibQt6.qt6cr_header_view_stretch_last_section(to_unsafe)
    end

    # Enables or disables last-section stretching.
    def stretch_last_section=(value : Bool) : Bool
      LibQt6.qt6cr_header_view_set_stretch_last_section(to_unsafe, value)
      value
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
  end
end
