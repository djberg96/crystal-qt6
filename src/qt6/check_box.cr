module Qt6
  class CheckBox < Widget
    @toggled : Signal(Bool) = Signal(Bool).new
    @callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter toggled : Signal(Bool)

    def initialize(text : String = "", parent : Widget? = nil)
      super(LibQt6.qt6cr_check_box_create(parent.try(&.to_unsafe) || Pointer(Void).null, text.to_unsafe), parent.nil?)
      @toggled = Signal(Bool).new
      @callback_userdata = Box.box(self)
      LibQt6.qt6cr_check_box_on_toggled(to_unsafe, TOGGLED_TRAMPOLINE, @callback_userdata)
    end

    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_check_box_text(to_unsafe))
    end

    def text=(value : String) : String
      LibQt6.qt6cr_check_box_set_text(to_unsafe, value.to_unsafe)
      value
    end

    def checked? : Bool
      LibQt6.qt6cr_check_box_is_checked(to_unsafe)
    end

    def checked=(value : Bool) : Bool
      LibQt6.qt6cr_check_box_set_checked(to_unsafe, value)
      value
    end

    def on_toggled(&block : Bool ->) : self
      @toggled.connect { |value| block.call(value) }
      self
    end

    protected def emit_toggled(value : Bool) : Nil
      @toggled.emit(value)
    end

    private TOGGLED_TRAMPOLINE = ->(userdata : Void*, value : Bool) do
      Box(CheckBox).unbox(userdata).emit_toggled(value)
    end
  end
end
