module Qt6
  @[Flags]
  enum WizardOption : Int32
    IndependentPages             = 0x00000001
    IgnoreSubTitles              = 0x00000002
    ExtendedWatermarkPixmap      = 0x00000004
    NoDefaultButton              = 0x00000008
    NoBackButtonOnStartPage      = 0x00000010
    NoBackButtonOnLastPage       = 0x00000020
    DisabledBackButtonOnLastPage = 0x00000040
    HaveNextButtonOnLastPage     = 0x00000080
    HaveFinishButtonOnEarlyPages = 0x00000100
    NoCancelButton               = 0x00000200
    CancelButtonOnLeft           = 0x00000400
    HaveHelpButton               = 0x00000800
    HelpButtonOnRight            = 0x00001000
    HaveCustomButton1            = 0x00002000
    HaveCustomButton2            = 0x00004000
    HaveCustomButton3            = 0x00008000
    NoCancelButtonOnLastPage     = 0x00010000
    StretchBanner                = 0x00020000
  end
end
