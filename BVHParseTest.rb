require 'json'
require_relative 'GaitBVHParsers'

angle_data = {}

File.open('MOCAP/07_01.bvh', 'r') do |mocap_file|
  mocap_file.each_line do |line|
    exploded_line = line.split
    if exploded_line[0].to_i != 0

      angle_data[:pelvis] = pelvis_parser(exploded_line.drop(3).take(3))
      exploded_line = exploded_line.drop(6)

      angle_data[:left_thigh] =  hip_parser(exploded_line.take(3))
      exploded_line = exploded_line.drop(3)

      angle_data[:left_calf] =  knee_parser(exploded_line.take(3))
      exploded_line = exploded_line.drop(9)

      angle_data[:right_thigh] =  hip_parser(exploded_line.take(3))
      exploded_line = exploded_line.drop(3)

      angle_data[:right_calf] =  knee_parser(exploded_line.take(3))
      exploded_line = exploded_line.drop(9)

      angle_data[:spine_01] = chest_parser(exploded_line.take(3))
      exploded_line = exploded_line.drop(3)

      angle_data[:spine_03] = chest_parser(exploded_line.take(3))
      exploded_line = exploded_line.drop(3)

      puts JSON.generate(angle_data)
    end
  end
end