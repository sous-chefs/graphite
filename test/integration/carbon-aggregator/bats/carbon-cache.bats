#!/usr/bin/env bats

@test "carbon-cache should be running" {
  ps aux | grep carbon-cache\.p[y]
}

@test "carbon-cache should be listening on port 2003" {
  pid="$(ps aux | grep carbon-cache\.p[y] | awk '{print $2}' | head -1)"
  lsof -Pna -itcp:2003 -sTCP:LISTEN -p$pid 2> /dev/null
}

