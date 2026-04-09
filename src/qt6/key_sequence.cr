module Qt6
  record KeySequence, value : String do
    def to_s : String
      value
    end

    def to_s(io : IO) : Nil
      io << value
    end
  end
end
