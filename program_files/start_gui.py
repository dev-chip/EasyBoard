#-------------------------------------------------------------------------------
# Starts the GUI interface
#-------------------------------------------------------------------------------

import sys
import os
import shutil

if sys.version_info[0] != 3:
    print("This script requires Python version 3.x")
    sys.exit(1)

try:
    from PyQt5.QtWidgets import QApplication
    from PyQt5 import QtGui
except ImportError:
    print("This script requires PyQt5. Try command 'pip install PyQt5'")
    sys.exit(1)

from qtgui.controller import Controller
from qtgui.cfg import get_configs
from qtgui.logger import set_logger_level, init_console_logger

logger = init_console_logger(name="gui")
THIS_PATH = os.path.abspath(os.path.dirname(__file__))

version_id = 2.3


def print_pretty_name():
    print (
            "    ***************************************************" + "\n"
            "                  EasyBoard - VERSION  %s          " % str(version_id) + "\n"
            "    ***************************************************"
           )


def create_config():
    shutil.copyfile(os.path.join(THIS_PATH, "qtgui", "default_configs.ini"), os.path.join(THIS_PATH, "qtgui", "configs.ini"))
    return get_configs()


if __name__ == '__main__':
    print_pretty_name()

    # set log level
    try:
        config = get_configs()
    except IOError:
        config = create_config()
    set_logger_level(int(config["COMMON"]["log_level"]), name="gui")

    # start GUI
    logger.info("Starting GUI...")

    app = QApplication(sys.argv)
    # set icon


    controller = Controller()
    controller.show_main()
    app.exec_()

    # exit
    sys.exit(0)
