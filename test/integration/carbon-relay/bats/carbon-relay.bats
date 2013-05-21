#!/usr/bin/env bats

@test "carbon-relay should be running" {
  ps aux | grep carbon-relay\.p[y]
}

@test "carbon-relay should be listening on port 2013" {
  pid="$(ps aux | grep carbon-relay\.p[y] | awk '{print $2}' | head -1)"
  lsof -Pna -itcp:2013 -sTCP:LISTEN -p$pid 2> /dev/null
}

