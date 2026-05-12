module Qt6
  # Wraps `QProxyStyle`.
  class ProxyStyle < CommonStyle
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    # Creates a proxy style that forwards to the given base style.
    def initialize(base_style : Style? = nil)
      super(LibQt6.qt6cr_proxy_style_create(base_style.try(&.to_unsafe) || Pointer(Void).null), true)
      base_style.adopt_by_parent! unless base_style.nil?
    end

    # Creates a proxy style by Qt style key, such as `"Fusion"`.
    def initialize(key : String)
      super(LibQt6.qt6cr_proxy_style_create_with_key(key.to_unsafe), true)
    end

    # Returns the current base style, if one is set.
    def base_style : Style?
      handle = LibQt6.qt6cr_proxy_style_base_style(to_unsafe)
      handle.null? ? nil : Style.wrap(handle)
    end

    # Replaces the proxy's base style.
    def base_style=(value : Style?) : Style?
      LibQt6.qt6cr_proxy_style_set_base_style(to_unsafe, value.try(&.to_unsafe) || Pointer(Void).null)
      value.adopt_by_parent! unless value.nil?
      value
    end

    # Qt-style alias for `base_style=`.
    def set_base_style(value : Style?) : self
      self.base_style = value
      self
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end
  end
end
