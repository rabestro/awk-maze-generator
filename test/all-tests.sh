#!/usr/bin/env bash

cd "$(dirname "$0")" || exit 1

for maze in *.maze
do
    echo
    echo "$maze"
    echo -n "    "
    gawk -f ../test-maze.awk -v Rows=18 -v Cols=76 "$maze"
done

