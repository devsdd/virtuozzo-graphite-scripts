#!/bin/sh

# script to dump the key results from fio data

logfile="/var/log/fio/data/fio.log"
outdir="./fio"
riops_file="$outdir/read_iops.csv"
wiops_file="$outdir/write_iops.csv"
rclat_file="$outdir/read_clat.csv"
wclat_file="$outdir/write_clat.csv"
outfile="$outdir/fio.tsv"

test -d $outdir || mkdir $outdir

/usr/bin/awk '/read/ {if(match($6,"iops")) print $6}' $logfile  | /usr/bin/cut -d '=' -f 2 > $riops_file
/usr/bin/awk '/read/ {if(match($7,"iops")) print $7}' $logfile  | /usr/bin/cut -d '=' -f 2 >> $riops_file

/usr/bin/awk '/write/ {if(match($5,"iops")) print $5}' $logfile  | /usr/bin/cut -d '=' -f 2 > $wiops_file
/usr/bin/awk '/write/ {if(match($6,"iops")) print $6}' $logfile  | /usr/bin/cut -d '=' -f 2 >> $wiops_file

grep -A1 'read' $logfile | awk -F ',' '/clat/ {print $(NF-1)}' | cut -d '=' -f 2 | sed 's/^ //g' > $rclat_file
grep -A1 'write' $logfile | awk -F ',' '/clat/ {print $(NF-1)}' | cut -d '=' -f 2 | sed 's/^ //g' > $wclat_file
