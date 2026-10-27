# LocalDrop

LocalDrop is a free, open-source macOS utility for private, on-device file conversion. Drop an image into the window, move toward an output format on the radial picker, and release. The converted copy is saved beside the original.

This is an independent clean-room project. It is not affiliated with, endorsed by, or derived from Tangerine or Leap Studio. It uses no Tangerine source code, assets, screenshots, copy, or branding.

## Current MVP

- Native macOS 13+ app written in Swift and AppKit
- Original radial drag-and-drop interface
- Local conversion among PNG, JPEG, TIFF, and HEIC
- JPG, PNG, HEIC, TIFF, BMP, and GIF inputs through ImageIO
- Collision-safe output naming; originals are never overwritten
- No network code, telemetry, accounts, or uploads

## Run locally

Requirements: macOS 13+, Xcode 15+ or the matching Swift toolchain.

```sh
swift run LocalDrop
```

Run tests with `swift test`. For a distributable `.app`, open the package in Xcode, select the LocalDrop executable, and create an app/archive target with your own bundle identifier and signing team.

## Project status

This repository is an early functional scaffold, not a feature-complete replacement. See [FEASIBILITY.md](FEASIBILITY.md) and [ROADMAP.md](ROADMAP.md) before contributing.

## License

Apache License 2.0. See [LICENSE](LICENSE). Third-party conversion engines added later must be reviewed for license compatibility and attribution.
