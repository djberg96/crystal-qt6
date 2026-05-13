require "./spec_helper"

describe Qt6 do
  it "supports common control widgets and date-based editors" do
    application = app
    slider = Qt6::Slider.new(Qt6::Orientation::Vertical)
    progress_bar = Qt6::ProgressBar.new
    scroll_bar = Qt6::ScrollBar.new(Qt6::Orientation::Horizontal)
    dial = Qt6::Dial.new
    date_time_edit = Qt6::DateTimeEdit.new
    date_edit = Qt6::DateEdit.new
    time_edit = Qt6::TimeEdit.new
    calendar = Qt6::CalendarWidget.new
    lcd = Qt6::LcdNumber.new
    stacked_host = Qt6::Widget.new
    command_link = Qt6::CommandLinkButton.new("Export", "Save the current map")
    parented_command_link = Qt6::CommandLinkButton.new(stacked_host)
    titled_command_link = Qt6::CommandLinkButton.new("Publish", stacked_host)
    tab_bar = Qt6::TabBar.new
    stacked_layout = Qt6::StackedLayout.new(stacked_host)
    first_page = Qt6::Label.new("General")
    second_page = Qt6::Label.new("Preview")

    slider_values = [] of Int32
    slider_ranges = [] of Tuple(Int32, Int32)
    slider_pressed = 0
    slider_released = 0
    scroll_values = [] of Int32
    scroll_actions = [] of Qt6::AbstractSliderAction
    scroll_pressed = 0
    progress_values = [] of Int32
    dial_values = [] of Int32
    dial_ranges = [] of Tuple(Int32, Int32)
    dial_released = 0
    date_time_values = [] of String
    date_values = [] of String
    time_values = [] of String
    calendar_values = [] of String
    calendar_clicked = [] of String
    calendar_activated = [] of String
    calendar_pages = [] of Tuple(Int32, Int32)
    lcd_overflows = 0
    tab_indices = [] of Int32
    stacked_indices = [] of Int32

    slider.on_value_changed do |value|
      slider_values << value
    end
    slider.on_range_changed do |minimum, maximum|
      slider_ranges << {minimum, maximum}
    end
    slider.on_pressed do
      slider_pressed += 1
    end
    slider.on_released do
      slider_released += 1
    end
    scroll_bar.on_value_changed do |value|
      scroll_values << value
    end
    scroll_bar.on_action_triggered do |action|
      scroll_actions << action
    end
    scroll_bar.on_pressed do
      scroll_pressed += 1
    end
    dial.on_value_changed do |value|
      dial_values << value
    end
    dial.on_range_changed do |minimum, maximum|
      dial_ranges << {minimum, maximum}
    end
    dial.on_released do
      dial_released += 1
    end
    date_time_edit.on_date_time_changed do |value|
      date_time_values << value.to_string
    end
    date_edit.on_date_changed do |value|
      date_values << value.to_string
    end
    time_edit.on_time_changed do |value|
      time_values << value.to_string
    end
    calendar.on_selection_changed do
      calendar_values << calendar.selected_date.to_string
    end
    calendar.on_clicked do |value|
      calendar_clicked << value.to_string
    end
    calendar.on_activated do |value|
      calendar_activated << value.to_string
    end
    calendar.on_current_page_changed do |year, month|
      calendar_pages << {year, month}
    end
    lcd.on_overflow do
      lcd_overflows += 1
    end
    tab_bar.on_current_index_changed do |value|
      tab_indices << value
    end
    stacked_layout.on_current_index_changed do |value|
      stacked_indices << value
    end
    progress_bar.on_value_changed do |value|
      progress_values << value
    end

    progress_bar.set_range(0, 12)
    progress_bar.value = 7
    progress_bar.text_visible = false
    progress_bar.inverted_appearance = true
    progress_bar.text_direction = Qt6::ProgressBarDirection::BottomToTop
    progress_bar.format = "%v/%m"
    progress_bar.alignment = Qt6::AlignmentFlag::Center
    progress_bar.orientation = Qt6::Orientation::Vertical

    slider.orientation.should eq(Qt6::Orientation::Vertical)
    slider.orientation = Qt6::Orientation::Horizontal
    slider.set_range(10, 80)
    slider.single_step = 4
    slider.page_step = 12
    slider.tracking = false
    slider.inverted_appearance = true
    slider.inverted_controls = true
    slider.slider_down = true
    slider.value = 29
    Qt6::LibQt6.qt6cr_abstract_slider_emit_pressed(slider.to_unsafe)
    Qt6::LibQt6.qt6cr_abstract_slider_emit_released(slider.to_unsafe)

    scroll_bar.set_range(5, 20)
    scroll_bar.single_step = 2
    scroll_bar.page_step = 5
    scroll_bar.value = 11
    scroll_bar.trigger_action(Qt6::AbstractSliderAction::SliderPageStepAdd)
    Qt6::LibQt6.qt6cr_abstract_slider_emit_pressed(scroll_bar.to_unsafe)

    dial.set_range(0, 360)
    dial.single_step = 15
    dial.page_step = 60
    dial.wrapping = true
    dial.notch_target = 7.5
    dial.notches_visible = true
    dial.inverted_controls = true
    dial.value = 90
    Qt6::LibQt6.qt6cr_abstract_slider_emit_released(dial.to_unsafe)

    date_time = Qt6::QDateTime.new(2026, 4, 14, 9, 30, 15)
    initial_calendar_date = calendar.selected_date.to_string
    date = initial_calendar_date == "2026-04-15" ? Qt6::QDate.new(2026, 4, 16) : Qt6::QDate.new(2026, 4, 15)
    time = Qt6::QTime.new(11, 45, 0)

    date_time_edit.display_format = "yyyy/MM/dd HH:mm:ss"
    date_time_edit.calendar_popup = true
    date_time_edit.date_time = date_time
    date_edit.date = date
    time_edit.time = time

    calendar.minimum_date = Qt6::QDate.new(2026, 1, 1)
    calendar.maximum_date = Qt6::QDate.new(2026, 12, 31)
    calendar.set_date_range(Qt6::QDate.new(2026, 2, 1), Qt6::QDate.new(2026, 11, 30))
    calendar.grid_visible = true
    calendar.navigation_bar_visible = false
    calendar.date_edit_enabled = true
    calendar.date_edit_accept_delay = 640
    calendar.set_current_page(2026, 6)
    calendar.show_next_month
    calendar.show_previous_month
    calendar.show_next_year
    calendar.show_previous_year
    calendar.show_selected_date
    calendar.show_today
    calendar.selected_date = date
    calendar.clicked.emit(date)
    calendar.activated.emit(date)

    lcd.set_digit_count(6)
    lcd.set_hex_mode
    lcd.set_segment_style(Qt6::LcdNumberSegmentStyle::Flat)
    lcd.set_small_decimal_point(true)
    lcd.display(255)
    lcd.set_dec_mode
    lcd.set_oct_mode
    lcd.set_bin_mode
    lcd.set_hex_mode
    lcd.int_value.should eq(255)
    lcd.display(16_777_216)

    command_link.description = "Save the current map as an image"
    command_link.default = true
    command_link.auto_default = true
    command_link.flat = true
    titled_command_link.set_description("Upload the current map package")

    tab_bar.add_tab("Layers")
    tab_bar.add_tab("Export")
    tab_bar.insert_tab(1, "Search").should eq(1)
    tab_bar.set_tab_text(2, "Preview")
    tab_bar.set_tab_enabled(1, false).should be_false
    tab_bar.draw_base = false
    tab_bar.movable = true
    tab_bar.tabs_closable = true
    tab_bar.remove_tab(0)
    tab_bar.current_index = 1

    stacked_layout << first_page
    stacked_layout << second_page
    stacked_layout.current_index = 1

    application.process_events

    progress_bar.minimum.should eq(0)
    progress_bar.maximum.should eq(12)
    progress_bar.value.should eq(7)
    progress_bar.text_visible?.should be_false
    progress_bar.inverted_appearance?.should be_true
    progress_bar.text_direction.should eq(Qt6::ProgressBarDirection::BottomToTop)
    progress_bar.format.should eq("%v/%m")
    progress_bar.text.should eq("7/12")
    progress_bar.alignment.should eq(Qt6::AlignmentFlag::Center)
    progress_bar.orientation.should eq(Qt6::Orientation::Vertical)
    progress_bar.size_hint.width.should be > 0
    progress_bar.minimum_size_hint.height.should be > 0
    progress_values.should contain(7)
    progress_bar.reset_format.format.should eq("%p%")
    progress_bar.reset.value.should eq(-1)

    slider.orientation.should eq(Qt6::Orientation::Horizontal)
    slider.minimum.should eq(10)
    slider.maximum.should eq(80)
    slider.single_step.should eq(4)
    slider.page_step.should eq(12)
    slider.tracking?.should be_false
    slider.inverted_appearance?.should be_true
    slider.inverted_controls?.should be_true
    slider.slider_down?.should be_true
    slider.slider_position.should eq(29)
    slider.value.should eq(29)
    slider_values.last.should eq(29)
    slider_ranges.should contain({10, 80})
    slider_pressed.should be >= 1
    slider_released.should eq(1)

    scroll_bar.orientation.should eq(Qt6::Orientation::Horizontal)
    scroll_bar.minimum.should eq(5)
    scroll_bar.maximum.should eq(20)
    scroll_bar.single_step.should eq(2)
    scroll_bar.page_step.should eq(5)
    scroll_bar.value.should eq(16)
    scroll_values.last.should eq(16)
    scroll_actions.should contain(Qt6::AbstractSliderAction::SliderPageStepAdd)
    scroll_pressed.should eq(1)

    dial.minimum.should eq(0)
    dial.maximum.should eq(360)
    dial.single_step.should eq(15)
    dial.page_step.should eq(60)
    dial.wrapping?.should be_true
    dial.notch_target.should eq(7.5)
    dial.notch_size.should be > 0
    dial.notches_visible?.should be_true
    dial.inverted_controls?.should be_true
    dial.value.should eq(90)
    dial_values.last.should eq(90)
    dial_ranges.should contain({0, 360})
    dial_released.should eq(1)

    date_time_edit.display_format.should eq("yyyy/MM/dd HH:mm:ss")
    date_time_edit.calendar_popup?.should be_true
    date_time_edit.date_time.to_string.should eq(date_time.to_string)
    date_time_values.last.should eq(date_time.to_string)

    date_edit.date.to_string.should eq(date.to_string)
    date_values.last.should eq(date.to_string)

    time_edit.time.to_string.should eq(time.to_string)
    time_values.last.should eq(time.to_string)

    calendar.minimum_date.to_string.should eq("2026-02-01")
    calendar.maximum_date.to_string.should eq("2026-11-30")
    calendar.grid_visible?.should be_true
    calendar.navigation_bar_visible?.should be_false
    calendar.date_edit_enabled?.should be_true
    calendar.date_edit_accept_delay.should eq(640)
    calendar.year_shown.should eq(2026)
    calendar.month_shown.should be >= 1
    calendar.month_shown.should be <= 12
    calendar.selected_date.to_string.should eq(date.to_string)
    calendar_values.last.should eq(date.to_string)
    calendar_clicked.last.should eq(date.to_string)
    calendar_activated.last.should eq(date.to_string)
    calendar_pages.should contain({2026, 6})

    lcd.digit_count.should eq(6)
    lcd.mode.should eq(Qt6::LcdNumberMode::Hex)
    lcd.segment_style.should eq(Qt6::LcdNumberSegmentStyle::Flat)
    lcd.small_decimal_point?.should be_true
    lcd.overflow?(16_777_216).should be_true
    lcd.overflow?(255).should be_false
    lcd_overflows.should be >= 1

    command_link.text.should eq("Export")
    command_link.description.should eq("Save the current map as an image")
    command_link.default?.should be_true
    command_link.auto_default?.should be_true
    command_link.flat?.should be_true
    parented_command_link.text.should eq("")
    parented_command_link.description.should eq("")
    titled_command_link.text.should eq("Publish")
    titled_command_link.description.should eq("Upload the current map package")

    tab_bar.count.should eq(2)
    tab_bar.current_index.should eq(1)
    tab_bar.tab_text(1).should eq("Preview")
    tab_bar.tab_text(0).should eq("Search")
    tab_bar.tab_enabled?(0).should be_false
    tab_bar.draw_base?.should be_false
    tab_bar.movable?.should be_true
    tab_bar.tabs_closable?.should be_true
    tab_indices.last.should eq(1)

    stacked_layout.count.should eq(2)
    stacked_layout.current_index.should eq(1)
    stacked_indices.last.should eq(1)

    progress_bar.release
    scroll_bar.release
    dial.release
    date_time_edit.release
    date_edit.release
    time_edit.release
    calendar.release
    lcd.release
    command_link.release
    tab_bar.release
    stacked_host.release
  end

  it "supports WargameMapTool-style panel primitives" do
    application = app
    dialog = Qt6::Dialog.new
    dialog.minimum_width = 280

    mode_group = Qt6::ButtonGroup.new(dialog)
    mode_group.exclusive = true

    place_button = Qt6::PushButton.new("Place")
    select_button = Qt6::PushButton.new("Select")
    tool_button = Qt6::ToolButton.new
    tool_menu = Qt6::Menu.new("Brush Modes", dialog)
    stroke_action = Qt6::Action.new("Stroke", dialog)
    tool_button.text = "Brush"
    tool_button.tool_button_style = Qt6::ToolButtonStyle::TextUnderIcon
    tool_button.icon = Qt6::QIcon.new
    tool_button.icon_size = Qt6::Size.new(24, 24)
    tool_button.set_fixed_size(72, 88)
    tool_button.menu.should be_nil
    tool_button.default_action.should be_nil
    tool_button.auto_raise = true
    tool_menu.add_action("Fill")
    tool_button.menu = tool_menu
    tool_button.default_action = stroke_action
    tool_button.enabled = false
    tool_button.enabled = true

    toggled_states = [] of Bool
    clicked_labels = [] of String
    pressed_labels = [] of String
    released_labels = [] of String
    clicked_ids = [] of Int32
    pressed_ids = [] of Int32
    released_ids = [] of Int32
    group_toggles = [] of Tuple(String, Bool)
    id_toggles = [] of Tuple(Int32, Bool)
    select_button.on_toggled do |value|
      toggled_states << value
    end
    mode_group.on_button_clicked do |button|
      clicked_labels << (button.try(&.text) || "")
    end
    mode_group.on_button_pressed do |button|
      pressed_labels << (button.try(&.text) || "")
    end
    mode_group.on_button_released do |button|
      released_labels << (button.try(&.text) || "")
    end
    mode_group.on_button_toggled do |button, checked|
      group_toggles << {(button.try(&.text) || ""), checked}
    end
    mode_group.on_id_clicked do |id|
      clicked_ids << id
    end
    mode_group.on_id_pressed do |id|
      pressed_ids << id
    end
    mode_group.on_id_released do |id|
      released_ids << id
    end
    mode_group.on_id_toggled do |id, checked|
      id_toggles << {id, checked}
    end

    place_button.checkable = true
    select_button.checkable = true
    mode_group.add(place_button, 0)
    mode_group.add(select_button, 1)
    place_button.checked = true
    select_button.checked = true
    mode_group.id(select_button).should eq(1)
    mode_group.checked_button.not_nil!.to_unsafe.should eq(select_button.to_unsafe)
    mode_group.set_id(select_button, 5).should eq(5)
    mode_group.button(5).not_nil!.to_unsafe.should eq(select_button.to_unsafe)
    mode_group.buttons.map(&.text).sort.should eq(["Place", "Select"])
    mode_group << tool_button
    mode_group.buttons.map(&.text).sort.should eq([tool_button.text, "Place", "Select"].sort)
    mode_group.remove(tool_button)
    mode_group.buttons.map(&.text).sort.should eq(["Place", "Select"])
    clicked_labels.clear
    pressed_labels.clear
    released_labels.clear
    clicked_ids.clear
    pressed_ids.clear
    released_ids.clear
    group_toggles.clear
    id_toggles.clear
    select_button.click
    place_button.click
    application.process_events
    clicked_labels.should eq(["Select", "Place"])
    pressed_labels.should eq(["Select", "Place"])
    released_labels.should eq(["Select", "Place"])
    clicked_ids.should eq([5, 0])
    pressed_ids.should eq([5, 0])
    released_ids.should eq([5, 0])
    group_toggles.should eq([{"Select", false}, {"Place", true}])
    id_toggles.should eq([{5, false}, {0, true}])
    select_button.click
    application.process_events

    separator = Qt6::Frame.new
    separator.frame_shape = Qt6::FrameShape::HLine
    separator.frame_shadow = Qt6::FrameShadow::Sunken
    separator.line_width = 2
    separator.mid_line_width = 1
    separator.set_frame_style(Qt6::FrameShape::Panel, Qt6::FrameShadow::Raised)
    separator.frame_rect = Qt6::Rect.new(1, 2, 80, 6)
    separator.set_frame_shape(Qt6::FrameShape::HLine)
    separator.set_frame_shadow(Qt6::FrameShadow::Sunken)
    separator.set_line_width(2)
    separator.set_mid_line_width(1)
    separator.set_frame_rect(Qt6::Rect.new(1, 2, 80, 6))
    separator.frame_rect.should eq(Qt6::Rect.new(1, 2, 80, 6))

    host = Qt6::Widget.new
    layout = host.vbox do |column|
      column.spacing = 6
      column.set_contents_margins(4, 5, 6, 7)
    end
    layout << place_button
    layout << select_button
    layout.insert(0, tool_button)
    layout << separator
    layout.remove(separator)
    layout << separator

    scroll_area = Qt6::ScrollArea.new
    scroll_area.frame_shape = Qt6::FrameShape::NoFrame
    scroll_area.set_frame_style(Qt6::FrameShape::NoFrame.value | Qt6::FrameShadow::Plain.value)
    scroll_area.vertical_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOff
    scroll_area.horizontal_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOn
    scroll_area.widget_resizable = true
    scroll_area.widget = host
    focus_frame = Qt6::FocusFrame.new(dialog)
    tool_box = Qt6::ToolBox.new(dialog)
    tool_box_events = [] of Int32
    layers_page = Qt6::Label.new("Layers")
    filters_page = Qt6::Label.new("Filters")
    imported_page = Qt6::Label.new("Imported")
    tool_box.on_current_index_changed do |value|
      tool_box_events << value
    end
    tool_box.add_item(layers_page, "Layers")
    tool_box.add_item(filters_page, Qt6::QIcon.new, "Filters")
    tool_box.insert_item(1, imported_page, "Imported")
    size_grip = Qt6::SizeGrip.new(dialog)

    button_box = Qt6::DialogButtonBox.new(
      Qt6::DialogButtonBoxStandardButton::Ok | Qt6::DialogButtonBoxStandardButton::Cancel,
      dialog
    )
    button_box.center_buttons = true
    button_box.orientation = Qt6::Orientation::Vertical
    button_box.standard_buttons = Qt6::DialogButtonBoxStandardButton::Ok | Qt6::DialogButtonBoxStandardButton::Cancel | Qt6::DialogButtonBoxStandardButton::Help
    accepted = 0
    rejected = 0
    help_requests = 0
    clicked_buttons = [] of String
    button_box.on_accepted { accepted += 1 }
    button_box.on_help_requested { help_requests += 1 }
    button_box.on_clicked do |button|
      clicked_buttons << (button.try(&.text) || "")
    end
    button_box.on_rejected { rejected += 1 }

    ok_button = button_box.button(Qt6::DialogButtonBoxStandardButton::Ok).not_nil!
    cancel_button = button_box.button(Qt6::DialogButtonBoxStandardButton::Cancel).not_nil!
    help_button = button_box.button(Qt6::DialogButtonBoxStandardButton::Help).not_nil!
    custom_button = Qt6::PushButton.new("Preview")
    button_box.add_button(custom_button, Qt6::DialogButtonBoxButtonRole::ActionRole).to_unsafe.should eq(custom_button.to_unsafe)
    reset_button = button_box.add_button("Reset Export", Qt6::DialogButtonBoxButtonRole::ResetRole)
    apply_button = button_box.add_button(Qt6::DialogButtonBoxStandardButton::Apply)
    ok_button.text = "Export"
    ok_button.click
    help_button.click
    cancel_button.click
    custom_button.click
    reset_button.click
    application.process_events

    dialog.minimum_width.should eq(280)
    layout.spacing.should eq(6)
    tool_button.tool_button_style.should eq(Qt6::ToolButtonStyle::TextUnderIcon)
    tool_button.icon_size.should eq(Qt6::Size.new(24, 24))
    tool_button.menu.not_nil!.title.should eq("Brush Modes")
    tool_button.default_action.not_nil!.to_unsafe.should eq(stroke_action.to_unsafe)
    tool_button.auto_raise?.should be_true
    tool_button.enabled?.should be_true
    tool_button.size.should eq(Qt6::Size.new(72, 88))
    place_button.checkable?.should be_true
    place_button.checked?.should be_false
    select_button.checked?.should be_true
    mode_group.checked_id.should eq(5)
    mode_group.buttons.size.should eq(2)
    mode_group.button(5).not_nil!.text.should eq("Select")
    mode_group.button(5).not_nil!.checked?.should be_true
    toggled_states.last.should be_true
    separator.frame_shape.should eq(Qt6::FrameShape::HLine)
    separator.frame_shadow.should eq(Qt6::FrameShadow::Sunken)
    separator.frame_style.should eq(Qt6::FrameShape::HLine.value | Qt6::FrameShadow::Sunken.value)
    separator.line_width.should eq(2)
    separator.mid_line_width.should eq(1)
    separator.frame_width.should be >= 1
    scroll_area.frame_shape.should eq(Qt6::FrameShape::NoFrame)
    scroll_area.frame_style.should eq(Qt6::FrameShape::NoFrame.value | Qt6::FrameShadow::Plain.value)
    scroll_area.vertical_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOff)
    scroll_area.horizontal_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOn)
    scroll_area.widget_resizable?.should be_true
    focus_frame.widget.should be_nil
    focus_frame.widget = select_button
    focus_frame.widget.not_nil!.to_unsafe.should eq(select_button.to_unsafe)
    focus_frame.set_widget(place_button).to_unsafe.should eq(focus_frame.to_unsafe)
    focus_frame.widget.not_nil!.to_unsafe.should eq(place_button.to_unsafe)
    focus_frame.widget = nil
    focus_frame.widget.should be_nil
    tool_box.count.should eq(3)
    tool_box.item_text(0).should eq("Layers")
    tool_box.item_text(1).should eq("Imported")
    tool_box.set_item_text(1, "Assets").should eq("Assets")
    tool_box.item_text(1).should eq("Assets")
    tool_box.item_enabled?(0).should be_true
    tool_box.set_item_enabled(0, false).should be_false
    tool_box.item_enabled?(0).should be_false
    tool_box.current_widget = layers_page
    application.process_events
    tool_box.current_index.should eq(0)
    tool_box.current_index = 1
    application.process_events
    tool_box.current_widget.not_nil!.to_unsafe.should eq(imported_page.to_unsafe)
    tool_box.widget(2).not_nil!.to_unsafe.should eq(filters_page.to_unsafe)
    tool_box.index_of(filters_page).should eq(2)
    tool_box_events.last.should eq(1)
    tool_box.current_widget = filters_page
    application.process_events
    tool_box.current_index.should eq(2)
    tool_box.remove_item(1)
    tool_box.count.should eq(2)
    dialog.resize(320, 240)
    dialog.show
    application.process_events
    size_grip.size_hint.width.should be >= 0
    size_grip.size_hint.height.should be >= 0
    button_box.center_buttons?.should be_true
    button_box.orientation.should eq(Qt6::Orientation::Vertical)
    button_box.standard_buttons.should eq(
      Qt6::DialogButtonBoxStandardButton::Ok |
      Qt6::DialogButtonBoxStandardButton::Cancel |
      Qt6::DialogButtonBoxStandardButton::Help |
      Qt6::DialogButtonBoxStandardButton::Apply
    )
    button_box.buttons.size.should eq(6)
    button_box.button_role(ok_button).should eq(Qt6::DialogButtonBoxButtonRole::AcceptRole)
    button_box.button_role(custom_button).should eq(Qt6::DialogButtonBoxButtonRole::ActionRole)
    button_box.button_role(reset_button).should eq(Qt6::DialogButtonBoxButtonRole::ResetRole)
    button_box.standard_button(ok_button).should eq(Qt6::DialogButtonBoxStandardButton::Ok)
    button_box.standard_button(apply_button).should eq(Qt6::DialogButtonBoxStandardButton::Apply)
    button_box.standard_button(custom_button).should eq(Qt6::DialogButtonBoxStandardButton::NoButton)
    ok_button.text.should eq("Export")
    help_button.text.should_not be_empty
    clicked_buttons.should contain("Export")
    clicked_buttons.should contain(cancel_button.text)
    clicked_buttons.should contain(help_button.text)
    clicked_buttons.should contain("Preview")
    clicked_buttons.should contain("Reset Export")
    accepted.should eq(1)
    rejected.should eq(1)
    help_requests.should eq(1)
    button_box.remove_button(custom_button).to_unsafe.should eq(custom_button.to_unsafe)
    button_box.buttons.includes?(custom_button).should be_false
    button_box.clear
    button_box.buttons.should be_empty
    mode_group.remove(place_button)
    mode_group.id(place_button).should eq(-1)

    dialog.release
  end

  it "supports shortcut, rubber-band, and error helper widgets" do
    application = app
    host = Qt6::Widget.new
    host.resize(240, 180)

    sequence_changes = [] of String
    key_sequence_edit = Qt6::KeySequenceEdit.new("Ctrl+Shift+P", host)
    key_sequence_edit.on_key_sequence_changed do |value|
      sequence_changes << value.to_s
    end
    key_sequence_edit.set_clear_button_enabled(true)
    key_sequence_edit.key_sequence = "Ctrl+Alt+L"
    application.process_events

    host.show
    application.process_events

    rubber_band = Qt6::RubberBand.new(Qt6::RubberBandShape::Rectangle, host)
    rubber_band.set_geometry(Qt6::Rect.new(10, 12, 64, 48))
    rubber_band.show

    error_message = Qt6::ErrorMessage.new(host)
    error_message.show_message("Network timeout", "network")
    application.process_events

    key_sequence_edit.key_sequence.to_s.should_not be_empty
    sequence_changes.last.should eq(key_sequence_edit.key_sequence.to_s)
    key_sequence_edit.clear_button_enabled?.should be_true
    key_sequence_edit.clear
    application.process_events
    key_sequence_edit.key_sequence.to_s.should eq("")
    sequence_changes.last.should eq("")

    rubber_band.shape.should eq(Qt6::RubberBandShape::Rectangle)
    rubber_band.visible?.should be_true
    rubber_band.size.should eq(Qt6::Size.new(64, 48))
    rubber_band.hide
    application.process_events
    rubber_band.visible?.should be_false

    error_message.visible?.should be_true
    error_message.hide
    application.process_events
    error_message.visible?.should be_false

    host.release
  end

  it "supports standalone shortcuts" do
    application = app
    host = Qt6::EventWidget.new
    host.resize(240, 120)
    host.focus_policy = Qt6::FocusPolicy::StrongFocus

    shortcut = Qt6::Shortcut.new("P", host)
    activations = 0
    shortcut.on_activated do
      activations += 1
    end

    shortcut.auto_repeat = false
    shortcut.context = Qt6::ShortcutContext::WidgetShortcut
    shortcut.enabled = true
    shortcut.key_sequence = Qt6::KeySequence.new("P")

    host.show
    host.set_focus
    application.process_events

    shortcut.activate
    application.process_events

    shortcut.parent_widget.not_nil!.to_unsafe.should eq(host.to_unsafe)
    shortcut.key_sequence.to_s.should eq("P")
    shortcut.auto_repeat?.should be_false
    shortcut.context.should eq(Qt6::ShortcutContext::WidgetShortcut)
    shortcut.enabled?.should be_true
    activations.should eq(1)

    host.release
  end

  it "supports base gesture state, type, and hot-spot helpers" do
    app
    gesture = Qt6::Gesture.new
    hot_spot = Qt6::PointF.new(12.5, 24.0)

    gesture.gesture_type.should eq(Qt6::GestureType::CustomGesture)
    gesture.state.should eq(Qt6::GestureState::NoGesture)
    gesture.gesture_cancel_policy.should eq(Qt6::GestureCancelPolicy::CancelNone)
    gesture.has_hot_spot?.should be_false

    gesture.set_gesture_cancel_policy(Qt6::GestureCancelPolicy::CancelAllInContext)
    gesture.set_hot_spot(hot_spot)

    gesture.gesture_cancel_policy.should eq(Qt6::GestureCancelPolicy::CancelAllInContext)
    gesture.has_hot_spot?.should be_true
    gesture.hot_spot.should eq(hot_spot)

    gesture.unset_hot_spot
    gesture.has_hot_spot?.should be_false

    gesture.release
  end

  it "supports pan and pinch gesture state helpers" do
    app
    pan = Qt6::PanGesture.new
    pinch = Qt6::PinchGesture.new
    pan_offset = Qt6::PointF.new(18.0, 24.5)
    pan_last_offset = Qt6::PointF.new(5.0, 11.0)
    start_center = Qt6::PointF.new(10.0, 12.0)
    last_center = Qt6::PointF.new(14.5, 17.0)
    center = Qt6::PointF.new(19.0, 21.5)
    event = Qt6::GestureEvent.new([pan, pinch])

    pan.set_offset(pan_offset)
    pan.set_last_offset(pan_last_offset)
    pan.set_acceleration(1.75)

    pinch.set_change_flags(Qt6::PinchGestureChangeFlag::ScaleFactorChanged | Qt6::PinchGestureChangeFlag::CenterPointChanged)
    pinch.set_total_change_flags(Qt6::PinchGestureChangeFlag::ScaleFactorChanged | Qt6::PinchGestureChangeFlag::RotationAngleChanged | Qt6::PinchGestureChangeFlag::CenterPointChanged)
    pinch.set_start_center_point(start_center)
    pinch.set_last_center_point(last_center)
    pinch.set_center_point(center)
    pinch.set_total_scale_factor(1.8)
    pinch.set_last_scale_factor(1.2)
    pinch.set_scale_factor(1.5)
    pinch.set_total_rotation_angle(45.0)
    pinch.set_last_rotation_angle(12.5)
    pinch.set_rotation_angle(30.0)

    pan.gesture_type.should eq(Qt6::GestureType::PanGesture)
    pan.offset.should eq(pan_offset)
    pan.last_offset.should eq(pan_last_offset)
    pan.delta.should eq(Qt6::PointF.new(13.0, 13.5))
    pan.acceleration.should eq(1.75)

    pinch.gesture_type.should eq(Qt6::GestureType::PinchGesture)
    pinch.change_flags.should eq(Qt6::PinchGestureChangeFlag::ScaleFactorChanged | Qt6::PinchGestureChangeFlag::CenterPointChanged)
    pinch.total_change_flags.should eq(Qt6::PinchGestureChangeFlag::ScaleFactorChanged | Qt6::PinchGestureChangeFlag::RotationAngleChanged | Qt6::PinchGestureChangeFlag::CenterPointChanged)
    pinch.start_center_point.should eq(start_center)
    pinch.last_center_point.should eq(last_center)
    pinch.center_point.should eq(center)
    pinch.total_scale_factor.should eq(1.8)
    pinch.last_scale_factor.should eq(1.2)
    pinch.scale_factor.should eq(1.5)
    pinch.total_rotation_angle.should eq(45.0)
    pinch.last_rotation_angle.should eq(12.5)
    pinch.rotation_angle.should eq(30.0)

    event.gesture(Qt6::GestureType::PanGesture).should be_a(Qt6::PanGesture)
    event.gesture(Qt6::GestureType::PinchGesture).should be_a(Qt6::PinchGesture)
    event.gestures.map(&.gesture_type).should eq([Qt6::GestureType::PanGesture, Qt6::GestureType::PinchGesture])

    event.release
    pinch.release
    pan.release
  end

  it "supports gesture events and widget gesture registration" do
    app
    host = Qt6::Widget.new
    gesture = Qt6::Gesture.new
    event = Qt6::GestureEvent.new([gesture])
    live_event = Qt6::QEvent.new(event.to_unsafe)

    host.grab_gesture(Qt6::GestureType::CustomGesture, Qt6::GestureFlag::ReceivePartialGestures | Qt6::GestureFlag::IgnoredGesturesPropagateToParent)
    host.ungrab_gesture(Qt6::GestureType::CustomGesture)

    event.type.should eq(Qt6::EventType::Gesture)
    event.accepted?.should be_true
    event.gestures.map(&.to_unsafe).should eq([gesture.to_unsafe])
    event.active_gestures.map(&.to_unsafe).should eq([gesture.to_unsafe])
    event.canceled_gestures.should be_empty
    event.gesture(Qt6::GestureType::CustomGesture).not_nil!.to_unsafe.should eq(gesture.to_unsafe)

    event.ignore(gesture)
    event.accepted?(gesture).should be_false
    event.accepted?(Qt6::GestureType::CustomGesture).should be_false

    event.accept(gesture)
    event.accepted?(gesture).should be_true

    event.set_accepted(Qt6::GestureType::CustomGesture, false)
    event.accepted?(gesture).should be_false

    event.accept(Qt6::GestureType::CustomGesture)
    event.accepted?(Qt6::GestureType::CustomGesture).should be_true

    event.widget = host
    event.widget.not_nil!.to_unsafe.should eq(host.to_unsafe)
    live_event.gesture_event.to_unsafe.should eq(event.to_unsafe)

    event.release
    gesture.release
    host.release
  end

  it "supports callback-backed gesture recognizers" do
    app
    host = Qt6::Widget.new
    recognizer = Qt6::GestureRecognizer.new
    created_targets = [] of Void*
    recognize_calls = [] of {Void*, Void*, Int32}
    reset_calls = [] of Void*

    recognizer.on_create do |target|
      created_targets << (target.try(&.to_unsafe) || Pointer(Void).null)
      Qt6::Gesture.new(target)
    end

    recognizer.on_recognize do |state, watched, event|
      recognize_calls << {state.to_unsafe, watched.not_nil!.to_unsafe, event.type_value}
      Qt6::GestureRecognizerResult::MayBeGesture | Qt6::GestureRecognizerResult::ConsumeEventHint
    end

    recognizer.on_reset do |state|
      reset_calls << state.to_unsafe
    end

    type_id = recognizer.register
    type_id.should be >= Qt6::GestureType::CustomGesture.value
    recognizer.registered_types.should eq([type_id])

    host.grab_gesture(type_id, Qt6::GestureFlag::ReceivePartialGestures)
    host.ungrab_gesture(type_id)

    gesture = recognizer.create(host)
    event = Qt6::GestureEvent.new([gesture])
    event.set_widget(host)

    created_targets.should eq([Pointer(Void).null, host.to_unsafe])
    gesture.gesture_type.should eq(Qt6::GestureType::CustomGesture)
    gesture.gesture_type_value.should eq(Qt6::GestureType::CustomGesture.value)
    event.gesture(gesture.gesture_type_value).not_nil!.to_unsafe.should eq(gesture.to_unsafe)

    result = recognizer.recognize(gesture, host, Qt6::QEvent.new(event.to_unsafe))
    result.should eq(Qt6::GestureRecognizerResult::MayBeGesture | Qt6::GestureRecognizerResult::ConsumeEventHint)
    recognize_calls.should eq([{gesture.to_unsafe, host.to_unsafe, Qt6::EventType::Gesture.value}])

    recognizer.reset(gesture)
    reset_calls.should eq([gesture.to_unsafe])

    recognizer.unregister(type_id)
    recognizer.registered_types.should be_empty

    event.release
    host.release
    recognizer.release
  end

  it "supports widget graphics effects" do
    application = app
    host = Qt6::Widget.new
    host.resize(320, 220)

    blur_target = Qt6::Label.new("Blur", host)
    blur_target.move(12, 12)
    color_target = Qt6::Label.new("Colorize", host)
    color_target.move(12, 48)
    shadow_target = Qt6::Label.new("Shadow", host)
    shadow_target.move(12, 84)
    opacity_target = Qt6::Label.new("Opacity", host)
    opacity_target.move(12, 120)

    blur = Qt6::GraphicsBlurEffect.new
    enabled_changes = [] of Bool
    blur.on_enabled_changed do |value|
      enabled_changes << value
    end
    blur.blur_radius = 6.5
    blur.set_blur_hints(Qt6::GraphicsBlurHint::QualityHint | Qt6::GraphicsBlurHint::AnimationHint)

    colorize = Qt6::GraphicsColorizeEffect.new
    color_changes = [] of Qt6::Color
    strength_changes = [] of Float64
    colorize.on_color_changed do |value|
      color_changes << value
    end
    colorize.on_strength_changed do |value|
      strength_changes << value
    end
    colorize.color = Qt6::Color.new(48, 112, 176)
    colorize.set_strength(0.45)

    shadow = Qt6::GraphicsDropShadowEffect.new
    shadow_blur_changes = [] of Float64
    shadow_color_changes = [] of Qt6::Color
    shadow_offset_changes = [] of Qt6::PointF
    shadow.on_blur_radius_changed do |value|
      shadow_blur_changes << value
    end
    shadow.on_color_changed do |value|
      shadow_color_changes << value
    end
    shadow.on_offset_changed do |value|
      shadow_offset_changes << value
    end
    shadow.set_blur_radius(9.0)
    shadow.set_color(Qt6::Color.new(20, 24, 32, 180))
    shadow.set_offset(3.0, 4.0)
    shadow.x_offset = 5.0
    shadow.y_offset = 6.0

    opacity = Qt6::GraphicsOpacityEffect.new
    opacity_changes = [] of Float64
    opacity_mask_changes = [] of Qt6::Color
    opacity_mask = Qt6::QBrush.new(Qt6::Color.new(140, 120, 220, 180))
    opacity.on_opacity_changed do |value|
      opacity_changes << value
    end
    opacity.on_opacity_mask_changed do |value|
      opacity_mask_changes << value.color
    end
    opacity.set_opacity(0.55)
    opacity.set_opacity_mask(opacity_mask)

    blur_target.graphics_effect = blur
    color_target.graphics_effect = colorize
    shadow_target.graphics_effect = shadow
    opacity_target.graphics_effect = opacity

    host.show
    application.process_events

    blur_target.graphics_effect.not_nil!.to_unsafe.should eq(blur.to_unsafe)
    color_target.graphics_effect.not_nil!.to_unsafe.should eq(colorize.to_unsafe)
    shadow_target.graphics_effect.not_nil!.to_unsafe.should eq(shadow.to_unsafe)
    opacity_target.graphics_effect.not_nil!.to_unsafe.should eq(opacity.to_unsafe)

    blur.blur_radius.should eq(6.5)
    blur.blur_hints.should eq(Qt6::GraphicsBlurHint::QualityHint | Qt6::GraphicsBlurHint::AnimationHint)
    blur_rect = blur.bounding_rect_for(Qt6::RectF.new(0.0, 0.0, 10.0, 10.0))
    blur_rect.width.should be >= 10.0
    blur_rect.height.should be >= 10.0
    blur.enabled = false
    application.process_events
    blur.enabled?.should be_false
    enabled_changes.last.should be_false
    blur.set_enabled(true)
    application.process_events
    blur.enabled?.should be_true
    enabled_changes.last.should be_true
    blur.bounding_rect.width.should be >= 0.0
    blur.bounding_rect.height.should be >= 0.0

    colorize.color.should eq(Qt6::Color.new(48, 112, 176))
    colorize.strength.should eq(0.45)
    color_changes.last.should eq(Qt6::Color.new(48, 112, 176, 255))
    strength_changes.last.should eq(0.45)
    colorize.bounding_rect.width.should be >= 0.0
    colorize.bounding_rect_for(Qt6::RectF.new(1.0, 2.0, 10.0, 12.0)).should eq(Qt6::RectF.new(1.0, 2.0, 10.0, 12.0))

    shadow.blur_radius.should eq(9.0)
    shadow.color.should eq(Qt6::Color.new(20, 24, 32, 180))
    shadow.offset.should eq(Qt6::PointF.new(5.0, 6.0))
    shadow.x_offset.should eq(5.0)
    shadow.y_offset.should eq(6.0)
    shadow_blur_changes.last.should eq(9.0)
    shadow_color_changes.last.should eq(Qt6::Color.new(20, 24, 32, 180))
    shadow_offset_changes.last.should eq(Qt6::PointF.new(5.0, 6.0))
    shadow_rect = shadow.bounding_rect_for(Qt6::RectF.new(0.0, 0.0, 10.0, 10.0))
    shadow_rect.width.should be >= 10.0
    shadow_rect.height.should be >= 10.0

    opacity.opacity.should eq(0.55)
    opacity.opacity_mask.color.should eq(Qt6::Color.new(140, 120, 220, 180))
    opacity_changes.last.should eq(0.55)
    opacity_mask_changes.last.should eq(Qt6::Color.new(140, 120, 220, 180))
    opacity.bounding_rect_for(Qt6::RectF.new(2.0, 3.0, 10.0, 12.0)).should eq(Qt6::RectF.new(2.0, 3.0, 10.0, 12.0))
    opacity_target.graphics_effect = nil
    application.process_events
    opacity_target.graphics_effect.should be_nil

    host.release
  end

  it "supports wizard flows and wizard pages" do
    application = app
    wizard = Qt6::Wizard.new
    wizard.resize(360, 220)

    intro_page = Qt6::WizardPage.new
    intro_page.title = "Welcome"
    intro_page.sub_title = "Choose your deployment settings."
    intro_page.set_button_text(Qt6::WizardButton::NextButton, "Continue")

    required_name = Qt6::LineEdit.new("", intro_page)
    complete_changes = 0
    intro_page.on_complete_changed do
      complete_changes += 1
    end
    intro_page.register_field("project_name*", required_name)

    summary_page = Qt6::WizardPage.new
    summary_page.title = "Summary"
    summary_page.sub_title = "Review the generated configuration."
    summary_page.final_page = true
    summary_page.commit_page = true

    accent = Qt6::QPixmap.new(8, 8)
    accent.fill(Qt6::Color.new(32, 96, 160))
    intro_page.set_pixmap(Qt6::WizardPixmap::LogoPixmap, accent)
    summary_page.set_pixmap(Qt6::WizardPixmap::BannerPixmap, accent)
    wizard.set_pixmap(Qt6::WizardPixmap::WatermarkPixmap, accent)

    current_ids = [] of Int32
    custom_buttons = [] of Int32
    added_pages = [] of Int32
    removed_pages = [] of Int32
    help_requests = 0
    wizard.on_current_id_changed do |value|
      current_ids << value
    end
    wizard.on_custom_button_clicked do |value|
      custom_buttons << value
    end
    wizard.on_page_added do |value|
      added_pages << value
    end
    wizard.on_page_removed do |value|
      removed_pages << value
    end
    wizard.on_help_requested do
      help_requests += 1
    end

    wizard.wizard_style = Qt6::WizardStyle::ModernStyle
    wizard.set_option(Qt6::WizardOption::HaveHelpButton, true)
    wizard.set_option(Qt6::WizardOption::HaveCustomButton1, true)
    wizard.set_option(Qt6::WizardOption::IndependentPages, true)
    wizard.options = Qt6::WizardOption::HaveHelpButton | Qt6::WizardOption::HaveCustomButton1 | Qt6::WizardOption::IndependentPages
    wizard.set_button_text(Qt6::WizardButton::CancelButton, "Abort")
    wizard.set_button_text(Qt6::WizardButton::CustomButton1, "Preview")

    intro_id = 10
    wizard.set_page(intro_id, intro_page)
    summary_id = wizard.add_page(summary_page)
    wizard.start_id = intro_id

    wizard.show
    application.process_events

    wizard.page_ids.should eq([intro_id, summary_id])
    added_pages.should contain(intro_id)
    added_pages.should contain(summary_id)
    wizard.start_id.should eq(intro_id)
    wizard.current_id.should eq(intro_id)
    wizard.current_page.not_nil!.title.should eq("Welcome")
    wizard.page(intro_id).not_nil!.sub_title.should contain("deployment")
    wizard.wizard_style.should eq(Qt6::WizardStyle::ModernStyle)
    wizard.option?(Qt6::WizardOption::HaveHelpButton).should be_true
    wizard.option?(Qt6::WizardOption::HaveCustomButton1).should be_true
    wizard.option?(Qt6::WizardOption::IndependentPages).should be_true
    wizard.options.should eq(Qt6::WizardOption::HaveHelpButton | Qt6::WizardOption::HaveCustomButton1 | Qt6::WizardOption::IndependentPages)
    wizard.button_text(Qt6::WizardButton::CancelButton).should eq("Abort")
    wizard.button(Qt6::WizardButton::CancelButton).not_nil!.text.should eq("Abort")
    wizard.button_text(Qt6::WizardButton::CustomButton1).should eq("Preview")
    wizard.button(Qt6::WizardButton::CustomButton1).not_nil!.text.should eq("Preview")
    wizard.pixmap(Qt6::WizardPixmap::WatermarkPixmap).size.should eq(Qt6::Size.new(8, 8))
    intro_page.pixmap(Qt6::WizardPixmap::LogoPixmap).size.should eq(Qt6::Size.new(8, 8))
    summary_page.pixmap(Qt6::WizardPixmap::BannerPixmap).size.should eq(Qt6::Size.new(8, 8))
    intro_page.button_text(Qt6::WizardButton::NextButton).should eq("Continue")
    intro_page.wizard.not_nil!.to_unsafe.should eq(wizard.to_unsafe)
    summary_page.wizard.not_nil!.to_unsafe.should eq(wizard.to_unsafe)
    intro_page.complete?.should be_false

    required_name.text = "Map Generator"
    application.process_events

    intro_page.complete?.should be_true
    complete_changes.should be > 0
    intro_page.validate_page.should be_true
    wizard.validate_current_page.should be_true
    intro_page.field("project_name").should eq("Map Generator")
    wizard.field("project_name").should eq("Map Generator")
    summary_page.field("project_name").should eq("Map Generator")

    summary_page.set_field("project_name", "Cartographer")
    application.process_events

    wizard.field("project_name").should eq("Cartographer")
    required_name.text.should eq("Cartographer")
    help_requests_before = help_requests
    custom_button_count_before = custom_buttons.size
    wizard.button(Qt6::WizardButton::HelpButton).not_nil!.click
    wizard.button(Qt6::WizardButton::CustomButton1).not_nil!.click
    application.process_events
    help_requests.should be > help_requests_before
    custom_buttons.size.should be > custom_button_count_before
    custom_buttons.last.should eq(Qt6::WizardButton::CustomButton1.value)

    wizard.button(Qt6::WizardButton::NextButton).not_nil!.click
    application.process_events

    wizard.current_id.should eq(summary_id)
    wizard.current_page.not_nil!.title.should eq("Summary")
    summary_page.final_page?.should be_true
    summary_page.commit_page?.should be_true
    summary_page.next_id.should eq(-1)
    current_ids.last.should eq(summary_id)
    wizard.has_visited_page?(intro_id).should be_true
    wizard.visited_ids.should contain(intro_id)
    wizard.visited_ids.should contain(summary_id)

    wizard.back
    application.process_events
    wizard.current_id.should eq(intro_id)

    removed_page_count_before = removed_pages.size
    wizard.remove_page(summary_id)
    wizard.page(summary_id).should be_nil
    wizard.page_ids.should eq([intro_id])
    removed_pages.size.should be > removed_page_count_before
    removed_pages.last.should eq(summary_id)

    wizard.release
  end

  it "supports MDI areas and subwindows" do
    application = app
    host = Qt6::Widget.new
    host.resize(520, 360)

    mdi_area = Qt6::MdiArea.new(host)
    mdi_area.resize(480, 300)
    mdi_area.background = Qt6::QBrush.new(Qt6::Color.new(232, 238, 244))
    mdi_area.activation_order = Qt6::MdiWindowOrder::ActivationHistoryOrder
    mdi_area.set_option(Qt6::MdiAreaOption::DontMaximizeSubWindowOnActivation, true)
    mdi_area.view_mode = Qt6::MdiViewMode::TabbedView
    mdi_area.document_mode = true
    mdi_area.set_tab_position(Qt6::TabPosition::South)
    mdi_area.set_tab_shape(Qt6::TabShape::Triangular)
    mdi_area.tabs_closable = true
    mdi_area.set_tabs_movable(true)

    first_editor = Qt6::TextEdit.new(parent: host)
    first_editor.plain_text = "Alpha"
    second_editor = Qt6::TextEdit.new(parent: host)
    second_editor.plain_text = "Bravo"
    detached_label = Qt6::Label.new("Detached", host)

    first_sub_window = mdi_area.add_sub_window(first_editor)
    second_sub_window = mdi_area.add_sub_window(second_editor)
    first_sub_window.window_title = "Alpha.map"
    second_sub_window.window_title = "Bravo.map"
    first_sub_window.set_keyboard_single_step(6)
    first_sub_window.set_keyboard_page_step(32)
    first_sub_window.set_option(Qt6::MdiSubWindowOption::RubberBandMove, true)
    second_sub_window.set_option(Qt6::MdiSubWindowOption::RubberBandResize, true)
    system_menu = Qt6::Menu.new("Window", host)
    system_menu.add_action("Close")
    first_sub_window.set_system_menu(system_menu)

    activated_titles = [] of String
    second_activation_count = 0
    state_changes = [] of Tuple(Qt6::WindowState, Qt6::WindowState)
    mdi_area.on_sub_window_activated do |sub_window|
      activated_titles << (sub_window.try(&.window_title) || "")
    end
    second_sub_window.on_about_to_activate do
      second_activation_count += 1
    end
    first_sub_window.on_window_state_changed do |old_state, new_state|
      state_changes << {old_state, new_state}
    end

    detached_sub_window = Qt6::MdiSubWindow.new(host)
    detached_sub_window.set_widget(detached_label)
    detached_sub_window.window_title = "Detached"

    host.show
    first_sub_window.show
    second_sub_window.show
    detached_sub_window.show
    application.process_events
    first_sub_window.show_maximized
    application.process_events
    mdi_area.set_active_sub_window(second_sub_window)
    application.process_events

    mdi_area.set_active_sub_window(first_sub_window)
    application.process_events
    mdi_area.set_active_sub_window(second_sub_window)
    application.process_events
    mdi_area.activate_previous_sub_window
    application.process_events
    mdi_area.activate_next_sub_window
    application.process_events
    mdi_area.tile_sub_windows
    mdi_area.cascade_sub_windows
    mdi_area.set_active_sub_window(second_sub_window)
    application.process_events

    mdi_area.background.color.should eq(Qt6::Color.new(232, 238, 244))
    mdi_area.activation_order.should eq(Qt6::MdiWindowOrder::ActivationHistoryOrder)
    mdi_area.option?(Qt6::MdiAreaOption::DontMaximizeSubWindowOnActivation).should be_true
    mdi_area.view_mode.should eq(Qt6::MdiViewMode::TabbedView)
    mdi_area.document_mode?.should be_true
    mdi_area.tabs_closable?.should be_true
    mdi_area.tabs_movable?.should be_true
    mdi_area.tab_position.should eq(Qt6::TabPosition::South)
    mdi_area.tab_shape.should eq(Qt6::TabShape::Triangular)
    mdi_area.current_sub_window.not_nil!.window_title.should eq("Bravo.map")
    mdi_area.active_sub_window.not_nil!.window_title.should eq("Bravo.map")
    mdi_area.sub_windows.map(&.window_title).should eq(["Alpha.map", "Bravo.map"])
    mdi_area.sub_windows(Qt6::MdiWindowOrder::ActivationHistoryOrder).map(&.window_title).should contain("Bravo.map")
    activated_titles.should contain("Alpha.map")
    activated_titles.should contain("Bravo.map")
    second_activation_count.should be > 0

    first_sub_window.widget.not_nil!.to_unsafe.should eq(first_editor.to_unsafe)
    first_sub_window.system_menu.not_nil!.title.should eq("Window")
    first_sub_window.mdi_area.not_nil!.to_unsafe.should eq(mdi_area.to_unsafe)
    first_sub_window.keyboard_single_step.should eq(6)
    first_sub_window.keyboard_page_step.should eq(32)
    first_sub_window.option?(Qt6::MdiSubWindowOption::RubberBandMove).should be_true
    state_changes.any? { |(_, new_state)| new_state.includes?(Qt6::WindowState::Maximized) }.should be_true
    second_sub_window.option?(Qt6::MdiSubWindowOption::RubberBandResize).should be_true
    detached_sub_window.widget.not_nil!.to_unsafe.should eq(detached_label.to_unsafe)
    detached_sub_window.widget = nil
    detached_sub_window.widget.should be_nil
    detached_sub_window.widget = detached_label
    detached_sub_window.widget.not_nil!.to_unsafe.should eq(detached_label.to_unsafe)
    detached_sub_window.mdi_area.should be_nil
    detached_sub_window.shaded?.should be_false
    detached_sub_window.show_shaded
    detached_sub_window.show_system_menu

    mdi_area.remove_sub_window(first_editor).to_unsafe.should eq(first_editor.to_unsafe)

    host.release
  end

  it "supports WargameMapTool-style font, stack, and browser widgets" do
    application = app
    host = Qt6::Widget.new
    host.resize(320, 220)

    font_combo = Qt6::FontComboBox.new(host)
    font_combo.set_size_policy(Qt6::SizePolicy::Ignored, Qt6::SizePolicy::Fixed)
    font_combo.writing_system = Qt6::FontWritingSystem::Latin
    font_combo.font_filters = Qt6::FontComboBoxFontFilter::ScalableFonts | Qt6::FontComboBoxFontFilter::ProportionalFonts

    font_families = [] of String
    font_combo.on_current_font_changed do |font|
      font_families << font.family
    end

    font_combo.count.should be > 0
    original_font_index = font_combo.current_index
    if font_combo.count > 1
      alternate_index = original_font_index == 0 ? 1 : 0
      font_combo.current_index = alternate_index
    end
    application.process_events

    browser = Qt6::TextBrowser.new(host)
    browser.open_external_links = false
    browser.default_style_sheet = "a { color: #c00; }"
    browser.html = <<-HTML
      <h1>Guide</h1>
      <p><a href="page:intro">Intro</a></p>
    HTML
    browser.scroll_to_top

    clicked_links = [] of String
    browser.on_anchor_clicked do |href|
      clicked_links << href
    end

    stack = Qt6::StackedWidget.new(host)
    info_page = Qt6::Label.new("Info")
    stack.add_widget(info_page)
    stack.add_widget(browser)
    stack.widget(0).not_nil!.to_unsafe.should eq(info_page.to_unsafe)
    stack.current_widget.not_nil!.to_unsafe.should eq(info_page.to_unsafe)
    stack.index_of(browser).should eq(1)
    stack.current_widget = browser
    application.process_events

    font_combo.horizontal_size_policy.should eq(Qt6::SizePolicy::Ignored)
    font_combo.vertical_size_policy.should eq(Qt6::SizePolicy::Fixed)
    font_combo.writing_system.should eq(Qt6::FontWritingSystem::Latin)
    font_combo.font_filters.includes?(Qt6::FontComboBoxFontFilter::ScalableFonts).should be_true
    font_combo.font_filters.includes?(Qt6::FontComboBoxFontFilter::ProportionalFonts).should be_true
    font_combo.size_hint.width.should be > 0
    font_combo.size_hint.height.should be > 0
    font_combo.current_font.family.should_not be_empty
    font_families.last?.should_not be_nil if font_combo.count > 1 && font_combo.current_index != original_font_index
    browser.open_external_links?.should be_false
    browser.default_style_sheet.should contain("#c00")
    browser.plain_text.should contain("Guide")
    browser.html.should contain("page:intro")
    browser.vertical_scroll_value.should eq(0)
    clicked_links.should be_empty
    stack.count.should eq(2)
    stack.current_index.should eq(1)
    stack.current_widget.not_nil!.to_unsafe.should eq(browser.to_unsafe)
    stack.remove_widget(info_page)
    stack.count.should eq(1)
    stack.index_of(info_page).should eq(-1)

    host.release
  end

  it "supports text editors, documents, and cursors" do
    application = app
    host = Qt6::Widget.new
    host.resize(360, 260)

    rich_document = Qt6::TextDocument.new(host)
    rich_document.default_style_sheet = "p { color: #333; }"
    rich_document.html = "<p>Alpha beta</p>"
    rich_document.title = "Layer Notes"
    rich_document.undo_redo_enabled = true
    rich_document.modified = false

    document_cursor = Qt6::TextCursor.new(rich_document)
    document_cursor.move_position(Qt6::TextCursorMoveOperation::End)
    document_cursor.insert_text("!")
    document_cursor.set_position(0)
    document_cursor.move_position(Qt6::TextCursorMoveOperation::Right, Qt6::TextCursorMoveMode::KeepAnchor, 5)

    text_edit = Qt6::TextEdit.new(parent: host)
    rich_text_changes = 0
    text_edit.on_text_changed do
      rich_text_changes += 1
    end
    text_edit.accept_rich_text = true
    text_edit.undo_redo_enabled = true
    text_edit.read_only = false
    text_edit.placeholder_text = "Describe the selected layer"
    text_edit.document = rich_document
    editor_cursor = text_edit.text_cursor
    editor_cursor.move_position(Qt6::TextCursorMoveOperation::End)
    text_edit.text_cursor = editor_cursor
    text_edit.append("Gamma")

    plain_edit = Qt6::PlainTextEdit.new(parent: host)
    plain_text_changes = 0
    plain_block_counts = [] of Int32
    plain_modification_changes = [] of Bool
    plain_cursor_moves = 0
    plain_edit.on_text_changed do
      plain_text_changes += 1
    end
    plain_edit.on_block_count_changed do |value|
      plain_block_counts << value
    end
    plain_edit.on_modification_changed do |value|
      plain_modification_changes << value
    end
    plain_edit.on_cursor_position_changed do
      plain_cursor_moves += 1
    end
    plain_edit.placeholder_text = "Notes"
    plain_edit.undo_redo_enabled = true
    plain_edit.read_only = false
    plain_edit.line_wrap_mode = Qt6::PlainTextEditLineWrapMode::WidgetWidth
    plain_edit.word_wrap_mode = Qt6::TextOptionWrapMode::WrapAnywhere
    plain_edit.tab_changes_focus = true
    plain_edit.overwrite_mode = true
    plain_edit.tab_stop_distance = 32.0
    plain_edit.background_visible = true
    plain_edit.center_on_scroll = true
    plain_edit.plain_text = "Terrain"
    plain_document = plain_edit.document
    plain_layout = plain_document.document_layout.not_nil!
    first_block = plain_document.first_block
    plain_cursor = plain_edit.text_cursor
    plain_cursor.move_position(Qt6::TextCursorMoveOperation::End)
    plain_cursor.insert_text("\nUnits")
    plain_edit.text_cursor = plain_cursor
    plain_edit.append_plain_text("Roads")
    plain_edit.insert_plain_text("\nSupply")
    document_cursor.remove_selected_text
    document_cursor.insert_text("Omega")
    document_cursor.delete_previous_char
    document_cursor.insert_text("a")
    document_cursor.clear_selection
    text_edit.insert_html("<b> Delta</b>")
    text_edit.insert_plain_text(" Epsilon")
    found_omega = rich_document.find("Omega")
    found_units = plain_document.find("Units")
    missing_text = rich_document.find("Missing")
    found_omega.replace_selected_text("Omega")
    text_edit.can_undo?.should be_true
    text_edit.undo
    text_edit.can_redo?.should be_true
    text_edit.redo
    plain_edit.can_undo?.should be_true
    plain_edit.undo
    plain_edit.can_redo?.should be_true
    plain_edit.redo
    text_edit.select_all
    selected_rich_text = text_edit.text_cursor
    selected_rich_text.has_selection?.should be_true
    selected_rich_text.release
    plain_edit.select_all
    selected_plain_text = plain_edit.text_cursor
    selected_plain_text.has_selection?.should be_true
    selected_plain_text.release
    application.process_events

    rich_document.default_style_sheet.should contain("#333")
    rich_document.title.should eq("Layer Notes")
    rich_document.undo_redo_enabled?.should be_true
    rich_document.plain_text.should contain("Omega beta!")
    rich_document.plain_text.should contain("Gamma")
    rich_document.empty?.should be_false
    rich_document.block_count.should be >= 1
    rich_document.character_count.should be > 0
    rich_document.modified?.should be_true

    document_cursor.position.should eq(5)
    document_cursor.has_selection?.should be_false
    document_cursor.selection_start.should eq(5)
    document_cursor.selection_end.should eq(5)
    document_cursor.selected_text.should eq("")
    document_cursor.at_end?.should be_false
    found_omega.null?.should be_false
    found_omega.selected_text.should eq("")
    found_units.null?.should be_false
    found_units.selected_text.should eq("Units")
    missing_text.null?.should be_true

    text_edit.accept_rich_text?.should be_true
    text_edit.undo_redo_enabled?.should be_true
    text_edit.read_only?.should be_false
    text_edit.placeholder_text.should eq("Describe the selected layer")
    text_edit.plain_text.should contain("Omega beta!")
    text_edit.plain_text.should contain("Gamma")
    text_edit.plain_text.should contain("Delta Epsilon")
    text_edit.can_undo?.should be_true
    text_edit.document.plain_text.should eq(text_edit.plain_text)
    rich_text_changes.should be >= 1

    plain_document.plain_text.should contain("Terrain")
    plain_document.plain_text.should contain("Units")
    plain_document.plain_text.should contain("Roads")
    plain_document.plain_text.should contain("Supply")
    plain_edit.line_wrap_mode.should eq(Qt6::PlainTextEditLineWrapMode::WidgetWidth)
    plain_edit.word_wrap_mode.should eq(Qt6::TextOptionWrapMode::WrapAnywhere)
    plain_edit.tab_changes_focus?.should be_true
    plain_edit.overwrite_mode?.should be_true
    plain_edit.tab_stop_distance.should eq(32.0)
    plain_edit.background_visible?.should be_true
    plain_edit.center_on_scroll?.should be_true
    plain_edit.block_count.should eq(4)
    plain_layout.document.to_unsafe.should eq(plain_document.to_unsafe)
    plain_layout.cursor_width = 3
    plain_layout.cursor_width.should eq(3)
    plain_layout.ensure_block_layout(first_block)
    plain_layout.request_update
    plain_layout.document_size.width.should be >= 0.0
    plain_layout.document_size.height.should be > 0.0
    plain_layout.page_count.should be >= 1
    first_block.valid?.should be_true
    first_block.block_number.should eq(0)
    first_block.position.should eq(0)
    first_block.length.should be > 0
    first_block.text.should eq("Terrain")
    second_block = plain_document.find_block_by_number(1)
    second_block.valid?.should be_true
    second_block.block_number.should eq(1)
    second_block.text.should eq("Units")
    plain_layout.block_bounding_rect(second_block).height.should be > 0.0
    found_plain_block = plain_document.find_block(plain_document.plain_text.index("Units").not_nil!)
    found_plain_block.text.should eq("Units")
    plain_edit.undo_redo_enabled?.should be_true
    plain_edit.read_only?.should be_false
    plain_edit.placeholder_text.should eq("Notes")
    plain_edit.plain_text.should contain("Units")
    plain_edit.plain_text.should contain("Roads")
    plain_edit.can_undo?.should be_true
    plain_edit.document.plain_text.should eq(plain_edit.plain_text)
    plain_text_changes.should be >= 1
    plain_block_counts.should contain(2)
    plain_block_counts.should contain(4)
    plain_modification_changes.should contain(true)
    plain_cursor_moves.should be >= 1

    missing_text.release
    found_units.release
    found_omega.release
    found_plain_block.release
    second_block.release
    first_block.release
    editor_cursor.release
    plain_cursor.release
    document_cursor.release
    host.release
  end

  it "provides QObject-derived signals and timer callbacks" do
    application = app
    timer = Qt6::QTimer.new
    destroyed = 0
    fired = 0

    timer.destroyed.connect do
      destroyed += 1
    end

    timer.on_timeout do
      fired += 1
    end

    timer.single_shot = true
    timer.start(0)

    10.times do
      application.process_events
      break if fired == 1
    end

    fired.should eq(1)
    timer.active?.should be_false
    timer.release
    destroyed.should eq(1)
  end

  it "supports standalone undo stacks with Crystal-backed commands" do
    app
    stack = Qt6::UndoStack.new
    layers = [] of String
    can_undo_values = [] of Bool
    can_redo_values = [] of Bool
    clean_values = [] of Bool
    index_values = [] of Int32
    undo_texts = [] of String
    redo_texts = [] of String

    stack.on_can_undo_changed { |value| can_undo_values << value }
    stack.on_can_redo_changed { |value| can_redo_values << value }
    stack.on_clean_changed { |value| clean_values << value }
    stack.on_index_changed { |value| index_values << value }
    stack.on_undo_text_changed { |value| undo_texts << value }
    stack.on_redo_text_changed { |value| redo_texts << value }

    command = Qt6::UndoCommand.new(
      "Add roads",
      redo: -> { layers << "roads" },
      undo: -> { layers.pop }
    )
    command.text.should eq("Add roads")

    stack.clean?.should be_true
    stack.push(command)
    layers.should eq(["roads"])
    command.destroyed?.should be_false
    stack.count.should eq(1)
    stack.index.should eq(1)
    stack.undo_text.should eq("Add roads")
    stack.redo_text.should eq("")
    stack.can_undo?.should be_true
    stack.can_redo?.should be_false

    undo_action = stack.create_undo_action(prefix: "Undo")
    redo_action = stack.create_redo_action(prefix: "Redo")

    undo_action.enabled?.should be_true
    undo_action.trigger
    layers.should eq([] of String)
    stack.can_redo?.should be_true
    stack.redo_text.should eq("Add roads")

    redo_action.enabled?.should be_true
    redo_action.trigger
    layers.should eq(["roads"])
    stack.can_undo?.should be_true

    stack.set_clean
    stack.clean?.should be_true
    stack.clean_index.should eq(stack.index)

    stack.begin_macro("Add forces")
    stack.push(Qt6::UndoCommand.new("Add infantry", redo: -> { layers << "infantry" }, undo: -> { layers.pop }))
    stack.push(Qt6::UndoCommand.new("Add armor", redo: -> { layers << "armor" }, undo: -> { layers.pop }))
    stack.end_macro

    layers.should eq(["roads", "infantry", "armor"])
    stack.count.should eq(2)
    stack.undo_text.should eq("Add forces")
    stack.clean?.should be_false

    stack.undo
    layers.should eq(["roads"])
    stack.clean?.should be_true

    stack.redo
    layers.should eq(["roads", "infantry", "armor"])
    stack.clean?.should be_false

    can_undo_values.includes?(true).should be_true
    can_redo_values.includes?(true).should be_true
    clean_values.includes?(false).should be_true
    index_values.includes?(1).should be_true
    undo_texts.includes?("Add roads").should be_true
    redo_texts.includes?("Add roads").should be_true

    stack.clear
    stack.count.should eq(0)
    command.destroyed?.should be_true
    stack.release
  end

  it "provides dock-owned toggle view actions" do
    application = app
    main = Qt6::MainWindow.new
    dock = Qt6::DockWidget.new("Layers", main)
    label = Qt6::Label.new("Layer list")
    title_bar = Qt6::Label.new("Dock Header")
    feature_changes = [] of Qt6::DockWidgetFeature
    top_level_changes = [] of Bool
    allowed_area_changes = [] of Qt6::DockArea
    visibility_changes = [] of Bool
    dock.on_features_changed { |value| feature_changes << value }
    dock.on_top_level_changed { |value| top_level_changes << value }
    dock.on_allowed_areas_changed { |value| allowed_area_changes << value }
    dock.on_visibility_changed { |value| visibility_changes << value }
    dock.widget = label
    dock.title_bar_widget.should be_nil
    dock.title_bar_widget = title_bar
    dock.features = Qt6::DockWidgetFeature::DockWidgetClosable |
                    Qt6::DockWidgetFeature::DockWidgetMovable |
                    Qt6::DockWidgetFeature::DockWidgetFloatable |
                    Qt6::DockWidgetFeature::DockWidgetVerticalTitleBar
    dock.allowed_areas = Qt6::DockArea::Left | Qt6::DockArea::Right
    main.add_dock_widget(dock, Qt6::DockArea::Left)
    toggle_action = dock.toggle_view_action

    main.show
    application.process_events

    dock.title.should eq("Layers")
    toggle_action.text.should eq("Layers")
    toggle_action.checkable?.should be_true
    dock.widget.should_not be_nil
    dock.widget.not_nil!.window_title.should eq(label.window_title)
    dock.title_bar_widget.not_nil!.to_unsafe.should eq(title_bar.to_unsafe)
    dock.visible?.should be_true
    toggle_action.checked?.should be_true
    dock.floating?.should be_false
    dock.features.should eq(
      Qt6::DockWidgetFeature::DockWidgetClosable |
      Qt6::DockWidgetFeature::DockWidgetMovable |
      Qt6::DockWidgetFeature::DockWidgetFloatable |
      Qt6::DockWidgetFeature::DockWidgetVerticalTitleBar
    )
    dock.allowed_areas.should eq(Qt6::DockArea::Left | Qt6::DockArea::Right)
    dock.area_allowed?(Qt6::DockArea::Left).should be_true
    dock.area_allowed?(Qt6::DockArea::Right).should be_true
    dock.area_allowed?(Qt6::DockArea::Bottom).should be_false
    feature_changes.last.should eq(dock.features)
    allowed_area_changes.last.should eq(dock.allowed_areas)

    dock.floating = true
    application.process_events
    dock.floating?.should be_true
    top_level_changes.last.should be_true

    dock.floating = false
    application.process_events
    dock.floating?.should be_false
    top_level_changes.last.should be_false

    toggle_action.trigger
    application.process_events

    dock.visible?.should be_false
    toggle_action.checked?.should be_false
    visibility_changes.last.should be_false

    dock.visible = true
    application.process_events

    dock.visible?.should be_true
    toggle_action.checked?.should be_true
    visibility_changes.last.should be_true
    dock.title_bar_widget = nil
    dock.title_bar_widget.should be_nil

    toggle_action.release
    main.release
  end

  it "manages status-bar widgets and size grip state" do
    application = app
    main = Qt6::MainWindow.new
    status_bar = main.status_bar
    transient = Qt6::Label.new("Selection: 0")
    permanent = Qt6::Label.new("Ready")

    status_bar.add_widget(transient)
    status_bar.add_permanent_widget(permanent)
    status_bar.show_message("Working")

    main.show
    application.process_events

    transient.visible?.should be_true
    permanent.visible?.should be_true
    status_bar.current_message.should eq("Working")
    status_bar.size_grip_enabled?.should be_true

    status_bar.size_grip_enabled = false
    status_bar.size_grip_enabled?.should be_false

    status_bar.remove_widget(transient)
    application.process_events
    transient.visible?.should be_false

    permanent.text.should eq("Ready")

    main.release
  end

  it "retargets shared undo and redo actions with undo groups" do
    app
    group = Qt6::UndoGroup.new
    stack_a = Qt6::UndoStack.new
    stack_b = Qt6::UndoStack.new
    document_a = [] of String
    document_b = [] of String
    active_changes = [] of Qt6::UndoStack?
    undo_texts = [] of String
    redo_texts = [] of String

    group.on_active_stack_changed { |stack| active_changes << stack }
    group.on_undo_text_changed { |text| undo_texts << text }
    group.on_redo_text_changed { |text| redo_texts << text }

    group << stack_a
    group.add_stack(stack_b)
    group.stacks.size.should eq(2)

    undo_action = group.create_undo_action(prefix: "Undo")
    redo_action = group.create_redo_action(prefix: "Redo")

    stack_a.push(Qt6::UndoCommand.new("Add roads", redo: -> { document_a << "roads" }, undo: -> { document_a.pop }))
    stack_b.push(Qt6::UndoCommand.new("Add rivers", redo: -> { document_b << "rivers" }, undo: -> { document_b.pop }))

    group.active_stack = stack_a
    group.active_stack.try(&.same?(stack_a)).should be_true
    group.undo_text.should eq("Add roads")
    undo_action.enabled?.should be_true
    undo_action.trigger
    document_a.should eq([] of String)
    group.can_redo?.should be_true
    group.redo_text.should eq("Add roads")

    group.active_stack = stack_b
    group.active_stack.try(&.same?(stack_b)).should be_true
    group.undo_text.should eq("Add rivers")
    undo_action.enabled?.should be_true
    undo_action.trigger
    document_b.should eq([] of String)
    redo_action.enabled?.should be_true
    redo_action.trigger
    document_b.should eq(["rivers"])

    group.undo
    document_b.should eq([] of String)
    group.redo
    document_b.should eq(["rivers"])

    active_changes.any? { |stack| stack.try(&.same?(stack_a)) || false }.should be_true
    active_changes.any? { |stack| stack.try(&.same?(stack_b)) || false }.should be_true
    undo_texts.includes?("Add roads").should be_true
    redo_texts.includes?("Add roads").should be_true

    group.remove_stack(stack_a)
    group.stacks.should eq([stack_b])

    stack_a.release
    stack_b.release
    group.release
  end

  it "keeps parent-owned QObject wrappers alive until Qt destroys them" do
    app
    content_destroyed = 0
    layout_destroyed = 0
    scroll_area = Qt6::ScrollArea.new

    begin
      content = Qt6::Widget.new
      layout = Qt6::VBoxLayout.new(content)
      content.destroyed.connect { content_destroyed += 1 }
      layout.destroyed.connect { layout_destroyed += 1 }
      scroll_area.widget = content
    end

    GC.collect
    scroll_area.release

    content_destroyed.should eq(1)
    layout_destroyed.should eq(1)
  end

  it "supports QRhiWidget configuration and change signals" do
    application = app
    widget = Qt6::RhiWidget.new
    sample_counts = [] of Int32
    color_formats = [] of Qt6::RhiWidgetTextureFormat
    buffer_sizes = [] of Qt6::Size
    mirrored = [] of Bool

    widget.on_sample_count_changed do |value|
      sample_counts << value
    end
    widget.on_color_buffer_format_changed do |value|
      color_formats << value
    end
    widget.on_fixed_color_buffer_size_changed do |value|
      buffer_sizes << value
    end
    widget.on_mirror_vertically_changed do |value|
      mirrored << value
    end

    widget.set_api(Qt6::RhiWidgetApi::Null)
    widget.set_debug_layer_enabled(true)
    widget.set_sample_count(4)
    widget.set_color_buffer_format(Qt6::RhiWidgetTextureFormat::RGBA16F)
    widget.set_fixed_color_buffer_size(48, 24)
    widget.set_mirror_vertically(true)
    widget.resize(64, 32)
    widget.show
    application.process_events

    widget.api.should eq(Qt6::RhiWidgetApi::Null)
    widget.debug_layer_enabled?.should be_true
    widget.sample_count.should eq(4)
    widget.color_buffer_format.should eq(Qt6::RhiWidgetTextureFormat::RGBA16F)
    widget.fixed_color_buffer_size.should eq(Qt6::Size.new(48, 24))
    widget.mirror_vertically?.should be_true
    sample_counts.last.should eq(4)
    color_formats.last.should eq(Qt6::RhiWidgetTextureFormat::RGBA16F)
    buffer_sizes.last.should eq(Qt6::Size.new(48, 24))
    mirrored.last.should be_true

    framebuffer = widget.grab_framebuffer
    framebuffer.should be_a(Qt6::QImage)

    widget.release
  end

  it "supports nested event loops driven by timers" do
    app
    exit_loop = Qt6::QEventLoop.new
    exit_timer = Qt6::QTimer.new(exit_loop)
    exit_codes = [] of Int32

    exit_timer.single_shot = true
    exit_timer.on_timeout do
      exit_loop.running?.should be_true
      exit_codes << exit_loop.exit(23)
    end
    exit_timer.start(0)

    exit_loop.running?.should be_false
    exit_loop.run.should eq(23)
    exit_loop.running?.should be_false
    exit_codes.should eq([23])

    quit_loop = Qt6::QEventLoop.new
    quit_timer = Qt6::QTimer.new(quit_loop)
    quit_timer.single_shot = true
    quit_timer.on_timeout do
      quit_loop.running?.should be_true
      quit_loop.quit
    end
    quit_timer.start(0)

    quit_loop.run.should eq(0)
    quit_loop.running?.should be_false
  end

  it "quits the application through the top-level window close path" do
    application = app
    window = Qt6::MainWindow.new

    window.show
    application.process_events
    window.visible?.should be_true

    application.invoke_later do
      application.quit
    end

    application.run.should eq(0)
    application.process_events
    window.visible?.should be_false

    window.release
  end

  it "supports richer date edit sections, ranges, and popup calendar wiring" do
    application = app
    date = Qt6::QDate.new(2026, 4, 15)
    min_date = Qt6::QDate.new(2026, 4, 1)
    max_date = Qt6::QDate.new(2026, 4, 30)
    min_time = Qt6::QTime.new(8, 0, 0)
    max_time = Qt6::QTime.new(18, 30, 0)
    min_date_time = Qt6::QDateTime.new(2026, 4, 1, 8, 0, 0)
    max_date_time = Qt6::QDateTime.new(2026, 4, 30, 18, 30, 0)

    date_edit = Qt6::DateEdit.new(date)
    date_time_edit = Qt6::DateTimeEdit.new
    popup_calendar = Qt6::CalendarWidget.new

    date_edit.display_format = "dd/MM/yyyy"
    date_edit.calendar_popup = true
    date_edit.set_date_range(min_date, max_date)
    date_edit.calendar_widget = popup_calendar
    date_edit.current_section = Qt6::DateTimeEditSection::MonthSection
    date_edit.current_section_index = 2
    date_edit.selected_section = Qt6::DateTimeEditSection::YearSection

    date_time_edit.display_format = "yyyy-MM-dd HH:mm:ss"
    date_time_edit.set_date_time_range(min_date_time, max_date_time)
    date_time_edit.set_time_range(min_time, max_time)
    date_time_edit.minimum_date = min_date
    date_time_edit.maximum_date = max_date

    application.process_events

    date_edit.date.to_string.should eq(date.to_string)
    date_edit.minimum_date.to_string.should eq(min_date.to_string)
    date_edit.maximum_date.to_string.should eq(max_date.to_string)
    date_edit.displayed_sections.should eq(
      Qt6::DateTimeEditSection::DaySection |
      Qt6::DateTimeEditSection::MonthSection |
      Qt6::DateTimeEditSection::YearSection
    )
    date_edit.section_count.should eq(3)
    date_edit.section_at(0).should eq(Qt6::DateTimeEditSection::DaySection)
    date_edit.section_at(1).should eq(Qt6::DateTimeEditSection::MonthSection)
    date_edit.section_at(2).should eq(Qt6::DateTimeEditSection::YearSection)
    date_edit.current_section.should eq(Qt6::DateTimeEditSection::YearSection)
    date_edit.current_section_index.should eq(2)
    date_edit.section_text(Qt6::DateTimeEditSection::DaySection).should eq("15")
    date_edit.section_text(Qt6::DateTimeEditSection::MonthSection).should eq("04")
    date_edit.section_text(Qt6::DateTimeEditSection::YearSection).should eq("2026")
    date_edit.calendar_widget.not_nil!.to_unsafe.should eq(popup_calendar.to_unsafe)

    date_time_edit.minimum_date_time.to_string.should eq(min_date_time.to_string)
    date_time_edit.maximum_date_time.to_string.should eq(max_date_time.to_string)
    date_time_edit.minimum_time.to_string.should eq(min_time.to_string)
    date_time_edit.maximum_time.to_string.should eq(max_time.to_string)
    date_time_edit.minimum_date.to_string.should eq(min_date.to_string)
    date_time_edit.maximum_date.to_string.should eq(max_date.to_string)

    popup_calendar.release
    date_time_edit.release
    date_edit.release
  end
end
