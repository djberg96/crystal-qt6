module Qt6
  # Generic wrapper for existing `QLayout` handles when the concrete subtype
  # is not known or not important.
  class LayoutHandle < Layout
    def self.wrap(handle : LibQt6::Handle) : self
      new(handle)
    end

    protected def initialize(handle : LibQt6::Handle)
      super(handle)
    end
  end
end
