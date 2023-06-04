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
    setup()
    create_grid()
    generate_maze(FirstNodeIndex)
    clear_doors()
    print_maze()
}

function setup() {
    OFS = ""
    if (!Rows) die("number of rows must be specified")
    if (!Cols) die("number of columns must be specified")
    Seed ? srand(Seed) : srand()
}

function create_grid() {
    Width = 2 * Cols + 1
    Height = 2 * Rows + 1
    while (GridSize < Width * Height)
        Grid[GridSize++] = 1
    FirstNodeIndex = Width + 1
}

function generate_maze(source,   directions,direction,target) {
    visit(source)
    for (directions = "NEWS"; length(directions); sub(direction, "", directions)) {
        direction = substr(directions, int(rand() * length(directions)) + 1, 1)
        target = next_node_index(source, direction)
        if (is_visited(target)) continue
        knock_down_wall(source, target)
        generate_maze(target)
    }
}

function clear_doors() {
    Grid[(1 + 2 * int(rand() * Rows)) * Width] = 0
    Grid[(1 + 2 * int(rand() * Rows)) * Width + Width - 1] = 0
}

function print_maze(   row, col) {
    for (row = 0; row < Height; row++) {
        for (col = 0; col < Width; col++)
            $(col + 1) = Grid[row * Width + col] ? "##" : "  "
        print
    }
}

function next_node_index(i, direction) {
    if (direction == "N" && i > 2 * Width)
        return i - 2 * Width
    if (direction == "S" && i < GridSize - 2 * Width)
        return i + 2 * Width
    if (direction == "E" && i % Width < Width - 2)
        return i + 2
    if (direction == "W" && i % Width > 2)
        return i - 2
    return -1
}
function visit(nodeIndex) {Grid[nodeIndex] = 0}
function is_visited(target) {return !Grid[target]}
function knock_down_wall(source, target) {Grid[(source + target) / 2] = 0}
function die(message) {print message > "/dev/stderr"; exit 1}
