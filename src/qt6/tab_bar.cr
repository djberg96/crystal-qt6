module Qt6
  # Wraps `QTabBar`.
  class TabBar < Widget
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_index_changed : Signal(Int32)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_tab_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tab_bar_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_tab_bar_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    def add_tab(label : String) : Int32
      LibQt6.qt6cr_tab_bar_add_tab(to_unsafe, label.to_unsafe)
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

    def draw_base? : Bool
      LibQt6.qt6cr_tab_bar_draw_base(to_unsafe)
    end

    def draw_base=(value : Bool) : Bool
      LibQt6.qt6cr_tab_bar_set_draw_base(to_unsafe, value)
      value
    end

    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(TabBar).unbox(userdata).emit_current_index_changed(value)
    end
  end
end
