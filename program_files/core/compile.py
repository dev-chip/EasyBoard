import os
import subprocess
import io
import re
import shutil

from tools.logger import init_console_logger

THIS_PATH = os.path.abspath(os.path.dirname(__file__))
CRAM_DIR_PATH = os.path.abspath(os.path.join(THIS_PATH, "..", "CRAM"))
COMPILE_BAT_PATH = os.path.abspath(os.path.join(THIS_PATH, "compile.bat"))


def cosmic_compile(c_file_path, logger=init_console_logger(name="cosmic_compile")):
    """
        Compiles using the cosmic compiler.
    """
    # checks
    assert(os.path.isfile(c_file_path))
    assert(".c" == c_file_path[-2:])
    logger.info("Compiling...")

    # clean old header files
    logger.info("Cleaning old header files...")
    previous_h_files = [_ for _ in os.listdir(CRAM_DIR_PATH) if _[-2:] == ".h"]
    for f in previous_h_files:
        try:
            os.remove(os.path.join(CRAM_DIR_PATH, f))
        except Exception as e:
            logger.warning("Failed to clean old header files: '{}' could not be deleted: {}".format(f, e))

    # collect source header files
    with open(c_file_path, "r") as f:
        lines = f.read()
    local_includes = re.findall(r"#include\s{0,1}\".+[^\s]\"", lines)
    h_filenames = [_[8:].replace('"', '').replace(' ', '') for _ in local_includes]

    # copy source header files
    source_dir_path = os.path.join(os.path.dirname(c_file_path))
    for h_filename in h_filenames:
        src = os.path.join(source_dir_path, h_filename)
        dst = os.path.join(CRAM_DIR_PATH, h_filename)
        try:
            logger.info("Copying header file '{}' to '{}' ...".format(src, dst))
            shutil.copyfile(src, dst)
        except IOError as e:
            logger.error("Header file '{}' was not found. Compilation failed. Error message: {}".format(h_filename, e))
            logger.error("Compilation failed")
            return

    # compile
    command = r'"{}" "{}" "{}"'.format(COMPILE_BAT_PATH, CRAM_DIR_PATH, c_file_path)
    logger.debug("Executing command: {}".format(command))
    p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
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
