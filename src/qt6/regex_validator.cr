module Qt6
  # Wraps `QRegularExpressionValidator`.
  class RegexValidator < Validator
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    def initialize(pattern : String = "", parent : QObject? = nil)
      super(LibQt6.qt6cr_regex_validator_create(parent.try(&.to_unsafe) || Pointer(Void).null, pattern.to_unsafe), parent.nil?)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    def pattern : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_regex_validator_pattern(to_unsafe))
    end

    def pattern=(value : String) : String
      LibQt6.qt6cr_regex_validator_set_pattern(to_unsafe, value.to_unsafe)
      value
    end
  end
end
