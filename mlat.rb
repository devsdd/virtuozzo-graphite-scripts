#!/usr/bin/ruby

# Max scheduling latency of every container on the box

require '/usr/local/scripts/graphite/metrics/send_metrics'

`/usr/sbin/vzstat -b -t -o id,mlat | grep '^[[:space:]].*[[:digit:]]' 2> /dev/null 1> /tmp/vzstat.out`

data = Hash[*File.read('/tmp/vzstat.out').lstrip.split(/[, \n]+/)]

g = Graphite.new

g.metric_name= "max_sched_latency"

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

