module Qt6
  # Wraps `QSystemTrayIcon` for desktop tray integration.
  class SystemTrayIcon < QObject
    @activated : Signal(SystemTrayActivationReason) = Signal(SystemTrayActivationReason).new
    @message_clicked : Signal() = Signal().new
    @activated_userdata : LibQt6::Handle = Pointer(Void).null
    @message_clicked_userdata : LibQt6::Handle = Pointer(Void).null

    getter activated : Signal(SystemTrayActivationReason)
    getter message_clicked : Signal()

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.system_tray_available? : Bool
      LibQt6.qt6cr_system_tray_icon_is_system_tray_available
    end

    def self.supports_messages? : Bool
      LibQt6.qt6cr_system_tray_icon_supports_messages
    end

    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_system_tray_icon_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      register_callbacks
    end

    def initialize(icon : QIcon, parent : QObject? = nil)
      super(LibQt6.qt6cr_system_tray_icon_create_with_icon(parent.try(&.to_unsafe) || Pointer(Void).null, icon.to_unsafe), parent.nil?)
      register_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      register_callbacks
    end

    private def register_callbacks : Nil
      @activated = Signal(SystemTrayActivationReason).new
      @message_clicked = Signal().new
      @activated_userdata = Box.box(self)
      @message_clicked_userdata = Box.box(self)
      LibQt6.qt6cr_system_tray_icon_on_activated(to_unsafe, ACTIVATED_TRAMPOLINE, @activated_userdata)
      LibQt6.qt6cr_system_tray_icon_on_message_clicked(to_unsafe, MESSAGE_CLICKED_TRAMPOLINE, @message_clicked_userdata)
    end

    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_system_tray_icon_icon(to_unsafe), true)
    end

    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_system_tray_icon_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    def tool_tip : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_system_tray_icon_tool_tip(to_unsafe))
    end

    def tool_tip=(value : String) : String
      LibQt6.qt6cr_system_tray_icon_set_tool_tip(to_unsafe, value.to_unsafe)
      value
    end

    def visible? : Bool
      LibQt6.qt6cr_system_tray_icon_is_visible(to_unsafe)
    end

    def visible=(value : Bool) : Bool
      LibQt6.qt6cr_system_tray_icon_set_visible(to_unsafe, value)
      value
    end

    def geometry : Rect
      Rect.from_native(LibQt6.qt6cr_system_tray_icon_geometry(to_unsafe))
    end

    def show : self
      LibQt6.qt6cr_system_tray_icon_show(to_unsafe)
      self
    end

    def hide : self
      LibQt6.qt6cr_system_tray_icon_hide(to_unsafe)
      self
    end

    def context_menu : Menu?
      handle = LibQt6.qt6cr_system_tray_icon_context_menu(to_unsafe)
      handle.null? ? nil : Menu.wrap(handle)
    end

    def context_menu=(menu : Menu?) : Menu?
      LibQt6.qt6cr_system_tray_icon_set_context_menu(to_unsafe, menu.try(&.to_unsafe) || Pointer(Void).null)
      menu.try(&.adopt_by_parent!)
      menu
    end

    def show_message(title : String, message : String, *, icon : SystemTrayMessageIcon = SystemTrayMessageIcon::Information, timeout : Int = 10000) : self
      LibQt6.qt6cr_system_tray_icon_show_message(to_unsafe, title.to_unsafe, message.to_unsafe, icon.value, timeout.to_i32)
      self
    end

    def show_message(title : String, message : String, icon : QIcon, timeout : Int = 10000) : self
      LibQt6.qt6cr_system_tray_icon_show_message_with_icon(to_unsafe, title.to_unsafe, message.to_unsafe, icon.to_unsafe, timeout.to_i32)
      self
    end

    def supports_messages? : Bool
      self.class.supports_messages?
    end

    def set_icon(value : QIcon) : self
      self.icon = value
      self
    end

    def set_tool_tip(value : String) : self
      self.tool_tip = value
      self
    end

    def set_visible(value : Bool) : self
      self.visible = value
      self
    end

    def set_context_menu(value : Menu?) : self
      self.context_menu = value
      self
    end

    def on_activated(&block : SystemTrayActivationReason ->) : self
      @activated.connect { |reason| block.call(reason) }
      self
    end

    def on_message_clicked(&block : ->) : self
      @message_clicked.connect { block.call }
      self
    end

    protected def emit_activated(value : Int32) : Nil
      @activated.emit(SystemTrayActivationReason.from_value(value))
    end

    protected def emit_message_clicked : Nil
      @message_clicked.emit
    end

    private ACTIVATED_TRAMPOLINE = ->(userdata : Void*, value : Int32) do
      Box(SystemTrayIcon).unbox(userdata).emit_activated(value)
    end

    private MESSAGE_CLICKED_TRAMPOLINE = ->(userdata : Void*) do
      Box(SystemTrayIcon).unbox(userdata).emit_message_clicked
    end
  end
end
