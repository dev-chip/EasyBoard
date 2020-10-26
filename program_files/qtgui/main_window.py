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
import shutil
import subprocess

from PyQt5.QtWidgets import QFileDialog

from PyQt5 import QtGui

from qtgui.gen import MainWindowGenerated
from qtgui.thread import thread_log
from qtgui.window import Window
from qtgui.logger import init_console_logger
from qtgui.cfg import (get_configs,
                       overwrite_config)
from qtgui.show_dialog import show_confirm_dialog

from qtgui.workers.load_a import LoadAssembledThread
from qtgui.workers.load_c import LoadCompiledThread
from qtgui.workers.compile import CompileThread
from qtgui.workers.assemble import AssembleThread

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

        # set tabWidget
        self.ui.tabWidget.setCurrentIndex(0)

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
        self.ui.lineEdit_a_path.setText(self.config["PATHS"]["last_a_file"])

        self.c_buttons = [
            self.ui.pushButton_select_c_path,
            self.ui.pushButton_compile,
            self.ui.pushButton_load_c,
        ]

        self.a_buttons = [
            self.ui.pushButton_select_c_path,
            self.ui.pushButton_assemble,
            self.ui.pushButton_load_a,
        ]

        self.enforce_buttons_block()

        logger.info("GUI initialised")


    def init_signals(self):
        """
            Initialises widget signals
        """
        # path selection
        self.ui.pushButton_select_c_path.clicked.connect(self.choose_c_file)
        self.ui.pushButton_select_a_path.clicked.connect(self.choose_a_file)

        # hypervisor app buttons
        self.ui.pushButton_start_hyperterminal.clicked.connect(self.start_hyperterminal_app)
        self.ui.pushButton_close_hyperterminal.clicked.connect(self.close_hyperterminal_app)

        # open buttons
        self.ui.pushButton_open_c_file.clicked.connect(self.open_c_file_selected)
        self.ui.pushButton_open_assembly_file.clicked.connect(self.open_assembly_file_selected)
        self.ui.pushButton_open_c_moterola_s_record.clicked.connect(self.open_c_moterola_s_record)
        self.ui.pushButton_open_a_moterola_s_record.clicked.connect(self.open_a_moterola_s_record)
        self.ui.pushButton_open_map.clicked.connect(self.open_map)

        # run buttons
        self.ui.pushButton_compile.clicked.connect(self.compile)
        self.ui.pushButton_assemble.clicked.connect(self.assemble)
        self.ui.pushButton_load_c.clicked.connect(self.load_c)
        self.ui.pushButton_load_a.clicked.connect(self.load_a)

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

    def open_assembly_file_selected(self):
        """
            Opens the selected assembly file using the default allocated application.
        """
        file_path = str(self.ui.lineEdit_a_path.text())
        if os.path.isfile(file_path):
            subprocess.Popen(['notepad', '{}'.format(file_path)], shell=True)
            logger.info("Opening assembly file selected...")
        else:
            logger.error("Assembly file '{}' not found".format(file_path))

    def open_c_moterola_s_record(self):
        """
            Opens the compiled assembly code using the default allocated application.
        """
        file_path = os.path.abspath(os.path.join(CRAM_DIR_PATH, "outs19.txt"))
        if os.path.isfile(file_path):
            subprocess.Popen(['notepad', '{}'.format(file_path)], shell=True)
            logger.info("Opening Moterola S-record...")
        else:
            logger.error("Moterola S-record file '{}' not found".format(file_path))

    def open_a_moterola_s_record(self):
        """
            Opens the compiled assembly code using the default allocated application.
        """
        file_path = os.path.abspath(os.path.join(CRAM_DIR_PATH, "prog1.s19"))
        if os.path.isfile(file_path):
            subprocess.Popen(['notepad', '{}'.format(file_path)], shell=True)
            logger.info("Opening Moterola S-record...")
        else:
            logger.error("Moterola S-record file '{}' not found".format(file_path))

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
        file_path = os.path.abspath(os.path.join(THIS_PATH, "..", "docs", "EasyBoard User Guide.pdf"))
        if os.path.isfile(file_path):
            os.startfile('"{}"'.format(file_path))
            logger.info("Opening User Guide...")
        else:
            logger.error("User Guide '{}' not found".format(file_path))

    def compile(self):
        """
            Compiles the selected C file and generates outs19.txt file.
        """
        src = str(self.ui.lineEdit_c_path.text())
        # check c file path is valid
        if not os.path.isfile(src):
            logger.error("Aborted compile - invalid C file path: {}".format(src))
            return
        # disable main frame
        logger.debug("Locked main frame.")
        self.disable_buttons()
        # start thread
        logger.debug("Starting thread...")
        self.t = CompileThread(self.log_thread_callback, self.enable_buttons, src)
        self.t.start()
        logger.debug("Thread started")

    def assemble(self):
        """
            Assembles selected assembly file and generates assembly code (prog1.s19 file).
        """
        src = str(self.ui.lineEdit_a_path.text())
        # check .s07 file path is valid
        if not os.path.isfile(src):
            logger.error("Aborted assembly - invalid assembly file path: {}".format(src))
            return

        dst = os.path.abspath(os.path.join(CRAM_DIR_PATH, "prog1.s07"))

        if src != dst:  # prevents error (if file selected is in CRAM already)
            try:
                logger.debug('copying file --> src: "{}" dst: "{}" ...'.format(src, dst))
                shutil.copyfile(src, dst)
            except IOError as e:
                logger.error("Failed to process assembly code file selected '{}': error: {}".format(src, e))
                return

        # disable buttons
        self.disable_buttons()
        logger.debug("Disabled buttons")
        # start thread
        logger.debug("Starting thread...")
        self.t = AssembleThread(self.log_thread_callback, self.enable_buttons, dst)
        self.t.start()

    def load_c(self):
        # check outs19.txt exists
        if not os.path.isfile(os.path.join(CRAM_DIR_PATH, "outs19.txt")):
            logger.error("Aborted load - motorola s-record  file (outs19.txt) missing")
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
        self.t = LoadCompiledThread(self.log_thread_callback, self.enable_buttons)
        self.t.start()
        logger.debug("Thread started")

    def load_a(self):
        # check prog1.s19 exists
        if not os.path.isfile(os.path.join(CRAM_DIR_PATH, "prog1.s19")):
            logger.error("Aborted load - motorola s-record file (prog1.s19) missing")
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
        self.t = LoadAssembledThread(self.log_thread_callback, self.enable_buttons)
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

    def choose_a_file(self):
        path = QFileDialog.getOpenFileName(self, "Select assembly code file for assembly", self.config["PATHS"]["last_a_file"], "Source Code (*.s07)")[0]
        path = path.replace("/", '\\')
        if path == "":
            logger.info("Path selection cancelled")
            return
        logger.info("Assembly file path selected: '{}'".format(path))
        self.ui.lineEdit_a_path.setText(path)
        self.config["PATHS"]["last_a_file"] = path
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
        for button in self.c_buttons:
            button.setEnabled(False)
        self.enforce_buttons_block()

    def enable_buttons(self):
        logger.debug("Enabling buttons")
        for button in self.c_buttons:
            button.setEnabled(True)
        self.enforce_buttons_block()

    def save_configs(self):
        overwrite_config(self.config)

    def enforce_buttons_block(self):
        # c path check
        if os.path.isfile(str(self.ui.lineEdit_c_path.text())):
            self.ui.pushButton_open_c_file.setEnabled(True)
            self.ui.pushButton_compile.setEnabled(True)
        else:
            self.ui.pushButton_open_c_file.setEnabled(False)
            self.ui.pushButton_compile.setEnabled(False)
            logger.debug("Invalid C file path")
            self.ui.lineEdit_c_path.setText("")

        # c load -outs19.txt exists?
        if os.path.isfile(os.path.join(CRAM_DIR_PATH, "outs19.txt")):
            self.ui.pushButton_load_c.setEnabled(True)
        else:
            self.ui.pushButton_load_c.setEnabled(False)
            logger.debug("Assembly code file (outs19.txt) missing. Compile to generate")

        # a path check
        if os.path.isfile(str(self.ui.lineEdit_a_path.text())):
            self.ui.pushButton_open_assembly_file.setEnabled(True)
            self.ui.pushButton_assemble.setEnabled(True)
        else:
            self.ui.pushButton_open_assembly_file.setEnabled(False)
            self.ui.pushButton_assemble.setEnabled(False)
            logger.debug("Invalid assembly file path")
            self.ui.lineEdit_a_path.setText("")

        # a load - prog1.s19 exists?
        if os.path.isfile(os.path.join(CRAM_DIR_PATH, "prog1.s19")):
            self.ui.pushButton_load_a.setEnabled(True)
            self.ui.pushButton_open_a_moterola_s_record.setEnabled(True)
        else:
            self.ui.pushButton_load_a.setEnabled(False)
            self.ui.pushButton_open_a_moterola_s_record.setEnabled(False)
            logger.debug("Assembly code file (prog1.s19) missing. Assemble to generate")


if __name__ == "__main__":
    print ("No module test implemented.")
