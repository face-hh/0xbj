import ctypes
import os

def _start_():
    print(os.path.abspath("src/skibidi.jpg"))
    ctypes.windll.user32.SystemParametersInfoW(20, 0, os.path.abspath("src/skibidi.jpg") , 0)