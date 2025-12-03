# TwitterLegacyPatcher (macOS Catalyst edition)

A plugin to restore functionality to the Mac Catalyst Twitter application, powered by [Ammonia](https://github.com/CoreBedtime/ammonia).

## Patches include
- Bypass certificate pinning in the app
- Spoofing app version to allow login
- Ad blocking
- Account enhancements
- Media enhancements
- Legacy verified badge restoration

## Known Issues

- The Search page and Quote tweets don't work
- You may not be able to view tweet replies (working on a fix)
- Profile Banners don't show up at all
- Some update prompts remain but they can be easily dismissed

## Requirements

- macOS with SIP disabled
- [Ammonia](https://github.com/CoreBedtime/ammonia) installed
- Xcode Command Line Tools (for building from source)

## Installation

### Prerequisites: Install Ammonia

1. **Disable SIP** (System Integrity Protection)
   - Boot into Recovery Mode (hold Power button on Apple Silicon, or Cmd+R on Intel)
   - Open Terminal from Utilities menu
   - Run: `csrutil disable`
   - Reboot

2. **Install Ammonia**
   - Download and install the PKG from [Ammonia Releases](https://github.com/CoreBedtime/ammonia/releases/download/1.5/ammonia.pkg)

3. **Enable arm64e ABI** (required for Apple Silicon)
   ```bash
   sudo nvram boot-args=-arm64e_preview_abi
   ```

4. **Reboot**

### Install TwitterLegacyPatcher

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/twitterlegacypatcher-osx.git
cd twitterlegacypatcher-osx

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

## Building

The Makefile builds a universal binary supporting:
- `arm64` (Apple Silicon)
- `arm64e` (Apple Silicon with pointer authentication)
- `x86_64` (Intel, via Rosetta)

```bash
make        # Build the dylib (output in build/)
make clean  # Remove build artifacts
```

## How It Works

TwitterLegacyPatcher uses [Ammonia](https://github.com/CoreBedtime/ammonia) to inject into processes at runtime. The **whitelist** file tells Ammonia to only inject into the Twitter process. The tweak uses a `__attribute__((constructor))` entry point and waits for Twitter's classes to load before applying patches via method swizzling.

## License

See [LICENSE](LICENSE) for details.
