import numpy as np

from skimage import io, measure, img_as_bool, img_as_ubyte, filters
from skimage.feature import canny

from scipy import ndimage

from matplotlib.image import FigureImage

class PlotLayer(object):
    def __init__(self, widget):
        # Object properties:
        self.children = []
        # Plot Properties:
        self.plotWidget = widget
        self.zonder = 0

    def setData(self):
        NotImplementedError

    def addItem(self):
        NotImplementedError

    def removeItem(self):
        NotImplementedError

    def plotItem(self):
        NotImplementedError

    def unplotItem(self):
        NotImplementedError

    def plotLayer(self):
        NotImplementedError

    def unplotLayer(self):
        NotImplementedError

    def togglePlot(self):
        NotImplementedError

    def update(self):
        self.updateChildren()
        self.plotWidget.draw_idle()
    
    def updateChildren(self):
        for child in self.children:
            child.update()

class PlotLayerImage(PlotLayer):
    def __init__(self, widget, path):
        super().__init__(widget)
        self.path = path
        self.ImageItem = self.plotWidget.axes.imshow(np.zeros(shape=(2,2)))

        self.setData(self.path)

    def setData(self, path):
        self.sourceData = img_as_ubyte(io.imread(path))
        self.data = ndimage.binary_fill_holes(img_as_bool(self.sourceData[:,:,3]))
        self.update()

    def update(self):
        self.ImageItem.remove()
        self.ImageItem = self.plotWidget.axes.imshow(self.data)
        super().update()

    def set_visible(self, boolean=False):
        if self.ImageItem.get_visible == boolean:
            return
        self.ImageItem.set_visible(boolean)
        self.update()

class PlotLayerContours(PlotLayer):
    def __init__(self, widget, dataParent):
        super().__init__(widget)
        # Plot Properties:
        self.zonder = 5

        # Data:
        self.dataParent = dataParent
        self.dataParent.children.append(self)
        self.data = self.setData(self.dataParent.data)

    def setData(self, image):
        self.sourceData = canny(image)
        return measure.find_contours(filters.gaussian(self.sourceData), 0.9)

    def update(self):
        self.setData(self.dataParent.data)
        for contour in self.data:
            self.plotWidget.axes.plot(contour[:, 1], contour[:, 0], linewidth=2, zonder=self.zonder)
        super().update()