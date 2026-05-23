require "./spec_helper"

describe Qt6 do
  it "supports list and tree widgets for editor panels" do
    application = app
    list_widget = Qt6::ListWidget.new
    tree_widget = Qt6::TreeWidget.new
    row_changes = [] of Int32
    tree_changes = 0

    list_widget.on_current_row_changed do |row|
      row_changes << row
    end

    terrain_item = list_widget.add_item("Terrain")
    roads_item = list_widget.insert_item(1, "Roads")
    unit_item = Qt6::ListWidgetItem.new("Units")
    list_widget.add_item(unit_item)
    list_widget.current_item = unit_item

    tree_widget.on_current_item_changed do
      tree_changes += 1
    end

    tree_widget.column_count = 2
    tree_widget.header_label = "Layer"
    tree_widget.set_header_label(1, "State")
    root_item = tree_widget.add_top_level_item("Terrain")
    root_item.set_text(1, "Visible")
    child_item = Qt6::TreeWidgetItem.new("Contours")
    child_item.set_text(1, "Locked")
    root_item.add_child(child_item)
    overlay_item = Qt6::TreeWidgetItem.new("Units")
    overlay_item.set_text(1, "Hidden")
    tree_widget.add_top_level_item(overlay_item)
    tree_widget.current_item = child_item
    tree_widget.expand_all
    application.process_events

    list_widget.count.should eq(3)
    terrain_item.text.should eq("Terrain")
    roads_item.text.should eq("Roads")
    list_widget.row(roads_item).should eq(1)
    list_widget.item(1).not_nil!.text.should eq("Roads")
    list_widget.item_text(0).should eq("Terrain")
    list_widget.current_row.should eq(2)
    list_widget.current_item.not_nil!.text.should eq("Units")
    list_widget.current_text.should eq("Units")
    row_changes.last.should eq(2)

    tree_widget.column_count.should eq(2)
    tree_widget.header_label.should eq("Layer")
    tree_widget.header_label(1).should eq("State")
    tree_widget.top_level_item_count.should eq(2)
    tree_widget.top_level_item(0).not_nil!.text.should eq("Terrain")
    root_item.child_count.should eq(1)
    root_item.child(0).not_nil!.text.should eq("Contours")
    root_item.child(0).not_nil!.text(1).should eq("Locked")
    tree_widget.current_item.not_nil!.text.should eq("Contours")
    tree_widget.current_item_text(1).should eq("Locked")
    tree_changes.should be >= 1

    list_widget.clear
    tree_widget.collapse_all
    tree_widget.clear

    list_widget.count.should eq(0)
    tree_widget.top_level_item_count.should eq(0)
    list_widget.release
    tree_widget.release
  end

  it "supports advanced list widget item hooks and reorder state" do
    application = app
    list_widget = Qt6::ListWidget.new
    list_widget.resize(240, 180)
    list_widget.show
    icon_path = File.join(Dir.tempdir, "crystal-qt6-list-widget-item-#{Process.pid}.png")

    changed_texts = [] of String
    double_clicked_texts = [] of String
    rows_moved = 0

    list_widget.on_item_changed do |item|
      changed_texts << item.text
    end

    list_widget.on_item_double_clicked do |item|
      double_clicked_texts << item.text
    end

    list_widget.on_rows_moved do
      rows_moved += 1
    end

    list_widget.drag_drop_mode = Qt6::ItemViewDragDropMode::InternalMove
    list_widget.selection_mode = Qt6::ItemSelectionMode::ExtendedSelection
    list_widget.default_drop_action = Qt6::DropAction::MoveAction

    icon_image = Qt6::QImage.new(8, 8)
    icon_image.fill(Qt6::Color.new(32, 96, 192))
    icon_image.save(icon_path).should be_true
    terrain_icon = Qt6::QIcon.from_file(icon_path)
    terrain_item = Qt6::ListWidgetItem.new(terrain_icon, "Terrain")
    terrain_item.flags = Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable | Qt6::ItemFlag::UserCheckable | Qt6::ItemFlag::DragEnabled | Qt6::ItemFlag::DropEnabled
    terrain_item.check_state = Qt6::CheckState::Checked
    terrain_item.set_data("ground", Qt6::ItemDataRole::User)
    terrain_item.foreground = Qt6::Color.new(32, 96, 192)
    terrain_item.background = Qt6::QBrush.new(Qt6::Color.new(228, 236, 248))
    terrain_font = terrain_item.font
    terrain_font.bold = true
    terrain_item.font = terrain_font
    terrain_item.tool_tip = "Terrain controls"
    terrain_item.status_tip = "Toggle terrain visibility"
    terrain_item.whats_this = "Used for managing terrain-related layers."
    terrain_item.text_alignment = Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter
    terrain_item.size_hint = Qt6::Size.new(140, 30)
    list_widget.add_item(terrain_item)
    list_widget.add_item("Units")
    list_widget.add_item("Roads")
    application.process_events

    terrain_item.hidden = true
    application.process_events
    terrain_item.hidden?.should be_true
    terrain_item.hidden = false
    terrain_item.selected = true
    terrain_item.text = "Terrain Layer"
    application.process_events

    list_widget.sort_items(Qt6::SortOrder::Descending)
    application.process_events
    list_widget.move_item(1, 2).should be_true
    application.process_events
    Qt6::LibQt6.qt6cr_list_widget_emit_item_double_clicked(list_widget.to_unsafe, 2)
    application.process_events

    list_widget.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::InternalMove)
    list_widget.selection_mode.should eq(Qt6::ItemSelectionMode::ExtendedSelection)
    list_widget.default_drop_action.should eq(Qt6::DropAction::MoveAction)
    terrain_item.flags.includes?(Qt6::ItemFlag::Editable).should be_true
    terrain_item.flags.includes?(Qt6::ItemFlag::UserCheckable).should be_true
    terrain_item.check_state.should eq(Qt6::CheckState::Checked)
    terrain_item.data(Qt6::ItemDataRole::User).should eq("ground")
    terrain_item.icon.null?.should be_false
    terrain_item.foreground.should eq(Qt6::Color.new(32, 96, 192, 255))
    terrain_item.background.color.should eq(Qt6::Color.new(228, 236, 248, 255))
    terrain_item.font.bold?.should be_true
    terrain_item.tool_tip.should eq("Terrain controls")
    terrain_item.status_tip.should eq("Toggle terrain visibility")
    terrain_item.whats_this.should eq("Used for managing terrain-related layers.")
    terrain_item.text_alignment.includes?(Qt6::AlignmentFlag::Right).should be_true
    terrain_item.text_alignment.includes?(Qt6::AlignmentFlag::VCenter).should be_true
    terrain_item.size_hint.should eq(Qt6::Size.new(140, 30))
    terrain_item.selected?.should be_true
    terrain_item.hidden?.should be_false
    changed_texts.includes?("Terrain Layer").should be_true
    list_widget.item_text(2).should eq("Terrain Layer")
    double_clicked_texts.should eq(["Terrain Layer"])
    rows_moved.should be >= 1

    File.delete(icon_path) if File.exists?(icon_path)
    terrain_icon.release
    icon_image.release
    list_widget.release
  end

  it "supports item-view editor polish for widgets and model views" do
    application = app
    list_widget = Qt6::ListWidget.new
    tree_widget = Qt6::TreeWidget.new
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new
    list_model = Qt6::StandardItemModel.new(list_view)
    tree_model = Qt6::StandardItemModel.new(tree_view)

    list_widget.spacing = 2

    tree_widget.header_hidden = true
    category_item = Qt6::TreeWidgetItem.new("Guides")
    category_item.flags = category_item.flags & ~Qt6::ItemFlag::Selectable
    category_font = category_item.font
    category_font.bold = true
    category_item.font = category_font
    category_item.foreground = Qt6::Color.new(90, 90, 90)
    category_item << Qt6::TreeWidgetItem.new("  Layers")
    tree_widget << category_item
    tree_widget.expand_all

    list_model << Qt6::StandardItem.new("Terrain")
    list_model << Qt6::StandardItem.new("Units")
    list_model.set_item(0, 1, Qt6::StandardItem.new("Ground"))
    list_model.set_item(1, 1, Qt6::StandardItem.new("Air"))

    root_item = Qt6::StandardItem.new("Terrain")
    root_item.set_child(0, 0, Qt6::StandardItem.new("Contours"))
    tree_model << root_item

    list_view.model = list_model
    list_view.selection_mode = Qt6::ItemSelectionMode::SingleSelection
    list_view.alternating_row_colors = true
    list_view.flow = Qt6::ListViewFlow::LeftToRight
    list_view.wrapping = true
    list_view.resize_mode = Qt6::ListViewResizeMode::Adjust
    list_view.layout_mode = Qt6::ListViewLayoutMode::Batched
    list_view.view_mode = Qt6::ListViewViewMode::IconMode
    list_view.movement = Qt6::ListViewMovement::Snap
    list_view.spacing = 6
    list_view.grid_size = Qt6::Size.new(96, 48)
    list_view.model_column = 1
    list_view.uniform_item_sizes = true
    list_view.word_wrap = true
    list_view.selection_rect_visible = true
    list_view.batch_size = 4
    list_view.set_row_hidden(1, true)

    tree_view.model = tree_model
    tree_view.selection_mode = Qt6::ItemSelectionMode::SingleSelection
    tree_view.alternating_row_colors = true
    tree_view.header_hidden = true
    tree_view.root_is_decorated = false
    tree_view.uniform_row_heights = true
    tree_view.indentation = 14
    tree_view.expand_all
    application.process_events

    list_widget.spacing.should eq(2)
    tree_widget.header_hidden?.should be_true
    category_item.flags.includes?(Qt6::ItemFlag::Selectable).should be_false
    category_item.font.bold?.should be_true
    category_item.foreground.should eq(Qt6::Color.new(90, 90, 90, 255))
    category_item.child_count.should eq(1)

    list_view.selection_mode.should eq(Qt6::ItemSelectionMode::SingleSelection)
    list_view.alternating_row_colors?.should be_true
    list_view.flow.should eq(Qt6::ListViewFlow::LeftToRight)
    list_view.wrapping?.should be_true
    list_view.resize_mode.should eq(Qt6::ListViewResizeMode::Adjust)
    list_view.layout_mode.should eq(Qt6::ListViewLayoutMode::Batched)
    list_view.view_mode.should eq(Qt6::ListViewViewMode::IconMode)
    list_view.movement.should eq(Qt6::ListViewMovement::Snap)
    list_view.spacing.should eq(6)
    list_view.grid_size.should eq(Qt6::Size.new(96, 48))
    list_view.model_column.should eq(1)
    list_view.uniform_item_sizes?.should be_true
    list_view.word_wrap?.should be_true
    list_view.selection_rect_visible?.should be_true
    list_view.batch_size.should eq(4)
    list_view.row_hidden?(1).should be_true
    tree_view.selection_mode.should eq(Qt6::ItemSelectionMode::SingleSelection)
    tree_view.alternating_row_colors?.should be_true
    tree_view.header.should be_a(Qt6::HeaderView)
    tree_view.header_hidden?.should be_true
    tree_view.root_is_decorated?.should be_false
    tree_view.uniform_row_heights?.should be_true
    tree_view.indentation.should eq(14)

    list_view.release
    tree_view.release
    list_widget.release
    tree_widget.release
  end

  it "supports standard item icons" do
    app
    icon = Qt6::QIcon.from_theme("document-open")
    item = Qt6::StandardItem.new("Layer")

    icon.should be_a(Qt6::QIcon)
    item.icon.null?.should be_true

    item.icon = icon
    item.icon.should be_a(Qt6::QIcon)

    item.release
    icon.release
  end

  it "supports standard item interaction flags" do
    app
    item = Qt6::StandardItem.new("Layer")

    item.flags.includes?(Qt6::ItemFlag::Enabled).should be_true
    item.flags.includes?(Qt6::ItemFlag::Selectable).should be_true
    item.flags.includes?(Qt6::ItemFlag::DragEnabled).should be_true
    item.flags.includes?(Qt6::ItemFlag::DropEnabled).should be_true

    item.flags = Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::DragEnabled

    item.flags.includes?(Qt6::ItemFlag::Enabled).should be_true
    item.flags.includes?(Qt6::ItemFlag::Selectable).should be_true
    item.flags.includes?(Qt6::ItemFlag::DragEnabled).should be_true
    item.flags.includes?(Qt6::ItemFlag::DropEnabled).should be_false
    item.flags.includes?(Qt6::ItemFlag::Editable).should be_false

    item.release
  end

  it "supports styled item delegate paint and size hint hooks" do
    application = app
    list_view = Qt6::ListView.new
    model = Qt6::StandardItemModel.new(list_view)
    delegate = Qt6::StyledItemDelegate.new(list_view)
    item = Qt6::StandardItem.new("Terrain\n2 tracks")
    option = Qt6::StyleOptionViewItem.new
    canvas = Qt6::QImage.new(80, 30)
    direct_index = nil.as(Qt6::ModelIndex?)
    paint_calls = 0
    size_hint_calls = 0
    size_hint_index_valid_values = [] of Bool
    size_hint_rect_widths = [] of Float64
    painter_active_values = [] of Bool
    paint_index_rows = [] of Int32
    paint_rect_widths = [] of Float64
    text_rect_widths = [] of Float64
    selected_states = [] of Bool
    enabled_states = [] of Bool
    font_handles_seen = 0
    palette_handles_seen = 0

    delegate.on_size_hint do |option, index|
      size_hint_calls += 1
      size_hint_index_valid_values << index.valid?
      size_hint_rect_widths << option.rect.width
      Qt6::Size.new(0, 44)
    end

    delegate.on_paint do |painter, option, index|
      font = option.font
      palette = option.palette

      paint_calls += 1
      painter_active_values << painter.active?
      paint_index_rows << index.row
      paint_rect_widths << option.rect.width
      text_rect_widths << option.text_rect.width
      selected_states << option.selected?
      enabled_states << option.enabled?
      font_handles_seen += 1 unless font.to_unsafe.null?
      palette_handles_seen += 1 unless palette.to_unsafe.null?
      option.draw_background(painter)
      option.draw_decoration(painter)
      font.release
      palette.release

      false
    end

    model << item
    list_view.model = model
    list_view.item_delegate = delegate
    list_view.icon_size = Qt6::Size.new(24, 26)
    list_view.resize(240, 120)
    list_view.show
    option.init_from(list_view)
    option.rect = Qt6::Rect.new(0, 0, 80, 30)
    direct_index = model.index(0)
    5.times { application.process_events }
    delegate.size_hint(option, direct_index.not_nil!).should eq(Qt6::Size.new(0, 44))
    Qt6::QPainter.paint(canvas) do |painter|
      delegate.paint(painter, option, direct_index.not_nil!)
    end
    snapshot = list_view.grab
    application.process_events

    list_view.icon_size.should eq(Qt6::Size.new(24, 26))
    snapshot.null?.should be_false
    size_hint_calls.should be > 0
    size_hint_index_valid_values.should contain(true)
    size_hint_rect_widths.max.should be >= 0
    paint_calls.should be > 0
    painter_active_values.should contain(true)
    paint_index_rows.should contain(0)
    paint_rect_widths.max.should be > 0
    text_rect_widths.max.should be > 0
    selected_states.size.should eq(paint_calls)
    enabled_states.should contain(true)
    font_handles_seen.should eq(paint_calls)
    palette_handles_seen.should eq(paint_calls)

    direct_index.try(&.release)
    canvas.release
    option.release
    snapshot.release
    list_view.release
  end

  it "supports item delegate paint and size hint hooks" do
    application = app
    list_view = Qt6::ListView.new
    model = Qt6::StandardItemModel.new(list_view)
    delegate = Qt6::ItemDelegate.new(list_view)
    item = Qt6::StandardItem.new("Terrain\n2 tracks")
    paint_calls = 0
    size_hint_calls = 0
    paint_index_rows = [] of Int32
    option_widths = [] of Float64

    delegate.clipping = false

    delegate.on_size_hint do |option, index|
      size_hint_calls += 1
      option_widths << option.rect.width
      index.valid?.should be_true
      Qt6::Size.new(0, 40)
    end

    delegate.on_paint do |painter, option, index|
      paint_calls += 1
      painter.active?.should be_true
      paint_index_rows << index.row
      option_widths << option.rect.width
      false
    end

    model << item
    list_view.model = model
    list_view.item_delegate = delegate
    list_view.resize(240, 120)
    list_view.show
    5.times { application.process_events }
    snapshot = list_view.grab
    application.process_events

    delegate.clipping?.should be_false
    list_view.item_delegate.not_nil!.to_unsafe.should eq(delegate.to_unsafe)
    snapshot.null?.should be_false
    size_hint_calls.should be > 0
    paint_calls.should be > 0
    paint_index_rows.should contain(0)
    option_widths.max.should be >= 0

    snapshot.release
    list_view.release
  end

  it "supports model-view panels with roles, delegates, and proxy sorting/filtering" do
    application = app
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new
    list_model = Qt6::StandardItemModel.new(list_view)
    tree_model = Qt6::StandardItemModel.new(tree_view)
    proxy_model = Qt6::SortFilterProxyModel.new(list_view)
    delegate = Qt6::StyledItemDelegate.new(list_view)
    list_changes = 0
    tree_changes = 0

    list_view.on_current_index_changed do
      list_changes += 1
    end

    tree_view.on_current_index_changed do
      tree_changes += 1
    end

    terrain_list_item = Qt6::StandardItem.new("Terrain")
    terrain_list_item.set_data("Terrain tools", Qt6::ItemDataRole::ToolTip)
    terrain_list_item.set_data(20, Qt6::ItemDataRole::User)
    units_list_item = Qt6::StandardItem.new("Units")
    units_list_item.set_data(Qt6::Color.new(0, 64, 192), Qt6::ItemDataRole::Foreground)
    units_list_item.set_data(10, Qt6::ItemDataRole::User)
    list_model << terrain_list_item
    list_model << units_list_item

    tree_model.set_horizontal_header_label(0, "Layer")
    tree_model.set_horizontal_header_label(1, "State")
    terrain_item = Qt6::StandardItem.new("Terrain")
    terrain_state = Qt6::StandardItem.new("Visible")
    tree_model.set_item(0, 0, terrain_item)
    tree_model.set_item(0, 1, terrain_state)
    contour_item = Qt6::StandardItem.new("Contours")
    contour_state = Qt6::StandardItem.new("Locked")
    terrain_item.set_child(0, 0, contour_item)
    terrain_item.set_child(0, 1, contour_state)

    terrain_state_index = tree_model.index(0, 1)
    tree_model.set_data(terrain_state_index, "Shown", Qt6::ItemDataRole::Edit).should be_true

    delegate.on_display_text do |text|
      ">> #{text.upcase}"
    end

    proxy_model.source_model = list_model
    proxy_model.sort_role = Qt6::ItemDataRole::User
    proxy_model.filter_role = Qt6::ItemDataRole::Display
    proxy_model.filter_case_sensitivity = Qt6::CaseSensitivity::Insensitive
    proxy_model.dynamic_sort_filter = true
    proxy_model.sort
    proxy_model.sort_column.should eq(0)
    proxy_model.sort_order.should eq(Qt6::SortOrder::Ascending)

    list_view.model = proxy_model
    list_view.item_delegate = delegate
    tree_view.model = tree_model
    tree_view.expand_all

    list_index = proxy_model.index(0)
    tree_index = tree_model.index_from_item(contour_item)
    list_view.current_index = list_index
    tree_view.current_index = tree_index
    application.process_events

    current_list_index = list_view.current_index
    current_tree_index = tree_view.current_index
    source_list_index = proxy_model.map_to_source(current_list_index)

    list_model.row_count.should eq(2)
    list_model.column_count.should eq(1)
    list_model.item(0).not_nil!.text.should eq("Terrain")
    terrain_list_item.data(Qt6::ItemDataRole::ToolTip).should eq("Terrain tools")
    units_list_item.data(Qt6::ItemDataRole::Foreground).should eq(Qt6::Color.new(0, 64, 192, 255))
    list_model.data(source_list_index, Qt6::ItemDataRole::User).should eq(10)
    proxy_model.data(current_list_index).should eq("Units")
    delegate.display_text(proxy_model.data(current_list_index)).should eq(">> UNITS")
    current_list_index.valid?.should be_true
    current_list_index.row.should eq(0)
    current_list_index.column.should eq(0)
    source_list_index.row.should eq(1)
    list_changes.should be >= 1

    proxy_model.filter_regular_expression = "uni.*"
    proxy_model.filter_pattern.should eq("uni.*")
    proxy_model.invalidate
    application.process_events
    proxy_model.row_count.should eq(1)
    proxy_model.clear_filter
    proxy_model.invalidate
    proxy_model.sort(0, Qt6::SortOrder::Descending)
    application.process_events
    proxy_model.row_count.should eq(2)
    proxy_model.sort_column.should eq(0)
    proxy_model.sort_order.should eq(Qt6::SortOrder::Descending)
    sorted_proxy_index = proxy_model.index(0)
    proxy_model.data(sorted_proxy_index).should eq("Terrain")

    tree_proxy = Qt6::SortFilterProxyModel.new(tree_view)
    tree_proxy.source_model = tree_model
    tree_proxy.filter_case_sensitivity = Qt6::CaseSensitivity::Insensitive
    tree_proxy.recursive_filtering_enabled = true
    tree_proxy.filter_regular_expression = "contour"
    tree_proxy.invalidate
    application.process_events

    terrain_proxy_index = tree_proxy.index(0, 0)
    contour_proxy_index = tree_proxy.index(0, 0, terrain_proxy_index)
    contour_source_index = tree_proxy.map_to_source(contour_proxy_index)
    contour_proxy_roundtrip = tree_proxy.map_from_source(tree_model.index_from_item(contour_item))

    tree_model.row_count.should eq(1)
    tree_model.column_count.should eq(2)
    tree_model.horizontal_header_label.should eq("Layer")
    tree_model.horizontal_header_label(1).should eq("State")
    tree_model.data(terrain_state_index).should eq("Shown")
    terrain_item.row_count.should eq(1)
    terrain_item.child(0).not_nil!.text.should eq("Contours")
    terrain_item.child(0, 1).not_nil!.text.should eq("Locked")
    current_tree_index.valid?.should be_true
    current_tree_index.row.should eq(0)
    current_tree_index.column.should eq(0)
    tree_model.item_from_index(current_tree_index).not_nil!.text.should eq("Contours")
    tree_changes.should be >= 1
    tree_proxy.recursive_filtering_enabled?.should be_true
    tree_proxy.filter_pattern.should eq("contour")
    tree_proxy.row_count.should eq(1)
    tree_proxy.row_count(terrain_proxy_index).should eq(1)
    tree_proxy.data(terrain_proxy_index).should eq("Terrain")
    tree_proxy.data(contour_proxy_index).should eq("Contours")
    tree_model.data(contour_source_index).should eq("Contours")
    contour_proxy_roundtrip.valid?.should be_true
    contour_proxy_roundtrip.row.should eq(0)

    contour_proxy_roundtrip.release
    contour_source_index.release
    contour_proxy_index.release
    terrain_proxy_index.release
    sorted_proxy_index.release
    tree_proxy.release
    current_list_index.release
    current_tree_index.release
    source_list_index.release
    terrain_state_index.release
    list_index.release
    tree_index.release
    list_view.release
    tree_view.release
  end

  it "supports data widget mappers for form-style model editing" do
    application = app
    model = Qt6::StandardItemModel.new
    group_item = Qt6::StandardItem.new("Layers")
    name_item = Qt6::StandardItem.new("Terrain")
    visible_item = Qt6::StandardItem.new
    visible_item.set_data(true, Qt6::ItemDataRole::Edit)
    units_name_item = Qt6::StandardItem.new("Units")
    units_visible_item = Qt6::StandardItem.new
    units_visible_item.set_data(false, Qt6::ItemDataRole::Edit)
    group_item.set_child(0, 0, name_item)
    group_item.set_child(0, 1, visible_item)
    group_item.set_child(1, 0, units_name_item)
    group_item.set_child(1, 1, units_visible_item)
    model << group_item

    root_index = model.index_from_item(group_item)
    second_row_index = model.index(1, 0, root_index)

    host = Qt6::Widget.new
    name_edit = Qt6::LineEdit.new("", host)
    visible_check = Qt6::CheckBox.new("Visible", host)
    delegate = Qt6::StyledItemDelegate.new(host)
    mapper = Qt6::DataWidgetMapper.new(host)
    mapper_changes = [] of Int32

    mapper.on_current_index_changed do |value|
      mapper_changes << value
    end

    mapper.model = model
    mapper.item_delegate = delegate
    mapper.root_index = root_index
    mapper.orientation = Qt6::Orientation::Horizontal
    mapper.submit_policy = Qt6::DataWidgetMapperSubmitPolicy::ManualSubmit
    mapper.add_mapping(name_edit, 0)
    mapper.add_mapping(visible_check, 1, "checked")
    mapper.to_first
    application.process_events

    mapper.model.not_nil!.to_unsafe.should eq(model.to_unsafe)
    mapper.item_delegate.not_nil!.to_unsafe.should eq(delegate.to_unsafe)
    mapper.root_index.valid?.should be_true
    mapper.root_index.row.should eq(root_index.row)
    mapper.orientation.should eq(Qt6::Orientation::Horizontal)
    mapper.submit_policy.should eq(Qt6::DataWidgetMapperSubmitPolicy::ManualSubmit)
    mapper.current_index.should eq(0)
    mapper.mapped_section(name_edit).should eq(0)
    mapper.mapped_section(visible_check).should eq(1)
    mapper.mapped_property_name(name_edit).should eq("text")
    mapper.mapped_property_name(visible_check).should eq("checked")
    mapper.mapped_widget_at(0).not_nil!.to_unsafe.should eq(name_edit.to_unsafe)
    mapper.mapped_widget_at(1).not_nil!.to_unsafe.should eq(visible_check.to_unsafe)
    name_edit.text.should eq("Terrain")
    visible_check.checked?.should be_true

    name_edit.text = "Terrain Layer"
    visible_check.checked = false
    mapper.submit.should be_true
    application.process_events

    model.data(model.index(0, 0, root_index), Qt6::ItemDataRole::Edit).should eq("Terrain Layer")
    model.data(model.index(0, 1, root_index), Qt6::ItemDataRole::Edit).should eq(false)

    name_edit.text = "Temp"
    visible_check.checked = true
    mapper.revert
    application.process_events
    name_edit.text.should eq("Terrain Layer")
    visible_check.checked?.should be_false

    mapper.to_last
    application.process_events
    mapper.current_index.should eq(1)
    name_edit.text.should eq("Units")
    visible_check.checked?.should be_false
    mapper_changes.last.should eq(1)

    mapper.to_previous
    application.process_events
    mapper.current_index.should eq(0)

    mapper.set_current_model_index(second_row_index)
    application.process_events
    mapper.current_index.should eq(1)
    name_edit.text.should eq("Units")

    mapper.submit_policy = Qt6::DataWidgetMapperSubmitPolicy::AutoSubmit
    mapper.submit_policy.should eq(Qt6::DataWidgetMapperSubmitPolicy::AutoSubmit)
    mapper.set_current_index(0).should eq(0)
    application.process_events
    mapper.current_index.should eq(0)
    mapper_changes.last.should eq(0)
    name_edit.text.should eq("Terrain Layer")
    visible_check.checked?.should be_false

    mapper.to_next
    application.process_events
    mapper.current_index.should eq(1)
    mapper_changes.last.should eq(1)
    name_edit.text.should eq("Units")
    visible_check.checked?.should be_false

    mapper.remove_mapping(visible_check)
    mapper.mapped_section(visible_check).should eq(-1)
    mapper.mapped_widget_at(1).should be_nil
    mapper.clear_mapping
    mapper.mapped_section(name_edit).should eq(-1)
    mapper.mapped_widget_at(0).should be_nil

    second_row_index.release
    root_index.release
    host.release
    model.release
  end

  it "supports model drag sources and model-view drops" do
    application = app
    model = DraggableLayerListModel.new(["Terrain", "Units", "Roads"])
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new

    list_view.model = model
    tree_view.model = model

    list_view.drag_enabled = true
    list_view.drag_drop_mode = Qt6::ItemViewDragDropMode::InternalMove
    list_view.default_drop_action = Qt6::DropAction::MoveAction
    list_view.drop_indicator_shown = true
    list_view.accept_drops = true

    tree_view.drag_enabled = true
    tree_view.drag_drop_mode = Qt6::ItemViewDragDropMode::DragDrop
    tree_view.default_drop_action = Qt6::DropAction::MoveAction
    tree_view.drop_indicator_shown = true
    tree_view.accept_drops = true

    dragged_index = model.index(1)
    payload = model.mime_data([dragged_index]).not_nil!

    payload.text.should eq("Units")
    payload.has_format?(DraggableLayerListModel::MIME_TYPE).should be_true
    String.new(payload.data(DraggableLayerListModel::MIME_TYPE)).should eq("Units")
    model.mime_types.should eq([DraggableLayerListModel::MIME_TYPE, "text/plain"])
    model.supported_drag_actions.includes?(Qt6::DropAction::MoveAction).should be_true
    model.supported_drop_actions.includes?(Qt6::DropAction::MoveAction).should be_true

    model.drop_mime_data(payload, Qt6::DropAction::MoveAction, 0).should be_true
    application.process_events

    model.layers.should eq(["Units", "Terrain", "Roads"])
    list_view.drag_enabled?.should be_true
    list_view.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::InternalMove)
    list_view.default_drop_action.should eq(Qt6::DropAction::MoveAction)
    list_view.drop_indicator_shown?.should be_true
    list_view.accept_drops?.should be_true
    tree_view.drag_enabled?.should be_true
    tree_view.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::DragDrop)
    tree_view.default_drop_action.should eq(Qt6::DropAction::MoveAction)
    tree_view.drop_indicator_shown?.should be_true
    tree_view.accept_drops?.should be_true
    model.data(model.index(0)).should eq("Units")

    payload.release
    dragged_index.release
    list_view.release
    tree_view.release
  end

  it "supports table views and table widgets" do
    application = app
    table_view = Qt6::TableView.new
    table_widget = Qt6::TableWidget.new
    model = Qt6::StandardItemModel.new(table_view)
    current_index_changes = 0
    current_cell_changes = 0
    changed_item_texts = [] of String
    double_clicked_item_texts = [] of String

    table_view.on_current_index_changed do
      current_index_changes += 1
    end

    table_widget.on_current_cell_changed do
      current_cell_changes += 1
    end

    table_widget.on_item_changed do |item|
      changed_item_texts << item.text
    end

    table_widget.on_item_double_clicked do |item|
      double_clicked_item_texts << item.text
    end

    model.set_horizontal_header_label(0, "Layer")
    model.set_horizontal_header_label(1, "State")
    model.set_item(0, 0, Qt6::StandardItem.new("Terrain"))
    model.set_item(0, 1, Qt6::StandardItem.new("Visible"))
    model.set_item(1, 0, Qt6::StandardItem.new("Units"))
    model.set_item(1, 1, Qt6::StandardItem.new("Hidden"))

    table_view.model = model
    table_view.selection_mode = Qt6::ItemSelectionMode::SingleSelection
    table_view.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
    table_view.alternating_row_colors = true
    table_view.show_grid = false
    table_view.word_wrap = false
    table_view.sorting_enabled = true
    table_view.drag_enabled = true
    table_view.drag_drop_mode = Qt6::ItemViewDragDropMode::DragOnly
    table_view.default_drop_action = Qt6::DropAction::CopyAction
    table_view.drop_indicator_shown = true

    horizontal_header = table_view.horizontal_header
    horizontal_header.default_section_size = 96
    horizontal_header.minimum_section_size = 40
    horizontal_header.maximum_section_size = 180
    horizontal_header.default_alignment = Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter
    horizontal_header.stretch_last_section = true
    horizontal_header.sections_movable = true
    horizontal_header.sections_clickable = true
    horizontal_header.highlight_sections = false
    horizontal_header.cascading_section_resizes = true
    horizontal_header.set_section_resize_mode(0, Qt6::HeaderResizeMode::Fixed)
    horizontal_header.resize_section(0, 120)
    vertical_header = table_view.vertical_header
    vertical_header.default_section_size = 32
    vertical_header.set_section_hidden(1, true)

    selected_index = model.index(1, 1)
    table_view.current_index = selected_index
    table_view.set_span(0, 0, 1, 2)
    table_view.sort_by_column(0, Qt6::SortOrder::Descending)
    table_view.resize_columns_to_contents
    table_view.resize_rows_to_contents
    horizontal_header.move_section(0, 1)

    table_widget.row_count = 2
    table_widget.column_count = 2
    table_widget.set_horizontal_header_label(0, "Layer")
    table_widget.set_horizontal_header_label(1, "Visible")
    table_widget.set_vertical_header_label(0, "Base")
    table_widget.set_vertical_header_label(1, "Overlay")
    table_widget.selection_mode = Qt6::ItemSelectionMode::SingleSelection
    table_widget.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
    table_widget.alternating_row_colors = true
    table_widget.show_grid = false

    terrain_item = Qt6::TableWidgetItem.new("Terrain")
    terrain_item.flags = Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable
    terrain_item.set_data("terrain", Qt6::ItemDataRole::User)
    visible_item = Qt6::TableWidgetItem.new("Shown")
    visible_item.check_state = Qt6::CheckState::Checked
    visible_item.foreground = Qt6::Color.new(24, 120, 48)

    table_widget.set_item(0, 0, terrain_item)
    table_widget.set_item(0, 1, visible_item)
    terrain_item.text = "Terrain Layer"
    table_widget.set_span(1, 0, 1, 2)
    table_widget.set_current_cell(0, 1)
    table_widget.sort_by_column(0, Qt6::SortOrder::Descending)
    table_widget.resize_columns_to_contents
    table_widget.resize_rows_to_contents
    application.process_events
    Qt6::LibQt6.qt6cr_table_widget_emit_item_double_clicked(table_widget.to_unsafe, 0, 0)
    application.process_events

    current_index = table_view.current_index

    table_view.selection_mode.should eq(Qt6::ItemSelectionMode::SingleSelection)
    table_view.selection_behavior.should eq(Qt6::ItemSelectionBehavior::SelectRows)
    table_view.alternating_row_colors?.should be_true
    table_view.show_grid?.should be_false
    table_view.word_wrap?.should be_false
    table_view.sorting_enabled?.should be_true
    table_view.drag_enabled?.should be_true
    table_view.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::DragOnly)
    table_view.default_drop_action.should eq(Qt6::DropAction::CopyAction)
    table_view.drop_indicator_shown?.should be_true
    current_index.valid?.should be_true
    current_index.row.should eq(1)
    current_index.column.should eq(1)
    current_index_changes.should be >= 1
    horizontal_header.count.should eq(2)
    horizontal_header.orientation.should eq(Qt6::Orientation::Horizontal)
    horizontal_header.default_section_size.should eq(96)
    horizontal_header.minimum_section_size.should eq(40)
    horizontal_header.maximum_section_size.should eq(180)
    horizontal_header.default_alignment.should eq(Qt6::AlignmentFlag::Right | Qt6::AlignmentFlag::VCenter)
    horizontal_header.stretch_last_section?.should be_true
    horizontal_header.sections_movable?.should be_true
    horizontal_header.sections_clickable?.should be_true
    horizontal_header.highlight_sections?.should be_false
    horizontal_header.cascading_section_resizes?.should be_true
    horizontal_header.length.should be > 0
    horizontal_header.offset.should be >= 0
    horizontal_header.section_size(0).should be > 0
    horizontal_header.section_resize_mode(0).should eq(Qt6::HeaderResizeMode::Fixed)
    horizontal_header.visual_index(0).should eq(1)
    horizontal_header.visual_index(1).should eq(0)
    horizontal_header.logical_index(0).should eq(1)
    horizontal_header.logical_index(1).should eq(0)
    vertical_header.count.should eq(2)
    vertical_header.orientation.should eq(Qt6::Orientation::Vertical)
    vertical_header.hidden_section_count.should eq(1)
    vertical_header.default_section_size.should eq(32)
    vertical_header.section_hidden?(1).should be_true
    table_view.row_span(0, 0).should eq(1)
    table_view.column_span(0, 0).should eq(2)
    first_sorted_index = model.index(0, 0)
    model.data(first_sorted_index).should eq("Units")

    table_widget.row_count.should eq(2)
    table_widget.column_count.should eq(2)
    table_widget.horizontal_header_label.should eq("Layer")
    table_widget.horizontal_header_label(1).should eq("Visible")
    table_widget.vertical_header_label.should eq("Base")
    table_widget.vertical_header_label(1).should eq("Overlay")
    table_widget.selection_mode.should eq(Qt6::ItemSelectionMode::SingleSelection)
    table_widget.selection_behavior.should eq(Qt6::ItemSelectionBehavior::SelectRows)
    table_widget.alternating_row_colors?.should be_true
    table_widget.show_grid?.should be_false
    table_widget.current_row.should eq(0)
    table_widget.current_column.should eq(1)
    table_widget.current_item.not_nil!.text.should eq("Shown")
    table_widget.item(0, 0).not_nil!.text.should eq("Terrain Layer")
    table_widget.item(0, 0).not_nil!.data(Qt6::ItemDataRole::User).should eq("terrain")
    table_widget.item(0, 1).not_nil!.check_state.should eq(Qt6::CheckState::Checked)
    table_widget.item(0, 1).not_nil!.foreground.should eq(Qt6::Color.new(24, 120, 48, 255))
    current_cell_changes.should be >= 1
    changed_item_texts.includes?("Terrain Layer").should be_true
    double_clicked_item_texts.should eq(["Terrain Layer"])
    table_widget.horizontal_header.count.should eq(2)
    table_widget.horizontal_header.section_size(0).should be > 0
    table_widget.vertical_header.count.should eq(2)
    table_widget.row_span(1, 0).should eq(1)
    table_widget.column_span(1, 0).should eq(2)

    first_sorted_index.release
    current_index.release
    selected_index.release
    table_view.release
    table_widget.release
  end

  it "supports item view viewport access and hit testing" do
    application = app
    host = Qt6::Widget.new
    table = Qt6::TableView.new(host)
    model = Qt6::StandardItemModel.new(table)

    model.set_item(0, 0, Qt6::StandardItem.new("One"))
    model.set_item(1, 0, Qt6::StandardItem.new("Two"))

    table.model = model
    table.drag_enabled = true
    table.accept_drops = true
    table.drag_drop_mode = Qt6::ItemViewDragDropMode::DragDrop
    table.drag_drop_overwrite_mode = false
    table.default_drop_action = Qt6::DropAction::MoveAction
    table.drop_indicator_shown = true

    host.vbox do |column|
      column << table
    end
    host.resize(240, 160)
    host.show
    application.process_events

    viewport = table.viewport
    index = table.index_at(Qt6::PointF.new(10.0, 10.0))
    rect = table.visual_rect(index)

    viewport.should be_a(Qt6::Widget)
    index.valid?.should be_true
    rect.width.should be > 0.0
    rect.height.should be > 0.0
    table.drag_enabled?.should be_true
    table.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::DragDrop)
    table.drag_drop_overwrite_mode?.should be_false
    table.default_drop_action.should eq(Qt6::DropAction::MoveAction)
    table.drop_indicator_shown?.should be_true

    index.release
    host.release
  end

  it "supports shared abstract item view navigation and scroll helpers" do
    application = app
    host = Qt6::Widget.new
    tree_view = Qt6::TreeView.new(host)
    model = Qt6::StandardItemModel.new(tree_view)
    delegate = Qt6::StyledItemDelegate.new(tree_view)
    branch = Qt6::StandardItem.new("Layers")

    40.times do |index|
      branch.append_row(Qt6::StandardItem.new("Layer #{index}"))
    end
    model.append_row(branch)

    root_index = model.index(0)
    target_index = model.index(25, 0, root_index)

    tree_view.model = model
    tree_view.item_delegate = delegate
    tree_view.root_index = root_index
    tree_view.selection_mode = Qt6::ItemSelectionMode::ExtendedSelection
    tree_view.auto_scroll = false
    tree_view.auto_scroll_margin = 18
    tree_view.tab_key_navigation = true
    tree_view.vertical_scroll_bar_policy = Qt6::ScrollBarPolicy::AsNeeded
    tree_view.horizontal_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOff

    host.vbox do |column|
      column << tree_view
    end
    host.resize(220, 140)
    host.show
    application.process_events

    tree_view.scroll_to(target_index, Qt6::ScrollHint::PositionAtCenter)
    application.process_events
    tree_view.select_all
    application.process_events

    tree_view.item_delegate.not_nil!.to_unsafe.should eq(delegate.to_unsafe)
    tree_view.root_index.valid?.should be_true
    tree_view.root_index.row.should eq(0)
    tree_view.auto_scroll?.should be_false
    tree_view.auto_scroll_margin.should eq(18)
    tree_view.tab_key_navigation?.should be_true
    tree_view.vertical_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AsNeeded)
    tree_view.horizontal_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOff)
    tree_view.vertical_scroll_bar.orientation.should eq(Qt6::Orientation::Vertical)
    tree_view.horizontal_scroll_bar.orientation.should eq(Qt6::Orientation::Horizontal)
    tree_view.selection_model.not_nil!.has_selection?.should be_true
    tree_view.vertical_scroll_bar.value.should be > 0

    tree_view.clear_selection
    application.process_events
    tree_view.selection_model.not_nil!.has_selection?.should be_false

    tree_view.scroll_to_bottom
    application.process_events
    tree_view.vertical_scroll_bar.value.should be > 0

    tree_view.scroll_to_top
    application.process_events
    tree_view.vertical_scroll_bar.value.should eq(0)

    target_index.release
    root_index.release
    host.release
  end

  it "supports custom delegate editor creation and commit hooks" do
    app
    host = Qt6::Widget.new
    model = Qt6::StandardItemModel.new(host)
    item = Qt6::StandardItem.new("terrain")
    model << item
    index = model.index(0)
    delegate = Qt6::StyledItemDelegate.new(host)
    created_editors = [] of Qt6::LineEdit
    populated_values = [] of Qt6::ModelData
    committed_values = [] of String

    delegate.on_create_editor do |parent, editor_index|
      editor_index.row.should eq(0)
      editor = Qt6::LineEdit.new(parent: parent)
      created_editors << editor
      editor
    end

    delegate.on_set_editor_data do |editor, value, editor_index|
      editor_index.column.should eq(0)
      line_edit = editor.as(Qt6::LineEdit)
      populated_values << value
      line_edit.text = "#{value}-editor"
    end

    delegate.on_set_model_data do |editor, target_model, editor_index|
      line_edit = editor.as(Qt6::LineEdit)
      committed_values << line_edit.text
      target_model.set_data(editor_index, line_edit.text.upcase)
    end

    editor = delegate.create_editor(host, index)
    editor.should be_a(Qt6::LineEdit)
    line_edit = editor.as(Qt6::LineEdit)
    delegate.set_editor_data(line_edit, index)
    line_edit.text.should eq("terrain-editor")
    line_edit.text = "contours"
    delegate.set_model_data(line_edit, model, index)

    created_editors.size.should eq(1)
    populated_values.should eq(["terrain"])
    committed_values.should eq(["contours"])
    model.data(index).should eq("CONTOURS")

    index.release
    host.release
  end

  it "supports option-aware delegate editor hooks and item editor factories" do
    app
    host = Qt6::Widget.new
    model = Qt6::StandardItemModel.new(host)
    item = Qt6::StandardItem.new("terrain")
    model << item
    index = model.index(0)
    delegate = Qt6::StyledItemDelegate.new(host)
    factory = Qt6::QItemEditorFactory.new
    initialized_indexes = [] of Int32
    created_indexes = [] of Int32
    geometry_indexes = [] of Int32
    option_widths = [] of Float64

    delegate.item_editor_factory.should be_nil
    delegate.set_item_editor_factory(factory).to_unsafe.should eq(delegate.to_unsafe)
    delegate.item_editor_factory.not_nil!.to_unsafe.should eq(factory.to_unsafe)

    delegate.on_init_style_option do |option, option_index|
      initialized_indexes << option_index.row
      option_widths << option.rect.width
    end

    delegate.on_create_editor_with_option do |parent, option, editor_index|
      created_indexes << editor_index.row
      option_widths << option.rect.width
      Qt6::LineEdit.new(parent: parent)
    end

    delegate.on_update_editor_geometry do |editor, option, editor_index|
      geometry_indexes << editor_index.row
      option_widths << option.rect.width
      editor.resize(80, 22)
    end

    option = delegate.init_style_option(index)
    editor = delegate.create_editor(host, option, index)
    editor.should be_a(Qt6::LineEdit)
    delegate.update_editor_geometry(editor.not_nil!, option, index)

    initialized_indexes.should contain(0)
    created_indexes.should eq([0])
    geometry_indexes.should eq([0])
    option_widths.all? { |width| width >= 0 }.should be_true

    delegate.set_item_editor_factory(nil).to_unsafe.should eq(delegate.to_unsafe)
    delegate.item_editor_factory.should be_nil

    option.release
    factory.release
    index.release
    host.release
  end

  it "supports item editor creators and factory registration" do
    app
    host = Qt6::Widget.new
    model = Qt6::StandardItemModel.new(host)
    item = Qt6::StandardItem.new("terrain")
    model << item
    index = model.index(0)
    delegate = Qt6::StyledItemDelegate.new(host)
    factory = Qt6::QItemEditorFactory.new
    string_creator = Qt6::QItemEditorCreator.new("text")
    int_creator = Qt6::QItemEditorCreatorBase.new("value")
    string_creations = [] of Pointer(Void)
    int_creations = [] of Pointer(Void)

    string_creator.on_create_widget do |parent|
      editor = Qt6::LineEdit.new(parent: parent)
      string_creations << editor.to_unsafe
      editor
    end

    int_creator.on_create_widget do |parent|
      editor = Qt6::SpinBox.new(parent: parent)
      int_creations << editor.to_unsafe
      editor
    end

    string_creator.value_property_name.should eq("text")
    int_creator.value_property_name.should eq("value")

    preview_line_edit = string_creator.create_widget(host)
    preview_line_edit.should be_a(Qt6::LineEdit)
    preview_line_edit.not_nil!.release

    preview_spin_box = int_creator.create_widget(host)
    preview_spin_box.should be_a(Qt6::SpinBox)
    preview_spin_box.not_nil!.release

    factory.register_editor_for("terrain", string_creator)
    factory.register_editor_for(1, int_creator)
    factory.value_property_name_for("terrain").should eq("text")
    factory.value_property_name_for(1).should eq("value")

    string_editor = factory.create_editor_for("terrain", host)
    string_editor.should be_a(Qt6::LineEdit)
    int_editor = factory.create_editor_for(1, host)
    int_editor.should be_a(Qt6::SpinBox)

    delegate.item_editor_factory = factory
    delegate_editor = delegate.create_editor(host, index)
    delegate_editor.should_not be_nil

    string_creations.size.should be >= 2
    int_creations.size.should be >= 2

    delegate_editor.try(&.release)
    string_editor.try(&.release)
    int_editor.try(&.release)

    standard_factory = Qt6::QItemEditorFactory.new
    standard_string_creator = Qt6::QStandardItemEditorCreator.new
    standard_bool_creator = Qt6::QStandardItemEditorCreator.new

    standard_string_creator.value_property_name.should eq("")
    standard_bool_creator.value_property_name.should eq("")

    standard_string_creator.on_create_widget do |parent|
      Qt6::LineEdit.new(parent: parent)
    end

    standard_bool_creator.on_create_widget do |parent|
      Qt6::CheckBox.new(parent: parent)
    end

    standard_line_edit = standard_string_creator.create_widget(host)
    standard_line_edit.should be_a(Qt6::LineEdit)
    standard_string_creator.value_property_name.should eq("text")

    standard_check_box = standard_bool_creator.create_widget(host)
    standard_check_box.should be_a(Qt6::CheckBox)
    standard_bool_creator.value_property_name.should eq("checked")

    standard_factory.register_editor_for("terrain", standard_string_creator)
    standard_factory.register_editor_for(true, standard_bool_creator)
    standard_factory.value_property_name_for("terrain").should eq("text")
    standard_factory.value_property_name_for(true).should eq("checked")

    standard_string_editor = standard_factory.create_editor_for("terrain", host)
    standard_string_editor.should be_a(Qt6::LineEdit)
    standard_bool_editor = standard_factory.create_editor_for(true, host)
    standard_bool_editor.should be_a(Qt6::CheckBox)

    standard_string_editor.try(&.release)
    standard_bool_editor.try(&.release)
    standard_line_edit.try(&.release)
    standard_check_box.try(&.release)
    standard_factory.release
    index.release
    host.release
  end

  it "supports item delegate editor hooks, factories, and mapper/view assignment" do
    app
    host = Qt6::Widget.new
    model = Qt6::StandardItemModel.new(host)
    item = Qt6::StandardItem.new("terrain")
    model << item
    index = model.index(0)
    option = Qt6::StyleOptionViewItem.new
    delegate = Qt6::ItemDelegate.new(host)
    factory = Qt6::QItemEditorFactory.new
    mapper = Qt6::DataWidgetMapper.new(host)
    list_view = Qt6::ListView.new(host)
    created_indexes = [] of Int32
    geometry_indexes = [] of Int32
    populated_values = [] of Qt6::ModelData
    committed_values = [] of String
    option_widths = [] of Float64

    delegate.item_editor_factory.should be_nil
    delegate.item_editor_factory = factory
    delegate.item_editor_factory.not_nil!.to_unsafe.should eq(factory.to_unsafe)

    delegate.on_display_text do |text|
      "<< #{text.upcase}"
    end

    delegate.on_create_editor_with_option do |parent, style_option, editor_index|
      created_indexes << editor_index.row
      option_widths << style_option.rect.width
      Qt6::LineEdit.new(parent: parent)
    end

    delegate.on_set_editor_data do |editor, value, _editor_index|
      populated_values << value
      editor.as(Qt6::LineEdit).text = "#{value}-editor"
    end

    delegate.on_set_model_data do |editor, target_model, editor_index|
      line_edit = editor.as(Qt6::LineEdit)
      committed_values << line_edit.text
      target_model.set_data(editor_index, line_edit.text.upcase)
    end

    delegate.on_update_editor_geometry do |editor, style_option, editor_index|
      geometry_indexes << editor_index.row
      option_widths << style_option.rect.width
      editor.resize(84, 24)
    end

    list_view.model = model
    list_view.item_delegate = delegate
    mapper.model = model
    mapper.item_delegate = delegate

    editor = delegate.create_editor(host, option, index)
    editor.should be_a(Qt6::LineEdit)
    line_edit = editor.as(Qt6::LineEdit)
    delegate.set_editor_data(line_edit, index)
    line_edit.text.should eq("terrain-editor")
    line_edit.text = "contours"
    delegate.update_editor_geometry(line_edit, option, index)
    delegate.set_model_data(line_edit, model, index)

    delegate.display_text("terrain").should eq("<< TERRAIN")
    list_view.item_delegate.not_nil!.to_unsafe.should eq(delegate.to_unsafe)
    mapper.item_delegate.not_nil!.to_unsafe.should eq(delegate.to_unsafe)
    created_indexes.should eq([0])
    geometry_indexes.should eq([0])
    populated_values.should eq(["terrain"])
    committed_values.should eq(["contours"])
    option_widths.all? { |width| width >= 0 }.should be_true
    model.data(index).should eq("CONTOURS")

    delegate.item_editor_factory = nil
    delegate.item_editor_factory.should be_nil

    option.release
    factory.release
    index.release
    host.release
  end

  it "supports edit triggers and persistent editors in item views" do
    application = app
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new
    table_view = Qt6::TableView.new
    table_widget = Qt6::TableWidget.new

    list_model = Qt6::StandardItemModel.new(list_view)
    list_model << Qt6::StandardItem.new("Terrain")

    tree_model = Qt6::StandardItemModel.new(tree_view)
    branch = Qt6::StandardItem.new("Units")
    branch.append_row(Qt6::StandardItem.new("Infantry"))
    tree_model.append_row(branch)

    table_model = Qt6::StandardItemModel.new(table_view)
    table_model.set_item(0, 0, Qt6::StandardItem.new("Layer"))

    delegate = Qt6::StyledItemDelegate.new(list_view)
    delegate.on_create_editor do |parent, _index|
      Qt6::LineEdit.new(parent: parent)
    end

    list_view.model = list_model
    tree_view.model = tree_model
    table_view.model = table_model

    list_view.item_delegate = delegate
    tree_view.item_delegate = delegate
    table_view.item_delegate = delegate

    list_index = list_model.index(0)
    tree_index = tree_model.index(0, 0)
    table_index = table_model.index(0, 0)

    list_view.edit_triggers = Qt6::EditTrigger::DoubleClicked | Qt6::EditTrigger::EditKeyPressed
    tree_view.edit_triggers = Qt6::EditTrigger::CurrentChanged | Qt6::EditTrigger::SelectedClicked
    table_view.edit_triggers = Qt6::EditTrigger::AllEditTriggers

    list_view.open_persistent_editor(list_index)
    tree_view.open_persistent_editor(tree_index)
    table_view.open_persistent_editor(table_index)

    table_widget.row_count = 1
    table_widget.column_count = 1
    table_widget.edit_triggers = Qt6::EditTrigger::AnyKeyPressed | Qt6::EditTrigger::EditKeyPressed
    table_item = Qt6::TableWidgetItem.new("Visible")
    table_widget.set_item(0, 0, table_item)
    table_widget.open_persistent_editor(table_item)

    application.process_events

    list_view.edit_triggers.should eq(Qt6::EditTrigger::DoubleClicked | Qt6::EditTrigger::EditKeyPressed)
    tree_view.edit_triggers.should eq(Qt6::EditTrigger::CurrentChanged | Qt6::EditTrigger::SelectedClicked)
    table_view.edit_triggers.should eq(Qt6::EditTrigger::AllEditTriggers)
    table_widget.edit_triggers.should eq(Qt6::EditTrigger::AnyKeyPressed | Qt6::EditTrigger::EditKeyPressed)

    list_view.persistent_editor_open?(list_index).should be_true
    tree_view.persistent_editor_open?(tree_index).should be_true
    table_view.persistent_editor_open?(table_index).should be_true
    table_widget.persistent_editor_open?(table_item).should be_true

    list_view.close_persistent_editor(list_index)
    tree_view.close_persistent_editor(tree_index)
    table_view.close_persistent_editor(table_index)
    table_widget.close_persistent_editor(table_item)

    application.process_events

    list_view.persistent_editor_open?(list_index).should be_false
    tree_view.persistent_editor_open?(tree_index).should be_false
    table_view.persistent_editor_open?(table_index).should be_false
    table_widget.persistent_editor_open?(table_item).should be_false

    list_index.release
    tree_index.release
    table_index.release
    list_view.release
    tree_view.release
    table_view.release
    table_widget.release
  end

  it "supports proxy headers and shared selection models across views" do
    application = app
    list_view = Qt6::ListView.new
    tree_view = Qt6::TreeView.new
    source_model = Qt6::StandardItemModel.new(list_view)
    proxy_model = Qt6::SortFilterProxyModel.new(list_view)
    source_model << Qt6::StandardItem.new("Terrain")
    source_model << Qt6::StandardItem.new("Units")
    source_model.set_header_data(0, "Panel", Qt6::Orientation::Horizontal).should be_true
    proxy_model.source_model = source_model
    list_view.model = proxy_model
    tree_view.model = proxy_model

    shared_selection = Qt6::ItemSelectionModel.new(proxy_model, list_view)
    selection_changes = 0
    list_changes = 0
    tree_changes = 0

    shared_selection.on_current_index_changed do
      selection_changes += 1
    end

    list_view.on_current_index_changed do
      list_changes += 1
    end

    tree_view.on_current_index_changed do
      tree_changes += 1
    end

    list_view.selection_model = shared_selection
    tree_view.selection_model = shared_selection

    units_index = proxy_model.index(1)
    list_view.current_index = units_index
    application.process_events

    proxy_model.header_data.should eq("Panel")
    list_view.selection_model.not_nil!.current_index.row.should eq(1)
    tree_view.selection_model.not_nil!.current_index.row.should eq(1)
    tree_view.current_index.row.should eq(1)
    selection_changes.should be >= 1
    list_changes.should be >= 1
    tree_changes.should be >= 1

    units_index.release
    list_view.release
    tree_view.release
  end

  it "supports selection-model commands and model-index convenience helpers" do
    application = app
    list_view = Qt6::ListView.new
    model = Qt6::StandardItemModel.new(list_view)
    model << Qt6::StandardItem.new("Terrain")
    model << Qt6::StandardItem.new("Units")
    list_view.model = model

    selection_model = Qt6::ItemSelectionModel.new(model, list_view)
    list_view.selection_model = selection_model

    terrain_index = model.index(0)
    units_index = model.index(1)
    parent_index = units_index.parent(model)

    units_index.data(model).should eq("Units")
    units_index.set_data(model, "Counter").should be_true
    units_index.data(model).should eq("Counter")
    units_index.flags(model).should eq(model.flags(units_index))
    parent_index.valid?.should be_false

    selection_model.current_index.valid?.should be_false

    selection_model.current_index = terrain_index
    application.process_events
    selection_model.current_index.row.should eq(0)

    selection_model.select(units_index, Qt6::SelectionFlag::ClearAndSelect)
    application.process_events

    selection_model.current_index.row.should eq(0)
    selection_model.has_selection?.should be_true
    selection_model.selected?(units_index).should be_true
    selection_model.selected?(terrain_index).should be_false

    selection_model.set_current_index(units_index, Qt6::SelectionFlag::Current)
    application.process_events
    selection_model.current_index.row.should eq(1)

    selection_model.clear_selection
    application.process_events
    selection_model.has_selection?.should be_false

    selection_model.clear
    application.process_events
    selection_model.current_index.valid?.should be_false

    terrain_index.release
    units_index.release
    parent_index.release
    list_view.release
  end

  it "shares abstract item-view coverage across item-based widgets" do
    application = app
    list_widget = Qt6::ListWidget.new
    tree_widget = Qt6::TreeWidget.new
    table_widget = Qt6::TableWidget.new

    list_widget << "Terrain"
    list_widget << "Units"
    tree_widget.column_count = 1
    tree_root = Qt6::TreeWidgetItem.new("Layers")
    tree_widget << tree_root
    table_widget.row_count = 1
    table_widget.column_count = 1
    table_widget.set_item(0, 0, Qt6::TableWidgetItem.new("Visible"))

    list_widget.selection_mode = Qt6::ItemSelectionMode::ExtendedSelection
    list_widget.drag_enabled = true
    list_widget.drag_drop_mode = Qt6::ItemViewDragDropMode::InternalMove
    list_widget.default_drop_action = Qt6::DropAction::MoveAction
    list_widget.drop_indicator_shown = true
    list_widget.edit_triggers = Qt6::EditTrigger::SelectedClicked

    tree_widget.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
    tree_widget.alternating_row_colors = true
    tree_widget.drag_enabled = true
    tree_widget.drop_indicator_shown = true

    table_widget.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
    table_widget.alternating_row_colors = true

    list_widget.current_row = 1
    tree_widget.current_item = tree_root
    table_widget.set_current_cell(0, 0)
    application.process_events

    list_index = list_widget.current_index
    tree_index = tree_widget.current_index
    table_index = table_widget.current_index

    list_widget.selection_mode.should eq(Qt6::ItemSelectionMode::ExtendedSelection)
    list_widget.drag_enabled?.should be_true
    list_widget.drag_drop_mode.should eq(Qt6::ItemViewDragDropMode::InternalMove)
    list_widget.default_drop_action.should eq(Qt6::DropAction::MoveAction)
    list_widget.drop_indicator_shown?.should be_true
    list_widget.edit_triggers.should eq(Qt6::EditTrigger::SelectedClicked)
    list_widget.selection_model.should_not be_nil
    list_index.row.should eq(1)

    tree_widget.selection_behavior.should eq(Qt6::ItemSelectionBehavior::SelectRows)
    tree_widget.alternating_row_colors?.should be_true
    tree_widget.drag_enabled?.should be_true
    tree_widget.drop_indicator_shown?.should be_true
    tree_widget.selection_model.should_not be_nil
    tree_index.valid?.should be_true
    tree_index.row.should eq(0)

    table_widget.selection_behavior.should eq(Qt6::ItemSelectionBehavior::SelectRows)
    table_widget.alternating_row_colors?.should be_true
    table_widget.selection_model.should_not be_nil
    table_index.row.should eq(0)
    table_index.column.should eq(0)

    list_index.release
    tree_index.release
    table_index.release
    list_widget.release
    tree_widget.release
    table_widget.release
  end

  it "shares abstract scroll-area policies and scroll bars across descendants" do
    app
    scroll_area = Qt6::ScrollArea.new
    text_edit = Qt6::TextEdit.new("alpha\nbeta\ngamma")
    plain_text_edit = Qt6::PlainTextEdit.new("delta\nepsilon\nzeta")

    scroll_area.widget = Qt6::Label.new("Scrollable")
    scroll_area.vertical_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOff
    text_edit.horizontal_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOn
    plain_text_edit.vertical_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOn

    scroll_area.vertical_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOff)
    text_edit.horizontal_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOn)
    plain_text_edit.vertical_scroll_bar_policy.should eq(Qt6::ScrollBarPolicy::AlwaysOn)

    scroll_area.vertical_scroll_bar.orientation.should eq(Qt6::Orientation::Vertical)
    scroll_area.horizontal_scroll_bar.orientation.should eq(Qt6::Orientation::Horizontal)
    text_edit.vertical_scroll_bar.orientation.should eq(Qt6::Orientation::Vertical)
    plain_text_edit.horizontal_scroll_bar.orientation.should eq(Qt6::Orientation::Horizontal)

    scroll_area.release
    text_edit.release
    plain_text_edit.release
  end

  it "shares abstract scroll-area viewport, corner, and size-adjust helpers" do
    application = app
    main = Qt6::MainWindow.new
    host = Qt6::Widget.new
    layout = host.vbox do |column|
      column.spacing = 4
    end
    scroll_area = Qt6::ScrollArea.new
    text_edit = Qt6::TextEdit.new("alpha\nbeta\ngamma")
    plain_text_edit = Qt6::PlainTextEdit.new("delta\nepsilon\nzeta")
    content = Qt6::Label.new("Scrollable content")
    corner = Qt6::Label.new("Corner")

    content.set_fixed_size(320, 160)
    scroll_area.widget = content
    scroll_area.vertical_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOn
    scroll_area.horizontal_scroll_bar_policy = Qt6::ScrollBarPolicy::AlwaysOn
    scroll_area.corner_widget = corner
    scroll_area.size_adjust_policy = Qt6::AbstractScrollAreaSizeAdjustPolicy::AdjustToContentsOnFirstShow
    text_edit.size_adjust_policy = Qt6::AbstractScrollAreaSizeAdjustPolicy::AdjustIgnored
    plain_text_edit.size_adjust_policy = Qt6::AbstractScrollAreaSizeAdjustPolicy::AdjustToContents

    layout << scroll_area
    layout << text_edit
    layout << plain_text_edit
    main.central_widget = host
    main.resize(260, 320)
    main.show
    application.process_events

    scroll_area.viewport.should be_a(Qt6::Widget)
    text_edit.viewport.should be_a(Qt6::Widget)
    plain_text_edit.viewport.should be_a(Qt6::Widget)
    scroll_area.corner_widget.not_nil!.to_unsafe.should eq(corner.to_unsafe)
    scroll_area.maximum_viewport_size.width.should be > 0
    scroll_area.maximum_viewport_size.height.should be > 0
    text_edit.maximum_viewport_size.width.should be > 0
    plain_text_edit.maximum_viewport_size.height.should be > 0
    scroll_area.size_adjust_policy.should eq(Qt6::AbstractScrollAreaSizeAdjustPolicy::AdjustToContentsOnFirstShow)
    text_edit.size_adjust_policy.should eq(Qt6::AbstractScrollAreaSizeAdjustPolicy::AdjustIgnored)
    plain_text_edit.size_adjust_policy.should eq(Qt6::AbstractScrollAreaSizeAdjustPolicy::AdjustToContents)

    scroll_area.corner_widget = nil
    scroll_area.corner_widget.should be_nil

    main.release
  end

  it "exposes scroll-area content access and visibility helpers" do
    application = app
    main = Qt6::MainWindow.new
    main.resize(320, 240)

    scroll_area = Qt6::ScrollArea.new
    scroll_area.widget_resizable = false
    scroll_area.set_fixed_size(220, 140)

    content = Qt6::Widget.new
    content.set_fixed_size(900, 900)

    anchor = Qt6::Label.new("Anchor", content)
    anchor.move(720, 760)
    anchor.set_fixed_size(80, 24)

    scroll_area.widget = content
    main.central_widget = scroll_area

    main.show
    application.process_events

    scroll_area.widget.should_not be_nil
    scroll_area.widget.not_nil!.size.should eq(Qt6::Size.new(900, 900))
    scroll_area.size_hint.width.should be > 0
    scroll_area.size_hint.height.should be > 0
    scroll_area.vertical_scroll_bar.value.should eq(0)
    scroll_area.horizontal_scroll_bar.value.should eq(0)

    scroll_area.ensure_visible(780, 820, 10, 10)
    application.process_events
    scroll_area.vertical_scroll_bar.value.should be > 0
    scroll_area.horizontal_scroll_bar.value.should be > 0

    scroll_area.vertical_scroll_bar.value = 0
    scroll_area.horizontal_scroll_bar.value = 0
    scroll_area.ensure_widget_visible(anchor, 10, 10)
    application.process_events
    scroll_area.vertical_scroll_bar.value.should be > 0
    scroll_area.horizontal_scroll_bar.value.should be > 0

    taken = scroll_area.take_widget
    taken.should_not be_nil
    scroll_area.widget.should be_nil
    taken.not_nil!.size.should eq(Qt6::Size.new(900, 900))
    taken.not_nil!.release

    main.release
  end

  it "hosts a verified editor slice with undo, settings, clipboard, canvas interaction, and PNG export" do
    application = app
    state = EditorVerticalSliceSpecState.new
    main = Qt6::MainWindow.new
    main.window_title = "Vertical Slice Spec"
    main.resize(960, 680)
    status_bar = main.status_bar
    canvas = Qt6::EventWidget.new
    canvas.resize(720, 480)
    export_path = File.join(Dir.tempdir, "crystal-qt6-vertical-slice-#{Process.pid}.png")
    settings_path = File.join(Dir.tempdir, "crystal-qt6-vertical-slice-settings-#{Process.pid}.ini")
    File.delete?(export_path)
    File.delete?(settings_path)

    settings = Qt6::QSettings.new(settings_path)
    undo_stack = Qt6::UndoStack.new(main)
    save_action = Qt6::Action.new("Mark Saved", main)
    save_action.shortcut = "Ctrl+S"
    undo_action = undo_stack.create_undo_action(main, "Undo")
    redo_action = undo_stack.create_redo_action(main, "Redo")

    persist_state = -> do
      settings.set_value("ui/active_layer", state.active_layer)
      settings.set_value("view/zoom", state.zoom)
      settings.set_value("view/pan_x", state.pan_x)
      settings.set_value("view/pan_y", state.pan_y)
      settings.set_value("view/grid_spacing", state.grid_spacing)
      settings.set_value("view/marker_size", state.marker_size)
      settings.set_value("view/show_grid", state.show_grid)
      settings.sync
    end

    update_dirty_state = -> do
      dirty = !undo_stack.clean?
      main.window_title = dirty ? "Vertical Slice Spec *" : "Vertical Slice Spec"
      save_action.enabled = dirty
    end

    undo_stack.on_clean_changed { |_clean| update_dirty_state.call }
    undo_stack.on_index_changed { |_index| update_dirty_state.call }

    save_action.on_triggered do
      undo_stack.set_clean
      persist_state.call
      update_dirty_state.call
      status_bar.show_message("State marked saved", 1200)
    end

    grid_pen = Qt6::QPen.new(Qt6::Color.new(198, 206, 214), 1.0)
    frame_pen = Qt6::QPen.new(Qt6::Color.new(72, 80, 90), 2.0)
    route_pen = Qt6::QPen.new(state.accent, 3.0)
    hud_font = Qt6::QFont.new(point_size: 11, bold: true)

    scene_to_view = ->(point : Qt6::PointF) do
      Qt6::PointF.new(state.pan_x + point.x * state.zoom, state.pan_y + point.y * state.zoom)
    end

    copy_snapshot_action = Qt6::Action.new("Copy Snapshot", main)
    copy_snapshot_action.shortcut = "Ctrl+Shift+X"
    copy_snapshot_action.on_triggered do
      summary = "Layer #{state.active_layer}, zoom #{state.zoom.round(2)}x, grid #{state.grid_spacing}, marker #{state.marker_size}"
      payload = Qt6::MimeData.new
      payload.text = summary
      payload.html = "<strong>#{state.active_layer}</strong>"
      payload.image = canvas.grab.to_image
      payload.set_data("application/x-crystal-qt6-editor-state", summary)
      Qt6.clipboard.mime_data = payload
      status_bar.show_message("Copied snapshot", 1200)
    end

    canvas.on_mouse_press do |event|
      state.dragging = true
      state.last_pointer = event.position
    end

    canvas.on_mouse_move do |event|
      next unless state.dragging

      state.pan_x += event.position.x - state.last_pointer.x
      state.pan_y += event.position.y - state.last_pointer.y
      state.last_pointer = event.position
      canvas.update
    end

    canvas.on_mouse_release do |_event|
      state.dragging = false
      persist_state.call
    end

    canvas.on_wheel do |event|
      state.zoom = (state.zoom * (event.angle_delta.y >= 0 ? 1.1 : 0.9)).clamp(0.5, 3.0)
      persist_state.call
      canvas.update
    end

    canvas.on_paint_with_painter do |event, painter|
      painter.fill_rect(event.rect, Qt6::Color.new(245, 243, 238))

      scene_rect = Qt6::RectF.new(0.0, 0.0, 520.0, 320.0)
      painter.pen = frame_pen
      painter.brush = Qt6::Color.new(255, 255, 255)
      painter.draw_rect(Qt6::RectF.new(state.pan_x, state.pan_y, scene_rect.width * state.zoom, scene_rect.height * state.zoom))

      if state.show_grid
        painter.pen = grid_pen
        x = 0
        while x <= scene_rect.width
          painter.draw_line(scene_to_view.call(Qt6::PointF.new(x.to_f, 0.0)), scene_to_view.call(Qt6::PointF.new(x.to_f, scene_rect.height)))
          x += state.grid_spacing
        end

        y = 0
        while y <= scene_rect.height
          painter.draw_line(scene_to_view.call(Qt6::PointF.new(0.0, y.to_f)), scene_to_view.call(Qt6::PointF.new(scene_rect.width, y.to_f)))
          y += state.grid_spacing
        end
      end

      route_pen.color = state.accent
      painter.pen = route_pen
      painter.brush = state.accent
      points = case state.active_layer
               when "Units"
                 [
                   Qt6::PointF.new(96.0, 88.0),
                   Qt6::PointF.new(180.0, 156.0),
                   Qt6::PointF.new(276.0, 132.0),
                 ]
               else
                 [
                   Qt6::PointF.new(112.0, 92.0),
                   Qt6::PointF.new(210.0, 142.0),
                   Qt6::PointF.new(308.0, 118.0),
                 ]
               end.map { |point| scene_to_view.call(point) }

      points.each_cons(2) do |segment|
        painter.draw_line(segment[0], segment[1])
      end

      points.each_with_index do |point, index|
        size = state.marker_size.to_f * state.zoom
        painter.draw_ellipse(Qt6::RectF.new(point.x - size / 2.0, point.y - size / 2.0, size, size))
        painter.draw_text(Qt6::PointF.new(point.x + size / 2.0 + 6.0, point.y + 4.0), "#{index + 1}")
      end

      painter.font = hud_font
      painter.pen = Qt6::Color.new(50, 56, 62)
      painter.draw_text(Qt6::PointF.new(18.0, 24.0), "Layer #{state.active_layer} | zoom #{state.zoom.round(2)}x")
    end

    main.central_widget = canvas

    layer_model = Qt6::StandardItemModel.new(main)
    terrain_item = Qt6::StandardItem.new("Terrain")
    terrain_item.set_data(10, Qt6::ItemDataRole::User)
    units_item = Qt6::StandardItem.new("Units")
    units_item.set_data(20, Qt6::ItemDataRole::User)
    layer_model.set_item(0, 0, terrain_item)
    layer_model.set_item(0, 1, Qt6::StandardItem.new("Visible"))
    layer_model.set_item(1, 0, units_item)
    layer_model.set_item(1, 1, Qt6::StandardItem.new("Visible"))
    layer_model.set_horizontal_header_label(0, "Layer")
    layer_model.set_horizontal_header_label(1, "State")

    proxy_model = Qt6::SortFilterProxyModel.new(main)
    proxy_model.source_model = layer_model
    proxy_model.sort_role = Qt6::ItemDataRole::User
    proxy_model.sort

    tree_view = Qt6::TreeView.new
    tree_view.model = proxy_model
    selection_model = Qt6::ItemSelectionModel.new(proxy_model, tree_view)
    tree_view.selection_model = selection_model

    syncing_selection = false
    select_layer = ->(layer_name : String) do
      syncing_selection = true
      begin
        proxy_model.row_count.times do |row|
          index = proxy_model.index(row, 0)
          if proxy_model.data(index).to_s == layer_name
            tree_view.current_index = index
            index.release
            break
          end
          index.release
        end
      ensure
        syncing_selection = false
      end
    end

    apply_snapshot = ->(snapshot : EditorVerticalSliceSpecSnapshot, message : String?) do
      restore_editor_slice_spec(state, snapshot)
      select_layer.call(state.active_layer)
      persist_state.call
      status_bar.show_message(message, 1200) if message
      canvas.update
    end

    push_change = ->(label : String, before : EditorVerticalSliceSpecSnapshot, after : EditorVerticalSliceSpecSnapshot, message : String?) do
      undo_stack.push(Qt6::UndoCommand.new(
        label,
        redo: -> { apply_snapshot.call(after, message) },
        undo: -> { apply_snapshot.call(before, "Undid #{label.downcase}") }
      ))
      update_dirty_state.call
    end

    tree_view.on_current_index_changed do
      next if syncing_selection

      current = tree_view.current_index
      if current.valid?
        name_index = proxy_model.index(current.row, 0)
        layer_name = proxy_model.data(name_index).to_s
        unless layer_name == state.active_layer
          before = snapshot_editor_slice_spec(state)
          state.apply_layer(layer_name)
          after = snapshot_editor_slice_spec(state)
          restore_editor_slice_spec(state, before)
          push_change.call("Switch to #{layer_name}", before, after, "Active #{layer_name}")
        end
        name_index.release
      end
      current.release
      canvas.update
    end

    layers_dock = Qt6::DockWidget.new("Layers", main)
    layers_dock.widget = Qt6::Widget.new.tap do |panel|
      panel.vbox do |column|
        column << Qt6::Label.new("Manager")
        column << tree_view
      end
    end
    main.add_dock_widget(layers_dock, Qt6::DockArea::Left)

    inspector_dock = Qt6::DockWidget.new("Inspector", main)
    inspector_dock.widget = Qt6::Widget.new.tap do |panel|
      panel.form do |form|
        form.add_row("Layer", Qt6::Label.new("Driven by the manager dock"))
        form.add_row(Qt6::PushButton.new("Reset View").tap do |button|
          button.on_clicked do
            before = snapshot_editor_slice_spec(state)
            state.zoom = 1.0
            state.pan_x = 24.0
            state.pan_y = 28.0
            after = snapshot_editor_slice_spec(state)
            restore_editor_slice_spec(state, before)
            push_change.call("Reset view", before, after, "View reset")
          end
        end)
      end
    end
    main.add_dock_widget(inspector_dock, Qt6::DockArea::Right)

    file_menu = main.menu_bar.add_menu("File")
    export_action = Qt6::Action.new("Export PNG", main)
    export_action.shortcut = "Ctrl+E"
    export_action.on_triggered do
      canvas.grab.save(export_path).should be_true
      status_bar.show_message("Exported PNG", 1200)
    end
    file_menu << export_action
    file_menu << save_action

    edit_menu = main.menu_bar.add_menu("Edit")
    edit_menu << undo_action
    edit_menu << redo_action
    edit_menu << copy_snapshot_action

    toolbar = Qt6::ToolBar.new("Editor", main)
    toolbar << export_action
    toolbar << save_action
    toolbar << undo_action
    toolbar << redo_action
    toolbar << copy_snapshot_action
    main.add_tool_bar(toolbar)

    terrain_index = proxy_model.index(0, 0)
    tree_view.current_index = terrain_index
    terrain_index.release
    undo_stack.set_clean
    update_dirty_state.call
    persist_state.call

    units_index = proxy_model.index(1, 0)
    tree_view.current_index = units_index
    units_index.release

    main.show
    application.process_events

    state.active_layer.should eq("Units")
    state.grid_spacing.should eq(44)
    state.marker_size.should eq(22)
    settings.value("ui/active_layer").should eq("Units")
    settings.value("view/grid_spacing").should eq(44)
    undo_stack.clean?.should be_false
    undo_action.enabled?.should be_true
    save_action.enabled?.should be_true
    main.window_title.should eq("Vertical Slice Spec *")

    undo_action.trigger
    application.process_events
    state.active_layer.should eq("Terrain")
    undo_stack.clean?.should be_true
    redo_action.enabled?.should be_true
    main.window_title.should eq("Vertical Slice Spec")

    redo_action.trigger
    application.process_events
    state.active_layer.should eq("Units")
    undo_stack.clean?.should be_false

    save_action.trigger
    application.process_events
    undo_stack.clean?.should be_true
    save_action.enabled?.should be_false

    copy_snapshot_action.trigger
    application.process_events
    clipboard_payload = Qt6.clipboard.mime_data.not_nil!
    clipboard_payload.has_text?.should be_true
    clipboard_payload.text.should contain("Layer Units")
    clipboard_payload.has_image?.should be_true
    String.new(clipboard_payload.data("application/x-crystal-qt6-editor-state")).should contain("marker 22")

    zoom_before = state.zoom
    pan_x_before = state.pan_x
    pan_y_before = state.pan_y

    canvas.simulate_wheel(Qt6::PointF.new(180.0, 180.0))
    canvas.simulate_mouse_press(Qt6::PointF.new(140.0, 140.0))
    canvas.simulate_mouse_move(Qt6::PointF.new(196.0, 188.0), buttons: 1)
    canvas.simulate_mouse_release(Qt6::PointF.new(196.0, 188.0))
    5.times { application.process_events }

    export_action.trigger
    application.process_events

    png_header = File.open(export_path) do |file|
      bytes = Bytes.new(8)
      file.read_fully(bytes)
      bytes
    end

    state.active_layer.should eq("Units")
    proxy_model.header_data.should eq("Layer")
    tree_view.selection_model.not_nil!.current_index.row.should eq(1)
    state.zoom.should be > zoom_before
    state.pan_x.should be > pan_x_before
    state.pan_y.should be > pan_y_before
    settings.value("view/zoom").should eq(state.zoom)
    settings.value("view/pan_x").should eq(state.pan_x)
    settings.value("view/pan_y").should eq(state.pan_y)
    File.exists?(export_path).should be_true
    png_header.should eq(Bytes[0x89_u8, 0x50_u8, 0x4E_u8, 0x47_u8, 0x0D_u8, 0x0A_u8, 0x1A_u8, 0x0A_u8])

    Qt6.clipboard.clear
    File.delete?(export_path)
    File.delete?(settings_path)
    main.release
  end

  it "supports callback-backed abstract list models with edits and row notifications" do
    application = app
    model = EditableLayerListModel.new(["Terrain", "Units"])
    proxy = Qt6::SortFilterProxyModel.new
    proxy.source_model = model
    list_view = Qt6::ListView.new
    list_view.model = proxy

    delegate = Qt6::StyledItemDelegate.new(list_view)
    delegate.on_create_editor do |parent, _index|
      Qt6::LineEdit.new(parent: parent)
    end
    delegate.on_set_editor_data do |editor, value, _index|
      editor.as(Qt6::LineEdit).text = value.to_s
    end
    delegate.on_set_model_data do |editor, target_model, index|
      target_model.set_data(index, editor.as(Qt6::LineEdit).text).should be_true
    end
    list_view.item_delegate = delegate

    source_index = model.index(0)
    proxy_index = proxy.index(1)
    editor = delegate.create_editor(list_view, proxy_index)
    editor.should be_a(Qt6::LineEdit)
    line_edit = editor.as(Qt6::LineEdit)
    delegate.set_editor_data(line_edit, proxy_index)
    line_edit.text.should eq("Units")
    line_edit.text = "Counter"
    delegate.set_model_data(line_edit, proxy, proxy_index)
    application.process_events

    model.layers.should eq(["Terrain", "Counter"])
    proxy.data(proxy_index).should eq("Counter")
    proxy.header_data.should eq("Layer")
    model.flags(source_index).should eq(Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable)

    model.append_layer("Labels")
    application.process_events
    proxy.row_count.should eq(3)

    removed = model.remove_layer(0)
    application.process_events
    removed.should eq("Terrain")
    proxy.row_count.should eq(2)

    refreshed_index = proxy.index(0)
    proxy.data(refreshed_index).should eq("Counter")

    model.replace_layers(["Roads"])
    application.process_events
    proxy.row_count.should eq(1)

    reset_index = proxy.index(0)
    proxy.data(reset_index).should eq("Roads")

    source_index.release
    proxy_index.release
    refreshed_index.release
    reset_index.release
    list_view.release
    proxy.release
    model.release
  end

  it "supports callback-backed tree models in tree views" do
    application = app
    model = LayerTreeModel.new
    tree_view = Qt6::TreeView.new
    tree_view.model = model
    tree_view.expand_all

    terrain_index = model.index(0)
    contours_index = model.index(0, 0, terrain_index)
    units_index = model.index(1)
    parent_index = model.parent_index(contours_index)

    tree_changes = 0
    tree_view.on_current_index_changed do
      tree_changes += 1
    end

    tree_view.current_index = contours_index
    application.process_events
    model.set_data(contours_index, "Contours Overlay").should be_true
    application.process_events

    model.row_count.should eq(2)
    model.row_count(terrain_index).should eq(2)
    model.row_count(units_index).should eq(1)
    model.column_count(terrain_index).should eq(1)
    model.header_data.should eq("Layer")
    model.data(contours_index).should eq("Contours Overlay")
    parent_index.valid?.should be_true
    parent_index.row.should eq(0)
    parent_index.internal_id.should eq(1_u64)
    model.data(parent_index).should eq("Terrain")
    tree_view.current_index.internal_id.should eq(2_u64)
    tree_changes.should be >= 1

    parent_index.release
    units_index.release
    contours_index.release
    terrain_index.release
    tree_view.release
    model.release
  end

  it "supports mutable callback-backed tree models with row inserts, removals, and moves" do
    application = app
    model = MutableLayerTreeModel.new
    tree_view = Qt6::TreeView.new
    tree_view.model = model
    tree_view.expand_all

    terrain_index = model.index(0)
    terrain_index.internal_id.should eq(1_u64)

    model.append_child("Roads", terrain_index)
    application.process_events

    refreshed_terrain_index = model.index(0)
    roads_index = model.index(2, 0, refreshed_terrain_index)
    tree_view.current_index = roads_index
    application.process_events

    model.row_count(refreshed_terrain_index).should eq(3)
    model.data(roads_index).should eq("Roads")
    tree_view.current_index.internal_id.should eq(5_u64)

    model.move_child(2, 0, refreshed_terrain_index).should be_true
    application.process_events

    moved_first_index = model.index(0, 0, refreshed_terrain_index)
    model.data(moved_first_index).should eq("Roads")

    removed_label = model.remove_child(1, refreshed_terrain_index)
    application.process_events

    removed_label.should eq("Contours")
    model.row_count(refreshed_terrain_index).should eq(2)
    remaining_first_index = model.index(0, 0, refreshed_terrain_index)
    remaining_second_index = model.index(1, 0, refreshed_terrain_index)
    model.data(remaining_first_index).should eq("Roads")
    model.data(remaining_second_index).should eq("Labels")

    remaining_second_index.release
    remaining_first_index.release
    moved_first_index.release
    roads_index.release
    refreshed_terrain_index.release
    terrain_index.release
    tree_view.release
    model.release
  end

  it "supports column views, file icon providers, and file system models" do
    application = app
    root_path = File.join(Dir.tempdir, "crystal-qt6-filesystem-model-#{Process.pid}")
    maps_path = File.join(root_path, "maps")
    terrain_path = File.join(root_path, "terrain.map")
    units_path = File.join(maps_path, "units.map")
    notes_path = File.join(root_path, "notes.txt")

    Dir.mkdir_p(maps_path)
    File.write(terrain_path, "terrain")
    File.write(units_path, "units")
    File.write(notes_path, "notes")

    model = Qt6::FileSystemModel.new
    provider = Qt6::FileIconProvider.new
    column_view = Qt6::ColumnView.new
    preview = Qt6::Label.new("Preview", column_view)
    replacement_preview = Qt6::Label.new("Replacement", column_view)

    root_paths = [] of String
    loaded_paths = [] of String
    renamed_entries = [] of Tuple(String, String, String)
    preview_paths = [] of String
    current_index_changes = 0
    custom_selection_changes = 0

    model.on_root_path_changed do |path|
      root_paths << path
    end

    model.on_directory_loaded do |path|
      loaded_paths << path
    end

    model.on_file_renamed do |path, old_name, new_name|
      renamed_entries << {path, old_name, new_name}
    end

    column_view.on_current_index_changed do
      current_index_changes += 1
    end

    column_view.on_update_preview_widget do |index|
      preview_paths << model.file_path(index)
      index.release
    end

    model.filter = Qt6::DirectoryFilter::AllEntries | Qt6::DirectoryFilter::AllDirs | Qt6::DirectoryFilter::NoDotAndDotDot
    model.read_only = false
    model.resolve_symlinks = false
    model.name_filter_disables = false
    model.name_filters = ["*.map", "*.txt"]
    model.set_option(Qt6::FileSystemModelOption::DontUseCustomDirectoryIcons, true)

    root_index = model.set_root_path(root_path)
    50.times do
      application.process_events
      break if loaded_paths.includes?(root_path)
      sleep 10.milliseconds
    end

    50.times do
      application.process_events
      break if model.row_count(root_index) >= 2
      sleep 10.milliseconds
    end

    await_index = ->(path : String, minimum_children : Int32?) do
      index = Qt6::ModelIndex.new

      50.times do
        application.process_events

        index.release unless index.destroyed?
        index = model.index(path)

        child_count_ready = minimum_children.nil? || (index.valid? && model.row_count(index) >= minimum_children.not_nil!)
        break if index.valid? && child_count_ready
        sleep 10.milliseconds
      end

      index
    end

    root_index.release
    root_index = await_index.call(root_path, 2)
    maps_index = await_index.call(maps_path, 1)
    terrain_index = await_index.call(terrain_path, nil)
    notes_index = await_index.call(notes_path, nil)

    column_view.model = model
    column_view.root_index = root_index
    column_view.resize_grips_visible = true
    column_view.preview_column_visible = true
    column_view.preview_widget = preview
    column_view.column_widths = [140, 220]
    column_view.show
    application.process_events

    column_view.preview_column_visible = false
    application.process_events

    column_view.preview_column_visible = true
    application.process_events

    column_view.preview_widget = nil
    column_view.preview_widget.should be_nil
    column_view.preview_widget = replacement_preview
    column_view.preview_widget.not_nil!.to_unsafe.should eq(replacement_preview.to_unsafe)

    column_view.current_index = terrain_index
    application.process_events
    column_view.scroll_to(terrain_index, Qt6::ScrollHint::PositionAtCenter)
    column_view.select_all
    application.process_events

    custom_selection_model = Qt6::ItemSelectionModel.new(model, column_view)
    custom_selection_model.on_current_index_changed do
      custom_selection_changes += 1
    end
    column_view.selection_model = custom_selection_model
    custom_selection_model.set_current_index(terrain_index, Qt6::SelectionFlag::Current | Qt6::SelectionFlag::Select)
    application.process_events

    maps_index.release
    terrain_index.release
    notes_index.release
    root_index.release

    root_index = await_index.call(root_path, 2)
    maps_index = await_index.call(maps_path, 1)
    terrain_index = await_index.call(terrain_path, nil)
    notes_index = await_index.call(notes_path, nil)

    terrain_info = model.file_info(terrain_index)
    folder_icon = provider.icon(Qt6::FileIconType::Folder)
    file_icon = provider.icon(terrain_info)
    terrain_type_label = provider.type(terrain_info)
    terrain_model_icon = model.icon(terrain_index)
    terrain_modified = model.last_modified(terrain_index)
    terrain_permissions = model.permissions(terrain_index)
    terrain_info_modified = terrain_info.last_modified
    terrain_info_permissions = terrain_info.permissions

    model.root_path.should eq(root_path)
    root_paths.should contain(root_path)
    loaded_paths.should contain(root_path)
    model.root_directory.absolute_path.should eq(root_path)
    model.filter.should eq(Qt6::DirectoryFilter::AllEntries | Qt6::DirectoryFilter::AllDirs | Qt6::DirectoryFilter::NoDotAndDotDot)
    model.read_only?.should be_false
    model.resolve_symlinks?.should be_false
    model.name_filter_disables?.should be_false
    model.name_filters.should eq(["*.map", "*.txt"])
    model.option?(Qt6::FileSystemModelOption::DontUseCustomDirectoryIcons).should be_true
    provider.options.should eq(Qt6::FileIconProviderOption::None)
    provider.options = Qt6::FileIconProviderOption::DontUseCustomDirectoryIcons
    provider.options.should eq(Qt6::FileIconProviderOption::DontUseCustomDirectoryIcons)
    root_index.valid?.should be_true
    maps_index.valid?.should be_true
    terrain_index.valid?.should be_true
    notes_index.valid?.should be_true
    model.file_path(terrain_index).should eq(terrain_path)
    model.file_name(terrain_index).should eq("terrain.map")
    model.dir?(maps_index).should be_true
    model.dir?(terrain_index).should be_false
    model.size(terrain_index).should eq(7)
    terrain_modified.valid?.should be_true
    terrain_info_modified.valid?.should be_true
    terrain_modified.to_string.should eq(terrain_info_modified.to_string)
    terrain_permissions.should_not eq(Qt6::FilePermission::None)
    terrain_permissions.should eq(terrain_info_permissions)
    model.type(terrain_index).should_not be_empty
    terrain_type_label.should_not be_empty
    terrain_info.file_name.should eq("terrain.map")
    folder_icon.null?.should be_false
    file_icon.null?.should be_false
    terrain_model_icon.to_unsafe.should_not eq(Pointer(Void).null)

    column_view.root_index.valid?.should be_true
    column_view.root_index.row.should eq(root_index.row)
    column_view.resize_grips_visible?.should be_true
    column_view.preview_column_visible?.should be_true
    column_view.preview_widget.not_nil!.to_unsafe.should eq(replacement_preview.to_unsafe)
    column_view.column_widths.should eq([140, 220])
    column_view.current_index.valid?.should be_true
    column_view.current_index.row.should eq(terrain_index.row)
    current_index_changes.should be >= 1
    custom_selection_changes.should be >= 1
    preview_paths.should contain(terrain_path)
    column_view.selection_model.not_nil!.has_selection?.should be_true

    wrapped_column_view = Qt6::ColumnView.wrap(column_view.to_unsafe)
    wrapped_column_view.to_unsafe.should eq(column_view.to_unsafe)

    renamed_terrain_path = File.join(root_path, "terrain-renamed.map")
    model.rename(terrain_index, "terrain-renamed.map").should be_true

    renamed_index = await_index.call(renamed_terrain_path, nil)

    renamed_index.valid?.should be_true
    model.file_name(renamed_index).should eq("terrain-renamed.map")
    model.file_path(renamed_index).should eq(renamed_terrain_path)
    renamed_entries.should contain({root_path, "terrain.map", "terrain-renamed.map"})
    terrain_path = renamed_terrain_path

    root_index.release
    root_index = await_index.call(root_path, 2)
    generated_path = File.join(root_path, "generated")
    generated_index = model.mkdir(root_index, "generated")
    20.times { application.process_events }
    generated_index.release
    generated_index = await_index.call(generated_path, nil)
    generated_index.valid?.should be_true
    model.file_path(generated_index).should eq(generated_path)
    model.rmdir(generated_index).should be_true
    application.process_events

    notes_index.release
    notes_index = await_index.call(notes_path, nil)
    model.remove(notes_index).should be_true
    application.process_events
    File.exists?(notes_path).should be_false

    notes_index.release
    generated_index.release
    renamed_index.release
    terrain_info_modified.release
    terrain_info.release
    terrain_index.release
    terrain_modified.release
    file_icon.release
    folder_icon.release
    terrain_model_icon.release
    maps_index.release
    root_index.release
    wrapped_column_view.release
    column_view.release
    model.release
    provider.release

    File.delete(units_path) if File.exists?(units_path)
    File.delete(terrain_path) if File.exists?(terrain_path)
    Dir.delete(maps_path) if Dir.exists?(maps_path)
    Dir.delete(root_path) if Dir.exists?(root_path)
  end
end
