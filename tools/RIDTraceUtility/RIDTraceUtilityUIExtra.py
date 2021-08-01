from datetime import datetime

import os
import json
import time

from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *

from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.widgets import RectangleSelector
from matplotlib.figure import Figure

import RIDTraceUtilityValueDialog as RIDValueDialogUI
from RIDTraceUtilityCommands import cresentToolApply

import ridObjectsWithProgressUpdates as rid

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

    def clear(self):
        self.clearAxes()

    def clearAxes(self):
        self.axes.clear()
        self.axes.axis('off')
        self.axes.set_ylim(2048,0)
        self.axes.set_xlim(0,2048)
        self.axes.margins(0)

class ToolModifiers(QGroupBox):
    def __init__(self, ui):
        super().__init__(ui.dockWidgetContents)
        self.setObjectName("toolModifiersBox")

class cresentToolModifiers(ToolModifiers):
    def __init__(self, ui):
        super().__init__(ui)
        self.ui = ui
        self.basicMinimun = 15
        self.basicOffset = 20

        self.TMB_VL = QVBoxLayout(self)
        self.TMB_VL.setObjectName("TMB_VL")
        self.TMB_HL = QHBoxLayout()
        self.TMB_HL.setSizeConstraint(QLayout.SetMaximumSize)
        self.TMB_HL.setObjectName("TMB_HL")
        self.AlphaSizeToggle = QRadioButton(self)
        self.AlphaSizeToggle.setObjectName("Alpa Size")
        self.TMB_HL.addWidget(self.AlphaSizeToggle)
        self.AlphaSizeSpinner = QSpinBox(self)
        self.AlphaSizeSpinner.setObjectName("AlphaSizeSpinner")
        self.TMB_HL.addWidget(self.AlphaSizeSpinner)
        self.TMB_VL.addLayout(self.TMB_HL)
        self.TMB_HL_2 = QHBoxLayout()
        self.TMB_HL_2.setSizeConstraint(QLayout.SetMaximumSize)
        self.TMB_HL_2.setObjectName("TMB_HL_2")
        self.BetaSizeToggle = QRadioButton(self)
        self.BetaSizeToggle.setObjectName("Beta Size")
        self.TMB_HL_2.addWidget(self.BetaSizeToggle)
        self.BetaSizeSpinner = QSpinBox(self)
        self.BetaSizeSpinner.setObjectName("BetaSizeSpinner")
        self.TMB_HL_2.addWidget(self.BetaSizeSpinner)
        self.TMB_VL.addLayout(self.TMB_HL_2)
        self.cresentTMBApply = QPushButton(self)
        self.cresentTMBApply.setDisabled(True)
        self.cresentTMBApply.setObjectName("cresentTMBApply")   
        self.TMB_VL.addWidget(self.cresentTMBApply)


        self.AlphaSizeToggle.setChecked(True)
        self.AlphaSizeSpinner.setValue(self.basicMinimun)
        self.BetaSizeSpinner.setValue(self.basicMinimun + self.basicOffset)

        self.cresentTMBApply.clicked.connect(self.applyAction)

        self.retranslateUi(ui)
        
    def applyAction(self):
        self.ui.undoStack.push(cresentToolApply(self.ui))

    def getMinimun(self):
        if self.AlphaSizeToggle.isChecked():
            return self.AlphaSizeSpinner.value()
        elif self.BetaSizeToggle.isChecked():
            return self.BetaSizeSpinner.value()

    def retranslateUi(self, ui):
        _translate = QCoreApplication.translate
        self.setTitle(_translate("MainWindow", "Tool Modifiers:"))
        self.AlphaSizeToggle.setText(_translate("MainWindow", "Alpha Minimun Size"))
        self.BetaSizeToggle.setText(_translate("MainWindow", "Beta Minimun Size"))
        self.cresentTMBApply.setText(_translate("MainWindow", "Apply"))

