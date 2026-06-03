module Qt6
  # Base wrapper for `QAbstractProxyModel` subclasses.
  class AbstractProxyModel < AbstractItemModel
    @source_model_changed : Signal() = Signal().new
    @proxy_callback_userdata : LibQt6::Handle = Pointer(Void).null

    getter source_model_changed : Signal()

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
      @source_model_changed = Signal().new
      @proxy_callback_userdata = Box.box(self)
      LibQt6.qt6cr_abstract_proxy_model_on_source_model_changed(to_unsafe, SOURCE_MODEL_CHANGED_TRAMPOLINE, @proxy_callback_userdata)
    end

    def source_model=(model : AbstractItemModel) : AbstractItemModel
      LibQt6.qt6cr_abstract_proxy_model_set_source_model(to_unsafe, model.to_unsafe)
      model
    end

    def source_model : AbstractItemModel?
      handle = LibQt6.qt6cr_abstract_proxy_model_source_model(to_unsafe)
      handle.null? ? nil : AbstractItemModel.wrap(handle)
    end

    def map_to_source(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_abstract_proxy_model_map_to_source(to_unsafe, index.to_unsafe), true)
    end

    def map_from_source(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_abstract_proxy_model_map_from_source(to_unsafe, index.to_unsafe), true)
    end

    def map_selection_to_source(selection : ItemSelection) : ItemSelection
      ItemSelection.wrap(LibQt6.qt6cr_abstract_proxy_model_map_selection_to_source(to_unsafe, selection.to_unsafe), true)
    end

    def map_selection_from_source(selection : ItemSelection) : ItemSelection
      ItemSelection.wrap(LibQt6.qt6cr_abstract_proxy_model_map_selection_from_source(to_unsafe, selection.to_unsafe), true)
    end

    def on_source_model_changed(&block : ->) : self
      @source_model_changed.connect { block.call }
      self
    end

    private SOURCE_MODEL_CHANGED_TRAMPOLINE = ->(userdata : Void*) do
      Box(AbstractProxyModel).unbox(userdata).@source_model_changed.emit
    end
  end
end
