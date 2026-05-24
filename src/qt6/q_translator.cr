module Qt6
  # Wraps `QTranslator` for loading Qt `.qm` translation catalogs.
  class QTranslator < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a translator, optionally parented to another `QObject`.
    def initialize(parent : QObject? = nil)
      super(LibQt6.qt6cr_translator_create(parent.try(&.to_unsafe) || Pointer(Void).null), parent.nil?)
    end

    # Loads a compiled Qt translation catalog.
    def load(filename : String, directory : String = "") : Bool
      LibQt6.qt6cr_translator_load(to_unsafe, filename.to_unsafe, directory.to_unsafe)
    end
  end
end
