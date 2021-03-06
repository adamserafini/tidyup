#!/usr/bin/env bats

teardown() {
  rm -rf tmp
}

setup() {
  teardown
  mkdir tmp tmp/.hiddendir tmp/dir
  touch tmp/.hiddenfile tmp/file
}

@test "invoking emptydir with no arguments prints usage" {
  run bin/emptydir
  [ "$status" -eq 1 ]
  [ "$output" = "usage: emptydir [-a] directory ..." ]
}

@test "invoking emptydir with an non-existent directory prints error" {
  run bin/emptydir notexist
  [ "$status" -eq 1 ]
  [ "$output" = "emptydir: notexist: No such file or directory" ]
}

@test "invoking emptydir with file prints error" {
  run bin/emptydir LICENSE
  [ "$status" -eq 1 ]
  [ "$output" = "emptydir: LICENSE: Not a directory" ]
}

@test "invoking with an illegal arg prints error" {
  run bin/emptydir -x tmp
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "emptydir: illegal option: -- x" ]
  [ "${lines[1]}" = "usage: emptydir [-a] directory ..." ]

  # Both files should still exist.
  [ -f tmp/.hiddenfile ]
  [ -f tmp/file ]
}

@test "invoking with an illegal and legal arg prints error" {
  run bin/emptydir -ax tmp
  [ "$status" -eq 1 ]
  [ "${lines[0]}" = "emptydir: illegal option: -- x" ]
  [ "${lines[1]}" = "usage: emptydir [-a] directory ..." ]

  # Both files should still exist.
  [ -f tmp/.hiddenfile ]
  [ -f tmp/file ]
}

@test "invoking without -a flag removes normal files and dirs" {
  run bin/emptydir -f tmp
  [ "$status" -eq 0 ]
  [ -f tmp/.hiddenfile ]
  [ -d tmp/.hiddendir ]
  [ ! -f tmp/file ]
  [ ! -d tmp/dir ]
}

@test "invoking with -a flag removes all files and dirs" {
  run bin/emptydir -af tmp
  [ "$status" -eq 0 ]
  [ ! -f tmp/.hiddenfile ]
  [ ! -d tmp/.hiddendir ]
  [ ! -f tmp/file ]
  [ ! -d tmp/dir ]
}

@test "invoking with invalid and valid dir returns error" {
  run bin/emptydir -f tmp notexist
  [ "$status" -eq 1 ]
  [ "$output" = "emptydir: notexist: No such file or directory" ]

  # tmp should still have been emptied:
  [ ! -f tmp/file ]
  [ ! -d tmp/dir ]
}

@test "invoking without -f flag and with confirmation empties the dir" {
  run bash -c "yes | bin/emptydir tmp"
  [ ! -f tmp/file ]
  [ ! -d tmp/dir ]
}

@test "invoking without -f flag and without confirmation does not empty" {
  run bash -c "yes no | bin/emptydir tmp"
  [ -f tmp/file ]
  [ -d tmp/dir ]
}
