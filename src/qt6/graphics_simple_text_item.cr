module Qt6
  # Wraps `QGraphicsSimpleTextItem`.
  class GraphicsSimpleTextItem < AbstractGraphicsShapeItem
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a simple text item, optionally parented to another graphics item.
    def initialize(parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_simple_text_item_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Creates a simple text item with the given text, optionally parented.
    def initialize(text : String, parent : GraphicsItem? = nil)
      super(LibQt6.qt6cr_graphics_simple_text_item_create_with_text(text.to_unsafe, parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the current text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_graphics_simple_text_item_text(to_unsafe))
    end

    # Sets the text and returns it.
    def text=(value : String) : String
      LibQt6.qt6cr_graphics_simple_text_item_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `text=`.
    def set_text(value : String) : self
      self.text = value
      self
    end

    # Returns the current font.
    def font : QFont
      QFont.wrap(LibQt6.qt6cr_graphics_simple_text_item_font(to_unsafe), true)
    end

    # Sets the font and returns it.
    def font=(value : QFont) : QFont
      LibQt6.qt6cr_graphics_simple_text_item_set_font(to_unsafe, value.to_unsafe)
      value
    end

    # Qt-style alias for `font=`.
    def set_font(value : QFont) : self
      self.font = value
      self
    end

    # Returns the text item's bounding rectangle.
    def bounding_rect : RectF
      RectF.from_native(LibQt6.qt6cr_graphics_simple_text_item_bounding_rect(to_unsafe))
    end

    # Returns the text item's painted shape.
    def shape : QPainterPath
      QPainterPath.wrap(LibQt6.qt6cr_graphics_simple_text_item_shape(to_unsafe), true)
    end

    # Returns `true` when the point falls inside the painted text shape.
    def contains?(point : PointF) : Bool
      LibQt6.qt6cr_graphics_simple_text_item_contains(to_unsafe, point.to_native)
    end
  end
end
