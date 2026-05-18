module Qt6
  @[Flags]
  enum StyleSubControl : Int32
    ScrollBarAddLine        = 0x00000001
    ScrollBarSubLine        = 0x00000002
    ScrollBarAddPage        = 0x00000004
    ScrollBarSubPage        = 0x00000008
    ScrollBarFirst          = 0x00000010
    ScrollBarLast           = 0x00000020
    ScrollBarSlider         = 0x00000040
    ScrollBarGroove         = 0x00000080
    SpinBoxUp               = 0x00000001
    SpinBoxDown             = 0x00000002
    SpinBoxFrame            = 0x00000004
    SpinBoxEditField        = 0x00000008
    ComboBoxFrame           = 0x00000001
    ComboBoxEditField       = 0x00000002
    ComboBoxArrow           = 0x00000004
    ComboBoxListBoxPopup    = 0x00000008
    SliderGroove            = 0x00000001
    SliderHandle            = 0x00000002
    SliderTickmarks         = 0x00000004
    ToolButton              = 0x00000001
    ToolButtonMenu          = 0x00000002
    TitleBarSysMenu         = 0x00000001
    TitleBarMinButton       = 0x00000002
    TitleBarMaxButton       = 0x00000004
    TitleBarCloseButton     = 0x00000008
    TitleBarNormalButton    = 0x00000010
    TitleBarShadeButton     = 0x00000020
    TitleBarUnshadeButton   = 0x00000040
    TitleBarContextHelpButton = 0x00000080
    TitleBarLabel           = 0x00000100
    DialGroove              = 0x00000001
    DialHandle              = 0x00000002
    DialTickmarks           = 0x00000004
    GroupBoxCheckBox        = 0x00000001
    GroupBoxLabel           = 0x00000002
    GroupBoxContents        = 0x00000004
    GroupBoxFrame           = 0x00000008
    MdiMinButton            = 0x00000001
    MdiNormalButton         = 0x00000002
    MdiCloseButton          = 0x00000004
    CustomBase              = -268435456
  end
end
