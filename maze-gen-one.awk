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
    OFS = ""
    Rows = Rows ? Rows : 8
    Cols = Cols ? Cols : 16
    Width = 2 * Cols + 1
    Height = 2 * Rows + 1
    MaxCell = Width * Height - 1
    Seed ? srand(Seed) : srand()

    create_maze()
    generate_maze()
    print_maze()
}
function create_maze(   i) {
    for (i = Height * Width; i-- > 0;) Maze[i] = 1
    for (i = Rows * Cols; i-- > 0;) Maze[cell(i)] = 0
}
function generate_maze(   next_node,unvisited_nodes,current_node) {
    delete CellStack
    current_node = random(Rows) * Cols
    MazeEntrance = cell(current_node) - 1
    unvisited_nodes = Rows * Cols - 1
    while (unvisited_nodes) {
        find_valid_neighbors(current_node)
        if (length(Neighbors) == 0) {
            current_node = CellStack[length(CellStack)]
            delete CellStack[length(CellStack)]
        } else {
            next_node = Neighbors[random(length(Neighbors))]
            knock_down_wall(current_node, next_node)
            CellStack[length(CellStack) + 1] = current_node
            current_node = next_node
            --unvisited_nodes
        }
    }
    MazeExit = cell(random(Rows) * Cols + Cols - 1) + 1
}
function print_maze(   i) {
    for (i = 0; i < Width * Height; ++i)
        printf Width - i % Width == 1 ? "%s\n" : "%s", symbol(i)
}
function symbol(i,   n,e,s,w) {
    if (!Maze[i]) return " "
    if (is_door(i)) return "⇨"
    n = i < Width ? 0 : Maze[i - Width]
    e = Width - i % Width == 1 ? 0 : Maze[i + 1]
    s = i > MaxCell - Width ? 0 : Maze[i + Width]
    w = i % Width == 0 ? 0 : Maze[i - 1]
    return substr(" │─└││┌├─┘─┴┐┤┬┼", 1 + n + 2 * e + 4 * s + 8 * w, 1)
}
function find_valid_neighbors(i) {
    delete Neighbors
    if (i % Cols > 0) add(i - 1)
    if (i % Cols + 1 < Cols) add(i + 1)
    if (i >= Cols) add(i - Cols)
    if (i + Cols < Rows * Cols) add(i + Cols)
}
function has_all_walls(node) {
    return Maze[cell(node) + 1] && Maze[cell(node) - 1] && Maze[cell(node) - Width] && Maze[cell(node) + Width]
}
function random(bound) {return int(rand() * bound)}
function is_door(i) {return i == MazeEntrance || i == MazeExit}
function add(node) {if (has_all_walls(node)) Neighbors[length(Neighbors)] = node}
function knock_down_wall(source, target) {Maze[(cell(source) + cell(target)) / 2] = 0}
function cell(node) {return Width + 1 + int(node / Cols) * Width * 2 + node % Cols * 2}
