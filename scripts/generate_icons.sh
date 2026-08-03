#!/usr/bin/env bash
# Generates PWA icon PNGs from the iOS app icon (1024×1024 source).
# Uses only macOS built-in tools: sips.
set -e

SRC="ios/Runner/Assets.xcassets/AppIcon.appiconset/AppIcon~ios-marketing.png"
OUT="web/icons"

sizes=(192 512)

for size in "${sizes[@]}"; do
  echo "Generating ${size}×${size}..."
  sips -z "$size" "$size" "$SRC" --out "$OUT/Icon-$size.png" > /dev/null
  cp "$OUT/Icon-$size.png" "$OUT/Icon-maskable-$size.png"
done

# Favicon
echo "Generating favicon..."
sips -z 64 64 "$SRC" --out web/favicon.png > /dev/null

# Apple touch icon
echo "Generating apple-touch-icon..."
sips -z 180 180 "$SRC" --out "$OUT/apple-touch-icon.png" > /dev/null

echo "Done!"
