module Qt6
  # Wraps `QPushButton`.
  class PushButton < Widget
    @clicked : Signal() = Signal().new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    # Signal emitted when the button is clicked.
    getter clicked : Signal()

    # Creates a push button with optional text and parent.
    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_push_button_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      @clicked = Signal().new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_push_button_on_clicked(to_unsafe, CLICK_TRAMPOLINE, @callback_userdata)
    end

    # Returns the button text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_push_button_text(to_unsafe))
    end

    # Sets the button text and returns the assigned value.
    def text=(value : String) : String
      LibQt6.qt6cr_push_button_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Registers a block to run when the button is clicked.
    def on_clicked(&block : ->) : self
      @clicked.connect { block.call }
      self
    end

    # Programmatically clicks the button.
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
