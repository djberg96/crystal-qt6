module Qt6
  # Wraps `QUrl` for URL and local-file path handling.
  class QUrl < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a URL from a string representation.
    def initialize(value : String = "")
      super(LibQt6.qt6cr_qurl_create(value.to_unsafe))
    end

    # Creates a file URL from a local filesystem path.
    def self.from_local_file(path : String) : self
      wrap(LibQt6.qt6cr_qurl_create_from_local_file(path.to_unsafe), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns whether the URL parses as valid.
    def valid? : Bool
      LibQt6.qt6cr_qurl_is_valid(to_unsafe)
    end

    # Returns whether the URL points to a local filesystem path.
    def local_file? : Bool
      LibQt6.qt6cr_qurl_is_local_file(to_unsafe)
    end

    # Returns the URL scheme.
    def scheme : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qurl_scheme(to_unsafe))
    end

    # Returns the URL path component.
    def path : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qurl_path(to_unsafe))
    end

    # Returns the local filesystem path for a file URL.
    def to_local_file : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qurl_to_local_file(to_unsafe))
    end

    # Returns the canonical string form of the URL.
    def to_string : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qurl_to_string(to_unsafe))
    end

    def ==(other : self) : Bool
      to_string == other.to_string
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qurl_destroy(to_unsafe)
    end
  end
end
