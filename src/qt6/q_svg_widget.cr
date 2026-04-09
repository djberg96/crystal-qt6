module Qt6
  # Wraps `QSvgWidget` for embedding SVG display inside widget layouts.
  class QSvgWidget < Widget
    # Creates an SVG widget with an optional initial file and parent.
    def initialize(file_name : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_qsvg_widget_create(parent.try(&.to_unsafe) || Pointer(Void).null, file_name.to_unsafe), parent.nil?)
    end

    # Creates an SVG widget from an in-memory payload.
    def self.from_data(data : Bytes, parent : Widget? = nil) : self
      widget = new(parent: parent)
      widget.load_data(data)
      widget
    end

    # Creates an SVG widget from an in-memory string.
    def self.from_data(data : String, parent : Widget? = nil) : self
      widget = new(parent: parent)
      widget.load_data(data)
      widget
    end

    # Loads an SVG file into the widget and returns the assigned path.
    def load(file_name : String) : String
      LibQt6.qt6cr_qsvg_widget_load(to_unsafe, file_name.to_unsafe)
      file_name
    end

    # Loads an SVG payload into the widget and returns `self`.
    def load_data(data : Bytes) : self
      LibQt6.qt6cr_qsvg_widget_load_data(to_unsafe, data.to_unsafe, data.size)
      self
    end

    # Loads an SVG string into the widget and returns `self`.
    def load_data(data : String) : self
      bytes = data.to_slice
      load_data(bytes)
    end

    # Returns the widget's preferred SVG-driven size.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_qsvg_widget_size_hint(to_unsafe))
    end
  end
end