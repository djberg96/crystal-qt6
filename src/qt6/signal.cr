module Qt6
  class Signal(*T)
    def initialize
      @handlers = [] of Proc(*T, Nil)
    end

    def connect(&block : *T ->) : self
      @handlers << block
      self
    end

    def emit(*args : *T) : Nil
      @handlers.each do |handler|
        handler.call(*args)
      end
    end
  end
end
