from PyQt5.QtWidgets import QTableView
from PyQt5.QtCore import Qt

class TraceTableView(QTableView):
    def __init__(self, parent):
        QTableView.__init__(self, parent)

    def mousePressEvent(self, event):
        self.setDragEnabled(True)
        if event.button() == Qt.LeftButton:
            self.setDragEnabled(False)
        super().mousePressEvent(event)