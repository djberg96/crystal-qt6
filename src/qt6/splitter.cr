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

    # Returns the child widget at the given index, if present.
    def widget(index : Int) : Widget?
      handle = LibQt6.qt6cr_splitter_widget(to_unsafe, index.to_i32)
      handle.null? ? nil : Widget.wrap(handle)
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

    # Returns `true` when panes resize continuously during drag.
    def opaque_resize? : Bool
      LibQt6.qt6cr_splitter_opaque_resize(to_unsafe)
    end

    # Enables or disables continuous pane resizing during drag.
    def opaque_resize=(value : Bool) : Bool
      LibQt6.qt6cr_splitter_set_opaque_resize(to_unsafe, value)
      value
    end

    # Returns `true` when child panes can collapse to zero size.
    def children_collapsible? : Bool
      LibQt6.qt6cr_splitter_children_collapsible(to_unsafe)
    end

    # Enables or disables pane collapse behavior.
    def children_collapsible=(value : Bool) : Bool
      LibQt6.qt6cr_splitter_set_children_collapsible(to_unsafe, value)
      value
    end

    # Returns the splitter handle width in pixels.
    def handle_width : Int32
      LibQt6.qt6cr_splitter_handle_width(to_unsafe)
    end

    # Sets the splitter handle width and returns it.
    def handle_width=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_splitter_set_handle_width(to_unsafe, int_value)
      int_value
    end

    # Returns the current pane sizes in pixels.
    def sizes : Array(Int32)
      Qt6.copy_and_release_ints(LibQt6.qt6cr_splitter_sizes(to_unsafe))
    end

    # Sets the pane sizes and returns them.
    def set_sizes(values : Enumerable(Int)) : Array(Int32)
      sizes = values.map(&.to_i32).to_a
      pointer = sizes.empty? ? Pointer(Int32).null : sizes.to_unsafe
      LibQt6.qt6cr_splitter_set_sizes(to_unsafe, pointer, sizes.size)
      sizes
    end
  end
end
