import ctypes
import os

ctypes.windll.user32.SystemParametersInfoW(20, 0, os.path.abspath("skibidi.jpg") , 0)