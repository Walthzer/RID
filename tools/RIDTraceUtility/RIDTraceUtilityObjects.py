
def TraceUtilityTools(object):
    def __init__(self, Ui):
        self.ui = Ui
        self.initToolButtons()

    def initToolButtons(self):
        self.ui.actionMark_Cresent.triggered.connect(self.MarkCresent)
        self.ui.actionLink_Markings.triggered.connect(self.LinkCresent)

    def MarkCresent(self):
        pass
    def LinkCresent(self):
        pass



