#!/usr/bin/env gawk -f
# These variables are initialized on the command line (using '-v'):
# - Rows
# - Cols

BEGIN {
    Cols = 22
    Rows = 10
    Width = 2 * Cols + 1
    Hight = 2 * Rows + 1

    OFS = ""

    create_maze()
    generate_maze()
    print_maze()
}

function create_maze(   i) {
    for (i = Hight * Width; i-- > 0;) Maze[i] = 1
    for (i = Rows * Cols; i-- > 0;) Maze[cell(i)] = 0
}

function generate_maze(   current_cell,n_visited,n_cells,next_cell) {
    delete CellStack
    n_cells = Rows * Cols
    current_cell = 0
    n_visited = 1

    clear_enter()
    while (n_visited < n_cells) {
        find_valid_neighbors(current_cell)
        if (length(Neighbors) == 0) {
            current_cell = CellStack[length(CellStack)]
            delete CellStack[length(CellStack)]
            continue
        }
        next_cell = Neighbors[int(rand()*length(Neighbors))]
        knock_down_wall(current_cell, next_cell)
        CellStack[length(CellStack) + 1] = current_cell
        current_cell = next_cell
        ++n_visited
    }
    clear_exit()
}

function print_maze(   row,col) {
    for (row = 0; row < Hight; ++row) {
        for (col = 0; col < Width; ++col) {
            $(1 + col) = Maze[row * Width + col] ? "██" : "  "
        }
        print
    }
}

function find_valid_neighbors(i) {
    delete Neighbors
    if (i % Cols > 0) add_neighbor(i - 1)
    if (i % Cols + 1 < Cols) add_neighbor(i + 1)
    if (i >= Rows) add_neighbor(i - Cols)
    if (i < Rows * Cols) add_neighbor(i + Cols)
}

function has_all_walls(i) {
    return Maze[cell(i) + 1] && Maze[cell(i) - 1] && Maze[cell(i) - Width] && Maze[cell(i) + Width]
}
function add_neighbor(i) {if (has_all_walls(i)) Neighbors[length(Neighbors)] = i}
function clear_enter() {Maze[Width] = 0}
function clear_exit() {Maze[Width * Hight - Width - 1] = 0}
function knock_down_wall(source, target) {Maze[(cell(source) + cell(target)) / 2] = 0}
function cell(i) {return Width + 1 + int(i / Cols) * Width * 2 + i % Cols * 2}
