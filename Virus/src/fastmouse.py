import ctypes
import keyboard
import tkinter as tk

def change_speed(speed):
    #   1 - slow
    #   10 - standard
    #   20 - fast
    set_mouse_speed = 113   # 0x0071 for SPI_SETMOUSESPEED
    ctypes.windll.user32.SystemParametersInfoA(set_mouse_speed, 0, speed, 0)

def _start_():
    while True:
        change_speed(50)