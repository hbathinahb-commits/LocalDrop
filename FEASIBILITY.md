# Feasibility and legal boundary

_Assessment date: 27 October 2026. This is practical project guidance, not legal advice._

## What can be built independently

Publicly observable product behavior can inform a new product's requirements: local file conversion, drag-and-drop input, context-sensitive choices, radial selection, non-destructive output, and common file actions. Those ideas can be implemented from scratch with original code, visual design, naming, documentation, and tests.

The MVP is technically straightforward with public macOS frameworks. ImageIO handles common image formats. AVFoundation can cover many Apple-supported audio/video operations. PDFKit covers basic PDF work. Archive Foundation and system tools can cover some archives. Broader codec and office-document support will require optional third-party tools.

## Do not copy

- Proprietary source code, binaries, reverse-engineered internals, or private APIs
- The Tangerine name, icon, logo, trade dress, screenshots, demo media, marketing copy, or press assets
- Pixel-for-pixel layouts, animation timings, sound design, or a confusingly similar App Store presentation
- A conversion matrix copied wholesale from the product site

Contributors should base work on this repository's own specifications and public platform documentation, not disassembly or decompilation. Anyone with access to non-public competitor materials should not contribute knowledge derived from them.

## Key technical constraints

1. A normal in-app drop target is low risk and is implemented now.
2. A system-wide overlay that reacts while Finder drags are in progress needs prototyping against documented AppKit drag APIs. Accessibility or Input Monitoring permission may be necessary. The project should not depend on undocumented event taps or Finder injection.
3. Sandboxed distribution limits arbitrary filesystem and subprocess access. Security-scoped URLs, user-selected folders, and carefully scoped entitlements are required.
4. FFmpeg is excellent for media, but builds can be LGPL or GPL depending on configuration. Ship an LGPL-compatible build or keep it an optional user-installed dependency; document every codec and flag.
5. LibreOffice/Pandoc can expand document conversion but increase app size and introduce license, sandbox, and reliability work. Treat them as optional adapters.
6. App Store distribution and direct notarized distribution have different constraints. The open-source repository can support both, but signing certificates and Apple accounts cannot be shared.

## Licensing recommendation

Apache-2.0 is used for the new code because it is permissive, permits commercial and non-commercial reuse, requires preservation of notices, and includes an express patent grant. It does not grant rights to third-party trademarks, assets, codecs, or patents. Dependencies retain their own licenses.

Before a public release, conduct a trademark search for the final name, generate fully original artwork, inventory dependency licenses, and obtain legal review if the project will be monetized or distributed through the App Store.
