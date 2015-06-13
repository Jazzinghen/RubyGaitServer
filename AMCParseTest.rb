require 'json'
require_relative 'GaitAMCParsers'

angle_data = {}

File.open('MOCAP/91_04.amc', 'r') do |mocap_file|
  mocap_file.each_line do |line|
    exploded_line = line.split
    if exploded_line[0].to_i == 0
      case exploded_line[0]
        when 'rtibia'
          angle_data[:right_calf] = tibia_parser(exploded_line.drop(1))
        when 'ltibia'
          angle_data[:left_calf] = tibia_parser(exploded_line.drop(1))
        when 'rfemur'
          angle_data[:right_thigh] = femur_parser(exploded_line.drop(1))
        when 'lfemur'
          angle_data[:left_thigh] = femur_parser(exploded_line.drop(1))
        when 'rhumerus'
          angle_data[:right_upperarm] = humerus_parser(exploded_line.drop(1))
        when 'lhumerus'
          angle_data[:left_upperarm] = humerus_parser(exploded_line.drop(1))
        when 'lowerback'
          angle_data[:spine_01] = spine_parser(exploded_line.drop(1))
        when 'upperback'
          angle_data[:spine_02] = spine_parser(exploded_line.drop(1))
        when 'thorax'
          angle_data[:spine_03] = spine_parser(exploded_line.drop(1))
        when 'upperneck'
          angle_data[:neck] = neck_parser(exploded_line.drop(1))
        when 'head'
          angle_data[:head] = neck_parser(exploded_line.drop(1))
        when 'root'
          angle_data[:root] = root_parser(exploded_line.drop(4))
        when 'lhipjoint'
          angle_data[:left_hip_joint] = hip_parser(exploded_line.drop(1))
        when 'rhipjoint'
          angle_data[:right_hip_joint] = hip_parser(exploded_line.drop(1))
        else
          # Do stuff
      end
    else


      if angle_data[:left_hip_joint]
        angle_data[:left_hip_joint].each do |key, value|
          angle_data[:left_hip_joint][key] = value - angle_data[:root][key]
        end
      end

      if angle_data[:right_hip_joint]
        angle_data[:right_hip_joint].each do |key, value|
          angle_data[:right_hip_joint][key] = value - angle_data[:root][key]
        end
      end

      if angle_data[:left_thigh]
        angle_data[:left_thigh].each do |key, value|
          angle_data[:left_thigh][key] = value - angle_data[:root][key]
        end
      end

      if angle_data[:right_thigh]
        angle_data[:right_thigh].each do |key, value|
          angle_data[:right_thigh][key] = value - angle_data[:root][key]
        end
      end

      if angle_data[:left_calf]
        angle_data[:left_calf].each do |key, value|
          angle_data[:left_calf][key] = value - angle_data[:left_thigh][key]
        end
      end

      if angle_data[:right_calf]
        angle_data[:right_calf].each do |key, value|
          angle_data[:right_calf][key] = value - angle_data[:right_thigh][key]
        end
      end


      puts JSON.generate(angle_data)
    end
  end
end