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
