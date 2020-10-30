import os
import subprocess
import io

from tools.logger import init_console_logger

THIS_PATH = os.path.abspath(os.path.dirname(__file__))
CRAM_DIR_PATH = os.path.abspath(os.path.join(THIS_PATH, "..", "CRAM"))
ASSEMBLE_BAT_PATH = os.path.abspath(os.path.join(THIS_PATH, "assemble.bat"))


def cosmic_assemble(a_file_path, logger=init_console_logger(name="cosmic_assemble")):
    """
        Assembles using the cosmic compiler.
    """
    if not os.path.isfile(a_file_path):
        raise Exception("File for assembly not found: {}".format(a_file_path))
    if not ".s07" == a_file_path[-4:]:
        raise Exception("File for assembly has wrong extension: {}".format(a_file_path))

    logger.info("Running assembler...")
    command = r'"{}" "{}" "{}"'.format(ASSEMBLE_BAT_PATH, CRAM_DIR_PATH, a_file_path.replace(".s07", ""))
    logger.debug("Executing command: {}".format(command))
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    outs, errs = p.communicate()
    outs = outs.decode("utf-8")
    errs = errs.decode("utf-8")

    if len(errs) == 0 and "**** Error" not in outs:
        logger.info(outs)
        logger.info("Assembly successful")
    else:
        lines = outs + "\n" + errs
        logger.error(lines)
        logger.error("Assembly failed")

    if "**** Warning" in outs or "**** Warning" in errs:
        logger.warning("Code assembled with warnings")
    if "**** Error" in outs or "**** Error" in errs:
        logger.warning("Code assembled with errors")


if __name__ == "__main__":
    exit(cosmic_assemble(os.path.abspath(os.path.join(THIS_PATH, "..", "CRAM", "prog1.s07"))))
