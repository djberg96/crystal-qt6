module Qt6
  # Wraps `QTime`.
  class QTime < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a time from hour, minute, and second components.
    def initialize(hour : Int = 0, minute : Int = 0, second : Int = 0)
      super(LibQt6.qt6cr_qtime_create(hour.to_i32, minute.to_i32, second.to_i32))
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def hour : Int32
      LibQt6.qt6cr_qtime_hour(to_unsafe)
    end

    def minute : Int32
      LibQt6.qt6cr_qtime_minute(to_unsafe)
    end

    def second : Int32
      LibQt6.qt6cr_qtime_second(to_unsafe)
    end

    def valid? : Bool
      LibQt6.qt6cr_qtime_is_valid(to_unsafe)
    end

    def to_string(format : String = "HH:mm:ss") : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qtime_to_string(to_unsafe, format.to_unsafe))
    end

    def ==(other : self) : Bool
      hour == other.hour && minute == other.minute && second == other.second
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qtime_destroy(to_unsafe)
    end
  end
end
