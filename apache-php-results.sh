#!/bin/sh

awk '/90%/ {print $NF}' /var/log/apache-bench.log > apache-bench.csv
awk '/^Total/ {print $4}' /var/log/php-bench.log > php-bench.csv