class traceModeConfirmDialog(QDialog):
    def __init__(self, ui):
        super().__init__(ui, Qt.WindowCloseButtonHint)
        self.setObjectName("Dialog")
        self.resize(400, 100)
        self.verticalLayout = QVBoxLayout(self)
        self.verticalLayout.setObjectName("verticalLayout")
        self.label = QLabel(self)
        self.label.setScaledContents(True)
        self.label.setAlignment(Qt.AlignCenter)
        self.label.setWordWrap(True)
        self.label.setObjectName("label")
        self.verticalLayout.addWidget(self.label)
        self.buttonBox = QDialogButtonBox(self)
        self.buttonBox.setOrientation(Qt.Horizontal)
        self.buttonBox.setStandardButtons(QDialogButtonBox.No|QDialogButtonBox.Yes)
        self.buttonBox.setCenterButtons(True)
        self.buttonBox.setObjectName("buttonBox")
        self.verticalLayout.addWidget(self.buttonBox)

        self.retranslateUi()
        self.buttonBox.accepted.connect(self.accept)
        self.buttonBox.rejected.connect(self.reject)
        QMetaObject.connectSlotsByName(self)

        
    def retranslateUi(self):
        _translate = QCoreApplication.translate
        self.setWindowTitle(_translate("Dialog", "Confirm"))
        self.label.setText(_translate("Dialog", "<html><head/><body><h1 style=\" margin-top:18px; margin-bottom:12px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:14pt; font-weight:600; color:#aa0000;\">WARNING:</span></h1><p><span style=\" font-size:12pt;\">Are you sure you want to generate Trace data?</span></p></body></html>"))

class TraceItem(QStandardItem):
    def __init__(self, row, Trace):
        QStandardItem.__init__(self)
        self.Trace = Trace
        self.setData("{}".format(row), Qt.DisplayRole)

class TraceTagValidator(QValidator):
    def __init__(self, parent, tags):
        QValidator.__init__(self, parent)
        self.tags = tags

    def validate(self, string, pos):
        string = string.upper()

        table = self.parent().parent().parent()
        lineEdit = self.parent()

        table.parent().parent().updateTraceColour(selectedRow=table.currentIndex().row(), rowTagValue=string)

        if string == "" or string in self.tags:
            lineEdit.setStyleSheet("background-color: white")
            return QValidator.Acceptable, string, pos

        for tag in self.tags:
            if tag.startswith(string):
                lineEdit.setStyleSheet("background-color: red")
                return QValidator.Acceptable, string, pos

        return QValidator.Invalid, string, pos

class TraceTagDelegate(QStyledItemDelegate):
    def __init__(self, parent):
        QStyledItemDelegate.__init__(self, parent)

    def createEditor(self, parent, option, index):
        tags = self.parent().ui.TAGSDataContainer.tags
        completer = QCompleter(tags)
        completer.setCompletionMode(QCompleter.PopupCompletion)

        editor = QLineEdit(parent)

        validator = TraceTagValidator(editor, tags)

        editor.setPlaceholderText("GND")
        editor.setCompleter(completer)
        editor.setValidator(validator)

        return editor

class ridMimeTypes(object):
    tag = "TAG"
    trace = "TRACE"

class ridTraceColours(object):
    noTag = 'b'
    inValidTag = 'r'
    validTag = 'g'

class TraceTagItem(QStandardItem):
    def __init__(self):
        QStandardItem.__init__(self)
        self.setFlags(self.flags() | Qt.ItemIsDropEnabled | Qt.ItemIsDragEnabled)

class TraceConnectionItem(QStandardItem):
    def __init__(self):
        QStandardItem.__init__(self)
        self.setFlags(Qt.ItemIsSelectable | Qt.ItemIsDragEnabled | Qt.ItemIsEnabled | Qt.ItemIsDropEnabled | Qt.ItemIsDragEnabled)

class TagItem(QStandardItem):
    def __init__(self, tag):
        QStandardItem.__init__(self)
        self.setFlags(Qt.ItemIsSelectable | Qt.ItemIsDragEnabled | Qt.ItemIsEnabled)

        self.setData(tag, Qt.UserRole)
        self.setData(tag['tag'], Qt.EditRole)
        self.setData(tag['explainer'], Qt.ToolTipRole)

