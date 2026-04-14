require "./qt6/native"
require "./qt6/error"
require "./qt6/managed_resource"
require "./qt6/native_resource"
require "./qt6/color"
require "./qt6/image_format"
require "./qt6/io_device_open_mode"
require "./qt6/margins_f"
require "./qt6/page_orientation"
require "./qt6/page_size_unit"
require "./qt6/page_size"
require "./qt6/page_layout"
require "./qt6/point_f"
require "./qt6/size"
require "./qt6/size_f"
require "./qt6/rect"
require "./qt6/rect_f"
require "./qt6/paint_event"
require "./qt6/resize_event"
require "./qt6/mouse_event"
require "./qt6/wheel_event"
require "./qt6/key_event"
require "./qt6/event_type"
require "./qt6/signal"
require "./qt6/q_icon"
require "./qt6/application"
require "./qt6/q_object"
require "./qt6/q_event"
require "./qt6/event_filter"
require "./qt6/no_scroll_filter"
require "./qt6/q_event_loop"
require "./qt6/q_transform"
require "./qt6/q_polygon_f"
require "./qt6/q_painter_path"
require "./qt6/q_painter_path_stroker"
require "./qt6/q_image"
require "./qt6/q_image_reader"
require "./qt6/q_pixmap"
require "./qt6/q_byte_array"
require "./qt6/q_buffer"
require "./qt6/model_index"
require "./qt6/model_index_spec"
require "./qt6/item_data_role"
require "./qt6/item_flag"
require "./qt6/check_state"
require "./qt6/orientation"
require "./qt6/sort_order"
require "./qt6/case_sensitivity"
require "./qt6/drop_action"
require "./qt6/item_selection_mode"
require "./qt6/item_view_drag_drop_mode"
require "./qt6/model_data"
require "./qt6/abstract_item_model"
require "./qt6/abstract_list_model"
require "./qt6/abstract_tree_model"
require "./qt6/item_selection_model"
require "./qt6/standard_item"
require "./qt6/standard_item_model"
require "./qt6/sort_filter_proxy_model"
require "./qt6/mime_data"
require "./qt6/clipboard"
require "./qt6/q_svg_generator"
require "./qt6/q_svg_renderer"
require "./qt6/q_pdf_writer"
require "./qt6/pen_style"
require "./qt6/pen_cap_style"
require "./qt6/pen_join_style"
require "./qt6/painter_composition_mode"
require "./qt6/q_pen"
require "./qt6/q_linear_gradient"
require "./qt6/q_radial_gradient"
require "./qt6/q_brush"
require "./qt6/q_font"
require "./qt6/q_font_metrics"
require "./qt6/q_font_metrics_f"
require "./qt6/q_painter"
require "./qt6/dock_area"
require "./qt6/dialog_code"
require "./qt6/message_box_icon"
require "./qt6/message_box_button"
require "./qt6/file_dialog_accept_mode"
require "./qt6/file_dialog_file_mode"
require "./qt6/input_dialog_input_mode"
require "./qt6/key_sequence"
require "./qt6/size_policy"
require "./qt6/focus_policy"
require "./qt6/widget"
require "./qt6/abstract_button"
require "./qt6/q_svg_widget"
require "./qt6/layout"
require "./qt6/action"
require "./qt6/action_group"
require "./qt6/menu"
require "./qt6/menu_bar"
require "./qt6/status_bar"
require "./qt6/tool_bar"
require "./qt6/main_window"
require "./qt6/dialog"
require "./qt6/message_box"
require "./qt6/file_dialog"
require "./qt6/color_dialog"
require "./qt6/input_dialog"
require "./qt6/progress_dialog"
require "./qt6/splash_screen"
require "./qt6/dock_widget"
require "./qt6/drop_event"
require "./qt6/event_widget"
require "./qt6/label"
require "./qt6/tool_button_style"
require "./qt6/push_button"
require "./qt6/tool_button"
require "./qt6/line_edit"
require "./qt6/check_box"
require "./qt6/radio_button"
require "./qt6/button_group"
require "./qt6/combo_box"
require "./qt6/font_combo_box"
require "./qt6/list_widget_item"
require "./qt6/list_widget"
require "./qt6/tree_widget_item"
require "./qt6/tree_widget"
require "./qt6/styled_item_delegate"
require "./qt6/list_view"
require "./qt6/tree_view"
require "./qt6/slider"
require "./qt6/abstract_spin_box_button_symbol"
require "./qt6/abstract_spin_box"
require "./qt6/spin_box"
require "./qt6/double_spin_box"
require "./qt6/group_box"
require "./qt6/frame_shape"
require "./qt6/frame_shadow"
require "./qt6/frame"
require "./qt6/text_browser"
require "./qt6/tab_widget"
require "./qt6/stacked_widget"
require "./qt6/scroll_bar_policy"
require "./qt6/scroll_area"
require "./qt6/dialog_button_box_standard_button"
require "./qt6/dialog_button_box"
require "./qt6/splitter"
require "./qt6/q_timer"
require "./qt6/h_box_layout"
require "./qt6/grid_layout"
require "./qt6/form_layout"
require "./qt6/v_box_layout"

