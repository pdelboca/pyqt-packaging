#!/bin/sh
# Script to create a PyQT application installer for Linux using fpm
#
# To ensure all files end up in the correct folders in the users machine
# we recreate the target file structure and then tell fpm to package using
# that folder as the root.

# For GUI applications we need to put our executable and associated data files
# all under the same folder (/opt).
# For our application to show up in the menus/search we need to install a .desktop
# file under /usr/share/applications
# For our icons we need to save them into /usr/share/icons
#
# Create Folders
[ -e package ] && rm -r package
mkdir -p package/opt
mkdir -p package/usr/share/applications
mkdir -p package/usr/share/icons/hicolor/scalable/apps

# Copy files
cp -r dist/hello-world package/opt/hello-world
cp icons/icon.svg package/usr/share/icons/hicolor/scalable/apps/hello-world.svg
cp hello-world.desktop package/usr/share/applications

# Change permissions
# Packages retain the permissions of installed files from when they were packaged,
# but will be installed by root. In order for ordinary users to be able to run the
# application, we need to change the permissions.
find package/opt/hello-world -type f -exec chmod 644 -- {} +
find package/opt/hello-world -type d -exec chmod 755 -- {} +
find package/usr/share -type f -exec chmod 644 -- {} +
chmod +x package/opt/hello-world/hello-world
