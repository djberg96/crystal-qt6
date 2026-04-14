module Qt6
  # Wraps `QDateTime`.
  class QDateTime < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a date-time from calendar and clock components.
    def initialize(year : Int = 2000, month : Int = 1, day : Int = 1, hour : Int = 0, minute : Int = 0, second : Int = 0)
      super(LibQt6.qt6cr_qdatetime_create(year.to_i32, month.to_i32, day.to_i32, hour.to_i32, minute.to_i32, second.to_i32))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def date : QDate
      QDate.wrap(LibQt6.qt6cr_qdatetime_date(to_unsafe), true)
    end

    def time : QTime
      QTime.wrap(LibQt6.qt6cr_qdatetime_time(to_unsafe), true)
    end

    def valid? : Bool
      LibQt6.qt6cr_qdatetime_is_valid(to_unsafe)
    end

    def to_string(format : String = "yyyy-MM-dd HH:mm:ss") : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qdatetime_to_string(to_unsafe, format.to_unsafe))
    end

    def ==(other : self) : Bool
      date == other.date && time == other.time
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qdatetime_destroy(to_unsafe)
    end
  end
end
