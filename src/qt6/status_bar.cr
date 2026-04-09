module Qt6
  class StatusBar < Widget
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(parent : Widget? = nil)
      super(LibQt6.qt6cr_status_bar_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def show_message(message : String, timeout : Int = 0) : self
      LibQt6.qt6cr_status_bar_show_message(to_unsafe, message.to_unsafe, timeout)
      self
    end

    def current_message : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_status_bar_current_message(to_unsafe))
    end

    def clear_message : self
      LibQt6.qt6cr_status_bar_clear_message(to_unsafe)
      self
    end
  end
end
