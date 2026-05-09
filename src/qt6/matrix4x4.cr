module Qt6
  # Simple 4x4 matrix value used by graphics transforms.
  record Matrix4x4,
    m11 : Float64,
    m12 : Float64,
    m13 : Float64,
    m14 : Float64,
    m21 : Float64,
    m22 : Float64,
    m23 : Float64,
    m24 : Float64,
    m31 : Float64,
    m32 : Float64,
    m33 : Float64,
    m34 : Float64,
    m41 : Float64,
    m42 : Float64,
    m43 : Float64,
    m44 : Float64 do
    def self.identity : self
      new(
        1.0, 0.0, 0.0, 0.0,
        0.0, 1.0, 0.0, 0.0,
        0.0, 0.0, 1.0, 0.0,
        0.0, 0.0, 0.0, 1.0
      )
    end

    def self.from_native(value : LibQt6::Matrix4x4Value) : self
      new(
        value.m11, value.m12, value.m13, value.m14,
        value.m21, value.m22, value.m23, value.m24,
        value.m31, value.m32, value.m33, value.m34,
        value.m41, value.m42, value.m43, value.m44
      )
    end

    def to_native : LibQt6::Matrix4x4Value
      LibQt6::Matrix4x4Value.new(
        m11: m11, m12: m12, m13: m13, m14: m14,
        m21: m21, m22: m22, m23: m23, m24: m24,
        m31: m31, m32: m32, m33: m33, m34: m34,
        m41: m41, m42: m42, m43: m43, m44: m44
      )
    end

    def [](row : Int, column : Int) : Float64
      case {row, column}
      when {0, 0} then m11
      when {0, 1} then m12
      when {0, 2} then m13
      when {0, 3} then m14
      when {1, 0} then m21
      when {1, 1} then m22
      when {1, 2} then m23
      when {1, 3} then m24
      when {2, 0} then m31
      when {2, 1} then m32
      when {2, 2} then m33
      when {2, 3} then m34
      when {3, 0} then m41
      when {3, 1} then m42
      when {3, 2} then m43
      when {3, 3} then m44
      else
        raise IndexError.new
      end
    end
  end
end
