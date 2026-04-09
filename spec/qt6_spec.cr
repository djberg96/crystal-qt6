require "./spec_helper"

describe Qt6 do
  it "renders into images and pixmaps with paths and transforms" do
    app
    image = Qt6::QImage.new(32, 32)
    image.fill(Qt6::Color.new(255, 255, 255))
    image.set_pixel_color(0, 0, Qt6::Color.new(1, 2, 3, 255))

    pen = Qt6::QPen.new(Qt6::Color.new(255, 0, 0), 3)
    brush = Qt6::QBrush.new(Qt6::Color.new(255, 0, 0))
    font = Qt6::QFont.new(point_size: 14, bold: true, italic: true)
    metrics = font.metrics
    metrics_f = font.metrics_f

    transform = Qt6::QTransform.new
    transform.translate(4, 5)

    path = Qt6::QPainterPath.new
    path.add_rect(Qt6::RectF.new(0.0, 0.0, 8.0, 8.0))
    moved_path = path.transformed(transform)

    Qt6::QPainter.paint(image) do |painter|
      painter.active?.should be_true
      painter.antialiasing = false
      painter.pen = pen
      painter.brush = brush
      painter.font = font
      painter.draw_path(moved_path)
      painter.fill_rect(Qt6::RectF.new(20.0, 20.0, 4.0, 4.0), Qt6::Color.new(0, 0, 255))
      painter.draw_line(Qt6::PointF.new(0.0, 31.0), Qt6::PointF.new(31.0, 31.0))
      painter.draw_text(Qt6::PointF.new(1.0, 16.0), "qt6")
    end

    pixmap = Qt6::QPixmap.from_image(image)
    pixmap_canvas = Qt6::QPixmap.new(40, 40)
    pixmap_canvas.fill(Qt6::Color.new(0, 0, 0, 0))

    Qt6::QPainter.paint(pixmap_canvas) do |painter|
      painter.draw_image(Qt6::PointF.new(2.0, 2.0), image)
      painter.draw_pixmap(Qt6::PointF.new(0.0, 0.0), pixmap)
    end

    pixmap_image = pixmap_canvas.to_image
    image_path = File.join(Dir.tempdir, "crystal-qt6-render-image-#{Process.pid}.png")
    pixmap_path = File.join(Dir.tempdir, "crystal-qt6-render-pixmap-#{Process.pid}.png")
    text_bounds = metrics.bounding_rect("qt6")
    text_bounds_f = metrics_f.bounding_rect("qt6")

    pen.width.should eq(3.0)
    pen.color.should eq(Qt6::Color.new(255, 0, 0, 255))
    brush.color.should eq(Qt6::Color.new(255, 0, 0, 255))
    font.point_size.should eq(14)
    font.bold?.should be_true
    font.italic?.should be_true
    metrics.height.should be > 0
    metrics.ascent.should be > 0
    metrics.descent.should be >= 0
    metrics.horizontal_advance("qt6").should be > 0
    text_bounds.width.should be > 0.0
    text_bounds.height.should be > 0.0
    metrics_f.height.should be > 0.0
    metrics_f.ascent.should be > 0.0
    metrics_f.descent.should be >= 0.0
    metrics_f.horizontal_advance("qt6").should be > 0.0
    text_bounds_f.width.should be > 0.0
    text_bounds_f.height.should be > 0.0
    transform.map(Qt6::PointF.new(1.0, 1.0)).should eq(Qt6::PointF.new(5.0, 6.0))
    transform.map(Qt6::RectF.new(0.0, 0.0, 8.0, 8.0)).should eq(Qt6::RectF.new(4.0, 5.0, 8.0, 8.0))
    moved_path.bounding_rect.should eq(Qt6::RectF.new(4.0, 5.0, 8.0, 8.0))
    image.pixel_color(0, 0).should eq(Qt6::Color.new(1, 2, 3, 255))
    image.pixel_color(6, 7).should eq(Qt6::Color.new(255, 0, 0, 255))
    image.pixel_color(21, 21).should eq(Qt6::Color.new(0, 0, 255, 255))
    pixmap.width.should eq(32)
    pixmap.height.should eq(32)
    pixmap.null?.should be_false
    pixmap_image.pixel_color(1, 1).should eq(Qt6::Color.new(255, 255, 255, 255))
    pixmap_image.pixel_color(6, 7).should eq(Qt6::Color.new(255, 0, 0, 255))
    image.save(image_path).should be_true
    pixmap.save(pixmap_path).should be_true
    File.exists?(image_path).should be_true
    File.exists?(pixmap_path).should be_true
  end

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

    message_result.should eq(Qt6::MessageBoxButton::Ok)
    selected_color.should eq(Qt6::Color.new(32, 64, 96, 128))
    text_value.should eq("Roads")
    int_value.should eq(7)
    double_value.should eq(1.25)
    window.release
  end

  it "configures color and input dialogs" do
    app
    window = Qt6::MainWindow.new
    color_dialog = Qt6::ColorDialog.new(window)
    input_dialog = Qt6::InputDialog.new(window)

    color_dialog.window_title = "Pick Accent Color"
    color_dialog.native_dialog = false
    color_dialog.show_alpha_channel = true
    color_dialog.current_color = Qt6::Color.new(32, 96, 192, 180)

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

    color_dialog.window_title.should eq("Pick Accent Color")
    color_dialog.native_dialog?.should be_false
    color_dialog.current_color.should eq(Qt6::Color.new(32, 96, 192, 180))
    color_dialog.show_alpha_channel?.should be_true

    input_dialog.window_title.should eq("Layer Details")
    input_dialog.label_text.should eq("Layer name")
    input_dialog.text_value.should eq("Terrain")
    input_dialog.int_minimum.should eq(1)
    input_dialog.int_maximum.should eq(12)
    input_dialog.int_value.should eq(4)
    input_dialog.double_minimum.should eq(0.5)
    input_dialog.double_maximum.should eq(4.0)
    input_dialog.double_value.should eq(1.5)
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
    check_box.on_toggled do |value|
      toggled << value
    end
    combo_box.on_current_index_changed do |index|
      indices << index
    end
    combo_box << "Units" << "Terrain"

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
    combo_box.current_index = 1
    open_action.trigger
    application.process_events

    recent_menu.title.should eq("Recent")
    main.status_bar.current_message.should eq("Ready")
    line_edit.text = "Terrain"
    line_edit.text.should eq("Terrain")
    check_box.checked?.should be_true
    combo_box.count.should eq(2)
    combo_box.current_text.should eq("Terrain")
    toggled.last.should be_true
    indices.last.should eq(1)
    triggered.should eq(1)
    dialog.result.should eq(Qt6::DialogCode::Accepted)
    accepted.should eq(1)
    rejected.should eq(0)
    main.release
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

  it "exposes geometry types and custom widget event hooks" do
    application = app
    widget = Qt6::EventWidget.new
    paint_events = [] of Qt6::PaintEvent
    painter_events = [] of Qt6::PaintEvent
    resize_events = [] of Qt6::ResizeEvent
    mouse_presses = [] of Qt6::MouseEvent
    mouse_moves = [] of Qt6::MouseEvent
    mouse_releases = [] of Qt6::MouseEvent
    wheels = [] of Qt6::WheelEvent
    keys = [] of Qt6::KeyEvent

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
    widget.on_wheel { |event| wheels << event }
    widget.on_key_press { |event| keys << event }

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
    widget.simulate_wheel(Qt6::PointF.new(20.0, 30.0), angle_delta: Qt6::PointF.new(0.0, 120.0))
    widget.simulate_key_press(65)
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
    wheels.last.angle_delta.should eq(Qt6::PointF.new(0.0, 120.0))
    keys.last.key.should eq(65)
    snapshot.pixel_color(5, 5).should eq(Qt6::Color.new(255, 0, 0, 255))
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

    window.close
    application.process_events
    window.visible?.should be_false
    window.release
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

  it "supports hbox, form, and grid layouts" do
    app
    window = Qt6::Widget.new
    name_field = Qt6::LineEdit.new("Terrain")
    kind_field = Qt6::ComboBox.new
    kind_field << "Hexes" << "Terrain"
    primary = Qt6::PushButton.new("Primary")
    secondary = Qt6::PushButton.new("Secondary")
    top_left = Qt6::Label.new("A")
    top_right = Qt6::Label.new("B")
    footer = Qt6::Label.new("Footer")

    window.form do |form|
      form.add_row("Name", name_field)
      form.add_row(Qt6::Label.new("Kind"), kind_field)
      form.add_row(Qt6::Widget.new.tap do |button_row|
        button_row.hbox do |row|
          row << primary
          row << secondary
        end
      end)
      form.add_row(Qt6::Widget.new.tap do |grid_host|
        grid_host.grid do |grid|
          grid.add(top_left, 0, 0)
          grid.add(top_right, 0, 1)
          grid.add(footer, 1, 0, 1, 2)
        end
      end)
    end

    name_field.text.should eq("Terrain")
    kind_field.count.should eq(2)
    top_left.text.should eq("A")
    top_right.text.should eq("B")
    footer.text.should eq("Footer")
    window.release
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
