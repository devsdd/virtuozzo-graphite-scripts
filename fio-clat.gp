set term png
unset key
set grid
set output outfile
set xlabel "Iteration"
set ylabel "Execution Time (μs)"
set title "fio Benchmark\n".disk."\nCompletion Latencies\n".operation."s"
plot [0:linecount] [0:ylimit] infile with lines 
