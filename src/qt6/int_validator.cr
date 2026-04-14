module Qt6
  # Wraps `QIntValidator`.
  class IntValidator < Validator
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(bottom : Int = Int32::MIN, top : Int = Int32::MAX, parent : QObject? = nil)
      super(LibQt6.qt6cr_int_validator_create(parent.try(&.to_unsafe) || Pointer(Void).null, bottom.to_i32, top.to_i32), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def bottom : Int32
      LibQt6.qt6cr_int_validator_bottom(to_unsafe)
    end

    def bottom=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_int_validator_set_bottom(to_unsafe, int_value)
      int_value
    end

    def top : Int32
      LibQt6.qt6cr_int_validator_top(to_unsafe)
    end

    def top=(value : Int) : Int32
      int_value = value.to_i32
      LibQt6.qt6cr_int_validator_set_top(to_unsafe, int_value)
      int_value
    end

    def set_range(bottom : Int, top : Int) : Range(Int32, Int32)
      min_value = bottom.to_i32
      max_value = top.to_i32
      LibQt6.qt6cr_int_validator_set_range(to_unsafe, min_value, max_value)
      min_value..max_value
    end
  end
end
