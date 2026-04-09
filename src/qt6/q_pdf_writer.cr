module Qt6
  # Wraps `QPdfWriter` for vector PDF export through `QPainter`.
  class QPdfWriter < NativeResource
    @file_name : String
    @title = ""
    @creator = ""

    # Creates a PDF writer for the given output file with optional metadata.
    def initialize(file_name : String, *, title : String? = nil, creator : String? = nil)
      @file_name = file_name
      super(LibQt6.qt6cr_qpdf_writer_create(file_name.to_unsafe))
      self.title = title if title
      self.creator = creator if creator
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      @file_name = ""
      super(handle, owned)
    end

    # Returns the configured output file path.
    def file_name : String
      @file_name
    end

    # Returns the document title.
    def title : String
      @title
    end

    # Sets the document title.
    def title=(value : String) : String
      LibQt6.qt6cr_qpdf_writer_set_title(to_unsafe, value.to_unsafe)
      @title = value
    end

    # Returns the creator string embedded in the PDF metadata.
    def creator : String
      @creator
    end

    # Sets the creator string embedded in the PDF metadata.
    def creator=(value : String) : String
      LibQt6.qt6cr_qpdf_writer_set_creator(to_unsafe, value.to_unsafe)
      @creator = value
    end

    # Returns the output resolution in DPI.
    def resolution : Int32
      LibQt6.qt6cr_qpdf_writer_resolution(to_unsafe)
    end

    # Sets the output resolution in DPI.
    def resolution=(value : Int) : Int32
      resolution = value.to_i32
      LibQt6.qt6cr_qpdf_writer_set_resolution(to_unsafe, resolution)
      resolution
    end

    # Sets a custom page size measured in printer points.
    def page_size_points=(value : Size) : Size
      LibQt6.qt6cr_qpdf_writer_set_page_size_points(to_unsafe, value.width, value.height)
      value
    end

    # Starts a new page in the output document.
    def new_page : Bool
      LibQt6.qt6cr_qpdf_writer_new_page(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpdf_writer_destroy(to_unsafe)
    end
  end
end