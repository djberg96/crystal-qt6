module Qt6
  # Models `QFormLayout::TakeRowResult`.
  struct FormLayoutTakeRowResult
    getter label_item : LayoutItem?
    getter field_item : LayoutItem?

    def initialize(@label_item : LayoutItem?, @field_item : LayoutItem?)
    end

    # Releases any owned extracted layout items.
    def release : Nil
      @label_item.try(&.release)
      @field_item.try(&.release)
    end
  end
end
