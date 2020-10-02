# -------------------------------------------------------------------------------
# A generic worker thread example
# -------------------------------------------------------------------------------

import threading
import os

from qtgui.workers.classes import CommunicateLog, CommunicateDone
from qtgui.logger import init_signal_logger
from core.hyperterminal import load_to_hyperterminal

THIS_PATH = os.path.abspath(os.path.dirname(__file__))
ASSEMBLY_CODE_PATH = os.path.abspath(os.path.join(THIS_PATH, "..", "..", "CRAM", "outs19.txt"))


class LoadThread(threading.Thread):
    """
        Automatically loads a file through a HyperVisor window.
    """

    def __init__(self, logger_callback, unlock_main_frame):
        """
            init
        """
        threading.Thread.__init__(self)

        self.logCom = CommunicateLog()
        self.logCom.myGUI_signal.connect(logger_callback)
        self.log = init_signal_logger(self.logCom.myGUI_signal)

        self.doneCom = CommunicateDone()
        self.doneCom.myGUI_signal.connect(unlock_main_frame)
        self.done = self.doneCom.myGUI_signal

    def run(self):
        """
            Runs routine whilst communicating with GUI
        """
        try:
            load_to_hyperterminal(ASSEMBLY_CODE_PATH, logger=self.log)
        except Exception as e:
            self.log.error("Error occurred in thread: '{}'".format(e))
        self.done.emit()


if __name__ == "__main__":
    print("Module test not implemented")
