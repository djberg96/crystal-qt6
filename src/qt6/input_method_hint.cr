module Qt6
  @[Flags]
  enum InputMethodHint : Int32
    None                   =      0x0
    HiddenText             =      0x1
    SensitiveData          =      0x2
    NoAutoUppercase        =      0x4
    PreferNumbers          =      0x8
    PreferUppercase        =     0x10
    PreferLowercase        =     0x20
    NoPredictiveText       =     0x40
    Date                   =     0x80
    Time                   =    0x100
    PreferLatin            =    0x200
    MultiLine              =    0x400
    NoEditMenu             =    0x800
    NoTextHandles          =   0x1000
    DigitsOnly             =  0x10000
    FormattedNumbersOnly   =  0x20000
    UppercaseOnly          =  0x40000
    LowercaseOnly          =  0x80000
    DialableCharactersOnly = 0x100000
    EmailCharactersOnly    = 0x200000
    UrlCharactersOnly      = 0x400000
    LatinOnly              = 0x800000
    ExclusiveInputMask     = -0x10000
  end
end
