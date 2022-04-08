#!/bin/bash

#очистить output.csv и записать туда заданную строку
echo "multiplication type;launch count;matrix size;block size;\
threadsCnt;timer;average time;absError;relError;" > ../data/output.csv

cd ../source
make

for (( i=1; i<=8; i+=1 ))
do
./../source/main --matrix-size 9000 --multiplication-type POSIX_Threads \
                     --threads-count $i --launch-count 5
./../source/main --matrix-size 9000 --multiplication-type OpenMP \
                     --threads-count $i --launch-count 5
done

