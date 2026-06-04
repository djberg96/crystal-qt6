module Qt6
  class FileOpenEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(file : String)
      super(LibQt6.qt6cr_file_open_event_create_file(file.to_unsafe), true)
    end

    def initialize(url : QUrl)
      super(LibQt6.qt6cr_file_open_event_create_url(url.to_unsafe), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def file : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_file_open_event_file(to_unsafe))
    end

    def url : QUrl
      QUrl.wrap(LibQt6.qt6cr_file_open_event_url(to_unsafe), true)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_file_open_event_destroy(to_unsafe)
    end
  end
end
