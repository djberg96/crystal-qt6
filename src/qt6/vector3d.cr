module Qt6
  # Simple 3D vector value used by graphics transforms.
  record Vector3D, x : Float64, y : Float64, z : Float64 do
    def self.from_native(value : LibQt6::Vector3DValue) : self
      new(value.x, value.y, value.z)
    end

    def to_native : LibQt6::Vector3DValue
      LibQt6::Vector3DValue.new(x: x, y: y, z: z)
    end
  end
end
