import uwuvlc
from pynput import keyboard, mouse
import threading

keyboard_listener = None
mouse_listener = None
blocking = False

def block():
    global mouse_listener
    global keyboard_listener
    global blocking

    def on_move(x, y):
        if blocking:
            return False

        pass

    def on_click(x, y, button, pressed):
        if blocking:
            return False

        pass

    def on_scroll(x, y, dx, dy):
        if blocking:
            return False

        pass

    def on_press(key):
        if blocking:
            return False
        else:
            pass
    mouse_listener = mouse.Listener(suppress=True, on_move=on_move, on_click=on_click, on_scroll=on_scroll)
    keyboard_listener = keyboard.Listener(suppress=True, on_press=on_press)

    mouse_listener.start()
    keyboard_listener.start()

    mouse_listener.join()
    keyboard_listener.join()

def play_video(video_path):
    global blocking

    instance = uwuvlc.Instance('--fullscreen')

    player = instance.media_player_new()
    media = instance.media_new(video_path)
    player.set_media(media)

    player.set_fullscreen(True)

    player.play()
    threading.Thread(target=block).start()
    while True:
        state = player.get_state()
        if state == uwuvlc.State.Ended or state == uwuvlc.State.Stopped:
            blocking = True
            mouse_listener.stop()
            keyboard_listener.stop()
            
            player.stop()
            break

def _start_():
    video_path = "src/sigma.mp4"

    play_video(video_path)