module Qt6
  # Current shard version.
  VERSION = "0.3.0"
  @@application : Application?
  @@tracked_objects = [] of ManagedResource
  @@shutdown_registered = false

  # Creates or returns the shared `QApplication` wrapper for the process.
  #
  # The first call initializes Qt and registers the automatic shutdown hook.
  def self.application(args : Enumerable(String) = ARGV)
    register_shutdown_hook
    @@application ||= Application.new(args.to_a)
  end

  # Returns the shared application clipboard wrapper.
  def self.clipboard : Clipboard
    application.clipboard
  end

  # Releases tracked Qt objects and shuts down the shared application.
  #
  # Most applications can rely on the automatic `at_exit` hook, but this
  # method is available when you want a deterministic shutdown point.
  def self.shutdown : Nil
    tracked_objects = @@tracked_objects.dup
    tracked_objects.reverse_each(&.release)
    @@tracked_objects.clear

    application = @@application
    return unless application

    application.shutdown
    @@application = nil
  end

  # Builds a top-level `Widget`, applies a title and initial size, and yields
  # it for configuration.
  def self.window(title : String, width : Int32 = 800, height : Int32 = 600, &)
    widget = Widget.new
    widget.window_title = title
    widget.resize(width, height)
    yield widget
    widget
  end

  # Copies a native UTF-8 string into Crystal memory and releases the native
  # allocation.
  def self.copy_and_release_string(pointer : UInt8*) : String
    return "" if pointer.null?

    value = String.new(pointer)
    LibQt6.qt6cr_string_free(pointer)
    value
  end

  def self.copy_string(pointer : UInt8*) : String
    pointer.null? ? "" : String.new(pointer)
  end

  def self.copy_and_release_bytes(value : LibQt6::ByteArrayValue) : Bytes
    pointer = value.data
    size = value.size

    if pointer.null? || size <= 0
      LibQt6.qt6cr_string_free(pointer) unless pointer.null?
      return Bytes.empty
    end

    bytes = Bytes.new(size)
    bytes.to_unsafe.copy_from(pointer, size)
    LibQt6.qt6cr_string_free(pointer)
    bytes
  end

  def self.copy_and_release_strings(value : LibQt6::StringArrayValue) : Array(String)
    pointer = value.data
    size = value.size

    if pointer.null? || size <= 0
      LibQt6.qt6cr_string_array_free(value)
      return [] of String
    end

    strings = Array(String).new(size)
    size.times do |index|
      item = pointer[index]
      strings << (item.null? ? "" : String.new(item))
    end

    LibQt6.qt6cr_string_array_free(value)
    strings
  end

  def self.malloc_string(value : String) : UInt8*
    bytesize = value.bytesize
    pointer = LibC.malloc(bytesize + 1).as(UInt8*)
    pointer.copy_from(value.to_unsafe, bytesize)
    pointer[bytesize] = 0u8
    pointer
  end

  def self.track_object(object : ManagedResource) : Nil
    @@tracked_objects << object
  end

  def self.untrack_object(object : ManagedResource) : Nil
    @@tracked_objects.delete(object)
  end

  private def self.register_shutdown_hook : Nil
    return if @@shutdown_registered

    at_exit { Qt6.shutdown }
    @@shutdown_registered = true
  end
end
