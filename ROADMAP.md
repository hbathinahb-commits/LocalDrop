# Roadmap

## 0.1 — native image MVP

- [x] Window-based drag target
- [x] Original radial output picker
- [x] ImageIO conversion and non-destructive naming
- [x] Unit tests and CI
- [ ] Accessibility labels and keyboard-only operation
- [ ] App icon, created from an original brief
- [ ] Signed and notarized direct-download build

## 0.2 — dependable conversion core

- [ ] Progress, cancellation, multi-file batches, and structured errors
- [ ] Preserve or intentionally strip metadata with a visible choice
- [ ] Capability registry driven by detected input type
- [ ] Security-scoped bookmarks and sandbox test suite
- [ ] Conversion fixtures with licensing/provenance records

## 0.3 — media and documents

- [ ] AVFoundation audio/video conversion, trim, and compression
- [ ] PDFKit merge, split, rotate, and image export
- [ ] ZIP/TAR/GZIP actions through documented APIs
- [ ] Optional, license-reviewed FFmpeg adapter
- [ ] Optional document-conversion adapter

## Later — system workflow

- [ ] Prototype a documented, permission-respecting system-wide drag overlay
- [ ] Copy, move, reveal, copy-path, and share actions
- [ ] Customizable shortcuts
- [ ] Menu-bar mode and launch-at-login

The system-wide overlay ships only if it can be reliable without private APIs or invasive permissions.
