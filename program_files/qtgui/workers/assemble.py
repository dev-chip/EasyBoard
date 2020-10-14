# -------------------------------------------------------------------------------
# A generic worker thread example
# -------------------------------------------------------------------------------

import threading

from qtgui.workers.classes import CommunicateLog, CommunicateDone
from qtgui.logger import init_signal_logger
from core.assemble import cosmic_assemble


class AssembleThread(threading.Thread):
    """
        Automatically compiles a c file.
    """

    def __init__(self, logger_callback, unlock_main_frame, assembly_file_path):
        """
            init
        """
        threading.Thread.__init__(self)

        try:
            self.assembly_file_path = assembly_file_path

            self.logCom = CommunicateLog()
            self.logCom.myGUI_signal.connect(logger_callback)
            self.log = init_signal_logger(self.logCom.myGUI_signal)

            self.doneCom = CommunicateDone()
            self.doneCom.myGUI_signal.connect(unlock_main_frame)
            self.done = self.doneCom.myGUI_signal
        except Exception as e:
            print(e)

    def run(self):
        """
            Runs routine whilst commminicating with GUI
        """
        try:
            cosmic_assemble(self.assembly_file_path, logger=self.log)
        except Exception as e:
            self.log.error("Error occurred in thread: '{}'".format(e))
        self.done.emit()


if __name__ == "__main__":
    print("Module test not implemented")
