module Qt6
  # Wraps `QDate`.
  class QDate < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a date from year, month, and day components.
    def initialize(year : Int = 2000, month : Int = 1, day : Int = 1)
      super(LibQt6.qt6cr_qdate_create(year.to_i32, month.to_i32, day.to_i32))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def year : Int32
      LibQt6.qt6cr_qdate_year(to_unsafe)
    end

    def month : Int32
      LibQt6.qt6cr_qdate_month(to_unsafe)
    end

    def day : Int32
      LibQt6.qt6cr_qdate_day(to_unsafe)
    end

    def valid? : Bool
      LibQt6.qt6cr_qdate_is_valid(to_unsafe)
    end

    def to_string(format : String = "yyyy-MM-dd") : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qdate_to_string(to_unsafe, format.to_unsafe))
    end

    def ==(other : self) : Bool
      year == other.year && month == other.month && day == other.day
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qdate_destroy(to_unsafe)
    end
  end
end
