#!/bin/sh
set -ex

[ "$ACTION" = build ] || exit 0
[ "$BUILD_VARIANTS" = "normal" ] || exit 0
dir="$BUILD_DIR/$CONFIGURATION/"
dmg="$PROJECT_NAME.dmg"

rm -rf "$dir"
mkdir "$dir"
cp -R "$BUILD_DIR/$CONFIGURATION/$PROJECT_NAME.app" "$dir"
rm -f "$dmg"
hdiutil create -srcfolder "$dir" -volname "$EFFECTIVE_PLATFORM_NAME" "$dmg"
hdiutil internet-enable -yes "$dmg"
rm -rf "$dir"
