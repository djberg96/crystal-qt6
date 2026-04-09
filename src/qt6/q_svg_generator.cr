module Qt6
  # Wraps `QSvgGenerator` for vector export through `QPainter`.
  class QSvgGenerator < NativeResource
    # Creates an SVG generator with optional output path, size, and metadata.
    def initialize(file_name : String = "", width : Int = 0, height : Int = 0, *, title : String? = nil, description : String? = nil)
      super(LibQt6.qt6cr_qsvg_generator_create)
      self.file_name = file_name unless file_name.empty?

      if width > 0 && height > 0
        self.size = Size.new(width.to_i32, height.to_i32)
        self.view_box = RectF.new(0.0, 0.0, width.to_f64, height.to_f64)
      end

      self.title = title if title
      self.description = description if description
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the output file path.
    def file_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qsvg_generator_file_name(to_unsafe))
    end

    # Sets the output file path.
    def file_name=(value : String) : String
      LibQt6.qt6cr_qsvg_generator_set_file_name(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the generated canvas size.
    def size : Size
      Size.from_native(LibQt6.qt6cr_qsvg_generator_size(to_unsafe))
    end

    # Sets the generated canvas size.
    def size=(value : Size) : Size
      LibQt6.qt6cr_qsvg_generator_set_size(to_unsafe, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    # Returns the SVG view box.
    def view_box : RectF
      RectF.from_native(LibQt6.qt6cr_qsvg_generator_view_box(to_unsafe))
    end

    # Sets the SVG view box.
    def view_box=(value : RectF) : RectF
      LibQt6.qt6cr_qsvg_generator_set_view_box(to_unsafe, value.to_native)
      value
    end

    # Returns the document title.
    def title : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qsvg_generator_title(to_unsafe))
    end

    # Sets the document title.
    def title=(value : String) : String
      LibQt6.qt6cr_qsvg_generator_set_title(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the document description.
    def description : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qsvg_generator_description(to_unsafe))
    end

    # Sets the document description.
    def description=(value : String) : String
      LibQt6.qt6cr_qsvg_generator_set_description(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the output resolution in DPI.
    def resolution : Int32
      LibQt6.qt6cr_qsvg_generator_resolution(to_unsafe)
    end

    # Sets the output resolution in DPI.
    def resolution=(value : Int) : Int32
      resolution = value.to_i32
      LibQt6.qt6cr_qsvg_generator_set_resolution(to_unsafe, resolution)
      resolution
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qsvg_generator_destroy(to_unsafe)
    end
  end
end