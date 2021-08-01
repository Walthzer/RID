# This Python file uses the following encoding: utf-8
import sys

from RIDTraceUtilityUI import Ui_MainWindow
from RIDTraceUtilityUIExtra import cresentToolModifiers, ToolModifiers, traceModeConfirmDialog, ridTraceColours, TraceDataContainer, TAGSDataContainer, runnableTypes, processContourDataDialog, valueDialog
from RIDTraceUtilityCommands import *

import numpy as np
import ridObjectsWithProgressUpdates as rid

from skimage import io, measure, img_as_bool, img_as_ubyte, filters
from skimage.transform import hough_circle, hough_circle_peaks
from skimage.draw import circle_perimeter   
from skimage.feature import canny

from scipy import ndimage
from skgeom.draw import draw

from matplotlib.image import FigureImage
from matplotlib.widgets import RectangleSelector
from matplotlib.patches import Polygon

from PyQt5.QtWidgets import QMainWindow, QApplication
from PyQt5 import QtCore, QtGui, QtWidgets

from concurrent.futures import ThreadPoolExecutor

class MainWindowUIClass(Ui_MainWindow):
    closeValueDialog = QtCore.pyqtSignal()
    def __init__(self):
        super().__init__()
        
    def setupUi(self, MainWindow):
        super().setupUi(MainWindow)
        self.initTreeView()
        self.initButtons()
        self.initUndoStack()
        self.initToolModifiers()

    def initButtons(self):
        # Working Directory Button:
        self.actionOperating_Directory.triggered.connect(self.updateTreeViewRoot)

        self.actionReview_Contours.setDisabled(True)
        self.actionMark_Cresent.setDisabled(True)
        self.actionLink_Markings.setDisabled(True)
        self.actionImage_Mode.setDisabled(True)

        self.actionMove_Node.setDisabled(True)
        self.actionValue_Diaog.setDisabled(True)
        self.actionTrace_Mode.setDisabled(True)

    def initTreeView(self):
        self.FileViewerModel = QtWidgets.QFileSystemModel()
        self.FileViewerModel.setNameFilters(["*.png", "*.jpg", "*.jpeg"])
        self.FileViewerModel.setRootPath("P:\\WASHM\\WireCutter_resources\\pcbs_publ\\standard\\3W\\extvib\\0")
        self.FileViewer.setModel(self.FileViewerModel)
        self.FileViewer.setRootIndex(self.FileViewerModel.index("P:\\WASHM\\WireCutter_resources\\pcbs_publ\\standard\\3W\\extvib\\0"))
        self.Operating_Directory = self.FileViewerModel.rootPath()
        for x in range(1,4):
            self.FileViewer.hideColumn(x)

    def initUndoStack(self):
        self.undoStack = QtWidgets.QUndoStack()
        self.undoView.setStack(self.undoStack)
        undoAction = self.undoStack.createUndoAction(self, "&Undo")
        undoAction.setShortcuts(QtGui.QKeySequence.Undo)
        redoAction = self.undoStack.createRedoAction(self, "&Redo")
        redoAction.setShortcuts(QtGui.QKeySequence.Redo)

        self.imageToolBar.addAction(undoAction)
        self.imageToolBar.addAction(redoAction)
        self.traceToolBar.addAction(undoAction)
        self.traceToolBar.addAction(redoAction)

    def initToolModifiers(self):
        self.cresentTMB = cresentToolModifiers(self)

        self.verticalLayout.addWidget(self.cresentTMB)
        self.cresentTMB.setHidden(True)

    def updateTreeViewRoot(self):
        file_dialog = QtWidgets.QFileDialog()
        file_dialog.setFileMode(QtWidgets.QFileDialog.FileMode.Directory)
        file_dialog.show()

        if file_dialog.exec_():
            self.FileViewer.setRootIndex(self.FileViewerModel.index(file_dialog.selectedUrls()[0].toLocalFile()))

class EditModes():
    CORRECTION = 0
    NODES_VALUES = 1

class contourRunnable(QtCore.QRunnable):
    def __init__(self, id_, contour, dialog):
        super().__init__()
        self.id = id_
        self.contour = contour
        self.dialog = dialog

    def run(self):
        self.dialog.printText.emit("Processing contour {}...".format(self.id), 0, True)
        self.dialog.printText.emit("Creating Trace Object", 1, True)
        trace = rid.Trace(self.contour, self.id - 1)
        self.dialog.printText.emit("Trace Created", -1, True)
        for key in self.dialog.ui.TraceDataContainer.Sectors.sector_list:
            self.dialog.ui.TraceDataContainer.Sectors.sector_list[key].intersections_with_trace(trace)
        self.dialog.printText.emit("{} out of {} contours processed".format(self.id, self.dialog.progressBar.maximum()), -10, True)
        self.dialog.printTextPlain.emit("")
        self.dialog.runnableFinishedSignal.emit(runnableTypes.Trace, trace)

