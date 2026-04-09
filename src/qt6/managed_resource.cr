module Qt6
  module ManagedResource
    abstract def release : Nil
    abstract def destroyed? : Bool
  end
end