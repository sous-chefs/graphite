#!/usr/bin/env bats

@test "carbon-relay should be running" {
  ps aux | grep carbon-relay\.p[y]
}

@test "carbon-relay should be listening on port 2003" {
  pid="$(ps aux | grep carbon-relay\.p[y] | awk '{print $2}')"
  lsof -Pna -itcp:2003 -sTCP:LISTEN -p$pid 2> /dev/null
}

