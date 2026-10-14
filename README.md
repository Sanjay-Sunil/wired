# wired

Automatic Wi-Fi connection and captive-portal login for the **IIIT Kottayam** campus network on Linux.

## Features

- Logs in to the FortiGate captive portal automatically when you join any `IIITKottayam*` network
- Logs in again when the 6-hour session expires
- Picks the strongest access point when you open the lid or boot
- Stops after 3 failed logins in a row and shows a notification, so it won't keep hitting the portal

## Requirements

- Linux with NetworkManager and systemd
- `curl`
- A saved NetworkManager profile for the college Wi-Fi (join it once from the network menu)

## Installation

```bash
git clone https://github.com/Sanjay-Sunil/wired.git
cd wired
sudo ./install.sh
```

The installer asks for your portal username and password and stores them in `/etc/iiitk-login.conf`, which only root can read.

## Uninstall

```bash
sudo ./install.sh --uninstall
```

## Logs

```bash
journalctl -t iiitk-login -t iiitk-wifi -f
```

## Disclaimer

Unofficial project, not affiliated with IIIT Kottayam. Use your own credentials and follow the college's network policy.
