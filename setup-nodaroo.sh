#!/bin/bash
# Nodaroo node01 (Pterodactyl Python egg) xray launcher.
# First run downloads xray; config is rewritten on every start from $SERVER_PORT.
cd /home/container || exit 1
if [ ! -f xray ]; then
  echo "downloading xray..."
  python3 -c "import urllib.request; urllib.request.urlretrieve('https://github.com/XTLS/Xray-core/releases/download/v26.11.9/Xray-linux-64.zip','xray.zip')"
  python3 -c "import zipfile; zipfile.ZipFile('xray.zip').extract('xray')"
  chmod +x xray
  rm -f xray.zip
  echo "xray ready"
fi
python3 - <<'PYEOF'
import json, os
port = int(os.environ.get("SERVER_PORT", "25613"))
cfg = {
    "log": {"loglevel": "warning"},
    "inbounds": [{
        "port": port,
        "protocol": "vless",
        "settings": {"clients": [{"id": "02f70e88-0252-4cef-ba69-e52ec323b895"}], "decryption": "none"},
        "streamSettings": {"network": "ws", "wsSettings": {"path": "/proxy"}}
    }],
    "outbounds": [{"protocol": "freedom"}]
}
with open("config.json", "w") as f:
    json.dump(cfg, f)
print("config written, port", port)
PYEOF
exec ./xray run -c config.json
