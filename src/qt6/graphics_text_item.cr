module Qt6
  # Wraps `QGraphicsTextItem`.
  class GraphicsTextItem < GraphicsObject
    @link_activated : Signal(String) = Signal(String).new
    @link_hovered : Signal(String) = Signal(String).new
    @text_item_callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter link_activated : Signal(String)
    getter link_hovered : Signal(String)

    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_text_item_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      setup_text_item_callbacks
    end

    def initialize(text : String, parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_text_item_create_with_text(text.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      setup_text_item_callbacks
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      setup_text_item_callbacks
    end

    def html : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_graphics_text_item_html(to_unsafe))
    end

    def html=(value : String) : String
      LibQt6.qt6cr_graphics_text_item_set_html(to_unsafe, value.to_unsafe)
      value
    end

    def set_html(value : String) : self
      self.html = value
      self
    end

    def plain_text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_graphics_text_item_plain_text(to_unsafe))
    end

    def plain_text=(value : String) : String
      LibQt6.qt6cr_graphics_text_item_set_plain_text(to_unsafe, value.to_unsafe)
      value
    end

    def set_plain_text(value : String) : self
      self.plain_text = value
      self
    end

    def font : QFont
      QFont.wrap(LibQt6.qt6cr_graphics_text_item_font(to_unsafe), true)
    end

    def font=(value : QFont) : QFont
      LibQt6.qt6cr_graphics_text_item_set_font(to_unsafe, value.to_unsafe)
      value
    end

    def set_font(value : QFont) : self
      self.font = value
      self
    end

    def default_text_color : Color
      Color.from_native(LibQt6.qt6cr_graphics_text_item_default_text_color(to_unsafe))
    end

    def default_text_color=(value : Color) : Color
      LibQt6.qt6cr_graphics_text_item_set_default_text_color(to_unsafe, value.to_native)
      value
    end

    def set_default_text_color(value : Color) : self
      self.default_text_color = value
      self
    end

    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_text_item_bounding_rect(to_unsafe))
    end

    def shape : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_graphics_text_item_shape(to_unsafe), true)
    end

    def contains?(point : PointF) : Bool
      LibQt6.qt6cr_graphics_text_item_contains(to_unsafe, point.to_native)
    end

    def obscured_by?(item : GraphicsItem) : Bool
      LibQt6.qt6cr_graphics_text_item_is_obscured_by(to_unsafe, item.to_unsafe)
    end

    def opaque_area : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_graphics_text_item_opaque_area(to_unsafe), true)
    end

    def text_width : Float64
      LibQt6.qt6cr_graphics_text_item_text_width(to_unsafe)
    end

    def text_width=(value : Number) : Float64
      width = value.to_f64
      LibQt6.qt6cr_graphics_text_item_set_text_width(to_unsafe, width)
      width
    end

    def adjust_size : self
      LibQt6.qt6cr_graphics_text_item_adjust_size(to_unsafe)
      self
    end

    def document : TextDocument
      TextDocument.wrap(LibQt6.qt6cr_graphics_text_item_document(to_unsafe))
    end

    def document=(value : TextDocument) : TextDocument
      LibQt6.qt6cr_graphics_text_item_set_document(to_unsafe, value.to_unsafe)
      value
    end

    def text_interaction_flags : TextInteractionFlag
      TextInteractionFlag.from_value(LibQt6.qt6cr_graphics_text_item_text_interaction_flags(to_unsafe))
    end

    def text_interaction_flags=(value : TextInteractionFlag) : TextInteractionFlag
      LibQt6.qt6cr_graphics_text_item_set_text_interaction_flags(to_unsafe, value.value)
      value
    end

    def set_text_interaction_flags(value : TextInteractionFlag) : self
      self.text_interaction_flags = value
      self
    end

    def tab_changes_focus? : Bool
      LibQt6.qt6cr_graphics_text_item_tab_changes_focus(to_unsafe)
    end

    def tab_changes_focus=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_text_item_set_tab_changes_focus(to_unsafe, value)
      value
    end

    def open_external_links? : Bool
      LibQt6.qt6cr_graphics_text_item_open_external_links(to_unsafe)
    end

    def open_external_links=(value : Bool) : Bool
      LibQt6.qt6cr_graphics_text_item_set_open_external_links(to_unsafe, value)
      value
    end

    def text_cursor : TextCursor
      TextCursor.wrap(LibQt6.qt6cr_graphics_text_item_text_cursor(to_unsafe), true)
    end

    def text_cursor=(value : TextCursor) : TextCursor
      LibQt6.qt6cr_graphics_text_item_set_text_cursor(to_unsafe, value.to_unsafe)
      value
    end

    def on_link_activated(&block : String ->) : self
      @link_activated.connect { |value| block.call(value) }
      self
    end

    def on_link_hovered(&block : String ->) : self
      @link_hovered.connect { |value| block.call(value) }
      self
    end

    protected def emit_link_activated(value : UInt8*) : Nil
      @link_activated.emit(Qt6.copy_string(value))
    end

    protected def emit_link_hovered(value : UInt8*) : Nil
      @link_hovered.emit(Qt6.copy_string(value))
    end

    private def setup_text_item_callbacks : Nil
      @link_activated = Signal(String).new
      @link_hovered = Signal(String).new
      @text_item_callback_userdata = Box.box(self.as(GraphicsTextItem))
      LibQt6.qt6cr_graphics_text_item_on_link_activated(to_unsafe, LINK_ACTIVATED_TRAMPOLINE, @text_item_callback_userdata)
      LibQt6.qt6cr_graphics_text_item_on_link_hovered(to_unsafe, LINK_HOVERED_TRAMPOLINE, @text_item_callback_userdata)
    end

    private LINK_ACTIVATED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(GraphicsTextItem).unbox(userdata).emit_link_activated(value)
    end

    private LINK_HOVERED_TRAMPOLINE = ->(userdata : Void*, value : UInt8*) do
      Box(GraphicsTextItem).unbox(userdata).emit_link_hovered(value)
    end
  end
end
