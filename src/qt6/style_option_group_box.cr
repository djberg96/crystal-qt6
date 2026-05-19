module Qt6
  # Wraps `QStyleOptionGroupBox` for group-box paint and title-bar state.
  class StyleOptionGroupBox < StyleOptionComplex
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_group_box_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def features : StyleOptionFrameFeature
      StyleOptionFrameFeature.from_value(LibQt6.qt6cr_style_option_group_box_features(to_unsafe))
    end

    def features=(value : StyleOptionFrameFeature) : StyleOptionFrameFeature
      LibQt6.qt6cr_style_option_group_box_set_features(to_unsafe, value.value)
      value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_group_box_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_style_option_group_box_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def text_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_style_option_group_box_text_alignment(to_unsafe))
    end

    def text_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_style_option_group_box_set_text_alignment(to_unsafe, value.value)
      value
    end

    def text_color : Color
      Color.from_native(LibQt6.qt6cr_style_option_group_box_text_color(to_unsafe))
    end

    def text_color=(value : Color) : Color
      LibQt6.qt6cr_style_option_group_box_set_text_color(to_unsafe, value.to_native)
      value
    end

    def line_width : Int32
      LibQt6.qt6cr_style_option_group_box_line_width(to_unsafe)
    end

    def line_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_group_box_set_line_width(to_unsafe, int_value)
      int_value
    end

    def mid_line_width : Int32
      LibQt6.qt6cr_style_option_group_box_mid_line_width(to_unsafe)
    end

    def mid_line_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_group_box_set_mid_line_width(to_unsafe, int_value)
      int_value
    end

    def init_from(group_box : GroupBox) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, group_box.to_unsafe)
      LibQt6.qt6cr_group_box_init_style_option(group_box.to_unsafe, to_unsafe)
      self
    end

    def set_features(value : StyleOptionFrameFeature) : self
      self.features = value
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

    def set_text_color(value : Color) : self
      self.text_color = value
      self
    end

    def set_line_width(value : Int) : self
      self.line_width = value
      self
    end

    def set_mid_line_width(value : Int) : self
      self.mid_line_width = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_group_box_destroy(to_unsafe)
    end
  end
end
