module Qt6
  class ComboBox < Widget
    @current_index_changed : Signal(Int32) = Signal(Int32).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter current_index_changed : Signal(Int32)

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_combo_box_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @current_index_changed = Signal(Int32).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_combo_box_on_current_index_changed(to_unsafe, INDEX_CHANGED_TRAMPOLINE, @callback_userdata)
    end

    def add_item(text : String) : self
      LibQt6.qt6cr_combo_box_add_item(to_unsafe, text.to_unsafe)
      self
    end

    def <<(text : String) : self
      add_item(text)
      self
    end

    def count : Int32
      LibQt6.qt6cr_combo_box_count(to_unsafe)
    end

    def current_index : Int32
      LibQt6.qt6cr_combo_box_current_index(to_unsafe)
    end

    def current_index=(value : Int) : Int32
      LibQt6.qt6cr_combo_box_set_current_index(to_unsafe, value)
      value.to_i
    end

    def current_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_combo_box_current_text(to_unsafe))
    end

    def on_current_index_changed(&block : Int32 ->) : self
      @current_index_changed.connect { |value| block.call(value) }
      self
    end

    protected def emit_current_index_changed(value : Int32) : Nil
      @current_index_changed.emit(value)
    end

    private INDEX_CHANGED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(ComboBox).unbox(userdata).emit_current_index_changed(value)
    end
  end
end
