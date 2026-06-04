module Qt6
  record LockFileInfo, pid : Int64, hostname : String, app_name : String do
    def self.from_native(value : LibQt6::LockFileInfoValue) : self?
      hostname = Qt6.copy_and_release_string(value.hostname)
      app_name = Qt6.copy_and_release_string(value.app_name)
      value.valid ? new(value.pid, hostname, app_name) : nil
    end
  end
end
