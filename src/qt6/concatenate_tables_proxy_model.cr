module Qt6
  # Wraps `QConcatenateTablesProxyModel`, which stacks table-like source models vertically.
  class ConcatenateTablesProxyModel < AbstractItemModel
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_concatenate_tables_proxy_model_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def source_models : Array(AbstractItemModel)
      Qt6.copy_and_release_handles(LibQt6.qt6cr_concatenate_tables_proxy_model_source_models(to_unsafe)).map do |handle|
        AbstractItemModel.wrap(handle)
      end
    end

    def add_source_model(model : AbstractItemModel) : self
      LibQt6.qt6cr_concatenate_tables_proxy_model_add_source_model(to_unsafe, model.to_unsafe)
      self
    end

    def remove_source_model(model : AbstractItemModel) : self
      LibQt6.qt6cr_concatenate_tables_proxy_model_remove_source_model(to_unsafe, model.to_unsafe)
      self
    end

    def <<(model : AbstractItemModel) : self
      add_source_model(model)
    end

    def self.mapping_api_available? : Bool
      LibQt6.qt6cr_concatenate_tables_proxy_model_has_mapping_api
    end

    def mapping_api_available? : Bool
      self.class.mapping_api_available?
    end

    def map_to_source(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_concatenate_tables_proxy_model_map_to_source(to_unsafe, index.to_unsafe), true)
    end

    def map_from_source(index : ModelIndex) : ModelIndex
      ModelIndex.wrap(LibQt6.qt6cr_concatenate_tables_proxy_model_map_from_source(to_unsafe, index.to_unsafe), true)
    end
  end
end
