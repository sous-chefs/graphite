#!/usr/bin/env bats

@test "carbon-cache-a should be running" {
  ps aux | grep carbon-cache-a.pid
}

@test "carbon-cache-b should be running" {
  ps aux | grep carbon-cache-b.pid
}

@test "carbon-cache-c should be running" {
  ps aux | grep carbon-cache-c.pid
}

@test "carbon-cache-a should be listening on port 2003" {
  pid="$(ps aux | grep carbon-cache-a.pid | awk '{print $2}' | head -1)"
  lsof -Pna -itcp:2003 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "carbon-cache-b should be listening on port 2005" {
  pid="$(ps aux | grep carbon-cache-b.pid | awk '{print $2}' | head -1)"
  lsof -Pna -itcp:2005 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "carbon-cache-c should be listening on port 2007" {
  pid="$(ps aux | grep carbon-cache-c.pid | awk '{print $2}' | head -1)"
  lsof -Pna -itcp:2007 -sTCP:LISTEN -p$pid 2> /dev/null
}

