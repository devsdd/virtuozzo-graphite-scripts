set term png
unset key
set grid
set output outfile
set xlabel "Iteration"
set ylabel "Execution Time (s)"
set title "MySQL Benchmark\n".disk."\n".operation
plot [0:linecount] infile with lines smooth csplines
