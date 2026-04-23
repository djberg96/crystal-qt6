require "../src/qt6"

app = Qt6.application(["capture-model-view-widget-screenshots"])
app.name = "Model/View Screenshots"
app.organization_name = "crystal-qt6"
app.style_sheet = <<-CSS
  QWidget {
    font-size: 15px;
  }
  QListWidget, QTreeWidget, QTableView {
    background: rgb(255, 255, 255);
    alternate-background-color: rgb(245, 248, 250);
    border: 1px solid rgb(190, 198, 206);
    selection-background-color: rgb(72, 126, 176);
    selection-color: white;
  }
  QHeaderView::section {
    background: rgb(236, 241, 245);
    border: 0;
    border-right: 1px solid rgb(190, 198, 206);
    border-bottom: 1px solid rgb(190, 198, 206);
    padding: 6px 8px;
    font-weight: bold;
  }
CSS

OUTPUT_DIR = File.expand_path("../docs/book/images", __DIR__)
Dir.mkdir_p(OUTPUT_DIR)

def process_paints(app : Qt6::Application)
  8.times { app.process_events }
end

def save_widget(app : Qt6::Application, widget : Qt6::Widget, file_name : String)
  widget.show
  widget.update
  process_paints(app)

  output = File.join(OUTPUT_DIR, file_name)
  abort "Could not write #{output}" unless widget.grab.save(output)
  puts output

  widget.close
  process_paints(app)
end

list = Qt6::ListWidget.new
list.window_title = "ListWidget"
list.resize(420, 210)
list.alternating_row_colors = true
list.selection_mode = Qt6::ItemSelectionMode::SingleSelection

[
  {"Terrain", "terrain", Qt6::CheckState::Checked},
  {"Roads", "roads", Qt6::CheckState::Checked},
  {"Labels", "labels", Qt6::CheckState::PartiallyChecked},
  {"Draft Overlay", "overlay", Qt6::CheckState::Unchecked},
].each do |name, key, state|
  item = Qt6::ListWidgetItem.new(name)
  item.flags = Qt6::ItemFlag::Enabled |
    Qt6::ItemFlag::Selectable |
    Qt6::ItemFlag::UserCheckable
  item.check_state = state
  item.set_data(key, Qt6::ItemDataRole::User)
  list << item
end
list.current_row = 1
save_widget(app, list, "model-view-list-widget.png")

tree = Qt6::TreeWidget.new
tree.window_title = "TreeWidget"
tree.resize(560, 300)
tree.column_count = 2
tree.set_header_label(0, "Layer")
tree.set_header_label(1, "State")
tree.alternating_row_colors = true
tree.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows

terrain = Qt6::TreeWidgetItem.new("Terrain")
terrain.set_text(1, "Visible")
terrain << Qt6::TreeWidgetItem.new("Grid").tap { |item| item.set_text(1, "Visible") }
terrain << Qt6::TreeWidgetItem.new("Shade").tap { |item| item.set_text(1, "Locked") }

units = Qt6::TreeWidgetItem.new("Units")
units.set_text(1, "Visible")
units << Qt6::TreeWidgetItem.new("Inf").tap { |item| item.set_text(1, "Draft") }
units << Qt6::TreeWidgetItem.new("Pins").tap { |item| item.set_text(1, "Visible") }

tree << terrain
tree << units
tree.expand_all
tree.current_item = units.child(0).not_nil!
save_widget(app, tree, "model-view-tree-widget.png")

model = Qt6::StandardItemModel.new
model.set_horizontal_header_label(0, "Layer")
model.set_horizontal_header_label(1, "State")
model.set_horizontal_header_label(2, "Priority")

[
  {"Terrain", "Visible", 10},
  {"Roads", "Visible", 20},
  {"Labels", "Draft", 30},
  {"Logistics", "Locked", 40},
].each_with_index do |entry, row|
  name, state, priority = entry
  name_item = Qt6::StandardItem.new(name)
  name_item.set_data(priority, Qt6::ItemDataRole::User)
  state_item = Qt6::StandardItem.new(state)
  priority_item = Qt6::StandardItem.new(priority.to_s)

  model.set_item(row, 0, name_item)
  model.set_item(row, 1, state_item)
  model.set_item(row, 2, priority_item)
end

table = Qt6::TableView.new
table.window_title = "TableView"
table.resize(560, 260)
table.model = model
table.alternating_row_colors = true
table.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
table.selection_mode = Qt6::ItemSelectionMode::SingleSelection
table.sorting_enabled = true
table.sort_by_column(2, Qt6::SortOrder::Descending)
table.current_index = model.index(1, 0)
table.horizontal_header.stretch_last_section = true
table.horizontal_header.resize_section(0, 190)
table.horizontal_header.resize_section(1, 150)
save_widget(app, table, "model-view-table-view.png")

tree_model = Qt6::StandardItemModel.new
tree_model.set_horizontal_header_label(0, "Layer")
tree_model.set_horizontal_header_label(1, "State")

