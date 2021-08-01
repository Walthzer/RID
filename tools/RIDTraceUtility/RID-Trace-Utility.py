import sys
import os
import time

from PySide2.QtCore import *
from PySide2.QtGui import *
from PySide2.QtWidgets import *

import ridObjects as rid
from RIDTraceUtilityUI import Ui_MainWindow
from RIDTraceUtilityUIExtra import PlotCanvas
#from RIDTraceUtilityCommands import 
from skimage import io, measure, img_as_bool, img_as_ubyte, filters
from skimage.feature import canny
from scipy import ndimage

import random

def main():
    app = QApplication(sys.argv)

    mainWindow = MainWindow()

    mainWindow.show()

    sys.exit(app.exec_())

class MainWindow(QMainWindow, Ui_MainWindow):
    def __init__(self):
        QMainWindow.__init__(self)
        self.setupUi(self)


if (__name__ == '__main__'):
    main()