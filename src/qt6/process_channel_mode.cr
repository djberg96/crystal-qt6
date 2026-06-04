module Qt6
  enum ProcessChannelMode : Int32
    SeparateChannels       = 0
    MergedChannels         = 1
    ForwardedChannels      = 2
    ForwardedOutputChannel = 3
    ForwardedErrorChannel  = 4
  end
end
