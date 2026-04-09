module Qt6
  # Wraps `QSvgRenderer` for loading and drawing SVG content into a `QPainter`.
  class QSvgRenderer < NativeResource
    # Loads an SVG document from disk.
    def initialize(file_name : String = "")
      super(LibQt6.qt6cr_qsvg_renderer_create(file_name.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns `true` when the renderer currently holds a valid SVG document.
    def valid? : Bool
      LibQt6.qt6cr_qsvg_renderer_is_valid(to_unsafe)
    end

    # Loads or replaces the SVG document from disk.
    def load(file_name : String) : Bool
      LibQt6.qt6cr_qsvg_renderer_load(to_unsafe, file_name.to_unsafe)
    end

    # Returns the default document size from the SVG metadata.
    def default_size : Size
      Size.from_native(LibQt6.qt6cr_qsvg_renderer_default_size(to_unsafe))
    end

    # Returns the active SVG view box.
    def view_box : RectF
      RectF.from_native(LibQt6.qt6cr_qsvg_renderer_view_box(to_unsafe))
    end

    # Replaces the SVG view box.
    def view_box=(value : RectF) : RectF
      LibQt6.qt6cr_qsvg_renderer_set_view_box(to_unsafe, value.to_native)
      value
    end

    # Returns `true` if the named element exists in the loaded document.
    def element_exists?(element_id : String) : Bool
      LibQt6.qt6cr_qsvg_renderer_element_exists(to_unsafe, element_id.to_unsafe)
    end

    # Returns the bounds of a named element.
    def bounds_on_element(element_id : String) : RectF
      RectF.from_native(LibQt6.qt6cr_qsvg_renderer_bounds_on_element(to_unsafe, element_id.to_unsafe))
    end

    # Renders the loaded SVG using the painter's current transform and state.
    def render(painter : QPainter) : self
      LibQt6.qt6cr_qsvg_renderer_render(to_unsafe, painter.to_unsafe)
      self
    end

    # Renders the loaded SVG scaled into the requested bounds.
    def render(painter : QPainter, bounds : RectF) : self
      LibQt6.qt6cr_qsvg_renderer_render_with_bounds(to_unsafe, painter.to_unsafe, bounds.to_native)
      self
    end

    # Renders the named SVG element using the painter's current transform and state.
    def render(painter : QPainter, element_id : String) : self
      LibQt6.qt6cr_qsvg_renderer_render_element(to_unsafe, painter.to_unsafe, element_id.to_unsafe)
      self
    end

    # Renders the named SVG element scaled into the requested bounds.
    def render(painter : QPainter, element_id : String, bounds : RectF) : self
      LibQt6.qt6cr_qsvg_renderer_render_element_with_bounds(to_unsafe, painter.to_unsafe, element_id.to_unsafe, bounds.to_native)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qsvg_renderer_destroy(to_unsafe)
    end
  end
end