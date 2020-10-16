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
    command = r'"{}" {} {}'.format(ASSEMBLE_BAT_PATH, CRAM_DIR_PATH, a_file_path.replace(".s07", ""))
    logger.debug("Executing command: {}".format(command))
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    std_reader = io.TextIOWrapper(p.stdout, encoding='utf8')
    err_reader = io.TextIOWrapper(p.stderr, encoding='utf8')

    error_occurred = False

    while True:
        # read outputs
        s_out = std_reader.readline().rstrip()
        e_out = err_reader.readline().rstrip()

        # output std output text
        if s_out != '':
            while s_out != '':
                if "****" in s_out:  # error output detected in std
                    error_occurred = True
                if error_occurred:  # sometimes errors are output through s_out
                    logger.error(s_out)
                else:
                    logger.info(s_out)
                s_out = std_reader.readline().rstrip()

        # error occurred
        elif e_out != '':
            error_occurred = True
            # output entire error then return 1
            while e_out != '':
                logger.error(e_out)
                e_out = err_reader.readline().rstrip()

        # process finished
        elif p.poll() is not None:
            if error_occurred:
                logger.error("Assembly failed")
                return 1
            logger.info("Assembly successful")
            return 0


if __name__ == "__main__":
    exit(cram_compile(os.path.abspath(os.path.join(THIS_PATH, "..", "CRAM", "blank.c"))))
