require "../src/qt6"

class ModelViewWorkbenchLayer
  property name : String
  property state : String
  property notes : String
  property priority : Int32

  def initialize(@name : String, @state : String, @notes : String, @priority : Int32)
  end
end

class ModelViewWorkbenchModel < Qt6::AbstractListModel
  getter layers

  def initialize(@layers : Array(ModelViewWorkbenchLayer), parent : Qt6::QObject? = nil)
    super(parent)
  end

  def append_layer(layer : ModelViewWorkbenchLayer) : ModelViewWorkbenchLayer
    row = @layers.size
    begin_insert_rows(row, row)
    @layers << layer
    end_insert_rows
    layer
  end

  def remove_layer(row : Int) : ModelViewWorkbenchLayer
    begin_remove_rows(row, row)
    removed = @layers.delete_at(row)
    end_remove_rows
    removed
  end

  def restore_defaults : self
    begin_reset_model
    @layers = [
      ModelViewWorkbenchLayer.new("Terrain", "Visible", "Controls the grid overlay", 10),
      ModelViewWorkbenchLayer.new("Units", "Visible", "Tracks moveable markers", 20),
      ModelViewWorkbenchLayer.new("Labels", "Draft", "Carries annotation text", 30),
      ModelViewWorkbenchLayer.new("Logistics", "Locked", "Reserved for supply routes", 40),
    ]
    end_reset_model
    self
  end

  protected def model_row_count : Int32
    @layers.size.to_i32
  end

  protected def model_column_count : Int32
    3
  end

  protected def model_data(index : Qt6::ModelIndex, role : Int32) : Qt6::ModelData
    return nil unless index.valid?

    layer = @layers[index.row]?
    return nil unless layer

    case role
    when Qt6::ItemDataRole::Display.value, Qt6::ItemDataRole::Edit.value
      case index.column
      when 0 then layer.name
      when 1 then layer.state
      when 2 then layer.notes
      else        nil
      end
    when Qt6::ItemDataRole::ToolTip.value
      "#{layer.name} | priority #{layer.priority}"
    when Qt6::ItemDataRole::User.value
      index.column == 0 ? layer.priority : nil
    when Qt6::ItemDataRole::Foreground.value
      case layer.state
      when "Locked" then Qt6::Color.new(130, 62, 62)
      when "Draft"  then Qt6::Color.new(140, 108, 28)
      else               Qt6::Color.new(52, 90, 68)
      end
    else
      nil
    end
  end

  protected def model_set_data(index : Qt6::ModelIndex, value : Qt6::ModelData, role : Int32) : Bool
    return false unless index.valid? && role == Qt6::ItemDataRole::Edit.value

    layer = @layers[index.row]
    case index.column
    when 0 then layer.name = value.to_s
    when 1 then layer.state = value.to_s
    when 2 then layer.notes = value.to_s
    else
      return false
    end

    data_changed(index)
    true
  end

  protected def model_header_data(section : Int32, orientation : Qt6::Orientation, role : Int32) : Qt6::ModelData
    return nil unless orientation == Qt6::Orientation::Horizontal && role == Qt6::ItemDataRole::Display.value

    case section
    when 0 then "Layer"
    when 1 then "State"
    when 2 then "Notes"
    else        nil
    end
  end

  protected def model_flags(index : Qt6::ModelIndex) : Qt6::ItemFlag
    return Qt6::ItemFlag::None unless index.valid?

    Qt6::ItemFlag::Enabled | Qt6::ItemFlag::Selectable | Qt6::ItemFlag::Editable
  end
end

app = Qt6.application
app.name = "Model View Workbench"
app.organization_name = "crystal-qt6"
app.style_sheet = <<-CSS
  QWidget { font-family: "Avenir Next"; font-size: 13px; }
  QMainWindow { background: rgb(244, 242, 236); }
CSS

window = Qt6::MainWindow.new
window.window_title = "Model View Workbench"
window.resize(1240, 780)

status_bar = window.status_bar
status_bar.show_message("Ready")

source_model = ModelViewWorkbenchModel.new([] of ModelViewWorkbenchLayer, window)
source_model.restore_defaults

proxy = Qt6::SortFilterProxyModel.new(window)
proxy.source_model = source_model
proxy.sort_role = Qt6::ItemDataRole::User
proxy.filter_role = Qt6::ItemDataRole::Display
proxy.filter_key_column = 0
proxy.filter_case_sensitivity = Qt6::CaseSensitivity::Insensitive
proxy.dynamic_sort_filter = true
proxy.sort

delegate = Qt6::StyledItemDelegate.new(window)
delegate.on_display_text do |text|
  "#{text}  [proxy]"
end
delegate.on_create_editor do |parent, _index|
  Qt6::LineEdit.new(parent: parent)
end
delegate.on_set_editor_data do |editor, value, _index|
  editor.as(Qt6::LineEdit).text = value.to_s
end
delegate.on_set_model_data do |editor, target_model, index|
  target_model.set_data(index, editor.as(Qt6::LineEdit).text)
end

list_view = Qt6::ListView.new
list_view.model = proxy
list_view.item_delegate = delegate

