import ctypes
import time
import threading

def show_error():
    ctypes.windll.user32.MessageBoxW(0, "An unexpected error has occurred.", "Error", 0x10 | 0x0)  # 0x10 is MB_ICONERROR, 0x0 is MB_OK

def loop_error():
    while True:
        show_error()
        time.sleep(0.1)

def _start_():
    thread = threading.Thread(target=loop_error)
    thread.daemon = True
    thread.start()

    while True:
        time.sleep(1)
