module Qt6
  # Mirrors `Qt::ShortcutContext`.
  enum ShortcutContext
    WidgetShortcut             = 0
    WindowShortcut             = 1
    ApplicationShortcut        = 2
    WidgetWithChildrenShortcut = 3
  end
end
