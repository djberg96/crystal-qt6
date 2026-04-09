module Qt6
  class PushButton < Widget
    @clicked : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter clicked : Signal()

    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_push_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      @clicked = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_push_button_on_clicked(to_unsafe, CLICK_TRAMPOLINE, @callback_userdata)
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_push_button_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_push_button_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def on_clicked(&block : ->) : self
      @clicked.connect { block.call }
      self
    end

    def click : self
      LibQt6.qt6cr_push_button_click(to_unsafe)
      self
    end

    protected def emit_clicked : Nil
      @clicked.emit
    end

    private CLICK_TRAMPOLINE = ->(userdata : Void*) do
      Box(PushButton).unbox(userdata).emit_clicked
    end
  end
end
