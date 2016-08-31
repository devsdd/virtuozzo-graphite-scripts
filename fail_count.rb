#!/usr/bin/ruby

# Internal virtuozzo counter keeps a count of every time a container hits a resource limit (like max allocated RAM, max no. of processes etc.) Send this info to graphite
require '/usr/local/scripts/graphite/metrics/send_metrics'

`/usr/sbin/vzstat -b -t -o id,fcnt | grep '^[[:space:]].*[[:digit:]]' 2> /dev/null 1> /tmp/vzstat.out`

data = Hash[*File.read('/tmp/vzstat.out').lstrip.split(/[, \n]+/)]

g = Graphite.new

g.metric_name= "fail_count"

# need to dump data into tempfile as graphite doesn't seem to handle multiple TCP sockets on loop-through well
g.tempfile= "/tmp/" + g.metric_name

f = File.open(g.tempfile, "w")
data.each { |key, value|
# Graphite format
        if "#{key}" !~ /^-/ then
                f.printf "%s%s.%s %d %d\n", "#{Graphite::PREFIX}", "#{key}", g.metric_name, " #{value}", Time.now.to_i
        end
}
f.close
 
g.send_metric
