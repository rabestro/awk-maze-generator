#!/usr/bin/env gawk -f
# These variables are initialized on the command line (using '-v'):
# - width
# - height

BEGIN {

    print "Hello, World"
    #    print cell(2,3)
    Cols = 5
    Rows = 3
    Width = 2 * Cols + 1
    Hight = 2 * Rows + 1
    print Rows, Cols, Hight, Width

    OFS = ""
    create_maze()
    generate_maze()
    print_maze()
}

function has_all_walls(row, col,   x,y) {
    x = 2 * row
    y = 2 * col
    return Maze[north(x, y)] && Maze[south(x, y)] && Maze[west(x, y)] && Maze[east(x, y)]
}

function find_valid_neighbors() {

}

function create_maze(   i) {
    for (i = Hight * Width; i-- > 0;) Maze[i] = 1
}

function generate_maze(   i) {
    for (i = Rows * Cols; i-- > 0;) Maze[idx(i)] = 0
}

function idx(i) {return Width + 1 + int(i / Cols) * Width * 2 + i % Cols * 2}

function print_maze(   row,col) {
    for (row = 0; row < Hight; ++row) {
        for (col = 0; col < Width; ++col) {
            $(1 + col) = Maze[row * Width + col] ? "██" : "  "
        }
        print
    }
}

function north(row, col) {return cell(row, col - 1)}
function south(row, col) {return cell(row, col + 1)}
function east(row, col) {return cell(row + 1, col)}
function west(row, col) {return cell(row - 1, col)}
function cell(x, y) {return x "/" y}
