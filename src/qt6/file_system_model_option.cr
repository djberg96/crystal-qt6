module Qt6
  @[Flags]
  enum FileSystemModelOption : Int32
    DontWatchForChanges = 0x00000001
    DontResolveSymlinks = 0x00000002
    DontUseCustomDirectoryIcons = 0x00000004
  end
end
