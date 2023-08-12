#!/usr/bin/env bats

function validate_maze {
  local -ir rows="$1"
  local -ir cols="$2"
  result="$(gawk --file maze-gen-two.awk -v Rows=$rows -v Cols=$cols | gawk -f test-maze.awk -v Rows=$rows -v Cols=$cols)"
  [ "$result" = "The maze is perfect." ]
}

@test "the smallest possible maze is perfect" {
  #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
  validate_maze 2 2
}

@test "the small square maze is perfect" {
  #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
  validate_maze 5 5
}

@test "the small rectangular maze is perfect" {
  #[[ $BATS_RUN_SKIPPED == "true" ]] || skip
  validate_maze 5 10
}
