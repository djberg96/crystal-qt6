module Qt6
  # Wraps `QPen` for stroke styling.
  class QPen < NativeResource
    # Creates a pen with the given color and stroke width.
    def initialize(color : Color = Color.new(0, 0, 0), width : Number = 1.0)
      super(LibQt6.qt6cr_qpen_create(color.to_native, width.to_f64))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the pen color.
    def color : Color
      Color.from_native(LibQt6.qt6cr_qpen_color(to_unsafe))
    end

    # Sets the pen color.
    def color=(value : Color) : Color
      LibQt6.qt6cr_qpen_set_color(to_unsafe, value.to_native)
      value
    end

    # Returns the pen width in device units.
    def width : Float64
      LibQt6.qt6cr_qpen_width(to_unsafe)
    end

    # Sets the pen width in device units.
    def width=(value : Number) : Float64
      width = value.to_f64
      LibQt6.qt6cr_qpen_set_width(to_unsafe, width)
      width
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpen_destroy(to_unsafe)
    end
  end
end