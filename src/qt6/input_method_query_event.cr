module Qt6
  class InputMethodQueryEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(queries : InputMethodQuery)
      super(LibQt6.qt6cr_input_method_query_event_create(queries.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def queries : InputMethodQuery
      InputMethodQuery.from_value(LibQt6.qt6cr_input_method_query_event_queries(to_unsafe))
    end

    def set_value(query : InputMethodQuery, value) : self
      LibQt6.qt6cr_input_method_query_event_set_value(to_unsafe, query.value, Qt6.model_data_to_native(value))
      self
    end

    def value(query : InputMethodQuery) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_input_method_query_event_value(to_unsafe, query.value))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_input_method_query_event_destroy(to_unsafe)
    end
  end
end
