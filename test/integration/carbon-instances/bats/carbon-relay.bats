#!/usr/bin/env bats

@test "carbon-relay should be running" {
  ps aux | grep carbon-relay\.p[y]
}

@test "default carbon-relay should be listening on port 3003" {
  pid="$(ps aux | grep -e 'carbon-relay\.py.*--instance=a' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:3003 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "instance test1-a should be listening on port 3013" {
  pid="$(ps aux | grep -e 'carbon-relay\.py.*--instance=test1-a' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:3013 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "instance test1-b should be listening on port 3023" {
  pid="$(ps aux | grep -e 'carbon-relay\.py.*--instance=test1-b' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:3023 -sTCP:LISTEN -p$pid 2> /dev/null
}