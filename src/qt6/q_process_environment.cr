module Qt6
  # Wraps `QProcessEnvironment` for configuring child-process variables.
  class QProcessEnvironment < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def self.system_environment : self
      new(LibQt6.qt6cr_process_environment_system_environment, true)
    end

    def initialize(inherit_from_parent : Bool = false)
      super(LibQt6.qt6cr_process_environment_create(inherit_from_parent))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def empty? : Bool
      LibQt6.qt6cr_process_environment_is_empty(to_unsafe)
    end

    def inherits_from_parent? : Bool
      LibQt6.qt6cr_process_environment_inherits_from_parent(to_unsafe)
    end

    def contains?(name : String) : Bool
      LibQt6.qt6cr_process_environment_contains(to_unsafe, name.to_unsafe)
    end

    def value(name : String, default_value : String = "") : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_process_environment_value(to_unsafe, name.to_unsafe, default_value.to_unsafe))
    end

    def insert(name : String, value : String) : self
      LibQt6.qt6cr_process_environment_insert(to_unsafe, name.to_unsafe, value.to_unsafe)
      self
    end

    def insert(other : QProcessEnvironment) : self
      LibQt6.qt6cr_process_environment_insert_environment(to_unsafe, other.to_unsafe)
      self
    end

    def merge!(other : QProcessEnvironment) : self
      insert(other)
    end

    def merge(other : QProcessEnvironment) : QProcessEnvironment
      merged = QProcessEnvironment.new
      merged.insert(self)
      merged.insert(other)
      merged
    end

    def remove(name : String) : self
      LibQt6.qt6cr_process_environment_remove(to_unsafe, name.to_unsafe)
      self
    end

    def clear : self
      LibQt6.qt6cr_process_environment_clear(to_unsafe)
      self
    end

    def keys : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_process_environment_keys(to_unsafe))
    end

    def to_string_list : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_process_environment_to_string_list(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_process_environment_destroy(to_unsafe)
    end
  end
end
