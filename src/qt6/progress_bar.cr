module Qt6
  # Wraps `QProgressBar`.
  class ProgressBar < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_progress_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
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

    def text_visible? : Bool
      LibQt6.qt6cr_progress_bar_text_visible(to_unsafe)
    end

    def text_visible=(value : Bool) : Bool
      LibQt6.qt6cr_progress_bar_set_text_visible(to_unsafe, value)
      value
    end

    def format : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_progress_bar_format(to_unsafe))
    end

    def format=(value : String) : String
      LibQt6.qt6cr_progress_bar_set_format(to_unsafe, value.to_unsafe)
      value
    end

    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_progress_bar_orientation(to_unsafe))
    end

    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_progress_bar_set_orientation(to_unsafe, value.value)
      value
    end
  end
end
