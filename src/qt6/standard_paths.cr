module Qt6
  # Wraps `QStandardPaths` as a Crystal-friendly utility module.
  module StandardPaths
    # Returns the preferred writable path for the given standard location.
    def self.writable_location(location : StandardLocation) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_standard_paths_writable_location(location.value))
    end

    # Returns every known path for the given standard location.
    def self.standard_locations(location : StandardLocation) : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_standard_paths_standard_locations(location.value))
    end

    # Returns the user-facing display name for the standard location.
    def self.display_name(location : StandardLocation) : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_standard_paths_display_name(location.value))
    end
  end
end
