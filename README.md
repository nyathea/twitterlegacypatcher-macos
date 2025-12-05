# TwitterLegacyPatcher (macOS Catalyst edition)

A tweak to restore functionality to the Mac Catalyst Twitter application, powered by [Ammonia](https://github.com/CoreBedtime/ammonia).

If you dont have the Twitter app installed you can reinstall it from your Purchase history on the app store.

You may also find it from [Archive.org](https://archive.org/details/twitter_for_mac)

## Patches include
- Bypass certificate pinning in the app
- Spoofing app version to allow login
- Ad blocking
- QoL enhancements
- Legacy verified badge restoration

## Known Issues

- The Search page, Quote tweets, and tweet replies don't work
- Profile Banners don't show up at all
- Some update prompts remain (but they can be easily dismissed)

## Requirements

- macOS with SIP disabled
- Ammonia installed
- Xcode Command Line Tools (if building from source)

## Installation

### Prerequisites: Install Ammonia

1. **Disable SIP** (System Integrity Protection)
   - Boot into Recovery Mode (hold Power button on Apple Silicon, or Cmd+R on Intel)
   - Open Terminal from Utilities menu
   - Run: `csrutil disable`
   - Reboot

2. **Install Ammonia**
   - Download and install the PKG from [Ammonia Releases](https://github.com/CoreBedtime/ammonia/releases/)

3. **Enable arm64e ABI** (required for Apple Silicon)
   ```bash
   sudo nvram boot-args=-arm64e_preview_abi
   ```

4. **Reboot**

### Building TwitterLegacyPatcher

```bash
# Clone the repository
git clone https://github.com/nyathea/TwitterLegacyPatcher-MacOS.git
cd TwitterLegacyPatcher-MacOS

# Build and install
make
sudo make install
```

### Verify Installation
After installation, the following files should exist:
- `/var/ammonia/core/tweaks/libTwitterLegacyPatcher.dylib`
- `/var/ammonia/core/tweaks/libTwitterLegacyPatcher.dylib.whitelist`
- `/var/ammonia/core/tweaks/libTwitterLegacyPatcher.dylib.blacklist`

## Uninstallation

```bash
sudo make uninstall
```

Or manually remove:
```bash
sudo rm /var/ammonia/core/tweaks/libTwitterLegacyPatcher.dylib
sudo rm /var/ammonia/core/tweaks/libTwitterLegacyPatcher.dylib.whitelist
sudo rm /var/ammonia/core/tweaks/libTwitterLegacyPatcher.dylib.blacklist
```
