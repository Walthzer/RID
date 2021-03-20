import numpy as np

from skimage.transform import hough_circle, hough_circle_peaks
from skimage.feature import canny
from skimage.draw import circle_perimeter     

class imageModes():
    def __init__(self, ui=None):
        self.ui = ui
        self.imageMode = None

        self.cresentCircles = []

        #Image Mode ID's
        self.MARKCRESENT = 0
        self.FILLHOLE = 1    

        self.toggle_selector = RectangleSelector(self.ui.imagePlot.axes, self.line_select_callback, drawtype='box', useblit=True, button=[1, 3], minspanx=5, minspany=5, spancoords='pixels', interactive=False)
        self.toggle_selector.set_active(False)

    def reset(self):
        self.imageMode = None
        self.toggle_selector.set_active(False)

    def markCresent(self):
        if self.imageMode == self.MARKCRESENT:
            self.reset()
            return
        self.imageMode = self.MARKCRESENT
        self.ui.CresentButton
        self.toggle_selector.set_active(True)

    def fillHole(self):
        pass

    
    def line_select_callback(self, eclick, erelease):
        x1, y1 = round(eclick.xdata), round(eclick.ydata)
        x2, y2 = round(erelease.xdata), round(erelease.ydata)
        
        if self.imageMode == self.MARKCRESENT:
            image = np.zeros((y2-y1,x2-x1))
            image[0:y2-y1, 0:x2-x1] = self.ui.edges[y1:y2, x1:x2]

            circy, circx = self.houghCircleTransform(image)
            circle = np.array([circx + x1, circy + y1])
            self.cresentCircles.append(circle, self.ui.imagePlot.axes.plot(circle[0], circle[1]))
            self.ui.imagePlot.draw_idle()
            

    def houghCircleTransform(self, image):

        hough_radii = np.arange(15,50)
        hough_res = hough_circle(image, hough_radii)
        accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii, total_num_peaks=1)
        return circle_perimeter(cy[0], cx[0], radii[0], shape=image.shape)

self.imageModes = imageModes(self)

self.image = None
self.edges = None
self.isDrawImage = False

self.contours = []
self.contourImage = None
self.isDrawContours = False

self.initTreeView()
self.initButtons()

def initButtons(self):
    self.CresentButton.clicked.connect(self.imageModes.markCresent)
    self.ContourButton.clicked.connect(self.toggleContours)
    self.selectButton.clicked.connect(self.updateImage)
def initTreeView(self):
    for x in range(1,4):
        self.FileViewer.hideColumn(x)
    self.FileViewer.doubleClicked.connect(self.updateImage)
    self.actionOperating_Directory.triggered.connect(self.updateTreeViewRoot)
    self.Operating_Directory = self.FileViewerModel.rootPath()

def updateTreeViewRoot(self):
    file_dialog = QFileDialog()
    file_dialog.setFileMode(QFileDialog.FileMode.Directory)
    file_dialog.show()

    if file_dialog.exec_():
        self.FileViewer.setRootIndex(self.FileViewerModel.index(file_dialog.selectedUrls()[0].toLocalFile()))
def updateImage(self):
    if not self.FileViewerModel.isDir(self.FileViewer.currentIndex()):
        self.FillHolesButton.setEnabled(True)
        self.CresentButton.setEnabled(True)
        self.ContourButton.setEnabled(True)
        self.image = self.processImage(self.FileViewerModel.filePath(self.FileViewer.currentIndex()))
        self.imageModes.reset()
        self.drawImage(True)

def toggleContours(self):
    if self.isDrawContours:
        while len(self.contourHandels) > 0:
            self.contourHandels.pop().remove()
        self.isDrawContours = False
        self.imagePlot.draw()
    else:
        self.drawContours()

def createContours(self, image=None):
    gaussian = filters.gaussian(image)
    return measure.find_contours(gaussian, 0.9)
def processImage(self, filename):
    traces = img_as_ubyte(io.imread(filename))
    Alpha = traces[:,:,3]
    imageBool = img_as_bool(Alpha)
    return ndimage.binary_fill_holes(imageBool)
def drawImage(self, clear=False):
    self.isDrawImage = True
    if clear:
        self.clear()
    self.edges = canny(self.image)
    self.imagePlot.axes.imshow(self.image, aspect='equal')
    self.imagePlot.draw()
def drawContours(self):
    self.isDrawContours = True
    if (self.contourImage != self.image).any():
        self.contours = self.createContours(self.image)
        self.contourImage = self.image
        self.contourHandels = []
    for contour in self.contours:
        self.contourHandels.extend(self.imagePlot.axes.plot(contour[:, 1], contour[:, 0], linewidth=2))
    self.imagePlot.draw()
def clear(self):
    self.isDrawContours = False
    self.isDrawImage = False
    self.imagePlot.clearAxes()