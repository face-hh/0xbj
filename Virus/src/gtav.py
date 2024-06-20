import cv2
import tkinter as tk
from PIL import Image, ImageTk

width = int(1531/3)
height = int(863/3)

class VideoPlayer:
    def __init__(self, root, path):
        self.root = root
        self.root.title("Video Player")
        
        self.setup_gui()
        
        screen_width = root.winfo_screenwidth()
        start_x = (screen_width - 705) // 2  # Calculate center horizontally
        start_y = 100  # Start 200 pixels below the top
        
        # Set window position and size
        self.root.geometry(f"{width}x{height}+{start_x}+{start_y}")

        self.video_path = path
        self.cap = cv2.VideoCapture(self.video_path)
        self.width = width
        self.height = height
        
        self.paused = False
        self.update()
        
        self.root.attributes("-toolwindow", True)
        self.root.resizable(False, False)  # Disable resizing
        self.root.attributes('-topmost', True)
        self.root.protocol("WM_DELETE_WINDOW", self.on_close)
        
    def setup_gui(self):
        self.video_frame = tk.Frame(self.root)
        self.video_frame.pack()
        
        self.canvas = tk.Canvas(self.video_frame)
        self.canvas.pack()
        self.canvas.config(width=width, height=height)
        
    def update(self):
        if not self.paused:
            ret, frame = self.cap.read()
            if ret:
                frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                frame = cv2.resize(frame, dsize=(width, height))
                
                self.photo = ImageTk.PhotoImage(image=Image.fromarray(frame))
                self.canvas.create_image(0, 0, anchor=tk.NW, image=self.photo)
        self.root.after(10, self.update)
        
    def on_close(self):
        pass

def _start_():
    root = tk.Tk()
    player = VideoPlayer(root, "src/gtav.mp4")
    root.mainloop()
