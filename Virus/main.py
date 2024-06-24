import sys
from subprocess import Popen, PIPE, STDOUT
import os

import src.arabic
import src.bsod
import src.click
import src.edge
import src.errors
import src.familyguy
import src.fastmouse
import src.files
import src.gtav
import src.satisfying
import src.subway
import src.wallpaper
import src.youtube
import src.sigma
import src.uwuvlc

python_file = sys.argv[1]

if python_file == "verify":
    print("success")
elif python_file == "arabic":
    src.arabic._start_()
elif python_file == "sigma":
    src.sigma._start_("src/sigma.mp4")
elif python_file == "outro":
    src.sigma._start_("src/outro.mov")
elif python_file == "bsod":
    src.bsod._start_()
elif python_file == "click":
    src.click._start_()
elif python_file == "edge":
    src.edge._start_()
elif python_file == "errors":
    src.errors._start_()
elif python_file == "familyguy":
    src.familyguy._start_()
elif python_file == "fastmouse":
    src.fastmouse._start_()
elif python_file == "files":
    src.files._start_()
elif python_file == "gtav":
    src.gtav._start_()
elif python_file == "satisfying":
    src.satisfying._start_()
elif python_file == "subway":
    src.subway._start_()
elif python_file == "wallpaper":
    src.wallpaper._start_()
elif python_file == "youtube":
    src.youtube._start_()
else:
    print(f"Error: '{python_file}' is not a recognized script.")