tree_view = Qt6::TreeView.new
tree_view.model = proxy
tree_view.expand_all

shared_selection = Qt6::ItemSelectionModel.new(proxy, window)
list_view.selection_model = shared_selection
tree_view.selection_model = shared_selection

filter_input = Qt6::LineEdit.new
filter_input.text = "Terrain"
filter_hint = Qt6::Label.new("Filter applies through QSortFilterProxyModel on column 0.")
selection_summary = Qt6::Label.new("No current selection")
header_summary = Qt6::Label.new
notes_summary = Qt6::Label.new("Pick a row in either view to sync the shared selection model.")
editor_hint = Qt6::Label.new("Commit current name through StyledItemDelegate hooks:")

editor_host = Qt6::Widget.new
initial_index = proxy.index(0)
delegate_editor = delegate.create_editor(editor_host, initial_index).try(&.as(Qt6::LineEdit)) || Qt6::LineEdit.new(parent: editor_host)
editor_host.vbox do |column|
  column << delegate_editor
end

refresh_editor = -> do
  current = shared_selection.current_index
  if current.valid?
    editable_index = proxy.index(current.row, 0)
    source_index = proxy.map_to_source(editable_index)
    delegate.set_editor_data(delegate_editor, editable_index)

    layer_name = proxy.data(editable_index).to_s
    layer_state = proxy.data(proxy.index(current.row, 1)).to_s
    layer_notes = proxy.data(proxy.index(current.row, 2)).to_s
    selection_summary.text = "Proxy row #{editable_index.row + 1} -> source row #{source_index.row + 1} | #{layer_name}"
    notes_summary.text = "State #{layer_state} | #{layer_notes}"
    status_bar.show_message("Selection synced across list/tree: #{layer_name}", 1800)
  else
    selection_summary.text = "No current selection"
    notes_summary.text = "Pick a row in either view to sync the shared selection model."
  end
end

header_summary.text = "Headers: #{proxy.header_data(0)} | #{proxy.header_data(1)} | #{proxy.header_data(2)}"

shared_selection.on_current_index_changed do
  refresh_editor.call
end

apply_filter = -> do
  proxy.filter_regular_expression = filter_input.text
  proxy.invalidate
  status_bar.show_message(filter_input.text.empty? ? "Filter cleared" : "Filtering regex #{proxy.filter_pattern}", 1600)
end

filter_button = Qt6::PushButton.new("Apply Filter")
filter_button.on_clicked do
  apply_filter.call
end

clear_filter_button = Qt6::PushButton.new("Clear Filter")
clear_filter_button.on_clicked do
  filter_input.text = ""
  apply_filter.call
end

add_button = Qt6::PushButton.new("Add Layer")
add_button.on_clicked do
  name = "Overlay #{source_model.layers.size + 1}"
  source_model.append_layer(ModelViewWorkbenchLayer.new(name, "Draft", "Added through custom model notifications", (source_model.layers.size + 1).to_i32 * 10))
  proxy.sort
  status_bar.show_message("Inserted #{name}", 1600)
end

remove_button = Qt6::PushButton.new("Remove Current")
remove_button.on_clicked do
  current = shared_selection.current_index
  unless current.valid?
    status_bar.show_message("No row selected", 1400)
    next
  end

  source_index = proxy.map_to_source(proxy.index(current.row, 0))
  removed = source_model.remove_layer(source_index.row)
  status_bar.show_message("Removed #{removed.name}", 1600)
  if proxy.row_count > 0
    next_index = proxy.index(0)
    list_view.current_index = next_index
  end
end

commit_button = Qt6::PushButton.new("Commit Editor")
commit_button.on_clicked do
  current = shared_selection.current_index
  unless current.valid?
    status_bar.show_message("Pick a row before committing", 1400)
    next
  end

  editable_index = proxy.index(current.row, 0)
  delegate.set_model_data(delegate_editor, proxy, editable_index)
  refresh_editor.call
  status_bar.show_message("Committed #{delegate_editor.text} through delegate hooks", 1800)
end

restore_button = Qt6::PushButton.new("Restore Defaults")
restore_button.on_clicked do
  source_model.restore_defaults
  proxy.sort
  filter_input.text = ""
  proxy.clear_filter
  proxy.invalidate
  list_view.current_index = proxy.index(0)
  status_bar.show_message("Custom model reset and proxy refreshed", 1800)
end

list_panel = Qt6::Widget.new
list_panel.vbox do |column|
  column << Qt6::Label.new("List View")
  column << filter_input
  column << filter_button
  column << clear_filter_button
  column << filter_hint
  column << list_view
end

detail_panel = Qt6::Widget.new
detail_panel.vbox do |column|
  column << Qt6::Label.new("Tree View")
  column << tree_view
  column << header_summary
  column << selection_summary
  column << notes_summary
  column << editor_hint
  column << editor_host
  column << commit_button
  column << add_button
  column << remove_button
  column << restore_button
end

splitter = Qt6::Splitter.new(Qt6::Orientation::Horizontal)
splitter << list_panel
splitter << detail_panel
window.central_widget = splitter

window.show
list_view.current_index = initial_index
apply_filter.call
list_view.current_index = proxy.index(0)
app.run
