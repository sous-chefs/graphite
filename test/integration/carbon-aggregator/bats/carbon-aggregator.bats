#!/usr/bin/env bats

@test "carbon-aggregator should be running" {
  ps aux | grep carbon-aggregator\.p[y]
}

@test "carbon-aggregator should be listening on port 2023" {
  pid="$(ps aux | grep carbon-aggregator\.p[y] | awk '{print $2}' | head -1)"
  lsof -Pna -itcp:2023 -sTCP:LISTEN -p$pid 2> /dev/null
}

@test "aggregation-rules.conf should be generated" {
  test -f "/opt/graphite/conf/aggregation-rules.conf"
}

@test "aggregation-rules.conf should have the correct contents" {
  grep -qF "<env>.applications.<app>.all.latency" "/opt/graphite/conf/aggregation-rules.conf"
}

@test "rewrite-rules.conf should be generated" {
    test -f "/opt/graphite/conf/rewrite-rules.conf"
}

@test "rewrite-rules.conf should have the correct content" {
      grep -qF ".idle" "/opt/graphite/conf/rewrite-rules.conf"
}
