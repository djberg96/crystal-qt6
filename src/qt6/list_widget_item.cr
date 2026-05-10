module Qt6
  # Wraps `QListWidgetItem` for item-based list panels.
  class ListWidgetItem < NativeResource
    # Wraps an existing native item handle.
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a list item with optional display text.
    def initialize(text : String = "")
      super(LibQt6.qt6cr_list_widget_item_create(text.to_unsafe))
    end

    # Creates a list item with an icon and display text.
    def initialize(icon : QIcon, text : String)
      super(LibQt6.qt6cr_list_widget_item_create_with_icon(icon.to_unsafe, text.to_unsafe))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the item text.
    def text : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_list_widget_item_text(to_unsafe))
    end

    # Sets the item text.
    def text=(value : String) : String
      LibQt6.qt6cr_list_widget_item_set_text(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the item's icon.
    def icon : QIcon
      QIcon.wrap(LibQt6.qt6cr_list_widget_item_icon(to_unsafe), true)
    end

    # Sets the item's icon.
    def icon=(value : QIcon) : QIcon
      LibQt6.qt6cr_list_widget_item_set_icon(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the item's current flags.
    def flags : ItemFlag
      ItemFlag.from_value(LibQt6.qt6cr_list_widget_item_flags(to_unsafe))
    end

    # Sets the item's current flags.
    def flags=(value : ItemFlag) : ItemFlag
      LibQt6.qt6cr_list_widget_item_set_flags(to_unsafe, value.value)
      value
    end

    # Returns the item's check state.
    def check_state : CheckState
      CheckState.from_value(LibQt6.qt6cr_list_widget_item_check_state(to_unsafe))
    end

    # Sets the item's check state.
    def check_state=(value : CheckState) : CheckState
      LibQt6.qt6cr_list_widget_item_set_check_state(to_unsafe, value.value)
      value
    end

    # Returns item data for the given role.
    def data(role : ItemDataRole = ItemDataRole::Display) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_list_widget_item_data(to_unsafe, role.value))
    end

    # Sets item data for the given role.
    def set_data(value, role : ItemDataRole = ItemDataRole::Edit) : self
      LibQt6.qt6cr_list_widget_item_set_data(to_unsafe, role.value, Qt6.model_data_to_native(value))
      self
    end

    # Returns the item's foreground color.
    def foreground : Color
      Color.from_native(LibQt6.qt6cr_list_widget_item_foreground(to_unsafe))
    end

    # Sets the item's foreground color.
    def foreground=(value : Color) : Color
      LibQt6.qt6cr_list_widget_item_set_foreground(to_unsafe, value.to_native)
      value
    end

    # Returns the item's background brush.
    def background : QBrush
      QBrush.wrap(LibQt6.qt6cr_list_widget_item_background(to_unsafe), true)
    end

    # Sets the item's background brush.
    def background=(value : QBrush) : QBrush
      LibQt6.qt6cr_list_widget_item_set_background(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the item's font.
    def font : QFont
      QFont.wrap(LibQt6.qt6cr_list_widget_item_font(to_unsafe), true)
    end

    # Sets the item's font.
    def font=(value : QFont) : QFont
      LibQt6.qt6cr_list_widget_item_set_font(to_unsafe, value.to_unsafe)
      value
    end

    # Returns `true` when the item is hidden.
    def hidden? : Bool
      LibQt6.qt6cr_list_widget_item_is_hidden(to_unsafe)
    end

    # Shows or hides the item.
    def hidden=(value : Bool) : Bool
      LibQt6.qt6cr_list_widget_item_set_hidden(to_unsafe, value)
      value
    end

    # Returns `true` when the item is selected.
    def selected? : Bool
      LibQt6.qt6cr_list_widget_item_is_selected(to_unsafe)
    end

    # Selects or deselects the item.
    def selected=(value : Bool) : Bool
      LibQt6.qt6cr_list_widget_item_set_selected(to_unsafe, value)
      value
    end

    # Returns the preferred item size hint.
    def size_hint : Size
      Size.from_native(LibQt6.qt6cr_list_widget_item_size_hint(to_unsafe))
    end

    # Sets the preferred item size hint.
    def size_hint=(value : Size) : Size
      LibQt6.qt6cr_list_widget_item_set_size_hint(to_unsafe, LibQt6::SizeValue.new(width: value.width, height: value.height))
      value
    end

    # Returns the item's text alignment flags.
    def text_alignment : AlignmentFlag
      AlignmentFlag.from_value(LibQt6.qt6cr_list_widget_item_text_alignment(to_unsafe))
    end

    # Sets the item's text alignment flags.
    def text_alignment=(value : AlignmentFlag) : AlignmentFlag
      LibQt6.qt6cr_list_widget_item_set_text_alignment(to_unsafe, value.value)
      value
    end

    # Returns the item's tool-tip text.
    def tool_tip : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_list_widget_item_tool_tip(to_unsafe))
    end

    # Sets the item's tool-tip text.
    def tool_tip=(value : String) : String
      LibQt6.qt6cr_list_widget_item_set_tool_tip(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the item's status-tip text.
    def status_tip : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_list_widget_item_status_tip(to_unsafe))
    end

    # Sets the item's status-tip text.
    def status_tip=(value : String) : String
      LibQt6.qt6cr_list_widget_item_set_status_tip(to_unsafe, value.to_unsafe)
      value
    end

    # Returns the item's What's This help text.
    def whats_this : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_list_widget_item_whats_this(to_unsafe))
    end

    # Sets the item's What's This help text.
    def whats_this=(value : String) : String
      LibQt6.qt6cr_list_widget_item_set_whats_this(to_unsafe, value.to_unsafe)
      value
    end

    # Stops tracking the item after ownership moves to a native parent widget.
    def adopt_by_parent! : Nil
      return unless @owned

      Qt6.untrack_object(self)
      @owned = false
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_list_widget_item_destroy(to_unsafe)
    end
  end
end
