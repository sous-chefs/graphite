#!/usr/bin/env bats

@test "carbon-cache should be running" {
  ps aux | grep carbon-cache\.p[y]
}

@test "default carbon-cache should be listening on port 2003" {
  pid="$(ps aux | grep -e 'carbon-cache\.py.*--instance=a' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:2003 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "instance test1-a should be listening on port 2013" {
  pid="$(ps aux | grep -e 'carbon-cache\.py.*--instance=test1-a' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:2013 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "instance test1-a should be listening on port 2014" {
  pid="$(ps aux | grep -e 'carbon-cache\.py.*--instance=test1-a' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:2014 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "instance test1-a should be listening on port 7012" {
  pid="$(ps aux | grep -e 'carbon-cache\.py.*--instance=test1-a' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:7012 -sTCP:LISTEN -p$pid 2> /dev/null
}


@test "instance test1-b should be listening on port 2023" {
  pid="$(ps aux | grep -e 'carbon-cache\.py.*--instance=test1-b' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:2023 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "instance test1-b should be listening on port 2024" {
  pid="$(ps aux | grep -e 'carbon-cache\.py.*--instance=test1-b' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:2024 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "instance test1-b should be listening on port 7022" {
  pid="$(ps aux | grep -e 'carbon-cache\.py.*--instance=test1-b' | awk '{print $2}' | head -1)"
  sudo lsof -Pna -itcp:7022 -sTCP:LISTEN -p$pid 2> /dev/null
}