module Qt6
  @[Flags]
  enum InputDialogOption : Int32
    None                         = 0
    NoButtons                    = 0x00000001
    UseListViewForComboBoxItems  = 0x00000002
    UsePlainTextEditForTextInput = 0x00000004
  end
end
