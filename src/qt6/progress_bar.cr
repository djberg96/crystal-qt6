module Qt6
  # Wraps `QProgressBar`.
  class ProgressBar < Widget
    @value_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the progress value changes.
    getter value_changed : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_progress_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @value_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_progress_bar_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @value_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_progress_bar_on_value_changed(to_unsafe, VALUE_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    def minimum : Int32
      LibQt6.qt6cr_progress_bar_minimum(to_unsafe)
    end

    def minimum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_progress_bar_set_minimum(to_unsafe, int_value)
      int_value
    end

    def maximum : Int32
      LibQt6.qt6cr_progress_bar_maximum(to_unsafe)
    end

    def maximum=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_progress_bar_set_maximum(to_unsafe, int_value)
      int_value
    end

    def set_range(minimum : Int, maximum : Int) : Range(Int32, Int32)
      min_value = minimum.to_i32
      max_value = maximum.to_i32
      LibQt6.qt6cr_progress_bar_set_range(to_unsafe, min_value, max_value)
      min_value..max_value
    end

    def value : Int32
      LibQt6.qt6cr_progress_bar_value(to_unsafe)
    end

    def value=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_progress_bar_set_value(to_unsafe, int_value)
      int_value
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_progress_bar_text(to_unsafe))
    end

    def reset : self
      LibQt6.qt6cr_progress_bar_reset(to_unsafe)
      self
    end

    def text_visible? : Bool
      LibQt6.qt6cr_progress_bar_text_visible(to_unsafe)
    end

    def text_visible=(value : Bool) : Bool
      LibQt6.qt6cr_progress_bar_set_text_visible(to_unsafe, value)
      value
    end

    def inverted_appearance? : Bool
      LibQt6.qt6cr_progress_bar_inverted_appearance(to_unsafe)
    end

    def inverted_appearance=(value : Bool) : Bool
      LibQt6.qt6cr_progress_bar_set_inverted_appearance(to_unsafe, value)
      value
    end

    def text_direction : ProgressBarDirection
      ProgressBarDirection.from_value(LibQt6.qt6cr_progress_bar_text_direction(to_unsafe))
    end

    def text_direction=(value : ProgressBarDirection) : ProgressBarDirection
      LibQt6.qt6cr_progress_bar_set_text_direction(to_unsafe, value.value)
      value
    end

    def format : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_progress_bar_format(to_unsafe))
    end

    def format=(value : String) : String
      LibQt6.qt6cr_progress_bar_set_format(to_unsafe, value.to_unsafe)
      value
    end

    def reset_format : self
      LibQt6.qt6cr_progress_bar_reset_format(to_unsafe)
      self
    end

    def alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_progress_bar_alignment(to_unsafe))
    end

    def alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_progress_bar_set_alignment(to_unsafe, value.value)
      value
    end

    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_progress_bar_orientation(to_unsafe))
    end

    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_progress_bar_set_orientation(to_unsafe, value.value)
      value
    end

    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_progress_bar_size_hint(to_unsafe))
    end

    def minimum_size_hint : Size
      Size.from_native(LibQt6.qt6cr_progress_bar_minimum_size_hint(to_unsafe))
    end

    def set_minimum(value : Int) : self
      self.minimum = value
      self
    end

    def set_maximum(value : Int) : self
      self.maximum = value
      self
    end

    def set_value(value : Int) : self
      self.value = value
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

    def set_text_direction(value : ProgressBarDirection) : self
      self.text_direction = value
      self
    end

    def set_format(value : String) : self
      self.format = value
      self
    end

    def set_alignment(value : AlignmentFlag) : self
      self.alignment = value
      self
    end

    def set_orientation(value : Orientation) : self
      self.orientation = value
      self
    end

    def on_value_changed(&block : Int32 ->) : self
      @value_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_value_changed(value : Int32) : Nil
      @value_changed.emit(value)
    end

    private VALUE_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ProgressBar).unbox(userdata).emit_value_changed(value)
    end
  end
end
