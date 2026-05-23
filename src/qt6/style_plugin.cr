module Qt6
  # Wraps a callback-backed `QStylePlugin`.
  class StylePlugin < QObject
    @create_callback : Proc(String, Style?)? = nil
    @callback_userdata : LibQt6::Handle = Pointer(Void).null
    @style_wrappers = {} of LibQt6::Handle => Style

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_style_plugin_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      @callback_userdata = Box.box(self)
    end

    # Registers a block that can vend a style for the requested Qt key.
    def on_create(&block : String -> Style?) : self
      @create_callback = block
      LibQt6.qt6cr_style_plugin_on_create(to_unsafe, CREATE_TRAMPOLINE, @callback_userdata)
      self
    end

    # Requests a style instance for the given key.
    def create(key : String) : Style?
      handle = LibQt6.qt6cr_style_plugin_create_style(to_unsafe, key.to_unsafe)
      resolve_style(handle)
    end

    protected def build_style(key : String) : Style?
      callback = @create_callback
      return nil unless callback

      style = callback.call(key)
      remember_style(style) if style
      style
    end

    protected def resolve_style(handle : LibQt6::Handle) : Style?
      return nil if handle.null?

      @style_wrappers[handle]? || Style.wrap(handle)
    end

    private def remember_style(style : Style) : Style
      @style_wrappers[style.to_unsafe] = style
      style.destroyed.connect { @style_wrappers.delete(style.to_unsafe) }
      style
    end

    private CREATE_TRAMPOLINE = ->(userdata : Void*, key : UInt8*) do
      plugin = Box(StylePlugin).unbox(userdata)
      plugin.build_style(String.new(key)).try(&.to_unsafe) || Pointer(Void).null
    end
  end
end