class TraceDataContainer(QStandardItemModel):
    def __init__(self, parent = None):
        QStandardItemModel.__init__(self, 0, 2, parent)
        self.setHorizontalHeaderLabels(["Tag", "Connections"])
        self.dataChanged.connect(self.syncItemToTrace)

        self.Sectors = None

    def mimeData(self, indexes):
        mimedata = super(TraceDataContainer, self).mimeData(indexes)
        if indexes:
            mimedata.setData(ridMimeTypes.trace, QByteArray(bytearray(str(indexes[0].row()).encode())))
            if indexes[0].column() == 0 and not indexes[0].data() == None:
                mimedata.setData(ridMimeTypes.tag, QByteArray(bytearray(indexes[0].data().encode())))
        return mimedata

    def canDropMimeData(self, mimeData, action, row, column, parent):
        if parent.column() == 0 and (not mimeData.retrieveData(ridMimeTypes.tag, QVariant.String) == None):
            return True
        
        if parent.column() == 1 and (not mimeData.retrieveData(ridMimeTypes.trace, QVariant.String) == None):
            return True

        return False

    def dropMimeData(self, mimeData, action, row, column, parent):
        if not self.canDropMimeData(mimeData, action, row, column, parent):
            return False

        data = mimeData.retrieveData(ridMimeTypes.trace, QVariant.String)
        if (not data == None):
            originRow = int(data.data().decode())
            row = parent.row()
            if originRow == row:
                parent.model().setData(parent, None, Qt.UserRole)
                parent.model().setData(parent, None, Qt.DisplayRole)
                self.dataChanged.emit(parent, parent)
                return True
            
            parent.model().setData(parent, parent.model().getTrace(originRow), Qt.UserRole)
            parent.model().setData(parent, parent.model().getTrace(originRow).id, Qt.DisplayRole)
            self.dataChanged.emit(parent, parent)
            return True

        data = mimeData.retrieveData(ridMimeTypes.tag, QVariant.String)
        if (not data == None):
            parent.model().setData(parent, data.data().decode(), Qt.DisplayRole)
            self.dataChanged.emit(parent, parent)
            return True

        return False

    def syncItemToTrace(self, topLeft, bottomRight):
        item = self.itemFromIndex(topLeft)
        if isinstance(item, TraceTagItem):
            self.getTrace(item.row()).tag = item.text()

    def addTrace(self, Trace):
        self.appendRow([TraceTagItem(), TraceConnectionItem()])
        self.setVerticalHeaderItem(self.rowCount() - 1, TraceItem(self.rowCount() - 1, Trace))
    
    def getTrace(self, row):
        return self.verticalHeaderItem(row).Trace
    
    def getTraces(self):
        for row in range(self.rowCount()):
            yield self.getTrace(row)

class TAGSDataContainer(QStandardItemModel):
    def __init__(self, parent = None):
        QStandardItemModel.__init__(self, 0, 1, parent)
        self.tags = []

    def mimeData(self, indexes):
        mimedata = super(TAGSDataContainer, self).mimeData(indexes)
        if indexes:
            mimedata.setData(ridMimeTypes.tag, QByteArray(bytearray(indexes[0].data().encode())))
        return mimedata

    def loadTAGfile(self, fp):
        while self.rowCount() == 0:
            fp = os.path.dirname(fp)
            jsonPath = os.path.join(fp, "tags.json")
            if os.path.isfile(jsonPath):
                for tag in json.load(open(jsonPath, "r")):
                    self.addTAG(tag)

    def overrideTAGload(self, fp):
        self.clear()
        self.loadTAGfile(fp)

    def addTAG(self, tag):
        self.appendRow(TagItem(tag))
        self.tags.append(tag['tag'])

    def getTAG(self, row):
        return self.verticalHeaderItem(row).Trace
    
    def getTAGS(self):
        for row in range(self.rowCount()):
            yield self.getTAG(row)

class runnableTypes():
        Trace = 0
        Sectors = 1

