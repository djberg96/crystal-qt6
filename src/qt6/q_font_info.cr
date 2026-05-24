module Qt6
  # Wraps `QFontInfo` for resolved font information after Qt style substitution.
  class QFontInfo < NativeResource
    def self.wrap(handle : LibQt6::Handle, owned : Bool = false) : self
      new(handle, owned)
    end

    protected def initialize(handle : LibQt6::Handle, owned : Bool)
      super(handle, owned)
    end

    # Returns the resolved font family.
    def family : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qfont_info_family(to_unsafe))
    end

    # Returns the resolved style name.
    def style_name : String
      Qt6.copy_and_release_string(LibQt6.qt6cr_qfont_info_style_name(to_unsafe))
    end

    # Returns the resolved point size.
    def point_size : Int32
      LibQt6.qt6cr_qfont_info_point_size(to_unsafe)
    end

    # Returns the resolved floating-point point size.
    def point_size_f : Float64
      LibQt6.qt6cr_qfont_info_point_size_f(to_unsafe)
    end

    # Returns `true` if the resolved font is italic.
    def italic? : Bool
      LibQt6.qt6cr_qfont_info_italic(to_unsafe)
    end

    # Returns `true` if the resolved font is bold.
    def bold? : Bool
      LibQt6.qt6cr_qfont_info_bold(to_unsafe)
    end

    # Returns the resolved font weight.
    def weight : Int32
      LibQt6.qt6cr_qfont_info_weight(to_unsafe)
    end

    # Returns `true` if the resolved font is fixed-pitch.
    def fixed_pitch? : Bool
      LibQt6.qt6cr_qfont_info_fixed_pitch(to_unsafe)
    end

    # Returns `true` if the requested font resolved exactly.
    def exact_match? : Bool
      LibQt6.qt6cr_qfont_info_exact_match(to_unsafe)
    end

    protected def destroy_native : Nil
      LibQt6.qt6cr_qfont_info_destroy(to_unsafe)
    end
  end
end