terrain_root = Qt6::StandardItem.new("Terrain")
terrain_root.set_child(0, 0, Qt6::StandardItem.new("Grid"))
terrain_root.set_child(0, 1, Qt6::StandardItem.new("Visible"))
terrain_root.set_child(1, 0, Qt6::StandardItem.new("Shade"))
terrain_root.set_child(1, 1, Qt6::StandardItem.new("Locked"))

units_root = Qt6::StandardItem.new("Units")
units_root.set_child(0, 0, Qt6::StandardItem.new("Inf"))
units_root.set_child(0, 1, Qt6::StandardItem.new("Draft"))
units_root.set_child(1, 0, Qt6::StandardItem.new("Pins"))
units_root.set_child(1, 1, Qt6::StandardItem.new("Visible"))

tree_model.set_item(0, 0, terrain_root)
tree_model.set_item(0, 1, Qt6::StandardItem.new("Visible"))
tree_model.set_item(1, 0, units_root)
tree_model.set_item(1, 1, Qt6::StandardItem.new("Visible"))

tree_view = Qt6::TreeView.new
tree_view.window_title = "TreeView Headers"
tree_view.resize(520, 300)
tree_view.model = tree_model
tree_view.header_hidden = false
tree_view.root_is_decorated = true
tree_view.uniform_row_heights = true
tree_view.indentation = 22
tree_view.alternating_row_colors = true
tree_view.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
tree_view.current_index = tree_model.index(1, 0)
tree_view.expand_all
save_widget(app, tree_view, "model-view-tree-view-headers.png")

header_model = Qt6::StandardItemModel.new
header_model.set_horizontal_header_label(0, "Layer")
header_model.set_horizontal_header_label(1, "State")
header_model.set_horizontal_header_label(2, "Priority")
header_model.set_horizontal_header_label(3, "Notes")

[
  {"Terrain", "Visible", 10, "grid overlay"},
  {"Roads", "Visible", 20, "route layer"},
  {"Labels", "Draft", 30, "annotations"},
  {"Logistics", "Locked", 40, "supply routes"},
].each_with_index do |entry, row|
  name, state, priority, notes = entry
  header_model.set_item(row, 0, Qt6::StandardItem.new(name))
  header_model.set_item(row, 1, Qt6::StandardItem.new(state))
  header_model.set_item(row, 2, Qt6::StandardItem.new(priority.to_s))
  header_model.set_item(row, 3, Qt6::StandardItem.new(notes))
end

header_table = Qt6::TableView.new
header_table.window_title = "TableView Headers"
header_table.resize(620, 260)
header_table.model = header_model
header_table.alternating_row_colors = true
header_table.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
header_table.selection_mode = Qt6::ItemSelectionMode::SingleSelection
header_table.sorting_enabled = true
header_table.sort_by_column(2, Qt6::SortOrder::Descending)
header_table.current_index = header_model.index(2, 0)
header_table.horizontal_header.resize_section(0, 190)
header_table.horizontal_header.resize_section(1, 150)
header_table.horizontal_header.stretch_last_section = true
header_table.horizontal_header.set_section_hidden(3, true)
save_widget(app, header_table, "model-view-table-headers.png")

delegate_model = Qt6::StandardItemModel.new
delegate_model.set_horizontal_header_label(0, "Layer")
delegate_model.set_horizontal_header_label(1, "State")
[
  {"Terrain", "Visible"},
  {"Roads", "Visible"},
  {"Labels", "Draft"},
].each_with_index do |entry, row|
  name, state = entry
  delegate_model.set_item(row, 0, Qt6::StandardItem.new(name))
  delegate_model.set_item(row, 1, Qt6::StandardItem.new(state))
end

delegate_table = Qt6::TableView.new
delegate_table.window_title = "Delegate Editor"
delegate_table.resize(560, 230)
delegate_table.model = delegate_model
delegate_table.alternating_row_colors = true
delegate_table.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows
delegate_table.selection_mode = Qt6::ItemSelectionMode::SingleSelection
delegate_table.edit_triggers = Qt6::EditTrigger::DoubleClicked | Qt6::EditTrigger::EditKeyPressed
delegate_table.horizontal_header.resize_section(0, 220)
delegate_table.horizontal_header.stretch_last_section = true

delegate = Qt6::StyledItemDelegate.new(delegate_table)
delegate.on_create_editor do |parent, _index|
  editor = Qt6::LineEdit.new(parent: parent)
  editor.style_sheet = "QLineEdit { border: 2px solid rgb(72, 126, 176); padding: 3px 6px; background: white; }"
  editor
end
delegate.on_set_editor_data do |editor, value, _index|
  editor.as(Qt6::LineEdit).text = value.to_s
end
delegate.on_set_model_data do |editor, target_model, index|
  target_model.set_data(index, editor.as(Qt6::LineEdit).text)
end
delegate_table.item_delegate = delegate

edit_index = delegate_model.index(0, 0)
delegate_table.current_index = edit_index
delegate_table.open_persistent_editor(edit_index)
save_widget(app, delegate_table, "model-view-delegate-editor.png")

