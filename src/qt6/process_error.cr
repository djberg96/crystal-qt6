module Qt6
  enum ProcessError : Int32
    FailedToStart = 0
    Crashed       = 1
    Timedout      = 2
    ReadError     = 3
    WriteError    = 4
    UnknownError  = 5
  end
end
