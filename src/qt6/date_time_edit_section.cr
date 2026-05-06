module Qt6
  @[Flags]
  enum DateTimeEditSection : Int32
    NoSection         = 0x0000
    AmPmSection       = 0x0001
    MSecSection       = 0x0002
    SecondSection     = 0x0004
    MinuteSection     = 0x0008
    HourSection       = 0x0010
    DaySection        = 0x0100
    MonthSection      = 0x0200
    YearSection       = 0x0400
    TimeSectionsMask  = 0x001f
    DateSectionsMask  = 0x0700
  end
end
