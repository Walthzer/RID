import sys
import os
import time

from PyQt5.QtWidgets import QApplication, QMainWindow, QMenu, QVBoxLayout, QSizePolicy, QMessageBox, QWidget, QPushButton
from PyQt5.QtGui import QIcon


from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
import matplotlib.pyplot as plt

from skimage import io, measure, img_as_bool, img_as_ubyte, filters
from scipy import ndimage

import random

start_time = time.time()

def main():

    ##PREPARE IMAGE:
    #Read in the image:
    filename = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'traces.png')
    traces = img_as_ubyte(io.imread(filename))

    #Find contours in of the traces:
    Alpha = traces[:,:,3]
    bool = img_as_bool(Alpha)
    filled = ndimage.binary_fill_holes(bool)
    gaussian = filters.gaussian(filled)
    contours = measure.find_contours(gaussian, 0.9)

    plt.imshow(gaussian)

    print("---Exiting---")
    print("Elapsed Time: {}".format(time.time() - start_time))

    app = QApplication(sys.argv)
    ex = App(contours)
    sys.exit(app.exec_())



class App(QMainWindow):

    def __init__(self, contours):
        super().__init__()
        self.left = 10
        self.top = 10
        self.title = 'Trace processor'
        self.width = 2000
        self.height = 2000
        self.initUI(contours)

    def initUI(self, PassedContours):
        self.setWindowTitle(self.title)
        self.setGeometry(self.left, self.top, self.width, self.height)

        m = PlotCanvas(self, contours=PassedContours, width=11, height=11)
        m.move(0,0)

        button = QPushButton('Fill Holes', self)
        button.setToolTip('This s an example button')
        button.move(660,0)
        button.resize(140,100)

        self.show()


class PlotCanvas(FigureCanvas):

    def __init__(self, parent=None, contours=None, width=5, height=5, dpi=100):

        fig = Figure(figsize=(width, height), dpi=dpi)
        self.axes = fig.add_subplot(111)
        self.contours = contours

        FigureCanvas.__init__(self, fig)
        self.setParent(parent)

        FigureCanvas.setSizePolicy(self,
                QSizePolicy.Expanding,
                QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)
        self.plot(contours)


    def plot(self, contours):
        ax = self.figure.add_subplot(111)

        for contour in contours:
            ax.plot(contour[:, 1], contour[:, 0], linewidth=2)

        ax.set_title('PyQt Matplotlib Example')
        ax.set_ylim(2048,0)
        ax.set_xlim(0,2048)
        self.draw()

if __name__ == '__main__':
    main()

