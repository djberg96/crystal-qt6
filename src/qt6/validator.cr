module Qt6
  # Wraps `QValidator`.
  class Validator < QObject
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Validates the given input string.
    def validate(input : String) : ValidatorState
      ValidatorState.from_value(LibQt6.qt6cr_validator_validate(to_unsafe, input.to_unsafe))
    end
  end
end
