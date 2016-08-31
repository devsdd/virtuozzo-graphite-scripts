set term png
unset key
set grid
set output outfile
set xlabel "Iteration"
set ylabel operation." IOPS"
set title "fio Benchmark\n".disk."\n".operation." IOPS"
plot [0:linecount] [0:ylimit] infile with lines smooth csplines
