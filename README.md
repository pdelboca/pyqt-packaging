# PyQT Packaging

A repository with examples of how to package a PyQT application for Linux, Windows and MacOS.

## Repository structure

 - `packaging` folder: contains all the files and executables to package the PyQt application
 - `src` folder: contains all the application source code.

### Linux

For linux we are using [fpm](https://github.com/jordansissel/fpm). Follow the documentation to install it.

```bash
# Inside a virtual environment with pyinstaller and pyqt6 installed
./packaging/linux/package.sh
```

### MacOS

For MacOS we are using create-dmg and all the native MacOS tool to sign and notarize the DMG.

```bash
# Inside a virtual environment with pyinstaller and pyqt6 installed
# It also requires some secrets: See build-dmg.sh docstring for more information
./packaging/macos/build-dmg.sh
```

### Windows

TODO
