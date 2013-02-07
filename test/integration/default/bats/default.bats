#!/usr/bin/env bats

@test "carbon-cache should be running" {
  [ "$(ps aux | grep carbon-cache.p[y])" ]
}

@test "carbon should be listening" {
  [ "$(netstat -plant | grep python | grep 2003)" ]
}

@test "localhost should serve graphite browser" {
  [ "$(wget -qO- localhost  | grep 'Graphite Browser')" ]
}
