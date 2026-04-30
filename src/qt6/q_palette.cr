module Qt6
  # Wraps `QPalette` for theme-aware widget and painter colors.
  class QPalette < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a default palette.
    def initialize
      super(LibQt6.qt6cr_qpalette_create)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the color for the current palette group and role.
    def color(role : ColorRole) : Color
      Color.from_native(LibQt6.qt6cr_qpalette_color(to_unsafe, role.value))
    end

    # Returns the color for the given palette group and role.
    def color(group : ColorGroup, role : ColorRole) : Color
      Color.from_native(LibQt6.qt6cr_qpalette_color_for_group(to_unsafe, group.value, role.value))
    end

    # Sets the color for all palette groups.
    def set_color(role : ColorRole, color : Color) : self
      LibQt6.qt6cr_qpalette_set_color(to_unsafe, role.value, color.to_native)
      self
    end

    # Sets the color for the given palette group and role.
    def set_color(group : ColorGroup, role : ColorRole, color : Color) : self
      LibQt6.qt6cr_qpalette_set_color_for_group(to_unsafe, group.value, role.value, color.to_native)
      self
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qpalette_destroy(to_unsafe)
    end
  end
end
