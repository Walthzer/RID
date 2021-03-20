from PySide2.QtCore import *
from PySide2.QtGui import *
from PySide2.QtWidgets import *

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.widgets import RectangleSelector
from matplotlib.figure import Figure

class PlotCanvas(FigureCanvas):

    def __init__(self, parent=None, width=10, height=10, dpi=100):

        self.fig = Figure(figsize=(width, height))
        self.fig.tight_layout()

        FigureCanvas.__init__(self, self.fig)
        self.setParent(parent)

        FigureCanvas.setSizePolicy(self,
                QSizePolicy.Expanding,
                QSizePolicy.Expanding)
        FigureCanvas.updateGeometry(self)

        self.axes = self.fig.add_axes([0,0,1,1])
        self.clearAxes()

    def clearAxes(self):
        self.axes.clear()
        self.axes.axis('off')
        self.axes.set_ylim(2048,0)
        self.axes.set_xlim(0,2048)
        self.axes.margins(0)

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")
        MainWindow.resize(1364, 1021)

        self.actionOperating_Directory = QAction(MainWindow)
        self.actionOperating_Directory.setObjectName(u"actionOperating_Directory")
        self.actionOperating_Directory.setShortcutContext(Qt.WindowShortcut)

        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")
        self.horizontalLayout = QHBoxLayout(self.centralwidget)
        self.horizontalLayout.setObjectName(u"horizontalLayout")
        self.imagePlot = PlotCanvas(self.centralwidget)
        self.imagePlot.setObjectName(u"imagePlot")

        self.horizontalLayout.addWidget(self.imagePlot)

        MainWindow.setCentralWidget(self.centralwidget)
        self.Features = QDockWidget(MainWindow)
        self.Features.setObjectName(u"Features")
        self.Features.setMaximumSize(QSize(249, 524287))
        self.Features.setCursor(QCursor(Qt.ArrowCursor))
        self.Features.setFloating(False)
        self.Features.setFeatures(QDockWidget.DockWidgetFloatable|QDockWidget.DockWidgetMovable)
        self.Features.setAllowedAreas(Qt.LeftDockWidgetArea|Qt.RightDockWidgetArea)
        self.dockWidgetContents = QWidget()
        self.dockWidgetContents.setObjectName(u"dockWidgetContents")
        self.FeaturesVecticalLayout = QVBoxLayout(self.dockWidgetContents)
        self.FeaturesVecticalLayout.setObjectName(u"FeaturesVecticalLayout")
        self.tools = QGroupBox(self.dockWidgetContents)
        self.tools.setObjectName(u"tools")
        self.tools.setMinimumSize(QSize(231, 91))
        self.tools.setMaximumSize(QSize(231, 16777215))
        self.toolsVerticalLayout = QVBoxLayout(self.tools)
        self.toolsVerticalLayout.setObjectName(u"toolsVerticalLayout")
        #Fill Holes
        self.FillHolesButton = QPushButton(self.tools)
        self.FillHolesButton.setObjectName(u"FillHolesButton")
        self.FillHolesButton.setMaximumSize(QSize(211, 16777215))
        #Cresent Select
        self.CresentButton = QPushButton(self.tools)
        self.CresentButton.setObjectName(u"CresentButton")
        self.CresentButton.setMaximumSize(QSize(211, 16777215))
        #Contours
        self.ContourButton = QPushButton(self.tools)
        self.ContourButton.setObjectName(u"ContourButton")
        self.ContourButton.setMaximumSize(QSize(211, 16777215))

        self.FillHolesButton.setEnabled(False)
        self.CresentButton.setEnabled(False)
        self.ContourButton.setEnabled(False)

        #Add buttons to layout
        self.toolsVerticalLayout.addWidget(self.FillHolesButton)
        self.toolsVerticalLayout.addWidget(self.CresentButton)
        self.toolsVerticalLayout.addWidget(self.ContourButton)


        self.FeaturesVecticalLayout.addWidget(self.tools)

        self.Selection = QGroupBox(self.dockWidgetContents)
        self.Selection.setObjectName(u"Selection")
        self.Selection.setMinimumSize(QSize(231, 381))
        self.Selection.setMaximumSize(QSize(231, 16777215))
        self.verticalLayout_2 = QVBoxLayout(self.Selection)
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.selectButton = QPushButton(self.Selection)
        self.selectButton.setObjectName(u"selectButton")
        self.selectButton.setMaximumSize(QSize(211, 16777215))

        self.verticalLayout_2.addWidget(self.selectButton)

        self.FileViewerModel = QFileSystemModel()
        self.FileViewerModel.setNameFilters(["*.png", "*.jpg", "*.jpeg"])
        self.FileViewerModel.setRootPath('')
        self.FileViewer = QTreeView(self.Selection)
        self.FileViewer.setModel(self.FileViewerModel)
        #self.FileViewer.setRootIndex(self.FileViewerModel.index("P:\WASHM\WireCutter_resources\pcbs_publ"))
        self.FileViewer.setObjectName(u"FileViewer")
        self.FileViewer.setMaximumSize(QSize(211, 16777215))

        self.verticalLayout_2.addWidget(self.FileViewer)


        self.FeaturesVecticalLayout.addWidget(self.Selection)

        self.Features.setWidget(self.dockWidgetContents)
        MainWindow.addDockWidget(Qt.LeftDockWidgetArea, self.Features)
        self.Reports = QDockWidget(MainWindow)
        self.Reports.setObjectName(u"Reports")
        self.Reports.setMaximumSize(QSize(179, 524287))
        self.Reports.setFeatures(QDockWidget.DockWidgetFloatable|QDockWidget.DockWidgetMovable)
        self.Reports.setAllowedAreas(Qt.LeftDockWidgetArea|Qt.RightDockWidgetArea)
        self.dockWidgetContents_3 = QWidget()
        self.dockWidgetContents_3.setObjectName(u"dockWidgetContents_3")
        self.ReportVerticalLayout = QVBoxLayout(self.dockWidgetContents_3)
        self.ReportVerticalLayout.setObjectName(u"ReportVerticalLayout")
        self.status = QGroupBox(self.dockWidgetContents_3)
        self.status.setObjectName(u"status")
        self.status.setMinimumSize(QSize(161, 51))
        self.status.setMaximumSize(QSize(161, 16777215))
        self.statusVerticalLayout = QVBoxLayout(self.status)
        self.statusVerticalLayout.setObjectName(u"statusVerticalLayout")
        self.statusVerticalLayout.setAlignment(Qt.AlignTop)

        self.ReportVerticalLayout.addWidget(self.status)

        self.ApplyButton = QPushButton(self.tools)
        self.ApplyButton.setEnabled(False)
        self.ApplyButton.setObjectName(u"ApplyButton")
        self.ApplyButton.setMaximumSize(QSize(211, 16777215))

        self.statusVerticalLayout.addWidget(self.ApplyButton)

        self.Reports.setWidget(self.dockWidgetContents_3)
        MainWindow.addDockWidget(Qt.RightDockWidgetArea, self.Reports)

        self.menuBar = QMenuBar(MainWindow)
        self.menuBar.setObjectName(u"menuBar")
        self.menuBar.setGeometry(QRect(0, 0, 1364, 21))
        self.menuFile = QMenu(self.menuBar)
        self.menuFile.setObjectName(u"menuFile")
        MainWindow.setMenuBar(self.menuBar)

        self.menuBar.addAction(self.menuFile.menuAction())
        self.menuFile.addAction(self.actionOperating_Directory)

        self.retranslateUi(MainWindow)

        QMetaObject.connectSlotsByName(MainWindow)
    # setupUi

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"RID: Trace utility", None))
        self.Features.setWindowTitle(QCoreApplication.translate("MainWindow", u"Features", None))
        self.tools.setTitle(QCoreApplication.translate("MainWindow", u"Tools", None))
        self.FillHolesButton.setText(QCoreApplication.translate("MainWindow", u"&Fill Hole", None))
        self.ContourButton.setText(QCoreApplication.translate("MainWindow", u"Toggle Contours", None))
        self.CresentButton.setText(QCoreApplication.translate("MainWindow", u"&Mark Cresent Mode", None))
        self.Selection.setTitle(QCoreApplication.translate("MainWindow", u"Trace slection", None))
        self.selectButton.setText(QCoreApplication.translate("MainWindow", u"Select", None))
        self.Reports.setWindowTitle(QCoreApplication.translate("MainWindow", u"Reports", None))
        self.ApplyButton.setText(QCoreApplication.translate("MainWindow", u"Apply", None))
        self.status.setTitle(QCoreApplication.translate("MainWindow", u"Satus", None))
        self.menuFile.setTitle(QCoreApplication.translate("MainWindow", u"File", None))
        self.actionOperating_Directory.setText(QCoreApplication.translate("MainWindow", u"Operating Directory", None))
    # retranslateUi