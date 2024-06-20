from pynput import mouse
from playsound import playsound
import threading

def on_click(x, y, button, pressed):
    if pressed:
        threading.Thread(target=playsound, args=('src/fart-with-reverb.mp3',)).start()

def _start_():
    print("Listening for mouse clicks... Press Ctrl+C to exit.")
    listener = mouse.Listener(on_click=on_click)
    listener.start()
    listener.join()
