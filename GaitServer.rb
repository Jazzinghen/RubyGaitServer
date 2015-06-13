require 'socket'
require 'json'
require_relative 'GaitAMCParsers'

# Wait, are there style guidelines for Ruby?
# ESPECIALLY FOR VARIABLE NAMING? O_o
server_address = "127.0.0.1"
server_port    = 15300

puts 'Starting up GaitServer'

# Server established to listen for connections on port 15300
server = TCPServer.new(server_address, server_port)

# Accept a connection, session is a TCPSocket, generated when the server accepts a new connection
while (session = server.accept)
  # Start a new threaded conversation
  Thread.start do
    angle = 0
    # First things first: we output the information on the client address and port
    # TCPSocket.peeraddr #=> [address_family, port, hostname and numeric_address]
    puts "log: Connection from #{session.peeraddr[3]} at
          #{session.peeraddr[3]}:#{session.peeraddr[1]}"
    ## lets see what the client has to say by grabbing the input
    ## then display it. Please note that the session.gets will look
    ## for an end of line character "\n" before moving forward.

    # Generate a very basic JSON structure to send to UE4
    angle_data = {} #{left_calf: {pitch: 0, yaw: 0, roll: angle}}

    #puts JSON.generate(angle_data)

    i = 0

    #session.puts JSON.generate(angle_data)
    File.open('MOCAP/08_02.amc', 'r') do |mocap_file|
      mocap_file.each_line do |line|
        exploded_line = line.split
        if exploded_line[0].to_i == 0
          case exploded_line[0]
            when 'ltibia'
              angle_data[:right_calf] = tibia_parser(exploded_line.drop(1))
            when 'rtibia'
              angle_data[:left_calf] = tibia_parser(exploded_line.drop(1))
            when 'lfemur'
              angle_data[:right_thigh] = femur_parser(exploded_line.drop(1))
            when 'rfemur'
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

          puts JSON.generate(angle_data)
          session.puts JSON.generate(angle_data)
          sleep(0.05)
        end
      end
    end
    # reply with goodbye
    ## now lets end the session since all we wanted to do is
    ## acknowledge the client
    angle_data[:left_calf][:roll] = angle+10
    session.puts JSON.generate(angle_data)
    #session.puts "Server: Goodbye\n"
  end  #end thread conversation
end   #end loop