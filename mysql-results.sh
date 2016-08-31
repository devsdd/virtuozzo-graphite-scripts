#!/bin/sh

logfile="/var/log/mysql-bench.log"
var=`hostname`
outdir="./mysql"

test -d $outdir || mkdir $outdir

awk '/^alter-table:/ {print $4}' $logfile > $outdir/alter-table.csv
awk '/^big-tables:/ {print $4}' $logfile > $outdir/big-tables.csv
# don't really need connect values as they're insignificantly small for local connections
# awk '/^connect:/ {print $4}' $logfile > $outdir/connect.csv
awk '/^create:/ {print $4}' $logfile > $outdir/create.csv
awk '/^insert:/ {print $4}' $logfile > $outdir/insert.csv
awk '/^select:/ {print $4}' $logfile > $outdir/select.csv
