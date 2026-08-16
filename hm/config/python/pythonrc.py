# file: $PYTHONSTARTUP
# You should make sure $PYTHON_HISTORY is set in your shell startup for
# forward and backwards compatibilit.
import sys

if (
    # This script is only necessary for 3.4<=python<3.13
    # Python history for interactive shells was introduced in python 3.4
    # https: //docs.python.org/3/whatsnew/3.4.html#sys
    # The PYTHON_HISTORY environment variable was introduced in python 3.13
    # https://github.com/python/cpython/issues/73965
    (3, 4) <= sys.version_info < (3, 13)
    # IPython and bPython have their own histfiles
    # https://github.com/ipython/ipython
    and "ipython" not in sys.modules
    # https://github.com/bpython/bpython
    and "bpython" not in sys.modules
):
    import atexit
    import os
    import readline

    PYTHON_HISTORY = "PYTHON_HISTORY"
    XDG_STATE_HOME = "XDG_STATE_HOME"
    FULLPATH = "$HOME/.local/state"
    HISTFILE = "/python_history"

    # Check PYTHON_HISTORY for future-compatibility with Python >= 3.13
    if os.getenv(PYTHON_HISTORY, None):
        # print("Found $PYTHON_HISTORY", flush=False)
        histfile = "$" + PYTHON_HISTORY
    elif os.getenv(XDG_STATE_HOME, None):
        # print("Found $XDG_STATE_HOME", flush=False)
        histfile = "$" + XDG_STATE_HOME + HISTFILE
    else:
        # print("$PYTHON_HISTORY and $XDG_STATE_HOME not found", flush=False)
        histfile = FULLPATH + HISTFILE
    histfile = os.path.expandvars(histfile)

    if not os.path.exists(histfile):
        # Create the histfile and its parent directory if it doesn't yet exist
        print("Creating python histfile: " + histfile, flush=False)
        os.makedirs(os.path.dirname(histfile), exist_ok=True)
        fd = os.open(histfile, os.O_CREAT | os.O_WRONLY | os.O_EXCL, 0o666)
        os.close(fd)
        # https://github.com/python/cpython/issues/105694
        # Breaks on macos + python3 without this
        readline.write_history_file(histfile)

    # Read the history file
    readline.read_history_file(histfile)
    # This causes the history to be written at exit of the program
    atexit.register(readline.write_history_file, histfile)

    if hasattr(sys, "__interactivehook__"):
        # This prevents the default site.py hook from running
        del sys.__interactivehook__
