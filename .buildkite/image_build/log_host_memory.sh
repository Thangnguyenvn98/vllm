#!/bin/bash
# Run "$@" while logging host memory usage every 5s to the job log.
(
  while true; do
    awk '
      /^MemTotal:/ { total = $2 }
      /^MemAvailable:/ {
        printf "Host memory used: %.2f GiB\n", (total - $2) / 1048576
      }
    ' /proc/meminfo
    sleep 5
  done
) >&2 &
memory_sampler_pid=$!

"$@"
status=$?

kill "$memory_sampler_pid" 2>/dev/null || true
exit "$status"
