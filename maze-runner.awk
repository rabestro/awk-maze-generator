#!/usr/bin/env gawk -f
#
# Copyright (c) 2023 Jegors Čemisovs
# License: MIT License
# Repository: https://github.com/rabestro/awk-maze-generator
#

BEGIN {
    FPAT = "."
    OFS = ""
}

NR == 1 {
    Width = NF
}
{
    ++Height
}
$1 == "⇨" {
    StartRow = Height
}
$NF == "⇨" {
    EndRow = Height
}
{
    for (;NF;--NF) Grid[Height, NF] = $NF
}

END {
    if (find_path(StartRow, 2)) {
        print_maze()
    } else {
        print "Path not found"
    }
}

function find_path(row, col) {
    if (row < 1 || row > Height || col < 1 || col > Width || Grid[row, col] != " ") return 0
    Grid[row, col] = "⋅"
    if (row == EndRow && col == Width - 1 \
        || find_path(row + 1, col) || find_path(row - 1, col) \
        || find_path(row, col + 1) || find_path(row, col -1)) return 1
    Grid[row, col] = " "
    return 0
}

function print_maze(   row, col) {
    while (row++ < Height) {
        for (col = Width; col; --col)
            $col = Grid[row, col]
        print
    }
}
