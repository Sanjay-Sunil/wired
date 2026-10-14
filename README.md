# IIIT Kottayam Wi-Fi auto-connect

Stop typing your password into the FortiGate login page. This sets up a Linux
laptop to:

- **Log in to the captive portal automatically** whenever you join an
  `IIITKottayam*` network, and log in again when the 6-hour session runs out.
- **Pick the strongest access point** every time you open the lid (wake from
  sleep) or boot. It scans every `IIITKottayam*` AP, prefers 5 GHz when the
  signal is close, and moves down the list if an AP doesn't respond.

## Requirements

- Linux with **NetworkManager** and **systemd** (Arch, Omarchy, Ubuntu, Fedora, Mint, …)
- `curl`
- You must have joined the college Wi-Fi once, so NetworkManager has a saved profile for it

## Install

```bash
git clone https://github.com/<you>/iiitk-wifi.git
cd iiitk-wifi
sudo ./install.sh
```

The installer asks for your portal username and password and saves them in
`/etc/iiitk-login.conf`, which only root can read. They never leave your laptop
except to go to the college portal.

## Uninstall

```bash
sudo ./install.sh --uninstall
```

## How it works

| File | What it does |
|---|---|
| `90-iiitk-login` | NetworkManager dispatcher script. On connect, it detects the FortiGate redirect and posts your login. |
| `iiitk-login.timer` | Runs the login check every 3 minutes, so an expired session is fixed on its own. |
| `iiitk-wifi-best` | Ranks the APs and connects to the best one. |
| `iiitk-wifi-best.service` | Runs the above after wake from sleep and at boot. |

**Failsafe:** the portal limits how many devices can log in at once. After 3
failed logins in a row, the script stops and shows a desktop notification
instead of hammering the portal. Log in once from a browser and it starts
working again.

## Logs

```bash
journalctl -t iiitk-login -t iiitk-wifi -f
```

## Tuning

At the top of `/usr/local/bin/iiitk-wifi-best`:
`FIVE_GHZ_BONUS` (how much to favour 5 GHz), `KEEP_MARGIN` (how much better
another AP must be before switching), and `MAX_TRIES`. Set `IIITK_IFACE` to
force a specific Wi-Fi interface.

## Disclaimer

This is an unofficial student project, not affiliated with IIIT Kottayam. Use
your own credentials and follow the college's network usage policy.
