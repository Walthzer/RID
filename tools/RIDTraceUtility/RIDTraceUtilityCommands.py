import itertools

from skimage import img_as_bool
from skimage.feature import canny

from scipy import ndimage

from PyQt5.QtWidgets import QUndoCommand

class addCresentCircle(QUndoCommand):
    id_iter = itertools.count()
    def __init__(self, ui, circleData):
        super().__init__()

        self.ui = ui
        self.circleData = circleData
        self.id = next(self.id_iter)
        self.key = "{}".format(self.id)

        self.setText("added cresent mark '{}'".format(self.key))

    def redo(self):
        Artist = self.ui.widget.axes.plot(self.circleData[0], self.circleData[1], zorder=5)
        Artist[0].id_key = self.key
        self.ui.cresentCircles[self.key] = self.circleData, Artist
        self.ui.widget.draw_idle()

        if len(self.ui.cresentCircles) == 1:
            self.ui.cresentTMB.cresentTMBApply.setDisabled(False)

    def undo(self):
        circleModel = self.ui.cresentCircles.pop(self.key)

        if len(self.ui.cresentCircles) == 0:
            self.ui.cresentTMB.cresentTMBApply.setDisabled(True)

        circleModel[1][0].remove()
        self.ui.widget.draw_idle()


class cresentToolApply(QUndoCommand):
    id_iter = itertools.count()
    def __init__(self, ui):
        super().__init__()

        self.ui = ui

        self.image = None
        self.CorrectedImage = None
        self.cresentCirclesData = {}
        
        self.setText("Applied Cresent Markings")

    def redo(self):
        self.ImageDataArr = [self.ui.ImageData.copy(), self.ui.EdgeData.copy()]
        CorrectedImage = self.ui.ImageData.copy()
        for key, value in self.ui.cresentCircles.items():
            self.cresentCirclesData[key] = value[0].copy()
            CorrectedImage[value[0][1], value[0][0]] = True
            value[1][0].remove()
            del value

        del self.ui.cresentCircles
        self.ui.cresentCircles = {}

        CorrectedImage = ndimage.binary_fill_holes(img_as_bool(CorrectedImage))

        self.CorrectedImageArr = [CorrectedImage, canny(CorrectedImage)]
        self.ui.ImageData, self.ui.EdgeData = self.CorrectedImageArr
        self.ui.updatePlot()
        self.ui.cresentTMB.cresentTMBApply.setDisabled(True)

    def undo(self):
        self.ui.ImageData, self.ui.EdgeData = self.ImageDataArr
        self.ui.updatePlot()

        for key, value in self.cresentCirclesData.items():
            Artist = self.ui.widget.axes.plot(value[0], value[1])
            Artist[0].id_key = key
            self.ui.cresentCircles[key] = value, Artist

        del self.CorrectedImageArr
        del self.cresentCirclesData
        self.cresentCirclesData = {}

        self.ui.widget.draw_idle()
        self.ui.cresentTMB.cresentTMBApply.setDisabled(False)