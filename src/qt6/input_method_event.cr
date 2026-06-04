module Qt6
  class InputMethodEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize
      super(LibQt6.qt6cr_input_method_event_create, true)
    end

    def initialize(preedit : String, attributes : Enumerable(InputMethodAttribute) = [] of InputMethodAttribute)
      native_attributes = attributes.to_a.map(&.to_native)
      super(
        LibQt6.qt6cr_input_method_event_create_preedit(
          preedit.to_unsafe,
          native_attributes.empty? ? Pointer(LibQt6::InputMethodAttributeValue).null : native_attributes.to_unsafe,
          native_attributes.size
        ),
        true
      )
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def set_commit_string(value : String, replace_from : Int = 0, replace_length : Int = 0) : self
      LibQt6.qt6cr_input_method_event_set_commit_string(to_unsafe, value.to_unsafe, replace_from.to_i32, replace_length.to_i32)
      self
    end

    def preedit_string : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_input_method_event_preedit_string(to_unsafe))
    end

    def commit_string : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_input_method_event_commit_string(to_unsafe))
    end

    def replacement_start : Int32
      LibQt6.qt6cr_input_method_event_replacement_start(to_unsafe)
    end

    def replacement_length : Int32
      LibQt6.qt6cr_input_method_event_replacement_length(to_unsafe)
    end

    def attributes : Array(InputMethodAttribute)
      native = LibQt6.qt6cr_input_method_event_attributes(to_unsafe)
      values = Array(InputMethodAttribute).new(native.size) do |index|
        InputMethodAttribute.from_native(native.data[index])
      end
      LibQt6.qt6cr_input_method_attribute_array_free(native)
      values
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_input_method_event_destroy(to_unsafe)
    end
  end
end
