module Qt6
  # Wraps `QDesktopServices` as a Crystal-friendly utility module.
  module DesktopServices
    # Requests that the desktop environment open the URL.
    def self.open_url(url : QUrl) : Bool
      LibQt6.qt6cr_desktop_services_open_url(url.to_unsafe)
    end
  end
end
