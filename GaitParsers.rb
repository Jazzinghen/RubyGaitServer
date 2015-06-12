## Just for self-documentation:
#    - Rotation on the X axis -> Roll
#    - Rotation on the Y axis -> Pitch
#    - Rotation on the Z axis -> Yaw
#
#  These definitions are true in Unreal Engine's 3D space, as the Z axis goes UP, while X and Y axes form a plane
#  parallel to the ground.

## Functions to parse rotation angles and place them into their respective structures
def femur_parser(rotation_data)
  rx = rotation_data[0].to_f
  ry = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  {roll:rx, pitch: ry, yaw: rz}
end

def tibia_parser(rotation_data)
  rx = rotation_data[0].to_f
  {roll: rx, pitch: 0, yaw: 0}
end

def humerus_parser(rotation_data)
  rx = rotation_data[0].to_f
  ry = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  {roll:rx, pitch: ry, yaw: rz}
end