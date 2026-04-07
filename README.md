# TrackPoint Configuration Tool for Linux

A colorful TUI utility for configuring ThinkPad TrackPoint (pointing stick) settings.

![License](https://img.shields.io/badge/license-GPL%20v3-blue.svg)
![Platform](https://img.shields.io/badge/platform-Linux-lightgrey.svg)

## Features

- **Interactive TUI menu** with colored interface
- **Auto-detect driver type** (evdev vs libinput)
- **User-friendly 1-10 scale** abstraction for xinput values
- **Real-time adjustment** of:
  - Scroll speed / wheel emulation inertia
  - Pointer speed / acceleration
  - Acceleration profile (evdev only)
  - Natural scrolling toggle
- **Settings persistence** across restarts (systemd + desktop autostart)
- **Named profiles** for saving/loading different configurations
- **Startup logging** for troubleshooting

## Requirements

- Linux with X11
- `xinput` utility
- `bc` (for float math)

```bash
# Ubuntu/Debian
sudo apt install xinput bc

# Arch Linux
sudo pacman -S xorg-xinput bc

# Fedora
sudo dnf install xinput bc
```

## Installation

### Quick Install

```bash
git clone https://github.com/YOUR_USERNAME/trackpoint-config.git
cd trackpoint-config
./install.sh
```

### Manual Install

```bash
# Copy script
cp trackpoint ~/trackpoint
chmod +x ~/trackpoint

# Run
~/trackpoint
```

## Usage

Run the script:
```bash
~/trackpoint
```

### Menu Options

| Key | Action |
|-----|--------|
| 1 | Adjust scroll speed |
| 2 | Adjust pointer speed |
| 3 | Adjust acceleration (evdev only) |
| 4 | Toggle natural scrolling |
| 5 | Save current config (autoload on boot) |
| 6 | Save named profile |
| 7 | Load named profile |
| 8 | Delete named profile |
| r | Reset to defaults |
| l | View startup log |
| q | Quit |

**Important:** Use option 5 (Save Config) to persist settings across restarts. This regenerates the autostart script.

## Driver Detection

The script auto-detects at runtime which driver is active:

- **evdev**: Uses `Evdev Wheel Emulation Inertia`, `Device Accel Constant Deceleration`, `Device Accel Velocity Scaling`
- **libinput**: Uses `Scrolling Pixel Distance`, `Accel Speed`, `Natural Scrolling Enabled`

Check which driver you're using:
```bash
xinput list-props "TPPS/2 IBM TrackPoint" | grep -q "libinput" && echo "libinput" || echo "evdev"
```

## Value Conversion

User values (1-10) are converted to xinput values:

| Setting | evdev Formula | libinput Formula |
|---------|---------------|------------------|
| Scroll | `51 - user * 5` | `110 - user * 10` |
| Pointer | `2.05 - user * 0.15` | `-1.2 + user * 0.2` |

Higher user value = faster movement (consistent across drivers).

## Autoload on Boot

Settings persist across restarts via two mechanisms:
1. **Systemd user service** (primary): `systemctl --user status trackpoint.service`
2. **Desktop autostart** (backup): `~/.config/autostart/trackpoint.desktop`

The autostart script waits up to 15 seconds for device availability.

Check autoload status:
```bash
cat ~/.config/trackpoint/trackpoint.log
systemctl --user status trackpoint.service
```

## Configuration Files

| Path | Purpose |
|------|---------|
| `~/trackpoint` | Main script |
| `~/.config/trackpoint.conf` | Current saved configuration |
| `~/.config/trackpoint-autostart.sh` | Autostart script |
| `~/.config/autostart/trackpoint.desktop` | Desktop autostart entry |
| `~/.config/systemd/user/trackpoint.service` | Systemd user service |
| `~/.config/trackpoint/trackpoint.log` | Autostart execution log |
| `~/.config/trackpoint-profiles/*.conf` | Saved named profiles |

## Manual xinput Commands

View all properties:
```bash
xinput list-props "TPPS/2 IBM TrackPoint"
```

Set scroll inertia (evdev):
```bash
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Inertia" 26
```

Set pointer speed (evdev):
```bash
xinput set-prop "TPPS/2 IBM TrackPoint" "Device Accel Constant Deceleration" 1.45
```

Toggle natural scroll (evdev):
```bash
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 5 4  # on
xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5  # off
```

## Troubleshooting

If TrackPoint is not detected:
```bash
xinput list | grep -i trackpoint
sudo modprobe serioraw
```

## License

GNU General Public License v3.0 - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

This tool is designed for ThinkPad TrackPoint devices and uses the `xinput` utility to configure settings dynamically.