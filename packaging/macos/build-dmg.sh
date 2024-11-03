#!/bin/sh
# File to create the DMG file using create-dmg tool.
#
#
# Cleanup old dmg files
test -f HelloWorld.dmg && rm HelloWorld.dmg
test -d "dist/dmg" && rm -rf "dist/dmg"

# Build the project
test -d build && rm -r build
test -d dist && rm -r dist
pyinstaller ./packaging/macos/hello-world-macos.spec

# Codesign the executable created by pyinstaller
echo "Codesigning the executable created by PyInstaller"
echo $MAC_P12_BASE64_CERTIFICATE | base64 --decode > certificate.p12
security create-keychain -p $KEYCHAIN_PASSWORD build.keychain
security default-keychain -s build.keychain
security unlock-keychain -p $KEYCHAIN_PASSWORD build.keychain
security import certificate.p12 -k build.keychain -P $MAC_P12_PASSWORD -T /usr/bin/codesign
security set-key-partition-list -S apple-tool:,apple:,codedign: -s -k $KEYCHAIN_PASSWORD build.keychain
/usr/bin/codesign --force --deep --options=runtime --entitlements ./packaging/macos/entitlements.plist -s $MAC_TEAM_ID --timestamp dist/HelloWorld.app

# Create dmg folder and copy our signed executable
mkdir -p dist/dmg
cp "dist/HelloWorld.app" "dist/dmg"

# Create the dmg file
echo "Creating the DMG file"
create-dmg \
  --volname "HelloWorld" \
  --volicon "./src/media/icons/icon.icns" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "HelloWorld.app" 200 190 \
  --hide-extension "HelloWorld.app" \
  --app-drop-link 600 185 \
  "HelloWorld.dmg" \
  "dist/dmg/"

# Notarize the DMG File
echo "Notarizing the DMG file"
xcrun notarytool submit --verbose --team-id $MAC_TEAM_ID --apple-id $MAC_APPLE_ID --password $MAC_APP_SPECIFIC_PASSWORD --wait HelloWorld.dmg

# Staple the file
echo "Stapling the file"
xcrun stapler staple HelloWorld.dmg
