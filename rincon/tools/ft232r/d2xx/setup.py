########################################################################
### setup.py
###

import os
from distutils.core import setup, Extension
import sys

if sys.platform != "win32":
    raise RuntimeError, "You must build using Python for Win32"

setup(name="d2xx",
      version="0.1",
      author="mark hays",
      description="partial ftdi d2xx driver",
      py_modules=["d2xx", "seriald2xx", "serialfile", "spi"],
      ext_modules=[
        Extension("_d2xx",
                  ["d2xx.c"],
                  include_dirs=["."],
                  extra_link_args=["ftd2xx.lib"],
        ),
        Extension("_spi",
                  ["spi.c"],
        ),
      ])

### EOF setup.py

