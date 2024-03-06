#!/usr/bin/env bats
load '/opt/bats-test-helpers/bats-support/load.bash'
load '/opt/bats-test-helpers/bats-assert/load.bash'
load '/opt/bats-test-helpers/lox-bats-mock/stub.bash'

# ------

@test "get_major returns major version" {
  source /code/funcs.sh
  run get_major "5.6.7-alpha"
  [ "$status" -eq 0 ]
  [ "$output" == "5" ]
}

# ------

@test "get_minor returns minor version" {
  source /code/funcs.sh
  run get_minor "5.6.7-alpha"
  [ "$status" -eq 0 ]
  [ "$output" == "6" ]
}

# ------

@test "get_patch returns patch version" {
  source /code/funcs.sh
  run get_patch "5.6.7-alpha"
  [ "$status" -eq 0 ]
  [ "$output" == "7" ]
}

# ------

@test "get_maturity returns maturity version" {
  source /code/funcs.sh
  run get_maturity "8.9.7-alpha"
  [ "$status" -eq 0 ]
  [ "$output" == "alpha" ]
}

@test "get_maturity returns maturity version with v prefix" {
  source /code/funcs.sh
  run get_maturity "v8.9.7-alpha"
  [ "$status" -eq 0 ]
  [ "$output" == "alpha" ]
}

# ------

@test "get_maturity returns empty " {
  source /code/funcs.sh
  run get_maturity "8.9.7"
  [ "$status" -eq 0 ]
  [ "$output" == "" ]
}

# ------

@test "regression with missing maturity" {
  source /code/funcs.sh
  semver="8.9.7"

  run get_major $semver
  [ "$status" -eq 0 ]
  [ "$output" == "8" ]
  run get_minor $semver
  [ "$status" -eq 0 ]
  [ "$output" == "9" ]
  run get_patch $semver
  [ "$status" -eq 0 ]
  [ "$output" == "7" ]
  run get_maturity $semver
  [ "$status" -eq 0 ]
  [ "$output" == "" ]
}

# ------

@test "increment returns correctly incremented by 1 " {
  source /code/funcs.sh
  minor_version="9"

  run increment $minor_version
  [ "$status" -eq 0 ]
  [ "$output" == "10" ]
}

# ------

@test "is_patch_selected returns correctly when Patch checkbox checked" {
  source /code/funcs.sh
  run is_patch_selected "[x] Patch"
  [ "$status" -eq 0 ]
  [ "$output" == "true" ]

}

@test "is_minor_selected returns correctly when Minor checkbox checked" {
  source /code/funcs.sh
  run is_minor_selected "[x] Minor version"
  [ "$status" -eq 0 ]
  [ "$output" == "true" ]

}

@test "is_major_selected returns correctly when Major checkbox checked" {
  source /code/funcs.sh
  run is_major_selected "[x] Major version"
  [ "$status" -eq 0 ]
  [ "$output" == "true" ]

}

# ------

@test "is_patch_selected returns false when Patch checkbox not found" {
  source /code/funcs.sh
  run is_patch_selected "[x] apple"
  [ "$status" -eq 0 ]
  [ "$output" == "false" ]

}

@test "is_minor_selected returns false when Minor checkbox not found" {
  source /code/funcs.sh
  run is_minor_selected "[x] banana"
  [ "$status" -eq 0 ]
  [ "$output" == "false" ]

}

@test "is_major_selected returns false when Major checkbox not found" {
  source /code/funcs.sh
  run is_major_selected "[x] cucumber"
  [ "$status" -eq 0 ]
  [ "$output" == "false" ]

}

# ------

@test "is_selected returns correctly when checkbox checked correctly" {
  source /code/funcs.sh
  run is_selected "[x] Patch" "Patch"
  [ "$status" -eq 0 ]
  [ "$output" == "true" ]

}

@test "is_selected returns false when checkbox not checked properly: space to right of cross" {
  source /code/funcs.sh
  run is_selected "\[x \] Patch" "Patch"
  [ "$status" -eq 0 ]
  [ "$output" == "false" ]

}

@test "is_selected returns false when checkbox not checked properly: space to left of cross" {
  source /code/funcs.sh
  run is_selected "\[ x\] Patch" "Patch"
  [ "$status" -eq 0 ]
  [ "$output" == "false" ]

}

@test "is_selected returns false when checkbox not checked properly: spaces either side of cross" {
  source /code/funcs.sh
  run is_selected "\[ x \] Patch" "Patch"
  [ "$status" -eq 0 ]
  [ "$output" == "false" ]

}