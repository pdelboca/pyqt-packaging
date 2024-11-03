#!/bin/sh
# File to create the DMG file using create-dmg tool and notarize it.
#
# This is a bash script that I created after reading several sources and tutorials.
# It is intended to work on Github Actions and so it might not be the most optimized
# workflow for executing it locally (because of the secrets required for code sign
# and notarizing)
#
# This script expects 6 secrets:
#  - MAC_P12_BASE64_CERTIFICATE: A base64 encoded p12 certificate.
#  - MAC_P12_PASSWORD: The password used to encrypt the p12 certificate
#  - KEYCHAIN_PASSWORD: This is to create the temporary keychain in the Github Action runner.
#  - MAC_TEAM_ID: This is the ID of the team of your Apple Developer Account (Something like S1235Q75WSA)
#  - MAC_APPLE_ID: This is the ID of your Apple Developer Account (usually your email)
#  - MAC_APP_SPECIFIC_PASSWORD: The Application Specific Password created in your Developer Account.
#
# Context and materials that inspired this script:
#  - https://www.pythonguis.com/tutorials/packaging-pyqt6-applications-pyinstaller-macos-dmg/
#  - https://medium.com/flutter-community/build-sign-and-deliver-flutter-macos-desktop-applications-on-github-actions-5d9b69b0469c
#  - https://defn.io/2023/09/22/distributing-mac-apps-with-github-actions/
#  - https://gist.github.com/txoof/0636835d3cc65245c6288b2374799c43
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
