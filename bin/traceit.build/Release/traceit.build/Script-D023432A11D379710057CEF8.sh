#!/bin/sh
set -ex

[ "$ACTION" = build ] || exit 0
[ "$BUILD_VARIANTS" = "normal" ] || exit 0
dir="$TEMP_FILES_DIR/$CONFIGURATION/"
dmg="$PRODUCT_NAME.dmg"

rm -rf "$dir"
mkdir "$dir"
cp -R "$BUILD_DIR/$CONFIGURATION/$PRODUCT_NAME.app" "$dir"
rm -f "$dmg"
hdiutil create -srcfolder "$dir" -volname "$PRODUCT_NAME" "$dmg"
hdiutil internet-enable -yes "$dmg"
rm -rf "$dir"
