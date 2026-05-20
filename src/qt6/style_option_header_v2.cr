module Qt6
  # Wraps `QStyleOptionHeaderV2` for Qt 6 header paint extensions.
  class StyleOptionHeaderV2 < StyleOptionHeader
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_header_v2_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def text_elide_mode : TextElideMode
      TextElideMode.from_value(LibQt6.qt6cr_style_option_header_v2_text_elide_mode(to_unsafe))
    end

    def text_elide_mode=(value : TextElideMode) : TextElideMode
      LibQt6.qt6cr_style_option_header_v2_set_text_elide_mode(to_unsafe, value.value)
      value
    end

    def section_drag_target? : Bool
      LibQt6.qt6cr_style_option_header_v2_is_section_drag_target(to_unsafe)
    end

    def section_drag_target=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_header_v2_set_section_drag_target(to_unsafe, value)
      value
    end

    def set_text_elide_mode(value : TextElideMode) : self
      self.text_elide_mode = value
      self
    end

    def set_section_drag_target(value : Bool) : self
      self.section_drag_target = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_header_v2_destroy(to_unsafe)
    end
  end
end
