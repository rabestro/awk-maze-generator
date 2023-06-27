#!/usr/bin/env bash

for maze in *.maze
do
    echo
    echo "$maze"
    echo -n "    "
    gawk -f ../maze-test.awk -v Rows=18 -v Cols=76 "$maze"
done
