module Qt6
  # Wraps `QStyleFactory` as a static helper namespace.
  module StyleFactory
    extend self

    # Returns the available Qt style keys for this platform.
    def keys : Array(String)
      Qt6.copy_and_release_strings(LibQt6.qt6cr_style_factory_keys)
    end

    # Creates a style instance for the given Qt style key, if available.
    def create(key : String) : Style?
      handle = LibQt6.qt6cr_style_factory_create(key.to_unsafe)
      handle.null? ? nil : Style.wrap(handle, true)
    end
  end
end
