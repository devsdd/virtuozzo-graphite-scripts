set term png
unset key
set grid
set output outfile
set xlabel "Iteration"
set ylabel "Response Time (ms)"
# set label 1 gprintf("Mean = %g", mean_y)
set title "Apache Benchmark\n90th Percentile\nKVM + ".disk
plot [0:linecount] [0:50] infile with lines smooth csplines