class processContourDataDialog(QDialog):
    printTextPlain = pyqtSignal(str)
    printDottedText = pyqtSignal(str)
    printText = pyqtSignal(str, int, bool)

    setMaxProgressBar = pyqtSignal(int)
    updateProgressBar = pyqtSignal(int)
    changeIndentSignal = pyqtSignal(int)
    runnableFinishedSignal = pyqtSignal(int, object)

    def __init__(self, ui):
        super().__init__(ui, Qt.WindowCloseButtonHint)
        self.ui = ui
        self.indentAmount = 0

        self.setObjectName("Dialog")
        self.resize(400, 200)
        self.verticalLayout = QVBoxLayout(self)
        self.verticalLayout.setObjectName("verticalLayout")
        self.progressBar = QProgressBar(self)
        self.progressBar.setMaximum(100)
        self.progressBar.setProperty("value", 0)
        self.progressBar.setAlignment(Qt.AlignCenter)
        self.progressBar.setOrientation(Qt.Horizontal)
        self.progressBar.setInvertedAppearance(False)
        self.progressBar.setTextDirection(QProgressBar.TopToBottom)
        self.progressBar.setObjectName("progressBar")
        self.verticalLayout.addWidget(self.progressBar)
        self.TextBox = QTextEdit(self)
        self.TextBox.setSizeAdjustPolicy(QAbstractScrollArea.AdjustIgnored)
        self.TextBox.setReadOnly(True)
        self.TextBox.setAcceptRichText(False)
        self.TextBox.setObjectName("TextBox")
        self.verticalLayout.addWidget(self.TextBox)
        self.buttonBox = QDialogButtonBox(self)
        self.buttonBox.setOrientation(Qt.Horizontal)
        self.buttonBox.setStandardButtons(QDialogButtonBox.Ok)
        self.buttonBox.setCenterButtons(True)
        self.buttonBox.setObjectName("buttonBox")
        self.verticalLayout.addWidget(self.buttonBox)

        self.buttonBox.button(QDialogButtonBox.Ok).setDisabled(True)
        self.rejected.connect(self.stopPool)
        self.progressBar.valueChanged.connect(self.trackCompletion)

        self.printTextPlain.connect(self.writeTextPlain)
        self.printDottedText.connect(self.writeDottedText)
        self.printText.connect(self.writeText)
        
        self.setMaxProgressBar.connect(self.progressBar.setMaximum)
        self.updateProgressBar.connect(self.progressBar.setValue)
        self.runnableFinishedSignal.connect(self.runnableFinished)
        self.changeIndentSignal.connect(self.changeIndent)

        self.retranslateUi()
        self.buttonBox.accepted.connect(self.accept)
        self.buttonBox.rejected.connect(self.reject)
        QMetaObject.connectSlotsByName(self)
    
    def accept(self):
        super().accept()
        self.ui.setMode(1)

    def runnableFinished(self, runnableType, Data):
        self.progressBar.setValue(self.progressBar.value() + 1)

        if runnableType == runnableTypes.Trace:
            self.ui.TraceDataContainer.addTrace(Data)

    def trackCompletion(self):
        if self.progressBar.value() == self.progressBar.maximum():
            self.writeDottedText("JOBS DONE. TRACE DATA AVAILABLE")
            self.buttonBox.rejected.connect(self.accept)
            self.buttonBox.button(QDialogButtonBox.Ok).setDisabled(False)

    def changeIndent(self, indentAmount):
        self.indentAmount = max(0, self.indentAmount + indentAmount)

    def AutoScroll(self):
        self.TextBox.verticalScrollBar().setValue(self.TextBox.verticalScrollBar().maximum())

    def writeText(self, text="", indentAmount=None, nl=True):

        if indentAmount == None:
            indentAmount = self.indentAmount
        else:
            self.changeIndent(indentAmount)

        if nl:
            nl = "\n"
        else:
            nl = ""

        i = 0
        indent = ""
        while i < self.indentAmount:
            i += 1
            indent = indent + "----"

        text = "{}: {}{}{}".format(datetime.now().strftime("%H:%M:%S"), indent, text, nl)
        self.TextBox.insertPlainText(text)
        self.AutoScroll()
        print(text, end='')

    def writeTextPlain(self, text="", nl=True):

        if nl:
            nl = "\n"
        else:
            nl = ""

        text = "{}{}".format(text, nl)
        self.TextBox.insertPlainText(text)
        self.AutoScroll()
        print(text, end='')

    def writeDottedText(self, text):
        self.writeText("-----{}-----".format(text))

    def stopPool(self):
        self.pool.clear()
        self.printDottedText.emit("TASK ABORTED")

    def retranslateUi(self):
        _translate = QCoreApplication.translate
        self.setWindowTitle(_translate("Dialog", "Dialog"))
        self.TextBox.setHtml(_translate("Dialog", "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n"))

