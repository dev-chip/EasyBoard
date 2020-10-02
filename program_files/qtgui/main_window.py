# -------------------------------------------------------------------------------
# Name:        main_window.py
# Purpose:     Main window example.
#
# Author:      James Cook
#
# Created:     30/09/2020
# Copyright:   (c) James Cook 2020
# -------------------------------------------------------------------------------
import os

from PyQt5.QtWidgets import QFileDialog
from PyQt5 import QtGui

from qtgui.gen import MainWindowGenerated
from qtgui.thread import thread_log
from qtgui.window import Window
from qtgui.logger import init_console_logger
from qtgui.cfg import (get_configs,
                       overwrite_config)
from qtgui.show_dialog import show_confirm_dialog

from qtgui.workers.load import LoadThread
from qtgui.workers.compile import CompileThread
from qtgui.workers.compileandload import CompileAndLoadThread

logger = init_console_logger(name="gui")

THIS_PATH = os.path.abspath(os.path.dirname(__file__))
CRAM_DIR_PATH = os.path.join(THIS_PATH, "..", "CRAM")

from core.hyperterminal import open_hyperterminal, close_hyperterminal


class MainWindow(Window):

    def __init__(self):

        logger.debug("Setting up UI")

        super(Window, self).__init__()
        self.ui = MainWindowGenerated.Ui_MainWindow()
        self.ui.setupUi(self)

        # set icon
        icon = QtGui.QIcon()
        icon.addPixmap(QtGui.QPixmap(os.path.join(THIS_PATH, "img", "icon.png")))
        self.setWindowIcon(icon)

        logger.verbose("Initialising GUI logger")
        self.init_GUI_logger(logger)

        logger.verbose("Initialising signals")
        self.init_signals()

        self.config = get_configs()
        self.t = None

        self.ui.lineEdit_c_path.setText(self.config["PATHS"]["last_c_file"])

        self.right_buttons = [
            self.ui.pushButton_select_c_path,
            self.ui.pushButton_compile,
            self.ui.pushButton_load,
            self.ui.pushButton_compile_and_load
        ]

        self.enforce_buttons_block()

        logger.info("GUI initialised")


    def init_signals(self):
        """
            Initialises widget signals
        """
        # path selection
        self.ui.pushButton_select_c_path.clicked.connect(self.choose_c_file)

        # hypervisor app buttons
        self.ui.pushButton_start_hyperterminal.clicked.connect(self.start_hyperterminal_app)
        self.ui.pushButton_close_hyperterminal.clicked.connect(self.close_hyperterminal_app)

        # open buttons
        self.ui.pushButton_open_c_file.clicked.connect(self.open_c_file_selected)
        self.ui.pushButton_open_assembly_code.clicked.connect(self.open_assembly_code)
        self.ui.pushButton_open_map.clicked.connect(self.open_map)
        self.ui.pushButton_open_c_assembly_listing.clicked.connect(self.open_assembly_listing)

        # run buttons
        self.ui.pushButton_compile.clicked.connect(self.compile)
        self.ui.pushButton_load.clicked.connect(self.load)
        self.ui.pushButton_compile_and_load.clicked.connect(self.compile_and_load)

        # menu buttons
        self.ui.actionOpen_User_Guide.triggered.connect(self.open_user_guide)

    def start_hyperterminal_app(self):
        """
            Starts a HyperTermial application.
        """
        open_hyperterminal()
        logger.info("New HyperTerminal application started")
        logger.warning("Remember to configure HyperTerminal and connect your board before loading")

    def close_hyperterminal_app(self):
        if close_hyperterminal() == 0:
            logger.info("HyperTerminal applications killed")
        else:
            logger.error("Failed to close - no HyperTerminal applications found to kill")

    def open_c_file_selected(self):
        """
            Opens the selected c file using the default allocated application.
        """
        file_path = str(self.ui.lineEdit_c_path.text())
        if os.path.isfile(file_path):
            os.startfile('"{}"'.format(file_path))
            logger.info("Opening C file selected...")
        else:
            logger.error("C file '{}' not found".format(file_path))

    def open_assembly_code(self):
        """
            Opens the compiled assembly code using the default allocated application.
        """
        file_path = os.path.abspath(os.path.join(CRAM_DIR_PATH, "outs19.txt"))
        if os.path.isfile(file_path):
            os.startfile('"{}"'.format(file_path))
            logger.info("Opening generated assembly code...")
        else:
            logger.error("Assembly code file '{}' not found".format(file_path))

    def open_assembly_listing(self):
        """
            Opens the map file using the default allocated application.
        """
        file_path = os.path.abspath(os.path.join(CRAM_DIR_PATH, "assem.txt"))
        if os.path.isfile(file_path):
            os.startfile('"{}"'.format(file_path))
            logger.info("Opening generated assembly listing...")
        else:
            logger.error("Assembly listing file '{}' not found".format(file_path))

    def open_map(self):
        """
            Opens the map file using the default allocated application.
        """
        file_path = os.path.abspath(os.path.join(CRAM_DIR_PATH, "map.txt"))
        if os.path.isfile(file_path):
            os.startfile('"{}"'.format(file_path))
            logger.info("Opening generated linker map file...")
        else:
            logger.error("Linker map file '{}' not found".format(file_path))

    def open_user_guide(self):
        """
            Opens the user guide file using the default allocated application.
        """
        file_path = os.path.abspath(os.path.join(THIS_PATH, "..", "docs", "EasyBoard User Guide.docx"))
        if os.path.isfile(file_path):
            os.startfile('"{}"'.format(file_path))
            logger.info("Opening User Guide...")
        else:
            logger.error("User Guide '{}' not found".format(file_path))

    def compile(self):
        """
            Compiles the selected C file into assembly code and generates outs19.txt file.
        """
        # check c file path is valid
        if not os.path.isfile(str(self.ui.lineEdit_c_path.text())):
            logger.error("Aborted compile - invalid C file path")
            return
        # disable main frame
        logger.debug("Locked main frame.")
        self.disable_buttons()
        # start thread
        logger.debug("Starting thread...")
        self.t = CompileThread(self.log_thread_callback, self.enable_buttons, str(self.ui.lineEdit_c_path.text()))
        self.t.start()
        logger.debug("Thread started")

    def load(self):
        # check outs19.txt exits
        if not os.path.isfile(os.path.join(CRAM_DIR_PATH, "outs19.txt")):
            logger.error("Aborted load - assembly code file (outs19.txt) missing")
            return
        # confirm with the user before continuing
        proceed = show_confirm_dialog(text='Press the RESET button on the board before continuing.\n\n'
                                           'DO NOT touch your mouse or keyboard during the load sequence.\n\n'
                                           'Confirm that HyperTerminal is open and ready.')
        if not proceed:
            logger.info("File load aborted by user.")
            return
        # disable main frame
        logger.debug("Locked main frame.")
        self.disable_buttons()
        # start thread
        logger.debug("Starting thread...")
        self.t = LoadThread(self.log_thread_callback, self.enable_buttons)
        self.t.start()
        logger.debug("Thread started")

    def compile_and_load(self):
        # check c file path is valid
        if not os.path.isfile(str(self.ui.lineEdit_c_path.text())):
            logger.error("Aborted compile - invalid C file path")
            return
        # confirm with the user before continuing
        proceed = show_confirm_dialog(text='Press the RESET button on the board before continuing.\n\n'
                                           'DO NOT touch your mouse or keyboard during the load sequence.\n\n'
                                           'Confirm that HyperTerminal is open and ready.')
        if not proceed:
            logger.info("File load aborted by user.")
            return
        # disable main frame
        logger.debug("Locked main frame.")
        self.disable_buttons()
        # start thread
        logger.debug("Starting thread...")
        self.t = CompileAndLoadThread(self.log_thread_callback, self.enable_buttons, str(self.ui.lineEdit_c_path.text()))
        self.t.start()
        logger.debug("Thread started")

    def choose_c_file(self):
        path = QFileDialog.getOpenFileName(self, "Select C file for compilation", self.config["PATHS"]["last_c_file"], "C File (*.c)")[0]
        path = path.replace("/", '\\')
        if path == "":
            logger.info("Path selection cancelled")
            return
        logger.info("C file path selected: '{}'".format(path))
        self.ui.lineEdit_c_path.setText(path)
        self.config["PATHS"]["last_c_file"] = path
        self.save_configs()
        self.enforce_buttons_block()

    def log_thread_callback(self, text, log_type=""):
        """
            Logs messages received from a thread
        """
        logger.verbose("Thread send values " + str(text) + ", " + str(log_type) + " to the MainWindow.")
        thread_log(logger, text, log_type)

    def disable_buttons(self):
        logger.debug("Disabling buttons")
        for button in self.right_buttons:
            button.setEnabled(False)
        self.enforce_buttons_block()

    def enable_buttons(self):
        logger.debug("Enabling buttons")
        for button in self.right_buttons:
            button.setEnabled(True)
        self.enforce_buttons_block()

    def save_configs(self):
        overwrite_config(self.config)

    def enforce_buttons_block(self):
        # c path
        if os.path.isfile(str(self.ui.lineEdit_c_path.text())):
            self.ui.pushButton_open_c_file.setEnabled(True)
            self.ui.pushButton_compile.setEnabled(True)
        else:
            self.ui.pushButton_open_c_file.setEnabled(False)
            self.ui.pushButton_compile.setEnabled(False)
            logger.warning("Invalid C file path")

        # outs19.txt
        if os.path.isfile(os.path.join(CRAM_DIR_PATH, "outs19.txt")):
            self.ui.pushButton_load.setEnabled(True)
            self.ui.pushButton_compile_and_load.setEnabled(True)
        else:
            self.ui.pushButton_open_c_file.setEnabled(False)
            self.ui.pushButton_compile_and_load.setEnabled(False)
            logger.warning("Assembly code file (outs19.txt) missing. Compile to generate")



if __name__ == "__main__":
    print ("No module test implemented.")