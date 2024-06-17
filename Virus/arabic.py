import keyboard

pressed = False
english_to_arabic = {
    'a': 'ا', 'b': 'ب', 'c': 'ت', 'd': 'ث', 'e': 'ج', 'f': 'ح', 'g': 'خ',
    'h': 'د', 'i': 'ذ', 'j': 'ر', 'k': 'ز', 'l': 'س', 'm': 'ش', 'n': 'ص',
    'o': 'ض', 'p': 'ط', 'q': 'ظ', 'r': 'ع', 's': 'غ', 't': 'ف', 'u': 'ق',
    'v': 'ك', 'w': 'ل', 'x': 'م', 'y': 'ن', 'z': 'ه'
}

def on_key_event(event):
    global pressed

    if pressed:
        pressed = False
        return

    if event.name in english_to_arabic:
        arabic_char = english_to_arabic.get(event.name)
        pressed = True
        keyboard.write(arabic_char, delay=0)
    else:
        pressed = True
        keyboard.press(event.name)
        keyboard.release(event.name)

def punishment_arabic():
    keyboard.hook(on_key_event, suppress=True)
    #keyboard.wait('esc')
punishment_arabic()
keyboard.wait('esc')