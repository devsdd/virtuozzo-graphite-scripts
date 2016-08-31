#!/usr/bin/ruby

# base class and module which exposes methods to connect to and send metrics to the graphite server over TCP sockets
# include this file in every individual metric's collection script

require 'socket'

# need a mapping of container ID's and their respective hostnames
class Container_IDs_to_names
    o = Hash[%x{/usr/sbin/vzlist --no-header --output ctid,hostname}.split(/[, \n]+/)]
end

# Prefix needed for every single metric line as per graphite format
module Common_parameters
    # Make these class constants, since their values are not going to change
    HNAME = Socket.gethostname
    REV_HNAME = HNAME.split('.').reverse.join('.')
end

class Graphite
    include Common_parameters
    # Make these class constants, since their values are not going to change
    PREFIX = "my.product." + REV_HNAME + ".per-vps."
    GRAPHITE_SERVER = "INSERT GRAPHITE SERVER FQDN/IP HERE"
    GRAPHITE_PORT = 2003;

        attr_accessor :metric_name, :tempfile                             
                                                                                            
        def send_metric                                                                     
                @s = TCPSocket.open(GRAPHITE_SERVER, GRAPHITE_PORT)                         
                @s.write File.read(tempfile)                                                
                @s.close                                                                    
        end
end

