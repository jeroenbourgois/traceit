#!/bin/sh
set -ex

[ "$ACTION" = build ] || exit 0
[ "$BUILD_VARIANTS" = "normal" ] || exit 0
dir="$BUILD_DIR$CONFIGURATION/"
dmg="$BUILD_DIR$CONFIGURATION/$EFFECTIVE_PLATFORM_NAME.dmg"

rm -rf "$dir"
mkdir "$dir"
cp -R "$BUILT_PRODUCTS_DIR/$PROJECT_NAME.app" "$dir"
rm -f "$dmg"
hdiutil create -srcfolder "$dir" -volname "$PROJECT_NAME" "$dmg"
hdiutil internet-enable -yes "$dmg"
rm -rf "$dir"
