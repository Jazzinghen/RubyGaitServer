require 'json'
require_relative 'GaitParsers'

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
        else
          # Do stuff
      end
    else
      puts JSON.generate(angle_data)
    end
  end
end