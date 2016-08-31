#!/usr/bin/ruby

# output container ID and load average of every container on the box and send it to graphite
require '/usr/local/scripts/graphite/metrics/send_metrics'

`/usr/sbin/vzlist --no-header --output ctid,laverage 2> /dev/null 1> /tmp/load_avgs`

data = Hash[*File.read('/tmp/load_avgs').lstrip.split(/[, \n]+/)]

g = Graphite.new

g.metric_name= "1_min_load_avg"

# need to dump data into tempfile as graphite doesn't seem to handle multiple TCP sockets on loop-through well
g.tempfile= "/tmp/" + g.metric_name

f = File.open(g.tempfile, "w")
data.each { |key, value|
# Graphite format
        if "#{key}" !~ /^-/ then
                f.printf "%s%s.%s %.2f %d\n", "#{Graphite::PREFIX}", "#{key}".gsub('.', '-'), g.metric_name, " #{value.split('/')[0]}", Time.now.to_i
        end
}
f.close

g.send_metric

