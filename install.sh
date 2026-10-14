#!/bin/bash
# Installs IIIT Kottayam Wi-Fi auto-connect + captive-portal auto-login.
# Usage: sudo ./install.sh          (uninstall: sudo ./install.sh --uninstall)
set -e
[[ $EUID -eq 0 ]] || { echo "Run with sudo: sudo ./install.sh"; exit 1; }
cd "$(dirname "$0")"
UNITS="iiitk-login.timer iiitk-wifi-best.service"

if [[ "$1" == --uninstall ]]; then
  systemctl disable --now $UNITS 2>/dev/null || true
  rm -f /etc/NetworkManager/dispatcher.d/90-iiitk-login /usr/local/bin/iiitk-wifi-best \
        /etc/systemd/system/iiitk-login.{service,timer} /etc/systemd/system/iiitk-wifi-best.service
  systemctl daemon-reload
  read -rp "Also delete saved credentials (/etc/iiitk-login.conf)? [y/N] " a
  [[ "$a" == [yY]* ]] && rm -f /etc/iiitk-login.conf
  echo "Uninstalled."; exit 0
fi

command -v nmcli >/dev/null || { echo "NetworkManager (nmcli) is required."; exit 1; }
command -v curl  >/dev/null || { echo "curl is required."; exit 1; }

install -Dm755 90-iiitk-login         /etc/NetworkManager/dispatcher.d/90-iiitk-login
install -Dm755 iiitk-wifi-best        /usr/local/bin/iiitk-wifi-best
install -Dm644 iiitk-login.service    /etc/systemd/system/iiitk-login.service
install -Dm644 iiitk-login.timer      /etc/systemd/system/iiitk-login.timer
install -Dm644 iiitk-wifi-best.service /etc/systemd/system/iiitk-wifi-best.service

if [[ ! -s /etc/iiitk-login.conf ]]; then
  read -rp  "Portal username: " u
  read -rsp "Portal password: " p; echo
  umask 077
  printf "IIITK_USER=%q\nIIITK_PASS=%q\n" "$u" "$p" > /etc/iiitk-login.conf
  chmod 600 /etc/iiitk-login.conf
else
  echo "Keeping existing credentials in /etc/iiitk-login.conf"
fi

systemctl enable --now NetworkManager-dispatcher.service >/dev/null 2>&1 || true
systemctl daemon-reload
systemctl enable iiitk-wifi-best.service
systemctl enable --now iiitk-login.timer
echo "Installed. Logs: journalctl -t iiitk-login -t iiitk-wifi -f"
