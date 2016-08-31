# virtuozzo-graphite-scripts
Scripts to collect metrics from Virtuozzo servers and push them to graphite

## send_metrics.rb
contains common classes and modules which need to be called through every other script.

Every other script queries system counters to find the values of a single metric for every container on the box and uses send_metrics.rb to actually push them to the designated graphite server.
