module Qt6
  struct PageLayout
    getter page_size : PageSize
    getter orientation : PageOrientation
    getter margins : MarginsF

    def initialize(page_size : PageSize, orientation : PageOrientation = PageOrientation::Portrait, margins : MarginsF = MarginsF.new(0.0, 0.0, 0.0, 0.0))
      @page_size = page_size
      @orientation = orientation
      @margins = margins
    end
  end
end
