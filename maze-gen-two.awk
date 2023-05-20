#!/usr/bin/env gawk -f
#
# Copyright (c) 2023 Jegors Čemisovs
# License: MIT License
# Repository: https://github.com/rabestro/awk-maze-generator
#
# These variables are initialized on the command line (using '-v'):
# - Rows
# - Cols
# - Seed (optional)

BEGIN {
    Rows = Rows ? Rows : 8
    Cols = Cols ? Cols : 16
    Seed ? srand(Seed) : srand()

    Width = 2 * Cols + 1
    Height = 2 * Rows + 1

    create_grid()
    generate_maze(1, 1)
    clear_doors()
    print_maze()
}

function create_grid(    row, col) {
    for (row = 0; row < Height; row++)
        for (col = 0; col < Width; col++)
            Grid[row, col] = 1
}
function print_maze(   row, col) {
    for (row = 0; row < Height; row++) {
        for (col = 0; col < Width; col++)
            $(col + 1) = symbol(row, col)
        print
    }
}

# Recursive backtracking algorithm
function generate_maze(row, col,   directions,randDir,dx,dy,newRow,newCol) {
    Grid[row, col] = 0

    directions = "NESW"
    while (length(directions) > 0) {
        randDir = substr(directions, int(rand() * length(directions)) + 1, 1)
        dx = dy = 0
        if (randDir == "N") dy = -2
        if (randDir == "E") dx = 2
        if (randDir == "S") dy = 2
        if (randDir == "W") dx = -2

        newRow = row + dy
        newCol = col + dx
        if (newRow > 0 && newRow < Height && newCol > 0 && newCol < Width && Grid[newRow, newCol]) {
            Grid[row + dy / 2, col + dx / 2] = 0
            generate_maze(newRow, newCol)
        }
        directions = gensub(randDir, "", "1", directions)
    }
}
function clear_doors() {
    Grid[1 + 2 * int(rand() * Rows), 0] = 0
    Grid[1 + 2 * int(rand() * Rows), Width - 1] = 0
}
function symbol(row, col,   n,e,s,w) {
    if (!Grid[row, col])
        return col == 0 || col == Width - 1 ? "⇨" : " "
    n = row ? Grid[row - 1, col] : 0
    e = col < Width - 1 ? Grid[row, col + 1] : 0
    s = row < Height - 1 ? Grid[row + 1, col] : 0
    w = col ? Grid[row, col - 1] : 0
    return substr(" │─└││┌├─┘─┴┐┤┬┼", 1 + n + 2 * e + 4 * s + 8 * w, 1)
}
