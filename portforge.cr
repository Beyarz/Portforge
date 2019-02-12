# # # # # # # #
# !/usr/bin/env crystal # To be honest, I don't know where I got this from.
# # # # # # #

# # # # # #
# Created July 23th 2018
# Copyright (c) 2017 Beyar N.
# # # #

# # #
# Name: portforge.cr
# #

# Library
require "socket"

# Shows the limit
def limits
  puts "[-] The port can't be lower than 1,"
  puts "[-] nor can it be higher than 65535."
end

# Shows the usage of this script
def usage
  puts "[-] Argument: #{PROGRAM_NAME} host start end"
  puts "[-] Example:  #{PROGRAM_NAME} localhost 4440 4445"
end

# Progress update
def progress(update)
  update = update.to_f
  case update
  when update < 25.00 && update > 0.00
    puts "[!] 0% started."
  when update < 50.00 && update > 25.00
    puts "[!] 25% done."
  when update < 75.00 && update > 50.00
    puts "[!] 50% half of the job completed."
  when update < 100.00 && update > 75.00
    puts "[!] 75% majority of the work has been done."
  when update < 100.00 && update > 90.00
    puts "[!] 100% finished task!"
  end
end

# ARGV to VAR
begin
  host = ARGV[0]
  portStart = ARGV[1].to_i
  portEnd = ARGV[2].to_i
rescue IndexError
  usage()
  exit(1)
end

# Class used to check
# if run as root
lib LibC
  fun getuid : UInt16
end

# Validating input
approved = 0
if ARGV.size != 3
  usage()
else
  if portStart > 65535
    limits()
  elsif portStart < 1
    limits()
  elsif portEnd > 65535
    limits()
  elsif portEnd < 1
    limits()
  elsif portStart > portEnd
    usage()
  elsif portStart < 1024
    if LibC.getuid != 0
      puts "[-] Port lower than 1024 detected."
      puts "[-] You have to run as root."
      exit(1)
    end
  else
    approve = 1
  end
end

openPorts = Array(Int32).new
closedPorts = [] of Int32
portTest = (portStart..portEnd)
notAgain = 0
time = Time.now.second
allowedUpdate = 1

puts "[!] Scan started."

# Picks every single port from the array
# and performs the check
portTest.each do |current_port|

  # Checks which port is open by
  # trying to open a socket on a port
  # and decides wether a error is thrown or not
  begin
    client = TCPSocket.new(host, current_port, dns_timeout = 5)
    openPorts << current_port
    client.close
  rescue Errno
    closedPorts << current_port
  end

  # Shows how far the scanning
  # have progressed, updates every minute
  # but performs the calculations on a
  # separate fiber
  spawn do
    if time == Time.now.second
      if allowedUpdate == 1
        status = current_port.fdiv(portEnd)*100
        puts "[+] #{status.round(2)}% done."
        allowedUpdate = 0
        sleep 1.second
        allowedUpdate = 1
      end
    end
  end

  # Tells the sceduler to continue
  Fiber.yield

end

puts "[!] Scan finished."

# Goes through each closed port
puts "[+] Forging started."

# Infinite loop until interrupted
while(true)

    counter = 0
    closedPorts.each do |port|
    begin

      # Opens a socket on each port
      server = TCPServer.new(port)

      # Accepts incoming connections and closes it
      spawn do
        server.accept do |incoming|
          incoming.gets
          incoming << "Message received."
          incoming.close
        end
      end

      # Catching the binding error, assumes it is already open
      # Moves over from closed to open as it is open now
      rescue Errno
        openPorts << closedPorts[counter]
        closedPorts.delete_at(counter)

    end

    # Displays when all ports have been moved over to
    # the other array
    if closedPorts.size < 1
      puts "[+] The ports should be open now."
      puts "[!] To end this proccess you have to interrupt it."
    end

    # Used to count the array index
    counter += 1

  end
end
