module Qt6
  @[Flags]
  enum WindowState : Int32
    NoState    = 0
    Minimized  = 1
    Maximized  = 2
    FullScreen = 4
    Active     = 8
  end
end
