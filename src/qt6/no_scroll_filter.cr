module Qt6
  # Blocks wheel events on unfocused widgets, matching the common editor-panel
  # "scroll guard" pattern used by PySide applications.
  class NoScrollFilter < EventFilter
    def initialize(parent : QObject? = nil)
      super(parent)
      on_event do |watched, event|
        if watched && event.type == EventType::Wheel && !watched.has_focus?
          event.ignore
          true
        else
          false
        end
      end
    end
  end
end
