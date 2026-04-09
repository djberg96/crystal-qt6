module Qt6
  # Minimal Crystal-side signal object for composing callbacks.
  class Signal(*T)
    # Creates an empty signal with no handlers attached.
    def initialize
      @handlers = [] of Proc(*T, Nil)
    end

    # Registers a callback to be invoked when the signal emits.
    def connect(&block : *T ->) : self
      @handlers << block
      self
    end

    # Invokes each registered callback with the supplied arguments.
    def emit(*args : *T) : Nil
      @handlers.each do |handler|
        handler.call(*args)
      end
    end
  end
end
