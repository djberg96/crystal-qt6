module Qt6
  class WhatsThisClickedEvent < QEvent
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(href : String)
      super(LibQt6.qt6cr_whats_this_clicked_event_create(href.to_unsafe), true)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def href : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_whats_this_clicked_event_href(to_unsafe))
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_whats_this_clicked_event_destroy(to_unsafe)
    end
  end
end
