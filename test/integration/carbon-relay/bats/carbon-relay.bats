#!/usr/bin/env bats

@test "carbon-relay should be running" {
  ps aux | grep carbon-relay\.p[y]
}

@test "carbon-relay should be listening on port 2013" {
  pid="$(ps aux | grep carbon-relay\.p[y] | awk '{print $2}' | head -1)"
  lsof -Pna -itcp:2013 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "relay-rules.conf should be generated" {
  test -f "/opt/graphite/conf/relay-rules.conf"
}

@test "relay-rules.conf should have the correct contents" {
  grep -qF "^mydata\\.foo\\..+" "/opt/graphite/conf/relay-rules.conf"
}