def reorder_list(title : String) : Qt6::ListWidget
  list = Qt6::ListWidget.new
  list.window_title = title
  list.resize(420, 230)
  list.alternating_row_colors = true
  list.selection_mode = Qt6::ItemSelectionMode::SingleSelection
  list.drag_enabled = true
  list.drag_drop_mode = Qt6::ItemViewDragDropMode::InternalMove
  list.default_drop_action = Qt6::DropAction::MoveAction
  list.drop_indicator_shown = true

  ["Terrain", "Roads", "Labels", "Logistics"].each do |name|
    item = Qt6::ListWidgetItem.new(name)
    item.flags = Qt6::ItemFlag::Enabled |
      Qt6::ItemFlag::Selectable |
      Qt6::ItemFlag::DragEnabled |
      Qt6::ItemFlag::DropEnabled
    list << item
  end

  list
end

reorder_before = reorder_list("Before Reorder")
reorder_before.current_row = 3
save_widget(app, reorder_before, "model-view-row-reorder-before.png")

reorder_after = reorder_list("After Reorder")
reorder_after.move_item(3, 1)
reorder_after.current_row = 1
save_widget(app, reorder_after, "model-view-row-reorder-after.png")

workbench_model = Qt6::StandardItemModel.new
workbench_model.set_horizontal_header_label(0, "Layer")
workbench_model.set_horizontal_header_label(1, "State")
workbench_model.set_horizontal_header_label(2, "Notes")

[
  {"Terrain", "Visible", "Controls the grid overlay", 10},
  {"Units", "Visible", "Tracks moveable markers", 20},
  {"Labels", "Draft", "Carries annotation text", 30},
  {"Logistics", "Locked", "Reserved for supply routes", 40},
].each_with_index do |entry, row|
  name, state, notes, priority = entry
  name_item = Qt6::StandardItem.new(name)
  name_item.set_data(priority, Qt6::ItemDataRole::User)
  workbench_model.set_item(row, 0, name_item)
  workbench_model.set_item(row, 1, Qt6::StandardItem.new(state))
  workbench_model.set_item(row, 2, Qt6::StandardItem.new(notes))
end

workbench_proxy = Qt6::SortFilterProxyModel.new
workbench_proxy.source_model = workbench_model
workbench_proxy.sort_role = Qt6::ItemDataRole::User
workbench_proxy.filter_role = Qt6::ItemDataRole::Display
workbench_proxy.filter_key_column = 0
workbench_proxy.filter_case_sensitivity = Qt6::CaseSensitivity::Insensitive
workbench_proxy.filter_regular_expression = "Terrain|Units|Labels"
workbench_proxy.dynamic_sort_filter = true
workbench_proxy.sort

workbench_window = Qt6::MainWindow.new
workbench_window.window_title = "Model View Workbench"
workbench_window.resize(900, 540)
workbench_window.status_bar.show_message("Selection synced across views")

workbench_delegate = Qt6::StyledItemDelegate.new(workbench_window)
workbench_delegate.on_display_text do |text|
  text.empty? ? "(empty)" : "#{text}  [proxy]"
end

workbench_list = Qt6::ListView.new
workbench_list.model = workbench_proxy
workbench_list.item_delegate = workbench_delegate
workbench_list.alternating_row_colors = true

workbench_tree = Qt6::TreeView.new
workbench_tree.model = workbench_proxy
workbench_tree.header_hidden = false
workbench_tree.alternating_row_colors = true
workbench_tree.selection_behavior = Qt6::ItemSelectionBehavior::SelectRows

workbench_selection = Qt6::ItemSelectionModel.new(workbench_proxy, workbench_window)
workbench_list.selection_model = workbench_selection
workbench_tree.selection_model = workbench_selection
workbench_selection.current_index = workbench_proxy.index(0, 0)

filter_input = Qt6::LineEdit.new("Terrain|Units|Labels")
filter_label = Qt6::Label.new("QSortFilterProxyModel filter")
selection_label = Qt6::Label.new("Proxy row 1 -> source row 1 | Terrain")
notes_label = Qt6::Label.new("State Visible | Controls the grid overlay")
delegate_label = Qt6::Label.new("Delegate editor")
delegate_editor = Qt6::LineEdit.new("Terrain")

list_panel = Qt6::Widget.new
list_panel.vbox do |column|
  column << Qt6::Label.new("List View")
  column << filter_input
  column << filter_label
  column << workbench_list
end

detail_panel = Qt6::Widget.new
detail_panel.vbox do |column|
  column << Qt6::Label.new("Tree View")
  column << workbench_tree
  column << selection_label
  column << notes_label
  column << delegate_label
  column << delegate_editor
end

workbench_splitter = Qt6::Splitter.new(Qt6::Orientation::Horizontal)
workbench_splitter << list_panel
workbench_splitter << detail_panel
workbench_window.central_widget = workbench_splitter
save_widget(app, workbench_window, "model-view-workbench.png")
