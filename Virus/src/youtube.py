import subprocess
import time
import pyautogui
import pygetwindow as gw

def open_chrome():
    subprocess.Popen(["start", "chrome", "https://youtube.com/c/FaceDevStuff?sub_confirmation=1"], shell=True)
    time.sleep(5)

    windows = gw.getWindowsWithTitle('YouTube')
    if windows:
        windows[0].activate()
    else:
        print("Chrome window not found")

def type_in_chrome(search_text):
    pyautogui.hotkey('win', 'up')

    pyautogui.hotkey('ctrl', 'l')

    pyautogui.write(search_text)
    pyautogui.press('enter')

def click_subscribe_button(image_path):
    time.sleep(2.5)
    
    button_location = pyautogui.locateCenterOnScreen(image_path)
    
    if button_location is not None:
        pyautogui.moveTo(button_location)
        pyautogui.click()
    else:
        print("Subscribe button not found on the screen.")

def _start_():
    open_chrome()
    click_subscribe_button("src/subscribe.png")
