# PyQT Packaging

A repository with examples of how to package a PyQT application for Linux, Windows and MacOS.


### Linux

For linux we are using [fpm](https://github.com/jordansissel/fpm). Follow the documentation to install it.


```bash
# Inside a virtual environment with pyinstaller and pyqt6 installed
pyinstaller hello-world-linux.spec
./package.sh
fpm -C package -s dir -t deb -n "hello-world" -v 0.1.0 -p hello-world.deb
```
