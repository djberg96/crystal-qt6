require "./spec_helper"

describe Qt6 do
  it "supports common control widgets and date-based editors" do
    application = app
    progress_bar = Qt6::ProgressBar.new
    scroll_bar = Qt6::ScrollBar.new(Qt6::Orientation::Horizontal)
    dial = Qt6::Dial.new
    date_time_edit = Qt6::DateTimeEdit.new
    date_edit = Qt6::DateEdit.new
    time_edit = Qt6::TimeEdit.new
    calendar = Qt6::CalendarWidget.new
    lcd = Qt6::LcdNumber.new
    command_link = Qt6::CommandLinkButton.new("Export", "Save the current map")
    tab_bar = Qt6::TabBar.new
    stacked_host = Qt6::Widget.new
    stacked_layout = Qt6::StackedLayout.new(stacked_host)
    first_page = Qt6::Label.new("General")
    second_page = Qt6::Label.new("Preview")

    scroll_values = [] of Int32
    dial_values = [] of Int32
    date_time_values = [] of String
    date_values = [] of String
    time_values = [] of String
    calendar_values = [] of String
    tab_indices = [] of Int32
    stacked_indices = [] of Int32

    scroll_bar.on_value_changed do |value|
      scroll_values << value
    end
    dial.on_value_changed do |value|
      dial_values << value
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
    tab_bar.on_current_index_changed do |value|
      tab_indices << value
    end
    stacked_layout.on_current_index_changed do |value|
      stacked_indices << value
    end

    progress_bar.set_range(0, 12)
    progress_bar.value = 7
    progress_bar.text_visible = false
    progress_bar.inverted_appearance = true
    progress_bar.format = "%v/%m"
    progress_bar.alignment = Qt6::AlignmentFlag::Center
    progress_bar.orientation = Qt6::Orientation::Vertical

    scroll_bar.set_range(5, 20)
    scroll_bar.single_step = 2
    scroll_bar.page_step = 5
    scroll_bar.value = 11

    dial.set_range(0, 360)
    dial.wrapping = true
    dial.notches_visible = true
    dial.value = 90

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
    calendar.grid_visible = true
    calendar.selected_date = date

    lcd.digit_count = 6
    lcd.mode = Qt6::LcdNumberMode::Hex
    lcd.segment_style = Qt6::LcdNumberSegmentStyle::Flat
    lcd.small_decimal_point = true
    lcd.display(255)

    command_link.description = "Save the current map as an image"

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
    progress_bar.format.should eq("%v/%m")
    progress_bar.alignment.should eq(Qt6::AlignmentFlag::Center)
    progress_bar.orientation.should eq(Qt6::Orientation::Vertical)
    progress_bar.reset.value.should eq(-1)

    scroll_bar.orientation.should eq(Qt6::Orientation::Horizontal)
    scroll_bar.minimum.should eq(5)
    scroll_bar.maximum.should eq(20)
    scroll_bar.single_step.should eq(2)
    scroll_bar.page_step.should eq(5)
    scroll_bar.value.should eq(11)
    scroll_values.last.should eq(11)

    dial.minimum.should eq(0)
    dial.maximum.should eq(360)
    dial.wrapping?.should be_true
    dial.notches_visible?.should be_true
    dial.value.should eq(90)
    dial_values.last.should eq(90)

    date_time_edit.display_format.should eq("yyyy/MM/dd HH:mm:ss")
    date_time_edit.calendar_popup?.should be_true
    date_time_edit.date_time.to_string.should eq(date_time.to_string)
    date_time_values.last.should eq(date_time.to_string)

    date_edit.date.to_string.should eq(date.to_string)
    date_values.last.should eq(date.to_string)

    time_edit.time.to_string.should eq(time.to_string)
    time_values.last.should eq(time.to_string)

    calendar.minimum_date.to_string.should eq("2026-01-01")
    calendar.maximum_date.to_string.should eq("2026-12-31")
    calendar.grid_visible?.should be_true
    calendar.selected_date.to_string.should eq(date.to_string)
    calendar_values.last.should eq(date.to_string)

    lcd.digit_count.should eq(6)
    lcd.mode.should eq(Qt6::LcdNumberMode::Hex)
    lcd.segment_style.should eq(Qt6::LcdNumberSegmentStyle::Flat)
    lcd.small_decimal_point?.should be_true
    lcd.int_value.should eq(255)
    lcd.overflow?(16_777_216).should be_true
    lcd.overflow?(255).should be_false

    command_link.text.should eq("Export")
    command_link.description.should eq("Save the current map as an image")

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
    select_button.on_toggled do |value|
      toggled_states << value
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

    separator = Qt6::Frame.new
    separator.frame_shape = Qt6::FrameShape::HLine
    separator.frame_shadow = Qt6::FrameShadow::Sunken
    separator.line_width = 2
    separator.mid_line_width = 1

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
    button_box.on_accepted { accepted += 1 }
    button_box.on_rejected { rejected += 1 }

    ok_button = button_box.button(Qt6::DialogButtonBoxStandardButton::Ok).not_nil!
    cancel_button = button_box.button(Qt6::DialogButtonBoxStandardButton::Cancel).not_nil!
    help_button = button_box.button(Qt6::DialogButtonBoxStandardButton::Help).not_nil!
    ok_button.text = "Export"
    ok_button.click
    cancel_button.click
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
    mode_group.button(5).not_nil!.text.should eq("Select")
    mode_group.button(5).not_nil!.checked?.should be_true
    toggled_states.last.should be_true
    separator.frame_shape.should eq(Qt6::FrameShape::HLine)
    separator.frame_shadow.should eq(Qt6::FrameShadow::Sunken)
    separator.line_width.should eq(2)
    separator.mid_line_width.should eq(1)
    separator.frame_width.should be >= 1
    scroll_area.frame_shape.should eq(Qt6::FrameShape::NoFrame)
    scroll_area.vertical_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOff)
    scroll_area.horizontal_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOn)
    scroll_area.widget_resizable?.should be_true
    focus_frame.widget.should be_nil
    focus_frame.widget = select_button
    focus_frame.widget.not_nil!.to_unsafe.should eq(select_button.to_unsafe)
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
      Qt6::DialogButtonBoxStandardButton::Help
    )
    ok_button.text.should eq("Export")
    help_button.text.should_not be_empty
    accepted.should eq(1)
    rejected.should eq(1)
    mode_group.remove(place_button)
    mode_group.id(place_button).should eq(-1)

    dialog.release
  end

  it "supports shortcut, rubber-band, and error helper widgets" do
    application = app
    host = Qt6::Widget.new
    host.resize(240, 180)

    sequence_changes = [] of String
    key_sequence_edit = Qt6::KeySequenceEdit.new(Qt6::KeySequence.new("Ctrl+Shift+P"), host)
    key_sequence_edit.on_key_sequence_changed do |value|
      sequence_changes << value.to_s
    end
    key_sequence_edit.clear_button_enabled = true
    key_sequence_edit.key_sequence = "Ctrl+Alt+L"
    application.process_events

    rubber_band = Qt6::RubberBand.new(Qt6::RubberBandShape::Rectangle, host)
    rubber_band.set_geometry(Qt6::Rect.new(10, 12, 64, 48))
    rubber_band.show

    error_message = Qt6::ErrorMessage.new(host)
    error_message.show_message("Network timeout", "network")

    host.show
    application.process_events

    key_sequence_edit.key_sequence.to_s.should_not be_empty
    sequence_changes.last.should eq(key_sequence_edit.key_sequence.to_s)
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

  it "supports WargameMapTool-style font, stack, and browser widgets" do
    application = app
    host = Qt6::Widget.new
    host.resize(320, 220)

    font_combo = Qt6::FontComboBox.new(host)
    font_combo.set_size_policy(Qt6::SizePolicy::Ignored, Qt6::SizePolicy::Fixed)

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
    plain_edit.on_text_changed do
      plain_text_changes += 1
    end
    plain_edit.placeholder_text = "Notes"
    plain_edit.undo_redo_enabled = true
    plain_edit.read_only = false
    plain_edit.plain_text = "Terrain"
    plain_document = plain_edit.document
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
    plain_edit.undo_redo_enabled?.should be_true
    plain_edit.read_only?.should be_false
    plain_edit.placeholder_text.should eq("Notes")
    plain_edit.plain_text.should contain("Units")
    plain_edit.plain_text.should contain("Roads")
    plain_edit.can_undo?.should be_true
    plain_edit.document.plain_text.should eq(plain_edit.plain_text)
    plain_text_changes.should be >= 1

    missing_text.release
    found_units.release
    found_omega.release
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
    dock.widget = label
    dock.title_bar_widget.should be_nil
    dock.title_bar_widget = title_bar
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

    dock.floating = true
    application.process_events
    dock.floating?.should be_true

    dock.floating = false
    application.process_events
    dock.floating?.should be_false

    toggle_action.trigger
    application.process_events

    dock.visible?.should be_false
    toggle_action.checked?.should be_false

    dock.visible = true
    application.process_events

    dock.visible?.should be_true
    toggle_action.checked?.should be_true
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

end
