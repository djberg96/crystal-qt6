require "./spec_helper"

describe Qt6 do
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
    resize_events = [] of Qt6::ResizeEvent
    mouse_presses = [] of Qt6::MouseEvent
    mouse_moves = [] of Qt6::MouseEvent
    mouse_releases = [] of Qt6::MouseEvent
    wheels = [] of Qt6::WheelEvent
    keys = [] of Qt6::KeyEvent

    widget.on_paint { |event| paint_events << event }
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

    widget.size.should eq(Qt6::Size.new(200, 120))
    widget.rect.width.should eq(200.0)
    resize_events.last.size.should eq(Qt6::Size.new(200, 120))
    paint_events.empty?.should be_false
    mouse_presses.last.position.should eq(Qt6::PointF.new(10.0, 20.0))
    mouse_moves.last.position.should eq(Qt6::PointF.new(15.0, 25.0))
    mouse_releases.last.position.should eq(Qt6::PointF.new(18.0, 28.0))
    wheels.last.angle_delta.should eq(Qt6::PointF.new(0.0, 120.0))
    keys.last.key.should eq(65)
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
