module Qt6
  @[Flags]
  enum KeyboardModifier : Int32
    NoModifier          =          0
    ShiftModifier       =   33554432
    ControlModifier     =   67108864
    AltModifier         =  134217728
    MetaModifier        =  268435456
    KeypadModifier      =  536870912
    GroupSwitchModifier = 1073741824
  end
end
