#!/usr/bin/env bats

@test "carbon-cache should be running" {
  [ "$(pgrep -f carbon-cache\.py)" ]
}

@test "carbon-cache should be listening on port 2003" {
  [ "$(lsof -Pna -itcp:2003 -sTCP:LISTEN -p$(pgrep -f carbon-cache\.py) 2> /dev/null)" ]
}