class TraceUtility(QMainWindow, MainWindowUIClass):
    def __init__(self):
        QMainWindow.__init__(self)
        self.setupUi(self)

        self.ImageData = None
        self.EdgeData = []
        self.ContourData = [None, [], [], []] #Image, Contours, previous Contours, artist
        self.TraceDataContainer = TraceDataContainer(self)
        self.TAGSDataContainer = TAGSDataContainer(self)
        self.mode = None

        self.activeTool = None

        #CORRECTIONS:
        self.cresentCircles = {}

        self.toggle_selector = RectangleSelector(self.widget.axes, self.line_select_callback, drawtype='box', useblit=True, button=[1, 3], minspanx=5, minspany=5, spancoords='pixels', interactive=False)
        self.toggle_selector.set_active(False)

        self.setMode(None)

    def ToolChanged(self, action):
        if action.isChecked():
            self.activeTool = action
        else:
            self.activeTool = None
        
        if action == self.actionMark_Cresent:
            if not self.actionMark_Cresent.isChecked():
                #self.actionLink_Markings.setDisabled(False)
                self.actionReview_Contours.setDisabled(False)

                self.toggle_selector.set_active(False)
                self.widget.setCursor(QtCore.Qt.ArrowCursor)

                self.cresentTMB.setHidden(True)
                self.toolModifiersBox.setHidden(False)
            else:
                self.actionLink_Markings.setDisabled(True)
                self.actionReview_Contours.setDisabled(True)
                
                if len(self.EdgeData) == 0:
                    self.EdgeData = canny(self.ImageData)

                self.toggle_selector.set_active(True)
                self.widget.setCursor(QtCore.Qt.CrossCursor)

                self.toolModifiersBox.setHidden(True)
                self.cresentTMB.setHidden(False)

        elif action == self.actionReview_Contours:
            if not self.actionReview_Contours.isChecked():
                self.actionMark_Cresent.setDisabled(False)
                #self.actionLink_Markings.setDisabled(False)

                self.toggleContours()
            else:
                self.actionMark_Cresent.setDisabled(True)
                self.actionLink_Markings.setDisabled(True)

                self.toggleContours(True)

        elif action == self.actionLink_Markings:
            if not self.actionLink_Markings.isChecked():
                self.actionMark_Cresent.setDisabled(False)
                self.actionReview_Contours.setDisabled(False)
            else:
                self.actionMark_Cresent.setDisabled(True)
                self.actionReview_Contours.setDisabled(True)

        elif action == self.actionValue_Diaog:
            print("dialog")
            self.actionValue_Diaog.setDisabled(True)
            self.valueDialog = valueDialog(self)
            self.valueDialog.display()

    def modeSwitched(self, action):
        if action == self.actionTrace_Mode:
            if self.TraceDataContainer == None:
                pass
            dialog = traceModeConfirmDialog(self)
            dialog.accepted.connect(self.createTraceData)
            dialog.open()
        elif action == self.actionImage_Mode: 
            self.setMode(EditModes.CORRECTION)

    def createTraceData(self):
        if not (self.ImageData == self.ContourData[0]).all():
            self.createContours()

        self.TraceDataContainer = TraceDataContainer(self)

        self.TraceDataContainer.Sectors = rid.Sectors(rid.Resolution(self.ImageData.shape[0],self.ImageData.shape[1]))

        dialog = processContourDataDialog(self)
        rid.dialog = dialog
        dialog.open()
        dialog.setMaxProgressBar.emit(len(self.ContourData[1])) # contour jobs

        dialog.printDottedText.emit("Loading {} contours for processing".format(len(self.ContourData[1])))
        dialog.printTextPlain.emit("")

        pool = QtCore.QThreadPool.globalInstance()
        pool.setMaxThreadCount(1)
        dialog.pool = pool

        for key, contour in enumerate(self.ContourData[1]):
            pool.start(contourRunnable(key+1, contour, dialog))

    def FileViewerBoubleClick(self):
        if not self.FileViewerModel.isDir(self.FileViewer.currentIndex()):
            if not self.activeTool == None:
                self.activeTool.trigger()

            fp = self.FileViewerModel.filePath(self.FileViewer.currentIndex())
            self.TAGSDataContainer.loadTAGfile(fp)
            self.loadImage(fp)
            self.setMode(EditModes.CORRECTION)
            self.updatePlot()

    def updatePlot(self):
        self.widget.clear()
        self.widget.axes.imshow(self.ImageData, aspect='equal')
        self.widget.draw_idle()

    def loadImage(self, path):
        self.ImagePath = path
        self.ImageData = ndimage.binary_fill_holes(img_as_bool(img_as_ubyte(io.imread(path))[:,:,3]))
        self.ImageData[self.ImageData==False] = None
        self.ContourData = [None, [], [], []]
        self.EdgeData = []

    def setMode(self, mode):
        self.mode = mode

        self.actionMark_Cresent.setDisabled(True)
        self.actionLink_Markings.setDisabled(True)
        self.actionReview_Contours.setDisabled(True)

        self.actionMove_Node.setDisabled(True)
        self.actionValue_Diaog.setDisabled(True)

        self.actionImage_Mode.setDisabled(True)
        self.actionTrace_Mode.setDisabled(True)

        self.imageToolBar.setVisible(False)
        self.traceToolBar.setVisible(False)

        self.closeValueDialog.emit()

        if mode == EditModes.CORRECTION:
            self.actionMark_Cresent.setDisabled(False)
            self.actionReview_Contours.setDisabled(False)
            self.actionTrace_Mode.setDisabled(False)

            self.imageToolBar.setVisible(True)
        
        elif mode == EditModes.NODES_VALUES:
            self.actionReview_Contours.setDisabled(False)
            self.actionImage_Mode.setDisabled(False)

            #self.actionMove_Node.setDisabled(False)
            self.actionValue_Diaog.setDisabled(False)

            self.traceToolBar.setVisible(True)

            self.updatePlot()
            self.cresentCircles = {}

            self.toggleContours(True, ridTraceColours.noTag)
            
            for sector in self.TraceDataContainer.Sectors.sector_list.values():
                    self.widget.axes.plot(sector.polygon.coords[:,1], sector.polygon.coords[:,0], color='black', lw=1, zorder=50)

            for trace in self.TraceDataContainer.getTraces():
                for s in trace.segments:
                    self.widget.axes.plot([s.vertex0.x, s.vertex1.x], [s.vertex0.y, s.vertex1.y], 'b-', lw=1, zorder=15)

    def line_select_callback(self, eclick, erelease):
        x1, y1 = round(eclick.xdata), round(eclick.ydata)
        x2, y2 = round(erelease.xdata), round(erelease.ydata)
        
        if self.mode == EditModes.CORRECTION:
            image = np.zeros((y2-y1,x2-x1))
            image[0:y2-y1, 0:x2-x1] = self.EdgeData[y1:y2, x1:x2]

            circy, circx = self.houghCircleTransform(image)
            circle = np.array([circx + x1, circy + y1])
            self.undoStack.push(addCresentCircle(self, circle))

    def houghCircleTransform(self, image):
        hough_radii = np.arange(self.cresentTMB.getMinimun(),75)
        hough_res = hough_circle(image, hough_radii, normalize=True)
        accums, cx, cy, radii = hough_circle_peaks(hough_res, hough_radii, total_num_peaks=1)
        return circle_perimeter(cy[0], cx[0], radii[0], shape=image.shape)

    def createContours(self):
            self.ContourData[2] = self.ContourData[1]
            self.ContourData[1] = self.calculateContours(self.ImageData)
            self.ContourData[0] = self.ImageData

    def toggleContours(self, boolean=False, colour=None):
        if boolean:
            if not (self.ImageData == self.ContourData[0]).all():
                self.createContours()

            for contour in self.ContourData[1]:
                self.ContourData[3].append(self.widget.axes.plot(contour[:, 1], contour[:, 0], color=colour, linewidth=2, zorder=10))
        else:
            for ArtistList in self.ContourData[3]:
                for Artist in ArtistList:
                    Artist.remove()
            self.ContourData[3] = []
        self.widget.draw_idle()

    def calculateContours(self, image=None):
        gaussian = filters.gaussian(image)
        return measure.find_contours(gaussian, 0.9)

    def exportTracesJSON(self):
        pass

    def checkForPartsJSON(self):
        pass

    def createPartsBboxJSON(self):
        pass


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = TraceUtility()
    window.show()
    sys.exit(app.exec_())


