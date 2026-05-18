require "./spec_helper"

describe Qt6 do
  it "provides convenience helpers for common dialogs" do
    app
    window = Qt6::MainWindow.new
    text_changes = [] of String
    text_selected = [] of String
    int_changes = [] of Int32
    int_selected = [] of Int32
    double_changes = [] of Float64
    double_selected = [] of Float64

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

    text_value = Qt6::InputDialog.get_text(window, title: "Rename", label: "Layer", value: "Terrain", echo_mode: Qt6::EchoMode::Password) do |dialog|
      dialog.text_echo_mode.should eq(Qt6::EchoMode::Password)
      dialog.on_text_value_changed { |value| text_changes << value }
      dialog.on_text_value_selected { |value| text_selected << value }
      dialog.text_value = "Roads"
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    multi_line_value = Qt6::InputDialog.get_multi_line_text(window, title: "Notes", label: "Summary", value: "Terrain") do |dialog|
      dialog.option?(Qt6::InputDialogOption::UsePlainTextEditForTextInput).should be_true
      dialog.text_value = "Terrain\nRoads"
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    int_value = Qt6::InputDialog.get_int(window, title: "Count", label: "Columns", value: 3, minimum: 1, maximum: 12, step: 2) do |dialog|
      dialog.int_step.should eq(2)
      dialog.on_int_value_changed { |value| int_changes << value }
      dialog.on_int_value_selected { |value| int_selected << value }
      dialog.int_value = 7
      timer = Qt6::QTimer.new(dialog)
      timer.single_shot = true
      timer.on_timeout { dialog.accept }
      timer.start(0)
    end

    double_value = Qt6::InputDialog.get_double(window, title: "Scale", label: "Zoom", value: 1.0, minimum: 0.5, maximum: 4.0, decimals: 3) do |dialog|
      dialog.double_decimals.should eq(3)
      dialog.on_double_value_changed { |value| double_changes << value }
      dialog.on_double_value_selected { |value| double_selected << value }
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
    multi_line_value.should eq("Terrain\nRoads")
    int_value.should eq(7)
    double_value.should eq(1.25)
    item_value.should eq("Roads")
    text_changes.should contain("Roads")
    text_changes.last.should eq("Roads")
    text_selected.should contain("Roads")
    text_selected.last.should eq("Roads")
    int_changes.should contain(7)
    int_changes.last.should eq(7)
    int_selected.should contain(7)
    int_selected.last.should eq(7)
    double_changes.should contain(1.25)
    double_changes.last.should eq(1.25)
    double_selected.should contain(1.25)
    double_selected.last.should eq(1.25)
    selected_font.try(&.release)
    window.release
  end

  it "configures color, font, and input dialogs" do
    app
    window = Qt6::MainWindow.new
    color_dialog = Qt6::ColorDialog.new(window, Qt6::Color.new(16, 24, 48, 96))
    font_dialog = Qt6::FontDialog.new(window, Qt6::QFont.new("Courier", 10))
    input_dialog = Qt6::InputDialog.new(window)
    current_color_changes = [] of Qt6::Color
    selected_colors = [] of Qt6::Color
    current_font_changes = [] of Qt6::QFont
    selected_fonts = [] of Qt6::QFont
    text_value_changes = [] of String
    int_value_changes = [] of Int32
    double_value_changes = [] of Float64
    custom_index = 0
    standard_index = 0
    original_custom_color = Qt6::ColorDialog.custom_color(custom_index)
    original_standard_color = Qt6::ColorDialog.standard_color(standard_index)

    color_dialog.on_current_color_changed do |color|
      current_color_changes << color
    end

    color_dialog.on_color_selected do |color|
      selected_colors << color
    end

    font_dialog.on_current_font_changed do |font|
      current_font_changes << font
    end

    font_dialog.on_font_selected do |font|
      selected_fonts << font
    end

    input_dialog.on_text_value_changed do |value|
      text_value_changes << value
    end

    input_dialog.on_int_value_changed do |value|
      int_value_changes << value
    end

    input_dialog.on_double_value_changed do |value|
      double_value_changes << value
    end

    color_dialog.window_title = "Pick Accent Color"
    color_dialog.options = Qt6::ColorDialogOption::NoButtons | Qt6::ColorDialogOption::ShowAlphaChannel
    color_dialog.native_dialog = false
    color_dialog.set_option(Qt6::ColorDialogOption::NoEyeDropperButton)
    color_dialog.clear_option(Qt6::ColorDialogOption::NoButtons)
    color_dialog.current_color = Qt6::Color.new(32, 96, 192, 180)
    Qt6::ColorDialog.set_custom_color(custom_index, Qt6::Color.new(90, 45, 135, 225))
    Qt6::ColorDialog.set_standard_color(standard_index, Qt6::Color.new(20, 40, 60, 255))

    font_dialog.window_title = "Pick Label Font"
    font_dialog.options = Qt6::FontDialogOption::ScalableFonts | Qt6::FontDialogOption::MonospacedFonts
    font_dialog.native_dialog = false
    font_dialog.set_option(Qt6::FontDialogOption::NoButtons)
    font_dialog.clear_option(Qt6::FontDialogOption::NoButtons)
    font_dialog.set_current_font(Qt6::QFont.new("Helvetica", 14, true, false)).to_unsafe.should eq(font_dialog.to_unsafe)

    input_dialog.window_title = "Layer Details"
    input_dialog.options = Qt6::InputDialogOption::NoButtons
    input_dialog.set_option(Qt6::InputDialogOption::UseListViewForComboBoxItems)
    input_dialog.clear_option(Qt6::InputDialogOption::NoButtons)
    input_dialog.input_mode = Qt6::InputDialogInputMode::Text
    input_dialog.label_text = "Layer name"
    input_dialog.ok_button_text = "Rename"
    input_dialog.cancel_button_text = "Skip"
    input_dialog.text_echo_mode = Qt6::EchoMode::PasswordEchoOnEdit
    input_dialog.text_value = "Terrain"
    input_dialog.input_mode = Qt6::InputDialogInputMode::Int
    input_dialog.int_range = 1..12
    input_dialog.int_step = 3
    input_dialog.int_value = 4
    input_dialog.input_mode = Qt6::InputDialogInputMode::Double
    input_dialog.double_range = 0.5..4.0
    input_dialog.double_decimals = 2
    input_dialog.double_value = 1.5
    input_dialog.input_mode = Qt6::InputDialogInputMode::Text
    input_dialog.set_option(Qt6::InputDialogOption::UsePlainTextEditForTextInput)
    input_dialog.combo_box_items = ["Terrain", "Units", "Roads"]
    input_dialog.combo_box_editable = false
    input_dialog.text_value = "Units"

    color_dialog.window_title.should eq("Pick Accent Color")
    color_dialog.native_dialog?.should be_false
    color_dialog.option?(Qt6::ColorDialogOption::ShowAlphaChannel).should be_true
    color_dialog.option?(Qt6::ColorDialogOption::NoEyeDropperButton).should be_true
    color_dialog.option?(Qt6::ColorDialogOption::NoButtons).should be_false
    color_dialog.current_color.should eq(Qt6::Color.new(32, 96, 192, 180))
    color_dialog.show_alpha_channel?.should be_true
    color_dialog.accept
    color_dialog.selected_color.should eq(Qt6::Color.new(32, 96, 192, 180))
    current_color_changes.empty?.should be_false
    selected_colors.should eq([Qt6::Color.new(32, 96, 192, 180)])
    Qt6::ColorDialog.custom_count.should be > 0
    Qt6::ColorDialog.custom_color(custom_index).should eq(Qt6::Color.new(90, 45, 135, 255))
    Qt6::ColorDialog.standard_color(standard_index).should eq(Qt6::Color.new(20, 40, 60, 255))

    font_dialog.window_title.should eq("Pick Label Font")
    font_dialog.native_dialog?.should be_false
    font_dialog.option?(Qt6::FontDialogOption::ScalableFonts).should be_true
    font_dialog.option?(Qt6::FontDialogOption::MonospacedFonts).should be_true
    font_dialog.option?(Qt6::FontDialogOption::NoButtons).should be_false
    font_dialog.options.should eq(
      Qt6::FontDialogOption::DontUseNativeDialog |
      Qt6::FontDialogOption::ScalableFonts |
      Qt6::FontDialogOption::MonospacedFonts
    )
    font_dialog.current_font.point_size.should eq(14)
    font_dialog.accept
    font_dialog.selected_font.point_size.should eq(14)
    current_font_changes.empty?.should be_false
    selected_fonts.empty?.should be_false
    selected_fonts.last.point_size.should eq(14)

    input_dialog.window_title.should eq("Layer Details")
    input_dialog.option?(Qt6::InputDialogOption::UseListViewForComboBoxItems).should be_true
    input_dialog.option?(Qt6::InputDialogOption::UsePlainTextEditForTextInput).should be_true
    input_dialog.option?(Qt6::InputDialogOption::NoButtons).should be_false
    input_dialog.ok_button_text.should eq("Rename")
    input_dialog.cancel_button_text.should eq("Skip")
    input_dialog.label_text.should eq("Layer name")
    input_dialog.text_echo_mode.should eq(Qt6::EchoMode::PasswordEchoOnEdit)
    input_dialog.text_value.should eq("Units")
    input_dialog.int_minimum.should eq(1)
    input_dialog.int_maximum.should eq(12)
    input_dialog.int_step.should eq(3)
    input_dialog.int_value.should eq(4)
    input_dialog.double_minimum.should eq(0.5)
    input_dialog.double_maximum.should eq(4.0)
    input_dialog.double_decimals.should eq(2)
    input_dialog.double_value.should eq(1.5)
    input_dialog.combo_box_items.should eq(["Terrain", "Units", "Roads"])
    input_dialog.combo_box_editable?.should be_false
    text_value_changes.should contain("Terrain")
    text_value_changes.should contain("Units")
    int_value_changes.should contain(4)
    int_value_changes.last.should eq(4)
    double_value_changes.should contain(1.5)
    double_value_changes.last.should eq(1.5)
    Qt6::ColorDialog.set_custom_color(custom_index, original_custom_color)
    Qt6::ColorDialog.set_standard_color(standard_index, original_standard_color)
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
    message_box.detailed_text = "Terrain and unit placements will be lost."
    message_box.standard_buttons = Qt6::MessageBoxButton::Save | Qt6::MessageBoxButton::Discard | Qt6::MessageBoxButton::Cancel
    explain_button = message_box.add_button("Explain", Qt6::DialogButtonBoxButtonRole::HelpRole)
    apply_button = message_box.add_button(Qt6::MessageBoxButton::Apply)
    save_button = message_box.button(Qt6::MessageBoxButton::Save).not_nil!
    message_box.default_button = save_button
    message_box.set_escape_button(Qt6::MessageBoxButton::Cancel)
    message_box.accept

    file_dialog.accept_mode = Qt6::FileDialogAcceptMode::Save
    file_dialog.file_mode = Qt6::FileDialogFileMode::AnyFile
    # Configure the widget-backed dialog before applying view-specific state.
    file_dialog.options = Qt6::FileDialogOption::DontUseNativeDialog | Qt6::FileDialogOption::ReadOnly
    file_dialog.view_mode = Qt6::FileDialogViewMode::List
    file_dialog.set_option(Qt6::FileDialogOption::HideNameFilterDetails)
    file_dialog.filter = Qt6::DirectoryFilter::Files | Qt6::DirectoryFilter::NoDotAndDotDot
    file_dialog.directory = "/tmp"
    file_dialog.name_filter = "Maps (*.map *.json)"
    file_dialog.name_filters = ["Maps (*.map *.json)", "Images (*.png *.jpg)"]
    file_dialog.select_name_filter("Images (*.png *.jpg)")
    file_dialog.default_suffix = "map"
    file_dialog.history = ["/tmp", "/var/tmp"]
    file_dialog.set_label_text(Qt6::FileDialogLabel::Accept, "Export")
    file_dialog.supported_schemes = ["file", "https"]
    file_dialog.select_file("/tmp/example.map")

    message_box.window_title.should eq("Unsaved Changes")
    message_box.icon.should eq(Qt6::MessageBoxIcon::Warning)
    message_box.text.should eq("This map has unsaved changes.")
    message_box.informative_text.should eq("Save before closing?")
    message_box.detailed_text.should eq("Terrain and unit placements will be lost.")
    message_box.standard_buttons.includes?(Qt6::MessageBoxButton::Save).should be_true
    message_box.standard_buttons.includes?(Qt6::MessageBoxButton::Discard).should be_true
    message_box.standard_buttons.includes?(Qt6::MessageBoxButton::Cancel).should be_true
    message_box.button_role(explain_button).should eq(Qt6::DialogButtonBoxButtonRole::HelpRole)
    message_box.standard_button(apply_button).should eq(Qt6::MessageBoxButton::Apply)
    message_box.default_button.not_nil!.to_unsafe.should eq(save_button.to_unsafe)
    message_box.escape_button.not_nil!.to_unsafe.should eq(message_box.button(Qt6::MessageBoxButton::Cancel).not_nil!.to_unsafe)
    message_box.result.should eq(Qt6::DialogCode::Accepted)

    file_dialog.accept_mode.should eq(Qt6::FileDialogAcceptMode::Save)
    file_dialog.file_mode.should eq(Qt6::FileDialogFileMode::AnyFile)
    file_dialog.view_mode.should eq(Qt6::FileDialogViewMode::List)
    file_dialog.options.includes?(Qt6::FileDialogOption::DontUseNativeDialog).should be_true
    file_dialog.options.includes?(Qt6::FileDialogOption::ReadOnly).should be_true
    file_dialog.option?(Qt6::FileDialogOption::HideNameFilterDetails).should be_true
    file_dialog.filter.includes?(Qt6::DirectoryFilter::Files).should be_true
    file_dialog.filter.includes?(Qt6::DirectoryFilter::NoDotAndDotDot).should be_true
    file_dialog.directory.should eq("/tmp")
    file_dialog.name_filter.should eq("Maps (*.map *.json);;Images (*.png *.jpg)")
    file_dialog.name_filters.should eq(["Maps (*.map *.json)", "Images (*.png *.jpg)"])
    ["Images (*.png *.jpg)", "Images"].should contain(file_dialog.selected_name_filter)
    file_dialog.default_suffix.should eq("map")
    file_dialog.history.should eq(["/tmp", "/var/tmp"])
    file_dialog.label_text(Qt6::FileDialogLabel::Accept).should eq("Export")
    file_dialog.supported_schemes.should eq(["file", "https"])
    window.release
  end

  it "supports progress dialogs and splash screens" do
    application = app
    window = Qt6::MainWindow.new
    progress = Qt6::ProgressDialog.new(window, label_text: "Loading tiles", cancel_button_text: "Stop", minimum: 0, maximum: 10)
    custom_label = Qt6::Label.new("Preparing layers")
    custom_bar = Qt6::ProgressBar.new
    custom_cancel = Qt6::PushButton.new("Abort")
    canceled = false

    progress.on_canceled do
      canceled = true
    end

    progress.label_text.should eq("Loading tiles")
    progress.minimum.should eq(0)
    progress.maximum.should eq(10)
    progress.set_label(custom_label)
    progress.set_bar(custom_bar)
    progress.set_cancel_button(custom_cancel)
    progress.set_label_text("Loading tiles")
    progress.set_minimum_duration(0)
    progress.minimum_duration.should eq(0)
    progress.set_auto_close(false)
    progress.set_auto_reset(false)
    progress.auto_close?.should be_false
    progress.auto_reset?.should be_false
    progress.set_range(1, 5)
    progress.minimum.should eq(1)
    progress.maximum.should eq(5)
    progress.set_value(2)
    progress.value.should eq(2)
    custom_bar.value.should eq(2)
    custom_label.text.should eq("Loading tiles")
    progress.size_hint.width.should be > 0
    progress.size_hint.height.should be > 0
    progress.was_canceled?.should be_false

    cancel_timer = Qt6::QTimer.new(progress)
    cancel_timer.single_shot = true
    cancel_timer.on_timeout do
      custom_cancel.click
    end
    progress.show
    cancel_timer.start(0)
    10.times do
      application.process_events
      break if progress.was_canceled?
    end

    progress.was_canceled?.should be_true
    canceled.should be_true
    progress.reset

    splash_image = Qt6::QImage.new(24, 16)
    splash_image.fill(Qt6::Color.new(250, 240, 220))
    splash_image.set_pixel_color(2, 2, Qt6::Color.new(30, 90, 180))
    splash = Qt6::SplashScreen.new(splash_image.to_pixmap)
    mirrored_splash = Qt6::SplashScreen.wrap(splash.to_unsafe)
    replacement_pixmap = Qt6::QPixmap.new(12, 12)
    replacement_pixmap.fill(Qt6::Color.new(18, 36, 72))
    splash_messages = [] of String

    splash.pixmap.null?.should be_false
    mirrored_splash.pixmap.null?.should be_false
    splash.on_message_changed { |message| splash_messages << message }
    splash.show
    splash.show_message("Booting", Qt6::AlignmentFlag::Center, Qt6::Color.new(12, 34, 56))
    application.process_events
    splash.message.should eq("Booting")
    splash_messages.last.should eq("Booting")
    splash.set_pixmap(replacement_pixmap).to_unsafe.should eq(splash.to_unsafe)
    splash.pixmap.size.should eq(Qt6::Size.new(12, 12))
    window.show
    application.process_events
    splash.finish(window)
    application.process_events
    splash.visible?.should be_false
    splash.clear_message
    splash.message.should eq("")
    splash_messages.last.should eq("")

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
    canvas = Qt6::Label.new("Canvas")
    main.central_widget = canvas

    file_menu = main.menu_bar.add_menu("File")
    recent_menu = file_menu.add_menu("Recent")
    open_action = Qt6::Action.new("Open", main)
    open_action.on_triggered do
      triggered += 1
    end
    file_menu << open_action
    file_menu.add_separator

    custom_status = Qt6::StatusBar.new(main)
    main.status_bar = custom_status
    tool_bar = Qt6::ToolBar.new("Primary", main)
    secondary_toolbar = Qt6::ToolBar.new("Secondary", main)
    inserted_toolbar = Qt6::ToolBar.new("Inserted", main)
    tool_bar.object_name = "primary-toolbar"
    secondary_toolbar.object_name = "secondary-toolbar"
    inserted_toolbar.object_name = "inserted-toolbar"
    main.add_tool_bar(tool_bar)
    main.add_tool_bar(Qt6::ToolBarArea::Bottom, secondary_toolbar)
    main.insert_tool_bar(secondary_toolbar, inserted_toolbar)
    tool_bar << open_action
    main.icon_size = Qt6::Size.new(18, 16)
    main.tool_button_style = Qt6::ToolButtonStyle::TextBesideIcon
    main.animated = true
    main.document_mode = true
    main.dock_nesting_enabled = true
    main.set_corner(Qt6::Corner::TopLeftCorner, Qt6::DockArea::Left)

    dock = Qt6::DockWidget.new("Inspector", main)
    inspector = Qt6::Widget.new
    line_edit = Qt6::LineEdit.new("Hexes")
    check_box = Qt6::CheckBox.new("Snap")
    combo_box = Qt6::ComboBox.new
    completer = Qt6::Completer.new(["Terrain", "Roads", "Units"], combo_box)
    state_changes = [] of Qt6::CheckState
    check_clicks = 0
    combo_text_changes = [] of String
    combo_edit_text_changes = [] of String
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
    combo_box.on_current_text_changed do |value|
      combo_text_changes << value
    end
    combo_box.on_edit_text_changed do |value|
      combo_edit_text_changes << value
    end
    combo_box << "Units" << "Terrain"
    combo_box.insert_item(1, "Roads")

    inspector.vbox do |column|
      column << line_edit
      column << check_box
      column << combo_box
    end

    dock.widget = inspector
    dock.object_name = "inspector-dock"
    main.add_dock_widget(dock, Qt6::DockArea::Left)
    main.status_bar.show_message("Ready")
    saved_state = main.save_state

    dialog = Qt6::Dialog.new(main)
    finished = [] of Qt6::DialogCode
    dialog.on_accepted do
      accepted += 1
    end
    dialog.on_finished do |value|
      finished << value
    end
    dialog.on_rejected do
      rejected += 1
    end

    dialog.modal = true
    dialog.size_grip_enabled = true
    dialog.result = Qt6::DialogCode::Rejected
    dialog.open
    application.process_events
    dialog.visible?.should be_true
    dialog.done(Qt6::DialogCode::Accepted).should eq(Qt6::DialogCode::Accepted)
    check_box.checked = true
    check_box.tristate = true
    check_box.check_state = Qt6::CheckState::PartiallyChecked
    check_box.click
    combo_box.editable = true
    combo_box.completer = completer
    combo_box.placeholder_text = "Layer kind"
    combo_box.max_visible_items = 12
    combo_box.max_count = 6
    combo_box.duplicates_enabled = true
    combo_box.frame = false
    combo_box.insert_policy = Qt6::ComboBoxInsertPolicy::InsertAlphabetically
    combo_box.size_adjust_policy = Qt6::ComboBoxSizeAdjustPolicy::AdjustToContentsOnFirstShow
    combo_box.set_item_data(1, "roads-meta")
    combo_box.item_text(1).should eq("Roads")
    combo_box.find_text("Roads").should eq(1)
    combo_box.remove_item(0)
    combo_box.edit_text = "Overlay"
    combo_box.current_text = "Terrain"
    combo_box.current_index = combo_box.find_text("Terrain")
    combo_box.set_item_data(combo_box.current_index, 99)
    open_action.trigger
    application.process_events

    recent_menu.title.should eq("Recent")
    main.central_widget.not_nil!.to_unsafe.should eq(canvas.to_unsafe)
    main.status_bar.to_unsafe.should eq(custom_status.to_unsafe)
    main.status_bar.current_message.should eq("Ready")
    main.icon_size.should eq(Qt6::Size.new(18, 16))
    main.tool_button_style.should eq(Qt6::ToolButtonStyle::TextBesideIcon)
    main.animated?.should be_true
    main.document_mode?.should be_true
    main.dock_nesting_enabled?.should be_true
    main.corner(Qt6::Corner::TopLeftCorner).should eq(Qt6::DockArea::Left)
    tool_bar.object_name.should eq("primary-toolbar")
    secondary_toolbar.object_name.should eq("secondary-toolbar")
    inserted_toolbar.object_name.should eq("inserted-toolbar")
    dock.object_name.should eq("inspector-dock")
    secondary_toolbar.toggle_view_action.text.should eq("Secondary")
    inserted_toolbar.toggle_view_action.text.should eq("Inserted")
    saved_state.empty?.should be_false
    main.restore_state(saved_state).should be_true
    line_edit.text = "Terrain"
    line_edit.text.should eq("Terrain")
    check_box.text.should eq("Snap")
    check_box.checkable?.should be_true
    check_box.tristate?.should be_true
    check_box.checked?.should be_true
    check_box.check_state.should eq(Qt6::CheckState::Checked)
    combo_box.count.should eq(2)
    combo_box.editable?.should be_true
    combo_box.line_edit.should be_a(Qt6::LineEdit)
    combo_box.completer.not_nil!.to_unsafe.should eq(completer.to_unsafe)
    combo_box.placeholder_text.should eq("Layer kind")
    combo_box.max_visible_items.should eq(12)
    combo_box.max_count.should eq(6)
    combo_box.duplicates_enabled?.should be_true
    combo_box.frame?.should be_false
    combo_box.insert_policy.should eq(Qt6::ComboBoxInsertPolicy::InsertAlphabetically)
    combo_box.size_adjust_policy.should eq(Qt6::ComboBoxSizeAdjustPolicy::AdjustToContentsOnFirstShow)
    combo_box.item_data(0).should eq("roads-meta")
    combo_box.current_data.should eq(99)
    combo_box.current_text.should eq("Terrain")
    combo_text_changes.should contain("Terrain")
    combo_edit_text_changes.should contain("Overlay")
    toggled.last.should be_true
    state_changes.should contain(Qt6::CheckState::PartiallyChecked)
    state_changes.last.should eq(Qt6::CheckState::Checked)
    check_clicks.should eq(1)
    indices.last.should eq(1)
    triggered.should eq(1)
    dialog.modal?.should be_true
    dialog.size_grip_enabled?.should be_true
    dialog.result.should eq(Qt6::DialogCode::Accepted)
    accepted.should eq(1)
    rejected.should eq(0)
    finished.should contain(Qt6::DialogCode::Accepted)
    main.remove_dock_widget(dock)
    application.process_events
    dock.visible?.should be_false
    main.add_dock_widget(dock, Qt6::DockArea::Left)
    combo_box.clear
    combo_box.count.should eq(0)
    saved_state.release
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
    spin_text_changes = [] of String
    double_text_changes = [] of String

    spin_box.on_text_changed { |value| spin_text_changes << value }
    double_spin_box.on_text_changed { |value| double_text_changes << value }
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
    spin_box.step_type = Qt6::AbstractSpinBoxStepType::AdaptiveDecimalStepType
    spin_box.set_range(0, 100)
    spin_box.value = 25
    double_spin_box.button_symbols = Qt6::AbstractSpinBoxButtonSymbol::PlusMinus
    double_spin_box.read_only = false
    double_spin_box.wrapping = false
    double_spin_box.accelerated = true
    double_spin_box.prefix = "~"
    double_spin_box.suffix = "x"
    double_spin_box.special_value_text = "Default"
    double_spin_box.step_type = Qt6::AbstractSpinBoxStepType::AdaptiveDecimalStepType
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
    spin_box.step_type.should eq(Qt6::AbstractSpinBoxStepType::AdaptiveDecimalStepType)
    spin_box.text.should eq("Zoom 25%")
    spin_box.clean_text.should eq("25")
    spin_box.line_edit.should be_a(Qt6::LineEdit)
    spin_box.line_edit.text.should eq("Zoom 25%")
    spin_text_changes.last.should eq("Zoom 25%")
    editing_finished.should eq(1)
    return_pressed.should eq(1)
    double_spin_box.button_symbols.should eq(Qt6::AbstractSpinBoxButtonSymbol::PlusMinus)
    double_spin_box.read_only?.should be_false
    double_spin_box.wrapping?.should be_false
    double_spin_box.accelerated?.should be_true
    double_spin_box.step_type.should eq(Qt6::AbstractSpinBoxStepType::AdaptiveDecimalStepType)
    double_spin_box.decimals.should eq(3)
    double_spin_box.prefix.should eq("~")
    double_spin_box.suffix.should eq("x")
    double_spin_box.special_value_text.should eq("Default")
    double_spin_box.text.should eq("~1.250x")
    double_spin_box.clean_text.should eq("1.250")
    double_text_changes.last.should eq("~1.250x")
    date_time_edit.keyboard_tracking?.should be_false
    date_time_edit.line_edit.should be_a(Qt6::LineEdit)
    date_time_edit.text.should eq("2026/04/14 09:30:15")
    date_time_edit.line_edit.text.should eq(date_time_edit.text)

    spin_box.prefix = ""
    spin_box.suffix = ""
    spin_box.display_integer_base = 16
    spin_box.value = 31
    spin_box.display_integer_base.should eq(16)
    spin_box.text.downcase.should eq("1f")
    spin_box.clean_text.downcase.should eq("1f")

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
    splitter_moves = [] of Tuple(Int32, Int32)

    splitter = Qt6::Splitter.new(Qt6::Orientation::Horizontal)
    scroll_area = Qt6::ScrollArea.new
    tab_widget = Qt6::TabWidget.new
    outline_page = Qt6::Label.new("Outline")
    replacement_page = Qt6::Label.new("Replacement")
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
    radio_icon_path = File.join(Dir.tempdir, "crystal-qt6-radio-button-icon-#{Process.pid}.png")
    radio_icon_image = Qt6::QImage.new(12, 12)
    radio_icon_image.fill(Qt6::Color.new(24, 96, 160))
    radio_icon_image.save(radio_icon_path).should be_true

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
    splitter.on_splitter_moved do |pos, index|
      splitter_moves << {pos, index}
    end

    options_group.set_title("Inspector Options")
    options_group.set_checkable(true)
    options_group.set_alignment(Qt6::AlignmentFlag::HCenter)
    options_group.set_flat(true)
    auto_mode.set_text("Automatic")
    auto_mode.set_checked(true)
    auto_mode.set_auto_exclusive(false)
    auto_mode.auto_exclusive?.should be_false
    auto_mode.set_auto_exclusive(true)
    manual_mode.set_auto_exclusive(false)
    manual_mode.icon = Qt6::QIcon.new(radio_icon_path)
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
    splitter.insert(1, outline_page)
    splitter << tab_widget
    window.central_widget = splitter
    window.resize(420, 260)
    window.show

    slider.set_range(0, 100)
    slider.click_to_position?.should be_false
    slider.set_click_to_position(true)
    slider.set_tick_position(Qt6::SliderTickPosition::TicksBelow)
    slider.set_tick_interval(10)
    slider.value = 42
    spin_box.set_range(1, 9)
    spin_box.single_step = 2
    spin_box.value = 5
    double_spin_box.set_range(0.5, 4.0)
    double_spin_box.single_step = 0.25
    double_spin_box.value = 1.75
    manual_mode.click
    options_group.set_checked(false)
    application.process_events
    auto_mode.enabled?.should be_false
    manual_mode.enabled?.should be_false
    slider.enabled?.should be_false
    spin_box.enabled?.should be_false
    double_spin_box.enabled?.should be_false
    options_group.set_checked(true)
    application.process_events
    splitter.widget(0).not_nil!.to_unsafe.should eq(scroll_area.to_unsafe)
    splitter.widget(1).not_nil!.to_unsafe.should eq(outline_page.to_unsafe)
    splitter.widget(2).not_nil!.to_unsafe.should eq(tab_widget.to_unsafe)
    splitter.index_of(tab_widget).should eq(2)
    splitter.opaque_resize = false
    splitter.children_collapsible = false
    splitter.set_collapsible(1, true)
    splitter.set_stretch_factor(2, 3)
    splitter.handle_width = 9
    splitter.set_sizes([120, 80, 240]).should eq([120, 80, 240])
    replaced_outline = splitter.replace(1, replacement_page).not_nil!
    saved_splitter_state = splitter.save_state
    splitter.refresh
    tab_widget.widget(0).not_nil!.to_unsafe.should eq(layers_page.to_unsafe)
    tab_widget.current_widget.not_nil!.to_unsafe.should eq(layers_page.to_unsafe)
    tab_widget.index_of(export_page).should eq(1)
    tab_widget.tab_text(2).should eq("Preview")
    tab_widget.set_tab_text(2, "Inspect")
    tab_widget.current_widget = preview_page
    tab_widget.remove_tab(1)
    splitter.set_orientation(Qt6::Orientation::Vertical)
    application.process_events
    splitter.restore_state(saved_splitter_state.bytes).should be_true
    splitter.handle_width = 11
    splitter.restore_state(saved_splitter_state).should be_true
    splitter_range = splitter.get_range(1)
    splitter_handle = splitter.handle(1).not_nil!
    splitter_handle.orientation.should eq(splitter.orientation)
    splitter_handle.set_orientation(splitter.orientation).to_unsafe.should eq(splitter_handle.to_unsafe)
    splitter_handle.opaque_resize?.should be_false
    splitter_handle.splitter.not_nil!.to_unsafe.should eq(splitter.to_unsafe)
    Qt6::LibQt6.qt6cr_splitter_emit_splitter_moved(splitter.to_unsafe, 123, 1)
    Qt6::LibQt6.qt6cr_slider_emit_pressed(slider.to_unsafe)
    Qt6::LibQt6.qt6cr_slider_emit_released(slider.to_unsafe)
    application.process_events

    scroll_area.widget_resizable?.should be_true
    scroll_area.alignment.should eq(Qt6::AlignmentFlag::Center)
    splitter.count.should eq(3)
    splitter.orientation.should eq(Qt6::Orientation::Horizontal)
    splitter.opaque_resize?.should be_false
    splitter.children_collapsible?.should be_false
    splitter.collapsible?(1).should be_true
    splitter.handle_width.should eq(9)
    splitter.sizes.size.should eq(3)
    splitter.size_hint.width.should be > 0
    splitter.minimum_size_hint.width.should be >= 0
    splitter_range[0].should be <= splitter_range[1]
    splitter_handle.size_hint.width.should be >= 0
    splitter_moves.last.should eq({123, 1})
    saved_splitter_state.empty?.should be_false
    tab_widget.count.should eq(2)
    tab_widget.current_index.should eq(1)
    tab_widget.current_widget.not_nil!.to_unsafe.should eq(preview_page.to_unsafe)
    tab_widget.widget(1).not_nil!.to_unsafe.should eq(preview_page.to_unsafe)
    tab_widget.index_of(export_page).should eq(-1)
    tab_widget.tab_text(1).should eq("Inspect")
    options_group.title.should eq("Inspector Options")
    options_group.alignment.should eq(Qt6::AlignmentFlag::HCenter)
    options_group.checkable?.should be_true
    options_group.checked?.should be_true
    options_group.flat?.should be_true
    auto_mode.enabled?.should be_true
    manual_mode.enabled?.should be_true
    slider.enabled?.should be_true
    spin_box.enabled?.should be_true
    double_spin_box.enabled?.should be_true
    auto_mode.text.should eq("Automatic")
    auto_mode.checked?.should be_true
    auto_mode.auto_exclusive?.should be_true
    manual_mode.auto_exclusive?.should be_false
    manual_mode.icon.null?.should be_false
    manual_mode.size_hint.width.should be > 0
    manual_mode.minimum_size_hint.height.should be > 0
    manual_mode.checked?.should be_true
    slider.orientation.should eq(Qt6::Orientation::Horizontal)
    slider.minimum.should eq(0)
    slider.maximum.should eq(100)
    slider.click_to_position?.should be_true
    slider.tick_position.should eq(Qt6::SliderTickPosition::TicksBelow)
    slider.tick_interval.should eq(10)
    slider.value.should eq(42)
    slider.size_hint.width.should be > 0
    slider.minimum_size_hint.height.should be > 0
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
    replaced_outline.to_unsafe.should eq(outline_page.to_unsafe)
    tab_widget.clear
    tab_widget.count.should eq(0)
    saved_splitter_state.release
    replaced_outline.release
    window.release
    File.delete?(radio_icon_path)
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
    file_dialog.set_option(Qt6::FileDialogOption::DontUseNativeDialog)
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
    file_dialog.selected_files.should eq(["/tmp/second.map"])
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
    view_menu = Qt6::Menu.new("View", window)
    tools_menu = Qt6::Menu.new("Tools", window)
    window.menu_bar.add_menu(view_menu).to_unsafe.should eq(view_menu.to_unsafe)
    window.menu_bar.add_menu(tools_menu).to_unsafe.should eq(tools_menu.to_unsafe)
    help_action = window.menu_bar.add_action("Help")
    quick_open = file_menu.add_action("Quick Open")
    separator_action = file_menu.add_action("Separator Marker")
    advanced_menu = Qt6::Menu.new("Advanced", window)
    tools_menu.add_menu(advanced_menu)
    preferences_action = Qt6::Action.new("Preferences", window)
    tools_menu.add_action(preferences_action)
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
    tools_menu.default_action = preferences_action

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
    help_action.text.should eq("Help")
    tools_menu.default_action.not_nil!.text.should eq("Preferences")
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
    application = app
    window = Qt6::MainWindow.new
    icon_path = File.join(Dir.tempdir, "crystal-qt6-push-button-icon-#{Process.pid}.png")
    image = Qt6::QImage.new(12, 12)
    image.fill(Qt6::Color.new(40, 80, 160))
    image.save(icon_path).should be_true
    icon = Qt6::QIcon.new(icon_path)
    button = Qt6::PushButton.new(icon, "Volume", window)
    menu = Qt6::Menu.new("Volume Menu")

    button.menu.should be_nil
    button.default?.should be_false
    button.auto_default?.should be_false
    button.flat?.should be_false
    button.set_default(true)
    button.set_auto_default(true)
    button.set_flat(true)
    button.set_menu(menu)

    button.default?.should be_true
    button.auto_default?.should be_true
    button.flat?.should be_true
    button.icon.null?.should be_false
    button.size_hint.width.should be > 0
    button.minimum_size_hint.height.should be > 0
    button.menu.not_nil!.to_unsafe.should eq(menu.to_unsafe)
    button.menu.not_nil!.title.should eq("Volume Menu")

    window.show
    application.process_events
    Qt6::QTimer.single_shot(0) do
      button.menu.try(&.hide)
    end
    button.show_menu
    application.process_events

    button.menu = nil
    button.menu.should be_nil

    window.release
    File.delete?(icon_path)
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
