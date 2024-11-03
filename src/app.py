# Based on pythonguis.com examples

from PyQt6.QtWidgets import (
    QMainWindow,
    QApplication,
    QLabel,
    QVBoxLayout,
    QPushButton,
    QWidget,
)
from PyQt6.QtGui import QIcon
import os
import sys

# Make all paths relative to the project folder
basedir = os.path.dirname(__file__)

# tweak we need to make to get the icon showing on the taskbar on Windows
# https://www.pythonguis.com/tutorials/packaging-pyqt6-applications-windows-pyinstaller/
try:
    from ctypes import windll  # Only exists on Windows.
    myappid = "me.pdelboca.helloworld"
    windll.shell32.SetCurrentProcessExplicitAppUserModelID(myappid)
except ImportError:
    pass


class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Hello World")
        layout = QVBoxLayout()
        label = QLabel("My simple app.")
        label.setMargin(10)
        layout.addWidget(label)

        button_close = QPushButton("Close")
        button_close.setIcon(
            QIcon(os.path.join(basedir, "media/icons", "lightning.svg"))
        )
        button_close.pressed.connect(self.close)
        layout.addWidget(button_close)

        button_maximize = QPushButton("Maximize")
        button_maximize.setIcon(
            QIcon(os.path.join(basedir, "media/icons", "uparrow.svg"))
        )
        button_maximize.pressed.connect(self.showMaximized)
        layout.addWidget(button_maximize)

        container = QWidget()
        container.setLayout(layout)

        self.setCentralWidget(container)


app = QApplication(sys.argv)
app.setWindowIcon(QIcon(os.path.join(basedir, "media/icons", "icon.svg")))
window = MainWindow()
window.show()
app.exec()
