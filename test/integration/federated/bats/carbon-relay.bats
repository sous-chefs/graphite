#!/usr/bin/env bats

@test "carbon-relay should be running" {
  [ "$(pgrep -f carbon-relay\.py)" ]
}

@test "carbon-relay should be listening on port 2003" {
  [ "$(lsof -Pna -itcp:2003 -sTCP:LISTEN -p$(pgrep -f carbon-relay\.py) 2> /dev/null)" ]
}

