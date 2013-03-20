#!/usr/bin/env bats

@test "carbon-aggregator should be running" {
  [ "$(pgrep -f carbon-aggregator\.py)" ]
}

@test "carbon-aggregator should be listening on port 2023" {
  [ "$(lsof -Pna -itcp:2023 -sTCP:LISTEN -p$(pgrep -f carbon-aggregator\.py) 2> /dev/null)" ]
}

