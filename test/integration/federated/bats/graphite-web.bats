#!/usr/bin/env bats

@test "localhost should serve graphite browser" {
  wget -qO- localhost | grep 'Graphite Browser'
}

