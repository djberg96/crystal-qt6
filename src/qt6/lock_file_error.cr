module Qt6
  enum LockFileError : Int32
    NoError         = 0
    LockFailedError = 1
    PermissionError = 2
    UnknownError    = 3
  end
end
