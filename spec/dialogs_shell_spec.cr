require "./spec_helper"

describe Qt6 do
  it "provides convenience helpers for common dialogs" do
    app
    window = Qt6::MainWindow.new

    message_result = Qt6::MessageBox.information(window, title: "About", text: "Helper test") do |dialog|
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    selected_color = Qt6::ColorDialog.get_color(window, current_color: Qt6::Color.new(8, 16, 32, 64), title: "Accent", show_alpha_channel: true) do |dialog|
      dialog.native_dialog = false
      dialog.current_color = Qt6::Color.new(32, 64, 96, 128)
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    selected_font = Qt6::FontDialog.get_font(window, Qt6::QFont.new("Courier", 11), title: "Typeface") do |dialog|
      dialog.native_dialog = false
      dialog.current_font = Qt6::QFont.new("Helvetica", 13, true, true)
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    text_value = Qt6::InputDialog.get_text(window, title: "Rename", label: "Layer", value: "Terrain") do |dialog|
      dialog.text_value = "Roads"
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    int_value = Qt6::InputDialog.get_int(window, title: "Count", label: "Columns", value: 3, minimum: 1, maximum: 12) do |dialog|
      dialog.int_value = 7
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    double_value = Qt6::InputDialog.get_double(window, title: "Scale", label: "Zoom", value: 1.0, minimum: 0.5, maximum: 4.0) do |dialog|
      dialog.double_value = 1.25
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    item_value = Qt6::InputDialog.get_item(window, title: "Layer Type", label: "Kind", items: ["Terrain", "Units", "Roads"], current: 1, editable: false) do |dialog|
      dialog.combo_box_items.should eq(["Terrain", "Units", "Roads"])
      dialog.combo_box_editable?.should be_false
      dialog.text_value = "Roads"
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    message_result.should eq(Qt6::MessageBoxButton::Ok)
    selected_color.should eq(Qt6::Color.new(32, 64, 96, 128))
    selected_font.not_nil!.point_size.should eq(13)
    text_value.should eq("Roads")
    int_value.should eq(7)
    double_value.should eq(1.25)
    item_value.should eq("Roads")
    selected_font.try(&.release)
    window.release
  end

  it "configures color, font, and input dialogs" do
    app
    window = Qt6::MainWindow.new
    color_dialog = Qt6::ColorDialog.new(window)
    font_dialog = Qt6::FontDialog.new(window, Qt6::QFont.new("Courier", 10))
    input_dialog = Qt6::InputDialog.new(window)
    current_font_changes = [] of Qt6::QFont
    selected_fonts = [] of Qt6::QFont

    font_dialog.on_current_font_changed do |font|
      current_font_changes << font
    end

    font_dialog.on_font_selected do |font|
      selected_fonts << font
    end

    color_dialog.window_title = "Pick Accent Color"
    color_dialog.native_dialog = false
    color_dialog.show_alpha_channel = true
    color_dialog.current_color = Qt6::Color.new(32, 96, 192, 180)

    font_dialog.window_title = "Pick Label Font"
    font_dialog.options = Qt6::FontDialogOption::ScalableFonts | Qt6::FontDialogOption::MonospacedFonts
    font_dialog.native_dialog = false
    font_dialog.set_option(Qt6::FontDialogOption::NoButtons)
    font_dialog.clear_option(Qt6::FontDialogOption::NoButtons)
    font_dialog.current_font = Qt6::QFont.new("Helvetica", 14, true, false)

    input_dialog.window_title = "Layer Details"
    input_dialog.input_mode = Qt6::InputDialogInputMode::Text
    input_dialog.label_text = "Layer name"
    input_dialog.text_value = "Terrain"
    input_dialog.input_mode = Qt6::InputDialogInputMode::Int
    input_dialog.int_range = 1..12
    input_dialog.int_value = 4
    input_dialog.input_mode = Qt6::InputDialogInputMode::Double
    input_dialog.double_range = 0.5..4.0
    input_dialog.double_value = 1.5
    input_dialog.input_mode = Qt6::InputDialogInputMode::Text
    input_dialog.combo_box_items = ["Terrain", "Units", "Roads"]
    input_dialog.combo_box_editable = false
    input_dialog.text_value = "Units"

    color_dialog.window_title.should eq("Pick Accent Color")
    color_dialog.native_dialog?.should be_false
    color_dialog.current_color.should eq(Qt6::Color.new(32, 96, 192, 180))
    color_dialog.show_alpha_channel?.should be_true

    font_dialog.window_title.should eq("Pick Label Font")
    font_dialog.native_dialog?.should be_false
    font_dialog.option?(Qt6::FontDialogOption::ScalableFonts).should be_true
    font_dialog.option?(Qt6::FontDialogOption::MonospacedFonts).should be_true
    font_dialog.option?(Qt6::FontDialogOption::NoButtons).should be_false
    font_dialog.current_font.point_size.should eq(14)
    font_dialog.accept
    font_dialog.selected_font.point_size.should eq(14)
    current_font_changes.empty?.should be_false
    selected_fonts.empty?.should be_false

    input_dialog.window_title.should eq("Layer Details")
    input_dialog.label_text.should eq("Layer name")
    input_dialog.text_value.should eq("Units")
    input_dialog.int_minimum.should eq(1)
    input_dialog.int_maximum.should eq(12)
    input_dialog.int_value.should eq(4)
    input_dialog.double_minimum.should eq(0.5)
    input_dialog.double_maximum.should eq(4.0)
    input_dialog.double_value.should eq(1.5)
    input_dialog.combo_box_items.should eq(["Terrain", "Units", "Roads"])
    input_dialog.combo_box_editable?.should be_false
    window.release
  end

  it "configures standard message and file dialogs" do
    app
    window = Qt6::MainWindow.new
    message_box = Qt6::MessageBox.new(window)
    file_dialog = Qt6::FileDialog.new(window, "/tmp", "Maps (*.map *.json)")

    message_box.window_title = "Unsaved Changes"
    message_box.icon = Qt6::MessageBoxIcon::Warning
    message_box.text = "This map has unsaved changes."
    message_box.informative_text = "Save before closing?"
    message_box.standard_buttons = Qt6::MessageBoxButton::Save | Qt6::MessageBoxButton::Discard | Qt6::MessageBoxButton::Cancel
    message_box.accept

    file_dialog.accept_mode = Qt6::FileDialogAcceptMode::Save
    file_dialog.file_mode = Qt6::FileDialogFileMode::AnyFile
    file_dialog.directory = "/tmp"
    file_dialog.name_filter = "Maps (*.map *.json)"
    file_dialog.select_file("/tmp/example.map")

    message_box.window_title.should eq("Unsaved Changes")
    message_box.icon.should eq(Qt6::MessageBoxIcon::Warning)
    message_box.text.should eq("This map has unsaved changes.")
    message_box.informative_text.should eq("Save before closing?")
    message_box.standard_buttons.includes?(Qt6::MessageBoxButton::Save).should be_true
    message_box.standard_buttons.includes?(Qt6::MessageBoxButton::Discard).should be_true
    message_box.standard_buttons.includes?(Qt6::MessageBoxButton::Cancel).should be_true
    message_box.result.should eq(Qt6::DialogCode::Accepted)

    file_dialog.accept_mode.should eq(Qt6::FileDialogAcceptMode::Save)
    file_dialog.file_mode.should eq(Qt6::FileDialogFileMode::AnyFile)
    file_dialog.directory.should eq("/tmp")
    file_dialog.name_filter.should eq("Maps (*.map *.json)")
    window.release
  end

  it "supports progress dialogs and splash screens" do
    application = app
    window = Qt6::MainWindow.new
    progress = Qt6::ProgressDialog.new(window, label_text: "Loading tiles", cancel_button_text: "Stop", minimum: 0, maximum: 10)

    progress.label_text.should eq("Loading tiles")
    progress.minimum.should eq(0)
    progress.maximum.should eq(10)
    progress.minimum_duration = 0
    progress.minimum_duration.should eq(0)
    progress.auto_close = false
    progress.auto_reset = false
    progress.auto_close?.should be_false
    progress.auto_reset?.should be_false
    progress.range = 1..5
    progress.minimum.should eq(1)
    progress.maximum.should eq(5)
    progress.value = 2
    progress.value.should eq(2)
    progress.was_canceled?.should be_false

    cancel_timer = Qt6::QTimer.new(progress)
    cancel_timer.single_shot = true
    cancel_timer.on_timeout do
      progress.cancel
    end
    progress.show
    cancel_timer.start(0)
    10.times do
      application.process_events
      break if progress.was_canceled?
    end

    progress.was_canceled?.should be_true
    progress.reset

    splash_image = Qt6::QImage.new(24, 16)
    splash_image.fill(Qt6::Color.new(250, 240, 220))
    splash_image.set_pixel_color(2, 2, Qt6::Color.new(30, 90, 180))
    splash = Qt6::SplashScreen.new(splash_image.to_pixmap)
    replacement_pixmap = Qt6::QPixmap.new(12, 12)
    replacement_pixmap.fill(Qt6::Color.new(18, 36, 72))

    splash.pixmap.null?.should be_false
    splash.show
    splash.show_message("Booting", Qt6::AlignmentFlag::Center, Qt6::Color.new(12, 34, 56))
    application.process_events
    splash.message.should eq("Booting")
    splash.pixmap = replacement_pixmap
    splash.pixmap.size.should eq(Qt6::Size.new(12, 12))
    window.show
    application.process_events
    splash.finish(window)
    application.process_events
    splash.visible?.should be_false
    splash.clear_message
    splash.message.should eq("")

    splash.release
    window.release
  end

  it "supports action shortcuts and exclusive action groups" do
    app
    window = Qt6::MainWindow.new
    menu = window.menu_bar.add_menu("View")
    group = Qt6::ActionGroup.new(window)
    map_action = Qt6::Action.new("Map", window)
    units_action = Qt6::Action.new("Units", window)

    map_action.shortcut = Qt6::KeySequence.new("Ctrl+1")
    units_action.shortcut = "Ctrl+2"
    map_action.checkable = true
    units_action.checkable = true
    group.exclusive = true
    group << map_action
    group << units_action
    menu << map_action
    menu << units_action

    map_action.checked = true
    units_action.checked = true

    map_action.shortcut.to_s.should eq("Ctrl+1")
    units_action.shortcut.to_s.should eq("Ctrl+2")
    map_action.checkable?.should be_true
    units_action.checkable?.should be_true
    group.exclusive?.should be_true
    map_action.checked?.should be_false
    units_action.checked?.should be_true
    window.release
  end

  it "builds a reduced shell with menus, toolbars, docks, dialogs, and controls" do
    application = app
    main = Qt6::MainWindow.new
    triggered = 0
    accepted = 0
    rejected = 0
    toggled = [] of Bool
    indices = [] of Int32

    main.window_title = "Editor Shell"
    main.resize(960, 640)
    main.central_widget = Qt6::Label.new("Canvas")

    file_menu = main.menu_bar.add_menu("File")
    recent_menu = file_menu.add_menu("Recent")
    open_action = Qt6::Action.new("Open", main)
    open_action.on_triggered do
      triggered += 1
    end
    file_menu << open_action
    file_menu.add_separator

    tool_bar = Qt6::ToolBar.new("Primary", main)
    main.add_tool_bar(tool_bar)
    tool_bar << open_action

    dock = Qt6::DockWidget.new("Inspector", main)
    inspector = Qt6::Widget.new
    line_edit = Qt6::LineEdit.new("Hexes")
    check_box = Qt6::CheckBox.new("Snap")
    combo_box = Qt6::ComboBox.new
    state_changes = [] of Qt6::CheckState
    check_clicks = 0
    check_box.on_toggled do |value|
      toggled << value
    end
    check_box.on_state_changed do |value|
      state_changes << value
    end
    check_box.on_clicked do
      check_clicks += 1
    end
    combo_box.on_current_index_changed do |index|
      indices << index
    end
    combo_box << "Units" << "Terrain"
    combo_box.insert_item(1, "Roads")

    inspector.vbox do |column|
      column << line_edit
      column << check_box
      column << combo_box
    end

    dock.widget = inspector
    main.add_dock_widget(dock, Qt6::DockArea::Left)
    main.status_bar.show_message("Ready")

    dialog = Qt6::Dialog.new(main)
    dialog.on_accepted do
      accepted += 1
    end
    dialog.on_rejected do
      rejected += 1
    end

    dialog.accept
    check_box.checked = true
    check_box.tristate = true
    check_box.check_state = Qt6::CheckState::PartiallyChecked
    check_box.click
    combo_box.editable = true
    combo_box.item_text(1).should eq("Roads")
    combo_box.find_text("Roads").should eq(1)
    combo_box.remove_item(0)
    combo_box.current_text = "Terrain"
    combo_box.current_index = combo_box.find_text("Terrain")
    open_action.trigger
    application.process_events

    recent_menu.title.should eq("Recent")
    main.status_bar.current_message.should eq("Ready")
    line_edit.text = "Terrain"
    line_edit.text.should eq("Terrain")
    check_box.text.should eq("Snap")
    check_box.checkable?.should be_true
    check_box.tristate?.should be_true
    check_box.checked?.should be_true
    check_box.check_state.should eq(Qt6::CheckState::Checked)
    combo_box.count.should eq(2)
    combo_box.editable?.should be_true
    combo_box.current_text.should eq("Terrain")
    toggled.last.should be_true
    state_changes.should contain(Qt6::CheckState::PartiallyChecked)
    state_changes.last.should eq(Qt6::CheckState::Checked)
    check_clicks.should eq(1)
    indices.last.should eq(1)
    triggered.should eq(1)
    dialog.result.should eq(Qt6::DialogCode::Accepted)
    accepted.should eq(1)
    rejected.should eq(0)
    combo_box.clear
    combo_box.count.should eq(0)
    main.release
  end

  it "supports abstract spin boxes and general geometry value types" do
    application = app
    spin_box = Qt6::SpinBox.new
    double_spin_box = Qt6::DoubleSpinBox.new
    date_time_edit = Qt6::DateTimeEdit.new
    image = Qt6::QImage.new(32, 18)
    pixmap = Qt6::QPixmap.new(12, 7)
    editing_finished = 0
    return_pressed = 0

    spin_box.button_symbols = Qt6::AbstractSpinBoxButtonSymbol::NoButtons
    spin_box.read_only = true
    spin_box.wrapping = true
    spin_box.accelerated = true
    spin_box.correction_mode = Qt6::AbstractSpinBoxCorrectionMode::CorrectToNearestValue
    spin_box.keyboard_tracking = false
    spin_box.alignment = Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter
    spin_box.frame = false
    spin_box.group_separator_shown = true
    spin_box.prefix = "Zoom "
    spin_box.suffix = "%"
    spin_box.special_value_text = "Auto"
    spin_box.set_range(0, 100)
    spin_box.value = 25
    double_spin_box.button_symbols = Qt6::AbstractSpinBoxButtonSymbol::PlusMinus
    double_spin_box.read_only = false
    double_spin_box.wrapping = false
    double_spin_box.accelerated = true
    double_spin_box.prefix = "~"
    double_spin_box.suffix = "x"
    double_spin_box.special_value_text = "Default"
    double_spin_box.decimals = 3
    double_spin_box.set_range(0.0, 10.0)
    double_spin_box.value = 1.25
    date_time_edit.keyboard_tracking = false
    date_time_edit.read_only = false
    date_time_edit.display_format = "yyyy/MM/dd HH:mm:ss"
    date_time_edit.date_time = Qt6::QDateTime.new(2026, 4, 14, 9, 30, 15)

    spin_box.on_editing_finished { editing_finished += 1 }
    spin_box.on_return_pressed { return_pressed += 1 }
    Qt6::LibQt6.qt6cr_abstract_spin_box_emit_editing_finished(spin_box.to_unsafe)
    Qt6::LibQt6.qt6cr_abstract_spin_box_emit_return_pressed(spin_box.to_unsafe)
    spin_box.select_all
    spin_box.step_up
    spin_box.step_down
    spin_box.clear
    spin_box.value = 25
    spin_box.interpret_text

    rect = Qt6::Rect.new(1, 2, 30, 40)
    rect_f = rect.to_rect_f
    line_f = Qt6::LineF.new(1.0, 5.0, 5.0, 2.0)
    native_line_f = line_f.to_native
    translated_line_f = line_f.translated(2.0, -1.0)
    size = Qt6::Size.new(14, 9)
    size_f = size.to_size_f
    page_size = Qt6::PageSize.new(size_f)

    spin_box.should be_a(Qt6::AbstractSpinBox)
    double_spin_box.should be_a(Qt6::AbstractSpinBox)
    spin_box.button_symbols.should eq(Qt6::AbstractSpinBoxButtonSymbol::NoButtons)
    spin_box.read_only?.should be_true
    spin_box.wrapping?.should be_true
    spin_box.accelerated?.should be_true
    spin_box.correction_mode.should eq(Qt6::AbstractSpinBoxCorrectionMode::CorrectToNearestValue)
    spin_box.acceptable_input?.should be_true
    spin_box.keyboard_tracking?.should be_false
    spin_box.alignment.includes?(Qt6::AlignmentFlag::Right).should be_true
    spin_box.alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
    spin_box.frame?.should be_false
    spin_box.group_separator_shown?.should be_true
    spin_box.prefix.should eq("Zoom ")
    spin_box.suffix.should eq("%")
    spin_box.special_value_text.should eq("Auto")
    spin_box.text.should eq("Zoom 25%")
    spin_box.clean_text.should eq("25")
    spin_box.line_edit.should be_a(Qt6::LineEdit)
    spin_box.line_edit.text.should eq("Zoom 25%")
    editing_finished.should eq(1)
    return_pressed.should eq(1)
    double_spin_box.button_symbols.should eq(Qt6::AbstractSpinBoxButtonSymbol::PlusMinus)
    double_spin_box.read_only?.should be_false
    double_spin_box.wrapping?.should be_false
    double_spin_box.accelerated?.should be_true
    double_spin_box.decimals.should eq(3)
    double_spin_box.prefix.should eq("~")
    double_spin_box.suffix.should eq("x")
    double_spin_box.special_value_text.should eq("Default")
    double_spin_box.text.should eq("~1.250x")
    double_spin_box.clean_text.should eq("1.250")
    date_time_edit.keyboard_tracking?.should be_false
    date_time_edit.line_edit.should be_a(Qt6::LineEdit)
    date_time_edit.text.should eq("2026/04/14 09:30:15")
    date_time_edit.line_edit.text.should eq(date_time_edit.text)

    rect_f.should eq(Qt6::RectF.new(1.0, 2.0, 30.0, 40.0))
    rect_f.to_rect.should eq(rect)
    line_f.p1.should eq(Qt6::PointF.new(1.0, 5.0))
    line_f.p2.should eq(Qt6::PointF.new(5.0, 2.0))
    line_f.x1.should eq(1.0)
    line_f.y1.should eq(5.0)
    line_f.x2.should eq(5.0)
    line_f.y2.should eq(2.0)
    line_f.dx.should eq(4.0)
    line_f.dy.should eq(-3.0)
    line_f.center.should eq(Qt6::PointF.new(3.0, 3.5))
    line_f.length.should eq(5.0)
    line_f.angle.round(2).should eq(36.87)
    line_f.point_at(0.25).should eq(Qt6::PointF.new(2.0, 4.25))
    line_f.null?.should be_false
    Qt6::LineF.from_native(native_line_f).should eq(line_f)
    translated_line_f.should eq(Qt6::LineF.new(3.0, 4.0, 7.0, 1.0))
    Qt6::LineF.new(0.0, 0.0, 0.0, 0.0).null?.should be_true
    size_f.should eq(Qt6::SizeF.new(14.0, 9.0))
    size_f.to_size.should eq(size)
    page_size.size.should eq(size_f)
    image.rect.should eq(Qt6::Rect.new(0, 0, 32, 18))
    pixmap.rect.should eq(Qt6::Rect.new(0, 0, 12, 7))
    application.process_events

    spin_box.release
    double_spin_box.release
    image.release
    pixmap.release
  end

  it "supports editor controls and container widgets" do
    application = app
    window = Qt6::MainWindow.new
    radio_states = [] of Bool
    slider_values = [] of Int32
    slider_events = [] of String
    spin_values = [] of Int32
    double_values = [] of Float64
    group_states = [] of Bool
    tab_indices = [] of Int32

    splitter = Qt6::Splitter.new(Qt6::Orientation::Horizontal)
    scroll_area = Qt6::ScrollArea.new
    tab_widget = Qt6::TabWidget.new
    inspector = Qt6::Widget.new
    layers_page = Qt6::Label.new("Layers")
    export_page = Qt6::Label.new("Export")
    preview_page = Qt6::Label.new("Preview")
    options_group = Qt6::GroupBox.new("Options")
    auto_mode = Qt6::RadioButton.new("Auto")
    manual_mode = Qt6::RadioButton.new("Manual")
    slider = Qt6::Slider.new
    spin_box = Qt6::SpinBox.new
    double_spin_box = Qt6::DoubleSpinBox.new

    manual_mode.on_toggled do |value|
      radio_states << value
    end
    slider.on_value_changed do |value|
      slider_values << value
    end
    slider.on_pressed do
      slider_events << "pressed"
    end
    slider.on_released do
      slider_events << "released"
    end
    spin_box.on_value_changed do |value|
      spin_values << value
    end
    double_spin_box.on_value_changed do |value|
      double_values << value
    end
    options_group.on_toggled do |value|
      group_states << value
    end
    tab_widget.on_current_index_changed do |value|
      tab_indices << value
    end

    options_group.checkable = true
    options_group.alignment = Qt6::AlignmentFlag::HCenter
    options_group.flat = true
    options_group.vbox do |column|
      column << auto_mode
      column << manual_mode
      column << slider
      column << spin_box
      column << double_spin_box
    end

    inspector.vbox do |column|
      column << options_group
    end

    scroll_area.widget_resizable = true
    scroll_area.alignment = Qt6::AlignmentFlag::Center
    scroll_area.widget = inspector
    tab_widget.add_tab(layers_page, "Layers")
    tab_widget.add_tab(export_page, "Export")
    tab_widget.add_tab(preview_page, "Preview")
    splitter << scroll_area
    splitter << tab_widget
    window.central_widget = splitter
    window.resize(420, 260)
    window.show

    slider.set_range(0, 100)
    slider.click_to_position?.should be_false
    slider.click_to_position = true
    slider.value = 42
    spin_box.set_range(1, 9)
    spin_box.single_step = 2
    spin_box.value = 5
    double_spin_box.set_range(0.5, 4.0)
    double_spin_box.single_step = 0.25
    double_spin_box.value = 1.75
    auto_mode.auto_exclusive?.should be_true
    manual_mode.auto_exclusive = false
    manual_mode.click
    options_group.checked = false
    options_group.checked = true
    splitter.widget(0).not_nil!.to_unsafe.should eq(scroll_area.to_unsafe)
    splitter.widget(1).not_nil!.to_unsafe.should eq(tab_widget.to_unsafe)
    splitter.opaque_resize = false
    splitter.children_collapsible = false
    splitter.handle_width = 9
    splitter.set_sizes([120, 240]).should eq([120, 240])
    tab_widget.widget(0).not_nil!.to_unsafe.should eq(layers_page.to_unsafe)
    tab_widget.current_widget.not_nil!.to_unsafe.should eq(layers_page.to_unsafe)
    tab_widget.index_of(export_page).should eq(1)
    tab_widget.tab_text(2).should eq("Preview")
    tab_widget.set_tab_text(2, "Inspect")
    tab_widget.current_widget = preview_page
    tab_widget.remove_tab(1)
    splitter.orientation = Qt6::Orientation::Vertical
    application.process_events
    Qt6::LibQt6.qt6cr_slider_emit_pressed(slider.to_unsafe)
    Qt6::LibQt6.qt6cr_slider_emit_released(slider.to_unsafe)
    application.process_events

    scroll_area.widget_resizable?.should be_true
    scroll_area.alignment.should eq(Qt6::AlignmentFlag::Center)
    splitter.count.should eq(2)
    splitter.orientation.should eq(Qt6::Orientation::Vertical)
    splitter.opaque_resize?.should be_false
    splitter.children_collapsible?.should be_false
    splitter.handle_width.should eq(9)
    splitter.sizes.size.should eq(2)
    tab_widget.count.should eq(2)
    tab_widget.current_index.should eq(1)
    tab_widget.current_widget.not_nil!.to_unsafe.should eq(preview_page.to_unsafe)
    tab_widget.widget(1).not_nil!.to_unsafe.should eq(preview_page.to_unsafe)
    tab_widget.index_of(export_page).should eq(-1)
    tab_widget.tab_text(1).should eq("Inspect")
    options_group.title.should eq("Options")
    options_group.alignment.should eq(Qt6::AlignmentFlag::HCenter)
    options_group.checkable?.should be_true
    options_group.checked?.should be_true
    options_group.flat?.should be_true
    auto_mode.checked?.should be_false
    manual_mode.auto_exclusive?.should be_false
    manual_mode.checked?.should be_true
    slider.orientation.should eq(Qt6::Orientation::Horizontal)
    slider.minimum.should eq(0)
    slider.maximum.should eq(100)
    slider.click_to_position?.should be_true
    slider.value.should eq(42)
    spin_box.minimum.should eq(1)
    spin_box.maximum.should eq(9)
    spin_box.single_step.should eq(2)
    spin_box.value.should eq(5)
    double_spin_box.minimum.should eq(0.5)
    double_spin_box.maximum.should eq(4.0)
    double_spin_box.single_step.should eq(0.25)
    double_spin_box.value.should eq(1.75)
    radio_states.last.should be_true
    slider_values.last.should eq(42)
    slider_events.should eq(["pressed", "released"])
    spin_values.last.should eq(5)
    double_values.last.should eq(1.75)
    group_states.last.should be_true
    tab_indices.last.should eq(1)
    tab_widget.clear
    tab_widget.count.should eq(0)
    window.release
  end

  it "supports app-shell helpers for actions, toolbars, timers, and file dialogs" do
    app
    window = Qt6::MainWindow.new
    toolbar = Qt6::ToolBar.new("Shell", window)
    action = Qt6::Action.new("Export", window)
    file_dialog = Qt6::FileDialog.new(window, "/tmp", "Maps (*.map *.json)")
    loop = Qt6::QEventLoop.new
    triggered = [] of String

    action.tool_tip = "Export the active map"
    action.enabled = false
    action.data = "export-png"
    toolbar.movable = false
    toolbar.add_separator
    toolbar << action
    action.on_triggered do
      triggered << action.data.to_s
    end

    file_dialog.file_mode = Qt6::FileDialogFileMode::ExistingFiles
    file_dialog.select_file("/tmp/first.map")
    file_dialog.select_file("/tmp/second.map")

    Qt6::QTimer.single_shot(0) do
      action.enabled = true
      action.trigger
      loop.quit
    end

    loop.run.should eq(0)

    action.tool_tip.should eq("Export the active map")
    action.enabled?.should be_true
    action.data.should eq("export-png")
    toolbar.movable?.should be_false
    file_dialog.file_mode.should eq(Qt6::FileDialogFileMode::ExistingFiles)
    file_dialog.directory.should eq("/tmp")
    file_dialog.name_filter.should eq("Maps (*.map *.json)")
    triggered.should eq(["export-png"])

    loop.release
    window.release
  end

  it "supports desktop-shell action, menu, toolbar, and window polish" do
    application = app
    window = Qt6::MainWindow.new
    toggled = [] of Bool

    window.window_title = "Shell Polish"
    file_menu = window.menu_bar.add_menu("File")
    view_menu = window.menu_bar.add_menu("View")
    quick_open = file_menu.add_action("Quick Open")
    separator_action = file_menu.add_action("Separator Marker")
    toolbar = Qt6::ToolBar.new("Inspector", window)
    search = Qt6::LineEdit.new(parent: window)

    quick_open.shortcut = "Ctrl+Shift+O"
    quick_open.icon = Qt6::QIcon.new
    quick_open.checkable = true
    quick_open.status_tip = "Open a project quickly"
    quick_open.tool_tip = "Quick Open"
    quick_open.visible = false
    quick_open.visible = true
    quick_open.on_toggled do |value|
      toggled << value
    end
    quick_open.checked = true
    quick_open.checked = false

    separator_action.separator = true
    view_menu.title = "Panels"
    menu_action = view_menu.menu_action
    menu_action.text.should eq("Panels")

    window.add_tool_bar(toolbar)
    toolbar.movable = false
    toolbar.floatable = false
    toolbar.icon_size = Qt6::Size.new(20, 18)
    toolbar.tool_button_style = Qt6::ToolButtonStyle::TextBesideIcon
    toolbar.add_widget(search)
    toolbar.add_separator
    toolbar_action = toolbar.add_action("Refresh")
    toggle_view_action = toolbar.toggle_view_action
    toolbar_action.text.should eq("Refresh")
    toolbar.title = "Inspector Tools"
    window.remove_tool_bar(toolbar)
    window.add_tool_bar(toolbar)
    toolbar.clear
    toolbar << quick_open
    application.process_events

    quick_open.shortcut.to_s.should eq("Ctrl+Shift+O")
    quick_open.icon.null?.should be_true
    quick_open.status_tip.should eq("Open a project quickly")
    quick_open.tool_tip.should eq("Quick Open")
    quick_open.visible?.should be_true
    quick_open.checkable?.should be_true
    quick_open.checked?.should be_false
    toggled.should eq([true, false])
    separator_action.separator?.should be_true
    file_menu.add_action(Qt6::Action.new("Manual", window)).text.should eq("Manual")
    file_menu.clear
    toolbar.movable?.should be_false
    toolbar.floatable?.should be_false
    toolbar.icon_size.should eq(Qt6::Size.new(20, 18))
    toolbar.tool_button_style.should eq(Qt6::ToolButtonStyle::TextBesideIcon)
    toolbar.title.should eq("Inspector Tools")
    toggle_view_action.checkable?.should be_true
    toggle_view_action.text.should eq("Inspector Tools")
    window.window_title.should eq("Shell Polish")

    menu_action.release
    toggle_view_action.release
    window.release
  end

  it "supports widget actions with default widgets in menus" do
    app
    window = Qt6::MainWindow.new
    menu = Qt6::Menu.new("Controls", window)
    panel = Qt6::Widget.new(menu)
    slider = Qt6::Slider.new(Qt6::Orientation::Vertical, panel)
    action = Qt6::WidgetAction.new(menu)

    slider.set_range(0, 100)
    slider.value = 42
    panel.vbox do |column|
      column << slider
    end

    action.default_widget.should be_nil
    action.default_widget = panel
    menu.add_action(action).should eq(action)

    action.default_widget.not_nil!.to_unsafe.should eq(panel.to_unsafe)
    slider.orientation.should eq(Qt6::Orientation::Vertical)
    slider.value.should eq(42)

    window.release
  end

  it "supports push button menus" do
    app
    window = Qt6::MainWindow.new
    button = Qt6::PushButton.new("Volume", window)
    menu = Qt6::Menu.new("Volume Menu", button)

    button.menu.should be_nil
    button.default?.should be_false
    button.auto_default?.should be_false
    button.flat?.should be_false
    button.default = true
    button.auto_default = true
    button.flat = true
    button.menu = menu

    button.default?.should be_true
    button.auto_default?.should be_true
    button.flat?.should be_true
    button.menu.not_nil!.to_unsafe.should eq(menu.to_unsafe)
    button.menu.not_nil!.title.should eq("Volume Menu")

    button.menu = nil
    button.menu.should be_nil

    window.release
  end

  it "can execute menus at widget-local positions" do
    application = app
    window = Qt6::MainWindow.new
    menu = Qt6::Menu.new("Context Menu", window)
    menu.add_action("Play Now")

    window.resize(120, 80)
    window.show
    application.process_events

    Qt6::QTimer.single_shot(0) do
      menu.hide
    end

    menu.exec_at(window, Qt6::PointF.new(12.0, 18.0)).should eq(menu)

    window.release
  end

  it "supports system tray wrappers and standalone menus" do
    app
    window = Qt6::MainWindow.new
    menu = Qt6::Menu.new("Tray Menu", window)
    tray = Qt6::SystemTrayIcon.new(window)
    icon_path = File.join(Dir.tempdir, "crystal-qt6-tray-icon-#{Process.pid}.png")
    icon_image = Qt6::QImage.new(16, 16)
    activated = [] of Qt6::SystemTrayActivationReason
    message_clicked = false

    icon_image.fill(Qt6::Color.new(0, 0, 0, 0))
    icon_image.set_pixel_color(8, 8, Qt6::Color.new(32, 96, 180, 255))
    icon_image.save(icon_path).should be_true

    menu.add_action("Open")
    tray.icon.null?.should be_true
    tray.icon = Qt6::QIcon.from_file(icon_path)
    tray.tool_tip = "Tray test"
    tray.context_menu = menu
    tray.on_activated do |reason|
      activated << reason
    end
    tray.on_message_clicked do
      message_clicked = true
    end

    Qt6::SystemTrayIcon.system_tray_available?.should be_a(Bool)
    Qt6::SystemTrayIcon.supports_messages?.should be_a(Bool)
    tray.tool_tip.should eq("Tray test")
    tray.context_menu.not_nil!.title.should eq("Tray Menu")
    tray.icon.null?.should be_false
    activated.should be_empty
    message_clicked.should be_false

    if Qt6::SystemTrayIcon.system_tray_available?
      tray.show
      tray.visible?.should be_true
      tray.visible = false
      tray.visible?.should be_false

      if tray.supports_messages?
        tray.show_message("Spec", "Tray message", icon: Qt6::SystemTrayMessageIcon::Information, timeout: 1)
      end
    else
      tray.visible?.should be_false
    end

    window.release
  end

end
