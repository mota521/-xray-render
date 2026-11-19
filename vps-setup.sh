#!/bin/bash
# 1Free.eu VPS - xray VLESS+WS 一键部署
# 用法: 在 VPS 里以 root 执行: bash vps-setup.sh
set -e
UUID="301eabe5-d20e-4d24-90b2-5defeab30a4a"
WS_PATH="/proxy"
PORT=80

echo "=== 安装 xray ==="
bash <(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh) install

echo "=== 写配置 ==="
mkdir -p /usr/local/etc/xray
cat > /usr/local/etc/xray/config.json <<EOF
{
  "log": {"loglevel": "warning"},
  "inbounds": [
    {
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [{"id": "$UUID", "flow": ""}],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {"path": "$WS_PATH"}
      }
    }
  ],
  "outbounds": [{"protocol": "freedom", "tag": "direct"}]
}
EOF

systemctl enable xray
systemctl restart xray
sleep 2
echo "=== 部署完成 ==="
echo "IP: $(curl -s ifconfig.me)"
echo "端口: $PORT"
echo "UUID: $UUID"
echo "路径: $WS_PATH"
echo "协议: VLESS + WS"
systemctl status xray --no-pager | head -6
