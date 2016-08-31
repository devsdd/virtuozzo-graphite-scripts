set term png
unset key
set grid
set output outfile
set xlabel "Iteration"
set ylabel "Execution Time (s)"
set title "Php Benchmark\n".disk
plot [0:linecount] [0:15] infile with lines smooth csplines
