#!/usr/bin/env bats
@test "localhost should serve graphite browser over ssl" {
  [ "$(wget -qO- https://localhost --no-check-certificate | grep 'Graphite Browser')" ]
}
