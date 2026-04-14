module Qt6
  # Wraps `QCompleter`.
  class Completer < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(items : Enumerable(String) = [] of String, parent : QObject? = nil)
      super(LibQt6.qt6cr_completer_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
      self.items = items.to_a
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def items=(items : Array(String)) : Array(String)
      pointers = items.map(&.to_unsafe)
      LibQt6.qt6cr_completer_set_items(to_unsafe, pointers.to_unsafe, pointers.size)
      items
    end

    def completion_prefix : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_completer_completion_prefix(to_unsafe))
    end

    def completion_prefix=(value : String) : String
      LibQt6.qt6cr_completer_set_completion_prefix(to_unsafe, value.to_unsafe)
      value
    end

    def current_completion : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_completer_current_completion(to_unsafe))
    end

    def case_sensitivity : CaseSensitivity
      CaseSensitivity.from_value(LibQt6.qt6cr_completer_case_sensitivity(to_unsafe))
    end

    def case_sensitivity=(value : CaseSensitivity) : CaseSensitivity
      LibQt6.qt6cr_completer_set_case_sensitivity(to_unsafe, value.value)
      value
    end

    def completion_mode : CompleterCompletionMode
      CompleterCompletionMode.from_value(LibQt6.qt6cr_completer_completion_mode(to_unsafe))
    end

    def completion_mode=(value : CompleterCompletionMode) : CompleterCompletionMode
      LibQt6.qt6cr_completer_set_completion_mode(to_unsafe, value.value)
      value
    end
  end
end
