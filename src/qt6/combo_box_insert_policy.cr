module Qt6
  # Insert behavior used by `QComboBox` when editable text becomes a new item.
  enum ComboBoxInsertPolicy : Int32
    NoInsert             = 0
    InsertAtTop          = 1
    InsertAtCurrent      = 2
    InsertAtBottom       = 3
    InsertAfterCurrent   = 4
    InsertBeforeCurrent  = 5
    InsertAlphabetically = 6
  end
end
