module Qt6
  # Wraps `QSplitter`.
  class Splitter < Widget
    @splitter_moved : Signal(Int32, Int32) = Signal(Int32, Int32).new
    @splitter_moved_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted whenever a splitter handle is moved.
    getter splitter_moved : Signal(Int32, Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a splitter with the requested orientation and optional parent.
    def initialize(orientation : Orientation = Orientation::Horizontal, parent : Widget? = nil)
      super(LibQt6.qt6cr_splitter_create(parent.try(&.to_unsafe) || Pointer(Void).null, orientation.value), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @splitter_moved = Signal(Int32, Int32).new
      @splitter_moved_userdata = Box.box(self)
      LibQt6.qt6cr_splitter_on_splitter_moved(to_unsafe, SPLITTER_MOVED_TRAMPOLINE, @splitter_moved_userdata)
    end

    # Adds a widget to the splitter and returns it.
    def add(widget : Widget) : Widget
      LibQt6.qt6cr_splitter_add_widget(to_unsafe, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Inserts a widget at the given index and returns it.
    def insert(index : Int, widget : Widget) : Widget
      LibQt6.qt6cr_splitter_insert_widget(to_unsafe, index.to_i32, widget.to_unsafe)
      widget.adopt_by_parent!
      widget
    end

    # Replaces the widget at the given index and returns the previous widget, if present.
    def replace(index : Int, widget : Widget) : Widget?
      handle = LibQt6.qt6cr_splitter_replace_widget(to_unsafe, index.to_i32, widget.to_unsafe)
      widget.adopt_by_parent!
      handle.null? ? nil : Widget.wrap(handle, true)
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

    # Sets whether the pane at the given index may collapse to zero size.
    def set_collapsible(index : Int, value : Bool) : self
      LibQt6.qt6cr_splitter_set_collapsible(to_unsafe, index.to_i32, value)
      self
    end

    # Returns `true` when the pane at the given index may collapse.
    def collapsible?(index : Int) : Bool
      LibQt6.qt6cr_splitter_is_collapsible(to_unsafe, index.to_i32)
    end

    # Refreshes child geometry after splitter contents change.
    def refresh : self
      LibQt6.qt6cr_splitter_refresh(to_unsafe)
      self
    end

    # Returns the preferred splitter size.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_splitter_size_hint(to_unsafe))
    end

    # Returns the minimum preferred splitter size.
    def minimum_size_hint : Size
      Size.from_native(LibQt6.qt6cr_splitter_minimum_size_hint(to_unsafe))
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

    # Saves the current splitter state.
    def save_state : QByteArray
      QByteArray.wrap(LibQt6.qt6cr_splitter_save_state(to_unsafe), true)
    end

    # Restores a previously saved splitter state.
    def restore_state(value : QByteArray) : Bool
      LibQt6.qt6cr_splitter_restore_state(to_unsafe, value.to_unsafe)
    end

    # Convenience overload that accepts raw bytes.
    def restore_state(value : Bytes) : Bool
      state = QByteArray.new(value)
      result = restore_state(state)
      state.release
      result
    end

    # Returns the index of the given child widget, or `-1`.
    def index_of(widget : Widget) : Int32
      LibQt6.qt6cr_splitter_index_of(to_unsafe, widget.to_unsafe)
    end

    # Returns the legal movement range for the handle before the pane at the given index.
    def get_range(index : Int) : Tuple(Int32, Int32)
      value = LibQt6.qt6cr_splitter_get_range(to_unsafe, index.to_i32)
      {value.minimum, value.maximum}
    end

    # Returns the splitter handle at the given index, if present.
    def handle(index : Int) : SplitterHandle?
      handle = LibQt6.qt6cr_splitter_handle(to_unsafe, index.to_i32)
      handle.null? ? nil : SplitterHandle.wrap(handle)
    end

    # Sets the stretch factor for the pane at the given index.
    def set_stretch_factor(index : Int, stretch : Int) : self
      LibQt6.qt6cr_splitter_set_stretch_factor(to_unsafe, index.to_i32, stretch.to_i32)
      self
    end

    # Registers a block to run when a handle moves.
    def on_splitter_moved(&block : Int32, Int32 ->) : self
      @splitter_moved.connect { |pos, index| block.call(pos, index) }
      self
    end

    # Qt-style alias for `orientation=`.
    def set_orientation(value : Orientation) : self
      self.orientation = value
      self
    end

    # Qt-style alias for `opaque_resize=`.
    def set_opaque_resize(value : Bool) : self
      self.opaque_resize = value
      self
    end

    # Qt-style alias for `children_collapsible=`.
    def set_children_collapsible(value : Bool) : self
      self.children_collapsible = value
      self
    end

    # Qt-style alias for `handle_width=`.
    def set_handle_width(value : Int) : self
      self.handle_width = value
      self
    end

    protected def emit_splitter_moved(pos : Int32, index : Int32) : Nil
      @splitter_moved.emit(pos, index)
    end

    private SPLITTER_MOVED_TRAMPOLINE = ->(userdata : Void*, pos : Int32, index : Int32) do
      Box(Splitter).unbox(userdata).emit_splitter_moved(pos, index)
    end
  end
end
