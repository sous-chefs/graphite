#!/usr/bin/env bats

@test "carbon-cache should be running" {
  ps aux | grep carbon-cache\.p[y]
}

@test "carbon should be listening" {
  netstat -plnt | grep python | grep 2003
}

@test "uwsgi should be listening on port 8080" {
  lsof -Pna -itcp:8080 -sTCP:LISTEN | grep -Fq uwsgi
}

@test "localhost:8080 should serve graphite browser" {
  wget -qO- localhost:8080 | grep 'Graphite Browser'
}
