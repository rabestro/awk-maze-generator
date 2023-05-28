# The AWK scripts to generate maze

The repository contains AWK scripts to generate a random maze and find a path in the maze.

## Generate a random maze

To generate a maze, you can use one of two scripts: `maze-gen-one.awk` or `maze-gen-two.awk`. These two scripts work the same but use completely different algorithms to generate the maze. Both scripts have two mandatory parameters - the number of rows (Rows) and columns (Cols) in the maze. You can also specify an optional `Seed` parameter. 

Every time you run the script, you will receive a random maze.

```shell
gawk -f maze-gen-two.awk -v Rows=8 -v Cols=36 
```

However, if you specify optional `Seed` variables, you will get the same maze every time you run the script with a specific `Seed` value.

```shell
gawk -f maze-gen-two.awk -v Rows=8 -v Cols=36 -v Seed=42 
```

### Sample output 

![Maze Sample](maze-sample.png)

### Make scripts executable 

You can set the execution flag for scripts.

```shell
chmod +x maze-gen-two.awk
```

This will allow you to run scripts directly without specifying an interpreter.

```shell
./maze-gen-two.awk -v Rows=8 -v Cols=36
```

### Save the maze

```shell
./maze-gen-two.awk -v Rows=8 -v Cols=36 Seed=42 > sample.maze
```

## Find the path

```shell
gawk -f maze-runner.awk sample.maze
```

### Sample output of path

![Maze Path](maze-path.png)
