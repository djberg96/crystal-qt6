module Qt6
  # Wraps `QTabBar`.
  class TabBar < Widget
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @tab_close_requested : Signal(Int32) = Signal(Int32).new
    @tab_moved : Signal(Int32, Int32) = Signal(Int32, Int32).new
    @tab_bar_clicked : Signal(Int32) = Signal(Int32).new
    @tab_bar_double_clicked : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_index_changed : Signal(Int32)
    getter tab_close_requested : Signal(Int32)
    getter tab_moved : Signal(Int32, Int32)
    getter tab_bar_clicked : Signal(Int32)
    getter tab_bar_double_clicked : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tab_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @current_index_changed = Signal(Int32).new
      @tab_close_requested = Signal(Int32).new
      @tab_moved = Signal(Int32, Int32).new
      @tab_bar_clicked = Signal(Int32).new
      @tab_bar_double_clicked = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tab_bar_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tab_bar_on_tab_close_requested(to_unsafe, TAB_CLOSE_REQUESTED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tab_bar_on_tab_moved(to_unsafe, TAB_MOVED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tab_bar_on_tab_bar_clicked(to_unsafe, TAB_BAR_CLICKED_TRAMPOLINE, @callback_userdata)
      LibQt6.qt6cr_tab_bar_on_tab_bar_double_clicked(to_unsafe, TAB_BAR_DOUBLE_CLICKED_TRAMPOLINE, @callback_userdata)
    end

    def add_tab(label : String) : Int32
      LibQt6.qt6cr_tab_bar_add_tab(to_unsafe, label.to_unsafe)
    end

    def add_tab(icon : QIcon, label : String) : Int32
      LibQt6.qt6cr_tab_bar_add_tab_with_icon(to_unsafe, icon.to_unsafe, label.to_unsafe)
    end

    def insert_tab(index : Int, label : String) : Int32
      LibQt6.qt6cr_tab_bar_insert_tab(to_unsafe, index.to_i32, label.to_unsafe)
    end

    def insert_tab(index : Int, icon : QIcon, label : String) : Int32
      LibQt6.qt6cr_tab_bar_insert_tab_with_icon(to_unsafe, index.to_i32, icon.to_unsafe, label.to_unsafe)
    end

    def remove_tab(index : Int) : self
      LibQt6.qt6cr_tab_bar_remove_tab(to_unsafe, index.to_i32)
      self
    end

    def move_tab(from : Int, to : Int) : self
      LibQt6.qt6cr_tab_bar_move_tab(to_unsafe, from.to_i32, to.to_i32)
      self
    end

    def shape : TabBarShape
      TabBarShape.from_value(LibQt6.qt6cr_tab_bar_shape(to_unsafe))
    end

    def shape=(value : TabBarShape) : TabBarShape
      LibQt6.qt6cr_tab_bar_set_shape(to_unsafe, value.value)
      value
    end

    def count : Int32
      LibQt6.qt6cr_tab_bar_count(to_unsafe)
    end

    def current_index : Int32
      LibQt6.qt6cr_tab_bar_current_index(to_unsafe)
    end

    def current_index=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_tab_bar_set_current_index(to_unsafe, int_value)
      int_value
    end

    def tab_text(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tab_bar_tab_text(to_unsafe, index.to_i32))
    end

    def set_tab_text(index : Int, value : String) : String
      LibQt6.qt6cr_tab_bar_set_tab_text(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    def tab_enabled?(index : Int) : Bool
      LibQt6.qt6cr_tab_bar_tab_enabled(to_unsafe, index.to_i32)
    end

    def set_tab_enabled(index : Int, value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_tab_enabled(to_unsafe, index.to_i32, value)
      value
    end

    def tab_visible?(index : Int) : Bool
      LibQt6.qt6cr_tab_bar_tab_visible(to_unsafe, index.to_i32)
    end

    def set_tab_visible(index : Int, value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_tab_visible(to_unsafe, index.to_i32, value)
      value
    end

    def tab_text_color(index : Int) : Color
      Color.from_native(LibQt6.qt6cr_tab_bar_tab_text_color(to_unsafe, index.to_i32))
    end

    def set_tab_text_color(index : Int, value : Color) : Color
      LibQt6.qt6cr_tab_bar_set_tab_text_color(to_unsafe, index.to_i32, value.to_native)
      value
    end

    def tab_icon(index : Int) : QIcon
      QIcon.wrap(LibQt6.qt6cr_tab_bar_tab_icon(to_unsafe, index.to_i32), true)
    end

    def set_tab_icon(index : Int, value : QIcon) : QIcon
      LibQt6.qt6cr_tab_bar_set_tab_icon(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    def elide_mode : TextElideMode
      TextElideMode.from_value(LibQt6.qt6cr_tab_bar_elide_mode(to_unsafe))
    end

    def elide_mode=(value : TextElideMode) : TextElideMode
      LibQt6.qt6cr_tab_bar_set_elide_mode(to_unsafe, value.value)
      value
    end

    def tab_tool_tip(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tab_bar_tab_tool_tip(to_unsafe, index.to_i32))
    end

    def set_tab_tool_tip(index : Int, value : String) : String
      LibQt6.qt6cr_tab_bar_set_tab_tool_tip(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    def tab_whats_this(index : Int) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_tab_bar_tab_whats_this(to_unsafe, index.to_i32))
    end

    def set_tab_whats_this(index : Int, value : String) : String
      LibQt6.qt6cr_tab_bar_set_tab_whats_this(to_unsafe, index.to_i32, value.to_unsafe)
      value
    end

    def tab_rect(index : Int) : Rect
      Rect.from_native(LibQt6.qt6cr_tab_bar_tab_rect(to_unsafe, index.to_i32))
    end

    def tab_at(position : Point) : Int32
      LibQt6.qt6cr_tab_bar_tab_at(to_unsafe, position.to_native)
    end

    def tab_at(position : PointF) : Int32
      tab_at(Point.new(position.x.round.to_i, position.y.round.to_i))
    end

    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_tab_bar_size_hint(to_unsafe))
    end

    def minimum_size_hint : Size
      Size.from_native(LibQt6.qt6cr_tab_bar_minimum_size_hint(to_unsafe))
    end

    def draw_base? : Bool
      LibQt6.qt6cr_tab_bar_draw_base(to_unsafe)
    end

    def draw_base=(value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_draw_base(to_unsafe, value)
      value
    end

    def movable? : Bool
      LibQt6.qt6cr_tab_bar_movable(to_unsafe)
    end

    def movable=(value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_movable(to_unsafe, value)
      value
    end

    def tabs_closable? : Bool
      LibQt6.qt6cr_tab_bar_tabs_closable(to_unsafe)
    end

    def tabs_closable=(value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_tabs_closable(to_unsafe, value)
      value
    end

    def icon_size : Size
      Size.from_native(LibQt6.qt6cr_tab_bar_icon_size(to_unsafe))
    end

    def icon_size=(value : Size) : Size
      LibQt6.qt6cr_tab_bar_set_icon_size(to_unsafe, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    def uses_scroll_buttons? : Bool
      LibQt6.qt6cr_tab_bar_uses_scroll_buttons(to_unsafe)
    end

    def uses_scroll_buttons=(value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_uses_scroll_buttons(to_unsafe, value)
      value
    end

    def selection_behavior_on_remove : TabBarSelectionBehavior
      TabBarSelectionBehavior.from_value(LibQt6.qt6cr_tab_bar_selection_behavior_on_remove(to_unsafe))
    end

    def selection_behavior_on_remove=(value : TabBarSelectionBehavior) : TabBarSelectionBehavior
      LibQt6.qt6cr_tab_bar_set_selection_behavior_on_remove(to_unsafe, value.value)
      value
    end

    def expanding? : Bool
      LibQt6.qt6cr_tab_bar_expanding(to_unsafe)
    end

    def expanding=(value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_expanding(to_unsafe, value)
      value
    end

    def document_mode? : Bool
      LibQt6.qt6cr_tab_bar_document_mode(to_unsafe)
    end

    def document_mode=(value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_document_mode(to_unsafe, value)
      value
    end

    def auto_hide? : Bool
      LibQt6.qt6cr_tab_bar_auto_hide(to_unsafe)
    end

    def auto_hide=(value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_auto_hide(to_unsafe, value)
      value
    end

    def change_current_on_drag? : Bool
      LibQt6.qt6cr_tab_bar_change_current_on_drag(to_unsafe)
    end

    def change_current_on_drag=(value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_change_current_on_drag(to_unsafe, value)
      value
    end

    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
    end

    def on_tab_close_requested(&block : Int32 ->) : self
      @tab_close_requested.connect { |value| block.call(value) }
      self
    end

    def on_tab_moved(&block : Int32, Int32 ->) : self
      @tab_moved.connect { |from, to| block.call(from, to) }
      self
    end

    def on_tab_bar_clicked(&block : Int32 ->) : self
      @tab_bar_clicked.connect { |value| block.call(value) }
      self
    end

    def on_tab_bar_double_clicked(&block : Int32 ->) : self
      @tab_bar_double_clicked.connect { |value| block.call(value) }
      self
    end

    def set_shape(value : TabBarShape) : self
      self.shape = value
      self
    end

    def set_elide_mode(value : TextElideMode) : self
      self.elide_mode = value
      self
    end

    def set_icon_size(value : Size) : self
      self.icon_size = value
      self
    end

    def set_uses_scroll_buttons(value : Bool) : self
      self.uses_scroll_buttons = value
      self
    end

    def set_selection_behavior_on_remove(value : TabBarSelectionBehavior) : self
      self.selection_behavior_on_remove = value
      self
    end

    def set_expanding(value : Bool) : self
      self.expanding = value
      self
    end

    def set_document_mode(value : Bool) : self
      self.document_mode = value
      self
    end

    def set_auto_hide(value : Bool) : self
      self.auto_hide = value
      self
    end

    def set_change_current_on_drag(value : Bool) : self
      self.change_current_on_drag = value
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    protected def emit_tab_close_requested(value : Int32) : Nil
      @tab_close_requested.emit(value)
    end

    protected def emit_tab_moved(from : Int32, to : Int32) : Nil
      @tab_moved.emit(from, to)
    end

    protected def emit_tab_bar_clicked(value : Int32) : Nil
      @tab_bar_clicked.emit(value)
    end

    protected def emit_tab_bar_double_clicked(value : Int32) : Nil
      @tab_bar_double_clicked.emit(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabBar).unbox(userdata).emit_current_index_changed(value)
    end

    private TAB_CLOSE_REQUESTED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabBar).unbox(userdata).emit_tab_close_requested(value)
    end

    private TAB_MOVED_TRAMPOLINE = ->(userdata : Void*, from : Int32, to : Int32) do
      Box(TabBar).unbox(userdata).emit_tab_moved(from, to)
    end

    private TAB_BAR_CLICKED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabBar).unbox(userdata).emit_tab_bar_clicked(value)
    end

    private TAB_BAR_DOUBLE_CLICKED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabBar).unbox(userdata).emit_tab_bar_double_clicked(value)
    end
  end
end
