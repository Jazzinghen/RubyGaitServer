require 'socket'

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
    # First things first: we output the information on the client address and port
    # TCPSocket.peeraddr #=> [address_family, port, hostname and numeric_address]
    puts "log: Connection from #{session.peeraddr[3]} at
          #{session.peeraddr[3]}:#{session.peeraddr[1]}"
    ## lets see what the client has to say by grabbing the input
    ## then display it. Please note that the session.gets will look
    ## for an end of line character "\n" before moving forward.
    # input = session.gets
    # puts input

    # Let's send something to the client, to acknowledge the connection
    session.puts "Server: Welcome #{session.peeraddr[2]}\n"
    # reply with goodbye
    ## now lets end the session since all we wanted to do is
    ## acknowledge the client
    puts "log: sending goodbye"
    session.puts "Server: Goodbye\n"
  end  #end thread conversation
end   #end loop