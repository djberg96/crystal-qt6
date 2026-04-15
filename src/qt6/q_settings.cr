module Qt6
  # Wraps `QSettings` for persisted application settings storage.
  class QSettings < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a settings store backed by a concrete file path.
    def initialize(file_name : String, format : SettingsFormat = SettingsFormat::Ini)
      super(LibQt6.qt6cr_qsettings_create_from_file(file_name.to_unsafe, format.value))
    end

    # Creates a user-scope settings store for an organization/application pair.
    def self.for_application(organization : String, application : String, format : SettingsFormat = SettingsFormat::Native) : self
      wrap(LibQt6.qt6cr_qsettings_create_for_application(organization.to_unsafe, application.to_unsafe, format.value), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the underlying settings file path, when applicable.
    def file_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qsettings_file_name(to_unsafe))
    end

    # Returns whether the given key currently exists.
    def contains?(key : String) : Bool
      LibQt6.qt6cr_qsettings_contains(to_unsafe, key.to_unsafe)
    end

    # Returns the current value for a key or the provided fallback.
    def value(key : String, default_value = nil) : ModelData
      Qt6.model_data_from_native(LibQt6.qt6cr_qsettings_value(to_unsafe, key.to_unsafe, Qt6.model_data_to_native(default_value)))
    end

    # Sets a value and returns the normalized value.
    def set_value(key : String, value) : ModelData
      normalized = Qt6.normalize_model_data(value)
      LibQt6.qt6cr_qsettings_set_value(to_unsafe, key.to_unsafe, Qt6.model_data_to_native(normalized))
      normalized
    end

    # Removes a single key or subtree.
    def remove(key : String) : self
      LibQt6.qt6cr_qsettings_remove(to_unsafe, key.to_unsafe)
      self
    end

    # Clears the entire settings store.
    def clear : self
      LibQt6.qt6cr_qsettings_clear(to_unsafe)
      self
    end

    # Flushes pending settings changes to the backing store.
    def sync : self
      LibQt6.qt6cr_qsettings_sync(to_unsafe)
      self
    end

    # Returns all stored keys.
    def all_keys : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_qsettings_all_keys(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qsettings_destroy(to_unsafe)
    end
  end
end
