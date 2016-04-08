#!/usr/bin/env bash

# (c) Adam Serafini 2016

# My ad-hoc library for testing bash CLI projects.

# Export the test directory:
export DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

run() {
  # Iterate through all files that match the test pattern.
  for filename in $DIR/t[0-9]*-*.sh
  do
    $filename
  done

  exit 1
}

# Only 'run' the tests if this script is called directly:
RUNNING="$(basename $0)"

if [[ "$RUNNING" == "bash-test.sh" ]]
then
  run "$@"
fi
