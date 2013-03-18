#!/usr/bin/env bats

@test "carbon-cache should be running" {
  [ "$(pgrep carbon-cache.py)" ]
}

@test "carbon should be listening on port 2013" {
  [ "$(lsof -Pna -itcp:2013 -sTCP:LISTEN -ccarbon-cache.py)" ]
}

@test "carbon-relay should be running" {
  [ "$(pgrep carbon-relay.py)" ]
}

@test "carbon should be listening on port 2003" {
  [ "$(lsof -Pna -itcp:2003 -sTCP:LISTEN -ccarbon-relay.py)" ]
}

@test "localhost should serve graphite browser" {
  [ "$(wget -qO- localhost  | grep 'Graphite Browser')" ]
}