class valueDialog(QDialog, RIDValueDialogUI.Ui_Dialog):
    def __init__(self, ui):
        super().__init__(ui, Qt.WindowCloseButtonHint)
        self.setupUi(self)
        self.ui = ui
        self.setupTable()
        self.setupList()

    def addTAG(self):
        print("add tag")

    def reloadTAGS(self):
        self.ui.TAGSDataContainer.overrideTAGload(self.ui.FileViewerModel.filePath(self.ui.FileViewer.currentIndex()))

    def setupTable(self):
        self.ui.TraceDataContainer.setHeaderData(0, Qt.Horizontal, 'Tag')
        self.tracesTable.setModel(self.ui.TraceDataContainer)
        self.ui.TraceDataContainer.dataChanged.connect(self.updateSelection)

        self.tracesTable.setAcceptDrops(True)
        self.tracesTable.setDragEnabled(True)
        self.tracesTable.setItemDelegateForColumn(0, TraceTagDelegate(self))

        selectionModel = self.tracesTable.selectionModel()
        selectionModel.selectionChanged.connect(self.updateTraceColoursFromSelection)
        
    def setupList(self):
        self.tagsList.setModel(self.ui.TAGSDataContainer)

    def verifyData(self, index):
        if index.column() == 0:
            if index.data(Qt.DisplayRole) == "":
                self.tracesTable.model().setData(index, QBrush(Qt.white), Qt.BackgroundRole)
                return

            if index.data(Qt.DisplayRole) in self.ui.TAGSDataContainer.tags:
                self.tracesTable.model().setData(index, QBrush(Qt.green), Qt.BackgroundRole)
            else:
                self.tracesTable.model().setData(index, QBrush(Qt.red), Qt.BackgroundRole)
        elif index.column() == 1:
            if index.data(Qt.UserRole) == None:
                self.tracesTable.model().setData(index, QBrush(Qt.white), Qt.BackgroundRole)
                return
            if isinstance(index.data(Qt.UserRole), rid.Trace):
                self.tracesTable.model().setData(index, QBrush(Qt.green), Qt.BackgroundRole)
            else:
                self.tracesTable.model().setData(index, QBrush(Qt.red), Qt.BackgroundRole)

    def updateSelection(self, topLeft, bottomRight):
        selectionModel = self.tracesTable.selectionModel()
        self.tracesTable.setCurrentIndex(topLeft)
        selectionModel.select(topLeft, selectionModel.ClearAndSelect)
        self.verifyData(topLeft)

    def getTraceColour(self, tag):
        if not tag == "":

            if tag in self.ui.TAGSDataContainer.tags:
                return ridTraceColours.validTag
            else:
                return ridTraceColours.inValidTag

        return ridTraceColours.noTag

    def updateTraceColoursFromSelection(self, selected, deselected):
        deselect = None
        if not len(deselected.indexes()) == 0:
            deselect = deselected.indexes()[0].row()

        if not len(selected.indexes()) == 0:
            self.updateTraceColour(selected.indexes()[0].row(), deselectedRow=deselect)

    def updateTraceColour(self, selectedRow, rowTagValue=None, deselectedRow=None,):
        if not (deselectedRow == None):
            Trace = self.ui.TraceDataContainer.getTrace(deselectedRow)
            tag = Trace.tag
            style = 'solid'

            for Artist in self.ui.ContourData[3][deselectedRow]:
                Artist.remove()

            self.ui.ContourData[3][deselectedRow] = (self.ui.widget.axes.plot(Trace.contour[:, 1], Trace.contour[:, 0], color=self.getTraceColour(tag), linestyle=style, linewidth=2, zorder=10))

        Trace = self.ui.TraceDataContainer.getTrace(selectedRow)
        tag = Trace.tag
        style = 'dashed'

        if not rowTagValue == None:
            tag = rowTagValue

        for Artist in self.ui.ContourData[3][selectedRow]:
            Artist.remove()

        self.ui.ContourData[3][selectedRow] = (self.ui.widget.axes.plot(Trace.contour[:, 1], Trace.contour[:, 0], color=self.getTraceColour(tag), linestyle=style, linewidth=2, zorder=10))
        self.ui.widget.draw_idle()

    def display(self):
        self.ui.closeValueDialog.connect(self.reject)
        self.ui.valueDialog.rejected.connect(self.selfReset)
        self.show()

    def selfReset(self):
        self.ui.actionValue_Diaog.setDisabled(False)