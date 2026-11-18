#!/bin/sh
set -e
PORT="${PORT:-10000}"
UUID="${UUID:?UUID env var is required}"
WS_PATH="${WS_PATH:-/proxy}"
cat > /etc/xray-config.json << JSONEOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [{ "id": "${UUID}" }],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "${WS_PATH}" }
      }
    }
  ],
  "outbounds": [
    { "protocol": "freedom", "tag": "direct" },
    { "protocol": "blackhole", "tag": "block" }
  ]
}
JSONEOF
exec /usr/local/bin/xray run -c /etc/xray-config.json
