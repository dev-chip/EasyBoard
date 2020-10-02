import subprocess
import time
import sys
import os

from tools.logger import init_console_logger

THIS_PATH = os.path.abspath(os.path.dirname(__file__))
HYPERTERM_PATH = os.path.abspath(os.path.join(THIS_PATH, "..", "CRAM", "hypertrm.exe"))
sys.path.insert(0, os.path.abspath(os.path.join(THIS_PATH, "..", "lib")))

import mypygetwindow as gw
import mypyautogui as pyautogui

# FAILSAFE should be off
pyautogui.FAILSAFE = False


def open_hyperterminal():
    """
        Opens a hyperterminal window.
    """
    p = subprocess.Popen(HYPERTERM_PATH)
    return 0


def close_hyperterminal():
    """
        Closes all hyperterminal windows.
    """
    p = subprocess.Popen(r'TASKKILL /F /IM hypertrm.exe', stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    output, error = p.communicate()
    if error != b'':
        return 1
    else:
        return 0


def load_to_hyperterminal(assembly_code_path, logger=init_console_logger(name="load_to_hyperterminal")):
    """
        Locates a HyperTerminal window and automates the load sequence for
        the selected assembly file.
    """
    logger.warning("DO NOT touch mouse or keyboard during load sequence")
    logger.info("Loading file in HyperTerminal...")
    # ------------------------------------------------- #
    # Check a hyperterminal window is open
    # ------------------------------------------------- #

    logger.debug("Checking a HyperTerminal window is open...")
    titles = gw.getAllTitles()
    terminal = None
    for title in titles:
        if 'HyperTerminal' in title:
            terminal = gw.getWindowsWithTitle(title)[0]
            break
        
    if not terminal:
        logger.error("Aborted sequence - HyperTerminal not open")
        return 1

    # ------------------------------------------------- #
    # Switch window focus to hyperterminal window
    # ------------------------------------------------- #

    logger.debug("Switching window focus to HyperTerminal...")
    terminal.restore()
    terminal.activate()
    time.sleep(0.5)

    # ------------------------------------------------- #
    # Enter required load commands/data
    # ------------------------------------------------- #

    logger.debug("Entering required load commands/data")
    pyautogui.typewrite('lf', interval=0.05)
    if 'HyperTerminal' in gw.getAllTitles():
        # this means an error window popped-up
        logger.error("Aborted load sequence. You are not connected to a board. Setup a connection then try again.")
        return 1

    pyautogui.press('enter')
    pyautogui.typewrite('fourty-two', interval=0.05)
    pyautogui.press('enter')
    
    # ------------------------------------------------- #
    # Enter path into dialog
    # ------------------------------------------------- #

    # open dialog
    logger.debug("Opening send text file chooser dialog...")
    pyautogui.hotkey('alt', 't')
    pyautogui.press('t')

    # Detect dialog opening
    logger.debug("Detecting send text file chooser dialog...")
    time.sleep(0.5)  # initial wait for window
    start = time.time()
    timeout = 5
    while("Send Text File" not in gw.getAllTitles() and time.time() < start+timeout):
        # wait for window to appear
        time.sleep(0.5)
    if time.time() > start+timeout:
        # timeout - window did not open
        msg = "Something went wrong... Aborted load sequence. (error - file selection window timeout)"
        logger.error(msg)
        return 1

    # enter path into file selection dialog
    logger.debug("Entering path into file selection dialog...")
    pyautogui.write(assembly_code_path)
    pyautogui.press('enter')

    # done
    logger.info("Load file sequence completed")


if __name__ == "__main__":
    print("Running test for {} ...".format(__file__))
    load_to_hyperterminal(r'C:\Users\cooki\OneDrive\Documents\workspace\uni\modules\modules\RTSCS\workspace\CRAM5\CRAM\outs19.txt')