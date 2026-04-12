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

    # Returns the pen style.
    def style : PenStyle
      PenStyle.from_value(LibQt6.qt6cr_qpen_style(to_unsafe))
    end

    # Sets the pen style.
    def style=(value : PenStyle) : PenStyle
      LibQt6.qt6cr_qpen_set_style(to_unsafe, value.value)
      value
    end

    # Returns the pen cap style.
    def cap_style : PenCapStyle
      PenCapStyle.from_value(LibQt6.qt6cr_qpen_cap_style(to_unsafe))
    end

    # Sets the pen cap style.
    def cap_style=(value : PenCapStyle) : PenCapStyle
      LibQt6.qt6cr_qpen_set_cap_style(to_unsafe, value.value)
      value
    end

    # Returns the pen join style.
    def join_style : PenJoinStyle
      PenJoinStyle.from_value(LibQt6.qt6cr_qpen_join_style(to_unsafe))
    end

    # Sets the pen join style.
    def join_style=(value : PenJoinStyle) : PenJoinStyle
      LibQt6.qt6cr_qpen_set_join_style(to_unsafe, value.value)
      value
    end

    # Returns the dash offset for custom dash patterns.
    def dash_offset : Float64
      LibQt6.qt6cr_qpen_dash_offset(to_unsafe)
    end

    # Sets the dash offset for custom dash patterns.
    def dash_offset=(value : Number) : Float64
      dash_offset = value.to_f64
      LibQt6.qt6cr_qpen_set_dash_offset(to_unsafe, dash_offset)
      dash_offset
    end

    # Sets a custom dash pattern in pen-width units.
    def dash_pattern=(values : Enumerable(Number)) : Array(Float64)
      pattern = values.map(&.to_f64)
      return pattern if pattern.empty?

      LibQt6.qt6cr_qpen_set_dash_pattern(to_unsafe, pattern.to_unsafe, pattern.size)
      pattern
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpen_destroy(to_unsafe)
    end
  end
end
