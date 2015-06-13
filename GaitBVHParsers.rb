## Just for self-documentation:
#    - Rotation on the X axis -> Roll
#    - Rotation on the Y axis -> Pitch
#    - Rotation on the Z axis -> Yaw
#
#  These definitions are true in Unreal Engine's 3D space, as the Z axis goes UP, while X and Y axes form a plane
#  parallel to the ground.

## BVH notes:
#    - Looks like in BVH the order of the angles is ZXY, which, in our case, is YXZ
#    - Animation frames are just a LINE of rotations and translations, based on the definitions of the bones. To
#      extract information it is needed to analyse them in order. In CMU case, for example, the data is like this:
#      Hips_tr_z Hips_tr_x Hips_tr_y Hips_rt_z Hips_rt_x Hips_rt_y LeftHip_rt_z LeftHip_rt_x LeftHip_rt_y [and so on]

## Conversion BVH to Unreal Engine 4 bones:
#      BVH                     Unreal Engine 4
#
#    - Hips                 -> Pelvis
#    - Left/Right Hip       -> Thigh_l/r
#    - Left/Right Knee      -> Calf_l/r
#    - Left/Right Ankle     -> Foot_l/r
#    - Chest                -> Spine_01
#    - CS_BVH               -> Spine_03                 [We miss an intermediate bone: the doll will be a little stiff]
#    - Left/Right Shoulder  -> UpperArm_l/r
#    - Left/Right Elbow     -> LowerArm_l/r
#    - Left/Right Wrist     -> Hand_l/r
#    - Head                 -> Neck_01

## Functions to parse rotation angles and place them into their respective structures
def hip_parser(rotation_data)
  rx = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  ry = rotation_data[0].to_f
  {roll:rx, pitch: ry, yaw: rz}
end

def knee_parser(rotation_data)
  rx = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  ry = rotation_data[0].to_f
  {roll: rx, pitch: ry, yaw: rz}
end

def shoulder_parser(rotation_data)
  rx = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  ry = rotation_data[0].to_f
  {roll:rx, pitch: ry, yaw: rz}
end

def elbow_parser(rotation_data)
  rx = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  ry = rotation_data[0].to_f
  {roll:rx, pitch: ry, yaw: rz}
end

def neck_parser(rotation_data)
  rx = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  ry = rotation_data[0].to_f
  {roll:rx, pitch: ry, yaw: rz}
end

def chest_parser(rotation_data)
  rx = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  ry = rotation_data[0].to_f
  {roll:rx, pitch: ry, yaw: rz}
end

def root_parser(rotation_data)
  rx = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  ry = rotation_data[0].to_f
  {roll:rx, pitch: ry, yaw: rz}
end

def pelvis_parser(rotation_data)
  rx = rotation_data[1].to_f
  rz = rotation_data[2].to_f
  ry = rotation_data[0].to_f
  {roll:rx, pitch: ry, yaw: rz}
end