import os
import subprocess
import io

from tools.logger import init_console_logger

THIS_PATH = os.path.abspath(os.path.dirname(__file__))
CRAM_DIR_PATH = os.path.abspath(os.path.join(THIS_PATH, "..", "CRAM"))
COMPILE_BAT_PATH = os.path.abspath(os.path.join(THIS_PATH, "compile.bat"))


def cosmic_compile(c_file_path, logger=init_console_logger(name="cosmic_compile")):
    """
        Compiles using the cosmic compiler.
    """
    assert(os.path.isfile(c_file_path))
    assert(".c" == c_file_path[-2:])
    logger.info("Compiling...")
    logger.debug("Executing command: {}".format(r'"{}" {} {}'.format(COMPILE_BAT_PATH, CRAM_DIR_PATH, c_file_path)))
    p = subprocess.Popen(r'"{}" {} {}'.format(COMPILE_BAT_PATH, CRAM_DIR_PATH, c_file_path), stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    std_reader = io.TextIOWrapper(p.stdout, encoding='utf8')
    err_reader = io.TextIOWrapper(p.stderr, encoding='utf8')

    while True:
        # read outputs
        s_out = std_reader.readline().rstrip()
        e_out = err_reader.readline().rstrip()

        # output std output text
        if s_out != '':
            logger.info(s_out)

        # error occurred
        elif e_out != '':
            # output entire error then return 1
            while e_out != '':
                logger.error(e_out)
                e_out = err_reader.readline().rstrip()
            logger.error("Compilation failed")
            return 1

        # process finished
        elif p.poll() is not None:
            logger.info("Compilation successful")
            return 0


if __name__ == "__main__":
    exit(cram_compile(os.path.abspath(os.path.join(THIS_PATH, "..", "CRAM", "blank.c"))))
