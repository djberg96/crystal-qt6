module Qt6
  @[Flags]
  enum MatchFlag
    Exactly       = 0
    Contains      = 1
    StartsWith    = 2
    EndsWith      = 3
    RegularExpression = 4
    Wildcard      = 5
    FixedString   = 8
    CaseSensitive = 16
    Wrap          = 32
    Recursive     = 64
  end
end
