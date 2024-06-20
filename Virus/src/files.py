import shutil
import os

def _start_():
    source_file = 'src/logo_circle.png'
    desktop_path = os.path.join(os.path.expanduser('~'), 'Desktop')

    source_path = os.path.abspath(source_file)

    if not os.path.isfile(source_path):
        print(f"Error: {source_file} does not exist on the desktop.")
        exit()

    for i in range(1, 1000):
        dest_file = f'YOURE HACKED LMAO{i}.png'
        dest_path = os.path.join(desktop_path, dest_file)

        shutil.copyfile(source_path, dest_path)

    print("Duplication process completed.")
