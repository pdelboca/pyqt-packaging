#!/bin/sh
# File to create the DMG file to install the aplication on MacOS using create-dmg tool.
#
# Cleanup old dmg files
test -f HelloWorld.dmg && rm HelloWorld.dmg
test -d "dist/dmg" && rm -rf "dist/dmg"

# Create dmg folder and copy our app bundle created by pyinstaller.
mkdir -p dist/dmg
cp -r "dist/HelloWorld.app" "dist/dmg"

# Create the dmg file
create-dmg \
  --volname "HelloWorld" \ # Name for the disk image (DMG) itself
  --volicon "icons/icon.icns" \
  --window-pos 200 120 \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "HelloWorld.app" 200 190 \
  --hide-extension "HelloWorld.app" \
  --app-drop-link 600 185 \
  "HelloWorld.dmg" \
  "dist/dmg/"
