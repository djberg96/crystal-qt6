module Qt6
  record ProcessStartResult, started : Bool, process_id : Int64 do
    def self.from_native(value : LibQt6::ProcessStartResultValue) : self
      new(value.started, value.process_id)
    end
  end
end
