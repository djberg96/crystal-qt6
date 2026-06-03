module Qt6
  @[Flags]
  enum ModelCheckIndexOption
    NoOption        = 0
    IndexIsValid    = 1
    DoNotUseParent  = 2
    ParentIsInvalid = 4
  end
end
