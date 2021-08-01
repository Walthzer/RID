class PlotItem(object):
    def __init__(self, data, zondor):
        self.data = data
        self.zonder = zondor

    def plotItem(self):
        pass

    def unplotItem(self):
        pass

    def togglePlotItem(self):
        pass

class PlotItemCircle(PlotItem):
    pass

class PlotItemContour(PlotItem):
    pass

class PlotItemPolygon(PlotItem):
    pass
    
class Image(object):
    def __init__(self, path):
        #FILE SYSTEM
        self.PATH = path
        #self.DIR = TODIR(path)

        #IMAGE DATA:
        self.imageData = self.loadImageData(path)

        self.initializeUI()

        def loadImageData(self, path):
            pass

        def initializeUI(self):
            pass

        def toggleImage(self):
            pass

        def toggleContours(self):
            pass

        def toggleSectors(self):
            pass

        def toggleTracePolygons(self):
            pass

        def toggleTracePaths(self):
            pass


