#!/usr/bin/env gawk -f
#
# Copyright (c) 2023 Jegors Čemisovs
# License: MIT License
# Repository: https://github.com/rabestro/awk-maze-generator
#
# These variables are initialized on the command line (using '-v'):
# - Rows
# - Cols
function die(message) {print message > "/dev/stderr"; exit 1}
function assert(condition, message) {if (!condition) die(message)}
function assertEqual(actual, expected, message) {assert(actual == expected, message)}
function assertNotEqual(actual, expected, message) {assert(actual != expected, message)}

BEGIN {
    ExpectedCols = Cols * 2 + 1
    ExpectedRows = Rows * 2 + 1
    FPAT = "."
}
NF != ExpectedCols {
    die("Error: expected " ExpectedCols " columns, got " NF " at line " NR)
}
NR > ExpectedRows {
    die("Error: expected no more then " ExpectedRows " rows, got " NR)
}
{
    ++Height
}
Height == 1 && !/┌[─┬]+┐/ {
    die("Error: invalid top border")
}
$1 == "⇨" {
    if (StartRow) die("Error: multiple start points at line " NR)
    StartRow = Height
}
$NF == "⇨" {
    if (EndRow) die("Error: multiple end points at line " NR)
    EndRow = Height
}
{
    for (; NF; --NF) Grid[Height, NF] = $NF
}
ENDFILE {
    assert(StartRow, "Error: no start point")
    assert(EndRow, "Error: no end point")
    assert(Height == ExpectedRows, "Error: expected " ExpectedRows " rows, got " Height)

    check_cells()
    print "The maze is valid!"
}

function check_cells(   row,col,cell) {
    for (row = ExpectedRows; row; --row)
        for (col = ExpectedCols; col; --col) {
            cell = Grid[row, col]
            if (row == 1 || row == ExpectedRows || col == 1 || col == ExpectedCols) {
                assert(cell != " ", "Error: border at " row "," col " is empty")
            }
            if (row % 2 == 0 && col % 2 == 0) {
                assert(cell == " ", "Error: vertex at " row "," col " is not empty")
            }
            if (cell != " " && cell != "⇨") {
                assert(cell == symbol(row, col), "Error: invalid symbol '" cell "' at " row "," col ". Expected: '" symbol(row, col) "'")
            }
        }
}

function symbol(row, col,   n,e,s,w) {
    n = row > 1 && Grid[row - 1, col] != " "
    e = col < ExpectedCols && Grid[row, col + 1] != " "
    s = row < ExpectedRows && Grid[row + 1, col] != " "
    w = col > 1 && Grid[row, col - 1] != " "
    return substr(" │─└││┌├─┘─┴┐┤┬┼", 1 + n + 2 * e + 4 * s + 8 * w, 1)
}
