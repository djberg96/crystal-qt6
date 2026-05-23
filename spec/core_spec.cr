require "./spec_helper"

describe Qt6 do
  it "supports widget event filters and no-scroll guards" do
    application = app
    host = Qt6::Widget.new
    spin_box = Qt6::SpinBox.new(host)
    spin_box.set_range(0, 10)
    spin_box.value = 5
    spin_box.focus_policy = Qt6::FocusPolicy::StrongFocus

    filter_events = [] of Int32
    filter = Qt6::EventFilter.new(host)
    filter.on_event do |watched, event|
      filter_events << event.type_value
      watched.try(&.to_unsafe) == spin_box.to_unsafe && event.type == Qt6::EventType::Wheel && !spin_box.has_focus?
    end
    spin_box.install_event_filter(filter)

    spin_box.show
    application.process_events
    spin_box.simulate_wheel(Qt6::PointF.new(10.0, 10.0))
    application.process_events

    spin_box.value.should eq(5)
    filter_events.should contain(Qt6::EventType::Wheel.value)

    spin_box.remove_event_filter(filter)
    no_scroll = Qt6::NoScrollFilter.new(host)
    spin_box.install_event_filter(no_scroll)
    spin_box.simulate_wheel(Qt6::PointF.new(10.0, 10.0))
    application.process_events
    spin_box.value.should eq(5)

    spin_box.remove_event_filter(no_scroll)
    application.process_events
    spin_box.simulate_wheel(Qt6::PointF.new(10.0, 10.0))
    application.process_events

    spin_box.value.should be > 5
    spin_box.focus_policy.should eq(Qt6::FocusPolicy::StrongFocus)

    host.release
  end

  it "exposes mouse event details from event filters" do
    application = app
    widget = Qt6::EventWidget.new
    mouse_events = [] of Qt6::MouseEvent

    filter = Qt6::EventFilter.new(widget)
    filter.on_event do |_watched, event|
      if event.type == Qt6::EventType::MouseButtonPress
        mouse_events << event.mouse_event
      end

      false
    end
    widget.install_event_filter(filter)

    widget.show
    application.process_events
    widget.simulate_mouse_press(Qt6::PointF.new(30.0, 40.0), button: 2, buttons: 2)
    application.process_events

    mouse_events.size.should eq(1)
    mouse_events.first.position.should eq(Qt6::PointF.new(30.0, 40.0))
    mouse_events.first.button.should eq(2)
    mouse_events.first.buttons.should eq(2)

    widget.release
  end

  it "exposes geometry types and custom widget event hooks" do
    application = app
    widget = Qt6::EventWidget.new
    paint_events = [] of Qt6::PaintEvent
    painter_events = [] of Qt6::PaintEvent
    resize_events = [] of Qt6::ResizeEvent
    mouse_presses = [] of Qt6::MouseEvent
    mouse_moves = [] of Qt6::MouseEvent
    mouse_releases = [] of Qt6::MouseEvent
    mouse_double_clicks = [] of Qt6::MouseEvent
    wheels = [] of Qt6::WheelEvent
    keys = [] of Qt6::KeyEvent
    key_releases = [] of Qt6::KeyEvent
    enters = [] of Qt6::WidgetEvent
    leaves = [] of Qt6::WidgetEvent
    focus_ins = [] of Qt6::WidgetEvent
    focus_outs = [] of Qt6::WidgetEvent

    widget.on_paint { |event| paint_events << event }
    widget.on_paint_with_painter do |event, painter|
      painter_events << event
      painter.active?.should be_true
      painter.fill_rect(Qt6::RectF.new(0.0, 0.0, 24.0, 16.0), Qt6::Color.new(255, 0, 0))
    end
    widget.on_resize { |event| resize_events << event }
    widget.on_mouse_press { |event| mouse_presses << event }
    widget.on_mouse_move { |event| mouse_moves << event }
    widget.on_mouse_release { |event| mouse_releases << event }
    widget.on_mouse_double_click { |event| mouse_double_clicks << event }
    widget.on_wheel { |event| wheels << event }
    widget.on_key_press { |event| keys << event }
    widget.on_key_release { |event| key_releases << event }
    widget.on_enter { |event| enters << event }
    widget.on_leave { |event| leaves << event }
    widget.on_focus_in { |event| focus_ins << event }
    widget.on_focus_out { |event| focus_outs << event }

    widget.resize(200, 120)
    widget.show
    application.process_events

    widget.repaint_now
    10.times do
      application.process_events
      break unless paint_events.empty?
    end
    widget.simulate_mouse_press(Qt6::PointF.new(10.0, 20.0))
    widget.simulate_mouse_move(Qt6::PointF.new(15.0, 25.0))
    widget.simulate_mouse_release(Qt6::PointF.new(18.0, 28.0))
    widget.simulate_mouse_double_click(Qt6::PointF.new(22.0, 32.0))
    widget.simulate_wheel(Qt6::PointF.new(20.0, 30.0), angle_delta: Qt6::PointF.new(0.0, 120.0))
    widget.simulate_key_press(65)
    widget.simulate_key_release(65)
    widget.simulate_enter(Qt6::PointF.new(4.0, 5.0))
    widget.simulate_leave
    widget.simulate_focus_in
    widget.simulate_focus_out
    application.process_events
    snapshot = widget.grab.to_image

    widget.size.should eq(Qt6::Size.new(200, 120))
    widget.rect.width.should eq(200.0)
    resize_events.last.size.should eq(Qt6::Size.new(200, 120))
    paint_events.empty?.should be_false
    painter_events.empty?.should be_false
    mouse_presses.last.position.should eq(Qt6::PointF.new(10.0, 20.0))
    mouse_moves.last.position.should eq(Qt6::PointF.new(15.0, 25.0))
    mouse_releases.last.position.should eq(Qt6::PointF.new(18.0, 28.0))
    mouse_double_clicks.last.position.should eq(Qt6::PointF.new(22.0, 32.0))
    wheels.last.angle_delta.should eq(Qt6::PointF.new(0.0, 120.0))
    keys.last.key.should eq(65)
    key_releases.last.key.should eq(65)
    enters.last.type.should eq(Qt6::EventType::Enter)
    leaves.last.type.should eq(Qt6::EventType::Leave)
    focus_ins.last.type.should eq(Qt6::EventType::FocusIn)
    focus_outs.last.type.should eq(Qt6::EventType::FocusOut)
    snapshot.pixel_color(5, 5).should eq(Qt6::Color.new(255, 0, 0, 255))
    widget.release
  end

  it "supports drop callbacks and synthetic text drops on event widgets" do
    application = app
    widget = Qt6::EventWidget.new
    drag_enter_payloads = [] of String
    drag_move_positions = [] of Qt6::PointF
    dropped_payloads = [] of String
    acceptance_states = [] of Bool

    widget.accept_drops = true
    widget.on_drag_enter do |event|
      drag_enter_payloads << event.mime_data.not_nil!.text
      event.accept_proposed_action
      acceptance_states << event.accepted?
    end
    widget.on_drag_move do |event|
      drag_move_positions << event.position
      event.accept
    end
    widget.on_drop do |event|
      dropped_payloads << event.mime_data.not_nil!.text
      event.accept_proposed_action
      acceptance_states << event.accepted?
    end

    widget.resize(180, 100)
    widget.show
    application.process_events

    widget.simulate_drag_enter_text(Qt6::PointF.new(12.0, 14.0), "terrain")
    widget.simulate_drag_move_text(Qt6::PointF.new(18.0, 24.0), "terrain")
    widget.simulate_drop_text(Qt6::PointF.new(20.0, 26.0), "terrain")
    application.process_events

    widget.accept_drops?.should be_true
    drag_enter_payloads.should eq(["terrain"])
    drag_move_positions.should eq([Qt6::PointF.new(18.0, 24.0)])
    dropped_payloads.should eq(["terrain"])
    acceptance_states.should eq([true, true])
    widget.release
  end

  it "shuts down without the Qt thread storage warning" do
    stdout = IO::Memory.new
    stderr = IO::Memory.new
    status = Process.run(
      "crystal",
      ["run", "spec/support/exit_warning_probe.cr"],
      output: stdout,
      error: stderr
    )

    status.success?.should be_true
    stderr.to_s.should_not contain("QThreadStorage: entry")
  end

  it "creates a widget with a readable title and visibility state" do
    application = app
    window = Qt6::Widget.new
    window.window_title = "Spec Window"
    window.resize(320, 180)

    window.window_title.should eq("Spec Window")
    window.visible?.should be_false

    window.show
    application.process_events
    window.visible?.should be_true

    window.visible = false
    application.process_events
    window.visible?.should be_false

    window.visible = true
    application.process_events
    window.visible?.should be_true

    window.hide
    application.process_events
    window.visible?.should be_false

    window.show
    application.process_events
    window.visible?.should be_true

    window.close
    application.process_events
    window.visible?.should be_false
    window.release
  end

  it "supports core widget sizing, help text, and accessibility metadata" do
    application = app
    previous_tool_tip_font = Qt6::ToolTip.font
    previous_tool_tip_palette = Qt6::ToolTip.palette
    label = Qt6::Label.new("Widget Controls")
    line_edit = Qt6::LineEdit.new

    label.tool_tip = "Shared widget affordances"
    label.status_tip = "Shown in the status bar when hovered"
    label.whats_this = "Explains this widget in What's This mode"
    label.accessible_name = "Widget controls label"
    label.accessible_description = "Summarizes shared widget affordances"
    label.accessible_identifier = "core-widget-controls-label"
    tool_tip_font = Qt6::QFont.new(point_size: 12, bold: true)
    tool_tip_palette = Qt6::QPalette.new
    tool_tip_palette.set_color(Qt6::ColorRole::ToolTipBase, Qt6::Color.new(28, 34, 42))
    tool_tip_palette.set_color(Qt6::ColorRole::ToolTipText, Qt6::Color.new(232, 238, 244))
    Qt6::ToolTip.font = tool_tip_font
    Qt6::ToolTip.palette = tool_tip_palette
    label.word_wrap = true
    label.minimum_width = 120
    label.minimum_height = 32
    label.maximum_width = 360
    label.maximum_height = 120
    label.set_minimum_size(140, 40)
    label.set_maximum_size(420, 160)
    label.mouse_tracking = true
    label.cursor_shape = Qt6::CursorShape::PointingHand
    label.transparent_for_mouse_events = true
    label.set_attribute(Qt6::WidgetAttribute::OpaquePaintEvent)
    label.set_attribute(Qt6::WidgetAttribute::ShowWithoutActivating, true)
    label.clear_attribute(Qt6::WidgetAttribute::ShowWithoutActivating)
    label.move(14, 18)
    label.adjust_size
    line_edit.placeholder_text = "Enter a layer name"
    label.show
    application.process_events
    Qt6::ToolTip.show_text(label, Qt6::PointF.new(8.0, 10.0), "Explicit shared tooltip")
    application.process_events

    Qt6::ToolTip.font.point_size.should eq(12)
    Qt6::ToolTip.font.bold?.should be_true
    Qt6::ToolTip.palette.color(Qt6::ColorRole::ToolTipBase).should eq(Qt6::Color.new(28, 34, 42, 255))
    Qt6::ToolTip.palette.color(Qt6::ColorRole::ToolTipText).should eq(Qt6::Color.new(232, 238, 244, 255))
    Qt6::ToolTip.text.should eq("Explicit shared tooltip")
    Qt6::ToolTip.visible?.should be_a(Bool)
    Qt6::ToolTip.hide_text
    application.process_events

    label.tool_tip.should eq("Shared widget affordances")
    label.status_tip.should eq("Shown in the status bar when hovered")
    label.whats_this.should eq("Explains this widget in What's This mode")
    label.accessible_name.should eq("Widget controls label")
    label.accessible_description.should eq("Summarizes shared widget affordances")
    label.accessible_identifier.should eq("core-widget-controls-label")
    label.word_wrap?.should be_true
    label.minimum_size.should eq(Qt6::Size.new(140, 40))
    label.minimum_width.should eq(140)
    label.minimum_height.should eq(40)
    label.maximum_size.should eq(Qt6::Size.new(420, 160))
    label.maximum_width.should eq(420)
    label.maximum_height.should eq(160)
    label.mouse_tracking?.should be_true
    label.cursor_shape.should eq(Qt6::CursorShape::PointingHand)
    label.transparent_for_mouse_events?.should be_true
    label.attribute?(Qt6::WidgetAttribute::TransparentForMouseEvents).should be_true
    label.attribute?(Qt6::WidgetAttribute::OpaquePaintEvent).should be_true
    label.attribute?(Qt6::WidgetAttribute::ShowWithoutActivating).should be_false
    label.size.width.should be > 0
    label.size.height.should be > 0
    line_edit.placeholder_text.should eq("Enter a layer name")

    label.fixed_width = 200
    label.fixed_height = 48
    label.minimum_width.should eq(200)
    label.maximum_width.should eq(200)
    label.minimum_height.should eq(48)
    label.maximum_height.should eq(48)

    label.set_attribute(Qt6::WidgetAttribute::TransparentForMouseEvents, false)
    label.transparent_for_mouse_events?.should be_false

    Qt6::ToolTip.font = previous_tool_tip_font
    Qt6::ToolTip.palette = previous_tool_tip_palette
    line_edit.release
    label.release
  end

  it "supports validators, completers, and rich line-edit editing helpers" do
    application = app
    host = Qt6::Widget.new
    line_edit = Qt6::LineEdit.new("Alpha", host)
    int_validator = Qt6::IntValidator.new(10, 99, line_edit)
    double_validator = Qt6::DoubleValidator.new(0.5, 9.5, 2, line_edit)
    regex_validator = Qt6::RegexValidator.new("^[A-Z][a-z]+$", line_edit)
    completer = Qt6::Completer.new(["Terrain", "Units", "Roads"], line_edit)
    changed_texts = [] of String
    editing_finished = 0
    return_pressed = 0

    line_edit.on_text_changed do |value|
      changed_texts << value
    end
    line_edit.on_editing_finished { editing_finished += 1 }
    line_edit.on_return_pressed { return_pressed += 1 }

    completer.case_sensitivity = Qt6::CaseSensitivity::Insensitive
    completer.completion_mode = Qt6::CompleterCompletionMode::PopupCompletion
    completer.model_sorting = Qt6::CompleterModelSorting::CaseInsensitivelySortedModel
    completer.completion_column = 0
    completer.completion_role = Qt6::ItemDataRole::Display.value
    completer.wrap_around = true
    completer.max_visible_items = 9
    completer.completion_prefix = "uni"

    line_edit.set_placeholder_text("Search terrain")
    line_edit.set_clear_button_enabled(true)
    line_edit.set_drag_enabled(true)
    line_edit.set_echo_mode(Qt6::EchoMode::Password)
    line_edit.set_input_mask("00-00;_")
    line_edit.set_alignment(Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter)
    line_edit.validator = regex_validator
    line_edit.completer = completer
    line_edit.input_mask.should eq("00-00;_")
    line_edit.input_mask = ""
    line_edit.set_max_length(8)
    line_edit.set_text("terrain")
    line_edit.acceptable_input?.should be_false
    line_edit.set_text("Bravo")
    line_edit.acceptable_input?.should be_true
    line_edit.display_text.should_not eq("Bravo")
    line_edit.set_read_only(true)
    line_edit.read_only?.should be_true
    line_edit.set_read_only(false)
    line_edit.set_modified(true)
    line_edit.modified?.should be_true
    line_edit.set_modified(false)
    line_edit.modified?.should be_false
    line_edit.set_cursor_position(2)
    line_edit.set_selection(1, 2)
    completer.current_row = 0
    Qt6::LibQt6.qt6cr_line_edit_emit_editing_finished(line_edit.to_unsafe)
    Qt6::LibQt6.qt6cr_line_edit_emit_return_pressed(line_edit.to_unsafe)
    application.process_events

    int_validator.validate("42").should eq(Qt6::ValidatorState::Acceptable)
    int_validator.validate("abc").should eq(Qt6::ValidatorState::Invalid)
    double_validator.validate("1.25").should eq(Qt6::ValidatorState::Acceptable)
    double_validator.validate("oops").should eq(Qt6::ValidatorState::Invalid)
    regex_validator.validate("Terrain").should eq(Qt6::ValidatorState::Acceptable)
    regex_validator.validate("terrain").should eq(Qt6::ValidatorState::Invalid)

    int_validator.bottom.should eq(10)
    int_validator.top.should eq(99)
    double_validator.bottom.should eq(0.5)
    double_validator.top.should eq(9.5)
    double_validator.decimals.should eq(2)
    regex_validator.pattern.should eq("^[A-Z][a-z]+$")
    completer.case_sensitivity.should eq(Qt6::CaseSensitivity::Insensitive)
    completer.completion_mode.should eq(Qt6::CompleterCompletionMode::PopupCompletion)
    completer.model_sorting.should eq(Qt6::CompleterModelSorting::CaseInsensitivelySortedModel)
    completer.completion_column.should eq(0)
    completer.completion_role.should eq(Qt6::ItemDataRole::Display.value)
    completer.wrap_around?.should be_true
    completer.max_visible_items.should eq(9)
    completer.completion_prefix.should eq("uni")
    completer.completion_count.should eq(1)
    completer.current_row.should eq(0)
    completer.current_completion.should eq("Units")
    completer.widget.not_nil!.to_unsafe.should eq(line_edit.to_unsafe)

    line_edit.placeholder_text.should eq("Search terrain")
    line_edit.echo_mode.should eq(Qt6::EchoMode::Password)
    line_edit.input_mask.should eq("")
    line_edit.alignment.includes?(Qt6::AlignmentFlag::Right).should be_true
    line_edit.alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
    line_edit.max_length.should eq(8)
    line_edit.clear_button_enabled?.should be_true
    line_edit.drag_enabled?.should be_true
    line_edit.validator.not_nil!.validate("Roads").should eq(Qt6::ValidatorState::Acceptable)
    line_edit.completer.not_nil!.completion_prefix.should eq("uni")
    line_edit.text.should eq("Bravo")
    line_edit.cursor_position.should eq(3)
    line_edit.selected_text.should eq("ra")
    line_edit.has_selected_text?.should be_true
    line_edit.selection_start.should eq(1)
    changed_texts.last.should eq("Bravo")
    editing_finished.should eq(1)
    return_pressed.should eq(1)

    line_edit.select_all
    line_edit.selected_text.should eq("Bravo")
    line_edit.clear_selection
    line_edit.has_selected_text?.should be_false
    line_edit.clear
    line_edit.text.should eq("")

    host.release
  end

  it "supports application metadata, stylesheets, and window icons" do
    application = app
    icon_path = File.join(Dir.tempdir, "crystal-qt6-window-icon-#{Process.pid}.png")
    icon_image = Qt6::QImage.new(16, 16)
    icon_image.fill(Qt6::Color.new(0, 0, 0, 0))
    icon_image.set_pixel_color(4, 4, Qt6::Color.new(32, 96, 180, 255))
    icon_image.save(icon_path).should be_true

    previous_name = application.name
    previous_organization_name = application.organization_name
    previous_organization_domain = application.organization_domain
    previous_style_sheet = application.style_sheet
    previous_window_icon = application.window_icon

    icon = Qt6::QIcon.from_file(icon_path)
    icon.null?.should be_false

    application.name = "crystal-qt6 specs"
    application.organization_name = "Spec Org"
    application.organization_domain = "spec.example"
    application.style_sheet = "QWidget { color: rgb(12, 34, 56); }"
    application.window_icon = icon

    window = Qt6::Widget.new
    window.style_sheet = "QWidget { background-color: rgb(22, 44, 66); }"
    window.window_icon = icon

    application.name.should eq("crystal-qt6 specs")
    application.organization_name.should eq("Spec Org")
    application.organization_domain.should eq("spec.example")
    application.style_sheet.should eq("QWidget { color: rgb(12, 34, 56); }")
    application.window_icon.null?.should be_false
    window.style_sheet.should eq("QWidget { background-color: rgb(22, 44, 66); }")
    window.window_icon.null?.should be_false

    window.release
    application.name = previous_name
    application.organization_name = previous_organization_name
    application.organization_domain = previous_organization_domain
    application.style_sheet = previous_style_sheet
    application.window_icon = previous_window_icon
  end

  it "supports theme-aware palettes on applications and widgets" do
    application = app
    previous_palette = application.palette

    palette = Qt6::QPalette.new
    palette.set_color(Qt6::ColorRole::Window, Qt6::Color.new(24, 36, 48))
    palette.set_color(Qt6::ColorRole::WindowText, Qt6::Color.new(210, 220, 230))
    palette.set_color(Qt6::ColorRole::Highlight, Qt6::Color.new(60, 110, 180))
    palette.set_color(Qt6::ColorGroup::Disabled, Qt6::ColorRole::Text, Qt6::Color.new(120, 130, 140))

    palette.color(Qt6::ColorRole::Window).should eq(Qt6::Color.new(24, 36, 48, 255))
    palette.color(Qt6::ColorRole::WindowText).should eq(Qt6::Color.new(210, 220, 230, 255))
    palette.color(Qt6::ColorGroup::Disabled, Qt6::ColorRole::Text).should eq(Qt6::Color.new(120, 130, 140, 255))

    application.palette = palette
    application_palette = application.palette
    application_palette.color(Qt6::ColorRole::Window).should eq(Qt6::Color.new(24, 36, 48, 255))
    application_palette.color(Qt6::ColorRole::Highlight).should eq(Qt6::Color.new(60, 110, 180, 255))
    application_palette.color(Qt6::ColorGroup::Disabled, Qt6::ColorRole::Text).should eq(Qt6::Color.new(120, 130, 140, 255))

    window = Qt6::Widget.new
    window.palette = palette
    window_palette = window.palette
    window_palette.color(Qt6::ColorRole::WindowText).should eq(Qt6::Color.new(210, 220, 230, 255))
    window_palette.color(Qt6::ColorRole::Window).should eq(Qt6::Color.new(24, 36, 48, 255))

    window.release
    application.palette = previous_palette
  end

  it "supports common styles on applications and widgets" do
    application = app
    previous_style_name = application.style.try(&.name)
    window = Qt6::Widget.new
    application_style = Qt6::CommonStyle.new
    widget_style = Qt6::CommonStyle.new
    proxy_style = Qt6::ProxyStyle.new(widget_style)
    replacement_base_style = Qt6::CommonStyle.new
    style_keys = Qt6::StyleFactory.keys
    factory_style = previous_style_name ? Qt6::StyleFactory.create(previous_style_name.not_nil!) : style_keys.first?.try { |key| Qt6::StyleFactory.create(key) }
    polished_palette = Qt6::QPalette.new

    begin
      application.style = application_style
      window.style = proxy_style

      active_application_style = application.style
      active_widget_style = window.style
      active_application_style.should_not be_nil
      active_widget_style.should_not be_nil
      active_application_style = active_application_style.not_nil!
      active_widget_style = active_widget_style.not_nil!

      active_application_style.name.should eq(application_style.name)
      active_widget_style.name.should eq(proxy_style.name)
      active_application_style.standard_palette.color(Qt6::ColorRole::Window).should be_a(Qt6::Color)
      active_widget_style.standard_palette.color(Qt6::ColorRole::WindowText).should be_a(Qt6::Color)
      style_keys.should_not be_empty
      factory_style.should_not be_nil
      factory_style.not_nil!.name.should_not be_empty
      proxy_style.base_style.should_not be_nil
      proxy_style.base_style.not_nil!.name.should eq(widget_style.name)
      proxy_style.set_base_style(replacement_base_style)
      proxy_style.base_style.should_not be_nil
      proxy_style.base_style.not_nil!.name.should eq(replacement_base_style.name)
      active_application_style.polish(window).to_unsafe.should eq(window.to_unsafe)
      active_application_style.unpolish(window).to_unsafe.should eq(window.to_unsafe)
      active_application_style.polish(application).to_unsafe.should eq(application.to_unsafe)
      active_application_style.unpolish(application).to_unsafe.should eq(application.to_unsafe)
      active_application_style.polish(polished_palette).to_unsafe.should eq(polished_palette.to_unsafe)
      polished_palette.color(Qt6::ColorRole::Window).should be_a(Qt6::Color)

      if previous_style_name
        keyed_proxy_style = Qt6::ProxyStyle.new(previous_style_name)
        keyed_proxy_style.base_style.should_not be_nil
        keyed_proxy_style.base_style.not_nil!.name.should eq(previous_style_name)
        keyed_proxy_style.release
      end
    ensure
      factory_style.try(&.release)
      polished_palette.release
      window.release
      application.set_style(previous_style_name.not_nil!) if previous_style_name
    end
  end

  it "supports style hint return helpers" do
    base = Qt6::StyleHintReturn.new
    region = Qt6::QRegion.new(4, 6, 20, 12)
    mask = Qt6::StyleHintReturnMask.new
    variant = Qt6::StyleHintReturnVariant.new

    begin
      base.version.should eq(1)
      base.type.should eq(Qt6::StyleHintReturnType::Default)
      base.set_version(3).to_unsafe.should eq(base.to_unsafe)
      base.version.should eq(3)
      base.set_type(Qt6::StyleHintReturnType::Default).to_unsafe.should eq(base.to_unsafe)

      mask.type.should eq(Qt6::StyleHintReturnType::Mask)
      mask.set_region(region).to_unsafe.should eq(mask.to_unsafe)
      mask_region = mask.region
      mask_region.bounding_rect.should eq(Qt6::Rect.new(4, 6, 20, 12))
      mask_region.release

      variant.type.should eq(Qt6::StyleHintReturnType::Variant)
      variant.set_variant("Fusion").to_unsafe.should eq(variant.to_unsafe)
      variant.variant.should eq("Fusion")
      variant.variant = true
      variant.variant.should eq(true)
    ensure
      variant.release
      mask.release
      region.release
      base.release
    end
  end

  it "supports shared style options" do
    application = app
    host = Qt6::Widget.new
    option = Qt6::StyleOption.new
    view_option = Qt6::StyleOptionViewItem.new
    palette = Qt6::QPalette.new

    begin
      host.resize(140, 48)
      host.show
      application.process_events

      palette.set_color(Qt6::ColorRole::Window, Qt6::Color.new(35, 45, 55))
      option.version.should eq(1)
      option.type.should eq(Qt6::StyleOptionType::Default)
      option.set_version(2).to_unsafe.should eq(option.to_unsafe)
      option.version.should eq(2)
      option.state = Qt6::StyleStateFlag::Enabled | Qt6::StyleStateFlag::Selected
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
      option.state.includes?(Qt6::StyleStateFlag::Selected).should be_true
      option.direction = Qt6::LayoutDirection::LeftToRight
      option.direction.should eq(Qt6::LayoutDirection::LeftToRight)
      option.rect = Qt6::Rect.new(2, 3, 25, 11)
      option.rect.should eq(Qt6::RectF.new(2.0, 3.0, 25.0, 11.0))
      option.palette = palette
      option.palette.color(Qt6::ColorRole::Window).should eq(Qt6::Color.new(35, 45, 55, 255))
      option.style_object = host
      option.style_object.should_not be_nil
      option.style_object.not_nil!.to_unsafe.should eq(host.to_unsafe)
      option.init_from(host).to_unsafe.should eq(option.to_unsafe)
      option.direction.should be_a(Qt6::LayoutDirection)
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 140.0, 48.0))
      option.font_metrics.height.should be > 0
      option.style_object.should_not be_nil
      option.style_object.not_nil!.to_unsafe.should eq(host.to_unsafe)

      view_option.init_from(host)
      view_option.type.should eq(Qt6::StyleOptionType::ViewItem)
      view_option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 140.0, 48.0))
      view_option.font_metrics.height.should be > 0
      view_option.state = Qt6::StyleStateFlag::Enabled | Qt6::StyleStateFlag::Selected
      view_option.selected?.should be_true
      view_option.enabled?.should be_true
      view_option.text_rect.width.should be >= 0
    ensure
      palette.release
      view_option.release
      option.release
      host.release
    end
  end

  it "supports button style options" do
    application = app
    button = Qt6::PushButton.new("Deploy")
    option = Qt6::StyleOptionButton.new
    icon = Qt6::QIcon.new

    begin
      button.resize(132, 36)
      button.icon = icon
      button.icon_size = Qt6::Size.new(18, 18)
      button.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::Button)
      option.features.should eq(Qt6::StyleOptionButtonFeature::None)
      option.set_features(
        Qt6::StyleOptionButtonFeature::Flat |
        Qt6::StyleOptionButtonFeature::DefaultButton |
        Qt6::StyleOptionButtonFeature::HasMenu
      ).to_unsafe.should eq(option.to_unsafe)
      option.features.includes?(Qt6::StyleOptionButtonFeature::Flat).should be_true
      option.features.includes?(Qt6::StyleOptionButtonFeature::DefaultButton).should be_true
      option.features.includes?(Qt6::StyleOptionButtonFeature::HasMenu).should be_true

      option.set_text(button.text).to_unsafe.should eq(option.to_unsafe)
      option.text.should eq("Deploy")
      option.set_icon(icon).to_unsafe.should eq(option.to_unsafe)
      option.icon.null?.should be_true
      option.set_icon_size(Qt6::Size.new(18, 18)).to_unsafe.should eq(option.to_unsafe)
      option.icon_size.should eq(Qt6::Size.new(18, 18))

      option.init_from(button)
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 132.0, 36.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
    ensure
      icon.release
      option.release
      button.release
    end
  end

  it "supports combo-box style options" do
    application = app
    combo_box = Qt6::ComboBox.new
    option = Qt6::StyleOptionComboBox.new
    icon = Qt6::QIcon.new

    begin
      combo_box.add_item("Terrain")
      combo_box.add_item("Units")
      combo_box.current_index = 1
      combo_box.editable = true
      combo_box.frame = false
      combo_box.resize(156, 32)
      combo_box.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::ComboBox)
      option.editable?.should be_false
      option.set_editable(combo_box.editable?).to_unsafe.should eq(option.to_unsafe)
      option.editable?.should be_true
      option.set_frame(combo_box.frame?).to_unsafe.should eq(option.to_unsafe)
      option.frame?.should be_false
      option.set_current_text(combo_box.current_text).to_unsafe.should eq(option.to_unsafe)
      option.current_text.should eq("Units")
      option.set_current_icon(icon).to_unsafe.should eq(option.to_unsafe)
      option.current_icon.null?.should be_true
      option.set_icon_size(Qt6::Size.new(16, 18)).to_unsafe.should eq(option.to_unsafe)
      option.icon_size.should eq(Qt6::Size.new(16, 18))
      option.set_text_alignment(Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter).to_unsafe.should eq(option.to_unsafe)
      option.text_alignment.includes?(Qt6::AlignmentFlag::Right).should be_true
      option.text_alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
      option.set_popup_rect(Qt6::Rect.new(3, 4, 70, 22)).to_unsafe.should eq(option.to_unsafe)
      option.popup_rect.should eq(Qt6::RectF.new(3.0, 4.0, 70.0, 22.0))

      option.init_from(combo_box)
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 156.0, 32.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
    ensure
      icon.release
      option.release
      combo_box.release
    end
  end

  it "supports complex style options" do
    option = Qt6::StyleOptionComplex.new
    combo_option = Qt6::StyleOptionComboBox.new

    begin
      option.type.should eq(Qt6::StyleOptionType::Complex)
      option.sub_controls.should eq(Qt6::StyleSubControl::All)
      option.active_sub_controls.should eq(Qt6::StyleSubControl::None)

      option.set_sub_controls(
        Qt6::StyleSubControl::ComboBoxFrame |
        Qt6::StyleSubControl::ComboBoxArrow
      ).to_unsafe.should eq(option.to_unsafe)
      option.sub_controls.includes?(Qt6::StyleSubControl::ComboBoxFrame).should be_true
      option.sub_controls.includes?(Qt6::StyleSubControl::ComboBoxArrow).should be_true

      option.set_active_sub_controls(Qt6::StyleSubControl::ComboBoxArrow).to_unsafe.should eq(option.to_unsafe)
      option.active_sub_controls.should eq(Qt6::StyleSubControl::ComboBoxArrow)

      combo_option.sub_controls = Qt6::StyleSubControl::ComboBoxFrame | Qt6::StyleSubControl::ComboBoxListBoxPopup
      combo_option.active_sub_controls = Qt6::StyleSubControl::ComboBoxListBoxPopup
      combo_option.sub_controls.includes?(Qt6::StyleSubControl::ComboBoxFrame).should be_true
      combo_option.sub_controls.includes?(Qt6::StyleSubControl::ComboBoxListBoxPopup).should be_true
      combo_option.active_sub_controls.should eq(Qt6::StyleSubControl::ComboBoxListBoxPopup)
    ensure
      combo_option.release
      option.release
    end
  end

  it "supports dock-widget style options" do
    application = app
    dock = Qt6::DockWidget.new("Layers")
    option = Qt6::StyleOptionDockWidget.new

    begin
      dock.features = Qt6::DockWidgetFeature::DockWidgetClosable |
                      Qt6::DockWidgetFeature::DockWidgetMovable |
                      Qt6::DockWidgetFeature::DockWidgetFloatable |
                      Qt6::DockWidgetFeature::DockWidgetVerticalTitleBar
      dock.resize(164, 34)
      dock.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::DockWidget)
      option.set_title("Inspector").to_unsafe.should eq(option.to_unsafe)
      option.title.should eq("Inspector")
      option.set_closable(true).to_unsafe.should eq(option.to_unsafe)
      option.set_movable(true).to_unsafe.should eq(option.to_unsafe)
      option.set_floatable(true).to_unsafe.should eq(option.to_unsafe)
      option.set_vertical_title_bar(true).to_unsafe.should eq(option.to_unsafe)
      option.closable?.should be_true
      option.movable?.should be_true
      option.floatable?.should be_true
      option.vertical_title_bar?.should be_true

      option.init_from(dock)
      option.title.should eq("Layers")
      option.closable?.should be_true
      option.movable?.should be_true
      option.floatable?.should be_true
      option.vertical_title_bar?.should be_true
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
    ensure
      option.release
      dock.release
    end
  end

  it "supports frame style options" do
    application = app
    frame = Qt6::Frame.new
    line_edit = Qt6::LineEdit.new
    option = Qt6::StyleOptionFrame.new

    begin
      frame.frame_shape = Qt6::FrameShape::Box
      frame.line_width = 3
      frame.mid_line_width = 1
      frame.resize(120, 32)
      frame.show

      line_edit.resize(100, 28)
      line_edit.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::Frame)
      option.features.should eq(Qt6::StyleOptionFrameFeature::None)
      option.set_line_width(4).to_unsafe.should eq(option.to_unsafe)
      option.line_width.should eq(4)
      option.set_mid_line_width(2).to_unsafe.should eq(option.to_unsafe)
      option.mid_line_width.should eq(2)
      option.set_features(
        Qt6::StyleOptionFrameFeature::Flat |
        Qt6::StyleOptionFrameFeature::Rounded
      ).to_unsafe.should eq(option.to_unsafe)
      option.features.includes?(Qt6::StyleOptionFrameFeature::Flat).should be_true
      option.features.includes?(Qt6::StyleOptionFrameFeature::Rounded).should be_true
      option.set_frame_shape(Qt6::FrameShape::WinPanel).to_unsafe.should eq(option.to_unsafe)
      option.frame_shape.should eq(Qt6::FrameShape::WinPanel)

      option.init_from(frame)
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 120.0, 32.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
      option.line_width.should eq(frame.line_width)
      option.mid_line_width.should eq(frame.mid_line_width)

      option.init_from(line_edit)
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 100.0, 28.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
      option.line_width.should be >= 0
      option.mid_line_width.should be >= 0
    ensure
      option.release
      line_edit.release
      frame.release
    end
  end

  it "supports graphics-item style options" do
    option = Qt6::StyleOptionGraphicsItem.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)
    identity = Qt6::QTransform.new
    scaled = Qt6::QTransform.new

    begin
      option.type.should eq(Qt6::StyleOptionType::GraphicsItem)
      wrapped.should be_a(Qt6::StyleOptionGraphicsItem)

      option.exposed_rect.should eq(Qt6::RectF.new(0.0, 0.0, 0.0, 0.0))
      option.set_exposed_rect(Qt6::RectF.new(2.5, 3.5, 10.0, 6.0)).to_unsafe.should eq(option.to_unsafe)
      option.exposed_rect.should eq(Qt6::RectF.new(2.5, 3.5, 10.0, 6.0))
      option.exposed_rect = Qt6::Rect.new(1, 2, 7, 9)
      option.exposed_rect.should eq(Qt6::RectF.new(1.0, 2.0, 7.0, 9.0))

      Qt6::StyleOptionGraphicsItem.level_of_detail_from_transform(identity).should be_close(1.0, 1e-6)
      scaled.scale(2.0, 2.0)
      Qt6::StyleOptionGraphicsItem.level_of_detail_from_transform(scaled).should be_close(2.0, 1e-6)
    ensure
      scaled.release
      identity.release
      option.release
    end
  end

  it "supports group-box style options" do
    application = app
    group_box = Qt6::GroupBox.new("Terrain")
    option = Qt6::StyleOptionGroupBox.new

    begin
      group_box.alignment = Qt6::AlignmentFlag::HCenter
      group_box.checkable = true
      group_box.checked = true
      group_box.flat = true
      group_box.resize(168, 52)
      group_box.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::GroupBox)
      option.set_features(Qt6::StyleOptionFrameFeature::Flat | Qt6::StyleOptionFrameFeature::Rounded).to_unsafe.should eq(option.to_unsafe)
      option.features.includes?(Qt6::StyleOptionFrameFeature::Flat).should be_true
      option.features.includes?(Qt6::StyleOptionFrameFeature::Rounded).should be_true
      option.set_text("Inspector").to_unsafe.should eq(option.to_unsafe)
      option.text.should eq("Inspector")
      option.set_text_alignment(Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter).to_unsafe.should eq(option.to_unsafe)
      option.text_alignment.includes?(Qt6::AlignmentFlag::Right).should be_true
      option.text_alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
      option.set_text_color(Qt6::Color.new(12, 34, 56, 200)).to_unsafe.should eq(option.to_unsafe)
      option.text_color.should eq(Qt6::Color.new(12, 34, 56, 200))
      option.set_line_width(3).to_unsafe.should eq(option.to_unsafe)
      option.line_width.should eq(3)
      option.set_mid_line_width(1).to_unsafe.should eq(option.to_unsafe)
      option.mid_line_width.should eq(1)

      option.init_from(group_box)
      option.text.should eq("Terrain")
      option.text_alignment.includes?(Qt6::AlignmentFlag::HCenter).should be_true
      option.features.includes?(Qt6::StyleOptionFrameFeature::Flat).should be_true
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
      option.sub_controls.includes?(Qt6::StyleSubControl::GroupBoxLabel).should be_true
      option.sub_controls.includes?(Qt6::StyleSubControl::GroupBoxFrame).should be_true
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 168.0, 52.0))
      option.line_width.should be >= 0
      option.mid_line_width.should be >= 0
    ensure
      option.release
      group_box.release
    end
  end

  it "supports header style options" do
    application = app
    table_view = Qt6::TableView.new
    model = Qt6::StandardItemModel.new(table_view)
    option = Qt6::StyleOptionHeader.new
    icon = Qt6::QIcon.new

    begin
      model.set_item(0, 0, Qt6::StandardItem.new("Terrain"))
      model.set_item(0, 1, Qt6::StandardItem.new("Visible"))
      model.set_horizontal_header_label(0, "Layer")
      model.set_horizontal_header_label(1, "State")
      table_view.model = model

      header = table_view.horizontal_header
      header.default_alignment = Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter
      table_view.resize(220, 80)
      table_view.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::Header)
      option.set_section(1).to_unsafe.should eq(option.to_unsafe)
      option.section.should eq(1)
      option.set_text("Inspector").to_unsafe.should eq(option.to_unsafe)
      option.text.should eq("Inspector")
      option.set_text_alignment(Qt6::AlignmentFlag::Left | Qt6::AlignmentFlag::VCenter).to_unsafe.should eq(option.to_unsafe)
      option.text_alignment.includes?(Qt6::AlignmentFlag::Left).should be_true
      option.text_alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
      option.set_icon(icon).to_unsafe.should eq(option.to_unsafe)
      option.icon.null?.should be_true
      option.set_icon_alignment(Qt6::AlignmentFlag::HCenter | Qt6::AlignmentFlag::Bottom).to_unsafe.should eq(option.to_unsafe)
      option.icon_alignment.includes?(Qt6::AlignmentFlag::HCenter).should be_true
      option.icon_alignment.includes?(Qt6::AlignmentFlag::Bottom).should be_true
      option.set_position(Qt6::StyleOptionHeaderSectionPosition::End).to_unsafe.should eq(option.to_unsafe)
      option.position.should eq(Qt6::StyleOptionHeaderSectionPosition::End)
      option.set_selected_position(Qt6::StyleOptionHeaderSelectedPosition::NextIsSelected).to_unsafe.should eq(option.to_unsafe)
      option.selected_position.should eq(Qt6::StyleOptionHeaderSelectedPosition::NextIsSelected)
      option.set_sort_indicator(Qt6::StyleOptionHeaderSortIndicator::SortDown).to_unsafe.should eq(option.to_unsafe)
      option.sort_indicator.should eq(Qt6::StyleOptionHeaderSortIndicator::SortDown)
      option.set_orientation(Qt6::Orientation::Vertical).to_unsafe.should eq(option.to_unsafe)
      option.orientation.should eq(Qt6::Orientation::Vertical)

      option.init_from(header)
      option.orientation.should eq(Qt6::Orientation::Horizontal)
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
      option.rect.width.should be >= 0.0
      option.rect.height.should be >= 0.0

      option.init_from_index(header, 0)
      option.section.should eq(0)
      option.text.should eq("Layer")
      option.orientation.should eq(Qt6::Orientation::Horizontal)
      option.position.should eq(Qt6::StyleOptionHeaderSectionPosition::Beginning)
      option.selected_position.should eq(Qt6::StyleOptionHeaderSelectedPosition::NotAdjacent)
    ensure
      icon.release
      option.release
      table_view.release
    end
  end

  it "supports header v2 style options" do
    application = app
    table_view = Qt6::TableView.new
    model = Qt6::StandardItemModel.new(table_view)
    option = Qt6::StyleOptionHeaderV2.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)

    begin
      model.set_item(0, 0, Qt6::StandardItem.new("Terrain"))
      model.set_horizontal_header_label(0, "Layer")
      table_view.model = model
      table_view.resize(180, 60)
      table_view.show
      application.process_events

      option.version.should eq(2)
      option.type.should eq(Qt6::StyleOptionType::Header)
      wrapped.should be_a(Qt6::StyleOptionHeaderV2)

      option.set_text_elide_mode(Qt6::TextElideMode::ElideMiddle).to_unsafe.should eq(option.to_unsafe)
      option.text_elide_mode.should eq(Qt6::TextElideMode::ElideMiddle)
      option.set_section_drag_target(true).to_unsafe.should eq(option.to_unsafe)
      option.section_drag_target?.should be_true

      header = table_view.horizontal_header
      option.init_from(header)
      option.version.should eq(2)
      option.orientation.should eq(Qt6::Orientation::Horizontal)
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true

      option.init_from_index(header, 0)
      option.version.should eq(2)
      option.section.should eq(0)
      option.text.should eq("Layer")
    ensure
      option.release
      table_view.release
    end
  end

  it "supports focus-rect style options" do
    application = app
    host = Qt6::Widget.new
    option = Qt6::StyleOptionFocusRect.new

    begin
      host.resize(88, 24)
      host.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::FocusRect)
      option.set_background_color(Qt6::Color.new(12, 34, 56, 200)).to_unsafe.should eq(option.to_unsafe)
      option.background_color.should eq(Qt6::Color.new(12, 34, 56, 200))

      option.init_from(host)
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 88.0, 24.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
      option.background_color.should be_a(Qt6::Color)
    ensure
      option.release
      host.release
    end
  end

  it "supports menu-item style options" do
    application = app
    menu = Qt6::Menu.new("Terrain")
    action = menu.add_action("&Forest\tCtrl+F")
    option = Qt6::StyleOptionMenuItem.new
    icon = Qt6::QIcon.new
    font = Qt6::QFont.new("Helvetica", 13, bold: true)

    begin
      menu.resize(180, 40)
      menu.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::MenuItem)
      option.menu_item_type.should eq(Qt6::StyleOptionMenuItemType::Normal)
      option.check_type.should eq(Qt6::StyleOptionMenuItemCheckType::NotCheckable)
      option.checked?.should be_false
      option.menu_has_checkable_items?.should be_true

      option.set_menu_item_type(Qt6::StyleOptionMenuItemType::DefaultItem).to_unsafe.should eq(option.to_unsafe)
      option.menu_item_type.should eq(Qt6::StyleOptionMenuItemType::DefaultItem)
      option.set_check_type(Qt6::StyleOptionMenuItemCheckType::NonExclusive).to_unsafe.should eq(option.to_unsafe)
      option.check_type.should eq(Qt6::StyleOptionMenuItemCheckType::NonExclusive)
      option.set_checked(true).to_unsafe.should eq(option.to_unsafe)
      option.checked?.should be_true
      option.set_menu_has_checkable_items(true).to_unsafe.should eq(option.to_unsafe)
      option.menu_has_checkable_items?.should be_true
      option.set_menu_rect(Qt6::Rect.new(4, 6, 120, 24)).to_unsafe.should eq(option.to_unsafe)
      option.menu_rect.should eq(Qt6::RectF.new(4.0, 6.0, 120.0, 24.0))
      option.set_text("Forest\tCtrl+F").to_unsafe.should eq(option.to_unsafe)
      option.text.should eq("Forest\tCtrl+F")
      option.set_icon(icon).to_unsafe.should eq(option.to_unsafe)
      option.icon.null?.should be_true
      option.set_max_icon_width(18).to_unsafe.should eq(option.to_unsafe)
      option.max_icon_width.should eq(18)
      option.set_reserved_shortcut_width(44).to_unsafe.should eq(option.to_unsafe)
      option.reserved_shortcut_width.should eq(44)
      option.set_font(font).to_unsafe.should eq(option.to_unsafe)
      option.font.family.should eq(font.family)
      option.font.point_size.should eq(font.point_size)
      option.font.bold?.should eq(font.bold?)

      action.checkable = true
      action.checked = true
      option.init_from(menu, action)
      option.text.should eq(action.text)
      option.menu_item_type.should eq(Qt6::StyleOptionMenuItemType::Normal)
      option.check_type.should eq(Qt6::StyleOptionMenuItemCheckType::NonExclusive)
      option.checked?.should be_true
      option.menu_has_checkable_items?.should be_true
      option.rect.width.should be > 0.0
      option.menu_rect.width.should be > 0.0
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
    ensure
      font.release
      icon.release
      option.release
      menu.release
    end
  end

  it "supports menu-item v2 style options" do
    application = app
    menu = Qt6::Menu.new("Terrain")
    action = menu.add_action("&Forest\tCtrl+F")
    option = Qt6::StyleOptionMenuItemV2.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)

    begin
      menu.resize(180, 40)
      menu.show
      application.process_events

      option.version.should eq(2)
      option.type.should eq(Qt6::StyleOptionType::MenuItem)
      wrapped.should be_a(Qt6::StyleOptionMenuItemV2)

      option.mouse_down?.should be_false
      option.set_mouse_down(true).to_unsafe.should eq(option.to_unsafe)
      option.mouse_down?.should be_true

      option.init_from(menu, action)
      option.version.should eq(2)
      option.text.should eq(action.text)
      option.menu_item_type.should eq(Qt6::StyleOptionMenuItemType::Normal)
      option.rect.width.should be > 0.0
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
    ensure
      option.release
      menu.release
    end
  end

  it "supports progress-bar style options" do
    application = app
    progress_bar = Qt6::ProgressBar.new
    option = Qt6::StyleOptionProgressBar.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)

    begin
      progress_bar.set_range(5, 25)
      progress_bar.value = 12
      progress_bar.format = "%p% ready"
      progress_bar.alignment = Qt6::AlignmentFlag::HCenter | Qt6::AlignmentFlag::VCenter
      progress_bar.text_visible = true
      progress_bar.inverted_appearance = true
      progress_bar.text_direction = Qt6::ProgressBarDirection::BottomToTop
      progress_bar.resize(180, 28)
      progress_bar.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::ProgressBar)
      wrapped.should be_a(Qt6::StyleOptionProgressBar)
      option.minimum.should eq(0)
      option.maximum.should eq(0)
      option.progress.should eq(0)
      option.text.should eq("")
      option.text_visible?.should be_false
      option.inverted_appearance?.should be_false
      option.bottom_to_top?.should be_false

      option.set_minimum(5).to_unsafe.should eq(option.to_unsafe)
      option.minimum.should eq(5)
      option.set_maximum(25).to_unsafe.should eq(option.to_unsafe)
      option.maximum.should eq(25)
      option.set_progress(12).to_unsafe.should eq(option.to_unsafe)
      option.progress.should eq(12)
      option.set_text("12 / 25").to_unsafe.should eq(option.to_unsafe)
      option.text.should eq("12 / 25")
      option.set_text_alignment(Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter).to_unsafe.should eq(option.to_unsafe)
      option.text_alignment.includes?(Qt6::AlignmentFlag::Right).should be_true
      option.text_alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
      option.set_text_visible(true).to_unsafe.should eq(option.to_unsafe)
      option.text_visible?.should be_true
      option.set_inverted_appearance(true).to_unsafe.should eq(option.to_unsafe)
      option.inverted_appearance?.should be_true
      option.set_bottom_to_top(true).to_unsafe.should eq(option.to_unsafe)
      option.bottom_to_top?.should be_true

      option.init_from(progress_bar)
      option.minimum.should eq(5)
      option.maximum.should eq(25)
      option.progress.should eq(12)
      option.text.should eq("35% ready")
      option.text_alignment.includes?(Qt6::AlignmentFlag::HCenter).should be_true
      option.text_alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
      option.text_visible?.should be_true
      option.inverted_appearance?.should be_true
      option.bottom_to_top?.should be_true
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 180.0, 28.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
    ensure
      option.release
      progress_bar.release
    end
  end

  it "supports rubber-band style options" do
    application = app
    host = Qt6::Widget.new
    rubber_band = Qt6::RubberBand.new(Qt6::RubberBandShape::Rectangle, host)
    option = Qt6::StyleOptionRubberBand.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)

    begin
      host.resize(200, 120)
      host.show
      rubber_band.set_geometry(10, 12, 80, 26)
      rubber_band.show
      application.process_events

      option.type.should eq(Qt6::StyleOptionType::RubberBand)
      wrapped.should be_a(Qt6::StyleOptionRubberBand)
      option.shape.should eq(Qt6::RubberBandShape::Line)
      option.opaque?.should be_false

      option.set_shape(Qt6::RubberBandShape::Rectangle).to_unsafe.should eq(option.to_unsafe)
      option.shape.should eq(Qt6::RubberBandShape::Rectangle)
      option.set_opaque(true).to_unsafe.should eq(option.to_unsafe)
      option.opaque?.should be_true

      option.init_from(rubber_band)
      option.shape.should eq(Qt6::RubberBandShape::Rectangle)
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 80.0, 26.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
      option.opaque?.should be_a(Bool)
    ensure
      option.release
      rubber_band.release
      host.release
    end
  end

  it "supports size-grip style options" do
    option = Qt6::StyleOptionSizeGrip.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)

    begin
      option.type.should eq(Qt6::StyleOptionType::SizeGrip)
      wrapped.should be_a(Qt6::StyleOptionSizeGrip)
      option.corner.should eq(Qt6::Corner::BottomRightCorner)
      option.sub_controls.should eq(Qt6::StyleSubControl::All)

      option.set_corner(Qt6::Corner::BottomRightCorner).to_unsafe.should eq(option.to_unsafe)
      option.corner.should eq(Qt6::Corner::BottomRightCorner)
      option.set_sub_controls(Qt6::StyleSubControl::None).to_unsafe.should eq(option.to_unsafe)
      option.sub_controls.should eq(Qt6::StyleSubControl::None)
      option.set_active_sub_controls(Qt6::StyleSubControl::None).to_unsafe.should eq(option.to_unsafe)
      option.active_sub_controls.should eq(Qt6::StyleSubControl::None)
    ensure
      option.release
    end
  end

  it "supports slider style options" do
    application = app
    slider = Qt6::Slider.new(Qt6::Orientation::Horizontal)
    scroll_bar = Qt6::ScrollBar.new(Qt6::Orientation::Vertical)
    dial = Qt6::Dial.new
    option = Qt6::StyleOptionSlider.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)

    begin
      slider.set_range(10, 90)
      slider.value = 42
      slider.tick_position = Qt6::SliderTickPosition::TicksBelow
      slider.tick_interval = 5
      slider.single_step = 2
      slider.page_step = 12
      slider.inverted_appearance = true
      slider.resize(160, 24)
      slider.show

      scroll_bar.set_range(0, 100)
      scroll_bar.value = 30
      scroll_bar.resize(18, 120)
      scroll_bar.show

      dial.set_range(0, 40)
      dial.value = 14
      dial.wrapping = true
      dial.notch_target = 6.5
      dial.resize(60, 60)
      dial.show

      application.process_events

      option.type.should eq(Qt6::StyleOptionType::Slider)
      wrapped.should be_a(Qt6::StyleOptionSlider)
      option.orientation.should eq(Qt6::Orientation::Horizontal)
      option.minimum.should eq(0)
      option.maximum.should eq(0)
      option.tick_position.should eq(Qt6::SliderTickPosition::NoTicks)
      option.tick_interval.should eq(0)
      option.upside_down?.should be_false
      option.slider_position.should eq(0)
      option.slider_value.should eq(0)
      option.single_step.should eq(0)
      option.page_step.should eq(0)
      option.notch_target.should eq(0.0)
      option.dial_wrapping?.should be_false
      option.keyboard_modifiers.should eq(Qt6::KeyboardModifier::NoModifier)

      option.set_orientation(Qt6::Orientation::Vertical).to_unsafe.should eq(option.to_unsafe)
      option.orientation.should eq(Qt6::Orientation::Vertical)
      option.set_minimum(10).to_unsafe.should eq(option.to_unsafe)
      option.minimum.should eq(10)
      option.set_maximum(90).to_unsafe.should eq(option.to_unsafe)
      option.maximum.should eq(90)
      option.set_tick_position(Qt6::SliderTickPosition::TicksBothSides).to_unsafe.should eq(option.to_unsafe)
      option.tick_position.should eq(Qt6::SliderTickPosition::TicksBothSides)
      option.set_tick_interval(4).to_unsafe.should eq(option.to_unsafe)
      option.tick_interval.should eq(4)
      option.set_upside_down(true).to_unsafe.should eq(option.to_unsafe)
      option.upside_down?.should be_true
      option.set_slider_position(28).to_unsafe.should eq(option.to_unsafe)
      option.slider_position.should eq(28)
      option.set_slider_value(26).to_unsafe.should eq(option.to_unsafe)
      option.slider_value.should eq(26)
      option.set_single_step(3).to_unsafe.should eq(option.to_unsafe)
      option.single_step.should eq(3)
      option.set_page_step(11).to_unsafe.should eq(option.to_unsafe)
      option.page_step.should eq(11)
      option.set_notch_target(7.25).to_unsafe.should eq(option.to_unsafe)
      option.notch_target.should eq(7.25)
      option.set_dial_wrapping(true).to_unsafe.should eq(option.to_unsafe)
      option.dial_wrapping?.should be_true
      option.set_keyboard_modifiers(Qt6::KeyboardModifier::ShiftModifier | Qt6::KeyboardModifier::ControlModifier).to_unsafe.should eq(option.to_unsafe)
      option.keyboard_modifiers.includes?(Qt6::KeyboardModifier::ShiftModifier).should be_true
      option.keyboard_modifiers.includes?(Qt6::KeyboardModifier::ControlModifier).should be_true

      option.init_from(slider)
      option.orientation.should eq(Qt6::Orientation::Horizontal)
      option.minimum.should eq(10)
      option.maximum.should eq(90)
      option.tick_position.should eq(Qt6::SliderTickPosition::TicksBelow)
      option.tick_interval.should eq(5)
      option.slider_position.should eq(42)
      option.slider_value.should eq(42)
      option.single_step.should eq(2)
      option.page_step.should eq(12)
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 160.0, 24.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true

      option.init_from(scroll_bar)
      option.orientation.should eq(Qt6::Orientation::Vertical)
      option.minimum.should eq(0)
      option.maximum.should eq(100)
      option.slider_position.should eq(30)
      option.slider_value.should eq(30)
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 18.0, 120.0))

      option.init_from(dial)
      option.minimum.should eq(0)
      option.maximum.should eq(40)
      option.slider_position.should eq(14)
      option.slider_value.should eq(14)
      option.notch_target.should be_close(6.5, 0.001)
      option.dial_wrapping?.should be_true
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 60.0, 60.0))
    ensure
      option.release
      dial.release
      scroll_bar.release
      slider.release
    end
  end

  it "supports spin-box style options" do
    application = app
    spin_box = Qt6::SpinBox.new
    double_spin_box = Qt6::DoubleSpinBox.new
    date_edit = Qt6::DateEdit.new
    option = Qt6::StyleOptionSpinBox.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)

    begin
      spin_box.button_symbols = Qt6::AbstractSpinBoxButtonSymbol::PlusMinus
      spin_box.frame = false
      spin_box.set_range(10, 90)
      spin_box.value = 42
      spin_box.resize(80, 28)
      spin_box.show

      double_spin_box.set_range(0.0, 10.0)
      double_spin_box.value = 10.0
      double_spin_box.resize(96, 28)
      double_spin_box.show

      date_edit.date = Qt6::QDate.new(2026, 5, 23)
      date_edit.resize(110, 28)
      date_edit.show

      application.process_events

      option.type.should eq(Qt6::StyleOptionType::SpinBox)
      wrapped.should be_a(Qt6::StyleOptionSpinBox)
      option.button_symbols.should eq(Qt6::AbstractSpinBoxButtonSymbol::UpDownArrows)
      option.step_enabled.should eq(Qt6::AbstractSpinBoxStepEnabled::StepNone)
      option.frame?.should be_false
      option.sub_controls.should eq(Qt6::StyleSubControl::All)

      option.set_button_symbols(Qt6::AbstractSpinBoxButtonSymbol::NoButtons).to_unsafe.should eq(option.to_unsafe)
      option.button_symbols.should eq(Qt6::AbstractSpinBoxButtonSymbol::NoButtons)
      option.set_step_enabled(Qt6::AbstractSpinBoxStepEnabled::StepUpEnabled | Qt6::AbstractSpinBoxStepEnabled::StepDownEnabled).to_unsafe.should eq(option.to_unsafe)
      option.step_enabled.includes?(Qt6::AbstractSpinBoxStepEnabled::StepUpEnabled).should be_true
      option.step_enabled.includes?(Qt6::AbstractSpinBoxStepEnabled::StepDownEnabled).should be_true
      option.set_frame(false).to_unsafe.should eq(option.to_unsafe)
      option.frame?.should be_false

      option.init_from(spin_box)
      option.button_symbols.should eq(Qt6::AbstractSpinBoxButtonSymbol::PlusMinus)
      option.frame?.should be_false
      option.step_enabled.includes?(Qt6::AbstractSpinBoxStepEnabled::StepUpEnabled).should be_true
      option.step_enabled.includes?(Qt6::AbstractSpinBoxStepEnabled::StepDownEnabled).should be_true
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 80.0, 28.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true

      option.init_from(double_spin_box)
      option.frame?.should be_true
      option.step_enabled.includes?(Qt6::AbstractSpinBoxStepEnabled::StepDownEnabled).should be_true
      option.step_enabled.includes?(Qt6::AbstractSpinBoxStepEnabled::StepUpEnabled).should be_false
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 96.0, 28.0))

      option.init_from(date_edit)
      option.button_symbols.should eq(Qt6::AbstractSpinBoxButtonSymbol::UpDownArrows)
      option.frame?.should be_true
      option.rect.should eq(Qt6::RectF.new(0.0, 0.0, 110.0, 28.0))
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
    ensure
      option.release
      date_edit.release
      double_spin_box.release
      spin_box.release
    end
  end

  it "supports tab style options" do
    application = app
    tab_bar = Qt6::TabBar.new
    option = Qt6::StyleOptionTab.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)
    icon = Qt6::QIcon.new

    begin
      tab_bar.add_tab("Alpha")
      tab_bar.add_tab("Beta")
      tab_bar.add_tab("Gamma")
      tab_bar.current_index = 1
      tab_bar.resize(180, 28)
      tab_bar.show

      application.process_events

      option.type.should eq(Qt6::StyleOptionType::Tab)
      wrapped.should be_a(Qt6::StyleOptionTab)
      option.shape.should eq(Qt6::TabBarShape::RoundedNorth)
      option.text.should eq("")
      option.icon.null?.should be_true
      option.row.should eq(0)
      option.position.should eq(Qt6::StyleOptionTabPosition::Beginning)
      option.selected_position.should eq(Qt6::StyleOptionTabSelectedPosition::NotAdjacent)
      option.corner_widgets.should eq(Qt6::StyleOptionTabCornerWidget::NoCornerWidgets)
      option.icon_size.should eq(Qt6::Size.new(-1, -1))
      option.document_mode?.should be_false
      option.left_button_size.should eq(Qt6::Size.new(-1, -1))
      option.right_button_size.should eq(Qt6::Size.new(-1, -1))
      option.features.should eq(Qt6::StyleOptionTabFeature::None)
      option.tab_index.should eq(-1)

      option.set_shape(Qt6::TabBarShape::TriangularSouth).to_unsafe.should eq(option.to_unsafe)
      option.shape.should eq(Qt6::TabBarShape::TriangularSouth)
      option.set_text("Operations").to_unsafe.should eq(option.to_unsafe)
      option.text.should eq("Operations")
      option.set_icon(icon).to_unsafe.should eq(option.to_unsafe)
      option.icon.null?.should be_true
      option.set_row(2).to_unsafe.should eq(option.to_unsafe)
      option.row.should eq(2)
      option.set_position(Qt6::StyleOptionTabPosition::Middle).to_unsafe.should eq(option.to_unsafe)
      option.position.should eq(Qt6::StyleOptionTabPosition::Middle)
      option.set_selected_position(Qt6::StyleOptionTabSelectedPosition::PreviousIsSelected).to_unsafe.should eq(option.to_unsafe)
      option.selected_position.should eq(Qt6::StyleOptionTabSelectedPosition::PreviousIsSelected)
      option.set_corner_widgets(Qt6::StyleOptionTabCornerWidget::LeftCornerWidget | Qt6::StyleOptionTabCornerWidget::RightCornerWidget).to_unsafe.should eq(option.to_unsafe)
      option.corner_widgets.includes?(Qt6::StyleOptionTabCornerWidget::LeftCornerWidget).should be_true
      option.corner_widgets.includes?(Qt6::StyleOptionTabCornerWidget::RightCornerWidget).should be_true
      option.set_icon_size(Qt6::Size.new(18, 12)).to_unsafe.should eq(option.to_unsafe)
      option.icon_size.should eq(Qt6::Size.new(18, 12))
      option.set_document_mode(true).to_unsafe.should eq(option.to_unsafe)
      option.document_mode?.should be_true
      option.set_left_button_size(Qt6::Size.new(9, 7)).to_unsafe.should eq(option.to_unsafe)
      option.left_button_size.should eq(Qt6::Size.new(9, 7))
      option.set_right_button_size(Qt6::Size.new(11, 8)).to_unsafe.should eq(option.to_unsafe)
      option.right_button_size.should eq(Qt6::Size.new(11, 8))
      option.set_features(Qt6::StyleOptionTabFeature::HasFrame | Qt6::StyleOptionTabFeature::MinimumSizeHint).to_unsafe.should eq(option.to_unsafe)
      option.features.includes?(Qt6::StyleOptionTabFeature::HasFrame).should be_true
      option.features.includes?(Qt6::StyleOptionTabFeature::MinimumSizeHint).should be_true
      option.set_tab_index(6).to_unsafe.should eq(option.to_unsafe)
      option.tab_index.should eq(6)

      option.init_from(tab_bar, 0)
      option.text.should eq("Alpha")
      option.tab_index.should eq(0)
      option.position.should eq(Qt6::StyleOptionTabPosition::Beginning)
      option.selected_position.should eq(Qt6::StyleOptionTabSelectedPosition::NextIsSelected)
      option.row.should eq(0)
      option.rect.height.should be > 0
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true

      option.init_from(tab_bar, 2)
      option.text.should eq("Gamma")
      option.tab_index.should eq(2)
      option.position.should eq(Qt6::StyleOptionTabPosition::End)
      option.selected_position.should eq(Qt6::StyleOptionTabSelectedPosition::PreviousIsSelected)
      option.row.should eq(0)
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
    ensure
      icon.release
      option.release
      tab_bar.release
    end
  end

  it "supports tab-bar-base style options" do
    application = app
    tab_bar = Qt6::TabBar.new
    option = Qt6::StyleOptionTabBarBase.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)

    begin
      tab_bar.add_tab("North")
      tab_bar.add_tab("Center")
      tab_bar.add_tab("South")
      tab_bar.current_index = 1
      tab_bar.resize(180, 28)
      tab_bar.show

      application.process_events

      option.type.should eq(Qt6::StyleOptionType::TabBarBase)
      wrapped.should be_a(Qt6::StyleOptionTabBarBase)
      option.shape.should eq(Qt6::TabBarShape::RoundedNorth)
      option.tab_bar_rect.should eq(Qt6::RectF.new(0.0, 0.0, 0.0, 0.0))
      option.selected_tab_rect.should eq(Qt6::RectF.new(0.0, 0.0, 0.0, 0.0))
      option.document_mode?.should be_false

      option.set_shape(Qt6::TabBarShape::TriangularWest).to_unsafe.should eq(option.to_unsafe)
      option.shape.should eq(Qt6::TabBarShape::TriangularWest)
      option.set_tab_bar_rect(Qt6::Rect.new(1, 2, 120, 24)).to_unsafe.should eq(option.to_unsafe)
      option.tab_bar_rect.should eq(Qt6::RectF.new(1.0, 2.0, 120.0, 24.0))
      option.set_selected_tab_rect(Qt6::Rect.new(3, 4, 40, 20)).to_unsafe.should eq(option.to_unsafe)
      option.selected_tab_rect.should eq(Qt6::RectF.new(3.0, 4.0, 40.0, 20.0))
      option.set_document_mode(true).to_unsafe.should eq(option.to_unsafe)
      option.document_mode?.should be_true

      option.init_from(tab_bar)
      option.shape.should eq(Qt6::TabBarShape::RoundedNorth)
      option.tab_bar_rect.should eq(Qt6::RectF.new(0.0, 0.0, 180.0, 28.0))
      option.selected_tab_rect.height.should be > 0
      option.selected_tab_rect.width.should be > 0
      option.document_mode?.should be_false
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true

      option.init_from(tab_bar, 0)
      option.selected_tab_rect.height.should be > 0
      option.selected_tab_rect.width.should be > 0
      option.selected_tab_rect.should_not eq(Qt6::RectF.new(0.0, 0.0, 0.0, 0.0))

      option.init_from(tab_bar, -1)
      option.selected_tab_rect.should eq(Qt6::RectF.new(0.0, 0.0, 0.0, 0.0))
    ensure
      option.release
      tab_bar.release
    end
  end

  it "supports tab-widget-frame style options" do
    application = app
    tab_widget = Qt6::TabWidget.new
    first_page = Qt6::Widget.new
    second_page = Qt6::Widget.new
    option = Qt6::StyleOptionTabWidgetFrame.new
    wrapped = Qt6::StyleOption.wrap(option.to_unsafe)

    begin
      tab_widget.add_tab(first_page, "Overview")
      tab_widget.add_tab(second_page, "Details")
      tab_widget.current_index = 1
      tab_widget.resize(220, 120)
      tab_widget.show

      application.process_events

      option.type.should eq(Qt6::StyleOptionType::TabWidgetFrame)
      wrapped.should be_a(Qt6::StyleOptionTabWidgetFrame)
      option.line_width.should eq(0)
      option.mid_line_width.should eq(0)
      option.shape.should eq(Qt6::TabBarShape::RoundedNorth)
      option.tab_bar_size.should eq(Qt6::Size.new(-1, -1))
      option.right_corner_widget_size.should eq(Qt6::Size.new(-1, -1))
      option.left_corner_widget_size.should eq(Qt6::Size.new(-1, -1))
      option.tab_bar_rect.should eq(Qt6::RectF.new(0.0, 0.0, 0.0, 0.0))
      option.selected_tab_rect.should eq(Qt6::RectF.new(0.0, 0.0, 0.0, 0.0))

      option.set_line_width(2).to_unsafe.should eq(option.to_unsafe)
      option.line_width.should eq(2)
      option.set_mid_line_width(1).to_unsafe.should eq(option.to_unsafe)
      option.mid_line_width.should eq(1)
      option.set_shape(Qt6::TabBarShape::TriangularSouth).to_unsafe.should eq(option.to_unsafe)
      option.shape.should eq(Qt6::TabBarShape::TriangularSouth)
      option.set_tab_bar_size(Qt6::Size.new(80, 24)).to_unsafe.should eq(option.to_unsafe)
      option.tab_bar_size.should eq(Qt6::Size.new(80, 24))
      option.set_right_corner_widget_size(Qt6::Size.new(14, 11)).to_unsafe.should eq(option.to_unsafe)
      option.right_corner_widget_size.should eq(Qt6::Size.new(14, 11))
      option.set_left_corner_widget_size(Qt6::Size.new(12, 9)).to_unsafe.should eq(option.to_unsafe)
      option.left_corner_widget_size.should eq(Qt6::Size.new(12, 9))
      option.set_tab_bar_rect(Qt6::Rect.new(1, 2, 120, 28)).to_unsafe.should eq(option.to_unsafe)
      option.tab_bar_rect.should eq(Qt6::RectF.new(1.0, 2.0, 120.0, 28.0))
      option.set_selected_tab_rect(Qt6::Rect.new(3, 4, 50, 18)).to_unsafe.should eq(option.to_unsafe)
      option.selected_tab_rect.should eq(Qt6::RectF.new(3.0, 4.0, 50.0, 18.0))

      option.init_from(tab_widget)
      option.shape.should eq(Qt6::TabBarShape::RoundedNorth)
      option.tab_bar_size.width.should be > 0
      option.tab_bar_size.height.should be > 0
      option.tab_bar_rect.width.should be > 0
      option.tab_bar_rect.height.should be > 0
      option.selected_tab_rect.width.should be > 0
      option.selected_tab_rect.height.should be > 0
      option.state.includes?(Qt6::StyleStateFlag::Enabled).should be_true
    ensure
      option.release
      second_page.release
      first_page.release
      tab_widget.release
    end
  end

  it "supports application timing, drag, and focus helpers" do
    application = app
    previous_cursor_flash_time = application.cursor_flash_time
    previous_double_click_interval = application.double_click_interval
    previous_keyboard_input_interval = application.keyboard_input_interval
    previous_wheel_scroll_lines = application.wheel_scroll_lines
    previous_start_drag_time = application.start_drag_time
    previous_start_drag_distance = application.start_drag_distance
    previous_auto_sip_enabled = application.auto_sip_enabled?

    window = Qt6::Widget.new
    line_edit = Qt6::LineEdit.new("", window)
    line_edit.focus_policy = Qt6::FocusPolicy::StrongFocus

    begin
      application.cursor_flash_time = previous_cursor_flash_time + 100
      application.double_click_interval = previous_double_click_interval + 25
      application.keyboard_input_interval = previous_keyboard_input_interval + 15
      application.wheel_scroll_lines = previous_wheel_scroll_lines + 1
      application.start_drag_time = previous_start_drag_time + 20
      application.start_drag_distance = previous_start_drag_distance + 2
      application.auto_sip_enabled = !previous_auto_sip_enabled

      window.show
      window.raise_to_front
      window.activate_window
      application.process_events
      line_edit.set_focus
      20.times do
        application.process_events
        break if line_edit.has_focus? || application.focus_widget.try(&.to_unsafe) == line_edit.to_unsafe
        sleep 10.milliseconds
      end

      application.cursor_flash_time.should eq(previous_cursor_flash_time + 100)
      application.double_click_interval.should eq(previous_double_click_interval + 25)
      application.keyboard_input_interval.should eq(previous_keyboard_input_interval + 15)
      application.wheel_scroll_lines.should eq(previous_wheel_scroll_lines + 1)
      application.start_drag_time.should eq(previous_start_drag_time + 20)
      application.start_drag_distance.should eq(previous_start_drag_distance + 2)
      application.auto_sip_enabled?.should eq(!previous_auto_sip_enabled)
      if active_window = application.active_window
        active_window.to_unsafe.should eq(window.to_unsafe)
        line_edit.has_focus?.should be_true
        application.focus_widget.should_not be_nil
        application.focus_widget.not_nil!.to_unsafe.should eq(line_edit.to_unsafe)
      end

      application.close_all_windows
      5.times { application.process_events }
      window.visible?.should be_false
    ensure
      application.cursor_flash_time = previous_cursor_flash_time
      application.double_click_interval = previous_double_click_interval
      application.keyboard_input_interval = previous_keyboard_input_interval
      application.wheel_scroll_lines = previous_wheel_scroll_lines
      application.start_drag_time = previous_start_drag_time
      application.start_drag_distance = previous_start_drag_distance
      application.auto_sip_enabled = previous_auto_sip_enabled
      line_edit.release
      window.release
    end
  end

  it "supports queued application invocations" do
    application = app
    label = Qt6::Label.new("Waiting")
    events = [] of String

    application.invoke_later do
      events << "first"
      label.text = "First"
    end

    application.invoke_later do
      events << "second"
      label.text = "Second"
    end

    events.should be_empty
    label.text.should eq("Waiting")

    application.process_events

    events.should eq(["first", "second"])
    label.text.should eq("Second")
    label.release
  end

  it "queues application invocations from worker fibers" do
    application = app
    label = Qt6::Label.new("Waiting")
    scheduled = Channel(Nil).new(1)
    completion = Channel(String).new(1)

    spawn same_thread: false do
      application.invoke_later do
        label.text = "Worker"
        completion.send(label.text)
      end

      scheduled.send(nil)
    end

    scheduled.receive

    result = nil
    20.times do
      application.process_events

      select
      when value = completion.receive
        result = value
        break
      else
        Fiber.yield
      end
    end

    result.should eq("Worker")
    label.text.should eq("Worker")
    label.release
  end

  it "updates label and button text" do
    app
    label = Qt6::Label.new("Ready")
    button = Qt6::PushButton.new("Launch")

    label.text.should eq("Ready")
    button.text.should eq("Launch")

    label.text = "Running"
    button.text = "Stop"

    label.text.should eq("Running")
    button.text.should eq("Stop")
    label.release
    button.release
  end

  it "supports layouts and click callbacks" do
    application = app
    window = Qt6::Widget.new
    layout = Qt6::VBoxLayout.new(window)
    label = Qt6::Label.new("0")
    button = Qt6::PushButton.new("Increment")
    clicks = 0

    layout << label
    layout << button

    button.on_clicked do
      clicks += 1
      label.text = clicks.to_s
    end

    button.click
    application.process_events

    clicks.should eq(1)
    label.text.should eq("1")
    window.release
  end

  it "supports shared abstract button properties and slots" do
    application = app
    window = Qt6::Widget.new
    button = Qt6::PushButton.new("Stateful")
    group = Qt6::ButtonGroup.new(window)
    group.add(button, 7)

    clicks = 0
    clicked_states = [] of Bool
    lifecycle = [] of String

    button.on_clicked { clicks += 1 }
    button.on_clicked_checked { |value| clicked_states << value }
    button.on_pressed { lifecycle << "pressed" }
    button.on_released { lifecycle << "released" }

    button.checkable = true
    button.checked = false
    button.shortcut = "Ctrl+Alt+S"
    button.down = true
    button.down = false
    button.auto_repeat = true
    button.auto_repeat_delay = 120
    button.auto_repeat_interval = 45
    button.auto_exclusive = true
    button.icon = Qt6::QIcon.new
    button.icon_size = Qt6::Size.new(18, 20)

    button.toggle
    application.process_events
    button.click
    application.process_events

    loop = Qt6::QEventLoop.new
    Qt6::QTimer.single_shot(150) { loop.quit }
    button.animate_click
    loop.run
    application.process_events

    button.checkable?.should be_true
    button.checked?.should be_true
    button.shortcut.to_s.should eq("Ctrl+Alt+S")
    button.down?.should be_false
    button.auto_repeat?.should be_true
    button.auto_repeat_delay.should eq(120)
    button.auto_repeat_interval.should eq(45)
    button.auto_exclusive?.should be_true
    button.group.not_nil!.to_unsafe.should eq(group.to_unsafe)
    button.icon.null?.should be_true
    button.icon_size.should eq(Qt6::Size.new(18, 20))
    clicks.should eq(2)
    clicked_states.should eq([true, true])
    lifecycle.should eq(["pressed", "released", "pressed", "released"])

    window.release
  end

  it "supports hbox, form, and grid layouts" do
    application = app
    window = Qt6::Widget.new
    name_field = Qt6::LineEdit.new("Terrain")
    kind_field = Qt6::ComboBox.new
    kind_field << "Hexes" << "Terrain"
    description_field = Qt6::LineEdit.new("Detailed terrain notes")
    temporary_field = Qt6::LineEdit.new("Temporary")
    primary = Qt6::PushButton.new("Primary")
    secondary = Qt6::PushButton.new("Secondary")
    top_left = Qt6::Label.new("A")
    top_right = Qt6::Label.new("B")
    detail_status = Qt6::Label.new("Ready")
    footer = Qt6::Label.new("Footer")
    kind_label = Qt6::Label.new("Kind")
    map_name_label = Qt6::Label.new("Map Name")
    advanced_row = Qt6::HBoxLayout.new
    advanced_toggle = Qt6::CheckBox.new("Advanced")
    advanced_mode = Qt6::ComboBox.new
    advanced_mode << "Fog" << "LOS"
    detail_grid = Qt6::GridLayout.new
    detail_grid.add(top_right, 0, 0)
    detail_grid.add(detail_status, 0, 1)
    notes_layout = Qt6::HBoxLayout.new
    notes_label = Qt6::Label.new("Notes")
    notes_value = Qt6::Label.new("Ready")
    grid_layout = nil.as(Qt6::GridLayout?)

    form = window.form do |form|
      form.field_growth_policy = Qt6::FormLayoutFieldGrowthPolicy::ExpandingFieldsGrow
      form.row_wrap_policy = Qt6::FormLayoutRowWrapPolicy::WrapLongRows
      form.label_alignment = Qt6::AlignmentFlag::Right
      form.form_alignment = Qt6::AlignmentFlag::Top | Qt6::AlignmentFlag::Left
      form.horizontal_spacing = 12
      form.vertical_spacing = 9
      form.add_row(map_name_label, name_field)
      form.add_row(kind_label, kind_field)
      form.insert_row(1, "Description", description_field)
      form.add_row("Advanced", advanced_row)
      advanced_row.add_stretch
      advanced_row << advanced_toggle
      advanced_row << advanced_mode
      notes_layout << notes_label
      notes_layout << notes_value
      form.add_row(Qt6::Widget.new.tap do |button_row|
        button_row.hbox do |row|
          row.add_stretch
          row << primary
          row.add_stretch(2)
          row << secondary
          row.add_stretch
        end
      end)
      form.add_row(Qt6::Widget.new.tap do |grid_host|
        grid_host.grid do |grid|
          grid_layout = grid
          grid.horizontal_spacing = 6
          grid.vertical_spacing = 4
          grid.origin_corner = Qt6::Corner::BottomLeftCorner
          grid.set_row_stretch(2, 2)
          grid.set_column_stretch(1, 3)
          grid.set_row_minimum_height(0, 18)
          grid.set_column_minimum_width(0, 24)
          grid.add(top_left, 0, 0, 1, 1, Qt6::AlignmentFlag::Right)
          grid.add(detail_grid, 1, 0, 1, 2, Qt6::AlignmentFlag::Center)
          grid.add(footer, 2, 0, 1, 2, Qt6::AlignmentFlag::HCenter)
        end
      end)
      form.add_row("Temporary", temporary_field)
      form.add_row(notes_layout)
    end
    form.set_row_visible(advanced_row, false)
    form.set_row_visible(advanced_row, true)
    form.set_row_visible(notes_layout, false)
    form.set_row_visible(notes_layout, true)

    name_field.text.should eq("Terrain")
    description_field.text.should eq("Detailed terrain notes")
    kind_field.count.should eq(2)
    advanced_mode.count.should eq(2)
    top_left.text.should eq("A")
    top_right.text.should eq("B")
    detail_status.text.should eq("Ready")
    footer.text.should eq("Footer")
    detail_grid.row_count.should eq(1)
    detail_grid.column_count.should eq(2)
    form.field_growth_policy.should eq(Qt6::FormLayoutFieldGrowthPolicy::ExpandingFieldsGrow)
    form.row_wrap_policy.should eq(Qt6::FormLayoutRowWrapPolicy::WrapLongRows)
    form.label_alignment.should eq(Qt6::AlignmentFlag::Right)
    form.form_alignment.should eq(Qt6::AlignmentFlag::Top | Qt6::AlignmentFlag::Left)
    form.horizontal_spacing.should eq(12)
    form.vertical_spacing.should eq(9)
    form.row_count.should eq(8)
    form.label_for_field(name_field).not_nil!.to_unsafe.should eq(map_name_label.to_unsafe)
    form.label_for_field(kind_field).not_nil!.to_unsafe.should eq(kind_label.to_unsafe)
    form.label_for_field(advanced_row).should_not be_nil
    form.row_visible?(advanced_row).should be_true
    form.row_visible?(notes_layout).should be_true
    grid = grid_layout.not_nil!
    grid.horizontal_spacing.should eq(6)
    grid.vertical_spacing.should eq(4)
    grid.origin_corner.should eq(Qt6::Corner::BottomLeftCorner)
    grid.row_stretch(2).should eq(2)
    grid.column_stretch(1).should eq(3)
    grid.row_minimum_height(0).should eq(18)
    grid.column_minimum_width(0).should eq(24)
    grid.row_count.should eq(3)
    grid.column_count.should eq(2)
    top_left_item = grid.item_at_position(0, 0).not_nil!
    top_left_item.widget.not_nil!.to_unsafe.should eq(top_left.to_unsafe)
    detail_item = grid.item_at_position(1, 0).not_nil!
    detail_item.layout.not_nil!.to_unsafe.should eq(detail_grid.to_unsafe)
    window.show
    application.process_events
    footer_cell = grid.cell_rect(2, 0)
    footer_cell.width.should be > 0
    footer_cell.height.should be > 0
    temporary_result = form.take_row(temporary_field)
    advanced_result = form.take_row(advanced_row)
    form.row_count.should eq(6)
    temporary_result.label_item.should_not be_nil
    temporary_result.label_item.not_nil!.widget.should_not be_nil
    temporary_result.field_item.not_nil!.widget.not_nil!.to_unsafe.should eq(temporary_field.to_unsafe)
    advanced_result.label_item.should_not be_nil
    advanced_result.label_item.not_nil!.widget.should_not be_nil
    advanced_result.field_item.not_nil!.layout.not_nil!.to_unsafe.should eq(advanced_row.to_unsafe)
    notes_value.text.should eq("Ready")
    top_left_item.release
    detail_item.release
    temporary_result.release
    advanced_result.release
    window.release
  end

  it "supports vbox layout stretch helpers" do
    app
    window = Qt6::Widget.new
    top = Qt6::Label.new("Top")
    bottom = Qt6::Label.new("Bottom")

    window.vbox do |column|
      column << top
      column.add_stretch(2)
      column << bottom
      column.add_stretch
    end

    top.text.should eq("Top")
    bottom.text.should eq("Bottom")
    window.release
  end

  it "supports shared box layout helpers and direction control" do
    application = app
    window = Qt6::Widget.new
    left = Qt6::Label.new("Left")
    right = Qt6::Label.new("Right")
    center = Qt6::Label.new("Center")
    row = Qt6::HBoxLayout.new
    mirrored_row = Qt6::HBoxLayout.wrap(row.to_unsafe)

    layout = Qt6::BoxLayout.new(Qt6::BoxLayoutDirection::LeftToRight, window)
    layout.enabled = false
    layout.enabled?.should be_false
    layout.set_enabled(true)
    layout.set_contents_margins(3, 4, 5, 6)
    row.add(left, 1)
    row.insert(1, center, 3)
    row.set_stretch_factor(center, 4).should be_true
    row.stretch(0).should eq(1)
    row.stretch(1).should eq(4)
    layout.add(row, 2)
    layout.insert_spacing(1, 8)
    layout.insert(2, right, 5)
    layout.insert_stretch(3, 2)
    layout.add_spacing(4)
    layout.add_stretch
    layout.set_stretch(0, 1)
    layout.set_stretch_factor(right, 6).should be_true
    layout.set_stretch_factor(row, 7).should be_true
    layout.stretch(0).should eq(7)
    layout.stretch(2).should eq(6)
    layout.add_strut(24)
    mirrored_row.direction.should eq(Qt6::BoxLayoutDirection::LeftToRight)
    mirrored_row.direction = Qt6::BoxLayoutDirection::RightToLeft
    layout.direction = Qt6::BoxLayoutDirection::RightToLeft
    window.resize(180, 60)
    window.show
    application.process_events

    row.direction.should eq(Qt6::BoxLayoutDirection::RightToLeft)
    mirrored_row.to_unsafe.should eq(row.to_unsafe)
    layout.direction.should eq(Qt6::BoxLayoutDirection::RightToLeft)
    layout.contents_margins.should eq(Qt6::Margins.new(3, 4, 5, 6))
    layout.count.should eq(7)
    layout.index_of(right).should eq(2)
    layout.size_hint.width.should be >= 0
    layout.size_hint.height.should be >= 0
    layout.minimum_size.width.should be >= 0
    layout.maximum_size.width.should be >= layout.minimum_size.width
    layout.geometry.width.should be > 0
    layout.geometry.height.should be > 0
    layout.contents_rect.width.should be >= 0
    layout.contents_rect.height.should be >= 0
    layout.invalidate
    layout.activate.should be_true
    layout.update
    layout_item = layout.item_at(0).not_nil!
    layout_item.layout.not_nil!.to_unsafe.should eq(row.to_unsafe)
    layout_item.geometry.width.should be >= 0
    row.count.should eq(2)
    row_item = row.item_at(0).not_nil!
    row_item.widget.not_nil!.to_unsafe.should eq(left.to_unsafe)
    removed_item = row.take_at(1).not_nil!
    row.count.should eq(1)
    removed_item.widget.not_nil!.to_unsafe.should eq(center.to_unsafe)
    left.text.should eq("Left")
    center.text.should eq("Center")
    right.text.should eq("Right")
    removed_item.release
    window.release
  end

  it "supports spacer items through shared layout item wrappers" do
    application = app
    window = Qt6::Widget.new
    left = Qt6::Label.new("Left")
    right = Qt6::Label.new("Right")
    footer = Qt6::Label.new("Footer")
    spacer = Qt6::SpacerItem.new(12, 18, Qt6::SizePolicy::Expanding, Qt6::SizePolicy::Minimum)
    grid_spacer = Qt6::SpacerItem.new(8, 6, Qt6::SizePolicy::Minimum, Qt6::SizePolicy::Expanding)
    grid = Qt6::GridLayout.new

    spacer.set_geometry(1, 2, 12, 18)
    spacer.geometry.should eq(Qt6::Rect.new(1, 2, 12, 18))
    spacer.change_size(14, 20, Qt6::SizePolicy::MinimumExpanding, Qt6::SizePolicy::Fixed)

    grid.add(Qt6::Label.new("Top"), 0, 0)
    grid.add(grid_spacer, 1, 0)
    grid.add(footer, 2, 0)

    layout = Qt6::HBoxLayout.new(window)
    layout << left
    layout.add(spacer)
    layout << right
    layout.add(grid)

    window.resize(220, 80)
    window.show
    application.process_events

    spacer.size_hint.should eq(Qt6::Size.new(14, 20))
    spacer.minimum_size.should eq(Qt6::Size.new(14, 20))
    spacer.horizontal_size_policy.should eq(Qt6::SizePolicy::MinimumExpanding)
    spacer.vertical_size_policy.should eq(Qt6::SizePolicy::Fixed)
    spacer.size_policy.horizontal_policy.should eq(Qt6::SizePolicy::MinimumExpanding)
    spacer.size_policy.vertical_policy.should eq(Qt6::SizePolicy::Fixed)
    layout.count.should eq(4)
    layout.index_of(right).should eq(2)

    spacer_item = layout.item_at(1).not_nil!
    spacer_item.should be_a(Qt6::SpacerItem)
    spacer_item.spacer_item.not_nil!.to_unsafe.should eq(spacer.to_unsafe)
    spacer_item.geometry.width.should be >= 0

    grid_item = grid.item_at_position(1, 0).not_nil!
    grid_item.should be_a(Qt6::SpacerItem)
    grid_item.spacer_item.not_nil!.to_unsafe.should eq(grid_spacer.to_unsafe)

    removed_spacer = layout.take_at(1).not_nil!
    removed_spacer.should be_a(Qt6::SpacerItem)
    removed_spacer.to_unsafe.should eq(spacer.to_unsafe)
    layout.count.should eq(3)

    left.text.should eq("Left")
    right.text.should eq("Right")
    footer.text.should eq("Footer")

    removed_spacer.release
    window.release
  end

  it "supports label alignment and pixmap display settings" do
    application = app
    window = Qt6::Widget.new
    label = Qt6::Label.new("Centered")
    buddy = Qt6::LineEdit.new("", window)
    pixmap = Qt6::QPixmap.new(24, 12)
    pixmap.fill(Qt6::Color.new(80, 120, 160))

    window.vbox do |column|
      column << label
      column << buddy
    end

    label.set_text("Centered")
    label.set_alignment(Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter)
    label.set_word_wrap(true)
    label.set_indent(6)
    label.set_margin(4)
    label.set_buddy(buddy)
    label.set_pixmap(pixmap)
    label.set_scaled_contents(true)

    window.resize(80, 40)
    window.show
    application.process_events

    returned_pixmap = label.pixmap
    label.alignment.includes?(Qt6::AlignmentFlag::Right).should be_true
    label.alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
    label.word_wrap?.should be_true
    label.indent.should eq(6)
    label.margin.should eq(4)
    label.buddy.not_nil!.to_unsafe.should eq(buddy.to_unsafe)
    returned_pixmap.should_not be_nil
    returned_pixmap.not_nil!.size.should eq(Qt6::Size.new(24, 12))
    label.scaled_contents?.should be_true

    label.pixmap = nil
    label.text = "Fallback text"
    label.pixmap = nil
    label.scaled_contents = false
    label.buddy = nil
    label.text.should eq("Fallback text")
    label.scaled_contents?.should be_false
    label.buddy.should be_nil

    returned_pixmap.try(&.release)
    pixmap.release
    window.release
  end

  it "supports table widget item icons and theme icon lookup" do
    application = app
    table_widget = Qt6::TableWidget.new
    icon_path = File.join(Dir.tempdir, "crystal-qt6-table-item-icon-#{Process.pid}.png")
    icon_image = Qt6::QImage.new(16, 16)
    icon_image.fill(Qt6::Color.new(0, 0, 0, 0))
    icon_image.set_pixel_color(8, 8, Qt6::Color.new(32, 96, 180, 255))
    icon_image.save(icon_path).should be_true

    icon = Qt6::QIcon.from_file(icon_path)
    themed_icon = Qt6::QIcon.from_theme("document-open")
    item = Qt6::TableWidgetItem.new("Album")
    item.icon = icon

    table_widget.row_count = 1
    table_widget.column_count = 1
    table_widget.set_item(0, 0, item)
    application.process_events

    icon.null?.should be_false
    themed_icon.should be_a(Qt6::QIcon)
    table_widget.item(0, 0).not_nil!.text.should eq("Album")
    returned_icon = table_widget.item(0, 0).not_nil!.icon
    returned_icon.null?.should be_false

    returned_icon.release
    themed_icon.release
    icon.release
    icon_image.release
    table_widget.release
  ensure
    File.delete?(icon_path) if icon_path
  end

  it "builds a window with the helper DSL" do
    app
    window = Qt6.window("Helper Window", 420, 240) do |widget|
      widget.vbox do |column|
        column << Qt6::Label.new("Top")
        column << Qt6::PushButton.new("Action")
      end
    end

    window.window_title.should eq("Helper Window")
    window.release
  end
end
