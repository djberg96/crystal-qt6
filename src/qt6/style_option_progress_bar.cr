module Qt6
  # Wraps `QStyleOptionProgressBar` for progress-bar paint and layout state.
  class StyleOptionProgressBar < StyleOption
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_style_option_progress_bar_create, true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def minimum : Int32
      LibQt6.qt6cr_style_option_progress_bar_minimum(to_unsafe)
    end

    def minimum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_progress_bar_set_minimum(to_unsafe, int_value)
      int_value
    end

    def maximum : Int32
      LibQt6.qt6cr_style_option_progress_bar_maximum(to_unsafe)
    end

    def maximum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_progress_bar_set_maximum(to_unsafe, int_value)
      int_value
    end

    def progress : Int32
      LibQt6.qt6cr_style_option_progress_bar_progress(to_unsafe)
    end

    def progress=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_style_option_progress_bar_set_progress(to_unsafe, int_value)
      int_value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_style_option_progress_bar_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_style_option_progress_bar_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def text_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_style_option_progress_bar_text_alignment(to_unsafe))
    end

    def text_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_style_option_progress_bar_set_text_alignment(to_unsafe, value.value)
      value
    end

    def text_visible? : Bool
      LibQt6.qt6cr_style_option_progress_bar_text_visible(to_unsafe)
    end

    def text_visible=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_progress_bar_set_text_visible(to_unsafe, value)
      value
    end

    def inverted_appearance? : Bool
      LibQt6.qt6cr_style_option_progress_bar_inverted_appearance(to_unsafe)
    end

    def inverted_appearance=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_progress_bar_set_inverted_appearance(to_unsafe, value)
      value
    end

    def bottom_to_top? : Bool
      LibQt6.qt6cr_style_option_progress_bar_bottom_to_top(to_unsafe)
    end

    def bottom_to_top=(value : Bool) : Bool
      LibQt6.qt6cr_style_option_progress_bar_set_bottom_to_top(to_unsafe, value)
      value
    end

    def init_from(progress_bar : ProgressBar) : self
      LibQt6.qt6cr_style_option_init_from(to_unsafe, progress_bar.to_unsafe)
      LibQt6.qt6cr_progress_bar_init_style_option(progress_bar.to_unsafe, to_unsafe)
      self
    end

    def set_minimum(value : Int) : self
      self.minimum = value
      self
    end

    def set_maximum(value : Int) : self
      self.maximum = value
      self
    end

    def set_progress(value : Int) : self
      self.progress = value
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

    def set_text_visible(value : Bool) : self
      self.text_visible = value
      self
    end

    def set_inverted_appearance(value : Bool) : self
      self.inverted_appearance = value
      self
    end

    def set_bottom_to_top(value : Bool) : self
      self.bottom_to_top = value
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_style_option_progress_bar_destroy(to_unsafe)
    end
  end
end
