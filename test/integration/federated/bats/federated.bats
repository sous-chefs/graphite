#!/usr/bin/env bats

@test "carbon-cache should be running" {
  [ "$(pgrep -f carbon-cache\.py)" ]
}

@test "carbon-cache should be listening on port 2013" {
  [ "$(lsof -Pna -itcp:2013 -sTCP:LISTEN -p$(pgrep -f carbon-cache\.py) 2> /dev/null)" ]
}

@test "carbon-relay should be running" {
  [ "$(pgrep -f carbon-relay\.py)" ]
}

@test "carbon-relay should be listening on port 2003" {
  [ "$(lsof -Pna -itcp:2003 -sTCP:LISTEN -p$(pgrep -f carbon-relay\.py) 2> /dev/null)" ]
}

@test "localhost should serve graphite browser" {
  [ "$(wget -qO- localhost  | grep 'Graphite Browser')" ]
}
