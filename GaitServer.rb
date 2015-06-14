require 'socket'
require 'json'
require_relative 'GaitBVHParsers'

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
    correction_data = {}
    
    #puts JSON.generate(angle_data)

    i = 0

    #session.puts JSON.generate(angle_data)
    File.open('MOCAP/37_01.bvh', 'r') do |mocap_file|
      mocap_file.each_line do |line|
        exploded_line = line.split
        if exploded_line[0].to_i != 0

          if correction_data[:pelvis]
            angle_data[:pelvis] = pelvis_parser(exploded_line.drop(3).take(3), correction_data[:pelvis])
            exploded_line = exploded_line.drop(6)

            angle_data[:left_thigh] =  hip_parser(exploded_line.take(3), correction_data[:left_thigh])
            exploded_line = exploded_line.drop(3)

            angle_data[:left_calf] =  knee_parser(exploded_line.take(3), correction_data[:left_calf])
            exploded_line = exploded_line.drop(6)

            angle_data[:right_thigh] =  hip_parser(exploded_line.take(3), correction_data[:right_thigh])
            exploded_line = exploded_line.drop(3)

            angle_data[:right_calf] =  knee_parser(exploded_line.take(3), correction_data[:right_calf])
            exploded_line = exploded_line.drop(6)

            angle_data[:spine_01] = chest_parser(exploded_line.take(3), correction_data[:spine_01])
            exploded_line = exploded_line.drop(3)

            angle_data[:spine_03] = chest_parser(exploded_line.take(3), correction_data[:spine_03])
            exploded_line = exploded_line.drop(3)

            angle_data[:left_clavicle] = chest_parser(exploded_line.take(3), correction_data[:left_clavicle])
            exploded_line = exploded_line.drop(3)

            angle_data[:left_upper_arm] = shoulder_parser(exploded_line.take(3), correction_data[:left_upper_arm])
            exploded_line = exploded_line.drop(3)

            angle_data[:left_lower_arm] = chest_parser(exploded_line.take(3), correction_data[:left_lower_arm])
            exploded_line = exploded_line.drop(6)

            angle_data[:right_clavicle] = chest_parser(exploded_line.take(3), correction_data[:right_clavicle])
            exploded_line = exploded_line.drop(3)

            angle_data[:right_upper_arm] = shoulder_parser(exploded_line.take(3), correction_data[:right_upper_arm])
            exploded_line = exploded_line.drop(3)

            angle_data[:right_lower_arm] = chest_parser(exploded_line.take(3), correction_data[:right_lower_arm])
            exploded_line = exploded_line.drop(6)


            puts JSON.generate(angle_data)
            session.puts JSON.generate(angle_data)
            sleep(0.04)
            
          else
            correction_data[:pelvis] = correction_parser(exploded_line.drop(3).take(3))
            exploded_line = exploded_line.drop(6)

            correction_data[:left_thigh] =  correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(3)

            correction_data[:left_calf] =  correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(6)

            correction_data[:right_thigh] =  correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(3)

            correction_data[:right_calf] =  correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(6)

            correction_data[:spine_01] = correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(3)

            correction_data[:spine_03] = correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(3)

            correction_data[:left_clavicle] = correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(3)

            correction_data[:left_upper_arm] = correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(3)

            correction_data[:left_lower_arm] = correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(6)

            correction_data[:right_clavicle] = correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(3)

            correction_data[:right_upper_arm] = correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(3)

            correction_data[:right_lower_arm] = correction_parser(exploded_line.take(3))
            exploded_line = exploded_line.drop(6)
          end
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