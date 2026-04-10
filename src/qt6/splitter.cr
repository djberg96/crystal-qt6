module Qt6
  # Wraps `QSplitter`.
  class Splitter < Widget
    # Creates a splitter with the requested orientation and optional parent.
    def initialize(orientation : Orientation = Orientation::Horizontal, parent : Widget? = nil)
      super(LibQt6.qt6cr_splitter_create(parent.try(&.to_unsafe) || Pointer(Void).null, orientation.value), parent.nil?)
    end

    # Adds a widget to the splitter and returns it.
    def add(widget : Widget) : Widget
      LibQt6.qt6cr_splitter_add_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Appends a widget to the splitter and returns `self`.
    def <<(widget : Widget) : self
      add(widget)
      self
    end

    # Returns the number of child widgets.
    def count : Int32
      LibQt6.qt6cr_splitter_count(to_unsafe)
    end

    # Returns the splitter orientation.
    def orientation : Orientation
      Orientation.from_value(LibQt6.qt6cr_splitter_orientation(to_unsafe))
    end

    # Sets the splitter orientation and returns it.
    def orientation=(value : Orientation) : Orientation
      LibQt6.qt6cr_splitter_set_orientation(to_unsafe, value.value)
      value
    end
  end
end