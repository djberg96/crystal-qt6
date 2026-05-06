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

    def model_sorting : CompleterModelSorting
      CompleterModelSorting.from_value(LibQt6.qt6cr_completer_model_sorting(to_unsafe))
    end

    def model_sorting=(value : CompleterModelSorting) : CompleterModelSorting
      LibQt6.qt6cr_completer_set_model_sorting(to_unsafe, value.value)
      value
    end

    def completion_column : Int32
      LibQt6.qt6cr_completer_completion_column(to_unsafe)
    end

    def completion_column=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_completer_set_completion_column(to_unsafe, int_value)
      int_value
    end

    def completion_role : Int32
      LibQt6.qt6cr_completer_completion_role(to_unsafe)
    end

    def completion_role=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_completer_set_completion_role(to_unsafe, int_value)
      int_value
    end

    def completion_count : Int32
      LibQt6.qt6cr_completer_completion_count(to_unsafe)
    end

    def current_row : Int32
      LibQt6.qt6cr_completer_current_row(to_unsafe)
    end

    def current_row=(value : Int) : Bool
      LibQt6.qt6cr_completer_set_current_row(to_unsafe, value.to_i32)
    end

    def widget : Widget?
      handle = LibQt6.qt6cr_completer_widget(to_unsafe)
      handle.null? ? nil : Widget.wrap(handle)
    end

    def widget=(value : Widget?) : Widget?
      LibQt6.qt6cr_completer_set_widget(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value
    end

    def complete : self
      LibQt6.qt6cr_completer_complete(to_unsafe, Rect.new(0, 0, 0, 0).to_native)
      self
    end

    def complete(rect : Rect) : self
      LibQt6.qt6cr_completer_complete(to_unsafe, rect.to_native)
      self
    end

    def wrap_around? : Bool
      LibQt6.qt6cr_completer_wrap_around(to_unsafe)
    end

    def wrap_around=(value : Bool) : Bool
      LibQt6.qt6cr_completer_set_wrap_around(to_unsafe, value)
      value
    end

    def max_visible_items : Int32
      LibQt6.qt6cr_completer_max_visible_items(to_unsafe)
    end

    def max_visible_items=(value : Int) : Int32
      LibQt6.qt6cr_completer_set_max_visible_items(to_unsafe, value)
      value.to_i32
    end
  end
end
